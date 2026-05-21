/**
 * app.js — Lógica principal del dashboard SGCP
 */

// ── Guardia de sesión ─────────────────────────────────────
if (!Auth.isLoggedIn()) window.location.href = 'index.html';
document.getElementById('logoutBtn').addEventListener('click', Auth.logout);

// ── Navegación por tabs ───────────────────────────────────
document.getElementById('navTabs').addEventListener('click', (e) => {
  const btn = e.target.closest('.tab-btn');
  if (!btn) return;
  document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
  document.querySelectorAll('.section').forEach(s => s.classList.remove('active'));
  btn.classList.add('active');
  document.getElementById(`sec-${btn.dataset.section}`).classList.add('active');
  loadSection(btn.dataset.section);
});

// ── Modal genérico ────────────────────────────────────────
const modal       = document.getElementById('modal');
const modalTitle  = document.getElementById('modalTitle');
const modalForm   = document.getElementById('modalForm');
const modalError  = document.getElementById('modalError');
const modalSubmit = document.getElementById('modalSubmit');

function openModal(title, fields, onSubmit) {
  modalTitle.textContent = title;
  modalError.classList.add('hidden');
  modalForm.innerHTML = fields.map(f => fieldHtml(f)).join('');
  modalSubmit.onclick = async () => {
    modalError.classList.add('hidden');
    const data = collectForm(fields);
    const err = await onSubmit(data);
    if (err) { modalError.textContent = err; modalError.classList.remove('hidden'); }
    else closeModal();
  };
  modal.classList.remove('hidden');
}

function closeModal() { modal.classList.add('hidden'); }
document.getElementById('modalClose').onclick  = closeModal;
document.getElementById('modalCancel').onclick = closeModal;
modal.addEventListener('click', e => { if (e.target === modal) closeModal(); });

function fieldHtml({ name, label, type = 'text', value = '', options }) {
  if (options) {
    const opts = options.map(o =>
      `<option value="${o.value}" ${String(o.value) === String(value) ? 'selected' : ''}>${o.label}</option>`
    ).join('');
    return `<div class="field"><label>${label}</label><select name="${name}">${opts}</select></div>`;
  }
  if (type === 'textarea')
    return `<div class="field"><label>${label}</label><textarea name="${name}">${value}</textarea></div>`;
  return `<div class="field"><label>${label}</label>
    <input name="${name}" type="${type}" value="${value ?? ''}" /></div>`;
}

function collectForm(fields) {
  const fd = new FormData(modalForm);
  const out = {};
  fields.forEach(f => { out[f.name] = fd.get(f.name) ?? ''; });
  return out;
}

// ── Tabla genérica ────────────────────────────────────────
function renderTable(containerId, columns, rows, onEdit, onDelete) {
  const wrap = document.getElementById(containerId);
  if (!rows.length) {
    wrap.innerHTML = '<p class="empty-msg">Sin registros.</p>';
    return;
  }
  const heads = columns.map(c => `<th>${c.label}</th>`).join('') + '<th>Acciones</th>';
  const body  = rows.map(row => {
    const cells = columns.map(c => {
      const val = row[c.key] ?? '—';
      if (c.key === 'status')
        return `<td><span class="badge ${val === 'active' ? 'badge-active' : 'badge-inactive'}">${val}</span></td>`;
      return `<td>${val}</td>`;
    }).join('');
    return `<tr>${cells}
      <td><div class="actions">
        <button class="btn-edit" data-id="${row.id}">Editar</button>
        <button class="btn-del"  data-id="${row.id}">Eliminar</button>
      </div></td></tr>`;
  }).join('');

  wrap.innerHTML = `<div class="table-wrap"><table><thead><tr>${heads}</tr></thead><tbody>${body}</tbody></table></div>`;
  wrap.querySelectorAll('.btn-edit').forEach(b => b.onclick = () => onEdit(Number(b.dataset.id), rows));
  wrap.querySelectorAll('.btn-del').forEach(b  => b.onclick = () => onDelete(Number(b.dataset.id)));
}

async function confirmDelete(endpoint, id, reload) {
  if (!confirm('¿Eliminar este registro?')) return;
  const res = await Api.delete(`${endpoint}${id}/`);
  if (res.ok) reload();
  else alert('No se pudo eliminar.');
}

