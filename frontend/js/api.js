/**
 * api.js — Cliente HTTP que agrega el token JWT y reintenta si expira
 */
const API_BASE = 'http://127.0.0.1:8000';

async function apiFetch(path, options = {}) {
  const headers = {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${Auth.getAccess()}`,
    ...(options.headers || {}),
  };

  let res = await fetch(`${API_BASE}${path}`, { ...options, headers });

  // Token expirado → refrescar y reintentar una vez
  if (res.status === 401) {
    const ok = await Auth.refresh();
    if (!ok) return res;
    headers['Authorization'] = `Bearer ${Auth.getAccess()}`;
    res = await fetch(`${API_BASE}${path}`, { ...options, headers });
  }

  return res;
}

const Api = {
  get:    (path)         => apiFetch(path),
  post:   (path, body)   => apiFetch(path, { method: 'POST',   body: JSON.stringify(body) }),
  put:    (path, body)   => apiFetch(path, { method: 'PUT',    body: JSON.stringify(body) }),
  patch:  (path, body)   => apiFetch(path, { method: 'PATCH',  body: JSON.stringify(body) }),
  delete: (path)         => apiFetch(path, { method: 'DELETE' }),
};
