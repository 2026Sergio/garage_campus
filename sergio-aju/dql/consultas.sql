USE campuslands_mysql;

-- 1. Listado de citas pendientes ordenadas por fecha más cercana
SELECT 
    c.id AS cita_id,
    cl.nombre AS cliente,
    CONCAT(v.marca, ' ', v.modelo) AS vehiculo,
    s.nombre AS servicio,
    m.nombre AS mecanico,
    c.fecha_programada,
    c.precio_final
FROM citas_servicio c
JOIN vehiculos v ON c.vehiculo_id = v.id
JOIN clientes cl ON v.cliente_id = cl.id
JOIN servicios s ON c.servicio_id = s.id
JOIN mecanicos m ON c.mecanico_id = m.id
WHERE c.estado = 'pendiente'
ORDER BY c.fecha_programada ASC;

-- 2. Total estimado por estado de cita
SELECT 
    estado,
    COUNT(*) AS total_citas,
    SUM(precio_final) AS acumulado_precio
FROM citas_servicio
GROUP BY estado;

-- 3. Ranking de mecánicos por cantidad de citas atendidas
SELECT 
    m.id AS mecanico_id,
    m.nombre AS mecanico,
    m.especialidad,
    COUNT(c.id) AS total_citas_atendidas
FROM mecanicos m
LEFT JOIN citas_servicio c ON m.id = c.mecanico_id
GROUP BY m.id, m.nombre, m.especialidad
ORDER BY total_citas_atendidas DESC;


-- 4. Vehículos con más de una cita registrada
SELECT 
    v.id AS vehiculo_id,
    CONCAT(v.marca, ' ', v.modelo) AS vehiculo,
    v.placa,
    cl.nombre AS propietario,
    COUNT(c.id) AS total_citas
FROM vehiculos v
JOIN clientes cl ON v.cliente_id = cl.id
JOIN citas_servicio c ON v.id = c.vehiculo_id
GROUP BY v.id, v.placa, cl.nombre
HAVING COUNT(c.id) > 1;


-- 5. Servicios más solicitados y promedio de precio final
SELECT 
    s.id AS servicio_id,
    s.nombre AS servicio,
    s.categoria,
    COUNT(c.id) AS veces_solicitado,
    AVG(c.precio_final) AS promedio_precio_final
FROM servicios s
LEFT JOIN citas_servicio c ON s.id = c.servicio_id
GROUP BY s.id, s.nombre, s.categoria
ORDER BY veces_solicitado DESC;