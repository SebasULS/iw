# SGCP — Sistema de Gestión de Citas para Peluquería

## Autores

| Autor | Rol | Porcentaje |
|-------|-----|------------|
| Davis Arapa Chua | Configuración del proyecto Django y estructura base | 100 % |
| Sebastian Castro Mamani | Restricciones del modelo y pruebas funcionales | 100 % |
| Piero Delgado Chipana | Administración de modelos en Django Admin y coordinación | 100 % |
| Hugo Diaz Chavez | Documentación y evidencias | 100 % |

## Entregables

| Entregable | URL |
|------------|-----|
| Repositorio | https://github.com/Vsrn12/SGCP.git |
| Informe LaTeX | `Informes/informe.tex` |

---

## Descripción del Proyecto

El presente sistema web tiene el objetivo de **automatizar la gestión de citas de una peluquería**.  
El sistema permite:

- Registrar peluquerías, usuarios (clientes, recepcionistas, administradores), estilistas y servicios.
- Gestionar la disponibilidad horaria de cada estilista por día de la semana.
- Reservar citas verificando que no existan cruces de horario para el estilista.
- Validar que el servicio y el estilista pertenezcan a la misma peluquería.
- Exponer una API REST completa protegida con autenticación JWT.
- Administrar todos los recursos desde el panel de Django Admin.

---

## Tecnologías utilizadas

| Tecnología | Versión | Uso |
|------------|---------|-----|
| Python | 3.11+ | Lenguaje principal |
| Django | 6.0.4 | Framework web backend |
| Django REST Framework | 3.17.1 | API RESTful |
| SimpleJWT | 5.5.1 | Autenticación JWT |
| django-cors-headers | 4.7+ | CORS para el frontend |
| SQLite | — | Base de datos local |
| PostgreSQL | 12+ | Base de datos de producción (`backend/db/`) |
| HTML / CSS / JS | — | Frontend estático (consumo de la API) |
| django-extensions | 4.1 | Diagrama ER |
| Git / GitHub | — | Control de versiones |

---

## Estructura del Proyecto

```text
SGCP/
├── README.md
├── requirements.txt              # Dependencias del proyecto
├── backend/
│   └── MyDjangoProyect/
│       ├── manage.py
│       ├── db.sqlite3            # Base de datos local (desarrollo)
│       ├── crear_datos.py        # Script para poblar datos de prueba
│       ├── MyDjangoProyect/      # Configuración global Django
│       │   ├── settings.py
│       │   ├── urls.py           # Rutas principales + JWT
│       │   ├── wsgi.py
│       │   └── asgi.py
│       └── MyWebApps/
│           └── SAC/              # Aplicación principal
│               ├── admin.py      # Registro de modelos en Django Admin
│               ├── serializers.py# Serializadores DRF
│               ├── views.py      # ViewSets de la API
│               ├── migrations/
│               └── models/
│                   ├── __init__.py
│                   ├── base.py         # ModeloAuditable + validar_telefono
│                   ├── peluqueria.py
│                   ├── usuario.py
│                   ├── estilista.py
│                   ├── servicio.py
│                   ├── cita.py
│                   └── horario_estilista.py
├── frontend/
│   ├── index.html                # Pantalla de login
│   ├── dashboard.html            # Dashboard principal (CRUD por sección)
│   ├── css/
│   │   └── style.css             # Estilos globales
│   └── js/
│       ├── auth.js               # Manejo de tokens JWT (localStorage)
│       ├── api.js                # Cliente HTTP con refresco automático
│       └── app.js                # Lógica del dashboard (tabs, tablas, modales)
└── informes/
    └── informe.tex               # Informe técnico en LaTeX
```

---

## Modelo de Datos

### Tablas principales

| Tabla | Modelo Django | Descripción |
|-------|--------------|-------------|
| `hair_salons` | `Peluqueria` | Sede del negocio |
| `users` | `Usuario` | Clientes, recepcionistas y administradores |
| `stylists` | `Estilista` | Personal de atención |
| `services` | `Servicio` | Oferta comercial disponible |
| `appointments` | `Cita` | Reservas de clientes |
| `stylist_schedules` | `HorarioEstilista` | Disponibilidad semanal del estilista |

Todos los modelos heredan de `ModeloAuditable`, que incluye: `id`, `status`, `created`, `modified`, `created_id`, `modified_id`.

### Restricciones implementadas desde el modelo

- Validación de formato de teléfono (mínimo 7 dígitos, caracteres permitidos).
- Encriptación automática de contraseña (`make_password`) antes de guardar.
- Validación del rol permitido para usuarios (`cliente`, `administrador`, `recepcionista`).
- Precio y duración de servicios deben ser mayores que cero.
- `hora_fin` debe ser posterior a `hora_inicio` en citas y horarios.
- Sin cruces de horario para el mismo estilista en la misma fecha.
- El estilista y el servicio de una cita deben pertenecer a la misma peluquería.
- La duración real de la cita debe coincidir con la duración del servicio.

---

## Base de Datos PostgreSQL

El directorio `backend/db/` contiene los archivos SQL para producción:

| Archivo | Descripción |
|---------|-------------|
| `SGCPelu.sql` | Backup completo (estructura + datos de prueba) |
| `peluqueria_db.sql` | Script de creación de tablas |
| `datos_prueba.sql` | Datos de prueba adicionales |

### Importar backup PostgreSQL

