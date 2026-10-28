# Arquitectura MVP

- Usuario (navegador) -> React/Vite -> API REST Java Spring Boot -> PostgreSQL/PostGIS.
- Frontend en Cloudflare Pages; backend en Railway; BD en Supabase (futuro).
- Autenticación: Supabase Auth, JWT validado por Spring Security (HU-003).
- La API administra todos los datos de negocio. No exponer tablas directamente al frontend.
- Módulos: identity, customers, installations, plans, subscriptions, billing, geography, reporting, audit.
- Separar estado administrativo del estado físico real de la red.
- Moneda MXN, campos monetarios `NUMERIC(12,2)`, fecha comercial de Mexico City.
- Los datos geográficos usan `geometry(Point,4326)` e índice GiST.
- Fuera de alcance: routers, OLT, SNMP, suspensiones remotas, CFDI, cobro bancario automático.

## Advertencias actuales
Scaffold NO listo para producción: falta seguridad, autorización por rol, endpoints CRUD, scheduler, validación transaccional de pagos y respaldos automáticos. La extensión PostGIS requiere habilitación/permisos en BD alojada.
