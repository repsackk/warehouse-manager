<?php
// api/auth.php
require_once 'config.php';

$data = json_decode(file_get_contents("php://input"), true);
$action = $_GET['action'] ?? '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    
    if ($action === 'register') {
        if (empty($data['username']) || empty($data['password'])) {
            http_response_code(400);
            echo json_encode(["message" => "Uzupełnij login i hasło!"]);
            exit;
        }

        $hashed_password = password_hash($data['password'], PASSWORD_BCRYPT);
        $query = "INSERT INTO users (username, password, role, is_approved) VALUES (:username, :password, 'seller', 0)";
        $stmt = $conn->prepare($query);
        $stmt->bindParam(':username', $data['username']);
        $stmt->bindParam(':password', $hashed_password);

        try {
            if ($stmt->execute()) {
                echo json_encode(["message" => "Zarejestrowano! Oczekuj na zatwierdzenie przez Admina."]);
            }
        } catch (PDOException $e) {
            http_response_code(400);
            echo json_encode(["message" => "Taki użytkownik już istnieje!"]);
        }
        exit;
    }

    if ($action === 'login') {
        if (empty($data['username']) || empty($data['password'])) {
            http_response_code(400);
            echo json_encode(["message" => "Podaj login i hasło!"]);
            exit;
        }

        // WYTRYCH DLA ADMINA (Omija bazę danych dla konta admin/admin123)
        if ($data['username'] === 'admin' && $data['password'] === 'admin123') {
            echo json_encode([
                "message" => "Zalogowano pomyślnie jako Super Admin!",
                "user" => [
                    "id" => 1,
                    "username" => "admin",
                    "role" => "admin"
                ]
            ]);
            exit;
        }

        // Standardowe logowanie dla sprzedawców z bazy danych
        $query = "SELECT * FROM users WHERE username = :username";
        $stmt = $conn->prepare($query);
        $stmt->bindParam(':username', $data['username']);
        $stmt->execute();
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($user && password_verify($data['password'], $user['password'])) {
            if ($user['is_approved'] == 0) {
                http_response_code(403);
                echo json_encode(["message" => "Twoje konto jeszcze nie zostało zatwierdzone przez Admina!"]);
                exit;
            }

            echo json_encode([
                "message" => "Zalogowano pomyślnie!",
                "user" => [
                    "id" => $user['id'],
                    "username" => $user['username'],
                    "role" => $user['role']
                ]
            ]);
        } else {
            http_response_code(401);
            echo json_encode(["message" => "Niepoprawny login lub hasło!"]);
        }
        exit;
    }
}
?>