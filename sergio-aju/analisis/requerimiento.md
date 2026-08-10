# Análisis de Requerimientos - Garage Elite Campus

## Entidades Detectadas
1. **clientes**: Propietarios de los vehículos (motos de alto cilindraje, autos de lujo e hiperdeportivos).
2. **vehiculos**: Unidades mecánicas asociadas a un cliente específico.
3. **mecanicos**: Personal técnico del taller especializado.
4. **servicios**: Catálogo de mantenimientos e intervenciones disponibles.
5. **citas_servicio**: Tabla transaccional que registra las reservas, asignaciones, estados y costos finales.

## Relaciones (Cardinalidad)
* **Un cliente** puede tener **muchos vehículos** (1 a N). Un vehículo pertenece a un solo cliente.
* **Un vehículo** puede tener **muchas citas de servicio** a lo largo del tiempo (1 a N). Una cita pertenece a un solo vehículo.
* **Un mecánico** puede atender **muchas citas de servicio** (1 a N). Una cita es atendida por un solo mecánico.
* **Un servicio** del catálogo puede estar presente en **muchas citas** (1 a N). Una cita corresponde a un servicio específico.

## Reglas de Negocio y Supuestos
* **Estados Controlados**: Las citas solo pueden adoptar los estados: `pendiente`, `en_proceso`, `completada`, `cancelada`.
* **Cancelación Lógica**: No se permite el borrado físico (`DELETE`) de citas históricas o completadas; la cancelación se gestiona actualizando el estado a `cancelada`.
* **Validación de Integridad**: Ningún procedimiento de inserción o actualización permitirá llaves foráneas inexistentes ni precios negativos.
* **Disponibilidad del Personal**: Solo se pueden asignar mecánicos que se encuentren activos (`activo = 1`).