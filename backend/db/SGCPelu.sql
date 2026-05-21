--
-- PostgreSQL database dump
--

\restrict qsBGFtCUdSqPB1r4kKXkH1PaoGsx9bj3F0ANgfXGkLXs1FW6jCCzHFiCDabkVEW

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: appointments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointments (
    id integer NOT NULL,
    user_id integer NOT NULL,
    stylist_id integer NOT NULL,
    service_id integer NOT NULL,
    hairsalon_id integer NOT NULL,
    appointmentdate date NOT NULL,
    starthour time without time zone NOT NULL,
    endhour time without time zone NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    observations text,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_id integer NOT NULL,
    modified_id integer,
    CONSTRAINT appointments_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'confirmed'::character varying, 'cancelled'::character varying, 'completed'::character varying])::text[])))
);


ALTER TABLE public.appointments OWNER TO postgres;

--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointments_id_seq OWNER TO postgres;

--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.appointments.id;


--
-- Name: hairsalons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hairsalons (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    description text,
    address character varying(255) NOT NULL,
    city character varying(100),
    phone character varying(20),
    email character varying(150),
    openinghour time without time zone,
    closinghour time without time zone,
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_id integer NOT NULL,
    modified_id integer,
    CONSTRAINT hairsalons_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying])::text[])))
);


ALTER TABLE public.hairsalons OWNER TO postgres;

--
-- Name: hairsalons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hairsalons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hairsalons_id_seq OWNER TO postgres;

--
-- Name: hairsalons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hairsalons_id_seq OWNED BY public.hairsalons.id;


--
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    id integer NOT NULL,
    hairsalon_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    price numeric(10,2) NOT NULL,
    durationminutes integer NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_id integer NOT NULL,
    modified_id integer,
    CONSTRAINT services_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying])::text[])))
);


ALTER TABLE public.services OWNER TO postgres;

--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.services_id_seq OWNER TO postgres;

--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- Name: stylists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stylists (
    id integer NOT NULL,
    user_id integer NOT NULL,
    hairsalon_id integer NOT NULL,
    specialty character varying(100),
    experienceyears integer DEFAULT 0,
    available boolean DEFAULT true,
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_id integer NOT NULL,
    modified_id integer,
    CONSTRAINT stylists_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying])::text[])))
);


ALTER TABLE public.stylists OWNER TO postgres;

--
-- Name: stylists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stylists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stylists_id_seq OWNER TO postgres;

--
-- Name: stylists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stylists_id_seq OWNED BY public.stylists.id;


--
-- Name: stylistschedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stylistschedules (
    id integer NOT NULL,
    stylist_id integer NOT NULL,
    weekday character varying(20) NOT NULL,
    starthour time without time zone NOT NULL,
    endhour time without time zone NOT NULL,
    available boolean DEFAULT true,
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_id integer NOT NULL,
    modified_id integer,
    CONSTRAINT stylistschedules_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying])::text[]))),
    CONSTRAINT stylistschedules_weekday_check CHECK (((weekday)::text = ANY ((ARRAY['monday'::character varying, 'tuesday'::character varying, 'wednesday'::character varying, 'thursday'::character varying, 'friday'::character varying, 'saturday'::character varying, 'sunday'::character varying])::text[])))
);


ALTER TABLE public.stylistschedules OWNER TO postgres;

--
-- Name: stylistschedules_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stylistschedules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stylistschedules_id_seq OWNER TO postgres;

