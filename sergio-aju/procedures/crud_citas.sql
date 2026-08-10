USE campuslands_mysql;

DELIMITER //

-- ==========================================================
-- 1. CREAR CITA (CREATE)
-- ==========================================================
DROP PROCEDURE IF EXISTS sp_crear_cita_servicio//
CREATE PROCEDURE sp_crear_cita_servicio(
    IN p_vehiculo_id INT,
    IN p_servicio_id INT,
    IN p_mecanico_id INT,
    IN p_fecha_programada DATETIME,
    IN p_precio_final DECIMAL(10,2),
    IN p_notas VARCHAR(255),
    OUT p_cita_id INT
)
BEGIN
    IF p_precio_final < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de negocio: El precio final no puede ser negativo.';
    END IF;

    IF p_fecha_programada IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de negocio: La fecha programada no puede ser nula.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM vehiculos WHERE id = p_vehiculo_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de negocio: El vehículo especificado no existe.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM servicios WHERE id = p_servicio_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de negocio: El servicio especificado no existe.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM mecanicos WHERE id = p_mecanico_id AND activo = 1) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de negocio: El mecánico no existe o se encuentra inactivo.';
    END IF;

    INSERT INTO citas_servicio (
        vehiculo_id, servicio_id, mecanico_id, fecha_programada,
        estado, precio_final, notas
    ) VALUES (
        p_vehiculo_id, p_servicio_id, p_mecanico_id, p_fecha_programada,
        'pendiente', p_precio_final, p_notas
    );

    SET p_cita_id = LAST_INSERT_ID();
END//

-- ==========================================================
-- 2. LISTAR CITAS (READ)
-- ==========================================================
DROP PROCEDURE IF EXISTS sp_listar_citas_servicio//
CREATE PROCEDURE sp_listar_citas_servicio(
    IN p_estado VARCHAR(20)
)
BEGIN
    IF p_estado = '' THEN
        SET p_estado = NULL;
    END IF;

    SELECT 
        c.id AS id_cita,
        cl.nombre AS cliente,
        CONCAT(v.marca, ' ', v.modelo, ' (', v.placa, ')') AS vehiculo,
        s.nombre AS servicio,
        m.nombre AS mecanico,
        c.fecha_programada,
        c.estado,
        c.precio_final,
        c.notas
    FROM citas_servicio c
    JOIN vehiculos v ON c.vehiculo_id = v.id
    JOIN clientes cl ON v.cliente_id = cl.id
    JOIN servicios s ON c.servicio_id = s.id
    JOIN mecanicos m ON c.mecanico_id = m.id
    WHERE (p_estado IS NULL OR c.estado = p_estado)
    ORDER BY c.fecha_programada ASC;
END//

-- ==========================================================
-- 3. ACTUALIZAR CITA (UPDATE)
-- ==========================================================
DROP PROCEDURE IF EXISTS sp_actualizar_cita_servicio//
CREATE PROCEDURE sp_actualizar_cita_servicio(
    IN p_cita_id INT,
    IN p_mecanico_id INT,
    IN p_fecha_programada DATETIME,
    IN p_estado VARCHAR(20),
    IN p_precio_final DECIMAL(10,2),
    IN p_notas VARCHAR(255)
)
BEGIN
    DECLARE v_estado_actual VARCHAR(20);

    IF NOT EXISTS (SELECT 1 FROM citas_servicio WHERE id = p_cita_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de negocio: La cita de servicio especificada no existe.';
    END IF;

    SELECT estado INTO v_estado_actual FROM citas_servicio WHERE id = p_cita_id;
    IF v_estado_actual = 'cancelada' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de negocio: No se puede actualizar una cita que se encuentra cancelada.';
    END IF;

    IF p_estado NOT IN ('pendiente', 'en_proceso', 'completada', 'cancelada') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de negocio: El estado proporcionado no es válido.';
    END IF;

    IF p_precio_final < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de negocio: El precio final no puede ser negativo.';
    END IF;

    -- (Aquí estaba el error de dedo anterior, ya corregido)
    IF NOT EXISTS (SELECT 1 FROM mecanicos WHERE id = p_mecanico_id AND activo = 1) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de negocio: El mecánico seleccionado no está activo.';
    END IF;

    START TRANSACTION;

    UPDATE citas_servicio
    SET mecanico_id = p_mecanico_id,
        fecha_programada = p_fecha_programada,
        estado = p_estado,
        precio_final = p_precio_final,
        notas = p_notas
    WHERE id = p_cita_id;

    COMMIT;
END//

-- ==========================================================
-- 4. CANCELAR CITA
-- ==========================================================
DROP PROCEDURE IF EXISTS sp_cancelar_cita_servicio//
CREATE PROCEDURE sp_cancelar_cita_servicio(
    IN p_cita_id INT,
    IN p_motivo_cancelacion VARCHAR(255)
)
BEGIN
    DECLARE v_estado_actual VARCHAR(20);

    IF NOT EXISTS (SELECT 1 FROM citas_servicio WHERE id = p_cita_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de negocio: La cita no existe.';
    END IF;

    SELECT estado INTO v_estado_actual FROM citas_servicio WHERE id = p_cita_id;

    IF v_estado_actual = 'completada' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de negocio: No se puede cancelar una cita que ya fue completada.';
    END IF;

    UPDATE citas_servicio
    SET estado = 'cancelada',
        notas = CONCAT(COALESCE(notas, ''), ' | Cancelada: ', p_motivo_cancelacion)
    WHERE id = p_cita_id;
END//

-- ==========================================================
-- 5. ELIMINAR BORRADOR
-- ==========================================================
DROP PROCEDURE IF EXISTS sp_eliminar_cita_borrador//
CREATE PROCEDURE sp_eliminar_cita_borrador(
    IN p_cita_id INT
)
BEGIN
    DECLARE v_estado_actual VARCHAR(20);

    IF NOT EXISTS (SELECT 1 FROM citas_servicio WHERE id = p_cita_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de negocio: La cita no existe.';
    END IF;

    SELECT estado INTO v_estado_actual FROM citas_servicio WHERE id = p_cita_id;

    IF v_estado_actual <> 'pendiente' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error de seguridad: Solo se pueden eliminar borradores en estado pendiente. El historial debe conservarse.';
    END IF;

    DELETE FROM citas_servicio WHERE id = p_cita_id;
END//

DELIMITER ;