# Desarrollo de ISP Control

## Ramas
- `Master`: estable; no desarrollar directamente.
- `develop`: integración.
- `feature/HU-XXX-descripcion`: implementación aislada.

Abrir PR desde feature a develop y desde develop a Master para releases.

## Etapa 1: Fundamentos
- [ ] [HU-001](https://github.com/fabianvs1997/isp-control/issues/1) — CI y ejecución local
- [ ] [HU-002](https://github.com/fabianvs1997/isp-control/issues/2) — modelo y migraciones
- [ ] [HU-003](https://github.com/fabianvs1997/isp-control/issues/3) — autenticación y roles
- [ ] [HU-004](https://github.com/fabianvs1997/isp-control/issues/4) — planes comerciales

## Reglas
1. Prohibido publicar datos personales de clientes en GitHub.
2. No incorporar claves, tokens o archivos .env al repositorio.
3. Cada PR debe describir cambios, pruebas y riesgos.
4. No fusionar cambios si fallan compilación o pruebas.
5. No utilizar información real hasta implementar autenticación, respaldos y auditoría.

## Ejecución local
Desde raíz: `docker compose up -d`.
Backend: `cd backend && mvn spring-boot:run`.
Frontend: `cd frontend && npm install && npm run dev`.