--
-- Name: stylistschedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stylistschedules_id_seq OWNED BY public.stylistschedules.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    names character varying(100) NOT NULL,
    fathersurname character varying(100) NOT NULL,
    mothersurname character varying(100),
    email character varying(150) NOT NULL,
    password character varying(255) NOT NULL,
    phone character varying(20),
    role character varying(20) NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_id integer NOT NULL,
    modified_id integer,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['client'::character varying, 'admin'::character varying, 'stylist'::character varying])::text[]))),
    CONSTRAINT users_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'inactive'::character varying])::text[])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: appointments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- Name: hairsalons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hairsalons ALTER COLUMN id SET DEFAULT nextval('public.hairsalons_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- Name: stylists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stylists ALTER COLUMN id SET DEFAULT nextval('public.stylists_id_seq'::regclass);


--
-- Name: stylistschedules id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stylistschedules ALTER COLUMN id SET DEFAULT nextval('public.stylistschedules_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.appointments (id, user_id, stylist_id, service_id, hairsalon_id, appointmentdate, starthour, endhour, status, observations, created, modified, created_id, modified_id) FROM stdin;
1	4	1	1	1	2026-05-10	10:00:00	10:45:00	confirmed	Cliente solicita corte degradado.	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
2	5	2	3	2	2026-05-11	15:00:00	16:00:00	pending	Primera visita del cliente.	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
\.


--
-- Data for Name: hairsalons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hairsalons (id, name, description, address, city, phone, email, openinghour, closinghour, status, created, modified, created_id, modified_id) FROM stdin;
1	SalSalon Centro	Peluquería moderna especializada en cortes y tintes.	Av. Principal 123	Arequipa	054123456	contacto@salsalon.com	09:00:00	20:00:00	active	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
2	SalSalon Norte	Servicios de barbería y estilismo profesional.	Calle Los Olivos 456	Arequipa	054654321	norte@salsalon.com	10:00:00	21:00:00	active	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
\.


--
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.services (id, hairsalon_id, name, description, price, durationminutes, status, created, modified, created_id, modified_id) FROM stdin;
1	1	Corte de cabello	Corte moderno personalizado.	25.00	45	active	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
2	1	Tinte completo	Aplicación de tinte profesional.	80.00	120	active	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
3	2	Barbería clásica	Corte y perfilado de barba.	35.00	60	active	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
\.


--
-- Data for Name: stylists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stylists (id, user_id, hairsalon_id, specialty, experienceyears, available, status, created, modified, created_id, modified_id) FROM stdin;
1	2	1	Coloración y tintes	5	t	active	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
2	3	2	Cortes modernos y peinados	3	t	active	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
\.


--
-- Data for Name: stylistschedules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stylistschedules (id, stylist_id, weekday, starthour, endhour, available, status, created, modified, created_id, modified_id) FROM stdin;
1	1	monday	09:00:00	17:00:00	t	active	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
2	1	wednesday	09:00:00	17:00:00	t	active	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
3	2	friday	10:00:00	18:00:00	t	active	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, names, fathersurname, mothersurname, email, password, phone, role, status, created, modified, created_id, modified_id) FROM stdin;
1	Carlos	Ramirez	Quispe	admin@salsalon.com	123456	987654321	admin	active	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
2	María	Fernandez	Lopez	maria@salsalon.com	123456	912345678	stylist	active	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
3	Lucía	Torres	Mendoza	lucia@salsalon.com	123456	923456789	stylist	active	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
4	José	Gomez	Paredes	jose@gmail.com	123456	934567890	client	active	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
5	Ana	Vargas	Soto	ana@gmail.com	123456	945678901	client	active	2026-05-07 22:28:32.322635	2026-05-07 22:28:32.322635	1	\N
\.


--
-- Name: appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointments_id_seq', 2, true);


--
-- Name: hairsalons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hairsalons_id_seq', 2, true);


--
-- Name: services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.services_id_seq', 3, true);


--
-- Name: stylists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stylists_id_seq', 2, true);


--
-- Name: stylistschedules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stylistschedules_id_seq', 3, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: hairsalons hairsalons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hairsalons
    ADD CONSTRAINT hairsalons_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: stylists stylists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stylists
    ADD CONSTRAINT stylists_pkey PRIMARY KEY (id);


--
-- Name: stylistschedules stylistschedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stylistschedules
    ADD CONSTRAINT stylistschedules_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_appointments_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_appointments_date ON public.appointments USING btree (appointmentdate);


--
-- Name: idx_appointments_stylist; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_appointments_stylist ON public.appointments USING btree (stylist_id);


--
-- Name: idx_services_hairsalon; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_services_hairsalon ON public.services USING btree (hairsalon_id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: appointments fk_appointments_hairsalons; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointments_hairsalons FOREIGN KEY (hairsalon_id) REFERENCES public.hairsalons(id) ON DELETE CASCADE;


--
-- Name: appointments fk_appointments_services; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointments_services FOREIGN KEY (service_id) REFERENCES public.services(id) ON DELETE CASCADE;


--
-- Name: appointments fk_appointments_stylists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointments_stylists FOREIGN KEY (stylist_id) REFERENCES public.stylists(id) ON DELETE CASCADE;


--
-- Name: appointments fk_appointments_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_appointments_users FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: services fk_services_hairsalons; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT fk_services_hairsalons FOREIGN KEY (hairsalon_id) REFERENCES public.hairsalons(id) ON DELETE CASCADE;


--
-- Name: stylists fk_stylists_hairsalons; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stylists
    ADD CONSTRAINT fk_stylists_hairsalons FOREIGN KEY (hairsalon_id) REFERENCES public.hairsalons(id) ON DELETE CASCADE;


--
-- Name: stylists fk_stylists_users; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stylists
    ADD CONSTRAINT fk_stylists_users FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: stylistschedules fk_stylistschedules_stylists; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stylistschedules
    ADD CONSTRAINT fk_stylistschedules_stylists FOREIGN KEY (stylist_id) REFERENCES public.stylists(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict qsBGFtCUdSqPB1r4kKXkH1PaoGsx9bj3F0ANgfXGkLXs1FW6jCCzHFiCDabkVEW

