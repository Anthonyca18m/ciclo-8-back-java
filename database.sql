-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-10-2023 a las 00:09:07
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `utp_ca`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `generar_codigo` (IN `inputParam` VARCHAR(255))   BEGIN
    DECLARE generatedCode VARCHAR(255);
    DECLARE newCode VARCHAR(255);
    DECLARE codeExists INT;
    
    SET codeExists = 1;
    
    WHILE codeExists > 0 DO
        -- Obtener la primera letra en mayúscula
        SET generatedCode = CONCAT(UPPER(SUBSTRING(inputParam, 1, 1)));
        
        -- Generar 3 dígitos aleatorios
        SET generatedCode = CONCAT(generatedCode, LPAD(FLOOR(RAND() * 1000), 3, '0'));
        
        -- Verificar si el código ya existe en la tabla users
        SELECT COUNT(*) INTO codeExists FROM users WHERE code = generatedCode;
    END WHILE;
    
    -- Devolver el código generado que no existe en la tabla
    SELECT generatedCode;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contratos`
--

CREATE TABLE `contratos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `type_contrato_id` bigint(20) UNSIGNED DEFAULT NULL,
  `date_init` date NOT NULL,
  `date_end` date NOT NULL,
  `salario` decimal(11,2) NOT NULL,
  `status` char(1) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `user_created` varchar(50) NOT NULL,
  `user_updated` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `horarios`
--

CREATE TABLE `horarios` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `hour_in` datetime NOT NULL,
  `hour_out` datetime DEFAULT NULL,
  `tolerancia` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `user_created` varchar(50) NOT NULL,
  `user_updated` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `in_out_users_at`
--

CREATE TABLE `in_out_users_at` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `in_out` char(1) NOT NULL COMMENT 'E: ENTRADA, S: SALIDA',
  `type_r` char(1) NOT NULL COMMENT 'A: AUTOMATICO, M: MANUAL',
  `time_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `log_logins`
--

CREATE TABLE `log_logins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `log_updates`
--

CREATE TABLE `log_updates` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `action_name` varchar(255) DEFAULT NULL,
  `orig_data` text DEFAULT NULL,
  `rep_data` text DEFAULT NULL,
  `url_full` varchar(255) DEFAULT NULL,
  `ip_user` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `types_contratos`
--

CREATE TABLE `types_contratos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `types_contratos`
--

INSERT INTO `types_contratos` (`id`, `name`) VALUES
(1, 'TIEMPO COMPLETO'),
(2, 'MEDIO TIEMPO'),
(3, 'CONTRATO TEMPORAL');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `role` enum('ADMIN','USR') NOT NULL,
  `code` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `document` varchar(20) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `status` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (`id`, `role`, `code`, `name`, `document`, `username`, `password`, `status`, `created_at`, `updated_at`) VALUES
(1, 'ADMIN', 'M137', 'MAX ANTHONY CHI AYALA', '63571099', 'mcachi', '$2a$10$471mL5gYdbFWQRT4WF/2zOvkik7HNu/.WXtsnh6LXHeodVmUPL42K', 1, '2023-10-19 03:07:44', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users_horarios`
--

CREATE TABLE `users_horarios` (
  `id` bigint(20) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `horario_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `contratos`
--
ALTER TABLE `contratos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `type_contrato_id` (`type_contrato_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indices de la tabla `horarios`
--
ALTER TABLE `horarios`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `in_out_users_at`
--
ALTER TABLE `in_out_users_at`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `log_logins`
--
ALTER TABLE `log_logins`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `log_updates`
--
ALTER TABLE `log_updates`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `types_contratos`
--
ALTER TABLE `types_contratos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD UNIQUE KEY `UKr43af9ap4edm43mmtq01oddj6` (`username`);

--
-- Indices de la tabla `users_horarios`
--
ALTER TABLE `users_horarios`
  ADD PRIMARY KEY (`id`),
  ADD KEY `horario_id` (`horario_id`),
  ADD KEY `user_id` (`user_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `contratos`
--
ALTER TABLE `contratos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `horarios`
--
ALTER TABLE `horarios`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `in_out_users_at`
--
ALTER TABLE `in_out_users_at`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `log_logins`
--
ALTER TABLE `log_logins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `log_updates`
--
ALTER TABLE `log_updates`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `types_contratos`
--
ALTER TABLE `types_contratos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `users_horarios`
--
ALTER TABLE `users_horarios`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `contratos`
--
ALTER TABLE `contratos`
  ADD CONSTRAINT `contratos_ibfk_1` FOREIGN KEY (`type_contrato_id`) REFERENCES `types_contratos` (`id`),
  ADD CONSTRAINT `contratos_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Filtros para la tabla `users_horarios`
--
ALTER TABLE `users_horarios`
  ADD CONSTRAINT `users_horarios_ibfk_1` FOREIGN KEY (`horario_id`) REFERENCES `horarios` (`id`),
  ADD CONSTRAINT `users_horarios_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
