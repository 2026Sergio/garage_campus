USE campuslands_mysql;

-- Metemos 5 clientes de prueba
INSERT INTO clientes (nombre, telefono, email, estado) VALUES
('Carlos Mendoza', '5551-2345', 'carlos.mendoza@email.com', 'activo'),
('Sofía Ramírez', '5552-3456', 'sofia.ramirez@email.com', 'activo'),
('Alejandro Castillo', '5553-4567', 'alejandro.castillo@email.com', 'activo'),
('Valeria Gomez', '5554-5678', 'valeria.gomez@email.com', 'activo'),
('Mateo Fernández', '5555-6789', 'mateo.fernandez@email.com', 'activo');

-- Metemos 7 vehículos bien calida para los clientes
INSERT INTO vehiculos (cliente_id, tipo, marca, modelo, placa, anio) VALUES
(1, 'moto_alto_cilindraje', 'Yamaha', 'YZF-R1', 'M-789XYZ', 2024),
(1, 'auto_lujo', 'Porsche', '911 Carrera', 'P-123ABC', 2023),
(2, 'hiperdeportivo', 'Bugatti', 'Chiron', 'H-999ZZZ', 2022),
(3, 'moto_alto_cilindraje', 'Ducati', 'Panigale V4', 'M-456DEF', 2025),
(4, 'auto_lujo', 'Mercedes-Benz', 'AMG GT', 'P-789GHI', 2023),
(5, 'hiperdeportivo', 'Ferrari', 'SF90 Stradale', 'H-111AAA', 2024),
(5, 'moto_alto_cilindraje', 'BMW', 'S1000RR', 'M-321BBB', 2024);

-- 4 mecánicos 
INSERT INTO mecanicos (nombre, especialidad, activo) VALUES
('Esteban Quito', 'Motores de Alta Competición', 1),
('Mariana V8', 'Sistemas Electrónicos y ECU', 1),
('Roberto Bielas', 'Transmisiones y Frenos Carbocerámicos', 1),
('Lucas Pistón', 'Diagnóstico General de Pista', 0); 


-- 5 servicios 
INSERT INTO servicios (nombre, categoria, precio_base, duracion_min) VALUES
('Overhaul de Motor', 'Mecánica Mayor', 1500.00, 240),
('Alineación Dinámica de Suspensión', 'Pista', 450.00, 90),
('Mantenimiento Preventivo Desmo', 'Motos', 350.00, 120),
('Cambio de Frenos Carbocerámicos', 'Seguridad', 1200.00, 180),
('Diagnóstico Computarizado y Telemetría', 'Electrónica', 250.00, 60);
