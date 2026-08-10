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
