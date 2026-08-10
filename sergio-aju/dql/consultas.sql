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