// ════════════════════════════════════════════════════════════
//  SECCIÓN: PELUQUERÍAS
// ════════════════════════════════════════════════════════════
async function loadPeluquerias() {
  const res  = await Api.get('/api/peluquerias/');
  const data = await res.json();
  const rows = data.results ?? data;

  renderTable('tablePeluquerias',
    [{ key:'nombre', label:'Nombre' }, { key:'direccion', label:'Dirección' },
     { key:'telefono', label:'Teléfono' }, { key:'status', label:'Estado' }],
    rows,
    (id, all) => editPeluqueria(all.find(r => r.id === id)),
    (id) => confirmDelete('/api/peluquerias/', id, loadPeluquerias)
  );
}

function peluqueriaFields(p = {}) {
  return [
    { name:'nombre',    label:'Nombre',    value: p.nombre },
    { name:'direccion', label:'Dirección', value: p.direccion },
    { name:'telefono',  label:'Teléfono',  value: p.telefono },
    { name:'descripcion', label:'Descripción', type:'textarea', value: p.descripcion },
    { name:'status', label:'Estado', options:[
      { value:'active', label:'Activo' }, { value:'inactive', label:'Inactivo' }
    ], value: p.status ?? 'active' },
  ];
}

document.getElementById('btnNewPeluqueria').onclick = () =>
  openModal('Nueva Peluquería', peluqueriaFields(), async (data) => {
    const res = await Api.post('/api/peluquerias/', data);
    if (!res.ok) return 'Error al crear la peluquería.';
    loadPeluquerias();
  });

function editPeluqueria(p) {
  openModal('Editar Peluquería', peluqueriaFields(p), async (data) => {
    const res = await Api.put(`/api/peluquerias/${p.id}/`, data);
    if (!res.ok) return 'Error al actualizar.';
    loadPeluquerias();
  });
}

// ════════════════════════════════════════════════════════════
//  SECCIÓN: ESTILISTAS
// ════════════════════════════════════════════════════════════
let _peluquerias = [];
async function getPeluquerias() {
  if (_peluquerias.length) return _peluquerias;
  const r = await Api.get('/api/peluquerias/?page_size=100');
  const d = await r.json();
  _peluquerias = d.results ?? d;
  return _peluquerias;
}

async function loadEstilistas() {
  const [res, salones] = await Promise.all([Api.get('/api/estilistas/'), getPeluquerias()]);
  const rows = (await res.json()).results ?? await res.json();
  const salonMap = Object.fromEntries(salones.map(s => [s.id, s.nombre]));

  renderTable('tableEstilistas',
    [{ key:'nombre', label:'Nombre' }, { key:'especialidad', label:'Especialidad' },
     { key:'telefono', label:'Teléfono' }, { key:'hair_salon_name', label:'Peluquería' },
     { key:'status', label:'Estado' }],
    rows.map(r => ({ ...r, hair_salon_name: salonMap[r.hair_salon] ?? r.hair_salon })),
    (id, all) => editEstilista(all.find(r => r.id === id), salones),
    (id) => confirmDelete('/api/estilistas/', id, loadEstilistas)
  );
}

async function loadEstilistasSection() {
  const salones = await getPeluquerias();
  const res = await Api.get('/api/estilistas/');
  const data = await res.json();
  const rows = data.results ?? data;
  const salonMap = Object.fromEntries(salones.map(s => [s.id, s.nombre]));

  renderTable('tableEstilistas',
    [{ key:'nombre', label:'Nombre' }, { key:'especialidad', label:'Especialidad' },
     { key:'telefono', label:'Teléfono' }, { key:'hair_salon_name', label:'Peluquería' },
     { key:'status', label:'Estado' }],
    rows.map(r => ({ ...r, hair_salon_name: salonMap[r.hair_salon] ?? r.hair_salon })),
    (id, all) => editEstilista(rows.find(r => r.id === id), salones),
    (id) => confirmDelete('/api/estilistas/', id, loadEstilistasSection)
  );

  document.getElementById('btnNewEstilista').onclick = () => {
    openModal('Nuevo Estilista', estilistaFields({}, salones), async (data) => {
      const res = await Api.post('/api/estilistas/', data);
      if (!res.ok) return 'Error al crear el estilista.';
      _peluquerias = [];
      loadEstilistasSection();
    });
  };
}

