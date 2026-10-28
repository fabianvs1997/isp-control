import React from 'react';
import { createRoot } from 'react-dom/client';
import './style.css';

function App() {
  return <main><div className="eyebrow">ISP CONTROL / MVP</div><h1>Administración del ISP</h1><p>Monolito modular · Java 21 · React · PostgreSQL/PostGIS</p><section><h2>Proyecto inicializado</h2><p>Esta pantalla es un placeholder. El registro de clientes, cobranza y mapa se implementarán en las historias del backlog.</p><a href="/api/v1/health" target="_blank" rel="noreferrer">Comprobar API</a></section><small>Sin datos reales. Autenticación pendiente.</small></main>;
}
createRoot(document.getElementById('root')!).render(<React.StrictMode><App/></React.StrictMode>);
