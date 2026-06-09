-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Czas generowania: 09 Cze 2026, 17:54
-- Wersja serwera: 10.4.27-MariaDB
-- Wersja PHP: 8.1.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `warehouse_db`
--

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `invoices`
--

CREATE TABLE `invoices` (
  `id` int(11) NOT NULL,
  `client_name` varchar(255) NOT NULL,
  `client_nip` varchar(20) DEFAULT NULL,
  `client_address` text DEFAULT NULL,
  `seller_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Zrzut danych tabeli `invoices`
--

INSERT INTO `invoices` (`id`, `client_name`, `client_nip`, `client_address`, `seller_id`, `created_at`) VALUES
(1, 'dupcus', '213721372137', NULL, 2, '2026-06-09 10:13:58'),
(2, 'dupcus', '213721372137', NULL, 2, '2026-06-09 10:18:46'),
(3, 'dupcus', '213721372137', NULL, 2, '2026-06-09 10:39:42'),
(5, 'dupcus', '213721372137', NULL, 2, '2026-06-09 10:44:19'),
(6, 'dupcus ( ul. Trute 20, 34-404 Klikuszowa)', '213721372137', NULL, 2, '2026-06-09 10:50:01'),
(7, 'dupcus ( ul. Trute 20, 34-404 Klikuszowa)', '213721372137', NULL, 2, '2026-06-09 10:51:06'),
(8, 'dupcus ( ul. Trute 20, 34-404 Klikuszowa)', '213721372137', NULL, 2, '2026-06-09 10:54:28'),
(9, 'dupcus', '213721372137', NULL, 2, '2026-06-09 11:01:06'),
(10, 'dupcus', '213721372137', NULL, 2, '2026-06-09 11:04:43'),
(11, 'dupcus ( ul. Trute 20, 34-404 Klikuszowa)', '213721372137', NULL, 2, '2026-06-09 11:06:33'),
(12, 'dupcus ( ul. Trute 20, 34-404 Klikuszowa)', '213721372137', NULL, 1, '2026-06-09 11:07:56');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `invoice_items`
--

CREATE TABLE `invoice_items` (
  `id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Zrzut danych tabeli `invoice_items`
--

INSERT INTO `invoice_items` (`id`, `invoice_id`, `product_id`, `name`, `quantity`, `price`) VALUES
(1, 1, 1, 'Laptop Testowy', 1, '2999.00'),
(2, 2, 1, 'Laptop Testowy', 1, '2999.00'),
(3, 3, 1, 'Laptop Testowy', 1, '2999.00'),
(4, 5, 1, 'Laptop Testowy', 1, '2999.00'),
(5, 6, 1, 'Laptop Testowy', 1, '2999.00'),
(6, 7, 2, 'Kabel HDMI', 5, '29.99'),
(7, 8, 1, 'Laptop Testowy', 1, '2999.00'),
(8, 9, 3, 'Tv Samsun 52cal', 3, '5200.00'),
(9, 10, 3, 'Tv Samsun 52cal', 3, '5200.00'),
(10, 11, 3, 'Tv Samsun 52cal', 5, '5200.00'),
(11, 12, 1, 'Laptop Testowy', 4, '2999.00');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `sku` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `category` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Zrzut danych tabeli `products`
--

INSERT INTO `products` (`id`, `name`, `sku`, `price`, `stock`, `category`, `created_at`) VALUES
(1, 'Laptop Testowy', 'LAP-001', '2999.00', 0, 'Elektronika', '2026-06-08 16:23:04'),
(2, 'Kabel HDMI', 'KAB-002', '29.99', 95, 'Akcesoria', '2026-06-08 16:23:04'),
(3, 'Tv Samsun 52cal', 'TV0-003', '5200.00', 89, 'elektronika', '2026-06-09 11:00:25'),
(4, 'Laptop Dell Inspiron', 'LAP-101', '3500.00', 15, 'Elektronika', '2026-06-09 15:52:00'),
(5, 'Mysz bezprzewodowa Logitech', 'ACC-102', '120.00', 50, 'Akcesoria', '2026-06-09 15:52:00'),
(6, 'Klawiatura mechaniczna', 'ACC-103', '250.00', 30, 'Akcesoria', '2026-06-09 15:52:00'),
(7, 'Monitor Dell 24\"', 'MON-104', '800.00', 20, 'Elektronika', '2026-06-09 15:52:00'),
(8, 'Dysk SSD 500GB', 'HWR-105', '300.00', 40, 'Hardware', '2026-06-09 15:52:00'),
(9, 'Kabel USB-C', 'ACC-106', '45.00', 100, 'Akcesoria', '2026-06-09 15:52:00'),
(10, 'Słuchawki nauszne', 'AUD-107', '450.00', 25, 'Audio', '2026-06-09 15:52:00'),
(11, 'Głośnik Bluetooth', 'AUD-108', '200.00', 35, 'Audio', '2026-06-09 15:52:00'),
(12, 'Ładowarka sieciowa', 'ACC-109', '80.00', 60, 'Akcesoria', '2026-06-09 15:52:00'),
(13, 'Podkładka pod mysz', 'ACC-110', '30.00', 80, 'Akcesoria', '2026-06-09 15:52:00'),
(14, 'Drukarka laserowa', 'OFF-111', '700.00', 10, 'Biuro', '2026-06-09 15:52:00'),
(15, 'Papier ksero A4', 'OFF-112', '20.00', 200, 'Biuro', '2026-06-09 15:52:00'),
(16, 'Zestaw długopisów', 'OFF-113', '15.00', 150, 'Biuro', '2026-06-09 15:52:00'),
(17, 'Karta graficzna RTX 3060', 'HWR-114', '1600.00', 5, 'Hardware', '2026-06-09 15:52:00'),
(18, 'Procesor Intel i5', 'HWR-115', '900.00', 12, 'Hardware', '2026-06-09 15:52:00'),
(19, 'Pamięć RAM 16GB', 'HWR-116', '250.00', 45, 'Hardware', '2026-06-09 15:52:00'),
(20, 'Zasilacz 600W', 'HWR-117', '350.00', 20, 'Hardware', '2026-06-09 15:52:00'),
(21, 'Obudowa PC', 'HWR-118', '400.00', 8, 'Hardware', '2026-06-09 15:52:00'),
(22, 'Kamera internetowa', 'ACC-119', '250.00', 25, 'Akcesoria', '2026-06-09 15:52:00'),
(23, 'Router Wi-Fi 6', 'NET-120', '500.00', 15, 'Sieci', '2026-06-09 15:52:00'),
(24, 'Switch 8 portów', 'NET-121', '150.00', 20, 'Sieci', '2026-06-09 15:52:00'),
(25, 'Kabel Ethernet 5m', 'NET-122', '25.00', 70, 'Sieci', '2026-06-09 15:52:00'),
(26, 'Tablet graficzny', 'ACC-123', '600.00', 10, 'Akcesoria', '2026-06-09 15:52:00'),
(27, 'Mikrofon pojemnościowy', 'AUD-124', '350.00', 15, 'Audio', '2026-06-09 15:52:00'),
(28, 'Stojak na słuchawki', 'ACC-125', '70.00', 40, 'Akcesoria', '2026-06-09 15:52:00'),
(29, 'Fotel biurowy', 'FUR-126', '900.00', 5, 'Meble', '2026-06-09 15:52:00'),
(30, 'Biurko komputerowe', 'FUR-127', '500.00', 4, 'Meble', '2026-06-09 15:52:00'),
(31, 'Lampa biurkowa LED', 'FUR-128', '100.00', 30, 'Meble', '2026-06-09 15:52:00'),
(32, 'Kabel HDMI 2m', 'ACC-129', '30.00', 120, 'Akcesoria', '2026-06-09 15:52:00'),
(33, 'Przejściówka DisplayPort', 'ACC-130', '40.00', 50, 'Akcesoria', '2026-06-09 15:52:00'),
(34, 'Pendrive 64GB', 'STOR-131', '60.00', 100, 'Storage', '2026-06-09 15:52:00'),
(35, 'Dysk zewnętrzny 1TB', 'STOR-132', '350.00', 25, 'Storage', '2026-06-09 15:52:00'),
(36, 'Czytnik kart pamięci', 'STOR-133', '50.00', 40, 'Storage', '2026-06-09 15:52:00'),
(37, 'Bateria alkaliczna AAA', 'POW-134', '5.00', 500, 'Zasilanie', '2026-06-09 15:52:00'),
(38, 'Listwa zasilająca', 'POW-135', '60.00', 40, 'Zasilanie', '2026-06-09 15:52:00'),
(39, 'UPS 1000VA', 'POW-136', '800.00', 3, 'Zasilanie', '2026-06-09 15:52:00'),
(40, 'Etui na laptopa', 'ACC-137', '120.00', 30, 'Akcesoria', '2026-06-09 15:52:00'),
(41, 'Torba na laptopa', 'ACC-138', '180.00', 20, 'Akcesoria', '2026-06-09 15:52:00'),
(42, 'Czyścik do ekranów', 'ACC-139', '25.00', 100, 'Akcesoria', '2026-06-09 15:52:00'),
(43, 'Sprężone powietrze', 'ACC-140', '20.00', 150, 'Akcesoria', '2026-06-09 15:52:00'),
(44, 'Karta dźwiękowa', 'AUD-141', '200.00', 10, 'Audio', '2026-06-09 15:52:00'),
(45, 'Kabel audio jack', 'AUD-142', '20.00', 80, 'Audio', '2026-06-09 15:52:00'),
(46, 'Klawiatura bezprzewodowa', 'ACC-143', '150.00', 35, 'Akcesoria', '2026-06-09 15:52:00'),
(47, 'Mysz gamingowa', 'ACC-144', '300.00', 25, 'Akcesoria', '2026-06-09 15:52:00'),
(48, 'Monitor 27\" 144Hz', 'MON-145', '1300.00', 8, 'Elektronika', '2026-06-09 15:52:00'),
(49, 'Uchwyt do monitora', 'FUR-146', '150.00', 15, 'Meble', '2026-06-09 15:52:00'),
(50, 'Płyta główna Z690', 'HWR-147', '1100.00', 6, 'Hardware', '2026-06-09 15:52:00'),
(51, 'Chłodzenie procesora', 'HWR-148', '250.00', 20, 'Hardware', '2026-06-09 15:52:00'),
(52, 'Pasta termoprzewodząca', 'HWR-149', '30.00', 60, 'Hardware', '2026-06-09 15:52:00'),
(53, 'Wentylator 120mm', 'HWR-150', '40.00', 100, 'Hardware', '2026-06-09 15:52:00'),
(54, 'Zestaw wkrętaków precyzyjnych', 'TOOL-151', '80.00', 50, 'Narzędzia', '2026-06-09 15:52:00'),
(55, 'Opaski zaciskowe 100szt', 'TOOL-152', '10.00', 200, 'Narzędzia', '2026-06-09 15:52:00'),
(56, 'Tester kabli RJ45', 'TOOL-153', '70.00', 10, 'Narzędzia', '2026-06-09 15:52:00'),
(57, 'Zaciskarka do kabli', 'TOOL-154', '120.00', 10, 'Narzędzia', '2026-06-09 15:52:00'),
(58, 'Hub USB 3.0', 'ACC-155', '90.00', 40, 'Akcesoria', '2026-06-09 15:52:00'),
(59, 'Czytnik kodów kreskowych', 'OFF-156', '250.00', 5, 'Biuro', '2026-06-09 15:52:00'),
(60, 'Drukarka etykiet', 'OFF-157', '400.00', 5, 'Biuro', '2026-06-09 15:52:00'),
(61, 'Papier do etykiet', 'OFF-158', '50.00', 30, 'Biuro', '2026-06-09 15:52:00'),
(62, 'Smartwatch', 'WEAR-159', '900.00', 12, 'Elektronika', '2026-06-09 15:52:00'),
(63, 'Opaska sportowa', 'WEAR-160', '200.00', 30, 'Elektronika', '2026-06-09 15:52:00'),
(64, 'Ładowarka indukcyjna', 'ACC-161', '100.00', 40, 'Akcesoria', '2026-06-09 15:52:00'),
(65, 'Powerbank 10000mAh', 'POW-162', '150.00', 50, 'Zasilanie', '2026-06-09 15:52:00'),
(66, 'Kabel Lightning', 'ACC-163', '60.00', 70, 'Akcesoria', '2026-06-09 15:52:00'),
(67, 'Etui do smartfona', 'ACC-164', '40.00', 100, 'Akcesoria', '2026-06-09 15:52:00'),
(68, 'Szkło hartowane', 'ACC-165', '30.00', 150, 'Akcesoria', '2026-06-09 15:52:00'),
(69, 'Karta pamięci 128GB', 'STOR-166', '80.00', 80, 'Storage', '2026-06-09 15:52:00'),
(70, 'Adapter USB-C na HDMI', 'ACC-167', '70.00', 50, 'Akcesoria', '2026-06-09 15:52:00'),
(71, 'Klawiatura numeryczna', 'ACC-168', '50.00', 30, 'Akcesoria', '2026-06-09 15:52:00'),
(72, 'Stacja dokująca', 'ACC-169', '500.00', 10, 'Akcesoria', '2026-06-09 15:52:00'),
(73, 'Słuchawki douszne TWS', 'AUD-170', '300.00', 40, 'Audio', '2026-06-09 15:52:00'),
(74, 'Głośnik przenośny', 'AUD-171', '150.00', 30, 'Audio', '2026-06-09 15:52:00'),
(75, 'Mikrofon biurkowy', 'AUD-172', '100.00', 20, 'Audio', '2026-06-09 15:52:00'),
(76, 'Kamerka sportowa', 'ELE-173', '700.00', 8, 'Elektronika', '2026-06-09 15:52:00'),
(77, 'Statyw do kamerki', 'ACC-174', '80.00', 25, 'Akcesoria', '2026-06-09 15:52:00'),
(78, 'Dysk HDD 2TB', 'STOR-175', '300.00', 20, 'Storage', '2026-06-09 15:52:00'),
(79, 'Obudowa na dysk', 'STOR-176', '60.00', 40, 'Storage', '2026-06-09 15:52:00'),
(80, 'Wentylator USB', 'ACC-177', '30.00', 60, 'Akcesoria', '2026-06-09 15:52:00'),
(81, 'Podkładka chłodząca', 'ACC-178', '120.00', 20, 'Akcesoria', '2026-06-09 15:52:00'),
(82, 'Kabel DisplayPort 3m', 'ACC-179', '45.00', 40, 'Akcesoria', '2026-06-09 15:52:00'),
(83, 'Rozdzielacz HDMI', 'ACC-180', '50.00', 30, 'Akcesoria', '2026-06-09 15:52:00'),
(84, 'Pamięć RAM 8GB', 'HWR-181', '130.00', 60, 'Hardware', '2026-06-09 15:52:00'),
(85, 'Pasta srebrna', 'HWR-182', '50.00', 40, 'Hardware', '2026-06-09 15:52:00'),
(86, 'Zasilacz 500W', 'HWR-183', '250.00', 30, 'Hardware', '2026-06-09 15:52:00'),
(87, 'Dysk NVMe 1TB', 'HWR-184', '450.00', 25, 'Hardware', '2026-06-09 15:52:00'),
(88, 'Karta Wi-Fi PCIe', 'NET-185', '120.00', 20, 'Sieci', '2026-06-09 15:52:00'),
(89, 'Adapter Bluetooth', 'NET-186', '40.00', 50, 'Sieci', '2026-06-09 15:52:00'),
(90, 'Kabel telefoniczny', 'NET-187', '15.00', 100, 'Sieci', '2026-06-09 15:52:00'),
(91, 'Organizer na kable', 'ACC-188', '20.00', 80, 'Akcesoria', '2026-06-09 15:52:00'),
(92, 'Uchwyt na telefon', 'ACC-189', '30.00', 60, 'Akcesoria', '2026-06-09 15:52:00'),
(93, 'Lampka pierścieniowa', 'OFF-190', '150.00', 15, 'Biuro', '2026-06-09 15:52:00'),
(94, 'Green screen', 'OFF-191', '250.00', 5, 'Biuro', '2026-06-09 15:52:00'),
(95, 'Zestaw do czyszczenia optyki', 'TOOL-192', '40.00', 40, 'Narzędzia', '2026-06-09 15:52:00'),
(96, 'Śrubokręt magnetyczny', 'TOOL-193', '25.00', 60, 'Narzędzia', '2026-06-09 15:52:00'),
(97, 'Torba transportowa', 'ACC-194', '100.00', 20, 'Akcesoria', '2026-06-09 15:52:00'),
(98, 'Zasilacz laptopowy uniwersalny', 'POW-195', '150.00', 15, 'Zasilanie', '2026-06-09 15:52:00'),
(99, 'Bateria laptopowa', 'POW-196', '300.00', 10, 'Zasilanie', '2026-06-09 15:52:00'),
(100, 'Karta SIM adapter', 'NET-197', '10.00', 100, 'Sieci', '2026-06-09 15:52:00'),
(101, 'Folia ochronna', 'ACC-198', '20.00', 150, 'Akcesoria', '2026-06-09 15:52:00'),
(102, 'Etui silikonowe', 'ACC-199', '30.00', 100, 'Akcesoria', '2026-06-09 15:52:00'),
(103, 'Głośnik komputerowy', 'AUD-200', '80.00', 25, 'Audio', '2026-06-09 15:52:00'),
(399, 'Monitor 32\" 4K', 'MON-201', '1800.00', 5, 'Elektronika', '2026-06-09 15:53:33'),
(400, 'Klawiatura mechaniczna RGB', 'ACC-202', '350.00', 20, 'Akcesoria', '2026-06-09 15:53:33'),
(401, 'Mysz pionowa ergonomiczna', 'ACC-203', '220.00', 15, 'Akcesoria', '2026-06-09 15:53:33'),
(402, 'Słuchawki bezprzewodowe ANC', 'AUD-204', '600.00', 10, 'Audio', '2026-06-09 15:53:33'),
(403, 'Dysk SSD NVMe 2TB', 'HWR-205', '750.00', 12, 'Hardware', '2026-06-09 15:53:33'),
(404, 'Zestaw wideokonferencyjny', 'OFF-206', '1200.00', 3, 'Biuro', '2026-06-09 15:53:33'),
(405, 'Router Mesh Wi-Fi', 'NET-207', '850.00', 8, 'Sieci', '2026-06-09 15:53:33'),
(406, 'Kabel Ethernet 10m', 'NET-208', '40.00', 50, 'Sieci', '2026-06-09 15:53:33'),
(407, 'Stacja dokująca USB-C', 'ACC-209', '450.00', 12, 'Akcesoria', '2026-06-09 15:53:33'),
(408, 'Projektor multimedialny', 'ELE-210', '2500.00', 4, 'Elektronika', '2026-06-09 15:53:33'),
(409, 'Ekran projekcyjny', 'ELE-211', '500.00', 5, 'Elektronika', '2026-06-09 15:53:33'),
(410, 'Uchwyt ścienny TV', 'FUR-212', '150.00', 25, 'Meble', '2026-06-09 15:53:33'),
(411, 'Kamera 4K do streamingu', 'AUD-213', '400.00', 10, 'Audio', '2026-06-09 15:53:33'),
(412, 'Lampka biurkowa z ładowarką', 'OFF-214', '180.00', 20, 'Biuro', '2026-06-09 15:53:33'),
(413, 'Fotel gamingowy', 'FUR-215', '1200.00', 6, 'Meble', '2026-06-09 15:53:33'),
(414, 'Podnóżek biurowy', 'FUR-216', '90.00', 15, 'Meble', '2026-06-09 15:53:33'),
(415, 'Niszczarka do papieru', 'OFF-217', '300.00', 8, 'Biuro', '2026-06-09 15:53:33'),
(416, 'Laminator A4', 'OFF-218', '200.00', 10, 'Biuro', '2026-06-09 15:53:33'),
(417, 'Folia do laminowania', 'OFF-219', '40.00', 50, 'Biuro', '2026-06-09 15:53:33'),
(418, 'Zestaw markerów permanentnych', 'OFF-220', '25.00', 100, 'Biuro', '2026-06-09 15:53:33'),
(419, 'Tablica suchościeralna', 'OFF-221', '150.00', 10, 'Biuro', '2026-06-09 15:53:33'),
(420, 'Szafka na dokumenty', 'FUR-222', '450.00', 4, 'Meble', '2026-06-09 15:53:33'),
(421, 'Półka na monitor', 'FUR-223', '80.00', 30, 'Meble', '2026-06-09 15:53:33'),
(422, 'Zasilacz UPS 1500VA', 'POW-224', '1100.00', 3, 'Zasilanie', '2026-06-09 15:53:33'),
(423, 'Listwa antyprzepięciowa', 'POW-225', '90.00', 60, 'Zasilanie', '2026-06-09 15:53:33'),
(424, 'Baterie AA 12szt', 'POW-226', '30.00', 200, 'Zasilanie', '2026-06-09 15:53:33'),
(425, 'Akumulatorki AA', 'POW-227', '70.00', 80, 'Zasilanie', '2026-06-09 15:53:33'),
(426, 'Ładowarka do akumulatorków', 'POW-228', '120.00', 25, 'Zasilanie', '2026-06-09 15:53:33'),
(427, 'Kabel HDMI 5m', 'ACC-229', '55.00', 40, 'Akcesoria', '2026-06-09 15:53:33'),
(428, 'Adapter USB na Ethernet', 'NET-230', '65.00', 40, 'Sieci', '2026-06-09 15:53:33'),
(429, 'Karta graficzna RTX 4070', 'HWR-231', '3200.00', 4, 'Hardware', '2026-06-09 15:53:33'),
(430, 'Procesor Intel i9', 'HWR-232', '2100.00', 5, 'Hardware', '2026-06-09 15:53:33'),
(431, 'Chłodzenie wodne AIO', 'HWR-233', '550.00', 8, 'Hardware', '2026-06-09 15:53:33'),
(432, 'Obudowa z oknem', 'HWR-234', '500.00', 6, 'Hardware', '2026-06-09 15:53:33'),
(433, 'Wentylatory RGB 3-pak', 'HWR-235', '150.00', 20, 'Hardware', '2026-06-09 15:53:33'),
(434, 'Płyta główna X670', 'HWR-236', '1400.00', 5, 'Hardware', '2026-06-09 15:53:33'),
(435, 'Dysk SSD M.2 4TB', 'HWR-237', '1600.00', 5, 'Hardware', '2026-06-09 15:53:33'),
(436, 'Kabel SATA', 'HWR-238', '15.00', 100, 'Hardware', '2026-06-09 15:53:33'),
(437, 'Pasta termiczna metal', 'HWR-239', '60.00', 30, 'Hardware', '2026-06-09 15:53:33'),
(438, 'Opaska antystatyczna', 'TOOL-240', '20.00', 50, 'Narzędzia', '2026-06-09 15:53:33'),
(439, 'Zestaw śrubokrętów VDE', 'TOOL-241', '130.00', 15, 'Narzędzia', '2026-06-09 15:53:33'),
(440, 'Multimetr cyfrowy', 'TOOL-242', '180.00', 10, 'Narzędzia', '2026-06-09 15:53:33'),
(441, 'Lutownica kolbowa', 'TOOL-243', '90.00', 20, 'Narzędzia', '2026-06-09 15:53:33'),
(442, 'Cyna do lutowania', 'TOOL-244', '30.00', 40, 'Narzędzia', '2026-06-09 15:53:33'),
(443, 'Pistolet do kleju', 'TOOL-245', '50.00', 25, 'Narzędzia', '2026-06-09 15:53:33'),
(444, 'Wkład do kleju 20szt', 'TOOL-246', '15.00', 100, 'Narzędzia', '2026-06-09 15:53:33'),
(445, 'Czytnik e-booków', 'ELE-247', '650.00', 12, 'Elektronika', '2026-06-09 15:53:33'),
(446, 'Etui do czytnika', 'ACC-248', '70.00', 30, 'Akcesoria', '2026-06-09 15:53:33'),
(447, 'Smartwatch GPS', 'WEAR-249', '1100.00', 10, 'Elektronika', '2026-06-09 15:53:33'),
(448, 'Słuchawki sportowe', 'AUD-250', '250.00', 35, 'Audio', '2026-06-09 15:53:33'),
(449, 'Opaska na ramię do tel', 'ACC-251', '40.00', 50, 'Akcesoria', '2026-06-09 15:53:33'),
(450, 'Waga łazienkowa smart', 'ELE-252', '150.00', 15, 'Elektronika', '2026-06-09 15:53:33'),
(451, 'Oczyszczacz powietrza', 'ELE-253', '800.00', 5, 'Elektronika', '2026-06-09 15:53:33'),
(452, 'Filtr do oczyszczacza', 'ELE-254', '150.00', 20, 'Elektronika', '2026-06-09 15:53:33'),
(453, 'Nawilżacz powietrza', 'ELE-255', '200.00', 15, 'Elektronika', '2026-06-09 15:53:33'),
(454, 'Wentylator pokojowy', 'ELE-256', '250.00', 10, 'Elektronika', '2026-06-09 15:53:33'),
(455, 'Klimatyzator przenośny', 'ELE-257', '1500.00', 3, 'Elektronika', '2026-06-09 15:53:33'),
(456, 'Przedłużacz 10m', 'POW-258', '60.00', 40, 'Zasilanie', '2026-06-09 15:53:33'),
(457, 'Bęben na kabel', 'POW-259', '120.00', 10, 'Zasilanie', '2026-06-09 15:53:33'),
(458, 'Adapter podróżny', 'ACC-260', '50.00', 30, 'Akcesoria', '2026-06-09 15:53:33'),
(459, 'Latarka LED', 'TOOL-261', '80.00', 25, 'Narzędzia', '2026-06-09 15:53:33'),
(460, 'Baterie CR2032 5szt', 'POW-262', '15.00', 100, 'Zasilanie', '2026-06-09 15:53:33'),
(461, 'Kabel USB-C do Lightning', 'ACC-263', '70.00', 60, 'Akcesoria', '2026-06-09 15:53:33'),
(462, 'Szybka ładowarka 65W', 'POW-264', '130.00', 40, 'Zasilanie', '2026-06-09 15:53:33'),
(463, 'Powerbank 20000mAh', 'POW-265', '220.00', 30, 'Zasilanie', '2026-06-09 15:53:33'),
(464, 'Torba fotograficzna', 'ACC-266', '200.00', 15, 'Akcesoria', '2026-06-09 15:53:33'),
(465, 'Statyw do aparatu', 'ACC-267', '350.00', 8, 'Akcesoria', '2026-06-09 15:53:33'),
(466, 'Karta SD 256GB', 'STOR-268', '120.00', 50, 'Storage', '2026-06-09 15:53:33'),
(467, 'Adapter kart SD', 'STOR-269', '20.00', 80, 'Storage', '2026-06-09 15:53:33'),
(468, 'Dysk zewnętrzny SSD 1TB', 'STOR-270', '500.00', 20, 'Storage', '2026-06-09 15:53:33'),
(469, 'Etui na dysk', 'STOR-271', '40.00', 40, 'Storage', '2026-06-09 15:53:33'),
(470, 'Hub USB-C 7w1', 'ACC-272', '250.00', 25, 'Akcesoria', '2026-06-09 15:53:33'),
(471, 'Klawiatura Bluetooth', 'ACC-273', '180.00', 20, 'Akcesoria', '2026-06-09 15:53:33'),
(472, 'Mysz trackball', 'ACC-274', '300.00', 10, 'Akcesoria', '2026-06-09 15:53:33'),
(473, 'Podkładka pod nadgarstki', 'FUR-275', '60.00', 40, 'Meble', '2026-06-09 15:53:33'),
(474, 'Uchwyt na słuchawki RGB', 'ACC-276', '100.00', 15, 'Akcesoria', '2026-06-09 15:53:33'),
(475, 'Mikrofon USB', 'AUD-277', '450.00', 10, 'Audio', '2026-06-09 15:53:33'),
(476, 'Pop filtr', 'AUD-278', '50.00', 30, 'Audio', '2026-06-09 15:53:33'),
(477, 'Ramię mikrofonowe', 'AUD-279', '150.00', 12, 'Audio', '2026-06-09 15:53:33'),
(478, 'Karta dźwiękowa USB', 'AUD-280', '250.00', 10, 'Audio', '2026-06-09 15:53:33'),
(479, 'Głośniki 2.1', 'AUD-281', '350.00', 8, 'Audio', '2026-06-09 15:53:33'),
(480, 'Soundbar', 'AUD-282', '700.00', 5, 'Audio', '2026-06-09 15:53:33'),
(481, 'Kabel optyczny', 'AUD-283', '40.00', 50, 'Audio', '2026-06-09 15:53:33'),
(482, 'Wzmacniacz Wi-Fi', 'NET-284', '150.00', 20, 'Sieci', '2026-06-09 15:53:33'),
(483, 'Router 4G/LTE', 'NET-285', '400.00', 8, 'Sieci', '2026-06-09 15:53:33'),
(484, 'Antena zewnętrzna', 'NET-286', '120.00', 10, 'Sieci', '2026-06-09 15:53:33'),
(485, 'Kabel antenowy 10m', 'NET-287', '50.00', 30, 'Sieci', '2026-06-09 15:53:33'),
(486, 'Zestaw do czyszczenia PC', 'TOOL-288', '35.00', 60, 'Narzędzia', '2026-06-09 15:53:33'),
(487, 'Pędzel antystatyczny', 'TOOL-289', '25.00', 50, 'Narzędzia', '2026-06-09 15:53:33'),
(488, 'Szmatki z mikrofibry', 'OFF-290', '15.00', 100, 'Biuro', '2026-06-09 15:53:33'),
(489, 'Płyn do ekranów', 'OFF-291', '20.00', 80, 'Biuro', '2026-06-09 15:53:33'),
(490, 'Organizer na biurko', 'FUR-292', '70.00', 30, 'Meble', '2026-06-09 15:53:33'),
(491, 'Koszyk na dokumenty', 'FUR-293', '40.00', 40, 'Meble', '2026-06-09 15:53:33'),
(492, 'Podkładka pod laptopa', 'FUR-294', '100.00', 20, 'Meble', '2026-06-09 15:53:33'),
(493, 'Kłódka na kod', 'TOOL-295', '30.00', 50, 'Narzędzia', '2026-06-09 15:53:33'),
(494, 'Kabel security', 'ACC-296', '50.00', 30, 'Akcesoria', '2026-06-09 15:53:33'),
(495, 'Etui na tablet', 'ACC-297', '80.00', 40, 'Akcesoria', '2026-06-09 15:53:33'),
(496, 'Szkło hartowane tablet', 'ACC-298', '40.00', 60, 'Akcesoria', '2026-06-09 15:53:33'),
(497, 'Rysik do tabletu', 'ACC-299', '150.00', 20, 'Akcesoria', '2026-06-09 15:53:33'),
(498, 'Lampka nocna smart', 'ELE-300', '120.00', 20, 'Elektronika', '2026-06-09 15:53:33');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) DEFAULT 'seller',
  `is_approved` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Zrzut danych tabeli `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `is_approved`) VALUES
(1, 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', 1),
(2, 'repsackk', '$2y$10$HVSOVnUxaIo0Q2xK7OiOnOqio9BNWC5ch9R44U3C71sNBQReGP6sO', 'seller', 1);

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `invoices`
--
ALTER TABLE `invoices`
  ADD PRIMARY KEY (`id`),
  ADD KEY `seller_id` (`seller_id`);

--
-- Indeksy dla tabeli `invoice_items`
--
ALTER TABLE `invoice_items`
  ADD PRIMARY KEY (`id`);

--
-- Indeksy dla tabeli `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `sku` (`sku`);

--
-- Indeksy dla tabeli `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT dla zrzuconych tabel
--

--
-- AUTO_INCREMENT dla tabeli `invoices`
--
ALTER TABLE `invoices`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT dla tabeli `invoice_items`
--
ALTER TABLE `invoice_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT dla tabeli `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=499;

--
-- AUTO_INCREMENT dla tabeli `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Ograniczenia dla zrzutów tabel
--

--
-- Ograniczenia dla tabeli `invoices`
--
ALTER TABLE `invoices`
  ADD CONSTRAINT `invoices_ibfk_1` FOREIGN KEY (`seller_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