function estilistaFields(e = {}, salones = []) {
  return [
    { name:'nombre',      label:'Nombre',      value: e.nombre },
    { name:'telefono',    label:'Teléfono',    value: e.telefono },
    { name:'especialidad',label:'Especialidad',value: e.especialidad },
    { name:'hair_salon',  label:'Peluquería', options: salones.map(s => ({ value: s.id, label: s.nombre })), value: e.hair_salon },
    { name:'status', label:'Estado', options:[
      { value:'active', label:'Activo' }, { value:'inactive', label:'Inactivo' }
    ], value: e.status ?? 'active' },
  ];
}

function editEstilista(e, salones) {
  openModal('Editar Estilista', estilistaFields(e, salones), async (data) => {
    const res = await Api.put(`/api/estilistas/${e.id}/`, data);
    if (!res.ok) return 'Error al actualizar.';
    loadEstilistasSection();
  });
}

// ════════════════════════════════════════════════════════════
//  SECCIÓN: SERVICIOS
// ════════════════════════════════════════════════════════════
async function loadServicios() {
  const [res, salones] = await Promise.all([Api.get('/api/servicios/'), getPeluquerias()]);
  const data = await res.json();
  const rows = data.results ?? data;
  const salonMap = Object.fromEntries(salones.map(s => [s.id, s.nombre]));

  renderTable('tableServicios',
    [{ key:'nombre', label:'Nombre' }, { key:'precio', label:'Precio (S/)' },
     { key:'duracion_minutos', label:'Duración (min)' },
     { key:'hair_salon_name', label:'Peluquería' }, { key:'status', label:'Estado' }],
    rows.map(r => ({ ...r, hair_salon_name: salonMap[r.hair_salon] ?? r.hair_salon })),
    (id, all) => editServicio(rows.find(r => r.id === id), salones),
    (id) => confirmDelete('/api/servicios/', id, loadServicios)
  );

  document.getElementById('btnNewServicio').onclick = () =>
    openModal('Nuevo Servicio', servicioFields({}, salones), async (data) => {
      const res = await Api.post('/api/servicios/', { ...data, precio: parseFloat(data.precio), duracion_minutos: parseInt(data.duracion_minutos) });
      if (!res.ok) return 'Error al crear el servicio.';
      loadServicios();
    });
}

function servicioFields(s = {}, salones = []) {
  return [
    { name:'nombre',           label:'Nombre',              value: s.nombre },
    { name:'descripcion',      label:'Descripción',         type:'textarea', value: s.descripcion },
    { name:'precio',           label:'Precio (S/)',         type:'number',  value: s.precio },
    { name:'duracion_minutos', label:'Duración (minutos)',  type:'number',  value: s.duracion_minutos },
    { name:'hair_salon',       label:'Peluquería', options: salones.map(s => ({ value: s.id, label: s.nombre })), value: s.hair_salon },
    { name:'status', label:'Estado', options:[
      { value:'active', label:'Activo' }, { value:'inactive', label:'Inactivo' }
    ], value: s.status ?? 'active' },
  ];
}

function editServicio(s, salones) {
  openModal('Editar Servicio', servicioFields(s, salones), async (data) => {
    const res = await Api.put(`/api/servicios/${s.id}/`, { ...data, precio: parseFloat(data.precio), duracion_minutos: parseInt(data.duracion_minutos) });
    if (!res.ok) return 'Error al actualizar.';
    loadServicios();
  });
}

// ════════════════════════════════════════════════════════════
//  SECCIÓN: USUARIOS
// ════════════════════════════════════════════════════════════
async function loadUsuarios() {
  const res  = await Api.get('/api/usuarios/');
  const data = await res.json();
  const rows = data.results ?? data;

  renderTable('tableUsuarios',
    [{ key:'nombre', label:'Nombre' }, { key:'email', label:'Email' },
     { key:'rol', label:'Rol' }, { key:'status', label:'Estado' }],
    rows,
    (id, all) => editUsuario(all.find(r => r.id === id)),
    (id) => confirmDelete('/api/usuarios/', id, loadUsuarios)
  );

  document.getElementById('btnNewUsuario').onclick = () =>
    openModal('Nuevo Usuario', usuarioFields(), async (data) => {
      const res = await Api.post('/api/usuarios/', data);
      if (!res.ok) return 'Error al crear el usuario.';
      loadUsuarios();
    });
}

