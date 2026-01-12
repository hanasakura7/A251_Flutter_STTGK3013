-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jan 12, 2026 at 12:37 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `pawpal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_adoptions`
--

CREATE TABLE `tbl_adoptions` (
  `submission_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `motivation` text NOT NULL,
  `update_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_adoptions`
--

INSERT INTO `tbl_adoptions` (`submission_id`, `user_id`, `pet_id`, `motivation`, `update_at`) VALUES
(1, 2, 3, 'she is cute', '2026-01-12 17:59:34'),
(2, 4, 3, 'she is cute', '2026-01-12 18:43:22'),
(3, 4, 3, 'she is cute', '2026-01-12 19:10:16');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donations`
--

CREATE TABLE `tbl_donations` (
  `donation_id` int(11) NOT NULL,
  `pet_id` varchar(50) NOT NULL,
  `user_id` varchar(50) NOT NULL,
  `donation_type` enum('Money','Food','Medical') NOT NULL,
  `amount` decimal(10,2) DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `donor_name` varchar(255) NOT NULL,
  `donor_email` varchar(255) NOT NULL,
  `donor_phone` varchar(20) NOT NULL,
  `donation_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `image_paths` text NOT NULL,
  `lat` varchar(50) NOT NULL,
  `lng` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `age` varchar(2) NOT NULL,
  `gender` varchar(10) NOT NULL,
  `health` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `pet_type`, `category`, `description`, `image_paths`, `lat`, `lng`, `created_at`, `age`, `gender`, `health`) VALUES
(3, 2, 'mel', 'Cat', 'Adoption', '3 years old kitty found under the tree', '[\"uploads/pets/pet_1768211908_0.jpg\"]', '6.4551017', '100.50632', '2026-01-12 09:58:28', '3', 'Female', 'Healthy'),
(5, 5, 'sam', 'Cat', 'Help/Rescue', 'sam is stuck at a tree', '[\"uploads/pets/pet_1768216021_0.jpg\"]', '6.4551017', '100.50632', '2026-01-12 11:07:01', '3', 'Male', 'Minor Injury');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `reg_date` datetime DEFAULT current_timestamp(),
  `profile_image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `name`, `email`, `password`, `phone`, `reg_date`, `profile_image`) VALUES
(2, 'hafizah', 'hafizah@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0123456789', '2026-01-12 01:18:35', NULL),
(3, 'hanis', 'hanis@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0123456789', '2026-01-12 14:35:26', NULL),
(4, 'nasreen', 'ana@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0123456789', '2026-01-12 18:33:37', NULL),
(5, 'hana', 'hana@gmail.com', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '0123456789', '2026-01-12 19:05:20', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD PRIMARY KEY (`submission_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `pet_id` (`pet_id`);

--
-- Indexes for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD PRIMARY KEY (`donation_id`),
  ADD KEY `pet_id` (`pet_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `donation_date` (`donation_date`);

--
-- Indexes for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  MODIFY `submission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  MODIFY `donation_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD CONSTRAINT `tbl_adoptions_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `tbl_adoptions_ibfk_2` FOREIGN KEY (`pet_id`) REFERENCES `tbl_pets` (`pet_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
