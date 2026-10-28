# ISP Control

Sistema administrativo para un ISP híbrido (fibra óptica e inalámbrico), diseñado inicialmente para menos de 100 clientes.

## Alcance
- Gestión de clientes, planes, contratos e instalaciones geolocalizadas.
- Cargos y pagos mensuales, reportes administrativos.
- Mapa de instalaciones (sin control de equipos de red).

> Estado: **scaffold inicial**. Solo se incluye un endpoint de salud, esquema inicial de clientes y una pantalla React demostrativa. Los módulos funcionales y la seguridad aún se desarrollarán mediante issues. No utilizar con datos personales reales hasta completar autenticación, permisos, auditoría y respaldo.

## Tecnologías
Java 21, Spring Boot 3.5, Maven, PostgreSQL + PostGIS, Flyway, React, TypeScript, Vite.
Producción futura: Railway + Supabase + Cloudflare Pages; mapas con MapLibre y proveedor de teselas seleccionado por separado.

## Requisitos
Java 21, Maven 3.9+, Node.js 22+, Docker con Compose.

## Desarrollo local
```bash
cp backend/.env.example backend/.env # Solo como referencia: el ejemplo no se carga automáticamente
# Desde la raíz:
docker compose up -d
cd backend && mvn spring-boot:run
# En otra terminal:
cd frontend && npm install && npm run dev
```
Backend: http://localhost:8080/api/v1/health
Frontend: http://localhost:5173

## Arquitectura y roadmap
Consultar `docs/ARCHITECTURE.md` y `docs/BACKLOG.md`.

## Privacidad
No almacenar datos de clientes reales en Git, commits, issues, CSV de ejemplo o pruebas. Nunca subir credenciales de Supabase ni Railway.
