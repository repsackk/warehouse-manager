<?php
// api/admin.php
require_once 'config.php';

$method = $_SERVER['REQUEST_METHOD'];
$data = json_decode(file_get_contents("php://input"), true);

if ($method === 'GET') {
    // Pobierz listę niezaakceptowanych sprzedawców
    $query = "SELECT id, username, role, is_approved FROM users WHERE is_approved = 0";
    $stmt = $conn->prepare($query);
    $stmt->execute();
    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
}

if ($method === 'POST') {
    // Akceptacja sprzedawcy
    if (empty($data['user_id'])) {
        http_response_code(400);
        echo json_encode(["message" => "Brak ID użytkownika."]);
        exit;
    }

    $query = "UPDATE users SET is_approved = 1 WHERE id = :id";
    $stmt = $conn->prepare($query);
    $stmt->bindParam(':id', $data['user_id']);
    
    if ($stmt->execute()) {
        echo json_encode(["message" => "Sprzedawca został zatwierdzony!"]);
    } else {
        http_response_code(500);
        echo json_encode(["message" => "Błąd zatwierdzania."]);
    }
}
?>