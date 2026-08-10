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

-- 2. Tabla Vehículos (Con su llave foránea al cliente)
CREATE TABLE vehiculos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    tipo ENUM('moto_alto_cilindraje', 'auto_lujo', 'hiperdeportivo') NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    placa VARCHAR(20) UNIQUE NOT NULL,
    anio INT NOT NULL,
    CONSTRAINT fk_vehiculo_cliente FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. Tabla Mecánicos
CREATE TABLE mecanicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100) NOT NULL,
    activo TINYINT(1) DEFAULT 1
) ENGINE=InnoDB;

-- 4. Tabla Servicios (Catálogo)
CREATE TABLE servicios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    precio_base DECIMAL(10,2) NOT NULL,
    duracion_min INT NOT NULL
) ENGINE=InnoDB;


-- 5. Tabla Citas de Servicio (La que junta todo el poder relacional)
CREATE TABLE citas_servicio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    vehiculo_id INT NOT NULL,
    servicio_id INT NOT NULL,
    mecanico_id INT NOT NULL,
    fecha_programada DATETIME NOT NULL,
    estado ENUM('pendiente', 'en_proceso', 'completada', 'cancelada') DEFAULT 'pendiente',
    precio_final DECIMAL(10,2) NOT NULL,
    notas VARCHAR(255),
    actualizado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_cita_vehiculo FOREIGN KEY (vehiculo_id) REFERENCES vehiculos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cita_servicio FOREIGN KEY (servicio_id) REFERENCES servicios(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_cita_mecanico FOREIGN KEY (mecanico_id) REFERENCES mecanicos(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Índices para que las consultas voladoras de los reportes corran rápido
CREATE INDEX idx_citas_estado ON citas_servicio(estado);
CREATE INDEX idx_citas_fecha ON citas_servicio(fecha_programada);

