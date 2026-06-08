<?php
// api/products.php
require_once 'config.php';

$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'GET':
        $query = "SELECT * FROM products ORDER BY created_at DESC";
        $stmt = $conn->prepare($query);
        $stmt->execute();
        
        $products = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($products);
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);

        if (empty($data['name']) || empty($data['sku']) || !isset($data['price']) || !isset($data['stock']) || empty($data['category'])) {
            http_response_code(400);
            echo json_encode(["message" => "Wszystkie pola są wymagane!"]);
            break;
        }

        $query = "INSERT INTO products (name, sku, price, stock, category) VALUES (:name, :sku, :price, :stock, :category)";
        $stmt = $conn->prepare($query);

        $stmt->bindParam(":name", $data['name']);
        $stmt->bindParam(":sku", $data['sku']);
        $stmt->bindParam(":price", $data['price']);
        $stmt->bindParam(":stock", $data['stock']);
        $stmt->bindParam(":category", $data['category']);

        try {
            if ($stmt->execute()) {
                http_response_code(201);
                echo json_encode(["message" => "Produkt został dodany."]);
            }
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode(["message" => "Błąd: Kod SKU musi być unikalny!"]);
        }
        break;

    case 'DELETE':
        $data = json_decode(file_get_contents("php://input"), true);

        if (empty($data['id'])) {
            http_response_code(400);
            echo json_encode(["message" => "Brak ID produktu do usunięcia!"]);
            break;
        }

        $query = "DELETE FROM products WHERE id = :id";
        $stmt = $conn->prepare($query);
        $stmt->bindParam(":id", $data['id']);

        if ($stmt->execute()) {
            echo json_encode(["message" => "Produkt został usunięty."]);
        } else {
            http_response_code(500);
            echo json_encode(["message" => "Nie udało się usunąć produktu."]);
        }
        break;
    case 'PUT':
        // EDYCJA PRODUKTU PRZEZ ADMINA
        $data = json_decode(file_get_contents("php://input"), true);

        if (empty($data['id']) || empty($data['name']) || empty($data['sku']) || !isset($data['price']) || !isset($data['stock']) || empty($data['category'])) {
            http_response_code(400);
            echo json_encode(["message" => "Wszystkie pola są wymagane do edycji!"]);
            break;
        }

        $query = "UPDATE products SET name = :name, sku = :sku, price = :price, stock = :stock, category = :category WHERE id = :id";
        $stmt = $conn->prepare($query);

        $stmt->bindParam(":id", $data['id']);
        $stmt->bindParam(":name", $data['name']);
        $stmt->bindParam(":sku", $data['sku']);
        $stmt->bindParam(":price", $data['price']);
        $stmt->bindParam(":stock", $data['stock']);
        $stmt->bindParam(":category", $data['category']);

        if ($stmt->execute()) {
            echo json_encode(["message" => "Produkt został zaktualizowany przez Administratora."]);
        } else {
            http_response_code(500);
            echo json_encode(["message" => "Nie udało się zaktualizować produktu."]);
        }
        break;
    default:
        http_response_code(405);
        echo json_encode(["message" => "Metoda niedozwolona."]);
        break;
}
?>