DROP DATABASE IF EXISTS campuslands_mysql;
CREATE DATABASE campuslands_mysql CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE campuslands_mysql;

-- 1. Tabla Clientes
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    estado ENUM('activo', 'inactivo') DEFAULT 'activo',
    creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;