function usuarioFields(u = {}) {
  return [
    { name:'nombre',    label:'Nombre',    value: u.nombre },
    { name:'email',     label:'Email',     type:'email', value: u.email },
    { name:'contraseña',label:'Contraseña',type:'password', value: '' },
    { name:'telefono',  label:'Teléfono',  value: u.telefono },
    { name:'rol', label:'Rol', options:[
      { value:'cliente', label:'Cliente' },
      { value:'recepcionista', label:'Recepcionista' },
      { value:'administrador', label:'Administrador' },
    ], value: u.rol ?? 'cliente' },
    { name:'status', label:'Estado', options:[
      { value:'active', label:'Activo' }, { value:'inactive', label:'Inactivo' }
    ], value: u.status ?? 'active' },
  ];
}

function editUsuario(u) {
  openModal('Editar Usuario', usuarioFields(u), async (data) => {
    if (!data.contraseña) delete data.contraseña;
    const res = await Api.put(`/api/usuarios/${u.id}/`, data);
    if (!res.ok) return 'Error al actualizar.';
    loadUsuarios();
  });
}

// ════════════════════════════════════════════════════════════
//  SECCIÓN: CITAS
// ════════════════════════════════════════════════════════════
async function loadCitas() {
  const [resCitas, resEstilistas, resServicios, resUsuarios] = await Promise.all([
    Api.get('/api/citas/'), Api.get('/api/estilistas/'),
    Api.get('/api/servicios/'), Api.get('/api/usuarios/'),
  ]);
  const citas      = (await resCitas.json()).results      ?? await resCitas.json();
  const estilistas = (await resEstilistas.json()).results ?? await resEstilistas.json();
  const servicios  = (await resServicios.json()).results  ?? await resServicios.json();
  const usuarios   = (await resUsuarios.json()).results   ?? await resUsuarios.json();

  const estMap = Object.fromEntries(estilistas.map(e => [e.id, e.nombre]));
  const srvMap = Object.fromEntries(servicios.map(s => [s.id, s.nombre]));
  const usrMap = Object.fromEntries(usuarios.map(u => [u.id, u.nombre]));

  renderTable('tableCitas',
    [{ key:'fecha', label:'Fecha' }, { key:'hora_inicio', label:'Inicio' },
     { key:'hora_fin', label:'Fin' }, { key:'usuario_name', label:'Cliente' },
     { key:'estilista_name', label:'Estilista' }, { key:'servicio_name', label:'Servicio' },
     { key:'estado', label:'Estado' }],
    citas.map(c => ({
      ...c,
      usuario_name:  usrMap[c.user] ?? c.user,
      estilista_name: estMap[c.stylist] ?? c.stylist,
      servicio_name:  srvMap[c.service] ?? c.service,
    })),
    (id, all) => editCita(citas.find(c => c.id === id), usuarios, estilistas, servicios),
    (id) => confirmDelete('/api/citas/', id, loadCitas)
  );

  document.getElementById('btnNewCita').onclick = () =>
    openModal('Nueva Cita', citaFields({}, usuarios, estilistas, servicios), async (data) => {
      const res = await Api.post('/api/citas/', data);
      if (!res.ok) return 'Verifica que los datos sean correctos (horarios, duración del servicio, etc.)';
      loadCitas();
    });
}

function citaFields(c = {}, usuarios = [], estilistas = [], servicios = []) {
  return [
    { name:'user',    label:'Cliente',   options: usuarios.map(u => ({ value: u.id, label: u.nombre })), value: c.user },
    { name:'stylist', label:'Estilista', options: estilistas.map(e => ({ value: e.id, label: e.nombre })), value: c.stylist },
    { name:'service', label:'Servicio',  options: servicios.map(s => ({ value: s.id, label: `${s.nombre} (${s.duracion_minutos} min)` })), value: c.service },
    { name:'fecha',       label:'Fecha',         type:'date', value: c.fecha },
    { name:'hora_inicio', label:'Hora inicio',   type:'time', value: c.hora_inicio },
    { name:'hora_fin',    label:'Hora fin',      type:'time', value: c.hora_fin },
    { name:'estado', label:'Estado', options:[
      { value:'pendiente',  label:'Pendiente' },
      { value:'confirmada', label:'Confirmada' },
      { value:'completada', label:'Completada' },
      { value:'cancelada',  label:'Cancelada' },
    ], value: c.estado ?? 'pendiente' },
    { name:'observaciones', label:'Observaciones', type:'textarea', value: c.observaciones },
    { name:'status', label:'Status', options:[
      { value:'active', label:'Activo' }, { value:'inactive', label:'Inactivo' }
    ], value: c.status ?? 'active' },
  ];
}

