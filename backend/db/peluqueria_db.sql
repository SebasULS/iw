-- =========================================================
-- PROYECTO: SalSalon
-- Sistema Web de Gestión de Citas para Peluquerías
-- Base de Datos: PostgreSQL
-- =========================================================

-- =========================================================
-- TABLA: users
-- =========================================================

CREATE TABLE users (
    id SERIAL PRIMARY KEY,

    names VARCHAR(100) NOT NULL,
    fatherSurname VARCHAR(100) NOT NULL,
    motherSurname VARCHAR(100),

    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,

    phone VARCHAR(20),

    role VARCHAR(20) NOT NULL CHECK (
        role IN ('client', 'admin', 'stylist')
    ),

    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (
        status IN ('active', 'inactive')
    ),

    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    created_id INT NOT NULL,
    modified_id INT
);

-- =========================================================
-- TABLA: hairSalons
-- =========================================================

CREATE TABLE hairSalons (
    id SERIAL PRIMARY KEY,

    name VARCHAR(150) NOT NULL,
    description TEXT,

    address VARCHAR(255) NOT NULL,
    city VARCHAR(100),

    phone VARCHAR(20),
    email VARCHAR(150),

    openingHour TIME,
    closingHour TIME,

    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (
        status IN ('active', 'inactive')
    ),

    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    created_id INT NOT NULL,
    modified_id INT
);

-- =========================================================
-- TABLA: stylists
-- =========================================================

CREATE TABLE stylists (
    id SERIAL PRIMARY KEY,

    user_id INT NOT NULL,
    hairSalon_id INT NOT NULL,

    specialty VARCHAR(100),
    experienceYears INT DEFAULT 0,

    available BOOLEAN DEFAULT TRUE,

    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (
        status IN ('active', 'inactive')
    ),

    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    created_id INT NOT NULL,
    modified_id INT,

    CONSTRAINT fk_stylists_users
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_stylists_hairSalons
        FOREIGN KEY (hairSalon_id)
        REFERENCES hairSalons(id)
        ON DELETE CASCADE
);

-- =========================================================
-- TABLA: services
-- =========================================================

CREATE TABLE services (
    id SERIAL PRIMARY KEY,

    hairSalon_id INT NOT NULL,

    name VARCHAR(100) NOT NULL,
    description TEXT,

    price NUMERIC(10,2) NOT NULL,

    durationMinutes INT NOT NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (
        status IN ('active', 'inactive')
    ),

    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    created_id INT NOT NULL,
    modified_id INT,

    CONSTRAINT fk_services_hairSalons
        FOREIGN KEY (hairSalon_id)
        REFERENCES hairSalons(id)
        ON DELETE CASCADE
);

-- =========================================================
-- TABLA: stylistSchedules
-- =========================================================

CREATE TABLE stylistSchedules (
    id SERIAL PRIMARY KEY,

    stylist_id INT NOT NULL,

    weekDay VARCHAR(20) NOT NULL CHECK (
        weekDay IN (
            'monday',
            'tuesday',
            'wednesday',
            'thursday',
            'friday',
            'saturday',
            'sunday'
        )
    ),

    startHour TIME NOT NULL,
    endHour TIME NOT NULL,

    available BOOLEAN DEFAULT TRUE,

    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (
        status IN ('active', 'inactive')
    ),

    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    created_id INT NOT NULL,
    modified_id INT,

    CONSTRAINT fk_stylistSchedules_stylists
        FOREIGN KEY (stylist_id)
        REFERENCES stylists(id)
        ON DELETE CASCADE
);

-- =========================================================
-- TABLA: appointments
-- =========================================================

CREATE TABLE appointments (
    id SERIAL PRIMARY KEY,

    user_id INT NOT NULL,
    stylist_id INT NOT NULL,
    service_id INT NOT NULL,
    hairSalon_id INT NOT NULL,

    appointmentDate DATE NOT NULL,

    startHour TIME NOT NULL,
    endHour TIME NOT NULL,

    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (
        status IN (
            'pending',
            'confirmed',
            'cancelled',
            'completed'
        )
    ),

    observations TEXT,

    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    created_id INT NOT NULL,
    modified_id INT,

    CONSTRAINT fk_appointments_users
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_appointments_stylists
        FOREIGN KEY (stylist_id)
        REFERENCES stylists(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_appointments_services
        FOREIGN KEY (service_id)
        REFERENCES services(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_appointments_hairSalons
        FOREIGN KEY (hairSalon_id)
        REFERENCES hairSalons(id)
        ON DELETE CASCADE
);

CREATE INDEX idx_users_email
ON users(email);

CREATE INDEX idx_appointments_date
ON appointments(appointmentDate);

CREATE INDEX idx_appointments_stylist
ON appointments(stylist_id);

CREATE INDEX idx_services_hairSalon
ON services(hairSalon_id);

