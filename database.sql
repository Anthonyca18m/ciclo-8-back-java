-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-11-2023 a las 02:48:40
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
-- Base de datos: `utp_ca_2`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `clear_logins` ()   BEGIN
    TRUNCATE TABLE log_logins;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `exits_area_users` (IN `area` INT)   BEGIN
    SELECT COUNT(*) FROM users WHERE area_id = area;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `exits_horario_contratos` (IN `horario` INT)   BEGIN
    SELECT COUNT(*) FROM contratos WHERE horario_id = horario;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `exits_type_contratos` (IN `type_contrato` INT)   BEGIN
    SELECT COUNT(*) FROM contratos WHERE type_contrato_id = type_contrato;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generar_codigo` (IN `inputParam` VARCHAR(255))   BEGIN
    DECLARE generatedCode VARCHAR(255);
    DECLARE newCode VARCHAR(255);
    DECLARE codeExists INT;
    
    SET codeExists = 1;
    
    WHILE codeExists > 0 DO
        -- Obtener la primera letra en mayúscula
        SET generatedCode = CONCAT(UPPER(SUBSTRING(inputParam, 1, 1)));
        
        -- Generar 3 dígitos aleatorios
        -- SET generatedCode = CONCAT(generatedCode, LPAD(FLOOR(RAND() * 1000), 4, '0'));
        SET generatedCode = LPAD(FLOOR(RAND() * 10000), 4);
        -- Verificar si el código ya existe en la tabla users
        SELECT COUNT(*) INTO codeExists FROM users WHERE code = generatedCode;
    END WHILE;
    
    -- Devolver el código generado que no existe en la tabla
    SELECT generatedCode;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_areas` (IN `searching` VARCHAR(255), IN `limitRows` INT)   BEGIN
    SELECT * FROM areas a WHERE (a.area LIKE CONCAT('%', searching, '%') OR a.id LIKE CONCAT('%', searching, '%')) LIMIT limitRows;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_asistencia` (IN `searching` VARCHAR(255), IN `type_es` VARCHAR(255), IN `device` VARCHAR(255), IN `limitRows` INT)   BEGIN
    
    SELECT ou.id as aId, u.name, DATE_FORMAT(ou.time_at, '%Y-%d-%c %H:%i:%s %p') as time_at, IF(ou.in_out = 'E', 'ENTRADA', 'SALIDA'), IF(ou.type_r = 'A', 'AUTOMATICO', 'MANUAL'), ou.user_created
        FROM in_out_users_at ou INNER JOIN users u ON ou.user_id = u.id
        WHERE (u.name LIKE CONCAT('%', searching, '%') OR u.username LIKE CONCAT('%', searching, '%') OR u.code LIKE CONCAT('%', searching, '%')) 
        AND (type_es = '' OR ou.in_out = type_es) AND (device = '' OR ou.type_r = device) 
        AND u.role = 'USR' ORDER BY ou.id DESC LIMIT limitRows;
    
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_employes` (IN `searching` VARCHAR(255), IN `limitRows` INT, IN `area_id` VARCHAR(255))   BEGIN
    SELECT * FROM users u 
    	WHERE (u.name LIKE CONCAT('%', searching, '%') OR u.document LIKE CONCAT('%', searching, '%') OR u.code LIKE CONCAT('%', searching, '%'))  
        AND (area_id IS NULL OR u.area_id = area_id) 
        AND u.role = 'USR' LIMIT limitRows;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_horarios` (IN `searching` VARCHAR(255), IN `limitRows` INT)   BEGIN
    SELECT * FROM horarios h WHERE (h.hour_in LIKE CONCAT('%', searching, '%') OR h.hour_out LIKE CONCAT('%', searching, '%') OR h.id LIKE CONCAT('%', searching, '%'))  LIMIT limitRows;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_log_logins` (IN `searching` VARCHAR(255), IN `limitRows` INT)   BEGIN
    SELECT ll.id, u.username, u.name, ll.created_at FROM log_logins ll inner join users u on ll.user_id = u.id 
        WHERE (u.name LIKE CONCAT('%', searching, '%') OR u.username LIKE CONCAT('%', searching, '%') OR u.code LIKE CONCAT('%', searching, '%')) ORDER BY ll.id DESC LIMIT limitRows;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_log_move` (IN `searching` VARCHAR(255), IN `limitRows` INT)   BEGIN
    SELECT * FROM log_updates WHERE (username LIKE CONCAT('%', searching, '%') OR action_name LIKE CONCAT('%', searching, '%') OR url_full LIKE CONCAT('%', searching, '%')) ORDER BY id DESC LIMIT limitRows;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_type_contratos` (IN `searching` VARCHAR(255), IN `limitRows` INT)   BEGIN
    SELECT * FROM types_contratos h WHERE (h.name LIKE CONCAT('%', searching, '%') OR h.id LIKE CONCAT('%', searching, '%')) LIMIT limitRows;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `list_users` (IN `searching` VARCHAR(255), IN `limitRows` INT)   BEGIN
    SELECT * FROM users u 
    WHERE (u.name LIKE CONCAT('%', searching, '%') 
    OR u.username LIKE CONCAT('%', searching, '%') 
    OR u.code LIKE CONCAT('%', searching, '%')) 
    AND u.role = 'ADMIN' 
    LIMIT limitRows;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `select_uni` (IN `type_select` VARCHAR(255))   BEGIN
    CASE 
        WHEN type_select = 'areas' THEN 
            SELECT id, area AS name FROM areas ORDER BY area ASC;
        WHEN type_select = 'jornadas' THEN 
            SELECT id, name FROM types_contratos ORDER BY name ASC;
        WHEN type_select = 'horarios' THEN 
            SELECT id, CONCAT('De ', hour_in, ' a ', hour_out, ' T: ', tolerancia) AS name FROM horarios ORDER BY id ASC;
        WHEN type_select = 'employes' THEN 
            SELECT u.id as id, u.name as name FROM users u INNER JOIN contratos c ON u.id = c.user_id WHERE u.status = 1 AND c.status = 1 AND u.role = 'USR';
    END CASE;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `delete_employer` (`user` INT) RETURNS INT(11) DETERMINISTIC BEGIN
    DECLARE filas_afectadas INT DEFAULT 0;

    DELETE FROM contratos WHERE user_id = user AND (SELECT COUNT(*) FROM in_out_users_at ou WHERE ou.user_id = user) = 0;
    SET filas_afectadas = filas_afectadas + ROW_COUNT();

    DELETE FROM users WHERE id = user AND role = 'USR' AND (SELECT COUNT(*) FROM in_out_users_at ou WHERE ou.user_id = user) = 0;
    SET filas_afectadas = filas_afectadas + ROW_COUNT();

    IF filas_afectadas > 0 THEN
        RETURN 1;
    ELSE
        RETURN 0;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `registrarAsistencia` (`codigo` INT(4), `type_r` CHAR(1), `user_created` VARCHAR(255)) RETURNS VARCHAR(255) CHARSET utf8mb4 COLLATE utf8mb4_general_ci DETERMINISTIC BEGIN
    DECLARE DATE_NOW DATETIME DEFAULT NOW();
    DECLARE USER_ID BIGINT;
    DECLARE USERNAME VARCHAR(255);
    DECLARE TYPE_A CHAR(1) DEFAULT "E";
    DECLARE HOUR_IN DATETIME;
    DECLARE HOUR_OUT DATETIME;
    DECLARE TOLERANCIA INT;
    DECLARE STATUS_CONTRATO INT;
    DECLARE STATUS_USER INT;
    DECLARE DIFFMNT INT DEFAULT 0;
    DECLARE ULTIMO_R DATETIME;
    
    SELECT u.id, u.name, h.hour_in, h.hour_out, h.tolerancia, u.status, c.status INTO USER_ID, USERNAME, HOUR_IN, HOUR_OUT, TOLERANCIA, STATUS_USER, STATUS_CONTRATO
		FROM users u INNER JOIN contratos c ON u.id = c.user_id INNER JOIN horarios h ON c.horario_id = h.id 
			WHERE u.code = codigo;
    
    IF USER_ID IS NULL THEN return "422- EL CÓDIGO INGRESADO NO EXISTE.";  END IF;
    IF STATUS_USER = 0 THEN return "422- EL EMPLEADO ESTA INACTIVO.";  END IF;
    IF STATUS_CONTRATO = 0 THEN return "422- EL CONTRATO DEL EMPLEADO SE ENCUENTRA VENCIDO.";  END IF;
    
    SELECT ou.time_at INTO ULTIMO_R FROM in_out_users_at ou
		WHERE ou.user_id = USER_ID AND DATE_FORMAT(ou.time_at, "%Y-%m-%d") = CURDATE() ORDER BY ou.id DESC LIMIT 1;
    
    IF ULTIMO_R IS NOT NULL THEN 
		IF ((SELECT TIMESTAMPDIFF(MINUTE,ULTIMO_R,DATE_NOW))) < 60 THEN 
			RETURN "422- YA SE ENCUENTRA REGISTRADO SU MARCACIÓN, VUELVA A INTENTARLO MÁS TARDE."; 
		END IF;
    END IF;
    
	IF ((SELECT COUNT(*) FROM in_out_users_at ou WHERE ou.user_id = USER_ID AND DATE_FORMAT(ou.time_at, "%Y-%m-%d") = CURDATE()) >= 1) THEN 
		SET TYPE_A = "S"; 
	END IF;
    
    IF TYPE_A = "E" THEN 
		SET DIFFMNT = (SELECT TIMESTAMPDIFF(MINUTE,HOUR_IN,DATE_NOW)); 
    END IF;
    
    INSERT INTO in_out_users_at (user_id, in_out, type_r, time_at, min_cu, user_created) 
		VALUES (USER_ID, TYPE_A, type_r, DATE_NOW, DIFFMNT, user_created);
                
	RETURN CONCAT("200- HOLA ", USERNAME,", TU MARCACIÓN SE HA REGISTRADO CON ÉXITO.");
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `areas`
--