function editCita(c, usuarios, estilistas, servicios) {
  openModal('Editar Cita', citaFields(c, usuarios, estilistas, servicios), async (data) => {
    const res = await Api.put(`/api/citas/${c.id}/`, data);
    if (!res.ok) return 'Error al actualizar la cita.';
    loadCitas();
  });
}

// ════════════════════════════════════════════════════════════
//  SECCIÓN: HORARIOS DE ESTILISTAS
// ════════════════════════════════════════════════════════════
async function loadHorarios() {
  const [resH, resE] = await Promise.all([Api.get('/api/horarios/'), Api.get('/api/estilistas/')]);
  const horarios   = (await resH.json()).results ?? await resH.json();
  const estilistas = (await resE.json()).results ?? await resE.json();
  const estMap = Object.fromEntries(estilistas.map(e => [e.id, e.nombre]));

  renderTable('tableHorarios',
    [{ key:'estilista_name', label:'Estilista' }, { key:'dia_semana', label:'Día' },
     { key:'hora_inicio', label:'Inicio' }, { key:'hora_fin', label:'Fin' },
     { key:'activo', label:'Activo' }, { key:'status', label:'Estado' }],
    horarios.map(h => ({ ...h, estilista_name: estMap[h.stylist] ?? h.stylist, activo: h.activo ? 'Sí' : 'No' })),
    (id, all) => editHorario(horarios.find(h => h.id === id), estilistas),
    (id) => confirmDelete('/api/horarios/', id, loadHorarios)
  );

  document.getElementById('btnNewHorario').onclick = () =>
    openModal('Nuevo Horario', horarioFields({}, estilistas), async (data) => {
      const res = await Api.post('/api/horarios/', { ...data, activo: data.activo === 'true' });
      if (!res.ok) return 'Error al crear el horario.';
      loadHorarios();
    });
}

const DIAS = ['lunes','martes','miércoles','jueves','viernes','sábado','domingo'];

function horarioFields(h = {}, estilistas = []) {
  return [
    { name:'stylist', label:'Estilista', options: estilistas.map(e => ({ value: e.id, label: e.nombre })), value: h.stylist },
    { name:'dia_semana', label:'Día', options: DIAS.map(d => ({ value: d, label: d.charAt(0).toUpperCase() + d.slice(1) })), value: h.dia_semana },
    { name:'hora_inicio', label:'Hora inicio', type:'time', value: h.hora_inicio },
    { name:'hora_fin',    label:'Hora fin',    type:'time', value: h.hora_fin },
    { name:'activo', label:'Activo', options:[
      { value:'true', label:'Sí' }, { value:'false', label:'No' }
    ], value: String(h.activo ?? 'true') },
    { name:'status', label:'Estado', options:[
      { value:'active', label:'Activo' }, { value:'inactive', label:'Inactivo' }
    ], value: h.status ?? 'active' },
  ];
}

function editHorario(h, estilistas) {
  openModal('Editar Horario', horarioFields(h, estilistas), async (data) => {
    const res = await Api.put(`/api/horarios/${h.id}/`, { ...data, activo: data.activo === 'true' });
    if (!res.ok) return 'Error al actualizar el horario.';
    loadHorarios();
  });
}

// ════════════════════════════════════════════════════════════
//  DISPATCHER — carga la sección activa
// ════════════════════════════════════════════════════════════
const loaders = {
  peluquerias: loadPeluquerias,
  estilistas:  loadEstilistasSection,
  servicios:   loadServicios,
  usuarios:    loadUsuarios,
  citas:       loadCitas,
  horarios:    loadHorarios,
};

function loadSection(name) {
  loaders[name]?.();
}

// Carga inicial
loadPeluquerias();
