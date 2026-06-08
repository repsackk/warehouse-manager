<?php
// api/invoices.php
require_once 'config.php';

$method = $_SERVER['REQUEST_METHOD'];
$data = json_decode(file_get_contents("php://input"), true);

if ($method === 'POST') {
    // Wystawianie faktury
    if (empty($data['client_name']) || empty($data['seller_id']) || empty($data['items'])) {
        http_response_code(400);
        echo json_encode(["message" => "Brak kompletnych danych faktury!"]);
        exit;
    }

    $conn->beginTransaction(); // Bezpieczna transakcja DB

    try {
        // Generowanie numeru faktury (np. FV/2026/06/08/losowy_id)
        $invoice_number = "FV/" . date("Y/m/d/") . rand(100, 999);

        // 1. Wstawienie nagłówka faktury
        $query = "INSERT INTO invoices (invoice_number, client_name, client_nip, seller_id) VALUES (:num, :client, :nip, :seller)";
        $stmt = $conn->prepare($query);
        $stmt->bindParam(':num', $invoice_number);
        $stmt->bindParam(':client', $data['client_name']);
        $stmt->bindParam(':nip', $data['client_nip']);
        $stmt->bindParam(':seller', $data['seller_id']);
        $stmt->execute();
        $invoice_id = $conn->lastInsertId();

        // 2. Przetwarzanie pozycji faktury
        foreach ($data['items'] as $item) {
            $product_id = $item['product_id'];
            $qty = $item['quantity'];

            // Sprawdzenie dostępności towaru na magazynie
            $p_query = "SELECT stock, price FROM products WHERE id = :pid";
            $p_stmt = $conn->prepare($p_query);
            $p_stmt->bindParam(':pid', $product_id);
            $p_stmt->execute();
            $product = $p_stmt->fetch(PDO::FETCH_ASSOC);

            if (!$product || $product['stock'] < $qty) {
                throw new Exception("Brak wystarczającej ilości towaru na magazynie dla produktu ID: " . $product_id);
            }

            // Zapisanie pozycji faktury
            $item_query = "INSERT INTO invoice_items (invoice_id, product_id, quantity, price_at_sale) VALUES (:inv_id, :pid, :qty, :price)";
            $i_stmt = $conn->prepare($item_query);
            $i_stmt->bindParam(':inv_id', $invoice_id);
            $i_stmt->bindParam(':pid', $product_id);
            $i_stmt->bindParam(':qty', $qty);
            $i_stmt->bindParam(':price', $product['price']);
            $i_stmt->execute();

            // Odjęcie towaru ze stanu magazynowego!
            $update_query = "UPDATE products SET stock = stock - :qty WHERE id = :pid";
            $u_stmt = $conn->prepare($update_query);
            $u_stmt->bindParam(':qty', $qty);
            $u_stmt->bindParam(':pid', $product_id);
            $u_stmt->execute();
        }

        $conn->commit();
        echo json_encode(["message" => "Faktura " . $invoice_number . " wystawiona pomyślnie!"]);

    } catch (Exception $e) {
        $conn->rollBack();
        http_response_code(400);
        echo json_encode(["message" => $e->getMessage()]);
    }
}
?>