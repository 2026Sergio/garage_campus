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


-- 10 citas iniciales para tener con qué jugar en los reportes
INSERT INTO citas_servicio (vehiculo_id, servicio_id, mecanico_id, fecha_programada, estado, precio_final, notas) VALUES
(1, 3, 1, '2026-08-10 09:00:00', 'pendiente', 350.00, 'Revisión general previa a rodada'),
(2, 2, 2, '2026-08-10 11:30:00', 'en_proceso', 450.00, 'Ajuste de caída para circuito'),
(3, 1, 3, '2026-08-11 08:00:00', 'pendiente', 1500.00, 'Mantenimiento preventivo mayor'),
(4, 3, 1, '2026-08-11 14:00:00', 'pendiente', 380.00, 'Cambio de aceite y filtros de alto rendimiento'),
(5, 4, 3, '2026-08-12 10:00:00', 'completada', 1200.00, 'Sustitución de pastillas de freno'),
(6, 1, 3, '2026-08-12 15:00:00', 'en_proceso', 1600.00, 'Revisión de turbos'),
(7, 3, 1, '2026-08-13 09:30:00', 'pendiente', 350.00, 'Ajuste de cadena y embrague'),
(1, 5, 2, '2026-08-05 10:00:00', 'completada', 250.00, 'Lectura de sensores'),
(2, 4, 3, '2026-08-04 11:00:00', 'cancelada', 1200.00, 'Cliente canceló por viaje'),
(3, 5, 2, '2026-08-03 16:00:00', 'completada', 250.00, 'Prueba de telemetría final');

