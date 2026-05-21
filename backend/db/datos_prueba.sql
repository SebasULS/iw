-- =========================================================
-- DATOS DE PRUEBA
-- =========================================================

-- =========================================================
-- USERS
-- =========================================================

INSERT INTO users (
    names,
    fatherSurname,
    motherSurname,
    email,
    password,
    phone,
    role,
    status,
    created_id
)
VALUES
(
    'Carlos',
    'Ramirez',
    'Quispe',
    'admin@salsalon.com',
    '123456',
    '987654321',
    'admin',
    'active',
    1
),
(
    'María',
    'Fernandez',
    'Lopez',
    'maria@salsalon.com',
    '123456',
    '912345678',
    'stylist',
    'active',
    1
),
(
    'Lucía',
    'Torres',
    'Mendoza',
    'lucia@salsalon.com',
    '123456',
    '923456789',
    'stylist',
    'active',
    1
),
(
    'José',
    'Gomez',
    'Paredes',
    'jose@gmail.com',
    '123456',
    '934567890',
    'client',
    'active',
    1
),
(
    'Ana',
    'Vargas',
    'Soto',
    'ana@gmail.com',
    '123456',
    '945678901',
    'client',
    'active',
    1
);

-- =========================================================
-- HAIRSALONS
-- =========================================================

INSERT INTO hairSalons (
    name,
    description,
    address,
    city,
    phone,
    email,
    openingHour,
    closingHour,
    status,
    created_id
)
VALUES
(
    'SalSalon Centro',
    'Peluquería moderna especializada en cortes y tintes.',
    'Av. Principal 123',
    'Arequipa',
    '054123456',
    'contacto@salsalon.com',
    '09:00',
    '20:00',
    'active',
    1
),
(
    'SalSalon Norte',
    'Servicios de barbería y estilismo profesional.',
    'Calle Los Olivos 456',
    'Arequipa',
    '054654321',
    'norte@salsalon.com',
    '10:00',
    '21:00',
    'active',
    1
);

-- =========================================================
-- STYLISTS
-- =========================================================

INSERT INTO stylists (
    user_id,
    hairSalon_id,
    specialty,
    experienceYears,
    available,
    status,
    created_id
)
VALUES
(
    2,
    1,
    'Coloración y tintes',
    5,
    TRUE,
    'active',
    1
),
(
    3,
    2,
    'Cortes modernos y peinados',
    3,
    TRUE,
    'active',
    1
);

-- =========================================================
-- SERVICES
-- =========================================================

INSERT INTO services (
    hairSalon_id,
    name,
    description,
    price,
    durationMinutes,
    status,
    created_id
)
VALUES
(
    1,
    'Corte de cabello',
    'Corte moderno personalizado.',
    25.00,
    45,
    'active',
    1
),
(
    1,
    'Tinte completo',
    'Aplicación de tinte profesional.',
    80.00,
    120,
    'active',
    1
),
(
    2,
    'Barbería clásica',
    'Corte y perfilado de barba.',
    35.00,
    60,
    'active',
    1
);

-- =========================================================
-- STYLIST SCHEDULES
-- =========================================================

INSERT INTO stylistSchedules (
    stylist_id,
    weekDay,
    startHour,
    endHour,
    available,
    status,
    created_id
)
VALUES
(
    1,
    'monday',
    '09:00',
    '17:00',
    TRUE,
    'active',
    1
),
(
    1,
    'wednesday',
    '09:00',
    '17:00',
    TRUE,
    'active',
    1
),
(
    2,
    'friday',
    '10:00',
    '18:00',
    TRUE,
    'active',
    1
);

-- =========================================================
-- APPOINTMENTS
-- =========================================================

INSERT INTO appointments (
    user_id,
    stylist_id,
    service_id,
    hairSalon_id,
    appointmentDate,
    startHour,
    endHour,
    status,
    observations,
    created_id
)
VALUES
(
    4,
    1,
    1,
    1,
    '2026-05-10',
    '10:00',
    '10:45',
    'confirmed',
    'Cliente solicita corte degradado.',
    1
),
(
    5,
    2,
    3,
    2,
    '2026-05-11',
    '15:00',
    '16:00',
    'pending',
    'Primera visita del cliente.',
    1
);