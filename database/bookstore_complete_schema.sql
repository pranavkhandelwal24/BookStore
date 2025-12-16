-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 13, 2025 at 03:30 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `bookstore_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `books`
--

CREATE TABLE `books` (
  `book_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `isbn` varchar(20) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `discount_price` decimal(10,2) DEFAULT NULL,
  `stock` int(11) DEFAULT 0,
  `category` varchar(100) DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `books`
--

INSERT INTO `books` (`book_id`, `title`, `author`, `isbn`, `description`, `price`, `discount_price`, `stock`, `category`, `image_url`, `created_at`, `updated_at`) VALUES
(1, 'The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 'A classic American novel set in the Jazz Age. The story of Jay Gatsby and his obsession with Daisy Buchanan.', 299.00, 249.00, 49, 'Fiction', 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300', '2025-08-09 05:46:15', '2025-08-09 06:34:14'),
(2, 'To Kill a Mockingbird', 'Harper Lee', '9780061120084', 'A gripping tale of racial injustice and childhood innocence in the American South.', 349.00, NULL, 30, 'Fiction', 'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=300', '2025-08-09 05:46:15', '2025-08-09 05:46:15'),
(3, '1984', 'George Orwell', '9780451524935', 'A dystopian social science fiction novel about totalitarian control and surveillance.', 279.00, 199.00, 39, 'Science Fiction', 'https://images.unsplash.com/photo-1495640388908-05fa85288e61?w=300', '2025-08-09 05:46:15', '2025-08-09 06:34:14'),
(4, 'Pride and Prejudice', 'Jane Austen', '9780141439518', 'A romantic novel of manners set in Georgian England.', 259.00, NULL, 25, 'Romance', 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=300', '2025-08-09 05:46:15', '2025-08-09 05:46:15'),
(5, 'The Catcher in the Rye', 'J.D. Salinger', '9780316769174', 'A controversial novel about teenage rebellion and alienation.', 289.00, 249.00, 35, 'Fiction', 'https://images.unsplash.com/photo-1592496431122-2349e0fbc666?w=300', '2025-08-09 05:46:15', '2025-08-09 05:46:15'),
(6, 'Dune', 'Frank Herbert', '9780441172719', 'Epic science fiction novel set on the desert planet Arrakis.', 399.00, 329.00, 20, 'Science Fiction', 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300', '2025-08-09 05:46:15', '2025-08-09 05:46:15'),
(7, 'The Hobbit', 'J.R.R. Tolkien', '9780547928227', 'A fantasy adventure about Bilbo Baggins and his unexpected journey.', 319.00, 279.00, 45, 'Fantasy', 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=300', '2025-08-09 05:46:15', '2025-08-09 05:46:15'),
(8, 'Harry Potter and the Philosopher\'s Stone', 'J.K. Rowling', '9780747532699', 'The first book in the magical Harry Potter series.', 359.00, 299.00, 60, 'Fantasy', 'https://images.unsplash.com/photo-1551029506-0807df4e2031?w=300', '2025-08-09 05:46:15', '2025-08-09 05:46:15'),
(9, 'The Lord of the Rings', 'J.R.R. Tolkien', '9780544003415', 'Epic fantasy trilogy about the quest to destroy the One Ring.', 599.00, 499.00, 15, 'Fantasy', 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=300', '2025-08-09 05:46:15', '2025-08-09 05:46:15'),
(10, 'Sapiens', 'Yuval Noah Harari', '9780062316097', 'A brief history of humankind and how we came to dominate the world.', 449.00, 379.00, 30, 'Non-Fiction', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300', '2025-08-09 05:46:15', '2025-08-09 05:46:15'),
(11, 'The Alchemist', 'Paulo Coelho', '9780061122415', 'A philosophical novel about following your dreams and personal legend.', 229.00, 189.00, 55, 'Philosophy', 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=300', '2025-08-09 05:46:15', '2025-08-09 05:46:15'),
(12, 'Steve Jobs', 'Walter Isaacson', '9781451648539', 'The authorized biography of Apple co-founder Steve Jobs.', 499.00, 399.00, 25, 'Biography', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300', '2025-08-09 05:46:15', '2025-08-09 05:46:15'),
(13, 'Half-Girlfriend', 'Half', '', 'Half Girlfriend by Chetan Bhagat is a contemporary romance novel about Madhav Jha, a rural boy from Bihar, and Riya Somani, a sophisticated girl from Delhi. Their connection begins in college through a shared love of basketball, but cultural and linguistic differences complicate their relationship.', 600.00, 10.00, 2, 'Romance', 'https://harivubooks.com/cdn/shop/products/half_girlfriend_1_1.jpg?v=1670158110&width=600', '2025-08-09 06:06:03', '2025-08-11 11:18:08');

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `cart_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT 1,
  `added_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('pending','confirmed','shipped','delivered','cancelled') DEFAULT 'pending',
  `payment_status` enum('pending','paid','failed') DEFAULT 'pending',
  `payment_method` varchar(50) DEFAULT NULL,
  `transaction_id` varchar(100) DEFAULT NULL,
  `shipping_address` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `total_amount`, `status`, `payment_status`, `payment_method`, `transaction_id`, `shipping_address`, `created_at`, `updated_at`) VALUES
(1, 2, 468.00, 'pending', 'pending', 'UPI', NULL, 'yoyo', '2025-08-09 06:34:13', '2025-08-09 06:34:13'),
(2, 6, 60.00, 'pending', 'pending', 'UPI', NULL, 'YoYO', '2025-08-11 11:18:08', '2025-08-11 11:18:08');

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `order_item_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `book_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`order_item_id`, `order_id`, `book_id`, `quantity`, `price`) VALUES
(1, 1, 1, 1, 249.00),
(2, 1, 3, 1, 199.00),
(3, 1, 13, 2, 10.00),
(4, 2, 13, 6, 10.00);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `address` text DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `username`, `email`, `password`, `full_name`, `address`, `phone`, `role`, `created_at`) VALUES
(2, 'testuser', 'test@example.com', 'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae', 'Test User', NULL, NULL, 'user', '2025-08-09 05:46:15'),
(5, 'admin', 'admin@bookstore.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Administrator', NULL, NULL, 'admin', '2025-08-09 05:58:53'),
(6, 'webgoat', 'webgoat@gmail.com', 'd3ad9315b7be5dd53b31a273b3b3aba5defe700808305aa16a3062b76658a791', 'Web Goat', 'YoYO', '9588862881', 'user', '2025-08-11 11:17:25');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `books`
--
ALTER TABLE `books`
  ADD PRIMARY KEY (`book_id`),
  ADD UNIQUE KEY `isbn` (`isbn`),
  ADD KEY `idx_books_category` (`category`),
  ADD KEY `idx_books_title` (`title`),
  ADD KEY `idx_books_author` (`author`);

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD UNIQUE KEY `unique_user_book` (`user_id`,`book_id`),
  ADD KEY `book_id` (`book_id`),
  ADD KEY `idx_cart_user_id` (`user_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `idx_orders_user_id` (`user_id`),
  ADD KEY `idx_orders_status` (`status`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_item_id`),
  ADD KEY `book_id` (`book_id`),
  ADD KEY `idx_order_items_order_id` (`order_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `books`
--
ALTER TABLE `books`
  MODIFY `book_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `cart_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`book_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