```bash
# Crear la base de datos
psql -U postgres -h localhost -c "CREATE DATABASE sgcpelu;"

# Importar backup
psql -U postgres -h localhost -d sgcpelu -f backend/db/SGCPelu.sql

# Verificar tablas
psql -U postgres -h localhost -d sgcpelu -c "\dt"
```

---

## Preparación del Entorno

### 1. Clonar e instalar dependencias

```powershell
git clone https://github.com/Vsrn12/SGCP.git
cd SGCP

cd backend/MyDjangoProyect
python -m venv venv
# Windows
venv\Scripts\Activate.ps1
# Linux/macOS
source venv/bin/activate

pip install -r ../../requirements.txt
```

### 2. Aplicar migraciones

```powershell
python manage.py migrate
```

### 3. Credenciales del superusuario (ya incluido en `db.sqlite3`)

| Campo | Valor |
|-------|-------|
| Usuario | `admin` |
| Contraseña | `123` |

> La base de datos SQLite con el superusuario ya está incluida en el repositorio.

### 3. (Opcional) Poblar datos de prueba

```powershell
python crear_datos.py
```

### 4. Iniciar el servidor

```powershell
python manage.py runserver
```

El servidor queda disponible en `http://127.0.0.1:8000`.

---

## API REST con JWT

### Endpoints disponibles

| Método | URL | Descripción | Auth |
|--------|-----|-------------|------|
| POST | `/api/token/` | Obtener access + refresh token | No |
| POST | `/api/token/refresh/` | Renovar access token | No |
| GET/POST | `/api/peluquerias/` | Listar / crear peluquerías | JWT |
| GET/PUT/DELETE | `/api/peluquerias/{id}/` | Detalle / actualizar / eliminar | JWT |
| GET/POST | `/api/usuarios/` | Listar / crear usuarios | JWT |
| GET/PUT/DELETE | `/api/usuarios/{id}/` | Detalle / actualizar / eliminar | JWT |
| GET/POST | `/api/estilistas/` | Listar / crear estilistas | JWT |
| GET/PUT/DELETE | `/api/estilistas/{id}/` | Detalle / actualizar / eliminar | JWT |
| GET/POST | `/api/servicios/` | Listar / crear servicios | JWT |
| GET/PUT/DELETE | `/api/servicios/{id}/` | Detalle / actualizar / eliminar | JWT |
| GET/POST | `/api/citas/` | Listar / crear citas | JWT |
| GET/PUT/PATCH/DELETE | `/api/citas/{id}/` | Detalle / actualizar / eliminar | JWT |
| GET/POST | `/api/horarios/` | Listar / crear horarios de estilistas | JWT |
| GET/PUT/DELETE | `/api/horarios/{id}/` | Detalle / actualizar / eliminar | JWT |

### Autenticación

```http
POST http://127.0.0.1:8000/api/token/
Content-Type: application/json

{
  "username": "admin",
  "password": "tu_password"
}
```

Respuesta:
```json
{
  "access": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

Usar el `access` token en las siguientes peticiones:
```http
GET http://127.0.0.1:8000/api/peluquerias/
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

Las peticiones sin token retornan `HTTP 401`:
```json
{
  "detail": "Authentication credentials were not provided."
}
```

Las pruebas de la API también están disponibles en [`frontend/app.http`](frontend/app.http) (compatible con VS Code REST Client).

---

## Frontend (HTML/CSS/JS)

El directorio `fronted/` contiene un frontend estático que consume la API REST directamente desde el navegador.

### Archivos

| Archivo | Descripción |
|---------|-------------|
| `index.html` | Pantalla de login con validación JWT |
| `dashboard.html` | Dashboard con tabs por entidad (CRUD completo) |
| `css/style.css` | Estilos: login, navbar, tablas, modales |
| `js/auth.js` | Login, logout, refresco de token, guarda en `localStorage` |
| `js/api.js` | Wrapper de `fetch` que adjunta el Bearer token y reintenta si expira |
| `js/app.js` | Carga tablas, abre modales de creación/edición para cada entidad |
| `app.http` | Colección de pruebas REST (VS Code REST Client) |

### Cómo usarlo

1. Inicia el servidor Django (`python manage.py runserver`).
2. Abre `fronted/index.html` en el navegador (doble clic o `Live Server` de VS Code).
3. Inicia sesión con las credenciales del superusuario.
4. Navega por los tabs para gestionar peluquerías, estilistas, servicios, usuarios, citas y horarios.

> CORS ya está habilitado en Django (`CORS_ALLOW_ALL_ORIGINS = True` en desarrollo).

---

## Generar Diagrama Entidad-Relación

```powershell
cd backend/MyDjangoProyect
python manage.py graph_models SAC -o sac.dot
dot -Tpng sac.dot -o sac.png
```

---

## Panel de Administración

Acceder a `http://127.0.0.1:8000/admin/` con las credenciales del superusuario.  
Todos los modelos están registrados con filtros, búsquedas y visualización de estado.

---

## Rúbrica (Laboratorio)

| Ítem | Puntos | Descripción |
|------|--------|-------------|
| 1. GitHub | 2 | Repositorio con todos los archivos. Se clona. |
| 2. Base de datos | 4 | Django Admin configurado con SQLite/PostgreSQL |
| 3. REST Framework | 4 | Endpoints serializados JSON (CRUD completo) |
| 4. JWT | 4 | Autenticación con SimpleJWT |
| 5. REST Client | 3 | Pruebas con VS Code REST Client (`app.http`) |
| 6. Deploy | 3 | Despliegue en la nube (pendiente) |
| **Total** | **20** | |
