--
-- PostgreSQL database dump
--

-- Dumped from database version 14.20 (Ubuntu 14.20-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 16.6 (Ubuntu 16.6-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: face_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.face_status AS ENUM (
    'authorized',
    'unauthorized',
    'visitor',
    'employee'
);


--
-- Name: create_monthly_partition(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.create_monthly_partition() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    current_month DATE := DATE_TRUNC('month', CURRENT_DATE);
    next_month DATE := current_month + INTERVAL '1 month';
    partition_name TEXT;
    start_date TIMESTAMP;
    end_date TIMESTAMP;
BEGIN
    partition_name := 'crowd_data_' || TO_CHAR(current_month, 'MM_YYYY');
    start_date := current_month::TIMESTAMP;
    end_date := next_month::TIMESTAMP;
    
    IF NOT EXISTS (
        SELECT 1
        FROM pg_class c
        WHERE c.relname = partition_name
    ) THEN
        EXECUTE format(
            'CREATE TABLE %I PARTITION OF crowd_measurements ' ||
            'FOR VALUES FROM (%L) TO (%L)',
            partition_name,
            start_date,
            end_date
        );
        RAISE NOTICE 'Created partition %', partition_name;
    END IF;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

--
-- Name: crowd_measurements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_measurements (
    measurement_id integer NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
)
PARTITION BY RANGE (measured_at);


--
-- Name: crowd_measurements_measurement_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.crowd_measurements_measurement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: crowd_measurements_measurement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.crowd_measurements_measurement_id_seq OWNED BY public.crowd_measurements.measurement_id;


SET default_table_access_method = heap;

--
-- Name: crowd_data_01_2025; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_01_2025 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_01_2026; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_01_2026 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_02_2025; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_02_2025 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_02_2026; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_02_2026 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_03_2025; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_03_2025 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_03_2026; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_03_2026 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_04_2025; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_04_2025 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_04_2026; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_04_2026 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_05_2025; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_05_2025 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_05_2026; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_05_2026 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_06_2025; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_06_2025 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_06_2026; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_06_2026 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_07_2025; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_07_2025 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_07_2026; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_07_2026 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_08_2025; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_08_2025 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_08_2026; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_08_2026 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_09_2025; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_09_2025 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_09_2026; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_09_2026 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_10_2025; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_10_2025 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_10_2026; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_10_2026 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_11_2025; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_11_2025 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_11_2026; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_11_2026 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_12_2024; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_12_2024 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_12_2025; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_12_2025 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: crowd_data_12_2026; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crowd_data_12_2026 (
    measurement_id integer DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass) NOT NULL,
    camera_id integer NOT NULL,
    zone_name character varying(100) NOT NULL,
    area_name character varying(100) NOT NULL,
    capacity integer NOT NULL,
    number_of_people integer NOT NULL,
    crowding_level character varying(50) NOT NULL,
    crowding_percentage numeric(5,2) NOT NULL,
    measured_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: face_recognition; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.face_recognition (
    zone text,
    camera_id text,
    person_name text,
    "position" text,
    status text,
    "timestamp" timestamp without time zone
);


--
-- Name: crowd_data_01_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_01_2025 FOR VALUES FROM ('2025-01-01 00:00:00') TO ('2025-02-01 00:00:00');


--
-- Name: crowd_data_01_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_01_2026 FOR VALUES FROM ('2026-01-01 00:00:00') TO ('2026-02-01 00:00:00');


--
-- Name: crowd_data_02_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_02_2025 FOR VALUES FROM ('2025-02-01 00:00:00') TO ('2025-03-01 00:00:00');


--
-- Name: crowd_data_02_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_02_2026 FOR VALUES FROM ('2026-02-01 00:00:00') TO ('2026-03-01 00:00:00');


--
-- Name: crowd_data_03_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_03_2025 FOR VALUES FROM ('2025-03-01 00:00:00') TO ('2025-04-01 00:00:00');


--
-- Name: crowd_data_03_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_03_2026 FOR VALUES FROM ('2026-03-01 00:00:00') TO ('2026-04-01 00:00:00');


--
-- Name: crowd_data_04_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_04_2025 FOR VALUES FROM ('2025-04-01 00:00:00') TO ('2025-05-01 00:00:00');


--
-- Name: crowd_data_04_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_04_2026 FOR VALUES FROM ('2026-04-01 00:00:00') TO ('2026-05-01 00:00:00');


--
-- Name: crowd_data_05_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_05_2025 FOR VALUES FROM ('2025-05-01 00:00:00') TO ('2025-06-01 00:00:00');


--
-- Name: crowd_data_05_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_05_2026 FOR VALUES FROM ('2026-05-01 00:00:00') TO ('2026-06-01 00:00:00');


--
-- Name: crowd_data_06_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_06_2025 FOR VALUES FROM ('2025-06-01 00:00:00') TO ('2025-07-01 00:00:00');


--
-- Name: crowd_data_06_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_06_2026 FOR VALUES FROM ('2026-06-01 00:00:00') TO ('2026-07-01 00:00:00');


--
-- Name: crowd_data_07_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_07_2025 FOR VALUES FROM ('2025-07-01 00:00:00') TO ('2025-08-01 00:00:00');


--
-- Name: crowd_data_07_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_07_2026 FOR VALUES FROM ('2026-07-01 00:00:00') TO ('2026-08-01 00:00:00');


--
-- Name: crowd_data_08_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_08_2025 FOR VALUES FROM ('2025-08-01 00:00:00') TO ('2025-09-01 00:00:00');


--
-- Name: crowd_data_08_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_08_2026 FOR VALUES FROM ('2026-08-01 00:00:00') TO ('2026-09-01 00:00:00');


--
-- Name: crowd_data_09_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_09_2025 FOR VALUES FROM ('2025-09-01 00:00:00') TO ('2025-10-01 00:00:00');


--
-- Name: crowd_data_09_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_09_2026 FOR VALUES FROM ('2026-09-01 00:00:00') TO ('2026-10-01 00:00:00');


--
-- Name: crowd_data_10_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_10_2025 FOR VALUES FROM ('2025-10-01 00:00:00') TO ('2025-11-01 00:00:00');


--
-- Name: crowd_data_10_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_10_2026 FOR VALUES FROM ('2026-10-01 00:00:00') TO ('2026-11-01 00:00:00');


--
-- Name: crowd_data_11_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_11_2025 FOR VALUES FROM ('2025-11-01 00:00:00') TO ('2025-12-01 00:00:00');


--
-- Name: crowd_data_11_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_11_2026 FOR VALUES FROM ('2026-11-01 00:00:00') TO ('2026-12-01 00:00:00');


--
-- Name: crowd_data_12_2024; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_12_2024 FOR VALUES FROM ('2024-12-01 00:00:00') TO ('2025-01-01 00:00:00');


--
-- Name: crowd_data_12_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_12_2025 FOR VALUES FROM ('2025-12-01 00:00:00') TO ('2026-01-01 00:00:00');


--
-- Name: crowd_data_12_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_12_2026 FOR VALUES FROM ('2026-12-01 00:00:00') TO ('2027-01-01 00:00:00');


--
-- Name: crowd_measurements measurement_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ALTER COLUMN measurement_id SET DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass);


--
-- Name: crowd_measurements crowd_measurements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements
    ADD CONSTRAINT crowd_measurements_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_01_2025 crowd_data_01_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_01_2025
    ADD CONSTRAINT crowd_data_01_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_01_2026 crowd_data_01_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_01_2026
    ADD CONSTRAINT crowd_data_01_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_02_2025 crowd_data_02_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_02_2025
    ADD CONSTRAINT crowd_data_02_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_02_2026 crowd_data_02_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_02_2026
    ADD CONSTRAINT crowd_data_02_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_03_2025 crowd_data_03_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_03_2025
    ADD CONSTRAINT crowd_data_03_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_03_2026 crowd_data_03_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_03_2026
    ADD CONSTRAINT crowd_data_03_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_04_2025 crowd_data_04_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_04_2025
    ADD CONSTRAINT crowd_data_04_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_04_2026 crowd_data_04_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_04_2026
    ADD CONSTRAINT crowd_data_04_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_05_2025 crowd_data_05_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_05_2025
    ADD CONSTRAINT crowd_data_05_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_05_2026 crowd_data_05_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_05_2026
    ADD CONSTRAINT crowd_data_05_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_06_2025 crowd_data_06_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_06_2025
    ADD CONSTRAINT crowd_data_06_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_06_2026 crowd_data_06_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_06_2026
    ADD CONSTRAINT crowd_data_06_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_07_2025 crowd_data_07_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_07_2025
    ADD CONSTRAINT crowd_data_07_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_07_2026 crowd_data_07_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_07_2026
    ADD CONSTRAINT crowd_data_07_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_08_2025 crowd_data_08_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_08_2025
    ADD CONSTRAINT crowd_data_08_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_08_2026 crowd_data_08_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_08_2026
    ADD CONSTRAINT crowd_data_08_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_09_2025 crowd_data_09_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_09_2025
    ADD CONSTRAINT crowd_data_09_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_09_2026 crowd_data_09_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_09_2026
    ADD CONSTRAINT crowd_data_09_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_10_2025 crowd_data_10_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_10_2025
    ADD CONSTRAINT crowd_data_10_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_10_2026 crowd_data_10_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_10_2026
    ADD CONSTRAINT crowd_data_10_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_11_2025 crowd_data_11_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_11_2025
    ADD CONSTRAINT crowd_data_11_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_11_2026 crowd_data_11_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_11_2026
    ADD CONSTRAINT crowd_data_11_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_12_2024 crowd_data_12_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_12_2024
    ADD CONSTRAINT crowd_data_12_2024_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_12_2025 crowd_data_12_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_12_2025
    ADD CONSTRAINT crowd_data_12_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_12_2026 crowd_data_12_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_12_2026
    ADD CONSTRAINT crowd_data_12_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: idx_crowd_measurements_camera_zone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_crowd_measurements_camera_zone ON ONLY public.crowd_measurements USING btree (camera_id, zone_name);


--
-- Name: crowd_data_01_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_01_2025_camera_id_zone_name_idx ON public.crowd_data_01_2025 USING btree (camera_id, zone_name);


--
-- Name: idx_crowd_measurements_measured_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_crowd_measurements_measured_at ON ONLY public.crowd_measurements USING btree (measured_at);


--
-- Name: crowd_data_01_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_01_2025_measured_at_idx ON public.crowd_data_01_2025 USING btree (measured_at);


--
-- Name: crowd_data_01_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_01_2026_camera_id_zone_name_idx ON public.crowd_data_01_2026 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_01_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_01_2026_measured_at_idx ON public.crowd_data_01_2026 USING btree (measured_at);


--
-- Name: crowd_data_02_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_02_2025_camera_id_zone_name_idx ON public.crowd_data_02_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_02_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_02_2025_measured_at_idx ON public.crowd_data_02_2025 USING btree (measured_at);


--
-- Name: crowd_data_02_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_02_2026_camera_id_zone_name_idx ON public.crowd_data_02_2026 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_02_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_02_2026_measured_at_idx ON public.crowd_data_02_2026 USING btree (measured_at);


--
-- Name: crowd_data_03_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_03_2025_camera_id_zone_name_idx ON public.crowd_data_03_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_03_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_03_2025_measured_at_idx ON public.crowd_data_03_2025 USING btree (measured_at);


--
-- Name: crowd_data_03_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_03_2026_camera_id_zone_name_idx ON public.crowd_data_03_2026 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_03_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_03_2026_measured_at_idx ON public.crowd_data_03_2026 USING btree (measured_at);


--
-- Name: crowd_data_04_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_04_2025_camera_id_zone_name_idx ON public.crowd_data_04_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_04_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_04_2025_measured_at_idx ON public.crowd_data_04_2025 USING btree (measured_at);


--
-- Name: crowd_data_04_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_04_2026_camera_id_zone_name_idx ON public.crowd_data_04_2026 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_04_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_04_2026_measured_at_idx ON public.crowd_data_04_2026 USING btree (measured_at);


--
-- Name: crowd_data_05_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_05_2025_camera_id_zone_name_idx ON public.crowd_data_05_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_05_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_05_2025_measured_at_idx ON public.crowd_data_05_2025 USING btree (measured_at);


--
-- Name: crowd_data_05_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_05_2026_camera_id_zone_name_idx ON public.crowd_data_05_2026 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_05_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_05_2026_measured_at_idx ON public.crowd_data_05_2026 USING btree (measured_at);


--
-- Name: crowd_data_06_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_06_2025_camera_id_zone_name_idx ON public.crowd_data_06_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_06_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_06_2025_measured_at_idx ON public.crowd_data_06_2025 USING btree (measured_at);


--
-- Name: crowd_data_06_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_06_2026_camera_id_zone_name_idx ON public.crowd_data_06_2026 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_06_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_06_2026_measured_at_idx ON public.crowd_data_06_2026 USING btree (measured_at);


--
-- Name: crowd_data_07_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_07_2025_camera_id_zone_name_idx ON public.crowd_data_07_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_07_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_07_2025_measured_at_idx ON public.crowd_data_07_2025 USING btree (measured_at);


--
-- Name: crowd_data_07_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_07_2026_camera_id_zone_name_idx ON public.crowd_data_07_2026 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_07_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_07_2026_measured_at_idx ON public.crowd_data_07_2026 USING btree (measured_at);


--
-- Name: crowd_data_08_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_08_2025_camera_id_zone_name_idx ON public.crowd_data_08_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_08_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_08_2025_measured_at_idx ON public.crowd_data_08_2025 USING btree (measured_at);


--
-- Name: crowd_data_08_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_08_2026_camera_id_zone_name_idx ON public.crowd_data_08_2026 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_08_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_08_2026_measured_at_idx ON public.crowd_data_08_2026 USING btree (measured_at);


--
-- Name: crowd_data_09_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_09_2025_camera_id_zone_name_idx ON public.crowd_data_09_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_09_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_09_2025_measured_at_idx ON public.crowd_data_09_2025 USING btree (measured_at);


--
-- Name: crowd_data_09_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_09_2026_camera_id_zone_name_idx ON public.crowd_data_09_2026 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_09_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_09_2026_measured_at_idx ON public.crowd_data_09_2026 USING btree (measured_at);


--
-- Name: crowd_data_10_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_10_2025_camera_id_zone_name_idx ON public.crowd_data_10_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_10_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_10_2025_measured_at_idx ON public.crowd_data_10_2025 USING btree (measured_at);


--
-- Name: crowd_data_10_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_10_2026_camera_id_zone_name_idx ON public.crowd_data_10_2026 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_10_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_10_2026_measured_at_idx ON public.crowd_data_10_2026 USING btree (measured_at);


--
-- Name: crowd_data_11_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_11_2025_camera_id_zone_name_idx ON public.crowd_data_11_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_11_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_11_2025_measured_at_idx ON public.crowd_data_11_2025 USING btree (measured_at);


--
-- Name: crowd_data_11_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_11_2026_camera_id_zone_name_idx ON public.crowd_data_11_2026 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_11_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_11_2026_measured_at_idx ON public.crowd_data_11_2026 USING btree (measured_at);


--
-- Name: crowd_data_12_2024_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_12_2024_camera_id_zone_name_idx ON public.crowd_data_12_2024 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_12_2024_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_12_2024_measured_at_idx ON public.crowd_data_12_2024 USING btree (measured_at);


--
-- Name: crowd_data_12_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_12_2025_camera_id_zone_name_idx ON public.crowd_data_12_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_12_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_12_2025_measured_at_idx ON public.crowd_data_12_2025 USING btree (measured_at);


--
-- Name: crowd_data_12_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_12_2026_camera_id_zone_name_idx ON public.crowd_data_12_2026 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_12_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_12_2026_measured_at_idx ON public.crowd_data_12_2026 USING btree (measured_at);


--
-- Name: crowd_data_01_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_01_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_01_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_01_2025_measured_at_idx;


--
-- Name: crowd_data_01_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_01_2025_pkey;


--
-- Name: crowd_data_01_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_01_2026_camera_id_zone_name_idx;


--
-- Name: crowd_data_01_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_01_2026_measured_at_idx;


--
-- Name: crowd_data_01_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_01_2026_pkey;


--
-- Name: crowd_data_02_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_02_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_02_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_02_2025_measured_at_idx;


--
-- Name: crowd_data_02_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_02_2025_pkey;


--
-- Name: crowd_data_02_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_02_2026_camera_id_zone_name_idx;


--
-- Name: crowd_data_02_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_02_2026_measured_at_idx;


--
-- Name: crowd_data_02_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_02_2026_pkey;


--
-- Name: crowd_data_03_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_03_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_03_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_03_2025_measured_at_idx;


--
-- Name: crowd_data_03_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_03_2025_pkey;


--
-- Name: crowd_data_03_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_03_2026_camera_id_zone_name_idx;


--
-- Name: crowd_data_03_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_03_2026_measured_at_idx;


--
-- Name: crowd_data_03_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_03_2026_pkey;


--
-- Name: crowd_data_04_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_04_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_04_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_04_2025_measured_at_idx;


--
-- Name: crowd_data_04_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_04_2025_pkey;


--
-- Name: crowd_data_04_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_04_2026_camera_id_zone_name_idx;


--
-- Name: crowd_data_04_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_04_2026_measured_at_idx;


--
-- Name: crowd_data_04_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_04_2026_pkey;


--
-- Name: crowd_data_05_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_05_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_05_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_05_2025_measured_at_idx;


--
-- Name: crowd_data_05_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_05_2025_pkey;


--
-- Name: crowd_data_05_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_05_2026_camera_id_zone_name_idx;


--
-- Name: crowd_data_05_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_05_2026_measured_at_idx;


--
-- Name: crowd_data_05_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_05_2026_pkey;


--
-- Name: crowd_data_06_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_06_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_06_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_06_2025_measured_at_idx;


--
-- Name: crowd_data_06_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_06_2025_pkey;


--
-- Name: crowd_data_06_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_06_2026_camera_id_zone_name_idx;


--
-- Name: crowd_data_06_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_06_2026_measured_at_idx;


--
-- Name: crowd_data_06_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_06_2026_pkey;


--
-- Name: crowd_data_07_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_07_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_07_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_07_2025_measured_at_idx;


--
-- Name: crowd_data_07_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_07_2025_pkey;


--
-- Name: crowd_data_07_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_07_2026_camera_id_zone_name_idx;


--
-- Name: crowd_data_07_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_07_2026_measured_at_idx;


--
-- Name: crowd_data_07_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_07_2026_pkey;


--
-- Name: crowd_data_08_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_08_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_08_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_08_2025_measured_at_idx;


--
-- Name: crowd_data_08_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_08_2025_pkey;


--
-- Name: crowd_data_08_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_08_2026_camera_id_zone_name_idx;


--
-- Name: crowd_data_08_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_08_2026_measured_at_idx;


--
-- Name: crowd_data_08_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_08_2026_pkey;


--
-- Name: crowd_data_09_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_09_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_09_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_09_2025_measured_at_idx;


--
-- Name: crowd_data_09_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_09_2025_pkey;


--
-- Name: crowd_data_09_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_09_2026_camera_id_zone_name_idx;


--
-- Name: crowd_data_09_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_09_2026_measured_at_idx;


--
-- Name: crowd_data_09_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_09_2026_pkey;


--
-- Name: crowd_data_10_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_10_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_10_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_10_2025_measured_at_idx;


--
-- Name: crowd_data_10_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_10_2025_pkey;


--
-- Name: crowd_data_10_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_10_2026_camera_id_zone_name_idx;


--
-- Name: crowd_data_10_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_10_2026_measured_at_idx;


--
-- Name: crowd_data_10_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_10_2026_pkey;


--
-- Name: crowd_data_11_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_11_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_11_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_11_2025_measured_at_idx;


--
-- Name: crowd_data_11_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_11_2025_pkey;


--
-- Name: crowd_data_11_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_11_2026_camera_id_zone_name_idx;


--
-- Name: crowd_data_11_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_11_2026_measured_at_idx;


--
-- Name: crowd_data_11_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_11_2026_pkey;


--
-- Name: crowd_data_12_2024_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_12_2024_camera_id_zone_name_idx;


--
-- Name: crowd_data_12_2024_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_12_2024_measured_at_idx;


--
-- Name: crowd_data_12_2024_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_12_2024_pkey;


--
-- Name: crowd_data_12_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_12_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_12_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_12_2025_measured_at_idx;


--
-- Name: crowd_data_12_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_12_2025_pkey;


--
-- Name: crowd_data_12_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_12_2026_camera_id_zone_name_idx;


--
-- Name: crowd_data_12_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_12_2026_measured_at_idx;


--
-- Name: crowd_data_12_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_12_2026_pkey;


--
-- PostgreSQL database dump complete
--

