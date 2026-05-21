/**
 * auth.js — Manejo de tokens JWT en localStorage
 */
const Auth = (() => {
  const KEY_ACCESS  = 'sgcp_access';
  const KEY_REFRESH = 'sgcp_refresh';
  const API_BASE    = 'http://127.0.0.1:8000';

  function isLoggedIn() {
    return !!localStorage.getItem(KEY_ACCESS);
  }

  function getAccess() {
    return localStorage.getItem(KEY_ACCESS);
  }

  async function login(username, password) {
    try {
      const res = await fetch(`${API_BASE}/api/token/`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ username, password }),
      });
      if (!res.ok) return false;
      const data = await res.json();
      localStorage.setItem(KEY_ACCESS,  data.access);
      localStorage.setItem(KEY_REFRESH, data.refresh);
      return true;
    } catch {
      return false;
    }
  }

  async function refresh() {
    const token = localStorage.getItem(KEY_REFRESH);
    if (!token) return false;
    try {
      const res = await fetch(`${API_BASE}/api/token/refresh/`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ refresh: token }),
      });
      if (!res.ok) { logout(); return false; }
      const data = await res.json();
      localStorage.setItem(KEY_ACCESS, data.access);
      return true;
    } catch {
      logout();
      return false;
    }
  }

  function logout() {
    localStorage.removeItem(KEY_ACCESS);
    localStorage.removeItem(KEY_REFRESH);
    window.location.href = 'index.html';
  }

  return { isLoggedIn, getAccess, login, refresh, logout };
})();
