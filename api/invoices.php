<?php
// api/invoices.php
require_once 'config.php';

// Ustawienie nagłówków dla formatu JSON oraz CORS
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Obsługa zapytania przedwstępnego OPTIONS (CORS)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

$method = $_SERVER['REQUEST_METHOD'];

if ($method === 'POST') {
    // Pobranie danych przesłanych przez app.js
    $data = json_decode(file_get_contents("php://input"), true);

    // Walidacja czy podstawowe dane nie są puste
    if (empty($data['client_name']) || empty($data['items']) || empty($data['seller_id'])) {
        http_response_code(400);
        echo json_encode([
            "success" => false, 
            "message" => "Brak wymaganych danych faktury! Upewnij się, że koszyk nie jest pusty i podano nazwę klienta."
        ]);
        exit;
    }

    try {
        // Rozpoczynamy transakcję – albo wszystko się zapisze, albo nic
        $conn->beginTransaction();

        // Budujemy pełny, profesjonalny adres kupującego z przesłanych pól składowych
        $street = !empty($data['client_street']) ? $data['client_street'] : '';
        $home_number = !empty($data['client_home_number']) ? $data['client_home_number'] : '';
        $postcode = !empty($data['client_postcode']) ? $data['client_postcode'] : '';
        $city = !empty($data['client_city']) ? $data['client_city'] : '';

        // Składamy pełny adres w jedną czytelną całość dla bazy danych
        $fullAddress = "";
        if ($street) {
            $fullAddress .= " ul. " . $street . " " . $home_number;
        }
        if ($postcode || $city) {
            $fullAddress .= ($fullAddress ? ", " : "") . $postcode . " " . $city;
        }

        // Łączymy nazwę klienta z pełnym adresem do bezpiecznego zapisu w bazie
        $clientFullInfo = $data['client_name'];
        if (!empty($fullAddress)) {
            $clientFullInfo .= " (" . $fullAddress . ")";
        }

        // 1. Wstawienie nagłówka faktury do tabeli `invoices`
        $queryInvoice = "INSERT INTO invoices (client_name, client_nip, seller_id) VALUES (:client_name, :client_nip, :seller_id)";
        $stmtInvoice = $conn->prepare($queryInvoice);
        $stmtInvoice->bindParam(':client_name', $clientFullInfo);
        $stmtInvoice->bindParam(':client_nip', $data['client_nip']);
        $stmtInvoice->bindParam(':seller_id', $data['seller_id']);
        $stmtInvoice->execute();

        // Pobieramy ID wygenerowanej faktury
        $invoiceId = $conn->lastInsertId();
        
        // Generujemy ładny numer faktury na podstawie jej ID (np. FV/2026/06/0001)
        $invoiceNumber = "FV/" . date("Y/m/") . sprintf("%04d", $invoiceId);

        // Przygotowanie zapytań dla pozycji faktury oraz aktualizacji magazynu
        $queryItem = "INSERT INTO invoice_items (invoice_id, product_id, name, quantity, price) VALUES (:invoice_id, :product_id, :name, :quantity, :price)";
        $stmtItem = $conn->prepare($queryItem);

        $queryUpdateStock = "UPDATE products SET stock = stock - :quantity WHERE id = :product_id";
        $stmtUpdateStock = $conn->prepare($queryUpdateStock);

        // 2. Pętla przetwarzająca produkty z koszyka
        foreach ($data['items'] as $item) {
            // Sprawdzenie czy pozycja ma komplet danych
            if (empty($item['product_id']) || empty($item['name']) || empty($item['quantity']) || !isset($item['price'])) {
                throw new Exception("Niekompletne dane jednej z pozycji w koszyku.");
            }

            // Dodatkowe zabezpieczenie: sprawdzenie stanu magazynowego bezpośrednio w bazie
            $queryCheck = "SELECT stock, name FROM products WHERE id = :product_id";
            $stmtCheck = $conn->prepare($queryCheck);
            $stmtCheck->bindParam(':product_id', $item['product_id']);
            $stmtCheck->execute();
            $productDB = $stmtCheck->fetch(PDO::FETCH_ASSOC);

            if (!$productDB) {
                throw new Exception("Produkt o ID " . $item['product_id'] . " nie istnieje w bazie danych.");
            }

            if ($productDB['stock'] < $item['quantity']) {
                throw new Exception("Niewystarczający stan magazynowy w bazie dla: " . $productDB['name']);
            }

            // Zapis pozycji faktury (w tym kluczowa kolumna 'name' z Twojej bazy)
            $stmtItem->bindParam(':invoice_id', $invoiceId);
            $stmtItem->bindParam(':product_id', $item['product_id']);
            $stmtItem->bindParam(':name', $item['name']);
            $stmtItem->bindParam(':quantity', $item['quantity']);
            $stmtItem->bindParam(':price', $item['price']);
            $stmtItem->execute();

            // Odjęcie sztuk ze stanu magazynowego produktu
            $stmtUpdateStock->bindParam(':quantity', $item['quantity']);
            $stmtUpdateStock->bindParam(':product_id', $item['product_id']);
            $stmtUpdateStock->execute();
        }

        // Wszystko przebiegło pomyślnie – zatwierdzamy zmiany w bazie
        $conn->commit();

        // Zwracamy idealną strukturę JSON, przekazując rozbite pola bezpośrednio do pliku wydruku
        echo json_encode([
            "success" => true,
            "invoice_number" => $invoiceNumber,
            "client_name" => $data['client_name'],
            "client_street" => $street,
            "client_home_number" => $home_number,
            "client_postcode" => $postcode,
            "client_city" => $city,
            "client_nip" => $data['client_nip'],
            "items" => $data['items'],
            "message" => "Faktura została wystawiona pomyślnie!"
        ]);

    } catch (Exception $e) {
        // W razie jakiegokolwiek błędu cofamy wszystkie zmiany w bazie
        $conn->rollBack();
        http_response_code(500);
        echo json_encode([
            "success" => false,
            "message" => "Błąd podczas wystawiania faktury: " . $e->getMessage()
        ]);
    }
    exit;

} else if ($method === 'GET') {
    // Opcjonalnie: pobieranie historii faktur (przydatne, jeśli będziesz chciał zrobić listę)
    try {
        $query = "SELECT i.*, u.username as seller_name FROM invoices i LEFT JOIN users u ON i.seller_id = u.id ORDER BY i.created_at DESC";
        $stmt = $conn->prepare($query);
        $stmt->execute();
        $invoices = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($invoices);
    } catch (PDOException $e) {
        http_response_code(500);
        echo json_encode(["success" => false, "message" => "Błąd pobierania danych: " . $e->getMessage()]);
    }
    exit;
} else {
    http_response_code(405);
    echo json_encode(["success" => false, "message" => "Metoda niedozwolona."]);
    exit;
}
?>