CREATE TABLE `areas` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `area` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `user_created` varchar(50) DEFAULT NULL,
  `user_updated` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `areas`
--

INSERT INTO `areas` (`id`, `area`, `created_at`, `updated_at`, `user_created`, `user_updated`) VALUES
(1, 'RECURSOS HUMANOS', '2023-10-25 00:50:15', NULL, NULL, NULL),
(2, 'OPERACIONES', '2023-10-25 00:50:15', NULL, NULL, NULL),
(3, 'GERENCIA', '2023-10-25 00:50:15', NULL, NULL, NULL),
(4, 'ALMACEN', '2023-10-25 00:50:15', NULL, NULL, NULL),
(5, 'LOGISTICA', '2023-10-25 00:50:15', NULL, NULL, NULL),
(6, 'SEGURIDAD', '2023-10-25 00:50:15', NULL, NULL, NULL),
(7, 'VENTAS', '2023-10-25 00:50:15', NULL, NULL, NULL),
(9, 'ATENCIÓN AL CLIENTE', '2023-11-13 03:32:51', NULL, 'mcachi', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contratos`
--

CREATE TABLE `contratos` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `horario_id` bigint(20) UNSIGNED DEFAULT NULL,
  `type_contrato_id` bigint(20) UNSIGNED DEFAULT NULL,
  `date_init` date NOT NULL,
  `date_end` date NOT NULL,
  `salario` double NOT NULL,
  `status` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `user_created` varchar(50) DEFAULT NULL,
  `user_updated` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `contratos`
--

INSERT INTO `contratos` (`id`, `user_id`, `horario_id`, `type_contrato_id`, `date_init`, `date_end`, `salario`, `status`, `created_at`, `updated_at`, `user_created`, `user_updated`) VALUES
(36, 52, 1, 4, '2023-10-30', '2023-12-08', 10000, '1', '2023-11-16 06:22:35', NULL, 'mcachi', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `horarios`
--

CREATE TABLE `horarios` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `hour_in` time(6) NOT NULL,
  `hour_out` time(6) NOT NULL,
  `tolerancia` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL,
  `user_created` varchar(50) DEFAULT NULL,
  `user_updated` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `horarios`
--

INSERT INTO `horarios` (`id`, `hour_in`, `hour_out`, `tolerancia`, `created_at`, `updated_at`, `user_created`, `user_updated`) VALUES
(1, '08:00:00.000000', '17:00:00.000000', 10, '2023-10-25 02:39:07', NULL, '', ''),
(2, '09:00:00.000000', '18:00:00.000000', 10, '2023-10-25 02:39:07', NULL, '', ''),
(3, '10:20:00.059000', '16:00:00.000000', 10, '2023-10-25 02:39:07', NULL, '', ''),
(4, '07:00:00.000000', '13:00:00.000000', 10, '2023-10-25 02:39:07', NULL, '', ''),
(5, '08:00:00.000000', '14:00:00.000000', 10, '2023-10-25 02:39:07', NULL, '', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `in_out_users_at`
--

CREATE TABLE `in_out_users_at` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `in_out` char(1) NOT NULL,
  `type_r` char(1) NOT NULL,
  `time_at` datetime NOT NULL,
  `min_cu` int(11) DEFAULT NULL,
  `user_created` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `log_logins`
--

CREATE TABLE `log_logins` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` datetime(6) DEFAULT current_timestamp(6)
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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `username` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `log_updates`
--

INSERT INTO `log_updates` (`id`, `user_id`, `action_name`, `orig_data`, `rep_data`, `url_full`, `ip_user`, `created_at`, `username`) VALUES
(1, NULL, 'UPDATE ADM', 'mcachi | MAX ANTHONY CHI AYALA', 'mcachi | MAX ANTHONY CHI AYALA', 'http://127.0.0.1:4001/api/v1/users/1', '127.0.0.1', '2023-10-22 23:40:05', 'mcachi'),
(2, NULL, 'REG ADM', NULL, 'asfsedfsef | frdgdrgd', 'http://127.0.0.1:4001/api/v1/users', '127.0.0.1', '2023-10-24 06:29:44', 'mcachi'),
(3, NULL, 'UPDATE ADM', 'asfsedfsef | FRDGDRGD', 'asfsedfsef | moidifadc', 'http://127.0.0.1:4001/api/v1/users/2', '127.0.0.1', '2023-10-24 06:30:08', 'mcachi'),
(4, NULL, 'DELETE USER', 'asfsedfsef | moidifadc', '2', 'http://127.0.0.1:4001/api/v1/users/2', '127.0.0.1', '2023-10-24 06:30:17', 'mcachi'),
(5, NULL, 'UPDATE ADM', 'mcachi | MAX ANTHONY CHI AYALA', 'mcachi | MAX ANTHONY CHI AYALAfsdfsf', 'http://127.0.0.1:4001/api/v1/users/1', '127.0.0.1', '2023-10-24 06:30:31', 'mcachi'),
(6, NULL, 'UPDATE ADM', 'mcachi | MAX ANTHONY CHI AYALAfsdfsf', 'mcachi | MAX ANTHONY CHI AYALA', 'http://127.0.0.1:4001/api/v1/users/1', '127.0.0.1', '2023-10-24 06:30:37', 'mcachi'),
(7, NULL, 'UPDATE ADM', 'mcachi | MAX ANTHONY CHI AYALA', 'mcachi | MAX ANTHONY CHI AYALA', 'http://127.0.0.1:4001/api/v1/users/1', '127.0.0.1', '2023-10-24 06:30:58', 'anonymousUser'),
(8, NULL, 'REG ADM', NULL, 'fdgdfgdr | fdgdfgdg', 'http://127.0.0.1:4001/api/v1/users', '127.0.0.1', '2023-10-24 06:35:30', 'mcachi'),
(9, NULL, 'UPDATE ADM', 'fdgdfgdr | FDGDFGDG', 'testusuario | FDGDFGDG', 'http://127.0.0.1:4001/api/v1/users/5', '127.0.0.1', '2023-10-24 06:35:48', 'mcachi'),
(10, NULL, 'UPDATE ADM', 'testusuario | FDGDFGDG', 'mcachi | FDGDFGDG', 'http://127.0.0.1:4001/api/v1/users/5', '127.0.0.1', '2023-10-25 01:53:56', 'mcachi'),
(11, NULL, 'REG ADM', NULL, 'fghfhfth | gdfgdrgrdg', 'http://127.0.0.1:4001/api/v1/users', '127.0.0.1', '2023-10-25 06:44:23', 'mcachi'),
(12, NULL, 'UPDATE ADM', 'testusuario | FDGDFGDG', 'testusuario | FDGDFGDG', 'http://127.0.0.1:4001/api/v1/users/5', '127.0.0.1', '2023-10-25 07:35:11', 'mcachi'),
(13, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=dfgdfgdfgdfg, document=54345345, area_id=3, jornada_id=3, horario_id=2, c_init=2023-11-08, c_end=2023-11-07, c_salary=4353.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-07 06:46:57', 'mcachi'),
(14, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=sefsefesfdesdfe, document=23424324, area_id=5, jornada_id=2, horario_id=4, c_init=2023-11-06, c_end=2023-11-15, c_salary=324234.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-07 06:48:38', 'mcachi'),
(15, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=fdgdfgdrgdr, document=65468465, area_id=3, jornada_id=3, horario_id=2, c_init=2023-11-06, c_end=2023-11-17, c_salary=43534.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-07 06:58:52', 'mcachi'),
(16, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=dfserfsefs, document=23423423, area_id=5, jornada_id=1, horario_id=2, c_init=2023-11-07, c_end=2023-11-10, c_salary=43535.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-07 06:59:33', 'mcachi'),
(17, NULL, 'UPDATE ADM', 'testusuario | FDGDFGDG', 'testusuario | rtghtrgfhhfh', 'http://127.0.0.1:4001/api/v1/users/5', '127.0.0.1', '2023-11-07 07:31:12', 'mcachi'),
(18, NULL, 'UPDATE ADM', 'testusuario | rtghtrgfhhfh', 'testusuario | rtghtrgfhhfh', 'http://127.0.0.1:4001/api/v1/users/5', '127.0.0.1', '2023-11-07 07:31:28', 'mcachi'),
(19, NULL, 'UPDATE ADM', 'testusuario | rtghtrgfhhfh', 'testusuario | rtghtrgfhhfh', 'http://127.0.0.1:4001/api/v1/users/5', '127.0.0.1', '2023-11-07 07:31:38', 'mcachi'),
(20, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=trrrh, document=45654654, area_id=3, jornada_id=2, horario_id=2, c_init=2023-11-29, c_end=2023-11-05, c_salary=4355.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-07 07:49:56', 'testusuario'),
(21, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=gfhfhb fb, document=32543564, area_id=3, jornada_id=2, horario_id=1, c_init=2023-11-29, c_end=2023-10-05, c_salary=344.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-07 07:50:41', 'testusuario'),
(22, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=fgdgdfrgder, document=43534543, area_id=5, jornada_id=3, horario_id=2, c_init=2023-11-07, c_end=2023-11-23, c_salary=34534.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-08 05:47:07', 'mcachi'),
(23, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=dgtdrfgdfgdr, document=45645634, area_id=4, jornada_id=3, horario_id=2, c_init=2023-11-01, c_end=2023-11-23, c_salary=1000.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-08 06:37:59', 'mcachi'),
(24, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=ergferge, document=34534543, area_id=5, jornada_id=2, horario_id=1, dateInit=Mon Nov 06 19:00:00 PET 2023, dateEnd=Thu Nov 23 19:00:00 PET 2023, c_salary=3333.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-11 23:53:24', 'mcachi'),
(25, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=fdsggdfgdsgf, document=32423423, area_id=3, jornada_id=3, horario_id=2, dateInit=Tue Oct 31 19:00:00 PET 2023, dateEnd=Wed Nov 29 19:00:00 PET 2023, c_salary=3233.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-12 00:05:17', 'mcachi'),
(26, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=reertgrtertgf, document=32423432, area_id=2, jornada_id=2, horario_id=2, dateInit=Thu Nov 30 19:00:00 PET 2023, dateEnd=Mon Oct 30 19:00:00 PET 2023, c_salary=1111.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-12 00:09:19', 'mcachi'),
(27, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=addadwad, document=98567567, area_id=3, jornada_id=3, horario_id=3, dateInit=Tue Oct 31 19:00:00 PET 2023, dateEnd=Wed Nov 29 19:00:00 PET 2023, c_salary=3242.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-12 00:32:45', 'mcachi'),
(28, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=jhmghjgfh, document=65467756, area_id=2, jornada_id=3, horario_id=2, dateInit=Tue Oct 31 19:00:00 PET 2023, dateEnd=Wed Nov 29 19:00:00 PET 2023, c_salary=1474.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-12 00:37:33', 'mcachi'),
(29, NULL, 'DELETE USR', 'FDSGGDFGDSGF', '18', 'http://127.0.0.1:4001/api/v1/employes/18', '127.0.0.1', '2023-11-12 00:48:53', 'mcachi'),
(30, NULL, 'DELETE USR', 'GFHFHB FB', '13', 'http://127.0.0.1:4001/api/v1/employes/13', '127.0.0.1', '2023-11-12 00:49:02', 'mcachi'),
(31, NULL, 'DELETE USR', 'TRRRH', '12', 'http://127.0.0.1:4001/api/v1/employes/12', '127.0.0.1', '2023-11-12 00:49:04', 'mcachi'),
(32, NULL, 'DELETE USR', 'FGDGDFRGDER', '15', 'http://127.0.0.1:4001/api/v1/employes/15', '127.0.0.1', '2023-11-12 00:49:06', 'mcachi'),
(33, NULL, 'DELETE USR', 'DGTDRFGDFGDR', '16', 'http://127.0.0.1:4001/api/v1/employes/16', '127.0.0.1', '2023-11-12 00:49:40', 'mcachi'),
(34, NULL, 'DELETE USR', 'JHMGHJGFH', '26', 'http://127.0.0.1:4001/api/v1/employes/26', '127.0.0.1', '2023-11-12 00:49:42', 'mcachi'),
(35, NULL, 'DELETE USR', 'ADDADWAD', '25', 'http://127.0.0.1:4001/api/v1/employes/25', '127.0.0.1', '2023-11-12 00:49:46', 'mcachi'),
(36, NULL, 'DELETE USR', 'ERGFERGE', '17', 'http://127.0.0.1:4001/api/v1/employes/17', '127.0.0.1', '2023-11-12 00:49:47', 'mcachi'),
(37, NULL, 'DELETE USR', 'DFSERFSEFS', '11', 'http://127.0.0.1:4001/api/v1/employes/11', '127.0.0.1', '2023-11-12 00:50:12', 'mcachi'),
(38, NULL, 'DELETE USR', 'DFSERFSEFS', '11', 'http://127.0.0.1:4001/api/v1/employes/11', '127.0.0.1', '2023-11-12 00:50:18', 'mcachi'),
(39, NULL, 'DELETE USR', 'DFSERFSEFS', '11', 'http://127.0.0.1:4001/api/v1/employes/11', '127.0.0.1', '2023-11-12 00:50:22', 'mcachi'),
(40, NULL, 'DELETE USR', 'DFSERFSEFS', '11', 'http://127.0.0.1:4001/api/v1/employes/11', '127.0.0.1', '2023-11-12 00:50:55', 'mcachi'),
(41, NULL, 'DELETE USR', 'DFSERFSEFS', '11', 'http://127.0.0.1:4001/api/v1/employes/11', '127.0.0.1', '2023-11-12 00:51:09', 'mcachi'),
(42, NULL, 'DELETE USR', 'DFSERFSEFS', '11', 'http://127.0.0.1:4001/api/v1/employes/11', '127.0.0.1', '2023-11-12 00:51:17', 'mcachi'),
(43, NULL, 'DELETE USR', 'DFSERFSEFS', '11', 'http://127.0.0.1:4001/api/v1/employes/11', '127.0.0.1', '2023-11-12 01:27:42', 'mcachi'),
(44, NULL, 'DELETE USR', 'FDGDFGDRGDR', '10', 'http://127.0.0.1:4001/api/v1/employes/10', '127.0.0.1', '2023-11-12 01:27:51', 'mcachi'),
(45, NULL, 'DELETE USR', 'DFSERFSEFS', '11', 'http://127.0.0.1:4001/api/v1/employes/11', '127.0.0.1', '2023-11-12 01:28:17', 'mcachi'),
(46, NULL, 'DELETE USR', 'DFSERFSEFS', '11', 'http://127.0.0.1:4001/api/v1/employes/11', '127.0.0.1', '2023-11-12 01:28:37', 'mcachi'),
(47, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=fgdfgdfgedrgd, document=34534534, area_id=3, jornada_id=1, horario_id=3, dateInit=Tue Oct 31 19:00:00 PET 2023, dateEnd=Wed Nov 29 19:00:00 PET 2023, c_salary=2343.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-12 02:48:23', 'mcachi'),
(48, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=hgfjnhgjgyuj, document=45645745, area_id=3, jornada_id=3, horario_id=2, dateInit=Wed Nov 01 19:00:00 PET 2023, dateEnd=Wed Nov 29 19:00:00 PET 2023, c_salary=678678.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-12 02:52:22', 'mcachi'),
(49, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=dfggfdg, document=45645645, area_id=2, jornada_id=3, horario_id=2, dateInit=Tue Oct 31 19:00:00 PET 2023, dateEnd=Tue Nov 28 19:00:00 PET 2023, c_salary=34533.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-12 02:52:42', 'mcachi'),
(50, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=dfgdgdfgdf, document=53453543, area_id=5, jornada_id=3, horario_id=2, dateInit=Wed Nov 01 19:00:00 PET 2023, dateEnd=Tue Nov 28 19:00:00 PET 2023, c_salary=3453.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-12 02:58:26', 'mcachi'),
(51, NULL, 'DELETE USR', 'DFSERFSEFS', '11', 'http://127.0.0.1:4001/api/v1/employes/11', '127.0.0.1', '2023-11-12 02:58:42', 'mcachi'),
(52, NULL, 'DELETE USR', 'FGDFGDFGEDRGD', '27', 'http://127.0.0.1:4001/api/v1/employes/27', '127.0.0.1', '2023-11-12 02:58:44', 'mcachi'),
(53, NULL, 'DELETE USR', 'DFSERFSEFS', '11', 'http://127.0.0.1:4001/api/v1/employes/11', '127.0.0.1', '2023-11-12 02:58:46', 'mcachi'),
(54, NULL, 'DELETE USR', 'HGFJNHGJGYUJ', '28', 'http://127.0.0.1:4001/api/v1/employes/28', '127.0.0.1', '2023-11-12 02:58:51', 'mcachi'),
(55, NULL, 'DELETE USR', 'DFGGFDG', '29', 'http://127.0.0.1:4001/api/v1/employes/29', '127.0.0.1', '2023-11-12 02:58:53', 'mcachi'),
(56, NULL, 'DELETE USR', 'DFGDGDFGDF', '30', 'http://127.0.0.1:4001/api/v1/employes/30', '127.0.0.1', '2023-11-12 02:58:54', 'mcachi'),
(57, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=sdefefse, document=76765544, area_id=3, jornada_id=3, horario_id=2, dateInit=Tue Oct 31 19:00:00 PET 2023, dateEnd=Wed Nov 29 19:00:00 PET 2023, c_salary=34533.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-12 03:18:47', 'mcachi'),
(58, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=testefder, document=47675675, area_id=3, jornada_id=3, horario_id=2, dateInit=Mon Oct 30 19:00:00 PET 2023, dateEnd=Wed Nov 29 19:00:00 PET 2023, c_salary=4544.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-12 03:37:37', 'mcachi'),
(59, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=ytujtyhjt, document=45645645, area_id=5, jornada_id=1, horario_id=2, dateInit=Tue Oct 31 19:00:00 PET 2023, dateEnd=Wed Nov 29 19:00:00 PET 2023, c_salary=4355.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-12 05:14:18', 'mcachi'),
(60, NULL, 'DELETE USR', 'YTUJTYHJT', '34', 'http://127.0.0.1:4001/api/v1/employes/34', '127.0.0.1', '2023-11-12 22:39:38', 'mcachi'),
(61, NULL, 'DELETE USR', 'SDEFEFSE', '32', 'http://127.0.0.1:4001/api/v1/employes/32', '127.0.0.1', '2023-11-12 22:39:40', 'mcachi'),
(62, NULL, 'DELETE USR', 'TESTEFDER', '33', 'http://127.0.0.1:4001/api/v1/employes/33', '127.0.0.1', '2023-11-12 22:39:42', 'mcachi'),
(63, NULL, 'DELETE USR', 'DFSERFSEFS', '11', 'http://127.0.0.1:4001/api/v1/employes/11', '127.0.0.1', '2023-11-12 22:39:43', 'mcachi'),
(64, NULL, 'DELETE USR', 'DFSERFSEFS', '11', 'http://127.0.0.1:4001/api/v1/employes/11', '127.0.0.1', '2023-11-12 22:40:04', 'mcachi'),
(65, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=test employer, document=56463534, area_id=4, jornada_id=3, horario_id=2, dateInit=Tue Oct 31 19:00:00 PET 2023, dateEnd=Wed Nov 29 19:00:00 PET 2023, c_salary=3242.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-12 22:40:27', 'mcachi'),
(66, NULL, 'UPDATE USR', 'TEST EMPLOYER', 'EmployerUpdateRequest(name=TEST EMPLOYER, document=56463534, area_id=4, jornada_id=3, horario_id=2, dateInit=Tue Oct 31 19:00:00 PET 2023, dateEnd=Wed Nov 29 19:00:00 PET 2023, c_salary=3242.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/35', '127.0.0.1', '2023-11-12 23:19:04', 'mcachi'),
(67, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=test t rabajador, document=53645634, area_id=5, jornada_id=3, horario_id=2, dateInit=2023-10-31, dateEnd=2023-11-29, c_salary=32432.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-12 23:44:04', 'mcachi'),
(68, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=test tt rabajador, document=24356654, area_id=6, jornada_id=1, horario_id=1, dateInit=2023-10-31, dateEnd=2024-11-30, c_salary=1000.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-12 23:44:35', 'mcachi'),
(69, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=test ttt rabajador, document=45346453, area_id=3, jornada_id=3, horario_id=1, dateInit=2023-10-31, dateEnd=2024-10-31, c_salary=1233.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-12 23:59:57', 'mcachi'),
(70, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=TEST TTT RABAJADOR, document=31354648, area_id=2, jornada_id=4, horario_id=2, dateInit=2023-10-31, dateEnd=2024-11-29, c_salary=1500.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-13 00:05:00', 'mcachi'),
(71, NULL, 'UPDATE USR', 'TEST TTT RABAJADOR', 'EmployerUpdateRequest(name=TEST TTT RABAJADOR, document=45346453, area_id=3, jornada_id=4, horario_id=1, dateInit=2023-10-30, dateEnd=2024-10-30, c_salary=1700.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/38', '127.0.0.1', '2023-11-13 00:55:16', 'mcachi'),
(72, NULL, 'UPDATE USR', 'TEST TTT RABAJADOR', 'EmployerUpdateRequest(name=TEST TTT RABAJADOR, document=45346453, area_id=3, jornada_id=4, horario_id=1, dateInit=2023-10-30, dateEnd=2024-10-30, c_salary=1700.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/38', '127.0.0.1', '2023-11-13 00:55:22', 'mcachi'),
(73, NULL, 'UPDATE USR', 'TEST TTT RABAJADOR', 'EmployerUpdateRequest(name=TEST TTT RABAJADOR, document=45346453, area_id=3, jornada_id=4, horario_id=1, dateInit=2023-10-30, dateEnd=2024-10-30, c_salary=1700.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/38', '127.0.0.1', '2023-11-13 00:57:07', 'mcachi'),
(74, NULL, 'UPDATE USR', 'TEST TTT RABAJADOR', 'EmployerUpdateRequest(name=TEST TTT RABAJADOR, document=45346453, area_id=3, jornada_id=4, horario_id=1, dateInit=2023-10-29, dateEnd=2024-10-29, c_salary=2000.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/38', '127.0.0.1', '2023-11-13 00:57:36', 'mcachi'),
(75, NULL, 'UPDATE USR', 'TEST TTT RABAJADOR', 'EmployerUpdateRequest(name=TEST TTT RABAJADOR, document=31354648, area_id=2, jornada_id=4, horario_id=2, dateInit=2023-10-30, dateEnd=2022-01-28, c_salary=1500.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/39', '127.0.0.1', '2023-11-13 01:13:26', 'mcachi'),
(76, NULL, 'UPDATE USR', 'TEST TTT RABAJADOR', 'EmployerUpdateRequest(name=TEST TTT RABAJADOR, document=31354648, area_id=2, jornada_id=4, horario_id=2, dateInit=2023-10-30, dateEnd=2022-01-28, c_salary=1500.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/39', '127.0.0.1', '2023-11-13 01:13:45', 'mcachi'),
(77, NULL, 'UPDATE USR', 'TEST T RABAJADOR', 'EmployerUpdateRequest(name=TEST T RABAJADOR, document=53645634, area_id=5, jornada_id=3, horario_id=2, dateInit=2023-10-30, dateEnd=2024-11-06, c_salary=5500.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/36', '127.0.0.1', '2023-11-13 01:14:41', 'mcachi'),
(78, NULL, 'UPDATE USR', 'TEST T RABAJADOR', 'EmployerUpdateRequest(name=TEST T RABAJADOR, document=53645634, area_id=5, jornada_id=3, horario_id=2, dateInit=2023-10-30, dateEnd=2024-11-06, c_salary=5500.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/36', '127.0.0.1', '2023-11-13 01:16:22', 'mcachi'),
(79, NULL, 'UPDATE USR', 'TEST T RABAJADOR', 'EmployerUpdateRequest(name=TEST T RABAJADOR, document=53645634, area_id=5, jornada_id=3, horario_id=2, dateInit=2023-10-30, dateEnd=2024-11-06, c_salary=5500.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/36', '127.0.0.1', '2023-11-13 01:16:35', 'mcachi'),
(80, NULL, 'UPDATE USR', 'TEST T RABAJADOR', 'EmployerUpdateRequest(name=TEST T RABAJADOR, document=53645634, area_id=5, jornada_id=3, horario_id=2, dateInit=2023-10-30, dateEnd=2024-11-06, c_salary=5500.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/36', '127.0.0.1', '2023-11-13 01:16:54', 'mcachi'),
(81, NULL, 'UPDATE USR', 'TEST T RABAJADOR', 'EmployerUpdateRequest(name=TEST T RABAJADOR, document=53645634, area_id=5, jornada_id=3, horario_id=2, dateInit=2023-10-30, dateEnd=2024-11-06, c_salary=5500.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/36', '127.0.0.1', '2023-11-13 01:17:40', 'mcachi'),
(82, NULL, 'UPDATE USR', 'TEST TTT RABAJADOR', 'EmployerUpdateRequest(name=TEST TTT RABAJADOR, document=31354648, area_id=2, jornada_id=4, horario_id=2, dateInit=2023-10-30, dateEnd=2022-11-28, c_salary=1500.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/39', '127.0.0.1', '2023-11-13 01:17:57', 'mcachi'),
(83, NULL, 'UPDATE USR', 'TEST TTT RABAJADOR', 'EmployerUpdateRequest(name=TEST TTT RABAJADOR, document=31354648, area_id=2, jornada_id=4, horario_id=2, dateInit=2023-10-29, dateEnd=2022-11-27, c_salary=1500.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/39', '127.0.0.1', '2023-11-13 01:18:28', 'mcachi'),
(84, NULL, 'UPDATE USR', 'TEST TTT RABAJADOR', 'EmployerUpdateRequest(name=TEST TTT RABAJADOR, document=31354648, area_id=2, jornada_id=4, horario_id=2, dateInit=2023-10-29, dateEnd=2022-11-27, c_salary=1500.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/39', '127.0.0.1', '2023-11-13 01:19:05', 'mcachi'),
(85, NULL, 'UPDATE USR', 'TEST TTT RABAJADOR', 'EmployerUpdateRequest(name=TEST TTT RABAJADOR, document=31354648, area_id=2, jornada_id=4, horario_id=2, dateInit=2023-10-29, dateEnd=2022-11-27, c_salary=1500.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/39', '127.0.0.1', '2023-11-13 01:19:07', 'mcachi'),
(86, NULL, 'UPDATE USR', 'TEST TTT RABAJADOR', 'EmployerUpdateRequest(name=TEST TTT RABAJADOR, document=31354648, area_id=2, jornada_id=4, horario_id=2, dateInit=2023-10-29, dateEnd=2022-11-27, c_salary=1500.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/39', '127.0.0.1', '2023-11-13 01:21:31', 'mcachi'),
(87, NULL, 'UPDATE USR', 'TEST TTT RABAJADOR', 'EmployerUpdateRequest(name=TEST TTT RABAJADOR, document=31354648, area_id=2, jornada_id=4, horario_id=2, dateInit=2023-10-29, dateEnd=2022-11-27, c_salary=1500.0, status=1, role=USR)', 'http://127.0.0.1:4001/api/v1/employes/39', '127.0.0.1', '2023-11-13 01:24:12', 'mcachi'),
(88, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=TEST TTTAMDKASDMNA, document=65468465, area_id=5, jornada_id=4, horario_id=3, dateInit=2023-10-31, dateEnd=2024-06-02, c_salary=3500.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-13 01:28:28', 'mcachi'),
(89, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=KDMFSO JSNDFJKSN, document=54645643, area_id=3, jornada_id=4, horario_id=2, dateInit=2023-10-31, dateEnd=2024-10-31, c_salary=2000.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-13 01:29:12', 'mcachi'),
(90, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=LKMENSFKJ NSJENFSF, document=12354848, area_id=5, jornada_id=1, horario_id=3, dateInit=2023-10-31, dateEnd=2024-10-31, c_salary=4000.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-13 01:29:46', 'mcachi'),
(91, NULL, 'DELETE USER', 'fghfhfth | GDFGDRGRDG', '6', 'http://127.0.0.1:4001/api/v1/users/6', '127.0.0.1', '2023-11-13 01:31:18', 'mcachi'),
(92, NULL, 'DELETE USER', 'testusuario | rtghtrgfhhfh', '5', 'http://127.0.0.1:4001/api/v1/users/5', '127.0.0.1', '2023-11-13 01:31:21', 'mcachi'),
(93, NULL, 'DELETE USR', 'LKMENSFKJ NSJENFSF', '42', 'http://127.0.0.1:4001/api/v1/employes/42', '127.0.0.1', '2023-11-13 01:58:43', 'mcachi'),
(94, NULL, 'DELETE HORARIO', 'Horario(id=7, hour_in=09:00:00, hour_out=15:00:00, tolerancia=10, created_at=2023-10-24T16:39:07, updated_at=null, user_created=, user_updated=)', '7', 'http://127.0.0.1:4001/api/v1/horarios/7', '127.0.0.1', '2023-11-13 02:02:46', 'mcachi'),
(95, NULL, 'REG HORARIO', NULL, 'RegisterHorarioRequest(init=16:55, end=22:55, tolerancia=5)', 'http://127.0.0.1:4001/api/v1/horarios', '127.0.0.1', '2023-11-13 02:56:16', 'mcachi'),
(96, NULL, 'DELETE HORARIO', 'Horario(id=8, hour_in=16:55, hour_out=22:55, tolerancia=5, created_at=2023-11-12T16:56:16, updated_at=null, user_created=mcachi, user_updated=null)', '8', 'http://127.0.0.1:4001/api/v1/horarios/8', '127.0.0.1', '2023-11-13 02:56:21', 'mcachi'),
(97, NULL, 'REG HORARIO', NULL, 'RegisterHorarioRequest(init=17:56, end=22:56, tolerancia=1)', 'http://127.0.0.1:4001/api/v1/horarios', '127.0.0.1', '2023-11-13 02:56:51', 'mcachi'),
(98, NULL, 'DELETE HORARIO', 'Horario(id=9, hour_in=17:56, hour_out=22:56, tolerancia=1, created_at=2023-11-12T16:56:51, updated_at=null, user_created=mcachi, user_updated=null)', '9', 'http://127.0.0.1:4001/api/v1/horarios/9', '127.0.0.1', '2023-11-13 02:56:55', 'mcachi'),
(99, NULL, 'REG HORARIO', NULL, 'RegisterHorarioRequest(init=17:11, end=17:14, tolerancia=5)', 'http://127.0.0.1:4001/api/v1/horarios', '127.0.0.1', '2023-11-13 03:10:13', 'mcachi'),
(100, NULL, 'UPT HORARIO', 'Horario(id=6, hour_in=09:00, hour_out=16:01, tolerancia=10, created_at=2023-10-24T16:39:07, updated_at=2023-11-12T17:09:59, user_created=, user_updated=mcachi)', 'HorarioUpdateRequest(init=09:00, end=16:00, tolerancia=10)', 'http://127.0.0.1:4001/api/v1/horarios/6', '127.0.0.1', '2023-11-13 03:10:56', 'mcachi'),
(101, NULL, 'DELETE HORARIO', 'Horario(id=10, hour_in=17:11, hour_out=17:14, tolerancia=5, created_at=2023-11-12T17:10:13, updated_at=null, user_created=mcachi, user_updated=null)', '10', 'http://127.0.0.1:4001/api/v1/horarios/10', '127.0.0.1', '2023-11-13 03:11:36', 'mcachi'),
(102, NULL, 'UPDATE ADM', 'mcachi | USUARIO ADMINISTRADOR', 'mcachi | ADMINISTRADOR', 'http://127.0.0.1:4001/api/v1/users/1', '127.0.0.1', '2023-11-13 03:14:31', 'mcachi'),
(103, NULL, 'REG AREA', NULL, 'RegisterAreaRequest(name=ABASTECIMIENTO)', 'http://127.0.0.1:4001/api/v1/areas', '127.0.0.1', '2023-11-13 03:32:29', 'mcachi'),
(104, NULL, 'REG AREA', NULL, 'RegisterAreaRequest(name=ATENCIÓN AL CLIENTE)', 'http://127.0.0.1:4001/api/v1/areas', '127.0.0.1', '2023-11-13 03:32:51', 'mcachi'),
(105, NULL, 'REG AREA', NULL, 'RegisterAreaRequest(name=TEST)', 'http://127.0.0.1:4001/api/v1/areas', '127.0.0.1', '2023-11-13 03:32:56', 'mcachi'),
(106, NULL, 'UPT AREA', 'Area(id=10, area=TEST, created_at=2023-11-12T17:32:56, updated_at=null, user_created=mcachi, user_updated=null)', 'AreaUpdateRequest(name=TESTSEEF)', 'http://127.0.0.1:4001/api/v1/areas/10', '127.0.0.1', '2023-11-13 03:33:00', 'mcachi'),
(107, NULL, 'DELETE AREA', 'Area(id=10, area=TESTSEEF, created_at=2023-11-12T17:32:56, updated_at=2023-11-12T17:33, user_created=mcachi, user_updated=mcachi)', '10', 'http://127.0.0.1:4001/api/v1/areas/10', '127.0.0.1', '2023-11-13 03:33:04', 'mcachi'),
(108, NULL, 'REG TIPO CONTRATO', NULL, 'RegisterTypeContratoRequest(name=dfgdrgd)', 'http://127.0.0.1:4001/api/v1/typecontratos', '127.0.0.1', '2023-11-13 03:55:26', 'mcachi'),
(109, NULL, 'UPT TIPO CONTRATO', 'TypeContrato(id=5, name=dfgdrgd)', 'TypeContratoUpdateRequest(name=werwwew)', 'http://127.0.0.1:4001/api/v1/typecontratos/5', '127.0.0.1', '2023-11-13 03:55:30', 'mcachi'),
(110, NULL, 'DELETE TIPO CONTRATO', 'TypeContrato(id=5, name=werwwew)', '5', 'http://127.0.0.1:4001/api/v1/typecontratos/5', '127.0.0.1', '2023-11-13 03:56:15', 'mcachi'),
(111, NULL, 'DELETE MARCACION', '31 TEST T RABAJADOR E A 253 null', '31', 'http://127.0.0.1:4001/api/v1/asistencia/31', '127.0.0.1', '2023-11-16 00:03:29', 'mcachi'),
(112, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=fdgdfgdgdrg, document=45674564, area_id=4, jornada_id=4, horario_id=1, dateInit=2023-10-31, dateEnd=2023-11-29, c_salary=4000.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-16 05:48:52', 'mcachi'),
(113, NULL, 'DELETE USR', 'FDGDFGDGDRG', '43', 'http://127.0.0.1:4001/api/v1/employes/43', '127.0.0.1', '2023-11-16 05:49:02', 'mcachi'),
(114, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=tryhrtyrty, document=45645634, area_id=3, jornada_id=4, horario_id=3, dateInit=2023-10-31, dateEnd=2023-11-29, c_salary=4000.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-16 05:49:39', 'mcachi'),
(115, NULL, 'DELETE USR', 'TRYHRTYRTY', '44', 'http://127.0.0.1:4001/api/v1/employes/44', '127.0.0.1', '2023-11-16 05:49:44', 'mcachi'),
(116, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=gdhhgfhfghh, document=54645645, area_id=4, jornada_id=1, horario_id=3, dateInit=2021-12-31, dateEnd=2023-10-31, c_salary=1000.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-16 05:50:12', 'mcachi'),
(117, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=fgfghfghf, document=76867676, area_id=8, jornada_id=4, horario_id=2, dateInit=2023-10-31, dateEnd=2023-11-30, c_salary=1500.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-16 05:50:31', 'mcachi'),
(118, NULL, 'DELETE USR', 'GDHHGFHFGHH', '45', 'http://127.0.0.1:4001/api/v1/employes/45', '127.0.0.1', '2023-11-16 05:55:13', 'mcachi'),
(119, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=drfgdrgdrgdrgdrgdrg, document=43543443, area_id=4, jornada_id=4, horario_id=1, dateInit=2023-10-31, dateEnd=2023-11-29, c_salary=34543.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-16 05:55:27', 'mcachi'),
(120, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=tfg, document=45654656, area_id=8, jornada_id=4, horario_id=2, dateInit=2023-10-31, dateEnd=2023-11-29, c_salary=2000.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-16 05:55:38', 'mcachi'),
(121, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=sfesfesef, document=34534543, area_id=8, jornada_id=4, horario_id=1, dateInit=2023-10-31, dateEnd=2023-11-29, c_salary=3445.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-16 06:00:46', 'mcachi'),
(122, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=drgdrgdrg, document=45345433, area_id=9, jornada_id=4, horario_id=1, dateInit=2023-11-01, dateEnd=2023-11-29, c_salary=3444.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-16 06:04:05', 'mcachi'),
(123, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=dfrggdrdrg, document=54645654, area_id=4, jornada_id=4, horario_id=1, dateInit=2023-10-31, dateEnd=2023-11-29, c_salary=4555.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-16 06:06:01', 'mcachi'),
(124, NULL, 'DELETE USR', 'DFRGGDRDRG', '51', 'http://127.0.0.1:4001/api/v1/employes/51', '127.0.0.1', '2023-11-16 06:06:07', 'mcachi'),
(125, NULL, 'DELETE AREA', 'Area(id=8, area=ABASTECIMIENTO, created_at=2023-11-12T17:32:29, updated_at=null, user_created=mcachi, user_updated=null)', '8', 'http://127.0.0.1:4001/api/v1/areas/8', '127.0.0.1', '2023-11-16 06:13:19', 'mcachi'),
(126, NULL, 'DELETE MARCACION', '34 DRFGDRGDRGDRGDRGDRG M E 0 mcachi', '34', 'http://127.0.0.1:4001/api/v1/asistencia/34', '127.0.0.1', '2023-11-16 06:17:16', 'mcachi'),
(127, NULL, 'DELETE USR', 'DRFGDRGDRGDRGDRGDRG', '47', 'http://127.0.0.1:4001/api/v1/employes/47', '127.0.0.1', '2023-11-16 06:17:20', 'mcachi'),
(128, NULL, 'REG USR', NULL, 'RegisterEmployerRequest(name=PERSONAL i, document=65464868, area_id=4, jornada_id=4, horario_id=1, dateInit=2023-10-30, dateEnd=2023-12-08, c_salary=10000.0, role=USR)', 'http://127.0.0.1:4001/api/v1/employes', '127.0.0.1', '2023-11-16 06:22:35', 'mcachi'),
(129, NULL, 'DELETE HORARIO', 'Horario(id=6, hour_in=09:00, hour_out=16:00, tolerancia=10, created_at=2023-10-24T16:39:07, updated_at=2023-11-12T17:10:56, user_created=, user_updated=mcachi)', '6', 'http://127.0.0.1:4001/api/v1/horarios/6', '127.0.0.1', '2023-11-16 06:22:51', 'mcachi'),
(130, NULL, 'CLEAR LOG LOGIN', NULL, NULL, 'http://127.0.0.1:4001/api/v1/log/logins', '127.0.0.1', '2023-11-16 06:28:22', 'mcachi'),
(131, NULL, 'CLEAR LOG LOGIN', NULL, NULL, 'http://127.0.0.1:4001/api/v1/log/logins', '127.0.0.1', '2023-11-16 06:28:57', 'mcachi'),
(132, NULL, 'CLEAR LOG LOGIN', NULL, NULL, 'http://127.0.0.1:4001/api/v1/log/logins', '127.0.0.1', '2023-11-16 06:29:11', 'mcachi'),
(133, NULL, 'REG TIPO CONTRATO', NULL, 'RegisterTypeContratoRequest(name=fhgfhfh)', 'http://127.0.0.1:4001/api/v1/typecontratos', '127.0.0.1', '2023-11-16 06:31:52', 'mcachi'),
(134, NULL, 'DELETE TIPO CONTRATO', 'TypeContrato(id=6, name=fhgfhfh)', '6', 'http://127.0.0.1:4001/api/v1/typecontratos/6', '127.0.0.1', '2023-11-16 06:32:25', 'mcachi');

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
(1, 'ESTABLE'),
(3, 'TEMPORAL'),
(4, 'CAMPAÑA');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `area_id` bigint(20) UNSIGNED DEFAULT NULL,
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

INSERT INTO `users` (`id`, `area_id`, `role`, `code`, `name`, `document`, `username`, `password`, `status`, `created_at`, `updated_at`) VALUES
(1, NULL, 'ADMIN', '1234', 'ADMINISTRADOR', '99999999', 'mcachi', '$2a$10$471mL5gYdbFWQRT4WF/2zOvkik7HNu/.WXtsnh6LXHeodVmUPL42K', 1, '2023-10-19 03:07:44', '2023-11-13 03:14:31'),
(52, 4, 'USR', '2767', 'PERSONAL I', '65464868', '65464868', '$2a$10$Iw..1/W8Xqv5dWewljscz..7id1NSoRk1B8X/Zs8kuweKAD3F9L3q', 1, '2023-11-16 06:22:35', NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `areas`
--
ALTER TABLE `areas`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `contratos`
--
ALTER TABLE `contratos`
  ADD PRIMARY KEY (`id`),
  ADD KEY `type_contrato_id` (`type_contrato_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `horario_id` (`horario_id`);

--
-- Indices de la tabla `horarios`
--
ALTER TABLE `horarios`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `in_out_users_at`
--
ALTER TABLE `in_out_users_at`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

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
  ADD UNIQUE KEY `UKr43af9ap4edm43mmtq01oddj6` (`username`),
  ADD UNIQUE KEY `document` (`document`),
  ADD UNIQUE KEY `UKgn31mv5j1hsjp47mbmonwbo9w` (`username`,`document`),
  ADD KEY `area_id` (`area_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `areas`
--
ALTER TABLE `areas`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `contratos`
--
ALTER TABLE `contratos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT de la tabla `horarios`
--
ALTER TABLE `horarios`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `in_out_users_at`
--
ALTER TABLE `in_out_users_at`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT de la tabla `log_logins`
--
ALTER TABLE `log_logins`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `log_updates`
--
ALTER TABLE `log_updates`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=135;

--
-- AUTO_INCREMENT de la tabla `types_contratos`
--
ALTER TABLE `types_contratos`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `contratos`
--
ALTER TABLE `contratos`
  ADD CONSTRAINT `contratos_ibfk_1` FOREIGN KEY (`type_contrato_id`) REFERENCES `types_contratos` (`id`),
  ADD CONSTRAINT `contratos_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `contratos_ibfk_3` FOREIGN KEY (`horario_id`) REFERENCES `horarios` (`id`) ON DELETE SET NULL ON UPDATE SET NULL;

--
-- Filtros para la tabla `in_out_users_at`
--
ALTER TABLE `in_out_users_at`
  ADD CONSTRAINT `in_out_users_at_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION;

--
-- Filtros para la tabla `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`area_id`) REFERENCES `areas` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
