# HU-002 — PostgreSQL / PostGIS

## Migraciones
- `V1__initial_schema.sql`: modelo inicial publicado. No modificar su checksum.
- `V2__integrity_and_service_areas.sql`: agrega llave compuesta para asegurar que un contrato pertenezca al dueño de la instalación, validación de ubicación, áreas comerciales e índices.

## Invariantes
- Una suscripción no puede referenciar la instalación de otro cliente.
- `charges(subscription_id, period_start)` es único para impedir cargos duplicados.
- Los montos son `NUMERIC(12,2)` y están sujetos a checks.
- Las instalaciones pueden no tener coordenadas, pero toda ubicación guardada debe tener su fuente de precisión.
- `service_areas.boundary` guarda polígonos válidos en SRID 4326.
- HU-010 deberá imponer dentro de una transacción que asignaciones no superen pago/cargo y que el cliente coincida. No se afirma que V2 ya valide estas sumas.

## Validación
Levantar `docker compose up -d` en la raíz, luego `cd backend && mvn verify`.
La CI en la rama de HU-001 necesita fusionarse primero a `develop` para ejecutar pruebas con PostgreSQL en GitHub Actions.
No correr migraciones contra producción sin backup y verificación previa.
