--
-- PostgreSQL database dump
--

\restrict MtiULA0JqByUVlNLq9zK0BV2Nnz0yQ6HuEWVS5LrLk27jThEygDG52Z4KWWNBH8

-- Dumped from database version 14.20 (Ubuntu 14.20-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.20 (Ubuntu 14.20-0ubuntu0.22.04.1)

-- Started on 2026-02-05 16:22:29 +03

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
-- TOC entry 851 (class 1247 OID 16440)
-- Name: face_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.face_status AS ENUM (
    'authorized',
    'unauthorized',
    'visitor',
    'employee'
);


--
-- TOC entry 240 (class 1255 OID 16449)
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
-- TOC entry 241 (class 1255 OID 16450)
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
-- TOC entry 209 (class 1259 OID 16451)
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
-- TOC entry 210 (class 1259 OID 16455)
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
-- TOC entry 3745 (class 0 OID 0)
-- Dependencies: 210
-- Name: crowd_measurements_measurement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.crowd_measurements_measurement_id_seq OWNED BY public.crowd_measurements.measurement_id;


SET default_table_access_method = heap;

--
-- TOC entry 211 (class 1259 OID 16456)
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
-- TOC entry 212 (class 1259 OID 16461)
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
-- TOC entry 213 (class 1259 OID 16466)
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
-- TOC entry 214 (class 1259 OID 16471)
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
-- TOC entry 215 (class 1259 OID 16476)
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
-- TOC entry 216 (class 1259 OID 16481)
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
-- TOC entry 217 (class 1259 OID 16486)
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
-- TOC entry 218 (class 1259 OID 16491)
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
-- TOC entry 219 (class 1259 OID 16496)
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
-- TOC entry 220 (class 1259 OID 16501)
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
-- TOC entry 221 (class 1259 OID 16506)
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
-- TOC entry 222 (class 1259 OID 16511)
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
-- TOC entry 223 (class 1259 OID 16516)
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
-- TOC entry 224 (class 1259 OID 16521)
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
-- TOC entry 225 (class 1259 OID 16526)
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
-- TOC entry 226 (class 1259 OID 16531)
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
-- TOC entry 227 (class 1259 OID 16536)
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
-- TOC entry 228 (class 1259 OID 16541)
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
-- TOC entry 229 (class 1259 OID 16546)
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
-- TOC entry 230 (class 1259 OID 16551)
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
-- TOC entry 231 (class 1259 OID 16556)
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
-- TOC entry 232 (class 1259 OID 16561)
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
-- TOC entry 233 (class 1259 OID 16566)
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
-- TOC entry 234 (class 1259 OID 16571)
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
-- TOC entry 235 (class 1259 OID 16576)
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
-- TOC entry 236 (class 1259 OID 16581)
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
-- TOC entry 3318 (class 0 OID 0)
-- Name: crowd_data_01_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_01_2025 FOR VALUES FROM ('2025-01-01 00:00:00') TO ('2025-02-01 00:00:00');


--
-- TOC entry 3319 (class 0 OID 0)
-- Name: crowd_data_01_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_01_2026 FOR VALUES FROM ('2026-01-01 00:00:00') TO ('2026-02-01 00:00:00');


--
-- TOC entry 3320 (class 0 OID 0)
-- Name: crowd_data_02_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_02_2025 FOR VALUES FROM ('2025-02-01 00:00:00') TO ('2025-03-01 00:00:00');


--
-- TOC entry 3321 (class 0 OID 0)
-- Name: crowd_data_02_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_02_2026 FOR VALUES FROM ('2026-02-01 00:00:00') TO ('2026-03-01 00:00:00');


--
-- TOC entry 3322 (class 0 OID 0)
-- Name: crowd_data_03_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_03_2025 FOR VALUES FROM ('2025-03-01 00:00:00') TO ('2025-04-01 00:00:00');


--
-- TOC entry 3323 (class 0 OID 0)
-- Name: crowd_data_03_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_03_2026 FOR VALUES FROM ('2026-03-01 00:00:00') TO ('2026-04-01 00:00:00');


--
-- TOC entry 3324 (class 0 OID 0)
-- Name: crowd_data_04_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_04_2025 FOR VALUES FROM ('2025-04-01 00:00:00') TO ('2025-05-01 00:00:00');


--
-- TOC entry 3325 (class 0 OID 0)
-- Name: crowd_data_04_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_04_2026 FOR VALUES FROM ('2026-04-01 00:00:00') TO ('2026-05-01 00:00:00');


--
-- TOC entry 3326 (class 0 OID 0)
-- Name: crowd_data_05_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_05_2025 FOR VALUES FROM ('2025-05-01 00:00:00') TO ('2025-06-01 00:00:00');


--
-- TOC entry 3327 (class 0 OID 0)
-- Name: crowd_data_05_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_05_2026 FOR VALUES FROM ('2026-05-01 00:00:00') TO ('2026-06-01 00:00:00');


--
-- TOC entry 3328 (class 0 OID 0)
-- Name: crowd_data_06_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_06_2025 FOR VALUES FROM ('2025-06-01 00:00:00') TO ('2025-07-01 00:00:00');


--
-- TOC entry 3329 (class 0 OID 0)
-- Name: crowd_data_06_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_06_2026 FOR VALUES FROM ('2026-06-01 00:00:00') TO ('2026-07-01 00:00:00');


--
-- TOC entry 3330 (class 0 OID 0)
-- Name: crowd_data_07_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_07_2025 FOR VALUES FROM ('2025-07-01 00:00:00') TO ('2025-08-01 00:00:00');


--
-- TOC entry 3331 (class 0 OID 0)
-- Name: crowd_data_07_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_07_2026 FOR VALUES FROM ('2026-07-01 00:00:00') TO ('2026-08-01 00:00:00');


--
-- TOC entry 3332 (class 0 OID 0)
-- Name: crowd_data_08_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_08_2025 FOR VALUES FROM ('2025-08-01 00:00:00') TO ('2025-09-01 00:00:00');


--
-- TOC entry 3333 (class 0 OID 0)
-- Name: crowd_data_08_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_08_2026 FOR VALUES FROM ('2026-08-01 00:00:00') TO ('2026-09-01 00:00:00');


--
-- TOC entry 3334 (class 0 OID 0)
-- Name: crowd_data_09_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_09_2025 FOR VALUES FROM ('2025-09-01 00:00:00') TO ('2025-10-01 00:00:00');


--
-- TOC entry 3335 (class 0 OID 0)
-- Name: crowd_data_09_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_09_2026 FOR VALUES FROM ('2026-09-01 00:00:00') TO ('2026-10-01 00:00:00');


--
-- TOC entry 3336 (class 0 OID 0)
-- Name: crowd_data_10_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_10_2025 FOR VALUES FROM ('2025-10-01 00:00:00') TO ('2025-11-01 00:00:00');


--
-- TOC entry 3337 (class 0 OID 0)
-- Name: crowd_data_10_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_10_2026 FOR VALUES FROM ('2026-10-01 00:00:00') TO ('2026-11-01 00:00:00');


--
-- TOC entry 3338 (class 0 OID 0)
-- Name: crowd_data_11_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_11_2025 FOR VALUES FROM ('2025-11-01 00:00:00') TO ('2025-12-01 00:00:00');


--
-- TOC entry 3339 (class 0 OID 0)
-- Name: crowd_data_11_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_11_2026 FOR VALUES FROM ('2026-11-01 00:00:00') TO ('2026-12-01 00:00:00');


--
-- TOC entry 3340 (class 0 OID 0)
-- Name: crowd_data_12_2024; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_12_2024 FOR VALUES FROM ('2024-12-01 00:00:00') TO ('2025-01-01 00:00:00');


--
-- TOC entry 3341 (class 0 OID 0)
-- Name: crowd_data_12_2025; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_12_2025 FOR VALUES FROM ('2025-12-01 00:00:00') TO ('2026-01-01 00:00:00');


--
-- TOC entry 3342 (class 0 OID 0)
-- Name: crowd_data_12_2026; Type: TABLE ATTACH; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_12_2026 FOR VALUES FROM ('2026-12-01 00:00:00') TO ('2027-01-01 00:00:00');


--
-- TOC entry 3344 (class 2604 OID 16586)
-- Name: crowd_measurements measurement_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements ALTER COLUMN measurement_id SET DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass);


--
-- TOC entry 3714 (class 0 OID 16456)
-- Dependencies: 211
-- Data for Name: crowd_data_01_2025; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_01_2025 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3715 (class 0 OID 16461)
-- Dependencies: 212
-- Data for Name: crowd_data_01_2026; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_01_2026 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3716 (class 0 OID 16466)
-- Dependencies: 213
-- Data for Name: crowd_data_02_2025; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_02_2025 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3717 (class 0 OID 16471)
-- Dependencies: 214
-- Data for Name: crowd_data_02_2026; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_02_2026 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
1	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 11:04:02.260428
2	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:04:02.260428
3	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 11:04:02.260428
4	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 11:04:02.260428
5	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:18:13.763188
6	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 11:19:14.077407
7	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:19:14.077407
8	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 11:19:14.077407
9	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:19:14.077407
10	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 11:20:14.379731
11	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:20:14.379731
12	5	marketing-&-sales	main_area	10	6	Moderate	60.00	2026-02-03 11:20:14.379731
13	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 11:20:14.379731
14	4	showroom	main_area	10	1	Low	10.00	2026-02-03 11:21:14.596165
15	5	marketing-&-sales	main_area	10	6	Moderate	60.00	2026-02-03 11:21:14.596165
16	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 11:21:14.596165
17	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 11:21:14.596165
18	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:22:14.868878
19	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:22:14.868878
20	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 11:22:14.868878
21	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 11:22:14.868878
22	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 11:23:15.298906
23	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:23:15.298906
24	5	marketing-&-sales	main_area	10	6	Moderate	60.00	2026-02-03 11:23:15.298906
25	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 11:23:15.298906
26	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 11:24:15.639474
27	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:24:15.639474
28	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:24:15.639474
29	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 11:24:15.639474
30	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:25:16.020897
31	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 11:25:16.020897
32	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:25:16.020897
33	5	marketing-&-sales	main_area	10	5	Moderate	50.00	2026-02-03 11:25:16.020897
34	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 11:26:16.289197
35	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 11:26:16.289197
36	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 11:26:16.289197
37	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:26:16.289197
38	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 11:27:16.594122
39	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:27:16.594122
40	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:27:16.594122
41	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:27:16.594122
42	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:28:17.025487
43	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 11:28:17.025487
44	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:28:17.025487
45	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:28:17.025487
46	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 11:29:17.2235
47	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:29:17.2235
48	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:29:17.2235
49	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:29:17.2235
50	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 11:35:12.238195
51	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:35:12.238195
52	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:35:12.238195
53	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 11:35:12.238195
54	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:36:12.543337
55	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:36:12.543337
56	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 11:36:12.543337
57	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 11:36:12.543337
58	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:37:12.924551
59	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 11:37:12.924551
60	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-03 11:37:12.924551
61	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 11:37:12.924551
62	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:38:13.201055
63	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 11:38:13.201055
64	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 11:38:13.201055
65	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 11:38:13.201055
66	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 11:39:13.474883
67	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:39:13.474883
68	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 11:39:13.474883
69	2	robotics_lab	main_area	5	7	Crowded	140.00	2026-02-03 11:39:13.474883
70	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 11:40:13.665443
71	2	robotics_lab	main_area	5	8	Crowded	160.00	2026-02-03 11:40:13.665443
72	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 11:40:13.665443
73	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:40:13.665443
74	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:41:14.164804
75	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 11:41:14.164804
76	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-03 11:41:14.164804
77	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 11:41:14.164804
78	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 11:42:14.400443
79	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-03 11:42:14.400443
80	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 11:42:14.400443
81	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:42:14.400443
82	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 11:43:15.428191
83	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:43:15.428191
84	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 11:43:15.428191
85	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 11:43:15.428191
86	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:44:15.760297
87	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:44:15.760297
88	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 11:44:15.760297
89	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 11:44:15.760297
90	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:45:16.0026
91	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 11:45:16.0026
92	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-03 11:45:16.0026
93	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:45:16.0026
94	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 11:46:16.254679
95	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:46:16.254679
96	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:46:16.254679
97	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 11:46:16.254679
98	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 11:47:16.530754
99	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 11:47:16.530754
100	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 11:47:16.530754
101	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:47:16.530754
102	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 11:48:16.751871
103	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:48:16.751871
104	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 11:48:16.751871
105	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 11:48:16.751871
106	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:49:16.967645
107	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 11:49:16.967645
108	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-03 11:49:16.967645
109	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 11:49:16.967645
110	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 11:50:17.170077
111	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 11:50:17.170077
112	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:50:17.170077
113	4	showroom	main_area	10	0	Low	0.00	2026-02-03 11:50:17.170077
114	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 11:51:17.444384
115	4	showroom	main_area	10	2	Low	20.00	2026-02-03 11:51:17.444384
116	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 11:51:17.444384
117	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-03 11:51:17.444384
118	4	showroom	main_area	10	1	Low	10.00	2026-02-03 11:52:17.65398
119	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 11:52:17.65398
120	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 11:52:17.65398
121	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 11:52:17.65398
122	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 11:53:17.8749
123	4	showroom	main_area	10	2	Low	20.00	2026-02-03 11:53:17.8749
124	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 11:53:17.8749
125	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-03 11:53:17.8749
126	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 11:54:18.154227
127	4	showroom	main_area	10	2	Low	20.00	2026-02-03 11:54:18.154227
128	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 11:54:18.154227
129	2	robotics_lab	main_area	5	7	Crowded	140.00	2026-02-03 11:54:18.154227
130	4	showroom	main_area	10	1	Low	10.00	2026-02-03 11:55:18.384333
131	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 11:55:18.384333
132	2	robotics_lab	main_area	5	7	Crowded	140.00	2026-02-03 11:55:18.384333
133	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 11:55:18.384333
134	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 11:56:18.569624
135	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-03 11:56:18.569624
136	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 11:56:18.569624
137	4	showroom	main_area	10	1	Low	10.00	2026-02-03 11:56:18.569624
138	4	showroom	main_area	10	1	Low	10.00	2026-02-03 11:57:18.936461
139	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 11:57:18.936461
140	2	robotics_lab	main_area	5	8	Crowded	160.00	2026-02-03 11:57:18.936461
141	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 11:57:18.936461
142	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 11:58:19.609309
143	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-03 11:58:19.609309
144	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 11:58:19.609309
145	4	showroom	main_area	10	1	Low	10.00	2026-02-03 11:58:19.609309
146	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 11:59:19.903396
147	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-03 11:59:19.903396
148	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 11:59:19.903396
149	4	showroom	main_area	10	2	Low	20.00	2026-02-03 11:59:19.903396
150	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 12:00:20.1276
151	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-03 12:00:20.1276
152	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:00:20.1276
153	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:00:20.1276
154	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:01:20.48593
155	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 12:01:20.48593
156	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 12:01:20.48593
157	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:01:20.48593
158	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:02:20.688746
159	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:02:20.688746
160	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 12:02:20.688746
161	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-03 12:02:20.688746
162	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:03:21.094476
163	4	showroom	main_area	10	1	Low	10.00	2026-02-03 12:03:21.094476
164	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 12:03:21.094476
165	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 12:03:21.094476
166	4	showroom	main_area	10	1	Low	10.00	2026-02-03 12:04:21.367624
167	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 12:04:21.367624
168	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 12:04:21.367624
169	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:04:21.367624
170	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:05:21.717541
171	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:05:21.717541
172	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 12:05:21.717541
173	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 12:05:21.717541
174	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:06:21.898583
175	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 12:06:21.898583
176	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 12:06:21.898583
177	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:06:21.898583
178	4	showroom	main_area	10	1	Low	10.00	2026-02-03 12:07:22.117797
179	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 12:07:22.117797
180	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 12:07:22.117797
181	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:07:22.117797
182	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:08:22.619026
183	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:08:22.619026
184	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:08:22.619026
185	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 12:08:22.619026
186	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:09:22.929753
187	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 12:09:22.929753
188	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 12:09:22.929753
189	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:09:22.929753
190	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-03 12:10:23.127826
191	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:10:23.127826
192	4	showroom	main_area	10	1	Low	10.00	2026-02-03 12:10:23.127826
193	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 12:10:23.127826
194	2	robotics_lab	main_area	5	8	Crowded	160.00	2026-02-03 12:11:23.375542
195	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:11:23.375542
196	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:11:23.375542
197	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 12:11:23.375542
198	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:12:23.598222
199	4	showroom	main_area	10	1	Low	10.00	2026-02-03 12:12:23.598222
200	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:12:23.598222
201	2	robotics_lab	main_area	5	7	Crowded	140.00	2026-02-03 12:12:23.598222
202	2	robotics_lab	main_area	5	7	Crowded	140.00	2026-02-03 12:13:23.887032
203	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:13:23.887032
204	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:13:23.887032
205	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 12:13:23.887032
206	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:14:24.130431
207	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 12:14:24.130431
208	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 12:14:24.130431
209	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:14:24.130431
210	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:15:24.398441
211	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 12:15:24.398441
212	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 12:15:24.398441
213	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:15:24.398441
214	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:16:24.8917
215	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:16:24.8917
216	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:16:24.8917
217	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 12:16:24.8917
218	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:17:25.138952
219	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:17:25.138952
220	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:17:25.138952
221	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:17:25.138952
222	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 12:18:25.368923
223	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:18:25.368923
224	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:18:25.368923
225	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:18:25.368923
226	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 12:19:25.670617
227	4	showroom	main_area	10	4	Moderate	40.00	2026-02-03 12:19:25.670617
228	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:19:25.670617
229	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 12:19:25.670617
230	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:20:25.904515
231	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:20:25.904515
232	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 12:20:25.904515
233	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:20:25.904515
234	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:21:26.16741
235	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:21:26.16741
236	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:21:26.16741
237	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:21:26.16741
238	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:22:26.47876
239	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:22:26.47876
240	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:22:26.47876
241	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:22:26.47876
242	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:23:26.830678
243	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:23:26.830678
244	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:23:26.830678
245	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 12:23:26.830678
246	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:24:27.15905
247	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:24:27.15905
248	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:24:27.15905
249	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:24:27.15905
250	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:25:27.37086
251	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:25:27.37086
252	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:25:27.37086
253	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:25:27.37086
254	4	showroom	main_area	10	4	Moderate	40.00	2026-02-03 12:26:27.593211
255	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:26:27.593211
256	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:26:27.593211
257	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:26:27.593211
258	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:27:27.851746
259	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:27:27.851746
260	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:27:27.851746
261	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:27:27.851746
262	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:28:28.191803
263	4	showroom	main_area	10	4	Moderate	40.00	2026-02-03 12:28:28.191803
264	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:28:28.191803
265	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:28:28.191803
266	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:29:28.427888
267	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:29:28.427888
268	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:29:28.427888
269	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:29:28.427888
270	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:30:28.621093
271	4	showroom	main_area	10	4	Moderate	40.00	2026-02-03 12:30:28.621093
272	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:30:28.621093
273	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:30:28.621093
274	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:31:28.990471
275	4	showroom	main_area	10	5	Moderate	50.00	2026-02-03 12:31:28.990471
276	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 12:31:28.990471
277	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:31:28.990471
278	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 12:32:29.228032
279	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:32:29.228032
280	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:32:29.228032
281	4	showroom	main_area	10	5	Moderate	50.00	2026-02-03 12:32:29.228032
282	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:33:29.47251
283	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:33:29.47251
284	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:33:29.47251
285	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:33:29.47251
286	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:34:29.712206
287	4	showroom	main_area	10	4	Moderate	40.00	2026-02-03 12:34:29.712206
288	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:34:29.712206
289	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:34:29.712206
290	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:35:30.03302
291	4	showroom	main_area	10	4	Moderate	40.00	2026-02-03 12:35:30.03302
292	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:35:30.03302
293	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:35:30.03302
294	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:36:00.112782
295	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:36:00.112782
296	4	showroom	main_area	10	4	Moderate	40.00	2026-02-03 12:36:00.112782
297	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:36:00.112782
298	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:37:00.394219
299	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 12:37:00.394219
300	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:37:00.394219
301	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:37:00.394219
302	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:38:00.635815
303	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:38:00.635815
304	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:38:00.635815
305	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:38:00.635815
306	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 12:39:00.890583
307	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:39:00.890583
308	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:39:00.890583
309	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:39:00.890583
310	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:40:17.475689
311	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:40:17.475689
312	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:40:17.475689
313	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:40:17.475689
314	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:41:00.113854
315	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:41:00.113854
316	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:41:00.113854
317	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:41:00.113854
318	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:42:00.01086
319	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:42:00.01086
320	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:42:00.01086
321	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:42:00.01086
322	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:43:00.146764
323	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:43:00.146764
324	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:43:00.146764
325	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:43:00.146764
326	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:44:00.553681
327	4	showroom	main_area	10	3	Low	30.00	2026-02-03 12:44:00.553681
328	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:44:00.553681
329	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:44:00.553681
330	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:45:00.097185
331	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:45:00.097185
332	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:45:00.097185
333	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 12:45:00.097185
334	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:46:00.041914
335	4	showroom	main_area	10	1	Low	10.00	2026-02-03 12:46:00.041914
336	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:46:00.041914
337	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:46:00.041914
338	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:47:00.314285
339	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:47:00.314285
340	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:47:00.314285
341	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:47:00.314285
342	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:48:00.026703
343	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:48:00.026703
344	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:48:00.026703
345	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:48:00.026703
346	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:49:00.068308
347	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:49:00.068308
348	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:49:00.068308
349	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:49:00.068308
350	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:50:00.000516
351	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:50:00.000516
352	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:50:00.000516
353	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:50:00.000516
354	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:51:00.029781
355	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:51:00.029781
356	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:51:00.029781
357	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:51:00.029781
358	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:52:00.362548
359	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:52:00.362548
360	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:52:00.362548
361	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:52:00.362548
362	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:53:00.01357
363	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:53:00.01357
364	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:53:00.01357
365	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 12:53:00.01357
366	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:54:00.082514
367	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:54:00.082514
368	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:54:00.082514
369	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:54:00.082514
370	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:55:00.166529
371	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:55:00.166529
372	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:55:00.166529
373	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:55:00.166529
374	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:56:00.072952
375	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:56:00.072952
376	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:56:00.072952
377	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:56:00.072952
378	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:57:00.007602
379	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:57:00.007602
380	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:57:00.007602
381	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 12:57:00.007602
382	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 12:58:00.085864
383	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:58:00.085864
384	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:58:00.085864
385	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:58:00.085864
386	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:59:00.03809
387	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 12:59:00.03809
388	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 12:59:00.03809
389	4	showroom	main_area	10	2	Low	20.00	2026-02-03 12:59:00.03809
390	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:00:00.103083
391	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:00:00.103083
392	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 13:00:00.103083
393	4	showroom	main_area	10	2	Low	20.00	2026-02-03 13:00:00.103083
394	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:01:00.01899
395	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:01:00.01899
396	4	showroom	main_area	10	3	Low	30.00	2026-02-03 13:01:00.01899
397	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 13:01:00.01899
398	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:02:00.00782
399	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:02:00.00782
400	4	showroom	main_area	10	3	Low	30.00	2026-02-03 13:02:00.00782
401	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 13:02:00.00782
402	4	showroom	main_area	10	2	Low	20.00	2026-02-03 13:03:00.034849
403	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:03:00.034849
404	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:03:00.034849
405	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 13:03:00.034849
406	4	showroom	main_area	10	2	Low	20.00	2026-02-03 13:04:00.046403
407	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:04:00.046403
408	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 13:04:00.046403
409	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:04:00.046403
410	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:05:00.114008
411	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:05:00.114008
412	4	showroom	main_area	10	2	Low	20.00	2026-02-03 13:05:00.114008
413	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 13:05:00.114008
414	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:06:00.074551
415	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:06:00.074551
416	4	showroom	main_area	10	2	Low	20.00	2026-02-03 13:06:00.074551
417	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 13:06:00.074551
418	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:07:00.037854
419	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:07:00.037854
420	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:07:00.037854
421	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 13:07:00.037854
422	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:08:00.0364
423	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 13:08:00.0364
424	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:08:00.0364
425	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:08:00.0364
426	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:09:00.004509
427	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 13:09:00.004509
428	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:09:00.004509
429	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:09:00.004509
430	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:10:00.017193
431	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:10:00.017193
432	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 13:10:00.017193
433	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:10:00.017193
434	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:11:00.076112
435	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:11:00.076112
436	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:11:00.076112
437	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 13:11:00.076112
438	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 13:12:00.054698
439	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:12:00.054698
440	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:12:00.054698
441	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:12:00.054698
442	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:13:00.139302
443	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:13:00.139302
444	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:13:00.139302
445	5	marketing-&-sales	main_area	10	5	Moderate	50.00	2026-02-03 13:13:00.139302
446	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:14:00.002049
447	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:14:00.002049
448	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:14:00.002049
449	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 13:14:00.002049
450	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:15:00.030571
451	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:15:00.030571
452	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 13:15:00.030571
453	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:15:00.030571
454	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:16:00.025372
455	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:16:00.025372
456	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:16:00.025372
457	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 13:16:00.025372
458	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 13:17:00.011963
459	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:17:00.011963
460	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:17:00.011963
461	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:17:00.011963
462	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 13:18:00.094845
463	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:18:00.094845
464	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:18:00.094845
465	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:18:00.094845
466	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:19:00.087034
467	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:19:00.087034
468	4	showroom	main_area	10	2	Low	20.00	2026-02-03 13:19:00.087034
469	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 13:19:00.087034
470	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:20:00.035271
471	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:20:00.035271
472	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:20:00.035271
473	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 13:20:00.035271
474	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:21:00.044483
475	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:21:00.044483
476	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:21:00.044483
477	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 13:21:00.044483
478	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:22:00.06842
479	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:22:00.06842
480	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:22:00.06842
481	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:22:00.06842
482	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:23:00.098662
483	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:23:00.098662
484	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:23:00.098662
485	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 13:23:00.098662
486	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 13:24:00.007241
487	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:24:00.007241
488	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:24:00.007241
489	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:24:00.007241
490	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 13:25:00.00339
491	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:25:00.00339
492	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:25:00.00339
493	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:25:00.00339
494	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 13:26:00.011642
495	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:26:00.011642
496	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:26:00.011642
497	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:26:00.011642
498	4	showroom	main_area	10	2	Low	20.00	2026-02-03 13:27:00.030398
499	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:27:00.030398
500	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:27:00.030398
501	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 13:27:00.030398
502	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 13:28:00.044788
503	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:28:00.044788
504	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:28:00.044788
505	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:28:00.044788
506	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:29:00.101737
507	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 13:29:00.101737
508	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:29:00.101737
509	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:29:00.101737
510	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:30:00.033295
511	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:30:00.033295
512	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:30:00.033295
513	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:30:00.033295
514	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:31:00.008218
515	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:31:00.008218
516	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:31:00.008218
517	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:31:00.008218
518	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:32:00.107762
519	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:32:00.107762
520	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:32:00.107762
521	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:32:00.107762
522	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:33:00.025317
523	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:33:00.025317
524	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:33:00.025317
525	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 13:33:00.025317
526	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:34:00.024665
527	4	showroom	main_area	10	2	Low	20.00	2026-02-03 13:34:00.024665
528	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 13:34:00.024665
529	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:34:00.024665
530	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:35:00.113032
531	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:35:00.113032
532	4	showroom	main_area	10	2	Low	20.00	2026-02-03 13:35:00.113032
533	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:35:00.113032
534	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:36:00.007787
535	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 13:36:00.007787
536	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:36:00.007787
537	4	showroom	main_area	10	2	Low	20.00	2026-02-03 13:36:00.007787
538	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:37:00.036735
539	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:37:00.036735
540	4	showroom	main_area	10	2	Low	20.00	2026-02-03 13:37:00.036735
541	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:37:00.036735
542	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:38:00.037627
543	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:38:00.037627
544	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:38:00.037627
545	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:38:00.037627
546	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:39:00.073282
547	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:39:00.073282
548	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:39:00.073282
549	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:39:00.073282
550	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:40:00.04781
551	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:40:00.04781
552	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:40:00.04781
553	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:40:00.04781
554	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:41:00.118944
555	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:41:00.118944
556	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:41:00.118944
557	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:41:00.118944
558	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:42:00.001001
559	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:42:00.001001
560	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:42:00.001001
561	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:42:00.001001
562	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:43:00.043992
563	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 13:43:00.043992
564	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:43:00.043992
565	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:43:00.043992
566	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:44:00.023225
567	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:44:00.023225
568	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:44:00.023225
569	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 13:44:00.023225
570	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:45:00.140539
571	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:45:00.140539
572	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 13:45:00.140539
573	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:45:00.140539
574	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:46:00.020537
575	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 13:46:00.020537
576	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:46:00.020537
577	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:46:00.020537
578	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:47:00.109227
579	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 13:47:00.109227
580	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 13:47:00.109227
581	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:47:00.109227
582	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:48:00.0246
583	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:48:00.0246
584	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 13:48:00.0246
585	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:48:00.0246
586	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:49:00.020605
587	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 13:49:00.020605
588	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:49:00.020605
589	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:49:00.020605
590	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:50:00.033599
591	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:50:00.033599
592	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:50:00.033599
593	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:50:00.033599
594	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:51:00.111046
595	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:51:00.111046
596	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:51:00.111046
597	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 13:51:00.111046
598	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:52:00.00654
599	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:52:00.00654
600	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 13:52:00.00654
601	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:52:00.00654
602	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 13:53:00.375577
603	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:53:00.375577
604	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:53:00.375577
605	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:53:00.375577
606	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:54:00.026075
607	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:54:00.026075
608	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 13:54:00.026075
609	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 13:54:00.026075
610	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:55:00.037005
611	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:55:00.037005
612	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:55:00.037005
613	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:55:00.037005
614	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:56:00.038783
615	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:56:00.038783
616	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:56:00.038783
617	4	showroom	main_area	10	1	Low	10.00	2026-02-03 13:56:00.038783
618	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:57:00.075464
619	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:57:00.075464
620	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:57:00.075464
621	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:57:00.075464
622	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 13:58:00.014602
623	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 13:58:00.014602
624	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:58:00.014602
625	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:58:00.014602
626	4	showroom	main_area	10	0	Low	0.00	2026-02-03 13:59:00.188187
627	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 13:59:00.188187
628	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 13:59:00.188187
629	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 13:59:00.188187
630	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 14:00:00.00298
631	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 14:00:00.00298
632	4	showroom	main_area	10	1	Low	10.00	2026-02-03 14:00:00.00298
633	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 14:00:00.00298
634	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 14:01:00.154377
635	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 14:01:00.154377
636	4	showroom	main_area	10	0	Low	0.00	2026-02-03 14:01:00.154377
637	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 14:01:00.154377
638	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 14:02:00.085176
639	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 14:02:00.085176
640	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 14:02:00.085176
641	4	showroom	main_area	10	0	Low	0.00	2026-02-03 14:02:00.085176
642	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 14:03:00.087191
643	4	showroom	main_area	10	1	Low	10.00	2026-02-03 14:03:00.087191
644	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 14:03:00.087191
645	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 14:03:00.087191
646	4	showroom	main_area	10	1	Low	10.00	2026-02-03 14:04:00.01755
647	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 14:04:00.01755
648	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 14:04:00.01755
649	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 14:04:00.01755
650	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 14:05:00.127918
651	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 14:05:00.127918
652	4	showroom	main_area	10	1	Low	10.00	2026-02-03 14:05:00.127918
653	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 14:05:00.127918
654	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 14:06:00.018631
655	4	showroom	main_area	10	1	Low	10.00	2026-02-03 14:06:00.018631
656	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 14:06:00.018631
657	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 14:06:00.018631
658	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 14:07:00.151908
659	4	showroom	main_area	10	1	Low	10.00	2026-02-03 14:07:00.151908
660	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 14:07:00.151908
661	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 14:07:00.151908
662	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 14:08:00.116073
663	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 14:08:00.116073
664	4	showroom	main_area	10	0	Low	0.00	2026-02-03 14:08:00.116073
665	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 14:08:00.116073
666	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 14:09:00.007051
667	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 14:09:00.007051
668	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 14:09:00.007051
669	4	showroom	main_area	10	1	Low	10.00	2026-02-03 14:09:00.007051
670	4	showroom	main_area	10	2	Low	20.00	2026-02-03 14:10:00.141021
671	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 14:10:00.141021
672	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 14:10:00.141021
673	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 14:10:00.141021
674	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 14:11:00.080668
675	4	showroom	main_area	10	2	Low	20.00	2026-02-03 14:11:00.080668
676	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 14:11:00.080668
677	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 14:11:00.080668
678	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 14:12:00.004193
679	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 14:12:00.004193
680	4	showroom	main_area	10	2	Low	20.00	2026-02-03 14:12:00.004193
681	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 14:12:00.004193
682	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 14:13:00.136027
683	4	showroom	main_area	10	2	Low	20.00	2026-02-03 14:13:00.136027
684	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 14:13:00.136027
685	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 14:13:00.136027
686	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 14:14:00.007335
687	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 14:14:00.007335
688	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 14:14:00.007335
689	4	showroom	main_area	10	2	Low	20.00	2026-02-03 14:14:00.007335
690	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 14:15:00.11035
691	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 14:15:00.11035
692	4	showroom	main_area	10	2	Low	20.00	2026-02-03 14:15:00.11035
693	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 14:15:00.11035
694	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 14:28:00.13804
695	4	showroom	main_area	10	1	Low	10.00	2026-02-03 14:28:00.13804
696	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 14:28:00.13804
697	2	robotics_lab	main_area	5	7	Crowded	140.00	2026-02-03 14:28:00.13804
698	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 14:29:00.131407
699	2	robotics_lab	main_area	5	7	Crowded	140.00	2026-02-03 14:29:00.131407
700	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 14:29:00.131407
701	4	showroom	main_area	10	1	Low	10.00	2026-02-03 14:29:00.131407
702	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 14:30:00.078317
703	4	showroom	main_area	10	2	Low	20.00	2026-02-03 14:30:00.078317
704	2	robotics_lab	main_area	5	7	Crowded	140.00	2026-02-03 14:30:00.078317
705	5	marketing-&-sales	main_area	10	5	Moderate	50.00	2026-02-03 14:30:00.078317
706	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 14:31:00.142778
707	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-03 14:31:00.142778
708	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 14:31:00.142778
709	4	showroom	main_area	10	1	Low	10.00	2026-02-03 14:31:00.142778
710	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 14:32:00.103387
711	4	showroom	main_area	10	1	Low	10.00	2026-02-03 14:32:00.103387
712	2	robotics_lab	main_area	5	7	Crowded	140.00	2026-02-03 14:32:00.103387
713	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 14:32:00.103387
714	4	showroom	main_area	10	1	Low	10.00	2026-02-03 14:33:00.005741
715	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 14:33:00.005741
716	2	robotics_lab	main_area	5	8	Crowded	160.00	2026-02-03 14:33:00.005741
717	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 14:33:00.005741
718	4	showroom	main_area	10	1	Low	10.00	2026-02-03 14:34:00.004033
719	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 14:34:00.004033
720	2	robotics_lab	main_area	5	8	Crowded	160.00	2026-02-03 14:34:00.004033
721	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 14:34:00.004033
722	4	showroom	main_area	10	1	Low	10.00	2026-02-03 14:35:00.092261
723	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-03 14:35:00.092261
724	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 14:35:00.092261
725	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 14:35:00.092261
726	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 15:09:00.085465
727	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 15:09:00.085465
728	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 15:09:00.085465
729	4	showroom	main_area	10	2	Low	20.00	2026-02-03 15:09:00.085465
730	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 15:09:00.085465
731	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 15:10:00.00288
732	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 15:10:00.00288
733	4	showroom	main_area	10	1	Low	10.00	2026-02-03 15:10:00.00288
734	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 15:10:00.00288
735	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 15:10:00.00288
736	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:11:00.082289
737	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 15:11:00.082289
738	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:11:00.082289
739	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 15:11:00.082289
740	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 15:11:00.082289
741	2	robotics_lab	main_area	5	7	Crowded	140.00	2026-02-03 15:17:00.063183
742	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 15:17:00.063183
743	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:17:00.063183
744	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 15:17:00.063183
745	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 15:17:00.063183
746	2	robotics_lab	main_area	5	8	Crowded	160.00	2026-02-03 15:18:00.011097
747	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 15:18:00.011097
748	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:18:00.011097
749	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:18:00.011097
750	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 15:18:00.011097
751	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 15:19:00.00377
752	2	robotics_lab	main_area	5	8	Crowded	160.00	2026-02-03 15:19:00.00377
753	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 15:19:00.00377
754	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 15:19:00.00377
755	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:19:00.00377
756	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 15:24:00.024327
757	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 15:24:00.024327
758	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 15:24:00.024327
759	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:24:00.024327
760	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:24:00.024327
761	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 15:25:00.00206
762	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:25:00.00206
763	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 15:25:00.00206
764	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 15:25:00.00206
765	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 15:25:00.00206
766	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 15:26:00.008622
767	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:26:00.008622
768	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:26:00.008622
769	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 15:26:00.008622
770	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 15:26:00.008622
771	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 15:27:00.083693
772	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 15:27:00.083693
773	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:27:00.083693
774	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:27:00.083693
775	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:27:00.083693
776	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:28:00.092727
777	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 15:28:00.092727
778	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 15:28:00.092727
779	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:28:00.092727
780	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 15:28:00.092727
781	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:29:00.017186
782	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:29:00.017186
783	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:29:00.017186
784	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:29:00.017186
785	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:29:00.017186
786	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:30:00.000662
787	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:30:00.000662
788	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:30:00.000662
789	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:30:00.000662
790	4	showroom	main_area	10	1	Low	10.00	2026-02-03 15:30:00.000662
791	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:31:00.085668
792	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:31:00.085668
793	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:31:00.085668
794	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:31:00.085668
795	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:31:00.085668
796	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:32:00.047941
797	4	showroom	main_area	10	1	Low	10.00	2026-02-03 15:32:00.047941
798	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:32:00.047941
799	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:32:00.047941
800	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 15:32:00.047941
801	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:33:00.004664
802	4	showroom	main_area	10	1	Low	10.00	2026-02-03 15:33:00.004664
803	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 15:33:00.004664
804	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:33:00.004664
805	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:33:00.004664
806	4	showroom	main_area	10	1	Low	10.00	2026-02-03 15:34:00.001537
807	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:34:00.001537
808	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:34:00.001537
809	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:34:00.001537
810	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 15:34:00.001537
811	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:35:00.004589
812	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 15:35:00.004589
813	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:35:00.004589
814	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:35:00.004589
815	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 15:35:00.004589
816	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:36:00.029637
817	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 15:36:00.029637
818	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:36:00.029637
819	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:36:00.029637
820	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:36:00.029637
821	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:37:00.036386
822	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 15:37:00.036386
823	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:37:00.036386
824	4	showroom	main_area	10	1	Low	10.00	2026-02-03 15:37:00.036386
825	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 15:37:00.036386
826	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 15:38:00.001882
827	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:38:00.001882
828	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:38:00.001882
829	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:38:00.001882
830	4	showroom	main_area	10	3	Low	30.00	2026-02-03 15:38:00.001882
831	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:39:00.104856
832	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:39:00.104856
833	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:39:00.104856
834	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:39:00.104856
835	4	showroom	main_area	10	2	Low	20.00	2026-02-03 15:39:00.104856
836	4	showroom	main_area	10	4	Moderate	40.00	2026-02-03 15:40:00.110905
837	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:40:00.110905
838	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:40:00.110905
839	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:40:00.110905
840	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:40:00.110905
841	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 15:41:00.024118
842	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:41:00.024118
843	4	showroom	main_area	10	7	Crowded	70.00	2026-02-03 15:41:00.024118
844	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:41:00.024118
845	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:41:00.024118
846	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:42:00.098651
847	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 15:42:00.098651
848	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:42:00.098651
849	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 15:42:00.098651
850	4	showroom	main_area	10	7	Crowded	70.00	2026-02-03 15:42:00.098651
851	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:43:00.073618
852	4	showroom	main_area	10	5	Moderate	50.00	2026-02-03 15:43:00.073618
853	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 15:43:00.073618
854	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 15:43:00.073618
855	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 15:43:00.073618
856	4	showroom	main_area	10	5	Moderate	50.00	2026-02-03 15:44:00.003358
857	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 15:44:00.003358
858	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:44:00.003358
859	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 15:44:00.003358
860	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:44:00.003358
861	4	showroom	main_area	10	4	Moderate	40.00	2026-02-03 15:45:00.134428
862	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:45:00.134428
863	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:45:00.134428
864	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:45:00.134428
865	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 15:45:00.134428
866	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:46:02.722813
867	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:46:02.722813
868	4	showroom	main_area	10	5	Moderate	50.00	2026-02-03 15:46:02.722813
869	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:46:02.722813
870	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:46:02.722813
871	4	showroom	main_area	10	6	Moderate	60.00	2026-02-03 15:47:00.002083
872	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:47:00.002083
873	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 15:47:00.002083
874	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 15:47:00.002083
875	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 15:47:00.002083
876	4	showroom	main_area	10	4	Moderate	40.00	2026-02-03 15:48:00.118636
877	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 15:48:00.118636
878	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:48:00.118636
879	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 15:48:00.118636
880	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 15:48:00.118636
881	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:49:00.106606
882	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 15:49:00.106606
883	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 15:49:00.106606
884	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 15:49:00.106606
885	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:49:00.106606
886	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:50:00.070674
887	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 15:50:00.070674
888	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 15:50:00.070674
889	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 15:50:00.070674
890	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:50:00.070674
891	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 15:51:00.082594
892	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:51:00.082594
893	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 15:51:00.082594
894	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 15:51:00.082594
895	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:51:00.082594
896	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 15:52:00.045065
897	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 15:52:00.045065
898	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:52:00.045065
899	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:52:00.045065
900	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:52:00.045065
901	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:53:00.036186
902	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 15:53:00.036186
903	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 15:53:00.036186
904	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:53:00.036186
905	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:53:00.036186
906	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 15:54:00.032885
907	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:54:00.032885
908	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:54:00.032885
909	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-03 15:54:00.032885
910	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:54:00.032885
911	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 15:55:00.061498
912	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:55:00.061498
913	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:55:00.061498
914	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 15:55:00.061498
915	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 15:55:00.061498
916	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 15:56:00.193629
917	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 15:56:00.193629
918	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:56:00.193629
919	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 15:56:00.193629
920	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:56:00.193629
921	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:57:00.088356
922	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 15:57:00.088356
923	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 15:57:00.088356
924	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:57:00.088356
925	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:57:00.088356
926	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 15:58:00.012757
927	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 15:58:00.012757
928	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:58:00.012757
929	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 15:58:00.012757
930	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-03 15:58:00.012757
931	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 15:59:00.514065
932	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-03 15:59:00.514065
933	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 15:59:00.514065
934	4	showroom	main_area	10	0	Low	0.00	2026-02-03 15:59:00.514065
935	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-03 15:59:00.514065
936	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:00:00.01458
937	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:00:00.01458
938	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 16:00:00.01458
939	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-03 16:00:00.01458
940	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 16:00:00.01458
941	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:01:00.064009
942	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:01:00.064009
943	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 16:01:00.064009
944	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:01:00.064009
945	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-03 16:01:00.064009
946	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:02:00.028249
947	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:02:00.028249
948	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:02:00.028249
949	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:02:00.028249
950	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 16:02:00.028249
951	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:03:00.111248
952	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:03:00.111248
953	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 16:03:00.111248
954	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:03:00.111248
955	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:03:00.111248
956	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:04:00.045077
957	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:04:00.045077
958	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 16:04:00.045077
959	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:04:00.045077
960	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:04:00.045077
961	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:05:00.071478
962	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-03 16:05:00.071478
963	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:05:00.071478
964	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:05:00.071478
965	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:05:00.071478
966	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:06:00.142418
967	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:06:00.142418
968	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:06:00.142418
969	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 16:06:00.142418
970	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:06:00.142418
971	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:07:00.045693
972	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-03 16:07:00.045693
973	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:07:00.045693
974	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:07:00.045693
975	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:07:00.045693
976	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:08:00.136233
977	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:08:00.136233
978	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 16:08:00.136233
979	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 16:08:00.136233
980	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:08:00.136233
981	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:09:00.215535
982	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 16:09:00.215535
983	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:09:00.215535
984	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 16:09:00.215535
985	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:09:00.215535
986	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:10:00.098036
987	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:10:00.098036
988	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 16:10:00.098036
989	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:10:00.098036
990	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:10:00.098036
991	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:11:00.082116
992	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:11:00.082116
993	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:11:00.082116
994	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:11:00.082116
995	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:11:00.082116
996	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:12:00.014429
997	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:12:00.014429
998	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:12:00.014429
999	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:12:00.014429
1000	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:12:00.014429
1001	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:13:00.038934
1002	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:13:00.038934
1003	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:13:00.038934
1004	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:13:00.038934
1005	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:13:00.038934
1006	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:14:00.006393
1007	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:14:00.006393
1008	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:14:00.006393
1009	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:14:00.006393
1010	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:14:00.006393
1011	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:15:00.087092
1012	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:15:00.087092
1013	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:15:00.087092
1014	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:15:00.087092
1015	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:15:00.087092
1016	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:16:00.064169
1017	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:16:00.064169
1018	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:16:00.064169
1019	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:16:00.064169
1020	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:16:00.064169
1021	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:17:00.076309
1022	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:17:00.076309
1023	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:17:00.076309
1024	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:17:00.076309
1025	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:17:00.076309
1026	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:18:00.096595
1027	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:18:00.096595
1028	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:18:00.096595
1029	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:18:00.096595
1030	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:18:00.096595
1031	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:19:00.082011
1032	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:19:00.082011
1033	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:19:00.082011
1034	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:19:00.082011
1035	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:19:00.082011
1036	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:20:00.076645
1037	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:20:00.076645
1038	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:20:00.076645
1039	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:20:00.076645
1040	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:20:00.076645
1041	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:21:00.105638
1042	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:21:00.105638
1043	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:21:00.105638
1044	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 16:21:00.105638
1045	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:21:00.105638
1046	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:22:00.001124
1047	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:22:00.001124
1048	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:22:00.001124
1049	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:22:00.001124
1050	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:22:00.001124
1051	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:23:00.11683
1052	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:23:00.11683
1053	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 16:23:00.11683
1054	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:23:00.11683
1055	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:23:00.11683
1056	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:24:00.125221
1057	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-03 16:24:00.125221
1058	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:24:00.125221
1059	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:24:00.125221
1060	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:24:00.125221
1061	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:25:00.10445
1062	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:25:00.10445
1063	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:25:00.10445
1064	1	robotics_lab	main_area	10	4	Moderate	40.00	2026-02-03 16:25:00.10445
1065	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:25:00.10445
1066	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:26:00.024147
1067	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:26:00.024147
1068	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:26:00.024147
1069	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-03 16:26:00.024147
1070	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:26:00.024147
1071	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-03 16:27:00.030196
1072	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:27:00.030196
1073	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:27:00.030196
1074	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:27:00.030196
1075	4	showroom	main_area	10	2	Low	20.00	2026-02-03 16:27:00.030196
1076	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:28:00.023186
1077	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 16:28:00.023186
1078	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:28:00.023186
1079	4	showroom	main_area	10	2	Low	20.00	2026-02-03 16:28:00.023186
1080	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:28:00.023186
1081	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:29:00.108448
1082	4	showroom	main_area	10	2	Low	20.00	2026-02-03 16:29:00.108448
1083	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 16:29:00.108448
1084	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 16:29:00.108448
1085	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:29:00.108448
1086	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:30:00.021406
1087	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 16:30:00.021406
1088	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:30:00.021406
1089	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:30:00.021406
1090	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:30:00.021406
1091	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:31:00.001179
1092	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:31:00.001179
1093	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:31:00.001179
1094	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:31:00.001179
1095	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 16:31:00.001179
1096	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 16:33:00.090285
1097	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:33:00.090285
1098	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:33:00.090285
1099	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:33:00.090285
1100	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:33:00.090285
1101	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:34:00.077847
1102	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:34:00.077847
1103	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 16:34:00.077847
1104	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:34:00.077847
1105	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:34:00.077847
1106	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 16:35:00.102116
1107	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 16:35:00.102116
1108	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:35:00.102116
1109	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:35:00.102116
1110	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:35:00.102116
1111	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:36:00.102253
1112	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:36:00.102253
1113	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 16:36:00.102253
1114	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 16:36:00.102253
1115	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:36:00.102253
1116	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:37:00.095576
1117	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 16:37:00.095576
1118	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:37:00.095576
1119	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:37:00.095576
1120	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:37:00.095576
1121	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 16:38:00.00548
1122	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:38:00.00548
1123	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:38:00.00548
1124	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:38:00.00548
1125	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:38:00.00548
1126	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:39:00.019543
1127	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:39:00.019543
1128	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:39:00.019543
1129	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 16:39:00.019543
1130	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-03 16:39:00.019543
1131	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 16:40:00.026227
1132	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 16:40:00.026227
1133	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:40:00.026227
1134	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:40:00.026227
1135	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:40:00.026227
1136	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:41:00.027221
1137	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 16:41:00.027221
1138	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 16:41:00.027221
1139	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:41:00.027221
1140	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:41:00.027221
1141	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:42:00.077235
1142	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:42:00.077235
1143	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:42:00.077235
1144	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:42:00.077235
1145	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 16:42:00.077235
1146	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 16:43:00.032784
1147	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:43:00.032784
1148	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:43:00.032784
1149	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:43:00.032784
1150	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:43:00.032784
1151	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:44:00.062922
1152	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:44:00.062922
1153	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:44:00.062922
1154	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:44:00.062922
1155	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 16:44:00.062922
1156	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 16:45:00.063146
1157	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:45:00.063146
1158	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:45:00.063146
1159	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:45:00.063146
1160	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:45:00.063146
1161	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:46:00.083138
1162	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:46:00.083138
1163	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:46:00.083138
1164	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:46:00.083138
1165	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 16:46:00.083138
1166	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:47:00.028801
1167	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:47:00.028801
1168	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 16:47:00.028801
1169	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 16:47:00.028801
1170	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 16:47:00.028801
1171	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:48:00.134899
1172	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:48:00.134899
1173	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 16:48:00.134899
1174	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:48:00.134899
1175	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 16:48:00.134899
1176	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:49:00.032138
1177	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 16:49:00.032138
1178	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:49:00.032138
1179	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 16:49:00.032138
1180	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:49:00.032138
1181	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:50:00.040391
1182	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:50:00.040391
1183	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:50:00.040391
1184	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 16:50:00.040391
1185	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 16:50:00.040391
1186	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 16:51:00.053563
1187	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:51:00.053563
1188	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:51:00.053563
1189	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 16:51:00.053563
1190	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 16:51:00.053563
1191	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:52:00.007599
1192	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:52:00.007599
1193	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:52:00.007599
1194	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 16:52:00.007599
1195	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 16:52:00.007599
1196	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 16:53:00.031218
1197	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:53:00.031218
1198	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 16:53:00.031218
1199	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:53:00.031218
1200	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:53:00.031218
1201	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:54:00.067437
1202	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 16:54:00.067437
1203	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:54:00.067437
1204	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:54:00.067437
1205	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 16:54:00.067437
1206	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 16:55:00.024241
1207	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:55:00.024241
1208	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:55:00.024241
1209	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 16:55:00.024241
1210	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:55:00.024241
1211	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-03 16:56:00.12677
1212	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 16:56:00.12677
1213	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:56:00.12677
1214	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 16:56:00.12677
1215	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:56:00.12677
1216	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 16:57:00.129548
1217	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:57:00.129548
1218	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 16:57:00.129548
1219	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:57:00.129548
1220	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 16:57:00.129548
1221	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 16:58:00.000971
1222	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:58:00.000971
1223	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 16:58:00.000971
1224	4	showroom	main_area	10	1	Low	10.00	2026-02-03 16:58:00.000971
1225	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:58:00.000971
1226	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 16:59:00.004148
1227	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 16:59:00.004148
1228	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 16:59:00.004148
1229	4	showroom	main_area	10	0	Low	0.00	2026-02-03 16:59:00.004148
1230	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 16:59:00.004148
1231	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 17:00:00.024021
1232	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:00:00.024021
1233	4	showroom	main_area	10	0	Low	0.00	2026-02-03 17:00:00.024021
1234	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:00:00.024021
1235	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 17:00:00.024021
1236	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:01:00.047929
1237	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 17:01:00.047929
1238	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:01:00.047929
1239	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 17:01:00.047929
1240	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:01:00.047929
1241	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:02:00.021239
1242	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 17:02:00.021239
1243	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:02:00.021239
1244	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:02:00.021239
1245	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 17:02:00.021239
1246	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 17:03:00.003343
1247	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:03:00.003343
1248	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:03:00.003343
1249	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 17:03:00.003343
1250	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:03:00.003343
1251	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 17:04:00.128769
1252	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:04:00.128769
1253	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 17:04:00.128769
1254	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:04:00.128769
1255	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:04:00.128769
1256	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:05:00.016474
1257	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 17:05:00.016474
1258	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:05:00.016474
1259	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 17:05:00.016474
1260	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:05:00.016474
1261	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 17:06:00.014655
1262	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 17:06:00.014655
1263	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:06:00.014655
1264	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:06:00.014655
1265	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:06:00.014655
1266	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:07:00.019175
1267	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:07:00.019175
1268	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:07:00.019175
1269	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:07:00.019175
1270	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:07:00.019175
1271	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:08:00.002817
1272	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:08:00.002817
1273	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:08:00.002817
1274	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:08:00.002817
1275	4	showroom	main_area	10	0	Low	0.00	2026-02-03 17:08:00.002817
1276	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:09:00.009014
1277	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:09:00.009014
1278	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:09:00.009014
1279	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:09:00.009014
1280	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:09:00.009014
1281	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:10:00.011616
1282	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:10:00.011616
1283	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:10:00.011616
1284	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:10:00.011616
1285	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:10:00.011616
1286	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:11:00.01514
1287	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:11:00.01514
1288	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:11:00.01514
1289	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:11:00.01514
1290	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:11:00.01514
1291	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:12:00.010504
1292	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:12:00.010504
1293	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:12:00.010504
1294	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:12:00.010504
1295	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:12:00.010504
1296	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:13:00.078072
1297	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:13:00.078072
1298	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:13:00.078072
1299	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:13:00.078072
1300	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:13:00.078072
1301	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 17:14:00.122531
1302	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:14:00.122531
1303	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:14:00.122531
1304	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:14:00.122531
1305	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:14:00.122531
1306	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 17:15:00.125621
1307	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:15:00.125621
1308	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:15:00.125621
1309	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:15:00.125621
1310	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:15:00.125621
1311	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:16:00.130771
1312	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:16:00.130771
1313	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:16:00.130771
1314	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:16:00.130771
1315	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:16:00.130771
1316	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:17:00.120016
1317	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:17:00.120016
1318	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 17:17:00.120016
1319	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:17:00.120016
1320	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:17:00.120016
1321	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:18:00.001385
1322	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 17:18:00.001385
1323	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:18:00.001385
1324	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:18:00.001385
1325	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 17:18:00.001385
1326	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 17:19:00.035495
1327	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 17:19:00.035495
1328	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:19:00.035495
1329	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:19:00.035495
1330	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:19:00.035495
1331	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:20:00.125602
1332	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:20:00.125602
1333	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 17:20:00.125602
1334	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:20:00.125602
1335	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:20:00.125602
1336	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 17:21:00.020033
1337	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:21:00.020033
1338	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:21:00.020033
1339	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:21:00.020033
1340	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:21:00.020033
1341	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:22:00.023114
1342	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:22:00.023114
1343	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:22:00.023114
1344	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 17:22:00.023114
1345	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:22:00.023114
1346	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:23:00.056863
1347	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 17:23:00.056863
1348	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:23:00.056863
1349	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:23:00.056863
1350	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:23:00.056863
1351	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 17:24:00.114179
1352	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:24:00.114179
1353	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:24:00.114179
1354	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:24:00.114179
1355	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:24:00.114179
1356	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:25:00.001284
1357	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:25:00.001284
1358	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 17:25:00.001284
1359	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:25:00.001284
1360	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:25:00.001284
1361	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:26:00.001943
1362	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:26:00.001943
1363	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:26:00.001943
1364	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:26:00.001943
1365	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:26:00.001943
1366	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:27:00.008267
1367	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:27:00.008267
1368	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:27:00.008267
1369	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:27:00.008267
1370	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:27:00.008267
1371	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:28:00.081119
1372	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:28:00.081119
1373	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:28:00.081119
1374	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:28:00.081119
1375	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:28:00.081119
1376	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:29:00.088037
1377	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:29:00.088037
1378	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:29:00.088037
1379	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:29:00.088037
1380	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:29:00.088037
1381	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:30:00.016132
1382	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:30:00.016132
1383	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:30:00.016132
1384	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:30:00.016132
1385	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:30:00.016132
1386	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:31:00.017784
1387	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:31:00.017784
1388	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:31:00.017784
1389	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:31:00.017784
1390	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:31:00.017784
1391	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:32:00.048315
1392	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:32:00.048315
1393	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:32:00.048315
1394	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 17:32:00.048315
1395	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:32:00.048315
1396	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:33:00.031791
1397	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:33:00.031791
1398	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 17:33:00.031791
1399	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:33:00.031791
1400	4	showroom	main_area	10	0	Low	0.00	2026-02-03 17:33:00.031791
1401	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:34:00.066708
1402	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:34:00.066708
1403	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:34:00.066708
1404	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:34:00.066708
1405	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:34:00.066708
1406	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:35:00.088369
1407	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:35:00.088369
1408	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:35:00.088369
1409	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:35:00.088369
1410	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:35:00.088369
1411	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:36:00.048912
1412	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:36:00.048912
1413	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:36:00.048912
1414	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:36:00.048912
1415	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:36:00.048912
1416	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:37:00.035155
1417	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 17:37:00.035155
1418	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:37:00.035155
1419	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:37:00.035155
1420	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:37:00.035155
1421	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 17:38:00.023448
1422	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:38:00.023448
1423	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:38:00.023448
1424	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:38:00.023448
1425	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:38:00.023448
1426	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:39:00.007012
1427	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:39:00.007012
1428	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:39:00.007012
1429	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:39:00.007012
1430	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:39:00.007012
1431	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:40:00.053964
1432	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:40:00.053964
1433	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:40:00.053964
1434	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:40:00.053964
1435	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:40:00.053964
1436	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:41:00.015448
1437	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:41:00.015448
1438	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:41:00.015448
1439	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:41:00.015448
1440	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:41:00.015448
1441	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:42:00.026936
1442	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:42:00.026936
1443	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:42:00.026936
1444	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:42:00.026936
1445	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:42:00.026936
1446	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:43:00.019001
1447	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:43:00.019001
1448	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:43:00.019001
1449	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:43:00.019001
1450	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:43:00.019001
1451	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:44:00.008859
1452	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:44:00.008859
1453	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:44:00.008859
1454	4	showroom	main_area	10	1	Low	10.00	2026-02-03 17:44:00.008859
1455	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:44:00.008859
1456	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:45:00.002997
1457	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:45:00.002997
1458	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:45:00.002997
1459	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:45:00.002997
1460	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:45:00.002997
1461	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:46:00.082552
1462	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:46:00.082552
1463	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:46:00.082552
1464	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:46:00.082552
1465	4	showroom	main_area	10	3	Low	30.00	2026-02-03 17:46:00.082552
1466	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 17:47:00.014948
1467	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:47:00.014948
1468	4	showroom	main_area	10	2	Low	20.00	2026-02-03 17:47:00.014948
1469	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:47:00.014948
1470	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:47:00.014948
1471	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:48:00.07436
1472	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:48:00.07436
1473	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:48:00.07436
1474	4	showroom	main_area	10	0	Low	0.00	2026-02-03 17:48:00.07436
1475	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:48:00.07436
1476	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:49:00.005794
1477	4	showroom	main_area	10	0	Low	0.00	2026-02-03 17:49:00.005794
1478	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:49:00.005794
1479	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:49:00.005794
1480	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:49:00.005794
1481	4	showroom	main_area	10	0	Low	0.00	2026-02-03 17:50:00.090702
1482	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:50:00.090702
1483	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:50:00.090702
1484	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 17:50:00.090702
1485	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:50:00.090702
1486	4	showroom	main_area	10	0	Low	0.00	2026-02-03 17:51:00.00244
1487	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:51:00.00244
1488	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:51:00.00244
1489	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 17:51:00.00244
1490	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:51:00.00244
1491	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:52:00.07207
1492	4	showroom	main_area	10	0	Low	0.00	2026-02-03 17:52:00.07207
1493	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:52:00.07207
1494	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:52:00.07207
1495	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:52:00.07207
1496	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:53:00.11796
1497	4	showroom	main_area	10	0	Low	0.00	2026-02-03 17:53:00.11796
1498	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:53:00.11796
1499	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-03 17:53:00.11796
1500	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:53:00.11796
1501	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:54:00.080434
1502	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:54:00.080434
1503	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:54:00.080434
1504	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:54:00.080434
1505	4	showroom	main_area	10	0	Low	0.00	2026-02-03 17:54:00.080434
1506	4	showroom	main_area	10	0	Low	0.00	2026-02-03 17:55:00.024674
1507	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 17:55:00.024674
1508	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:55:00.024674
1509	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:55:00.024674
1510	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:55:00.024674
1511	4	showroom	main_area	10	0	Low	0.00	2026-02-03 17:56:00.102585
1512	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:56:00.102585
1513	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:56:00.102585
1514	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:56:00.102585
1515	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:56:00.102585
1516	4	showroom	main_area	10	0	Low	0.00	2026-02-03 17:57:00.011256
1517	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:57:00.011256
1518	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:57:00.011256
1519	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:57:00.011256
1520	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:57:00.011256
1521	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:58:00.048741
1522	4	showroom	main_area	10	0	Low	0.00	2026-02-03 17:58:00.048741
1523	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:58:00.048741
1524	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:58:00.048741
1525	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 17:58:00.048741
1526	4	showroom	main_area	10	0	Low	0.00	2026-02-03 17:59:00.122062
1527	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 17:59:00.122062
1528	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 17:59:00.122062
1529	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 17:59:00.122062
1530	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 17:59:00.122062
1531	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:00:00.136503
1532	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:00:00.136503
1533	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:00:00.136503
1534	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:00:00.136503
1535	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:00:00.136503
1536	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:01:00.006215
1537	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:01:00.006215
1538	4	showroom	main_area	10	2	Low	20.00	2026-02-03 18:01:00.006215
1539	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:01:00.006215
1540	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:01:00.006215
1541	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:02:00.024894
1542	4	showroom	main_area	10	4	Moderate	40.00	2026-02-03 18:02:00.024894
1543	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:02:00.024894
1544	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:02:00.024894
1545	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:02:00.024894
1546	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:03:00.035542
1547	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:03:00.035542
1548	4	showroom	main_area	10	3	Low	30.00	2026-02-03 18:03:00.035542
1549	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:03:00.035542
1550	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:03:00.035542
1551	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:04:00.017889
1552	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:04:00.017889
1553	4	showroom	main_area	10	4	Moderate	40.00	2026-02-03 18:04:00.017889
1554	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:04:00.017889
1555	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:04:00.017889
1556	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:05:00.0269
1557	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:05:00.0269
1558	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:05:00.0269
1559	4	showroom	main_area	10	3	Low	30.00	2026-02-03 18:05:00.0269
1560	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:05:00.0269
1561	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:06:00.176989
1562	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:06:00.176989
1563	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:06:00.176989
1564	4	showroom	main_area	10	4	Moderate	40.00	2026-02-03 18:06:00.176989
1565	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:06:00.176989
1566	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:07:00.006102
1567	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:07:00.006102
1568	4	showroom	main_area	10	5	Moderate	50.00	2026-02-03 18:07:00.006102
1569	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:07:00.006102
1570	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:07:00.006102
1571	4	showroom	main_area	10	4	Moderate	40.00	2026-02-03 18:08:00.003611
1572	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:08:00.003611
1573	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:08:00.003611
1574	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:08:00.003611
1575	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:08:00.003611
1576	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:09:00.126615
1577	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:09:00.126615
1578	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:09:00.126615
1579	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:09:00.126615
1580	4	showroom	main_area	10	3	Low	30.00	2026-02-03 18:09:00.126615
1581	4	showroom	main_area	10	1	Low	10.00	2026-02-03 18:10:00.044137
1582	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:10:00.044137
1583	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:10:00.044137
1584	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:10:00.044137
1585	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:10:00.044137
1586	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:11:00.042415
1587	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:11:00.042415
1588	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:11:00.042415
1589	4	showroom	main_area	10	1	Low	10.00	2026-02-03 18:11:00.042415
1590	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:11:00.042415
1591	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:12:00.036725
1592	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:12:00.036725
1593	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:12:00.036725
1594	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:12:00.036725
1595	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:12:00.036725
1596	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:13:00.006749
1597	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:13:00.006749
1598	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:13:00.006749
1599	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:13:00.006749
1600	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:13:00.006749
1601	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:14:00.08906
1602	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:14:00.08906
1603	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:14:00.08906
1604	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:14:00.08906
1605	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:14:00.08906
1606	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:15:00.02983
1607	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:15:00.02983
1608	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:15:00.02983
1609	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:15:00.02983
1610	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:15:00.02983
1611	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:16:00.025179
1612	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:16:00.025179
1613	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:16:00.025179
1614	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:16:00.025179
1615	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:16:00.025179
1616	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:17:00.003324
1617	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:17:00.003324
1618	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:17:00.003324
1619	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:17:00.003324
1620	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:17:00.003324
1621	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:18:00.011268
1622	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:18:00.011268
1623	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 18:18:00.011268
1624	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:18:00.011268
1625	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:18:00.011268
1626	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-03 18:19:00.068514
1627	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:19:00.068514
1628	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:19:00.068514
1629	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:19:00.068514
1630	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:19:00.068514
1631	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:20:00.029636
1632	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:20:00.029636
1633	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:20:00.029636
1634	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:20:00.029636
1635	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:20:00.029636
1636	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:21:00.045363
1637	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:21:00.045363
1638	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:21:00.045363
1639	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:21:00.045363
1640	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:21:00.045363
1641	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:22:00.073624
1642	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:22:00.073624
1643	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:22:00.073624
1644	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:22:00.073624
1645	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:22:00.073624
1646	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:23:00.06953
1647	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:23:00.06953
1648	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:23:00.06953
1649	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:23:00.06953
1650	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:23:00.06953
1651	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:24:00.044653
1652	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:24:00.044653
1653	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:24:00.044653
1654	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:24:00.044653
1655	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:24:00.044653
1656	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:25:00.003256
1657	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:25:00.003256
1658	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:25:00.003256
1659	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:25:00.003256
1660	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:25:00.003256
1661	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:26:00.039659
1662	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:26:00.039659
1663	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:26:00.039659
1664	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:26:00.039659
1665	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:26:00.039659
1666	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:27:00.059814
1667	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:27:00.059814
1668	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:27:00.059814
1669	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:27:00.059814
1670	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:27:00.059814
1671	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:28:00.049363
1672	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:28:00.049363
1673	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:28:00.049363
1674	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:28:00.049363
1675	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:28:00.049363
1676	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:29:00.077602
1677	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:29:00.077602
1678	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:29:00.077602
1679	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:29:00.077602
1680	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:29:00.077602
1681	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:30:00.074411
1682	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:30:00.074411
1683	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:30:00.074411
1684	4	showroom	main_area	10	1	Low	10.00	2026-02-03 18:30:00.074411
1685	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:30:00.074411
1686	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:31:00.045559
1687	4	showroom	main_area	10	1	Low	10.00	2026-02-03 18:31:00.045559
1688	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:31:00.045559
1689	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:31:00.045559
1690	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:31:00.045559
1691	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:32:00.083974
1692	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:32:00.083974
1693	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:32:00.083974
1694	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:32:00.083974
1695	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:32:00.083974
1696	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:33:00.053328
1697	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:33:00.053328
1698	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:33:00.053328
1699	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:33:00.053328
1700	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:33:00.053328
1701	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:34:00.020436
1702	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:34:00.020436
1703	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:34:00.020436
1704	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:34:00.020436
1705	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:34:00.020436
1706	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:35:00.038958
1707	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:35:00.038958
1708	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:35:00.038958
1709	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:35:00.038958
1710	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:35:00.038958
1711	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:36:00.095343
1712	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:36:00.095343
1713	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:36:00.095343
1714	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:36:00.095343
1715	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:36:00.095343
1716	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:37:00.074396
1717	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:37:00.074396
1718	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:37:00.074396
1719	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:37:00.074396
1720	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:37:00.074396
1721	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:38:00.035822
1722	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:38:00.035822
1723	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:38:00.035822
1724	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:38:00.035822
1725	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:38:00.035822
1726	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:39:00.137783
1727	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:39:00.137783
1728	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:39:00.137783
1729	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:39:00.137783
1730	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:39:00.137783
1731	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:40:00.100909
1732	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:40:00.100909
1733	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:40:00.100909
1734	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:40:00.100909
1735	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:40:00.100909
1736	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:41:00.006336
1737	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:41:00.006336
1738	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:41:00.006336
1739	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:41:00.006336
1740	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:41:00.006336
1741	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:42:00.004699
1742	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:42:00.004699
1743	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:42:00.004699
1744	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:42:00.004699
1745	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:42:00.004699
1746	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:43:00.079758
1747	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:43:00.079758
1748	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:43:00.079758
1749	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:43:00.079758
1750	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:43:00.079758
1751	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:44:00.010587
1752	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:44:00.010587
1753	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:44:00.010587
1754	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:44:00.010587
1755	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:44:00.010587
1756	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:45:00.064066
1757	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:45:00.064066
1758	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:45:00.064066
1759	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:45:00.064066
1760	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:45:00.064066
1761	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:46:00.073169
1762	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:46:00.073169
1763	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:46:00.073169
1764	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:46:00.073169
1765	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:46:00.073169
1766	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 18:47:00.089259
1767	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:47:00.089259
1768	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:47:00.089259
1769	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:47:00.089259
1770	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:47:00.089259
1771	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:48:00.089336
1772	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:48:00.089336
1773	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:48:00.089336
1774	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:48:00.089336
1775	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:48:00.089336
1776	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 18:49:00.007373
1777	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:49:00.007373
1778	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:49:00.007373
1779	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:49:00.007373
1780	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:49:00.007373
1781	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:50:00.003487
1782	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 18:50:00.003487
1783	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:50:00.003487
1784	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:50:00.003487
1785	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:50:00.003487
1786	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:51:00.081554
1787	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:51:00.081554
1788	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:51:00.081554
1789	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:51:00.081554
1790	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:51:00.081554
1791	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:52:00.090789
1792	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:52:00.090789
1793	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:52:00.090789
1794	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:52:00.090789
1795	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:52:00.090789
1796	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:53:00.10579
1797	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:53:00.10579
1798	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:53:00.10579
1799	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:53:00.10579
1800	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:53:00.10579
1801	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:54:00.00321
1802	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:54:00.00321
1803	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 18:54:00.00321
1804	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:54:00.00321
1805	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:54:00.00321
1806	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:55:00.056089
1807	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:55:00.056089
1808	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:55:00.056089
1809	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 18:55:00.056089
1810	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:55:00.056089
1811	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:56:00.028016
1812	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:56:00.028016
1813	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:56:00.028016
1814	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:56:00.028016
1815	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:56:00.028016
1816	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:57:00.021336
1817	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:57:00.021336
1818	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:57:00.021336
1819	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:57:00.021336
1820	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:57:00.021336
1821	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:58:00.003556
1822	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:58:00.003556
1823	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:58:00.003556
1824	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:58:00.003556
1825	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:58:00.003556
1826	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 18:59:00.093257
1827	4	showroom	main_area	10	0	Low	0.00	2026-02-03 18:59:00.093257
1828	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 18:59:00.093257
1829	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 18:59:00.093257
1830	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 18:59:00.093257
1831	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:00:00.107901
1832	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:00:00.107901
1833	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:00:00.107901
1834	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:00:00.107901
1835	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:00:00.107901
1836	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:01:00.005286
1837	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:01:00.005286
1838	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 19:01:00.005286
1839	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:01:00.005286
1840	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:01:00.005286
1841	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:02:00.070606
1842	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:02:00.070606
1843	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:02:00.070606
1844	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:02:00.070606
1845	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:02:00.070606
1846	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:03:00.010686
1847	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:03:00.010686
1848	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:03:00.010686
1849	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:03:00.010686
1850	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:03:00.010686
1851	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:04:00.117774
1852	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:04:00.117774
1853	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:04:00.117774
1854	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:04:00.117774
1855	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:04:00.117774
1856	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:05:00.005212
1857	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:05:00.005212
1858	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:05:00.005212
1859	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:05:00.005212
1860	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:05:00.005212
1861	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:06:00.005189
1862	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:06:00.005189
1863	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:06:00.005189
1864	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:06:00.005189
1865	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:06:00.005189
1866	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:07:00.035913
1867	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:07:00.035913
1868	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:07:00.035913
1869	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:07:00.035913
1870	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:07:00.035913
1871	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:08:00.013441
1872	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:08:00.013441
1873	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:08:00.013441
1874	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:08:00.013441
1875	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:08:00.013441
1876	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:09:00.066165
1877	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:09:00.066165
1878	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:09:00.066165
1879	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:09:00.066165
1880	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:09:00.066165
1881	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:10:00.003075
1882	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:10:00.003075
1883	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:10:00.003075
1884	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:10:00.003075
1885	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:10:00.003075
1886	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:11:00.041859
1887	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:11:00.041859
1888	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:11:00.041859
1889	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:11:00.041859
1890	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:11:00.041859
1891	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:12:00.003873
1892	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:12:00.003873
1893	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:12:00.003873
1894	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:12:00.003873
1895	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:12:00.003873
1896	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:13:00.079654
1897	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:13:00.079654
1898	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:13:00.079654
1899	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:13:00.079654
1900	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:13:00.079654
1901	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:14:00.139613
1902	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:14:00.139613
1903	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:14:00.139613
1904	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:14:00.139613
1905	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:14:00.139613
1906	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:15:00.067361
1907	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:15:00.067361
1908	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:15:00.067361
1909	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:15:00.067361
1910	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:15:00.067361
1911	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:16:00.012939
1912	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:16:00.012939
1913	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:16:00.012939
1914	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:16:00.012939
1915	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:16:00.012939
1916	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:17:00.075964
1917	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:17:00.075964
1918	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:17:00.075964
1919	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:17:00.075964
1920	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:17:00.075964
1921	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:18:00.062419
1922	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:18:00.062419
1923	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:18:00.062419
1924	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:18:00.062419
1925	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:18:00.062419
1926	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:19:00.054441
1927	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:19:00.054441
1928	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:19:00.054441
1929	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:19:00.054441
1930	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:19:00.054441
1931	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:20:00.067911
1932	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:20:00.067911
1933	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:20:00.067911
1934	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:20:00.067911
1935	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:20:00.067911
1936	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:21:00.019591
1937	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:21:00.019591
1938	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:21:00.019591
1939	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:21:00.019591
1940	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:21:00.019591
1941	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:22:00.000638
1942	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:22:00.000638
1943	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:22:00.000638
1944	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:22:00.000638
1945	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:22:00.000638
1946	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:23:00.018704
1947	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:23:00.018704
1948	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:23:00.018704
1949	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:23:00.018704
1950	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:23:00.018704
1951	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:24:00.074747
1952	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:24:00.074747
1953	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:24:00.074747
1954	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:24:00.074747
1955	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:24:00.074747
1956	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:25:00.007854
1957	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:25:00.007854
1958	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:25:00.007854
1959	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:25:00.007854
1960	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:25:00.007854
1961	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:26:00.005738
1962	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:26:00.005738
1963	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:26:00.005738
1964	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:26:00.005738
1965	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:26:00.005738
1966	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:27:00.031763
1967	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:27:00.031763
1968	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:27:00.031763
1969	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:27:00.031763
1970	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:27:00.031763
1971	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:28:00.021177
1972	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:28:00.021177
1973	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:28:00.021177
1974	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:28:00.021177
1975	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:28:00.021177
1976	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:29:00.170355
1977	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:29:00.170355
1978	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:29:00.170355
1979	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:29:00.170355
1980	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:29:00.170355
1981	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:30:00.000752
1982	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:30:00.000752
1983	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:30:00.000752
1984	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:30:00.000752
1985	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:30:00.000752
1986	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:31:00.020163
1987	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:31:00.020163
1988	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:31:00.020163
1989	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:31:00.020163
1990	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:31:00.020163
1991	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:32:00.078742
1992	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:32:00.078742
1993	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:32:00.078742
1994	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:32:00.078742
1995	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:32:00.078742
1996	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:33:00.001716
1997	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:33:00.001716
1998	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:33:00.001716
1999	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:33:00.001716
2000	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:33:00.001716
2001	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:34:00.105838
2002	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:34:00.105838
2003	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:34:00.105838
2004	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:34:00.105838
2005	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:34:00.105838
2006	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:35:00.011338
2007	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:35:00.011338
2008	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:35:00.011338
2009	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:35:00.011338
2010	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:35:00.011338
2011	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:36:00.137353
2012	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:36:00.137353
2013	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:36:00.137353
2014	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:36:00.137353
2015	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:36:00.137353
2016	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:37:00.092819
2017	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:37:00.092819
2018	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:37:00.092819
2019	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:37:00.092819
2020	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:37:00.092819
2021	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:38:00.002825
2022	4	showroom	main_area	10	1	Low	10.00	2026-02-03 19:38:00.002825
2023	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:38:00.002825
2024	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:38:00.002825
2025	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:38:00.002825
2026	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:39:00.002768
2027	4	showroom	main_area	10	1	Low	10.00	2026-02-03 19:39:00.002768
2028	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:39:00.002768
2029	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:39:00.002768
2030	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:39:00.002768
2031	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:40:00.007507
2032	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:40:00.007507
2033	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:40:00.007507
2034	4	showroom	main_area	10	1	Low	10.00	2026-02-03 19:40:00.007507
2035	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:40:00.007507
2036	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:41:00.051543
2037	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:41:00.051543
2038	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:41:00.051543
2039	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:41:00.051543
2040	4	showroom	main_area	10	1	Low	10.00	2026-02-03 19:41:00.051543
2041	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:42:00.018129
2042	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:42:00.018129
2043	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:42:00.018129
2044	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:42:00.018129
2045	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:42:00.018129
2046	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-03 19:43:00.008919
2047	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:43:00.008919
2048	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:43:00.008919
2049	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:43:00.008919
2050	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:43:00.008919
2051	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:44:00.001396
2052	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:44:00.001396
2053	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:44:00.001396
2054	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:44:00.001396
2055	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:44:00.001396
2056	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:45:00.074218
2057	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:45:00.074218
2058	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:45:00.074218
2059	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-03 19:45:00.074218
2060	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:45:00.074218
2061	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:46:00.02754
2062	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:46:00.02754
2063	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:46:00.02754
2064	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-03 19:46:00.02754
2065	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:46:00.02754
2066	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:47:00.051853
2067	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:47:00.051853
2068	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:47:00.051853
2069	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:47:00.051853
2070	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:47:00.051853
2071	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:48:00.027249
2072	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:48:00.027249
2073	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:48:00.027249
2074	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:48:00.027249
2075	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:48:00.027249
2076	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:49:00.001363
2077	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:49:00.001363
2078	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:49:00.001363
2079	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:49:00.001363
2080	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:49:00.001363
2081	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:50:00.001276
2082	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:50:00.001276
2083	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:50:00.001276
2084	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:50:00.001276
2085	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:50:00.001276
2086	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:51:00.064178
2087	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:51:00.064178
2088	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:51:00.064178
2089	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:51:00.064178
2090	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:51:00.064178
2091	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:52:00.060719
2092	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:52:00.060719
2093	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:52:00.060719
2094	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:52:00.060719
2095	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:52:00.060719
2096	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:53:00.038481
2097	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:53:00.038481
2098	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:53:00.038481
2099	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:53:00.038481
2100	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:53:00.038481
2101	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:54:00.024817
2102	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:54:00.024817
2103	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:54:00.024817
2104	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:54:00.024817
2105	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:54:00.024817
2106	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:55:00.002827
2107	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:55:00.002827
2108	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:55:00.002827
2109	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:55:00.002827
2110	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:55:00.002827
2111	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:56:00.005119
2112	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:56:00.005119
2113	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:56:00.005119
2114	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:56:00.005119
2115	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:56:00.005119
2116	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:57:00.127757
2117	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:57:00.127757
2118	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:57:00.127757
2119	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:57:00.127757
2120	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:57:00.127757
2121	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:58:00.021707
2122	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:58:00.021707
2123	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:58:00.021707
2124	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:58:00.021707
2125	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:58:00.021707
2126	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 19:59:00.062411
2127	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 19:59:00.062411
2128	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 19:59:00.062411
2129	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 19:59:00.062411
2130	4	showroom	main_area	10	0	Low	0.00	2026-02-03 19:59:00.062411
2131	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:00:00.025591
2132	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:00:00.025591
2133	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:00:00.025591
2134	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:00:00.025591
2135	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:00:00.025591
2136	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:01:00.002526
2137	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:01:00.002526
2138	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:01:00.002526
2139	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:01:00.002526
2140	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:01:00.002526
2141	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:02:00.111093
2142	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:02:00.111093
2143	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:02:00.111093
2144	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:02:00.111093
2145	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:02:00.111093
2146	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:03:00.069824
2147	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:03:00.069824
2148	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:03:00.069824
2149	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:03:00.069824
2150	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:03:00.069824
2151	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:04:00.05439
2152	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:04:00.05439
2153	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:04:00.05439
2154	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:04:00.05439
2155	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:04:00.05439
2156	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:05:00.049338
2157	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:05:00.049338
2158	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:05:00.049338
2159	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:05:00.049338
2160	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:05:00.049338
2161	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:06:00.021988
2162	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:06:00.021988
2163	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:06:00.021988
2164	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:06:00.021988
2165	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:06:00.021988
2166	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:07:00.047194
2167	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:07:00.047194
2168	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:07:00.047194
2169	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:07:00.047194
2170	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:07:00.047194
2171	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:08:00.068069
2172	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:08:00.068069
2173	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:08:00.068069
2174	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:08:00.068069
2175	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:08:00.068069
2176	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:09:00.10814
2177	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:09:00.10814
2178	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:09:00.10814
2179	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:09:00.10814
2180	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:09:00.10814
2181	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:10:00.005142
2182	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:10:00.005142
2183	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:10:00.005142
2184	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:10:00.005142
2185	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:10:00.005142
2186	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:11:00.041865
2187	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:11:00.041865
2188	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:11:00.041865
2189	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:11:00.041865
2190	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:11:00.041865
2191	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:12:00.011227
2192	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:12:00.011227
2193	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:12:00.011227
2194	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:12:00.011227
2195	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:12:00.011227
2196	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:13:00.031017
2197	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:13:00.031017
2198	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:13:00.031017
2199	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:13:00.031017
2200	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:13:00.031017
2201	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:14:00.009665
2202	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:14:00.009665
2203	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:14:00.009665
2204	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:14:00.009665
2205	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:14:00.009665
2206	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:15:00.000642
2207	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:15:00.000642
2208	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:15:00.000642
2209	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:15:00.000642
2210	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:15:00.000642
2211	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:16:00.065459
2212	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:16:00.065459
2213	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:16:00.065459
2214	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:16:00.065459
2215	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:16:00.065459
2216	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:17:00.039338
2217	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:17:00.039338
2218	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:17:00.039338
2219	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:17:00.039338
2220	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:17:00.039338
2221	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:18:00.022002
2222	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:18:00.022002
2223	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:18:00.022002
2224	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:18:00.022002
2225	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:18:00.022002
2226	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:19:00.116689
2227	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:19:00.116689
2228	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:19:00.116689
2229	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:19:00.116689
2230	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:19:00.116689
2231	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:20:00.061071
2232	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:20:00.061071
2233	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:20:00.061071
2234	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:20:00.061071
2235	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:20:00.061071
2236	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:21:00.062265
2237	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:21:00.062265
2238	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:21:00.062265
2239	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:21:00.062265
2240	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:21:00.062265
2241	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:22:00.060612
2242	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:22:00.060612
2243	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:22:00.060612
2244	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:22:00.060612
2245	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:22:00.060612
2246	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:23:00.005021
2247	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:23:00.005021
2248	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:23:00.005021
2249	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:23:00.005021
2250	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:23:00.005021
2251	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:24:00.053542
2252	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:24:00.053542
2253	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:24:00.053542
2254	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:24:00.053542
2255	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:24:00.053542
2256	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:25:00.021154
2257	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:25:00.021154
2258	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:25:00.021154
2259	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:25:00.021154
2260	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:25:00.021154
2261	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:26:00.119892
2262	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:26:00.119892
2263	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:26:00.119892
2264	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:26:00.119892
2265	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:26:00.119892
2266	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:27:00.035424
2267	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:27:00.035424
2268	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:27:00.035424
2269	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:27:00.035424
2270	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:27:00.035424
2271	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:28:00.053139
2272	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:28:00.053139
2273	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:28:00.053139
2274	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:28:00.053139
2275	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:28:00.053139
2276	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:29:00.111609
2277	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:29:00.111609
2278	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:29:00.111609
2279	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:29:00.111609
2280	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:29:00.111609
2281	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:30:00.037759
2282	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:30:00.037759
2283	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:30:00.037759
2284	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:30:00.037759
2285	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:30:00.037759
2286	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:31:00.090257
2287	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:31:00.090257
2288	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:31:00.090257
2289	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:31:00.090257
2290	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:31:00.090257
2291	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:32:00.063455
2292	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:32:00.063455
2293	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:32:00.063455
2294	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:32:00.063455
2295	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:32:00.063455
2296	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:33:00.005946
2297	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:33:00.005946
2298	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:33:00.005946
2299	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:33:00.005946
2300	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:33:00.005946
2301	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:34:00.096597
2302	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:34:00.096597
2303	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:34:00.096597
2304	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:34:00.096597
2305	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:34:00.096597
2306	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:35:00.016292
2307	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:35:00.016292
2308	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:35:00.016292
2309	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:35:00.016292
2310	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:35:00.016292
2311	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:36:00.092819
2312	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:36:00.092819
2313	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:36:00.092819
2314	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:36:00.092819
2315	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:36:00.092819
2316	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:37:00.006735
2317	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:37:00.006735
2318	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:37:00.006735
2319	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:37:00.006735
2320	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:37:00.006735
2321	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:38:00.071592
2322	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:38:00.071592
2323	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:38:00.071592
2324	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:38:00.071592
2325	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:38:00.071592
2326	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:39:00.028057
2327	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:39:00.028057
2328	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:39:00.028057
2329	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:39:00.028057
2330	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:39:00.028057
2331	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:40:00.008175
2332	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:40:00.008175
2333	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:40:00.008175
2334	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:40:00.008175
2335	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:40:00.008175
2336	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:41:00.050784
2337	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:41:00.050784
2338	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:41:00.050784
2339	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:41:00.050784
2340	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:41:00.050784
2341	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:42:00.022175
2342	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:42:00.022175
2343	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:42:00.022175
2344	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:42:00.022175
2345	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:42:00.022175
2346	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:43:00.005692
2347	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:43:00.005692
2348	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:43:00.005692
2349	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:43:00.005692
2350	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:43:00.005692
2351	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:44:00.039556
2352	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:44:00.039556
2353	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:44:00.039556
2354	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:44:00.039556
2355	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:44:00.039556
2356	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:45:00.063794
2357	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:45:00.063794
2358	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:45:00.063794
2359	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:45:00.063794
2360	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:45:00.063794
2361	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:46:00.01433
2362	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:46:00.01433
2363	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:46:00.01433
2364	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:46:00.01433
2365	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:46:00.01433
2366	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:47:00.080045
2367	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:47:00.080045
2368	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:47:00.080045
2369	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:47:00.080045
2370	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:47:00.080045
2371	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:48:00.050519
2372	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:48:00.050519
2373	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:48:00.050519
2374	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:48:00.050519
2375	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:48:00.050519
2376	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:49:00.082149
2377	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:49:00.082149
2378	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:49:00.082149
2379	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:49:00.082149
2380	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:49:00.082149
2381	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:50:00.017242
2382	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:50:00.017242
2383	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:50:00.017242
2384	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:50:00.017242
2385	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:50:00.017242
2386	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:51:00.079524
2387	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:51:00.079524
2388	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:51:00.079524
2389	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:51:00.079524
2390	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:51:00.079524
2391	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:52:00.010339
2392	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:52:00.010339
2393	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:52:00.010339
2394	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:52:00.010339
2395	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:52:00.010339
2396	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:53:00.115437
2397	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:53:00.115437
2398	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:53:00.115437
2399	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:53:00.115437
2400	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:53:00.115437
2401	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:54:00.007759
2402	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:54:00.007759
2403	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:54:00.007759
2404	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:54:00.007759
2405	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:54:00.007759
2406	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:55:00.028917
2407	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:55:00.028917
2408	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:55:00.028917
2409	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:55:00.028917
2410	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:55:00.028917
2411	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:56:00.007604
2412	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:56:00.007604
2413	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:56:00.007604
2414	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:56:00.007604
2415	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:56:00.007604
2416	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:57:00.094638
2417	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:57:00.094638
2418	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:57:00.094638
2419	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:57:00.094638
2420	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:57:00.094638
2421	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:58:00.003094
2422	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:58:00.003094
2423	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:58:00.003094
2424	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:58:00.003094
2425	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:58:00.003094
2426	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 20:59:00.03493
2427	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 20:59:00.03493
2428	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 20:59:00.03493
2429	4	showroom	main_area	10	0	Low	0.00	2026-02-03 20:59:00.03493
2430	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 20:59:00.03493
2431	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:00:00.129045
2432	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:00:00.129045
2433	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:00:00.129045
2434	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:00:00.129045
2435	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:00:00.129045
2436	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:01:00.03703
2437	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:01:00.03703
2438	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:01:00.03703
2439	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:01:00.03703
2440	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:01:00.03703
2441	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:02:00.037607
2442	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:02:00.037607
2443	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:02:00.037607
2444	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:02:00.037607
2445	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:02:00.037607
2446	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:03:00.094878
2447	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:03:00.094878
2448	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:03:00.094878
2449	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:03:00.094878
2450	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:03:00.094878
2451	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:04:00.006303
2452	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:04:00.006303
2453	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:04:00.006303
2454	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:04:00.006303
2455	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:04:00.006303
2456	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:05:00.073999
2457	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:05:00.073999
2458	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:05:00.073999
2459	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:05:00.073999
2460	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:05:00.073999
2461	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:06:00.000975
2462	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:06:00.000975
2463	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:06:00.000975
2464	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:06:00.000975
2465	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:06:00.000975
2466	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:07:00.099559
2467	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:07:00.099559
2468	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:07:00.099559
2469	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:07:00.099559
2470	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:07:00.099559
2471	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:08:00.100892
2472	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:08:00.100892
2473	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:08:00.100892
2474	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:08:00.100892
2475	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:08:00.100892
2476	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:09:00.130471
2477	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:09:00.130471
2478	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:09:00.130471
2479	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:09:00.130471
2480	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:09:00.130471
2481	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:10:00.011561
2482	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:10:00.011561
2483	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:10:00.011561
2484	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:10:00.011561
2485	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:10:00.011561
2486	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:11:00.019245
2487	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:11:00.019245
2488	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:11:00.019245
2489	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:11:00.019245
2490	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:11:00.019245
2491	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:12:00.004561
2492	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:12:00.004561
2493	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:12:00.004561
2494	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:12:00.004561
2495	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:12:00.004561
2496	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:13:00.060366
2497	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:13:00.060366
2498	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:13:00.060366
2499	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:13:00.060366
2500	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:13:00.060366
2501	4	showroom	main_area	10	1	Low	10.00	2026-02-03 21:14:00.029631
2502	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:14:00.029631
2503	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:14:00.029631
2504	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:14:00.029631
2505	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:14:00.029631
2506	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:15:00.029795
2507	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:15:00.029795
2508	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:15:00.029795
2509	4	showroom	main_area	10	2	Low	20.00	2026-02-03 21:15:00.029795
2510	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:15:00.029795
2511	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:16:00.004913
2512	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:16:00.004913
2513	4	showroom	main_area	10	1	Low	10.00	2026-02-03 21:16:00.004913
2514	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:16:00.004913
2515	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:16:00.004913
2516	4	showroom	main_area	10	1	Low	10.00	2026-02-03 21:17:00.098817
2517	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:17:00.098817
2518	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:17:00.098817
2519	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:17:00.098817
2520	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:17:00.098817
2521	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:18:00.013356
2522	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:18:00.013356
2523	4	showroom	main_area	10	1	Low	10.00	2026-02-03 21:18:00.013356
2524	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:18:00.013356
2525	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:18:00.013356
2526	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:19:00.026449
2527	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:19:00.026449
2528	4	showroom	main_area	10	2	Low	20.00	2026-02-03 21:19:00.026449
2529	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:19:00.026449
2530	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:19:00.026449
2531	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:20:00.058184
2532	4	showroom	main_area	10	1	Low	10.00	2026-02-03 21:20:00.058184
2533	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:20:00.058184
2534	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:20:00.058184
2535	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:20:00.058184
2536	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:21:00.094561
2537	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:21:00.094561
2538	4	showroom	main_area	10	2	Low	20.00	2026-02-03 21:21:00.094561
2539	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:21:00.094561
2540	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:21:00.094561
2541	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:22:00.043202
2542	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:22:00.043202
2543	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:22:00.043202
2544	4	showroom	main_area	10	2	Low	20.00	2026-02-03 21:22:00.043202
2545	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:22:00.043202
2546	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:23:00.101853
2547	4	showroom	main_area	10	2	Low	20.00	2026-02-03 21:23:00.101853
2548	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:23:00.101853
2549	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:23:00.101853
2550	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:23:00.101853
2551	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:24:00.09545
2552	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:24:00.09545
2553	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:24:00.09545
2554	4	showroom	main_area	10	3	Low	30.00	2026-02-03 21:24:00.09545
2555	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:24:00.09545
2556	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:25:00.016986
2557	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:25:00.016986
2558	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:25:00.016986
2559	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:25:00.016986
2560	4	showroom	main_area	10	1	Low	10.00	2026-02-03 21:25:00.016986
2561	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:26:00.002168
2562	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:26:00.002168
2563	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:26:00.002168
2564	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:26:00.002168
2565	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:26:00.002168
2566	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:27:00.049843
2567	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:27:00.049843
2568	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:27:00.049843
2569	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:27:00.049843
2570	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:27:00.049843
2571	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:28:00.03631
2572	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:28:00.03631
2573	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:28:00.03631
2574	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:28:00.03631
2575	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:28:00.03631
2576	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:29:00.040887
2577	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:29:00.040887
2578	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:29:00.040887
2579	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:29:00.040887
2580	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:29:00.040887
2581	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:30:00.021403
2582	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:30:00.021403
2583	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:30:00.021403
2584	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:30:00.021403
2585	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:30:00.021403
2586	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:31:00.006622
2587	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:31:00.006622
2588	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:31:00.006622
2589	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:31:00.006622
2590	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:31:00.006622
2591	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:32:00.023913
2592	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:32:00.023913
2593	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:32:00.023913
2594	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:32:00.023913
2595	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:32:00.023913
2596	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:33:00.073893
2597	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:33:00.073893
2598	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:33:00.073893
2599	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:33:00.073893
2600	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:33:00.073893
2601	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:34:00.096948
2602	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:34:00.096948
2603	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:34:00.096948
2604	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:34:00.096948
2605	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:34:00.096948
2606	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:35:00.007637
2607	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:35:00.007637
2608	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:35:00.007637
2609	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:35:00.007637
2610	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:35:00.007637
2611	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:36:00.098309
2612	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:36:00.098309
2613	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:36:00.098309
2614	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:36:00.098309
2615	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:36:00.098309
2616	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:37:00.025991
2617	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:37:00.025991
2618	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:37:00.025991
2619	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:37:00.025991
2620	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:37:00.025991
2621	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:38:00.022951
2622	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:38:00.022951
2623	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:38:00.022951
2624	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:38:00.022951
2625	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:38:00.022951
2626	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:39:00.053526
2627	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:39:00.053526
2628	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:39:00.053526
2629	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:39:00.053526
2630	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:39:00.053526
2631	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:40:00.00246
2632	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:40:00.00246
2633	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:40:00.00246
2634	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:40:00.00246
2635	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:40:00.00246
2636	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:41:00.026517
2637	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:41:00.026517
2638	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:41:00.026517
2639	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:41:00.026517
2640	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:41:00.026517
2641	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:42:00.124357
2642	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:42:00.124357
2643	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:42:00.124357
2644	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:42:00.124357
2645	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:42:00.124357
2646	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:43:00.014125
2647	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:43:00.014125
2648	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:43:00.014125
2649	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:43:00.014125
2650	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:43:00.014125
2651	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:44:00.01054
2652	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:44:00.01054
2653	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:44:00.01054
2654	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:44:00.01054
2655	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:44:00.01054
2656	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:45:00.011342
2657	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:45:00.011342
2658	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:45:00.011342
2659	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:45:00.011342
2660	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:45:00.011342
2661	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:46:00.05188
2662	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:46:00.05188
2663	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:46:00.05188
2664	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:46:00.05188
2665	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:46:00.05188
2666	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:47:00.044471
2667	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:47:00.044471
2668	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:47:00.044471
2669	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:47:00.044471
2670	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:47:00.044471
2671	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:48:00.005226
2672	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:48:00.005226
2673	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:48:00.005226
2674	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:48:00.005226
2675	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:48:00.005226
2676	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:49:00.015352
2677	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:49:00.015352
2678	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:49:00.015352
2679	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:49:00.015352
2680	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:49:00.015352
2681	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:50:00.002893
2682	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:50:00.002893
2683	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:50:00.002893
2684	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:50:00.002893
2685	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:50:00.002893
2686	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:51:00.010994
2687	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:51:00.010994
2688	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:51:00.010994
2689	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:51:00.010994
2690	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:51:00.010994
2691	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:52:00.010201
2692	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:52:00.010201
2693	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:52:00.010201
2694	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:52:00.010201
2695	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:52:00.010201
2696	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:53:00.013265
2697	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:53:00.013265
2698	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:53:00.013265
2699	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:53:00.013265
2700	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:53:00.013265
2701	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:54:00.060242
2702	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:54:00.060242
2703	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:54:00.060242
2704	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:54:00.060242
2705	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:54:00.060242
2706	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:55:00.03423
2707	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:55:00.03423
2708	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:55:00.03423
2709	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:55:00.03423
2710	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:55:00.03423
2711	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:56:00.103754
2712	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:56:00.103754
2713	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:56:00.103754
2714	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:56:00.103754
2715	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:56:00.103754
2716	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:57:00.104838
2717	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:57:00.104838
2718	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:57:00.104838
2719	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:57:00.104838
2720	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:57:00.104838
2721	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:58:00.136748
2722	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:58:00.136748
2723	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:58:00.136748
2724	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:58:00.136748
2725	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:58:00.136748
2726	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 21:59:00.030657
2727	4	showroom	main_area	10	0	Low	0.00	2026-02-03 21:59:00.030657
2728	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 21:59:00.030657
2729	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 21:59:00.030657
2730	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 21:59:00.030657
2731	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:00:00.051477
2732	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:00:00.051477
2733	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:00:00.051477
2734	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:00:00.051477
2735	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:00:00.051477
2736	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:01:00.060935
2737	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:01:00.060935
2738	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:01:00.060935
2739	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:01:00.060935
2740	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:01:00.060935
2741	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:02:00.104212
2742	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:02:00.104212
2743	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:02:00.104212
2744	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:02:00.104212
2745	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:02:00.104212
2746	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:03:00.006316
2747	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:03:00.006316
2748	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:03:00.006316
2749	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:03:00.006316
2750	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:03:00.006316
2751	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:04:00.056672
2752	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:04:00.056672
2753	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:04:00.056672
2754	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:04:00.056672
2755	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:04:00.056672
2756	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:05:00.020851
2757	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:05:00.020851
2758	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:05:00.020851
2759	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:05:00.020851
2760	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:05:00.020851
2761	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:06:00.00734
2762	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:06:00.00734
2763	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:06:00.00734
2764	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:06:00.00734
2765	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:06:00.00734
2766	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:07:00.113978
2767	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:07:00.113978
2768	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:07:00.113978
2769	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:07:00.113978
2770	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:07:00.113978
2771	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:08:00.043184
2772	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:08:00.043184
2773	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:08:00.043184
2774	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:08:00.043184
2775	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:08:00.043184
2776	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:09:00.02998
2777	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:09:00.02998
2778	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:09:00.02998
2779	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:09:00.02998
2780	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:09:00.02998
2781	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:10:00.002036
2782	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:10:00.002036
2783	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:10:00.002036
2784	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:10:00.002036
2785	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:10:00.002036
2786	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:11:00.010046
2787	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:11:00.010046
2788	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:11:00.010046
2789	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:11:00.010046
2790	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:11:00.010046
2791	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:12:00.124484
2792	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:12:00.124484
2793	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:12:00.124484
2794	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:12:00.124484
2795	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:12:00.124484
2796	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:13:00.024652
2797	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:13:00.024652
2798	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:13:00.024652
2799	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:13:00.024652
2800	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:13:00.024652
2801	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:14:00.03961
2802	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:14:00.03961
2803	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:14:00.03961
2804	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:14:00.03961
2805	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:14:00.03961
2806	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:15:00.112674
2807	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:15:00.112674
2808	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:15:00.112674
2809	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:15:00.112674
2810	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:15:00.112674
2811	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:16:00.109715
2812	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:16:00.109715
2813	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:16:00.109715
2814	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:16:00.109715
2815	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:16:00.109715
2816	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:17:00.003299
2817	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:17:00.003299
2818	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:17:00.003299
2819	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:17:00.003299
2820	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:17:00.003299
2821	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:18:00.01843
2822	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:18:00.01843
2823	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:18:00.01843
2824	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:18:00.01843
2825	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:18:00.01843
2826	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:19:00.013931
2827	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:19:00.013931
2828	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:19:00.013931
2829	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:19:00.013931
2830	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:19:00.013931
2831	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:20:00.020307
2832	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:20:00.020307
2833	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:20:00.020307
2834	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:20:00.020307
2835	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:20:00.020307
2836	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:21:00.027737
2837	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:21:00.027737
2838	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:21:00.027737
2839	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:21:00.027737
2840	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:21:00.027737
2841	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:22:00.026144
2842	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:22:00.026144
2843	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:22:00.026144
2844	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:22:00.026144
2845	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:22:00.026144
2846	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:23:00.006468
2847	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:23:00.006468
2848	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:23:00.006468
2849	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:23:00.006468
2850	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:23:00.006468
2851	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:24:00.083861
2852	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:24:00.083861
2853	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:24:00.083861
2854	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:24:00.083861
2855	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:24:00.083861
2856	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:25:00.071561
2857	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:25:00.071561
2858	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:25:00.071561
2859	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:25:00.071561
2860	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:25:00.071561
2861	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:26:00.005817
2862	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:26:00.005817
2863	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:26:00.005817
2864	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:26:00.005817
2865	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:26:00.005817
2866	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:27:00.009002
2867	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:27:00.009002
2868	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:27:00.009002
2869	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:27:00.009002
2870	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:27:00.009002
2871	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:28:00.007006
2872	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:28:00.007006
2873	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:28:00.007006
2874	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:28:00.007006
2875	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:28:00.007006
2876	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:29:00.014035
2877	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:29:00.014035
2878	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:29:00.014035
2879	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:29:00.014035
2880	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:29:00.014035
2881	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:30:00.081602
2882	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:30:00.081602
2883	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:30:00.081602
2884	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:30:00.081602
2885	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:30:00.081602
2886	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:31:00.081347
2887	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:31:00.081347
2888	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:31:00.081347
2889	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:31:00.081347
2890	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:31:00.081347
2891	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:32:00.001232
2892	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:32:00.001232
2893	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:32:00.001232
2894	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:32:00.001232
2895	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:32:00.001232
2896	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:33:00.103144
2897	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:33:00.103144
2898	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:33:00.103144
2899	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:33:00.103144
2900	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:33:00.103144
2901	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:34:00.017443
2902	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:34:00.017443
2903	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:34:00.017443
2904	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:34:00.017443
2905	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:34:00.017443
2906	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:35:00.061947
2907	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:35:00.061947
2908	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:35:00.061947
2909	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:35:00.061947
2910	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:35:00.061947
2911	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:36:00.00667
2912	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:36:00.00667
2913	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:36:00.00667
2914	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:36:00.00667
2915	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:36:00.00667
2916	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:37:00.021938
2917	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:37:00.021938
2918	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:37:00.021938
2919	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:37:00.021938
2920	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:37:00.021938
2921	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:38:00.071872
2922	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:38:00.071872
2923	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:38:00.071872
2924	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:38:00.071872
2925	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:38:00.071872
2926	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:39:00.009321
2927	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:39:00.009321
2928	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:39:00.009321
2929	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:39:00.009321
2930	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:39:00.009321
2931	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:40:00.004013
2932	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:40:00.004013
2933	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:40:00.004013
2934	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:40:00.004013
2935	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:40:00.004013
2936	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:41:00.010583
2937	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:41:00.010583
2938	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:41:00.010583
2939	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:41:00.010583
2940	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:41:00.010583
2941	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:42:00.092954
2942	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:42:00.092954
2943	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:42:00.092954
2944	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:42:00.092954
2945	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:42:00.092954
2946	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:43:00.041589
2947	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:43:00.041589
2948	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:43:00.041589
2949	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:43:00.041589
2950	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:43:00.041589
2951	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:44:00.009167
2952	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:44:00.009167
2953	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:44:00.009167
2954	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:44:00.009167
2955	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:44:00.009167
2956	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:45:00.065642
2957	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:45:00.065642
2958	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:45:00.065642
2959	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:45:00.065642
2960	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:45:00.065642
2961	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:46:00.052573
2962	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:46:00.052573
2963	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:46:00.052573
2964	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:46:00.052573
2965	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:46:00.052573
2966	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:47:00.007315
2967	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:47:00.007315
2968	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:47:00.007315
2969	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:47:00.007315
2970	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:47:00.007315
2971	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:48:00.103646
2972	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:48:00.103646
2973	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:48:00.103646
2974	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:48:00.103646
2975	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:48:00.103646
2976	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:49:00.009488
2977	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:49:00.009488
2978	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:49:00.009488
2979	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:49:00.009488
2980	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:49:00.009488
2981	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:50:00.043966
2982	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:50:00.043966
2983	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:50:00.043966
2984	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:50:00.043966
2985	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:50:00.043966
2986	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:51:00.069481
2987	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:51:00.069481
2988	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:51:00.069481
2989	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:51:00.069481
2990	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:51:00.069481
2991	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:52:00.016172
2992	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:52:00.016172
2993	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:52:00.016172
2994	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:52:00.016172
2995	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:52:00.016172
2996	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:53:00.119163
2997	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:53:00.119163
2998	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:53:00.119163
2999	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:53:00.119163
3000	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:53:00.119163
3001	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:54:00.009914
3002	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:54:00.009914
3003	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:54:00.009914
3004	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:54:00.009914
3005	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:54:00.009914
3006	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:55:00.036511
3007	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:55:00.036511
3008	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:55:00.036511
3009	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:55:00.036511
3010	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:55:00.036511
3011	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:56:00.003285
3012	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:56:00.003285
3013	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:56:00.003285
3014	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:56:00.003285
3015	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:56:00.003285
3016	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:57:00.00669
3017	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:57:00.00669
3018	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:57:00.00669
3019	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:57:00.00669
3020	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:57:00.00669
3021	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:58:00.081917
3022	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:58:00.081917
3023	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:58:00.081917
3024	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:58:00.081917
3025	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:58:00.081917
3026	4	showroom	main_area	10	0	Low	0.00	2026-02-03 22:59:00.043541
3027	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 22:59:00.043541
3028	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 22:59:00.043541
3029	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 22:59:00.043541
3030	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 22:59:00.043541
3031	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:00:00.027995
3032	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:00:00.027995
3033	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:00:00.027995
3034	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:00:00.027995
3035	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:00:00.027995
3036	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:01:00.036999
3037	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:01:00.036999
3038	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:01:00.036999
3039	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:01:00.036999
3040	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:01:00.036999
3041	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:02:00.040457
3042	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:02:00.040457
3043	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:02:00.040457
3044	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:02:00.040457
3045	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:02:00.040457
3046	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:03:00.11923
3047	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:03:00.11923
3048	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:03:00.11923
3049	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:03:00.11923
3050	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:03:00.11923
3051	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:04:00.114952
3052	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:04:00.114952
3053	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:04:00.114952
3054	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:04:00.114952
3055	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:04:00.114952
3056	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:05:00.014885
3057	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:05:00.014885
3058	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:05:00.014885
3059	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:05:00.014885
3060	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:05:00.014885
3061	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:06:00.075842
3062	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:06:00.075842
3063	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:06:00.075842
3064	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:06:00.075842
3065	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:06:00.075842
3066	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:07:00.022897
3067	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:07:00.022897
3068	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:07:00.022897
3069	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:07:00.022897
3070	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:07:00.022897
3071	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:08:00.038249
3072	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:08:00.038249
3073	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:08:00.038249
3074	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:08:00.038249
3075	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:08:00.038249
3076	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:09:00.069965
3077	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:09:00.069965
3078	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:09:00.069965
3079	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:09:00.069965
3080	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:09:00.069965
3081	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:10:00.001431
3082	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:10:00.001431
3083	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:10:00.001431
3084	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:10:00.001431
3085	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:10:00.001431
3086	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:11:00.063779
3087	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:11:00.063779
3088	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:11:00.063779
3089	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:11:00.063779
3090	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:11:00.063779
3091	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:12:00.004185
3092	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:12:00.004185
3093	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:12:00.004185
3094	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:12:00.004185
3095	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:12:00.004185
3096	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:13:00.045885
3097	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:13:00.045885
3098	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:13:00.045885
3099	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:13:00.045885
3100	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:13:00.045885
3101	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:14:00.011383
3102	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:14:00.011383
3103	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:14:00.011383
3104	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:14:00.011383
3105	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:14:00.011383
3106	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:15:00.046313
3107	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:15:00.046313
3108	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:15:00.046313
3109	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:15:00.046313
3110	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:15:00.046313
3111	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:16:00.023278
3112	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:16:00.023278
3113	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:16:00.023278
3114	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:16:00.023278
3115	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:16:00.023278
3116	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:17:00.014349
3117	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:17:00.014349
3118	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:17:00.014349
3119	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:17:00.014349
3120	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:17:00.014349
3121	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:18:00.090947
3122	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:18:00.090947
3123	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:18:00.090947
3124	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:18:00.090947
3125	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:18:00.090947
3126	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:19:00.072012
3127	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:19:00.072012
3128	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:19:00.072012
3129	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:19:00.072012
3130	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:19:00.072012
3131	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:20:00.017484
3132	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:20:00.017484
3133	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:20:00.017484
3134	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:20:00.017484
3135	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:20:00.017484
3136	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:21:00.015407
3137	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:21:00.015407
3138	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:21:00.015407
3139	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:21:00.015407
3140	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:21:00.015407
3141	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:22:00.035139
3142	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:22:00.035139
3143	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:22:00.035139
3144	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:22:00.035139
3145	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:22:00.035139
3146	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:23:00.00951
3147	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:23:00.00951
3148	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:23:00.00951
3149	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:23:00.00951
3150	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:23:00.00951
3151	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:24:00.09639
3152	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:24:00.09639
3153	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:24:00.09639
3154	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:24:00.09639
3155	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:24:00.09639
3156	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:25:00.005819
3157	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:25:00.005819
3158	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:25:00.005819
3159	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:25:00.005819
3160	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:25:00.005819
3161	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:26:00.050291
3162	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:26:00.050291
3163	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:26:00.050291
3164	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:26:00.050291
3165	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:26:00.050291
3166	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:27:00.01228
3167	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:27:00.01228
3168	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:27:00.01228
3169	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:27:00.01228
3170	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:27:00.01228
3171	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:28:00.005364
3172	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:28:00.005364
3173	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:28:00.005364
3174	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:28:00.005364
3175	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:28:00.005364
3176	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:29:00.028726
3177	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:29:00.028726
3178	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:29:00.028726
3179	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:29:00.028726
3180	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:29:00.028726
3181	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:30:00.081862
3182	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:30:00.081862
3183	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:30:00.081862
3184	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:30:00.081862
3185	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:30:00.081862
3186	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:31:00.007676
3187	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:31:00.007676
3188	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:31:00.007676
3189	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:31:00.007676
3190	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:31:00.007676
3191	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:32:00.107271
3192	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:32:00.107271
3193	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:32:00.107271
3194	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:32:00.107271
3195	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:32:00.107271
3196	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:33:00.003619
3197	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:33:00.003619
3198	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:33:00.003619
3199	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:33:00.003619
3200	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:33:00.003619
3201	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:34:00.00418
3202	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:34:00.00418
3203	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:34:00.00418
3204	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:34:00.00418
3205	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:34:00.00418
3206	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:35:00.085688
3207	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:35:00.085688
3208	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:35:00.085688
3209	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:35:00.085688
3210	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:35:00.085688
3211	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:36:00.065784
3212	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:36:00.065784
3213	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:36:00.065784
3214	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:36:00.065784
3215	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:36:00.065784
3216	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:37:00.037714
3217	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:37:00.037714
3218	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:37:00.037714
3219	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:37:00.037714
3220	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:37:00.037714
3221	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:38:00.03281
3222	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:38:00.03281
3223	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:38:00.03281
3224	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:38:00.03281
3225	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:38:00.03281
3226	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:39:00.002025
3227	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:39:00.002025
3228	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:39:00.002025
3229	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:39:00.002025
3230	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:39:00.002025
3231	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:40:00.013111
3232	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:40:00.013111
3233	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:40:00.013111
3234	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:40:00.013111
3235	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:40:00.013111
3236	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:41:00.086824
3237	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:41:00.086824
3238	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:41:00.086824
3239	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:41:00.086824
3240	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:41:00.086824
3241	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:42:00.054465
3242	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:42:00.054465
3243	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:42:00.054465
3244	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:42:00.054465
3245	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:42:00.054465
3246	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:43:00.001038
3247	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:43:00.001038
3248	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:43:00.001038
3249	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:43:00.001038
3250	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:43:00.001038
3251	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:44:00.016359
3252	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:44:00.016359
3253	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:44:00.016359
3254	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:44:00.016359
3255	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:44:00.016359
3256	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:45:00.03915
3257	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:45:00.03915
3258	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:45:00.03915
3259	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:45:00.03915
3260	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:45:00.03915
3261	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:46:00.003527
3262	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:46:00.003527
3263	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:46:00.003527
3264	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:46:00.003527
3265	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:46:00.003527
3266	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:47:00.10415
3267	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:47:00.10415
3268	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:47:00.10415
3269	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:47:00.10415
3270	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:47:00.10415
3271	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:48:00.051351
3272	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:48:00.051351
3273	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:48:00.051351
3274	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:48:00.051351
3275	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:48:00.051351
3276	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:49:00.010019
3277	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:49:00.010019
3278	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:49:00.010019
3279	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:49:00.010019
3280	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:49:00.010019
3281	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:50:00.039733
3282	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:50:00.039733
3283	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:50:00.039733
3284	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:50:00.039733
3285	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:50:00.039733
3286	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:51:00.114149
3287	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:51:00.114149
3288	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:51:00.114149
3289	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:51:00.114149
3290	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:51:00.114149
3291	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:52:00.004996
3292	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:52:00.004996
3293	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:52:00.004996
3294	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:52:00.004996
3295	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:52:00.004996
3296	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:53:00.009086
3297	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:53:00.009086
3298	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:53:00.009086
3299	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:53:00.009086
3300	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:53:00.009086
3301	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:54:00.006298
3302	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:54:00.006298
3303	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:54:00.006298
3304	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:54:00.006298
3305	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:54:00.006298
3306	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:55:00.068761
3307	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:55:00.068761
3308	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:55:00.068761
3309	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:55:00.068761
3310	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:55:00.068761
3311	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:56:00.008607
3312	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:56:00.008607
3313	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:56:00.008607
3314	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:56:00.008607
3315	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:56:00.008607
3316	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:57:00.048254
3317	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:57:00.048254
3318	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:57:00.048254
3319	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:57:00.048254
3320	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:57:00.048254
3321	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:58:00.011254
3322	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:58:00.011254
3323	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:58:00.011254
3324	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:58:00.011254
3325	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:58:00.011254
3326	4	showroom	main_area	10	0	Low	0.00	2026-02-03 23:59:00.041162
3327	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-03 23:59:00.041162
3328	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-03 23:59:00.041162
3329	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-03 23:59:00.041162
3330	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-03 23:59:00.041162
3331	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:00:00.014879
3332	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:00:00.014879
3333	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:00:00.014879
3334	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:00:00.014879
3335	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:00:00.014879
3336	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:01:00.005727
3337	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:01:00.005727
3338	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:01:00.005727
3339	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:01:00.005727
3340	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:01:00.005727
3341	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:02:00.079133
3342	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:02:00.079133
3343	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:02:00.079133
3344	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:02:00.079133
3345	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:02:00.079133
3346	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:03:00.018112
3347	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:03:00.018112
3348	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:03:00.018112
3349	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:03:00.018112
3350	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:03:00.018112
3351	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:04:00.054507
3352	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:04:00.054507
3353	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:04:00.054507
3354	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:04:00.054507
3355	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:04:00.054507
3356	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:05:00.107903
3357	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:05:00.107903
3358	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:05:00.107903
3359	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:05:00.107903
3360	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:05:00.107903
3361	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:06:00.025539
3362	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:06:00.025539
3363	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:06:00.025539
3364	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:06:00.025539
3365	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:06:00.025539
3366	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:07:00.005737
3367	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:07:00.005737
3368	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:07:00.005737
3369	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:07:00.005737
3370	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:07:00.005737
3371	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:08:00.105507
3372	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:08:00.105507
3373	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:08:00.105507
3374	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:08:00.105507
3375	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:08:00.105507
3376	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:09:00.028837
3377	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:09:00.028837
3378	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:09:00.028837
3379	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:09:00.028837
3380	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:09:00.028837
3381	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:10:00.114619
3382	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:10:00.114619
3383	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:10:00.114619
3384	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:10:00.114619
3385	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:10:00.114619
3386	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:11:00.083191
3387	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:11:00.083191
3388	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:11:00.083191
3389	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:11:00.083191
3390	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:11:00.083191
3391	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:12:00.094704
3392	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:12:00.094704
3393	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:12:00.094704
3394	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:12:00.094704
3395	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:12:00.094704
3396	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:13:00.102968
3397	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:13:00.102968
3398	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:13:00.102968
3399	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:13:00.102968
3400	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:13:00.102968
3401	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:14:00.051778
3402	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:14:00.051778
3403	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:14:00.051778
3404	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:14:00.051778
3405	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:14:00.051778
3406	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:15:00.022378
3407	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:15:00.022378
3408	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:15:00.022378
3409	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:15:00.022378
3410	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:15:00.022378
3411	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:16:00.084101
3412	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:16:00.084101
3413	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:16:00.084101
3414	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:16:00.084101
3415	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:16:00.084101
3416	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:17:00.065296
3417	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:17:00.065296
3418	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:17:00.065296
3419	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:17:00.065296
3420	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:17:00.065296
3421	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:18:00.072592
3422	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:18:00.072592
3423	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:18:00.072592
3424	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:18:00.072592
3425	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:18:00.072592
3426	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:19:00.004477
3427	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:19:00.004477
3428	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:19:00.004477
3429	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:19:00.004477
3430	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:19:00.004477
3431	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:20:00.010961
3432	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:20:00.010961
3433	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:20:00.010961
3434	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:20:00.010961
3435	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:20:00.010961
3436	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:21:00.008373
3437	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:21:00.008373
3438	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:21:00.008373
3439	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:21:00.008373
3440	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:21:00.008373
3441	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:22:00.068974
3442	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:22:00.068974
3443	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:22:00.068974
3444	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:22:00.068974
3445	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:22:00.068974
3446	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:23:00.044224
3447	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:23:00.044224
3448	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:23:00.044224
3449	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:23:00.044224
3450	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:23:00.044224
3451	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:24:00.005513
3452	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:24:00.005513
3453	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:24:00.005513
3454	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:24:00.005513
3455	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:24:00.005513
3456	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:25:00.004066
3457	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:25:00.004066
3458	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:25:00.004066
3459	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:25:00.004066
3460	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:25:00.004066
3461	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:26:00.018694
3462	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:26:00.018694
3463	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:26:00.018694
3464	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:26:00.018694
3465	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:26:00.018694
3466	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:27:00.074896
3467	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:27:00.074896
3468	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:27:00.074896
3469	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:27:00.074896
3470	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:27:00.074896
3471	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:28:00.051071
3472	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:28:00.051071
3473	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:28:00.051071
3474	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:28:00.051071
3475	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:28:00.051071
3476	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:29:00.006076
3477	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:29:00.006076
3478	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:29:00.006076
3479	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:29:00.006076
3480	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:29:00.006076
3481	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:30:00.038105
3482	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:30:00.038105
3483	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:30:00.038105
3484	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:30:00.038105
3485	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:30:00.038105
3486	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:31:00.029789
3487	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:31:00.029789
3488	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:31:00.029789
3489	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:31:00.029789
3490	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:31:00.029789
3491	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:32:00.000877
3492	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:32:00.000877
3493	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:32:00.000877
3494	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:32:00.000877
3495	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:32:00.000877
3496	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:33:00.076542
3497	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:33:00.076542
3498	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:33:00.076542
3499	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:33:00.076542
3500	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:33:00.076542
3501	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:34:00.041925
3502	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:34:00.041925
3503	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:34:00.041925
3504	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:34:00.041925
3505	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:34:00.041925
3506	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:35:00.067404
3507	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:35:00.067404
3508	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:35:00.067404
3509	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:35:00.067404
3510	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:35:00.067404
3511	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:36:00.064819
3512	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:36:00.064819
3513	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:36:00.064819
3514	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:36:00.064819
3515	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:36:00.064819
3516	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:37:00.088235
3517	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:37:00.088235
3518	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:37:00.088235
3519	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:37:00.088235
3520	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:37:00.088235
3521	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:38:00.007999
3522	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:38:00.007999
3523	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:38:00.007999
3524	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:38:00.007999
3525	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:38:00.007999
3526	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:39:00.084574
3527	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:39:00.084574
3528	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:39:00.084574
3529	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:39:00.084574
3530	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:39:00.084574
3531	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:40:00.003502
3532	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:40:00.003502
3533	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:40:00.003502
3534	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:40:00.003502
3535	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:40:00.003502
3536	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:41:00.07981
3537	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:41:00.07981
3538	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:41:00.07981
3539	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:41:00.07981
3540	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:41:00.07981
3541	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:42:00.057016
3542	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:42:00.057016
3543	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:42:00.057016
3544	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:42:00.057016
3545	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:42:00.057016
3546	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:43:00.011287
3547	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:43:00.011287
3548	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:43:00.011287
3549	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:43:00.011287
3550	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:43:00.011287
3551	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:44:00.061069
3552	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:44:00.061069
3553	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:44:00.061069
3554	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:44:00.061069
3555	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:44:00.061069
3556	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:45:00.03699
3557	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:45:00.03699
3558	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:45:00.03699
3559	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:45:00.03699
3560	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:45:00.03699
3561	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:46:00.079432
3562	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:46:00.079432
3563	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:46:00.079432
3564	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:46:00.079432
3565	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:46:00.079432
3566	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:47:00.025805
3567	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:47:00.025805
3568	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:47:00.025805
3569	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:47:00.025805
3570	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:47:00.025805
3571	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:48:00.008003
3572	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:48:00.008003
3573	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:48:00.008003
3574	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:48:00.008003
3575	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:48:00.008003
3576	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:49:00.098104
3577	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:49:00.098104
3578	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:49:00.098104
3579	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:49:00.098104
3580	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:49:00.098104
3581	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:50:00.028657
3582	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:50:00.028657
3583	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:50:00.028657
3584	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:50:00.028657
3585	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:50:00.028657
3586	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:51:00.107232
3587	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:51:00.107232
3588	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:51:00.107232
3589	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:51:00.107232
3590	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:51:00.107232
3591	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:52:00.014136
3592	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:52:00.014136
3593	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:52:00.014136
3594	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:52:00.014136
3595	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:52:00.014136
3596	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:53:00.013619
3597	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:53:00.013619
3598	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:53:00.013619
3599	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:53:00.013619
3600	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:53:00.013619
3601	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:54:00.00511
3602	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:54:00.00511
3603	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:54:00.00511
3604	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:54:00.00511
3605	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:54:00.00511
3606	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:55:00.037376
3607	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:55:00.037376
3608	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:55:00.037376
3609	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:55:00.037376
3610	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:55:00.037376
3611	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:56:00.025688
3612	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:56:00.025688
3613	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:56:00.025688
3614	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:56:00.025688
3615	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:56:00.025688
3616	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:57:00.108972
3617	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:57:00.108972
3618	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:57:00.108972
3619	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:57:00.108972
3620	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:57:00.108972
3621	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:58:00.113953
3622	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:58:00.113953
3623	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:58:00.113953
3624	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:58:00.113953
3625	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:58:00.113953
3626	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 00:59:00.055336
3627	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 00:59:00.055336
3628	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 00:59:00.055336
3629	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 00:59:00.055336
3630	4	showroom	main_area	10	0	Low	0.00	2026-02-04 00:59:00.055336
3631	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:00:00.018869
3632	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:00:00.018869
3633	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:00:00.018869
3634	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:00:00.018869
3635	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:00:00.018869
3636	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:01:00.080883
3637	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:01:00.080883
3638	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:01:00.080883
3639	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:01:00.080883
3640	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:01:00.080883
3641	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:02:00.04613
3642	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:02:00.04613
3643	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:02:00.04613
3644	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:02:00.04613
3645	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:02:00.04613
3646	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:03:00.044307
3647	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:03:00.044307
3648	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:03:00.044307
3649	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:03:00.044307
3650	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:03:00.044307
3651	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:04:00.070138
3652	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:04:00.070138
3653	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:04:00.070138
3654	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:04:00.070138
3655	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:04:00.070138
3656	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:05:00.109383
3657	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:05:00.109383
3658	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:05:00.109383
3659	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:05:00.109383
3660	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:05:00.109383
3661	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:06:00.066736
3662	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:06:00.066736
3663	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:06:00.066736
3664	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:06:00.066736
3665	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:06:00.066736
3666	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:07:00.111141
3667	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:07:00.111141
3668	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:07:00.111141
3669	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:07:00.111141
3670	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:07:00.111141
3671	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:08:00.006989
3672	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:08:00.006989
3673	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:08:00.006989
3674	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:08:00.006989
3675	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:08:00.006989
3676	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:09:00.030791
3677	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:09:00.030791
3678	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:09:00.030791
3679	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:09:00.030791
3680	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:09:00.030791
3681	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:10:00.008886
3682	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:10:00.008886
3683	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:10:00.008886
3684	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:10:00.008886
3685	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:10:00.008886
3686	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:11:00.0024
3687	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:11:00.0024
3688	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:11:00.0024
3689	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:11:00.0024
3690	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:11:00.0024
3691	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:12:00.014149
3692	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:12:00.014149
3693	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:12:00.014149
3694	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:12:00.014149
3695	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:12:00.014149
3696	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:13:00.056742
3697	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:13:00.056742
3698	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:13:00.056742
3699	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:13:00.056742
3700	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:13:00.056742
3701	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:14:00.053346
3702	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:14:00.053346
3703	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:14:00.053346
3704	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:14:00.053346
3705	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:14:00.053346
3706	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:15:00.035626
3707	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:15:00.035626
3708	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:15:00.035626
3709	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:15:00.035626
3710	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:15:00.035626
3711	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:16:00.007312
3712	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:16:00.007312
3713	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:16:00.007312
3714	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:16:00.007312
3715	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:16:00.007312
3716	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:17:00.010896
3717	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:17:00.010896
3718	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:17:00.010896
3719	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:17:00.010896
3720	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:17:00.010896
3721	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:18:00.000592
3722	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:18:00.000592
3723	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:18:00.000592
3724	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:18:00.000592
3725	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:18:00.000592
3726	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:19:00.018517
3727	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:19:00.018517
3728	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:19:00.018517
3729	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:19:00.018517
3730	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:19:00.018517
3731	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:20:00.03204
3732	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:20:00.03204
3733	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:20:00.03204
3734	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:20:00.03204
3735	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:20:00.03204
3736	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:21:00.064538
3737	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:21:00.064538
3738	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:21:00.064538
3739	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:21:00.064538
3740	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:21:00.064538
3741	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:22:00.046031
3742	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:22:00.046031
3743	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:22:00.046031
3744	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:22:00.046031
3745	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:22:00.046031
3746	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:23:00.004158
3747	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:23:00.004158
3748	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:23:00.004158
3749	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:23:00.004158
3750	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:23:00.004158
3751	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:24:00.111435
3752	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:24:00.111435
3753	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:24:00.111435
3754	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:24:00.111435
3755	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:24:00.111435
3756	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:25:00.00322
3757	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:25:00.00322
3758	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:25:00.00322
3759	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:25:00.00322
3760	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:25:00.00322
3761	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:26:00.094648
3762	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:26:00.094648
3763	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:26:00.094648
3764	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:26:00.094648
3765	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:26:00.094648
3766	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:27:00.102138
3767	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:27:00.102138
3768	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:27:00.102138
3769	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:27:00.102138
3770	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:27:00.102138
3771	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:28:00.006168
3772	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:28:00.006168
3773	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:28:00.006168
3774	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:28:00.006168
3775	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:28:00.006168
3776	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:29:00.038979
3777	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:29:00.038979
3778	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:29:00.038979
3779	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:29:00.038979
3780	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:29:00.038979
3781	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:30:00.037082
3782	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:30:00.037082
3783	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:30:00.037082
3784	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:30:00.037082
3785	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:30:00.037082
3786	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:31:00.079694
3787	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:31:00.079694
3788	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:31:00.079694
3789	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:31:00.079694
3790	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:31:00.079694
3791	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:32:00.012738
3792	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:32:00.012738
3793	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:32:00.012738
3794	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:32:00.012738
3795	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:32:00.012738
3796	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:33:00.0928
3797	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:33:00.0928
3798	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:33:00.0928
3799	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:33:00.0928
3800	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:33:00.0928
3801	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:34:00.040996
3802	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:34:00.040996
3803	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:34:00.040996
3804	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:34:00.040996
3805	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:34:00.040996
3806	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:35:00.067477
3807	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:35:00.067477
3808	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:35:00.067477
3809	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:35:00.067477
3810	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:35:00.067477
3811	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:36:00.030269
3812	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:36:00.030269
3813	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:36:00.030269
3814	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:36:00.030269
3815	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:36:00.030269
3816	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:37:00.016758
3817	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:37:00.016758
3818	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:37:00.016758
3819	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:37:00.016758
3820	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:37:00.016758
3821	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:38:00.081694
3822	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:38:00.081694
3823	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:38:00.081694
3824	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:38:00.081694
3825	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:38:00.081694
3826	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:39:00.063881
3827	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:39:00.063881
3828	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:39:00.063881
3829	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:39:00.063881
3830	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:39:00.063881
3831	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:40:00.043011
3832	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:40:00.043011
3833	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:40:00.043011
3834	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:40:00.043011
3835	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:40:00.043011
3836	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:41:00.006326
3837	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:41:00.006326
3838	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:41:00.006326
3839	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:41:00.006326
3840	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:41:00.006326
3841	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:42:00.056005
3842	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:42:00.056005
3843	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:42:00.056005
3844	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:42:00.056005
3845	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:42:00.056005
3846	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:43:00.022934
3847	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:43:00.022934
3848	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:43:00.022934
3849	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:43:00.022934
3850	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:43:00.022934
3851	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:44:00.010737
3852	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:44:00.010737
3853	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:44:00.010737
3854	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:44:00.010737
3855	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:44:00.010737
3856	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:45:00.038918
3857	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:45:00.038918
3858	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:45:00.038918
3859	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:45:00.038918
3860	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:45:00.038918
3861	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:46:00.098182
3862	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:46:00.098182
3863	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:46:00.098182
3864	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:46:00.098182
3865	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:46:00.098182
3866	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:47:00.007082
3867	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:47:00.007082
3868	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:47:00.007082
3869	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:47:00.007082
3870	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:47:00.007082
3871	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:48:00.071509
3872	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:48:00.071509
3873	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:48:00.071509
3874	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:48:00.071509
3875	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:48:00.071509
3876	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:49:00.006902
3877	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:49:00.006902
3878	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:49:00.006902
3879	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:49:00.006902
3880	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:49:00.006902
3881	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:50:00.023342
3882	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:50:00.023342
3883	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:50:00.023342
3884	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:50:00.023342
3885	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:50:00.023342
3886	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:51:00.049271
3887	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:51:00.049271
3888	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:51:00.049271
3889	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:51:00.049271
3890	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:51:00.049271
3891	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:52:00.115992
3892	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:52:00.115992
3893	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:52:00.115992
3894	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:52:00.115992
3895	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:52:00.115992
3896	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:53:00.079949
3897	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:53:00.079949
3898	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:53:00.079949
3899	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:53:00.079949
3900	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:53:00.079949
3901	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:54:00.109914
3902	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:54:00.109914
3903	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:54:00.109914
3904	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:54:00.109914
3905	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:54:00.109914
3906	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:55:00.007199
3907	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:55:00.007199
3908	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:55:00.007199
3909	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:55:00.007199
3910	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:55:00.007199
3911	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:56:00.03956
3912	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:56:00.03956
3913	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:56:00.03956
3914	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:56:00.03956
3915	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:56:00.03956
3916	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:57:00.046767
3917	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:57:00.046767
3918	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:57:00.046767
3919	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:57:00.046767
3920	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:57:00.046767
3921	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:58:00.087951
3922	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:58:00.087951
3923	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:58:00.087951
3924	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:58:00.087951
3925	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:58:00.087951
3926	4	showroom	main_area	10	0	Low	0.00	2026-02-04 01:59:00.074081
3927	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 01:59:00.074081
3928	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 01:59:00.074081
3929	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 01:59:00.074081
3930	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 01:59:00.074081
3931	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:00:00.032965
3932	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:00:00.032965
3933	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:00:00.032965
3934	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:00:00.032965
3935	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:00:00.032965
3936	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:01:00.019231
3937	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:01:00.019231
3938	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:01:00.019231
3939	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:01:00.019231
3940	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:01:00.019231
3941	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:02:00.003767
3942	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:02:00.003767
3943	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:02:00.003767
3944	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:02:00.003767
3945	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:02:00.003767
3946	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:03:00.005536
3947	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:03:00.005536
3948	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:03:00.005536
3949	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:03:00.005536
3950	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:03:00.005536
3951	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:04:00.005165
3952	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:04:00.005165
3953	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:04:00.005165
3954	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:04:00.005165
3955	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:04:00.005165
3956	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:05:00.040977
3957	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:05:00.040977
3958	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:05:00.040977
3959	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:05:00.040977
3960	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:05:00.040977
3961	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:06:00.024824
3962	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:06:00.024824
3963	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:06:00.024824
3964	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:06:00.024824
3965	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:06:00.024824
3966	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:07:00.005288
3967	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:07:00.005288
3968	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:07:00.005288
3969	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:07:00.005288
3970	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:07:00.005288
3971	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:08:00.109838
3972	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:08:00.109838
3973	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:08:00.109838
3974	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:08:00.109838
3975	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:08:00.109838
3976	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:09:00.008234
3977	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:09:00.008234
3978	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:09:00.008234
3979	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:09:00.008234
3980	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:09:00.008234
3981	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:10:00.025254
3982	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:10:00.025254
3983	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:10:00.025254
3984	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:10:00.025254
3985	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:10:00.025254
3986	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:11:00.106945
3987	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:11:00.106945
3988	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:11:00.106945
3989	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:11:00.106945
3990	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:11:00.106945
3991	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:12:00.104266
3992	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:12:00.104266
3993	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:12:00.104266
3994	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:12:00.104266
3995	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:12:00.104266
3996	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:13:00.063084
3997	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:13:00.063084
3998	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:13:00.063084
3999	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:13:00.063084
4000	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:13:00.063084
4001	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:14:00.088155
4002	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:14:00.088155
4003	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:14:00.088155
4004	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:14:00.088155
4005	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:14:00.088155
4006	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:15:00.056801
4007	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:15:00.056801
4008	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:15:00.056801
4009	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:15:00.056801
4010	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:15:00.056801
4011	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:16:00.024498
4012	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:16:00.024498
4013	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:16:00.024498
4014	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:16:00.024498
4015	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:16:00.024498
4016	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:17:00.045032
4017	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:17:00.045032
4018	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:17:00.045032
4019	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:17:00.045032
4020	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:17:00.045032
4021	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:18:00.042024
4022	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:18:00.042024
4023	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:18:00.042024
4024	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:18:00.042024
4025	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:18:00.042024
4026	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:19:00.120902
4027	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:19:00.120902
4028	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:19:00.120902
4029	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:19:00.120902
4030	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:19:00.120902
4031	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:20:00.115998
4032	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:20:00.115998
4033	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:20:00.115998
4034	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:20:00.115998
4035	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:20:00.115998
4036	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:21:00.12288
4037	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:21:00.12288
4038	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:21:00.12288
4039	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:21:00.12288
4040	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:21:00.12288
4041	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:22:00.044432
4042	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:22:00.044432
4043	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:22:00.044432
4044	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:22:00.044432
4045	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:22:00.044432
4046	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:23:00.072375
4047	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:23:00.072375
4048	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:23:00.072375
4049	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:23:00.072375
4050	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:23:00.072375
4051	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:24:00.035001
4052	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:24:00.035001
4053	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:24:00.035001
4054	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:24:00.035001
4055	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:24:00.035001
4056	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:25:00.016816
4057	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:25:00.016816
4058	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:25:00.016816
4059	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:25:00.016816
4060	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:25:00.016816
4061	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:26:00.021612
4062	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:26:00.021612
4063	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:26:00.021612
4064	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:26:00.021612
4065	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:26:00.021612
4066	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:27:00.006538
4067	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:27:00.006538
4068	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:27:00.006538
4069	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:27:00.006538
4070	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:27:00.006538
4071	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:28:00.095059
4072	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:28:00.095059
4073	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:28:00.095059
4074	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:28:00.095059
4075	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:28:00.095059
4076	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:29:00.043366
4077	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:29:00.043366
4078	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:29:00.043366
4079	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:29:00.043366
4080	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:29:00.043366
4081	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:30:00.015319
4082	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:30:00.015319
4083	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:30:00.015319
4084	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:30:00.015319
4085	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:30:00.015319
4086	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:31:00.108376
4087	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:31:00.108376
4088	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:31:00.108376
4089	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:31:00.108376
4090	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:31:00.108376
4091	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:32:00.031858
4092	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:32:00.031858
4093	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:32:00.031858
4094	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:32:00.031858
4095	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:32:00.031858
4096	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:33:00.001599
4097	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:33:00.001599
4098	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:33:00.001599
4099	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:33:00.001599
4100	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:33:00.001599
4101	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:34:00.058487
4102	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:34:00.058487
4103	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:34:00.058487
4104	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:34:00.058487
4105	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:34:00.058487
4106	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:35:00.066301
4107	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:35:00.066301
4108	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:35:00.066301
4109	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:35:00.066301
4110	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:35:00.066301
4111	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:36:00.110295
4112	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:36:00.110295
4113	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:36:00.110295
4114	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:36:00.110295
4115	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:36:00.110295
4116	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:37:00.021339
4117	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:37:00.021339
4118	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:37:00.021339
4119	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:37:00.021339
4120	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:37:00.021339
4121	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:38:00.015965
4122	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:38:00.015965
4123	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:38:00.015965
4124	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:38:00.015965
4125	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:38:00.015965
4126	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:39:00.037485
4127	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:39:00.037485
4128	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:39:00.037485
4129	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:39:00.037485
4130	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:39:00.037485
4131	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:40:00.038638
4132	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:40:00.038638
4133	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:40:00.038638
4134	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:40:00.038638
4135	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:40:00.038638
4136	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:41:00.092559
4137	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:41:00.092559
4138	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:41:00.092559
4139	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:41:00.092559
4140	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:41:00.092559
4141	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:42:00.017244
4142	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:42:00.017244
4143	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:42:00.017244
4144	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:42:00.017244
4145	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:42:00.017244
4146	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:43:00.049057
4147	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:43:00.049057
4148	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:43:00.049057
4149	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:43:00.049057
4150	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:43:00.049057
4151	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:44:00.087034
4152	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:44:00.087034
4153	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:44:00.087034
4154	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:44:00.087034
4155	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:44:00.087034
4156	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:45:00.00462
4157	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:45:00.00462
4158	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:45:00.00462
4159	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:45:00.00462
4160	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:45:00.00462
4161	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:46:00.104842
4162	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:46:00.104842
4163	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:46:00.104842
4164	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:46:00.104842
4165	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:46:00.104842
4166	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:47:00.103541
4167	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:47:00.103541
4168	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:47:00.103541
4169	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:47:00.103541
4170	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:47:00.103541
4171	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:48:00.019922
4172	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:48:00.019922
4173	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:48:00.019922
4174	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:48:00.019922
4175	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:48:00.019922
4176	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:49:00.051168
4177	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:49:00.051168
4178	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:49:00.051168
4179	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:49:00.051168
4180	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:49:00.051168
4181	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:50:00.10499
4182	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:50:00.10499
4183	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:50:00.10499
4184	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:50:00.10499
4185	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:50:00.10499
4186	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:51:00.011607
4187	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:51:00.011607
4188	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:51:00.011607
4189	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:51:00.011607
4190	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:51:00.011607
4191	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:52:00.006873
4192	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:52:00.006873
4193	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:52:00.006873
4194	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:52:00.006873
4195	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:52:00.006873
4196	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:53:00.015358
4197	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:53:00.015358
4198	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:53:00.015358
4199	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:53:00.015358
4200	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:53:00.015358
4201	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:54:00.033705
4202	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:54:00.033705
4203	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:54:00.033705
4204	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:54:00.033705
4205	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:54:00.033705
4206	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:55:00.108542
4207	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:55:00.108542
4208	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:55:00.108542
4209	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:55:00.108542
4210	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:55:00.108542
4211	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:56:00.073959
4212	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:56:00.073959
4213	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:56:00.073959
4214	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:56:00.073959
4215	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:56:00.073959
4216	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:57:00.003199
4217	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:57:00.003199
4218	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:57:00.003199
4219	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:57:00.003199
4220	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:57:00.003199
4221	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:58:00.033764
4222	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:58:00.033764
4223	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:58:00.033764
4224	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:58:00.033764
4225	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:58:00.033764
4226	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 02:59:00.083985
4227	4	showroom	main_area	10	0	Low	0.00	2026-02-04 02:59:00.083985
4228	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 02:59:00.083985
4229	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 02:59:00.083985
4230	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 02:59:00.083985
4231	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:00:00.006027
4232	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:00:00.006027
4233	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:00:00.006027
4234	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:00:00.006027
4235	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:00:00.006027
4236	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:01:00.028103
4237	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:01:00.028103
4238	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:01:00.028103
4239	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:01:00.028103
4240	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:01:00.028103
4241	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:02:00.050747
4242	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:02:00.050747
4243	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:02:00.050747
4244	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:02:00.050747
4245	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:02:00.050747
4246	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:03:00.112846
4247	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:03:00.112846
4248	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:03:00.112846
4249	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:03:00.112846
4250	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:03:00.112846
4251	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:04:00.021146
4252	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:04:00.021146
4253	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:04:00.021146
4254	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:04:00.021146
4255	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:04:00.021146
4256	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:05:00.035
4257	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:05:00.035
4258	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:05:00.035
4259	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:05:00.035
4260	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:05:00.035
4261	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:06:00.039967
4262	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:06:00.039967
4263	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:06:00.039967
4264	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:06:00.039967
4265	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:06:00.039967
4266	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:07:00.016674
4267	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:07:00.016674
4268	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:07:00.016674
4269	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:07:00.016674
4270	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:07:00.016674
4271	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:08:00.119993
4272	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:08:00.119993
4273	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:08:00.119993
4274	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:08:00.119993
4275	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:08:00.119993
4276	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:09:00.091343
4277	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:09:00.091343
4278	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:09:00.091343
4279	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:09:00.091343
4280	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:09:00.091343
4281	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:10:00.102559
4282	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:10:00.102559
4283	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:10:00.102559
4284	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:10:00.102559
4285	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:10:00.102559
4286	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:11:00.038092
4287	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:11:00.038092
4288	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:11:00.038092
4289	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:11:00.038092
4290	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:11:00.038092
4291	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:12:00.021247
4292	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:12:00.021247
4293	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:12:00.021247
4294	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:12:00.021247
4295	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:12:00.021247
4296	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:13:00.003606
4297	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:13:00.003606
4298	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:13:00.003606
4299	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:13:00.003606
4300	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:13:00.003606
4301	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:14:00.014511
4302	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:14:00.014511
4303	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:14:00.014511
4304	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:14:00.014511
4305	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:14:00.014511
4306	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:15:00.030857
4307	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:15:00.030857
4308	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:15:00.030857
4309	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:15:00.030857
4310	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:15:00.030857
4311	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:16:00.005612
4312	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:16:00.005612
4313	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:16:00.005612
4314	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:16:00.005612
4315	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:16:00.005612
4316	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:17:00.011543
4317	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:17:00.011543
4318	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:17:00.011543
4319	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:17:00.011543
4320	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:17:00.011543
4321	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:18:00.003788
4322	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:18:00.003788
4323	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:18:00.003788
4324	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:18:00.003788
4325	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:18:00.003788
4326	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:19:00.00652
4327	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:19:00.00652
4328	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:19:00.00652
4329	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:19:00.00652
4330	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:19:00.00652
4331	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:20:00.007058
4332	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:20:00.007058
4333	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:20:00.007058
4334	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:20:00.007058
4335	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:20:00.007058
4336	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:21:00.066613
4337	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:21:00.066613
4338	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:21:00.066613
4339	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:21:00.066613
4340	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:21:00.066613
4341	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:22:00.020882
4342	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:22:00.020882
4343	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:22:00.020882
4344	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:22:00.020882
4345	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:22:00.020882
4346	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:23:00.003132
4347	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:23:00.003132
4348	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:23:00.003132
4349	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:23:00.003132
4350	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:23:00.003132
4351	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:24:00.034739
4352	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:24:00.034739
4353	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:24:00.034739
4354	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:24:00.034739
4355	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:24:00.034739
4356	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:25:00.064847
4357	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:25:00.064847
4358	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:25:00.064847
4359	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:25:00.064847
4360	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:25:00.064847
4361	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:26:00.026942
4362	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:26:00.026942
4363	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:26:00.026942
4364	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:26:00.026942
4365	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:26:00.026942
4366	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:27:00.013655
4367	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:27:00.013655
4368	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:27:00.013655
4369	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:27:00.013655
4370	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:27:00.013655
4371	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:28:00.011084
4372	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:28:00.011084
4373	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:28:00.011084
4374	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:28:00.011084
4375	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:28:00.011084
4376	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:29:00.008133
4377	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:29:00.008133
4378	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:29:00.008133
4379	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:29:00.008133
4380	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:29:00.008133
4381	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:30:00.047027
4382	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:30:00.047027
4383	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:30:00.047027
4384	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:30:00.047027
4385	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:30:00.047027
4386	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:31:00.012077
4387	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:31:00.012077
4388	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:31:00.012077
4389	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:31:00.012077
4390	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:31:00.012077
4391	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:32:00.038625
4392	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:32:00.038625
4393	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:32:00.038625
4394	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:32:00.038625
4395	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:32:00.038625
4396	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:33:00.058627
4397	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:33:00.058627
4398	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:33:00.058627
4399	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:33:00.058627
4400	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:33:00.058627
4401	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:34:00.01124
4402	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:34:00.01124
4403	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:34:00.01124
4404	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:34:00.01124
4405	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:34:00.01124
4406	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:35:00.093943
4407	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:35:00.093943
4408	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:35:00.093943
4409	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:35:00.093943
4410	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:35:00.093943
4411	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:36:00.131748
4412	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:36:00.131748
4413	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:36:00.131748
4414	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:36:00.131748
4415	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:36:00.131748
4416	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:37:00.069828
4417	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:37:00.069828
4418	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:37:00.069828
4419	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:37:00.069828
4420	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:37:00.069828
4421	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:38:00.019144
4422	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:38:00.019144
4423	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:38:00.019144
4424	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:38:00.019144
4425	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:38:00.019144
4426	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:39:00.096249
4427	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:39:00.096249
4428	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:39:00.096249
4429	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:39:00.096249
4430	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:39:00.096249
4431	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:40:00.119174
4432	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:40:00.119174
4433	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:40:00.119174
4434	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:40:00.119174
4435	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:40:00.119174
4436	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:41:00.044588
4437	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:41:00.044588
4438	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:41:00.044588
4439	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:41:00.044588
4440	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:41:00.044588
4441	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:42:00.093846
4442	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:42:00.093846
4443	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:42:00.093846
4444	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:42:00.093846
4445	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:42:00.093846
4446	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:43:00.090343
4447	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:43:00.090343
4448	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:43:00.090343
4449	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:43:00.090343
4450	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:43:00.090343
4451	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:44:00.114243
4452	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:44:00.114243
4453	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:44:00.114243
4454	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:44:00.114243
4455	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:44:00.114243
4456	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:45:00.031345
4457	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:45:00.031345
4458	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:45:00.031345
4459	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:45:00.031345
4460	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:45:00.031345
4461	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:46:00.018241
4462	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:46:00.018241
4463	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:46:00.018241
4464	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:46:00.018241
4465	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:46:00.018241
4466	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:47:00.021862
4467	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:47:00.021862
4468	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:47:00.021862
4469	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:47:00.021862
4470	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:47:00.021862
4471	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:48:00.000533
4472	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:48:00.000533
4473	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:48:00.000533
4474	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:48:00.000533
4475	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:48:00.000533
4476	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:49:00.100992
4477	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:49:00.100992
4478	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:49:00.100992
4479	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:49:00.100992
4480	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:49:00.100992
4481	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:50:00.041748
4482	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:50:00.041748
4483	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:50:00.041748
4484	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:50:00.041748
4485	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:50:00.041748
4486	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:51:00.03253
4487	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:51:00.03253
4488	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:51:00.03253
4489	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:51:00.03253
4490	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:51:00.03253
4491	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:52:00.011803
4492	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:52:00.011803
4493	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:52:00.011803
4494	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:52:00.011803
4495	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:52:00.011803
4496	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:53:00.001447
4497	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:53:00.001447
4498	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:53:00.001447
4499	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:53:00.001447
4500	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:53:00.001447
4501	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:54:00.051959
4502	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:54:00.051959
4503	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:54:00.051959
4504	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:54:00.051959
4505	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:54:00.051959
4506	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:55:00.015105
4507	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:55:00.015105
4508	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:55:00.015105
4509	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:55:00.015105
4510	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:55:00.015105
4511	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:56:00.037938
4512	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:56:00.037938
4513	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:56:00.037938
4514	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:56:00.037938
4515	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:56:00.037938
4516	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:57:00.108322
4517	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:57:00.108322
4518	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:57:00.108322
4519	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:57:00.108322
4520	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:57:00.108322
4521	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:58:00.102583
4522	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:58:00.102583
4523	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:58:00.102583
4524	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:58:00.102583
4525	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:58:00.102583
4526	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 03:59:00.039377
4527	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 03:59:00.039377
4528	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 03:59:00.039377
4529	4	showroom	main_area	10	0	Low	0.00	2026-02-04 03:59:00.039377
4530	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 03:59:00.039377
4531	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:00:00.008337
4532	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:00:00.008337
4533	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:00:00.008337
4534	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:00:00.008337
4535	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:00:00.008337
4536	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:01:00.082571
4537	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:01:00.082571
4538	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:01:00.082571
4539	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:01:00.082571
4540	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:01:00.082571
4541	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:02:00.121227
4542	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:02:00.121227
4543	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:02:00.121227
4544	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:02:00.121227
4545	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:02:00.121227
4546	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:03:00.122418
4547	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:03:00.122418
4548	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:03:00.122418
4549	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:03:00.122418
4550	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:03:00.122418
4551	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:04:00.005
4552	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:04:00.005
4553	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:04:00.005
4554	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:04:00.005
4555	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:04:00.005
4556	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:05:00.041571
4557	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:05:00.041571
4558	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:05:00.041571
4559	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:05:00.041571
4560	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:05:00.041571
4561	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:06:00.033005
4562	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:06:00.033005
4563	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:06:00.033005
4564	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:06:00.033005
4565	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:06:00.033005
4566	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:07:00.003896
4567	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:07:00.003896
4568	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:07:00.003896
4569	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:07:00.003896
4570	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:07:00.003896
4571	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:08:00.000945
4572	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:08:00.000945
4573	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:08:00.000945
4574	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:08:00.000945
4575	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:08:00.000945
4576	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:09:00.012099
4577	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:09:00.012099
4578	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:09:00.012099
4579	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:09:00.012099
4580	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:09:00.012099
4581	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:10:00.097877
4582	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:10:00.097877
4583	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:10:00.097877
4584	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:10:00.097877
4585	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:10:00.097877
4586	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:11:00.053177
4587	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:11:00.053177
4588	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:11:00.053177
4589	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:11:00.053177
4590	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:11:00.053177
4591	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:12:00.018086
4592	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:12:00.018086
4593	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:12:00.018086
4594	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:12:00.018086
4595	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:12:00.018086
4596	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:13:00.075324
4597	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:13:00.075324
4598	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:13:00.075324
4599	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:13:00.075324
4600	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:13:00.075324
4601	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:14:00.035439
4602	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:14:00.035439
4603	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:14:00.035439
4604	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:14:00.035439
4605	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:14:00.035439
4606	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:15:00.028654
4607	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:15:00.028654
4608	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:15:00.028654
4609	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:15:00.028654
4610	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:15:00.028654
4611	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:16:00.114139
4612	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:16:00.114139
4613	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:16:00.114139
4614	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:16:00.114139
4615	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:16:00.114139
4616	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:17:00.040353
4617	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:17:00.040353
4618	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:17:00.040353
4619	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:17:00.040353
4620	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:17:00.040353
4621	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:18:00.000548
4622	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:18:00.000548
4623	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:18:00.000548
4624	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:18:00.000548
4625	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:18:00.000548
4626	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:19:00.028826
4627	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:19:00.028826
4628	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:19:00.028826
4629	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:19:00.028826
4630	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:19:00.028826
4631	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:20:00.113237
4632	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:20:00.113237
4633	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:20:00.113237
4634	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:20:00.113237
4635	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:20:00.113237
4636	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:21:00.004657
4637	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:21:00.004657
4638	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:21:00.004657
4639	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:21:00.004657
4640	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:21:00.004657
4641	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:22:00.031271
4642	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:22:00.031271
4643	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:22:00.031271
4644	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:22:00.031271
4645	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:22:00.031271
4646	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:23:00.006212
4647	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:23:00.006212
4648	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:23:00.006212
4649	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:23:00.006212
4650	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:23:00.006212
4651	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:24:00.064984
4652	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:24:00.064984
4653	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:24:00.064984
4654	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:24:00.064984
4655	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:24:00.064984
4656	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:25:00.081919
4657	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:25:00.081919
4658	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:25:00.081919
4659	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:25:00.081919
4660	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:25:00.081919
4661	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:26:00.077018
4662	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:26:00.077018
4663	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:26:00.077018
4664	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:26:00.077018
4665	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:26:00.077018
4666	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:27:00.005268
4667	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:27:00.005268
4668	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:27:00.005268
4669	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:27:00.005268
4670	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:27:00.005268
4671	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:28:00.013291
4672	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:28:00.013291
4673	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:28:00.013291
4674	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:28:00.013291
4675	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:28:00.013291
4676	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:29:00.009376
4677	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:29:00.009376
4678	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:29:00.009376
4679	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:29:00.009376
4680	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:29:00.009376
4681	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:30:00.007855
4682	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:30:00.007855
4683	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:30:00.007855
4684	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:30:00.007855
4685	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:30:00.007855
4686	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:31:00.077613
4687	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:31:00.077613
4688	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:31:00.077613
4689	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:31:00.077613
4690	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:31:00.077613
4691	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:32:00.009606
4692	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:32:00.009606
4693	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:32:00.009606
4694	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:32:00.009606
4695	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:32:00.009606
4696	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:33:00.059779
4697	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:33:00.059779
4698	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:33:00.059779
4699	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:33:00.059779
4700	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:33:00.059779
4701	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:34:00.115452
4702	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:34:00.115452
4703	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:34:00.115452
4704	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:34:00.115452
4705	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:34:00.115452
4706	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:35:00.028825
4707	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:35:00.028825
4708	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:35:00.028825
4709	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:35:00.028825
4710	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:35:00.028825
4711	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:36:00.099521
4712	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:36:00.099521
4713	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:36:00.099521
4714	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:36:00.099521
4715	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:36:00.099521
4716	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:37:00.018409
4717	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:37:00.018409
4718	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:37:00.018409
4719	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:37:00.018409
4720	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:37:00.018409
4721	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:38:00.008112
4722	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:38:00.008112
4723	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:38:00.008112
4724	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:38:00.008112
4725	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:38:00.008112
4726	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:39:00.093842
4727	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:39:00.093842
4728	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:39:00.093842
4729	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:39:00.093842
4730	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:39:00.093842
4731	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:40:00.04155
4732	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:40:00.04155
4733	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:40:00.04155
4734	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:40:00.04155
4735	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:40:00.04155
4736	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:41:00.099096
4737	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:41:00.099096
4738	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:41:00.099096
4739	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:41:00.099096
4740	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:41:00.099096
4741	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:42:00.008735
4742	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:42:00.008735
4743	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:42:00.008735
4744	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:42:00.008735
4745	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:42:00.008735
4746	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:43:00.021885
4747	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:43:00.021885
4748	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:43:00.021885
4749	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:43:00.021885
4750	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:43:00.021885
4751	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:44:00.0717
4752	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:44:00.0717
4753	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:44:00.0717
4754	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:44:00.0717
4755	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:44:00.0717
4756	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:45:00.002676
4757	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:45:00.002676
4758	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:45:00.002676
4759	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:45:00.002676
4760	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:45:00.002676
4761	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:46:00.096943
4762	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:46:00.096943
4763	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:46:00.096943
4764	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:46:00.096943
4765	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:46:00.096943
4766	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:47:00.0503
4767	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:47:00.0503
4768	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:47:00.0503
4769	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:47:00.0503
4770	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:47:00.0503
4771	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:48:00.124137
4772	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:48:00.124137
4773	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:48:00.124137
4774	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:48:00.124137
4775	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:48:00.124137
4776	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:49:00.007389
4777	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:49:00.007389
4778	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:49:00.007389
4779	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:49:00.007389
4780	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:49:00.007389
4781	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:50:00.073917
4782	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:50:00.073917
4783	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:50:00.073917
4784	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:50:00.073917
4785	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:50:00.073917
4786	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:51:00.033631
4787	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:51:00.033631
4788	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:51:00.033631
4789	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:51:00.033631
4790	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:51:00.033631
4791	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:52:00.010733
4792	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:52:00.010733
4793	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:52:00.010733
4794	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:52:00.010733
4795	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:52:00.010733
4796	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:53:00.007289
4797	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:53:00.007289
4798	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:53:00.007289
4799	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:53:00.007289
4800	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:53:00.007289
4801	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:54:00.037136
4802	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:54:00.037136
4803	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:54:00.037136
4804	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:54:00.037136
4805	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:54:00.037136
4806	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:55:00.001533
4807	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:55:00.001533
4808	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:55:00.001533
4809	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:55:00.001533
4810	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:55:00.001533
4811	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:56:00.018942
4812	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:56:00.018942
4813	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:56:00.018942
4814	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:56:00.018942
4815	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:56:00.018942
4816	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:57:00.007173
4817	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:57:00.007173
4818	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:57:00.007173
4819	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:57:00.007173
4820	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:57:00.007173
4821	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:58:00.026776
4822	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:58:00.026776
4823	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:58:00.026776
4824	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:58:00.026776
4825	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:58:00.026776
4826	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 04:59:00.002532
4827	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 04:59:00.002532
4828	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 04:59:00.002532
4829	4	showroom	main_area	10	0	Low	0.00	2026-02-04 04:59:00.002532
4830	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 04:59:00.002532
4831	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:00:00.03333
4832	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:00:00.03333
4833	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:00:00.03333
4834	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:00:00.03333
4835	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:00:00.03333
4836	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:01:00.0647
4837	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:01:00.0647
4838	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:01:00.0647
4839	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:01:00.0647
4840	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:01:00.0647
4841	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:02:00.018721
4842	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:02:00.018721
4843	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:02:00.018721
4844	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:02:00.018721
4845	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:02:00.018721
4846	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:03:00.030133
4847	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:03:00.030133
4848	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:03:00.030133
4849	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:03:00.030133
4850	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:03:00.030133
4851	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:04:00.112976
4852	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:04:00.112976
4853	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:04:00.112976
4854	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:04:00.112976
4855	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:04:00.112976
4856	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:05:00.005191
4857	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:05:00.005191
4858	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:05:00.005191
4859	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:05:00.005191
4860	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:05:00.005191
4861	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:06:00.091824
4862	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:06:00.091824
4863	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:06:00.091824
4864	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:06:00.091824
4865	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:06:00.091824
4866	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:07:00.100409
4867	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:07:00.100409
4868	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:07:00.100409
4869	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:07:00.100409
4870	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:07:00.100409
4871	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:08:00.051487
4872	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:08:00.051487
4873	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:08:00.051487
4874	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:08:00.051487
4875	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:08:00.051487
4876	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:09:00.002216
4877	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:09:00.002216
4878	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:09:00.002216
4879	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:09:00.002216
4880	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:09:00.002216
4881	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:10:00.064967
4882	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:10:00.064967
4883	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:10:00.064967
4884	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:10:00.064967
4885	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:10:00.064967
4886	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:11:00.003867
4887	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:11:00.003867
4888	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:11:00.003867
4889	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:11:00.003867
4890	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:11:00.003867
4891	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:12:00.006609
4892	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:12:00.006609
4893	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:12:00.006609
4894	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:12:00.006609
4895	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:12:00.006609
4896	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:13:00.00049
4897	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:13:00.00049
4898	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:13:00.00049
4899	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:13:00.00049
4900	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:13:00.00049
4901	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:14:00.110061
4902	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:14:00.110061
4903	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:14:00.110061
4904	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:14:00.110061
4905	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:14:00.110061
4906	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:15:00.003075
4907	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:15:00.003075
4908	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:15:00.003075
4909	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:15:00.003075
4910	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:15:00.003075
4911	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:16:00.028247
4912	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:16:00.028247
4913	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:16:00.028247
4914	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:16:00.028247
4915	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:16:00.028247
4916	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:17:00.000731
4917	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:17:00.000731
4918	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:17:00.000731
4919	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:17:00.000731
4920	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:17:00.000731
4921	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:18:00.109677
4922	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:18:00.109677
4923	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:18:00.109677
4924	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:18:00.109677
4925	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:18:00.109677
4926	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:19:00.010214
4927	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:19:00.010214
4928	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:19:00.010214
4929	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:19:00.010214
4930	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:19:00.010214
4931	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:20:00.062207
4932	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:20:00.062207
4933	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:20:00.062207
4934	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:20:00.062207
4935	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:20:00.062207
4936	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:21:00.021113
4937	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:21:00.021113
4938	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:21:00.021113
4939	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:21:00.021113
4940	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:21:00.021113
4941	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:22:00.006054
4942	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:22:00.006054
4943	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:22:00.006054
4944	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:22:00.006054
4945	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:22:00.006054
4946	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:23:00.003656
4947	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:23:00.003656
4948	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:23:00.003656
4949	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:23:00.003656
4950	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:23:00.003656
4951	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:24:00.022886
4952	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:24:00.022886
4953	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:24:00.022886
4954	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:24:00.022886
4955	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:24:00.022886
4956	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:25:00.048301
4957	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:25:00.048301
4958	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:25:00.048301
4959	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:25:00.048301
4960	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:25:00.048301
4961	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:26:00.011501
4962	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:26:00.011501
4963	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:26:00.011501
4964	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:26:00.011501
4965	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:26:00.011501
4966	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:27:00.004503
4967	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:27:00.004503
4968	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:27:00.004503
4969	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:27:00.004503
4970	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:27:00.004503
4971	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:28:00.065272
4972	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:28:00.065272
4973	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:28:00.065272
4974	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:28:00.065272
4975	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:28:00.065272
4976	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:29:00.087088
4977	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:29:00.087088
4978	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:29:00.087088
4979	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:29:00.087088
4980	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:29:00.087088
4981	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:30:00.025948
4982	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:30:00.025948
4983	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:30:00.025948
4984	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:30:00.025948
4985	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:30:00.025948
4986	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:31:00.066524
4987	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:31:00.066524
4988	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:31:00.066524
4989	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:31:00.066524
4990	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:31:00.066524
4991	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:32:00.075972
4992	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:32:00.075972
4993	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:32:00.075972
4994	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:32:00.075972
4995	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:32:00.075972
4996	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:33:00.094946
4997	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:33:00.094946
4998	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:33:00.094946
4999	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:33:00.094946
5000	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:33:00.094946
5001	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:34:00.019973
5002	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:34:00.019973
5003	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:34:00.019973
5004	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:34:00.019973
5005	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:34:00.019973
5006	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:35:00.038392
5007	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:35:00.038392
5008	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:35:00.038392
5009	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:35:00.038392
5010	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:35:00.038392
5011	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:36:00.010898
5012	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:36:00.010898
5013	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:36:00.010898
5014	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:36:00.010898
5015	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:36:00.010898
5016	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:37:00.05718
5017	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:37:00.05718
5018	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:37:00.05718
5019	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:37:00.05718
5020	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:37:00.05718
5021	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:38:00.020514
5022	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:38:00.020514
5023	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:38:00.020514
5024	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:38:00.020514
5025	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:38:00.020514
5026	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:39:00.040919
5027	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:39:00.040919
5028	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:39:00.040919
5029	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:39:00.040919
5030	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:39:00.040919
5031	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:40:00.090664
5032	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:40:00.090664
5033	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:40:00.090664
5034	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:40:00.090664
5035	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:40:00.090664
5036	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:41:00.050914
5037	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:41:00.050914
5038	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:41:00.050914
5039	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:41:00.050914
5040	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:41:00.050914
5041	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:42:00.092302
5042	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:42:00.092302
5043	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:42:00.092302
5044	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:42:00.092302
5045	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:42:00.092302
5046	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:43:00.046438
5047	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:43:00.046438
5048	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:43:00.046438
5049	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:43:00.046438
5050	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:43:00.046438
5051	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:44:00.007563
5052	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:44:00.007563
5053	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:44:00.007563
5054	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:44:00.007563
5055	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:44:00.007563
5056	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:45:00.01738
5057	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:45:00.01738
5058	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:45:00.01738
5059	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:45:00.01738
5060	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:45:00.01738
5061	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:46:00.080291
5062	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:46:00.080291
5063	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:46:00.080291
5064	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:46:00.080291
5065	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:46:00.080291
5066	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:47:00.01995
5067	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:47:00.01995
5068	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:47:00.01995
5069	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:47:00.01995
5070	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:47:00.01995
5071	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:48:00.00542
5072	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:48:00.00542
5073	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:48:00.00542
5074	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:48:00.00542
5075	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:48:00.00542
5076	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:49:00.109072
5077	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:49:00.109072
5078	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:49:00.109072
5079	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:49:00.109072
5080	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:49:00.109072
5081	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:50:00.116495
5082	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:50:00.116495
5083	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:50:00.116495
5084	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:50:00.116495
5085	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:50:00.116495
5086	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:51:00.007258
5087	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:51:00.007258
5088	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:51:00.007258
5089	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:51:00.007258
5090	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:51:00.007258
5091	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:52:00.054335
5092	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:52:00.054335
5093	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:52:00.054335
5094	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:52:00.054335
5095	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:52:00.054335
5096	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:53:00.10685
5097	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:53:00.10685
5098	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:53:00.10685
5099	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:53:00.10685
5100	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:53:00.10685
5101	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:54:00.007831
5102	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:54:00.007831
5103	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:54:00.007831
5104	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:54:00.007831
5105	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:54:00.007831
5106	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:55:00.079635
5107	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:55:00.079635
5108	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:55:00.079635
5109	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:55:00.079635
5110	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:55:00.079635
5111	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:56:00.02361
5112	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:56:00.02361
5113	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:56:00.02361
5114	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:56:00.02361
5115	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:56:00.02361
5116	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:57:00.05959
5117	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:57:00.05959
5118	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:57:00.05959
5119	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:57:00.05959
5120	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:57:00.05959
5121	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:58:00.028491
5122	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:58:00.028491
5123	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:58:00.028491
5124	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:58:00.028491
5125	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:58:00.028491
5126	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 05:59:00.103715
5127	4	showroom	main_area	10	0	Low	0.00	2026-02-04 05:59:00.103715
5128	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 05:59:00.103715
5129	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 05:59:00.103715
5130	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 05:59:00.103715
5131	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:00:00.050627
5132	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:00:00.050627
5133	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:00:00.050627
5134	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:00:00.050627
5135	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:00:00.050627
5136	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:01:00.010228
5137	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:01:00.010228
5138	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:01:00.010228
5139	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:01:00.010228
5140	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:01:00.010228
5141	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:02:00.050303
5142	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:02:00.050303
5143	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:02:00.050303
5144	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:02:00.050303
5145	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:02:00.050303
5146	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:03:00.058977
5147	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:03:00.058977
5148	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:03:00.058977
5149	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:03:00.058977
5150	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:03:00.058977
5151	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:04:00.116192
5152	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:04:00.116192
5153	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:04:00.116192
5154	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:04:00.116192
5155	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:04:00.116192
5156	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:05:00.047887
5157	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:05:00.047887
5158	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:05:00.047887
5159	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:05:00.047887
5160	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:05:00.047887
5161	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:06:00.016733
5162	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:06:00.016733
5163	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:06:00.016733
5164	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:06:00.016733
5165	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:06:00.016733
5166	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:07:00.080328
5167	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:07:00.080328
5168	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:07:00.080328
5169	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:07:00.080328
5170	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:07:00.080328
5171	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:08:00.063682
5172	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:08:00.063682
5173	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:08:00.063682
5174	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:08:00.063682
5175	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:08:00.063682
5176	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:09:00.032032
5177	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:09:00.032032
5178	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:09:00.032032
5179	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:09:00.032032
5180	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:09:00.032032
5181	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:10:00.060931
5182	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:10:00.060931
5183	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:10:00.060931
5184	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:10:00.060931
5185	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:10:00.060931
5186	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:11:00.004412
5187	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:11:00.004412
5188	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:11:00.004412
5189	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:11:00.004412
5190	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:11:00.004412
5191	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:12:00.013873
5192	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:12:00.013873
5193	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:12:00.013873
5194	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:12:00.013873
5195	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:12:00.013873
5196	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:13:00.001969
5197	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:13:00.001969
5198	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:13:00.001969
5199	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:13:00.001969
5200	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:13:00.001969
5201	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:14:00.006465
5202	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:14:00.006465
5203	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:14:00.006465
5204	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:14:00.006465
5205	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:14:00.006465
5206	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:15:00.043796
5207	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:15:00.043796
5208	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:15:00.043796
5209	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:15:00.043796
5210	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:15:00.043796
5211	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:16:00.093217
5212	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:16:00.093217
5213	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:16:00.093217
5214	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:16:00.093217
5215	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:16:00.093217
5216	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:17:00.008581
5217	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:17:00.008581
5218	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:17:00.008581
5219	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:17:00.008581
5220	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:17:00.008581
5221	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:18:00.110068
5222	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:18:00.110068
5223	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:18:00.110068
5224	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:18:00.110068
5225	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:18:00.110068
5226	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:19:00.035202
5227	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:19:00.035202
5228	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:19:00.035202
5229	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:19:00.035202
5230	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:19:00.035202
5231	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:20:00.121905
5232	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:20:00.121905
5233	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:20:00.121905
5234	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:20:00.121905
5235	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:20:00.121905
5236	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:21:00.039326
5237	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:21:00.039326
5238	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:21:00.039326
5239	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:21:00.039326
5240	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:21:00.039326
5241	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:22:00.068698
5242	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:22:00.068698
5243	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:22:00.068698
5244	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:22:00.068698
5245	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:22:00.068698
5246	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:23:00.071764
5247	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:23:00.071764
5248	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:23:00.071764
5249	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:23:00.071764
5250	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:23:00.071764
5251	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:24:00.050585
5252	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:24:00.050585
5253	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:24:00.050585
5254	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:24:00.050585
5255	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:24:00.050585
5256	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:25:00.010652
5257	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:25:00.010652
5258	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:25:00.010652
5259	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:25:00.010652
5260	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:25:00.010652
5261	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:26:00.051023
5262	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:26:00.051023
5263	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:26:00.051023
5264	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:26:00.051023
5265	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:26:00.051023
5266	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:27:00.061371
5267	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:27:00.061371
5268	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:27:00.061371
5269	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:27:00.061371
5270	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:27:00.061371
5271	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:28:00.025539
5272	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:28:00.025539
5273	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:28:00.025539
5274	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:28:00.025539
5275	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:28:00.025539
5276	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:29:00.094778
5277	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:29:00.094778
5278	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:29:00.094778
5279	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:29:00.094778
5280	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:29:00.094778
5281	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:30:00.005319
5282	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:30:00.005319
5283	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:30:00.005319
5284	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:30:00.005319
5285	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:30:00.005319
5286	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:31:00.091728
5287	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:31:00.091728
5288	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:31:00.091728
5289	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:31:00.091728
5290	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:31:00.091728
5291	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:32:00.006473
5292	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:32:00.006473
5293	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:32:00.006473
5294	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:32:00.006473
5295	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:32:00.006473
5296	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:33:00.113554
5297	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:33:00.113554
5298	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:33:00.113554
5299	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:33:00.113554
5300	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:33:00.113554
5301	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:34:00.032969
5302	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:34:00.032969
5303	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:34:00.032969
5304	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:34:00.032969
5305	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:34:00.032969
5306	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:35:00.093682
5307	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:35:00.093682
5308	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:35:00.093682
5309	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:35:00.093682
5310	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:35:00.093682
5311	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:36:00.047257
5312	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:36:00.047257
5313	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:36:00.047257
5314	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:36:00.047257
5315	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:36:00.047257
5316	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:37:00.038883
5317	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:37:00.038883
5318	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:37:00.038883
5319	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:37:00.038883
5320	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:37:00.038883
5321	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:38:00.028219
5322	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:38:00.028219
5323	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:38:00.028219
5324	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:38:00.028219
5325	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:38:00.028219
5326	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:39:00.009033
5327	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:39:00.009033
5328	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:39:00.009033
5329	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:39:00.009033
5330	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:39:00.009033
5331	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:40:00.035311
5332	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:40:00.035311
5333	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:40:00.035311
5334	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:40:00.035311
5335	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:40:00.035311
5336	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:41:00.070183
5337	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:41:00.070183
5338	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:41:00.070183
5339	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:41:00.070183
5340	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:41:00.070183
5341	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:42:00.003125
5342	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:42:00.003125
5343	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:42:00.003125
5344	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:42:00.003125
5345	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:42:00.003125
5346	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:43:00.01216
5347	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:43:00.01216
5348	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:43:00.01216
5349	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:43:00.01216
5350	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:43:00.01216
5351	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:44:00.013353
5352	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:44:00.013353
5353	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:44:00.013353
5354	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:44:00.013353
5355	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:44:00.013353
5356	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:45:00.070536
5357	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:45:00.070536
5358	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:45:00.070536
5359	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:45:00.070536
5360	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:45:00.070536
5361	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:46:00.112526
5362	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:46:00.112526
5363	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:46:00.112526
5364	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:46:00.112526
5365	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:46:00.112526
5366	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:47:00.006184
5367	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:47:00.006184
5368	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:47:00.006184
5369	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:47:00.006184
5370	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:47:00.006184
5371	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:48:00.094847
5372	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:48:00.094847
5373	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:48:00.094847
5374	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:48:00.094847
5375	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:48:00.094847
5376	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:49:00.019027
5377	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:49:00.019027
5378	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:49:00.019027
5379	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:49:00.019027
5380	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:49:00.019027
5381	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:50:00.001487
5382	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:50:00.001487
5383	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:50:00.001487
5384	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:50:00.001487
5385	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:50:00.001487
5386	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:51:00.001446
5387	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:51:00.001446
5388	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:51:00.001446
5389	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:51:00.001446
5390	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:51:00.001446
5391	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:52:00.019947
5392	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:52:00.019947
5393	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:52:00.019947
5394	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:52:00.019947
5395	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:52:00.019947
5396	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:53:00.056011
5397	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:53:00.056011
5398	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:53:00.056011
5399	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:53:00.056011
5400	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:53:00.056011
5401	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:54:00.016507
5402	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:54:00.016507
5403	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:54:00.016507
5404	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:54:00.016507
5405	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:54:00.016507
5406	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:55:00.003441
5407	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:55:00.003441
5408	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:55:00.003441
5409	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:55:00.003441
5410	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:55:00.003441
5411	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:56:00.044183
5412	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:56:00.044183
5413	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:56:00.044183
5414	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:56:00.044183
5415	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:56:00.044183
5416	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:57:00.021239
5417	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:57:00.021239
5418	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:57:00.021239
5419	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:57:00.021239
5420	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:57:00.021239
5421	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:58:00.006289
5422	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:58:00.006289
5423	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:58:00.006289
5424	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:58:00.006289
5425	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:58:00.006289
5426	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 06:59:00.025634
5427	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 06:59:00.025634
5428	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 06:59:00.025634
5429	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 06:59:00.025634
5430	4	showroom	main_area	10	0	Low	0.00	2026-02-04 06:59:00.025634
5431	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:00:00.029291
5432	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:00:00.029291
5433	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:00:00.029291
5434	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:00:00.029291
5435	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:00:00.029291
5436	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:01:00.032428
5437	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:01:00.032428
5438	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:01:00.032428
5439	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:01:00.032428
5440	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:01:00.032428
5441	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:02:00.000675
5442	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:02:00.000675
5443	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:02:00.000675
5444	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:02:00.000675
5445	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:02:00.000675
5446	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:03:00.105461
5447	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:03:00.105461
5448	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:03:00.105461
5449	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:03:00.105461
5450	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:03:00.105461
5451	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:04:00.147737
5452	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:04:00.147737
5453	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:04:00.147737
5454	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:04:00.147737
5455	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:04:00.147737
5456	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:05:00.059546
5457	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:05:00.059546
5458	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:05:00.059546
5459	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:05:00.059546
5460	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:05:00.059546
5461	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:06:00.095698
5462	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:06:00.095698
5463	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:06:00.095698
5464	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:06:00.095698
5465	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:06:00.095698
5466	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:07:00.001102
5467	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:07:00.001102
5468	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:07:00.001102
5469	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:07:00.001102
5470	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:07:00.001102
5471	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:08:00.029679
5472	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:08:00.029679
5473	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:08:00.029679
5474	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:08:00.029679
5475	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:08:00.029679
5476	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:09:00.060378
5477	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:09:00.060378
5478	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:09:00.060378
5479	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:09:00.060378
5480	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:09:00.060378
5481	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:10:00.073239
5482	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:10:00.073239
5483	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:10:00.073239
5484	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:10:00.073239
5485	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:10:00.073239
5486	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:11:00.07219
5487	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:11:00.07219
5488	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:11:00.07219
5489	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:11:00.07219
5490	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:11:00.07219
5491	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:12:00.054304
5492	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:12:00.054304
5493	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:12:00.054304
5494	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:12:00.054304
5495	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:12:00.054304
5496	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:13:00.003463
5497	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:13:00.003463
5498	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:13:00.003463
5499	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:13:00.003463
5500	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:13:00.003463
5501	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:14:00.035694
5502	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:14:00.035694
5503	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:14:00.035694
5504	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:14:00.035694
5505	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:14:00.035694
5506	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:15:00.058903
5507	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:15:00.058903
5508	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:15:00.058903
5509	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:15:00.058903
5510	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:15:00.058903
5511	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:16:00.010748
5512	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:16:00.010748
5513	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:16:00.010748
5514	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:16:00.010748
5515	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:16:00.010748
5516	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:17:00.066993
5517	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:17:00.066993
5518	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:17:00.066993
5519	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:17:00.066993
5520	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:17:00.066993
5521	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:18:00.007608
5522	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:18:00.007608
5523	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:18:00.007608
5524	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:18:00.007608
5525	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:18:00.007608
5526	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:19:00.063388
5527	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:19:00.063388
5528	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:19:00.063388
5529	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:19:00.063388
5530	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:19:00.063388
5531	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:20:00.005964
5532	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:20:00.005964
5533	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:20:00.005964
5534	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:20:00.005964
5535	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:20:00.005964
5536	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:21:00.078409
5537	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:21:00.078409
5538	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:21:00.078409
5539	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:21:00.078409
5540	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:21:00.078409
5541	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:22:00.10479
5542	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:22:00.10479
5543	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:22:00.10479
5544	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:22:00.10479
5545	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:22:00.10479
5546	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:23:00.000518
5547	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:23:00.000518
5548	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:23:00.000518
5549	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:23:00.000518
5550	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:23:00.000518
5551	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:24:00.023521
5552	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:24:00.023521
5553	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:24:00.023521
5554	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:24:00.023521
5555	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:24:00.023521
5556	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:25:00.032865
5557	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:25:00.032865
5558	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:25:00.032865
5559	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:25:00.032865
5560	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:25:00.032865
5561	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:26:00.015123
5562	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:26:00.015123
5563	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:26:00.015123
5564	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:26:00.015123
5565	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:26:00.015123
5566	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:27:00.008048
5567	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:27:00.008048
5568	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:27:00.008048
5569	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:27:00.008048
5570	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:27:00.008048
5571	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:28:00.061804
5572	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:28:00.061804
5573	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:28:00.061804
5574	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:28:00.061804
5575	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:28:00.061804
5576	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:29:00.017696
5577	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:29:00.017696
5578	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:29:00.017696
5579	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:29:00.017696
5580	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:29:00.017696
5581	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:30:00.073818
5582	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:30:00.073818
5583	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:30:00.073818
5584	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:30:00.073818
5585	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:30:00.073818
5586	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:31:00.023725
5587	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:31:00.023725
5588	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:31:00.023725
5589	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:31:00.023725
5590	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:31:00.023725
5591	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:32:00.037076
5592	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:32:00.037076
5593	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:32:00.037076
5594	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:32:00.037076
5595	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:32:00.037076
5596	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:33:00.041204
5597	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:33:00.041204
5598	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:33:00.041204
5599	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:33:00.041204
5600	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:33:00.041204
5601	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:34:00.087038
5602	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:34:00.087038
5603	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:34:00.087038
5604	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:34:00.087038
5605	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:34:00.087038
5606	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:35:00.11685
5607	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:35:00.11685
5608	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:35:00.11685
5609	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:35:00.11685
5610	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:35:00.11685
5611	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:36:00.008496
5612	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:36:00.008496
5613	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:36:00.008496
5614	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:36:00.008496
5615	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:36:00.008496
5616	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:37:00.051484
5617	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:37:00.051484
5618	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:37:00.051484
5619	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:37:00.051484
5620	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:37:00.051484
5621	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:38:00.071194
5622	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:38:00.071194
5623	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:38:00.071194
5624	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:38:00.071194
5625	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:38:00.071194
5626	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:39:00.077687
5627	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:39:00.077687
5628	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:39:00.077687
5629	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:39:00.077687
5630	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:39:00.077687
5631	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:40:00.131123
5632	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:40:00.131123
5633	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:40:00.131123
5634	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:40:00.131123
5635	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:40:00.131123
5636	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:41:00.001344
5637	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:41:00.001344
5638	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:41:00.001344
5639	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:41:00.001344
5640	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:41:00.001344
5641	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:42:00.060621
5642	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:42:00.060621
5643	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:42:00.060621
5644	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:42:00.060621
5645	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:42:00.060621
5646	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:43:00.037137
5647	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:43:00.037137
5648	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:43:00.037137
5649	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:43:00.037137
5650	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:43:00.037137
5651	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:44:00.041885
5652	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:44:00.041885
5653	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:44:00.041885
5654	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:44:00.041885
5655	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:44:00.041885
5656	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:45:00.088101
5657	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:45:00.088101
5658	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:45:00.088101
5659	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:45:00.088101
5660	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:45:00.088101
5661	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:46:00.106118
5662	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:46:00.106118
5663	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:46:00.106118
5664	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:46:00.106118
5665	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:46:00.106118
5666	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:47:00.005997
5667	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:47:00.005997
5668	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:47:00.005997
5669	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:47:00.005997
5670	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:47:00.005997
5671	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:48:00.016444
5672	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:48:00.016444
5673	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:48:00.016444
5674	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:48:00.016444
5675	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:48:00.016444
5676	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:49:00.099871
5677	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:49:00.099871
5678	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:49:00.099871
5679	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:49:00.099871
5680	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:49:00.099871
5681	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:50:00.010247
5682	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:50:00.010247
5683	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:50:00.010247
5684	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:50:00.010247
5685	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:50:00.010247
5686	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:51:00.054972
5687	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:51:00.054972
5688	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:51:00.054972
5689	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:51:00.054972
5690	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:51:00.054972
5691	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:52:00.111776
5692	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:52:00.111776
5693	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:52:00.111776
5694	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 07:52:00.111776
5695	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:52:00.111776
5696	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:53:00.010528
5697	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:53:00.010528
5698	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:53:00.010528
5699	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 07:53:00.010528
5700	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:53:00.010528
5701	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:54:00.003941
5702	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:54:00.003941
5703	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 07:54:00.003941
5704	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:54:00.003941
5705	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:54:00.003941
5706	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:55:00.074965
5707	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:55:00.074965
5708	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:55:00.074965
5709	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:55:00.074965
5710	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:55:00.074965
5711	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:56:00.068775
5712	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:56:00.068775
5713	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:56:00.068775
5714	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:56:00.068775
5715	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:56:00.068775
5716	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:57:00.758775
5717	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:57:00.758775
5718	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:57:00.758775
5719	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:57:00.758775
5720	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:57:00.758775
5721	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 07:58:00.709648
5722	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 07:58:00.709648
5723	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 07:58:00.709648
5724	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 07:58:00.709648
5725	4	showroom	main_area	10	0	Low	0.00	2026-02-04 07:58:00.709648
5726	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 08:00:00.035585
5727	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:00:00.035585
5728	5	marketing-&-sales	main_area	10	0	Low	0.00	2026-02-04 08:00:00.035585
5729	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 08:00:00.035585
5730	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 08:00:00.035585
5731	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 08:02:48.433153
5732	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 08:02:48.433153
5733	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 08:03:38.734814
5734	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 08:04:27.258207
5735	3	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 08:04:27.258207
5736	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-04 08:05:06.965674
5737	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:06:57.381706
5738	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 08:06:57.381706
5739	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 08:06:57.381706
5740	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:06:57.381706
5741	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:07:53.611995
5742	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 08:09:25.057529
5743	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:19:56.686349
5744	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 08:19:56.686349
5745	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 08:19:56.686349
5746	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 08:22:29.276385
5747	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 08:23:08.678089
5748	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 08:28:36.93719
5749	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 08:32:12.723486
5750	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-04 08:34:43.800296
5751	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:38:45.514163
5752	4	showroom	main_area	10	2	Low	20.00	2026-02-04 08:40:56.070135
5753	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:41:00.032217
5754	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:41:00.032217
5755	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 08:41:00.032217
5756	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 08:42:00.084938
5757	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:42:00.084938
5758	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:42:00.084938
5759	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 08:42:00.084938
5760	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 08:42:00.084938
5761	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:43:00.083186
5762	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:43:00.083186
5763	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:43:00.083186
5764	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 08:43:00.083186
5765	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-04 08:43:00.083186
5766	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:44:00.008699
5767	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:44:00.008699
5768	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:44:00.008699
5769	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-04 08:44:00.008699
5770	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 08:44:00.008699
5771	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 08:45:00.08552
5772	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 08:45:00.08552
5773	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 08:45:00.08552
5774	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:45:00.08552
5775	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:45:00.08552
5776	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:46:00.001452
5777	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 08:46:00.001452
5778	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 08:46:00.001452
5779	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:46:00.001452
5780	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 08:46:00.001452
5781	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:47:00.03717
5782	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:47:00.03717
5783	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 08:47:00.03717
5784	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 08:47:00.03717
5785	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 08:47:00.03717
5786	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:48:00.089805
5787	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 08:48:00.089805
5788	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:48:00.089805
5789	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 08:48:00.089805
5790	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 08:48:00.089805
5791	2	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 08:49:00.109383
5792	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 08:49:00.109383
5793	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 08:49:00.109383
5794	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:49:00.109383
5795	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 08:49:00.109383
5796	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 08:50:00.104072
5797	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:50:00.104072
5798	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 08:50:00.104072
5799	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 08:50:00.104072
5800	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:50:00.104072
5801	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:51:00.043493
5802	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 08:51:00.043493
5803	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 08:51:00.043493
5804	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:51:00.043493
5805	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 08:51:00.043493
5806	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:52:00.098231
5807	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 08:52:00.098231
5808	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:52:00.098231
5809	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 08:52:00.098231
5810	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-04 08:52:00.098231
5811	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:53:00.165847
5812	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-04 08:53:00.165847
5813	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 08:53:00.165847
5814	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:53:00.165847
5815	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 08:53:00.165847
5816	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:54:00.023154
5817	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 08:54:00.023154
5818	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:54:00.023154
5819	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 08:54:00.023154
5820	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 08:54:00.023154
5821	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:55:00.079372
5822	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:55:00.079372
5823	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:55:00.079372
5824	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 08:55:00.079372
5825	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 08:55:00.079372
5826	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:56:00.134112
5827	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:56:00.134112
5828	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 08:56:00.134112
5829	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 08:56:00.134112
5830	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:56:00.134112
5831	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:57:00.008672
5832	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:57:00.008672
5833	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-04 08:57:00.008672
5834	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:57:00.008672
5835	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-04 08:57:00.008672
5836	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 08:58:00.183257
5837	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-04 08:58:00.183257
5838	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:58:00.183257
5839	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:58:00.183257
5840	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:58:00.183257
5841	4	showroom	main_area	10	0	Low	0.00	2026-02-04 08:59:00.022647
5842	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-04 08:59:00.022647
5843	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:59:00.022647
5844	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 08:59:00.022647
5845	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-04 08:59:00.022647
5846	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-04 09:00:00.133974
5847	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:00:00.133974
5848	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:00:00.133974
5849	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 09:00:00.133974
5850	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:00:00.133974
5851	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:01:00.00167
5852	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-04 09:01:00.00167
5853	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 09:01:00.00167
5854	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:01:00.00167
5855	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:01:00.00167
5856	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:02:00.083615
5857	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:02:00.083615
5858	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 09:02:00.083615
5859	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:02:00.083615
5860	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-04 09:02:00.083615
5861	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-04 09:03:00.006637
5862	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:03:00.006637
5863	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:03:00.006637
5864	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:03:00.006637
5865	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:03:00.006637
5866	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:04:00.077264
5867	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:04:00.077264
5868	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:04:00.077264
5869	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-04 09:04:00.077264
5870	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-04 09:04:00.077264
5871	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:05:00.003611
5872	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-04 09:05:00.003611
5873	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 09:05:00.003611
5874	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:05:00.003611
5875	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:05:00.003611
5876	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 09:06:00.070278
5877	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:06:00.070278
5878	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:06:00.070278
5879	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:06:00.070278
5880	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-04 09:06:00.070278
5881	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:07:00.087238
5882	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:07:00.087238
5883	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:07:00.087238
5884	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 09:07:00.087238
5885	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:07:00.087238
5886	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-04 09:08:00.00222
5887	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:08:00.00222
5888	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:08:00.00222
5889	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 09:08:00.00222
5890	4	showroom	main_area	10	1	Low	10.00	2026-02-04 09:08:00.00222
5891	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-04 09:09:00.221842
5892	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-04 09:09:00.221842
5893	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:09:00.221842
5894	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:09:00.221842
5895	4	showroom	main_area	10	1	Low	10.00	2026-02-04 09:09:00.221842
5896	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:10:00.019695
5897	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:10:00.019695
5898	4	showroom	main_area	10	1	Low	10.00	2026-02-04 09:10:00.019695
5899	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:10:00.019695
5900	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-04 09:10:00.019695
5901	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:11:00.106297
5902	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:11:00.106297
5903	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:11:00.106297
5904	4	showroom	main_area	10	1	Low	10.00	2026-02-04 09:11:00.106297
5905	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-04 09:11:00.106297
5906	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:12:00.125241
5907	4	showroom	main_area	10	2	Low	20.00	2026-02-04 09:12:00.125241
5908	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:12:00.125241
5909	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:12:00.125241
5910	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-04 09:12:00.125241
5911	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:13:00.064544
5912	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-04 09:13:00.064544
5913	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:13:00.064544
5914	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:13:00.064544
5915	4	showroom	main_area	10	1	Low	10.00	2026-02-04 09:13:00.064544
5916	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:14:00.037903
5917	4	showroom	main_area	10	1	Low	10.00	2026-02-04 09:14:00.037903
5918	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:14:00.037903
5919	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:14:00.037903
5920	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:14:00.037903
5921	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:15:00.013908
5922	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:15:00.013908
5923	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:15:00.013908
5924	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:15:00.013908
5925	4	showroom	main_area	10	1	Low	10.00	2026-02-04 09:15:00.013908
5926	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:16:00.058852
5927	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:16:00.058852
5928	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:16:00.058852
5929	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:16:00.058852
5930	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:16:00.058852
5931	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:17:00.08204
5932	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:17:00.08204
5933	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:17:00.08204
5934	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:17:00.08204
5935	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:17:00.08204
5936	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:18:00.005457
5937	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:18:00.005457
5938	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:18:00.005457
5939	4	showroom	main_area	10	1	Low	10.00	2026-02-04 09:18:00.005457
5940	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:18:00.005457
5941	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:19:00.257212
5942	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:19:00.257212
5943	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:19:00.257212
5944	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:19:00.257212
5945	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:19:00.257212
5946	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:20:00.05398
5947	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:20:00.05398
5948	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:20:00.05398
5949	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:20:00.05398
5950	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:20:00.05398
5951	2	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:21:00.020327
5952	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:21:00.020327
5953	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:21:00.020327
5954	4	showroom	main_area	10	1	Low	10.00	2026-02-04 09:21:00.020327
5955	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:21:00.020327
5956	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:22:00.006388
5957	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:22:00.006388
5958	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:22:00.006388
5959	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:22:00.006388
5960	4	showroom	main_area	10	1	Low	10.00	2026-02-04 09:22:00.006388
5961	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:23:00.001433
5962	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:23:00.001433
5963	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:23:00.001433
5964	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:23:00.001433
5965	4	showroom	main_area	10	1	Low	10.00	2026-02-04 09:23:00.001433
5966	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:24:00.559075
5967	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:24:00.559075
5968	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:24:00.559075
5969	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:24:00.559075
5970	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-04 09:24:00.559075
5971	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-04 09:25:00.007605
5972	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:25:00.007605
5973	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:25:00.007605
5974	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:25:00.007605
5975	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:25:00.007605
5976	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:26:00.125226
5977	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:26:00.125226
5978	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:26:00.125226
5979	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:26:00.125226
5980	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:26:00.125226
5981	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:27:00.00216
5982	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-04 09:27:00.00216
5983	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:27:00.00216
5984	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:27:00.00216
5985	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:27:00.00216
5986	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:28:00.386205
5987	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-04 09:28:00.386205
5988	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:28:00.386205
5989	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:28:00.386205
5990	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:28:00.386205
5991	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:29:00.026491
5992	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:29:00.026491
5993	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-04 09:29:00.026491
5994	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:29:00.026491
5995	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:29:00.026491
5996	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:30:00.13083
5997	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:30:00.13083
5998	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:30:00.13083
5999	2	robotics_lab	main_area	5	6	Crowded	120.00	2026-02-04 09:30:00.13083
6000	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:30:00.13083
6001	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:31:00.069299
6002	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:31:00.069299
6003	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:31:00.069299
6004	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:31:00.069299
6005	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:31:00.069299
6006	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:32:00.116002
6007	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:32:00.116002
6008	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:32:00.116002
6009	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:32:00.116002
6010	4	showroom	main_area	10	2	Low	20.00	2026-02-04 09:32:00.116002
6011	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:33:00.003033
6012	4	showroom	main_area	10	1	Low	10.00	2026-02-04 09:33:00.003033
6013	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:33:00.003033
6014	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:33:00.003033
6015	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:33:00.003033
6016	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:34:00.078114
6017	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:34:00.078114
6018	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:34:00.078114
6019	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:34:00.078114
6020	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:34:00.078114
6021	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:35:00.124435
6022	1	robotics_lab	main_area	10	2	Low	20.00	2026-02-04 09:35:00.124435
6023	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:35:00.124435
6024	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:35:00.124435
6025	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:35:00.124435
6026	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:36:00.003955
6027	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:36:00.003955
6028	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:36:00.003955
6029	4	showroom	main_area	10	1	Low	10.00	2026-02-04 09:36:00.003955
6030	5	marketing-&-sales	main_area	10	1	Low	10.00	2026-02-04 09:36:00.003955
6031	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:37:00.43424
6032	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:37:00.43424
6033	4	showroom	main_area	10	2	Low	20.00	2026-02-04 09:37:00.43424
6034	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:37:00.43424
6035	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:37:00.43424
6036	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:38:00.103386
6037	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:38:00.103386
6038	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:38:00.103386
6039	4	showroom	main_area	10	1	Low	10.00	2026-02-04 09:38:00.103386
6040	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:38:00.103386
6041	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:39:00.033937
6042	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:39:00.033937
6043	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:39:00.033937
6044	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:39:00.033937
6045	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:39:00.033937
6046	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:40:00.094784
6047	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:40:00.094784
6048	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:40:00.094784
6049	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:40:00.094784
6050	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:40:00.094784
6051	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:41:00.005397
6052	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:41:00.005397
6053	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-04 09:41:00.005397
6054	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:41:00.005397
6055	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:41:00.005397
6056	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:42:00.004753
6057	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-04 09:42:00.004753
6058	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:42:00.004753
6059	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:42:00.004753
6060	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:42:00.004753
6061	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:43:00.126328
6062	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:43:00.126328
6063	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:43:00.126328
6064	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-04 09:43:00.126328
6065	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:43:00.126328
6066	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:44:00.047523
6067	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:44:00.047523
6068	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-04 09:44:00.047523
6069	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:44:00.047523
6070	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-04 09:44:00.047523
6071	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:45:00.122536
6072	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:45:00.122536
6073	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:45:00.122536
6074	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:45:00.122536
6075	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-04 09:45:00.122536
6076	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:46:00.142155
6077	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-04 09:46:00.142155
6078	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:46:00.142155
6079	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:46:00.142155
6080	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:46:00.142155
6081	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:47:00.013653
6082	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:47:00.013653
6083	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:47:00.013653
6084	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:47:00.013653
6085	1	robotics_lab	main_area	10	0	Low	0.00	2026-02-04 09:47:00.013653
6086	5	marketing-&-sales	main_area	10	4	Moderate	40.00	2026-02-04 09:48:00.028608
6087	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-04 09:48:00.028608
6088	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:48:00.028608
6089	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:48:00.028608
6090	3	robotics_lab	main_area	5	1	Low	20.00	2026-02-04 09:48:00.028608
6091	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:49:00.098104
6092	5	marketing-&-sales	main_area	10	3	Low	30.00	2026-02-04 09:49:00.098104
6093	1	robotics_lab	main_area	10	1	Low	10.00	2026-02-04 09:49:00.098104
6094	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:49:00.098104
6095	3	robotics_lab	main_area	5	0	Low	0.00	2026-02-04 09:49:00.098104
6096	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:50:00.055932
6097	3	robotics_lab	main_area	5	2	Moderate	40.00	2026-02-04 09:50:00.055932
6098	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:50:00.055932
6099	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 09:50:00.055932
6100	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:50:00.055932
6101	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 09:51:00.002094
6102	2	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:51:00.002094
6103	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:51:00.002094
6104	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:51:00.002094
6105	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:51:00.002094
6106	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:52:06.239018
6107	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 09:52:06.239018
6108	2	robotics_lab	main_area	5	4	Crowded	80.00	2026-02-04 09:52:06.239018
6109	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:52:06.239018
6110	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:52:06.239018
6111	3	robotics_lab	main_area	5	3	Moderate	60.00	2026-02-04 09:53:00.38861
6112	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:53:00.38861
6113	5	marketing-&-sales	main_area	10	2	Low	20.00	2026-02-04 09:53:00.38861
6114	1	robotics_lab	main_area	10	3	Low	30.00	2026-02-04 09:53:00.38861
6115	2	robotics_lab	main_area	5	5	Crowded	100.00	2026-02-04 09:53:00.38861
6116	2	Robotics lab	main_area	5	4	Crowded	80.00	2026-02-04 09:54:00.008552
6117	3	Robotics lab	main_area	5	3	Moderate	60.00	2026-02-04 09:54:00.008552
6118	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:54:00.008552
6119	5	Internal	main_area	10	2	Low	20.00	2026-02-04 09:54:00.008552
6120	1	Robotics lab	main_area	10	3	Low	30.00	2026-02-04 09:54:00.008552
6121	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:55:00.024125
6122	2	Robotics lab	main_area	5	4	Crowded	80.00	2026-02-04 09:55:00.024125
6123	5	Internal	main_area	10	2	Low	20.00	2026-02-04 09:55:00.024125
6124	1	Robotics lab	main_area	10	2	Low	20.00	2026-02-04 09:55:00.024125
6125	3	Robotics lab	main_area	5	2	Moderate	40.00	2026-02-04 09:55:00.024125
6126	2	Robotics lab	main_area	5	3	Moderate	60.00	2026-02-04 09:56:00.001189
6127	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:56:00.001189
6128	5	Internal	main_area	10	2	Low	20.00	2026-02-04 09:56:00.001189
6129	1	Robotics lab	main_area	10	3	Low	30.00	2026-02-04 09:56:00.001189
6130	3	Robotics lab	main_area	5	2	Moderate	40.00	2026-02-04 09:56:00.001189
6131	2	Robotics lab	main_area	5	4	Crowded	80.00	2026-02-04 09:57:00.109477
6132	3	Robotics lab	main_area	5	2	Moderate	40.00	2026-02-04 09:57:00.109477
6133	5	Internal	main_area	10	2	Low	20.00	2026-02-04 09:57:00.109477
6134	1	Robotics lab	main_area	10	2	Low	20.00	2026-02-04 09:57:00.109477
6135	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:57:00.109477
6136	2	Robotics lab	main_area	5	4	Crowded	80.00	2026-02-04 09:58:00.031694
6137	3	Robotics lab	main_area	5	2	Moderate	40.00	2026-02-04 09:58:00.031694
6138	4	showroom	main_area	10	0	Low	0.00	2026-02-04 09:58:00.031694
6139	5	Internal	main_area	10	3	Low	30.00	2026-02-04 09:58:00.031694
6140	1	Robotics lab	main_area	10	2	Low	20.00	2026-02-04 09:58:00.031694
6141	3	Robotics lab	main_area	5	3	Moderate	60.00	2026-02-04 09:59:00.16463
6142	4	showroom	main_area	10	1	Low	10.00	2026-02-04 09:59:00.16463
6143	5	Internal	main_area	10	3	Low	30.00	2026-02-04 09:59:00.16463
6144	1	Robotics lab	main_area	10	3	Low	30.00	2026-02-04 09:59:00.16463
6145	2	Robotics lab	main_area	5	4	Crowded	80.00	2026-02-04 09:59:00.16463
6146	1	Robotics lab	main_area	10	3	Low	30.00	2026-02-04 10:00:00.113021
6147	2	Robotics lab	main_area	5	4	Crowded	80.00	2026-02-04 10:00:00.113021
6148	3	Robotics lab	main_area	5	3	Moderate	60.00	2026-02-04 10:00:00.113021
6149	4	showroom	main_area	10	1	Low	10.00	2026-02-04 10:00:00.113021
6150	5	Internal	main_area	10	3	Low	30.00	2026-02-04 10:00:00.113021
6151	4	showroom	main_area	10	1	Low	10.00	2026-02-04 10:01:00.026378
6152	2	Robotics lab	main_area	5	4	Crowded	80.00	2026-02-04 10:01:00.026378
6153	5	Internal	main_area	10	4	Moderate	40.00	2026-02-04 10:01:00.026378
6154	3	Robotics lab	main_area	5	3	Moderate	60.00	2026-02-04 10:01:00.026378
6155	1	Robotics lab	main_area	10	3	Low	30.00	2026-02-04 10:01:00.026378
6156	5	Internal	main_area	10	5	Moderate	50.00	2026-02-04 10:02:00.023982
6157	2	Robotics lab	main_area	5	4	Crowded	80.00	2026-02-04 10:02:00.023982
6158	1	Robotics lab	main_area	10	3	Low	30.00	2026-02-04 10:02:00.023982
6159	3	Robotics lab	main_area	5	3	Moderate	60.00	2026-02-04 10:02:00.023982
6160	4	showroom	main_area	10	0	Low	0.00	2026-02-04 10:02:00.023982
6161	1	Robotics lab	main_area	10	3	Low	30.00	2026-02-04 10:03:00.051863
6162	2	Robotics lab	main_area	5	4	Crowded	80.00	2026-02-04 10:03:00.051863
6163	3	Robotics lab	main_area	5	3	Moderate	60.00	2026-02-04 10:03:00.051863
6164	4	showroom	main_area	10	0	Low	0.00	2026-02-04 10:03:00.051863
6165	5	Internal	main_area	10	5	Moderate	50.00	2026-02-04 10:03:00.051863
6166	5	Internal	main_area	10	5	Moderate	50.00	2026-02-04 10:04:00.005885
6167	1	Robotics lab	main_area	10	2	Low	20.00	2026-02-04 10:04:00.005885
6168	2	Robotics lab	main_area	5	4	Crowded	80.00	2026-02-04 10:04:00.005885
6169	3	Robotics lab	main_area	5	2	Moderate	40.00	2026-02-04 10:04:00.005885
6170	4	showroom	main_area	10	1	Low	10.00	2026-02-04 10:04:00.005885
6171	2	Robotics lab	main_area	5	5	Crowded	100.00	2026-02-04 10:05:00.037425
6172	3	Robotics lab	main_area	5	2	Moderate	40.00	2026-02-04 10:05:00.037425
6173	4	showroom	main_area	10	0	Low	0.00	2026-02-04 10:05:00.037425
6174	5	Internal	main_area	10	5	Moderate	50.00	2026-02-04 10:05:00.037425
6175	1	Robotics lab	main_area	10	2	Low	20.00	2026-02-04 10:05:00.037425
6176	3	Robotics lab	main_area	5	2	Moderate	40.00	2026-02-04 10:06:00.035563
6177	4	showroom	main_area	10	0	Low	0.00	2026-02-04 10:06:00.035563
6178	5	Internal	main_area	10	5	Moderate	50.00	2026-02-04 10:06:00.035563
6179	1	Robotics lab	main_area	10	2	Low	20.00	2026-02-04 10:06:00.035563
6180	2	Robotics lab	main_area	5	5	Crowded	100.00	2026-02-04 10:06:00.035563
6181	2	Robotics lab	main_area	5	5	Crowded	100.00	2026-02-04 10:07:00.137424
6182	3	Robotics lab	main_area	5	2	Moderate	40.00	2026-02-04 10:07:00.137424
6183	1	Robotics lab	main_area	10	2	Low	20.00	2026-02-04 10:07:00.137424
6184	4	showroom	main_area	10	0	Low	0.00	2026-02-04 10:07:00.137424
6185	5	Internal	main_area	10	5	Moderate	50.00	2026-02-04 10:07:00.137424
6186	1	Robotics lab	main_area	10	3	Low	30.00	2026-02-04 10:08:00.151837
6187	2	Robotics lab	main_area	5	4	Crowded	80.00	2026-02-04 10:08:00.151837
6188	3	Robotics lab	main_area	5	3	Moderate	60.00	2026-02-04 10:08:00.151837
6189	4	showroom	main_area	10	0	Low	0.00	2026-02-04 10:08:00.151837
6190	5	Internal	main_area	10	4	Moderate	40.00	2026-02-04 10:08:00.151837
6191	4	showroom	main_area	10	0	Low	0.00	2026-02-04 10:09:00.097723
6192	5	Internal	main_area	10	4	Moderate	40.00	2026-02-04 10:09:00.097723
6193	2	Robotics lab	main_area	5	3	Moderate	60.00	2026-02-04 10:09:00.097723
6194	3	Robotics lab	main_area	5	3	Moderate	60.00	2026-02-04 10:09:00.097723
6195	1	Robotics lab	main_area	10	3	Low	30.00	2026-02-04 10:09:00.097723
6196	3	Robotics lab	main_area	5	2	Moderate	40.00	2026-02-04 10:10:00.048168
6197	4	showroom	main_area	10	0	Low	0.00	2026-02-04 10:10:00.048168
6198	1	Robotics lab	main_area	10	2	Low	20.00	2026-02-04 10:10:00.048168
6199	2	Robotics lab	main_area	5	3	Moderate	60.00	2026-02-04 10:10:00.048168
6200	5	Internal	main_area	10	4	Moderate	40.00	2026-02-04 10:10:00.048168
6201	2	Robotics lab	main_area	5	4	Crowded	80.00	2026-02-04 10:11:00.000616
6202	3	Robotics lab	main_area	5	2	Moderate	40.00	2026-02-04 10:11:00.000616
6203	1	Robotics lab	main_area	10	2	Low	20.00	2026-02-04 10:11:00.000616
6204	4	showroom	main_area	10	0	Low	0.00	2026-02-04 10:11:00.000616
6205	5	Internal	main_area	10	4	Moderate	40.00	2026-02-04 10:11:00.000616
6206	1	Robotics lab	main_area	10	3	Low	30.00	2026-02-04 10:12:00.028805
6207	2	Robotics lab	main_area	5	4	Crowded	80.00	2026-02-04 10:12:00.028805
6208	3	Robotics lab	main_area	5	2	Moderate	40.00	2026-02-04 10:12:00.028805
6209	4	showroom	main_area	10	0	Low	0.00	2026-02-04 10:12:00.028805
6210	5	Internal	main_area	10	5	Moderate	50.00	2026-02-04 10:12:00.028805
6211	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 10:13:00.178418
6212	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 10:13:00.178418
6213	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 10:13:00.178418
6214	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 10:13:00.178418
6215	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:13:00.178418
6216	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 10:14:00.093947
6217	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 10:14:00.093947
6218	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 10:14:00.093947
6219	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:14:00.093947
6220	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 10:14:00.093947
6221	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 10:15:00.039957
6222	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 10:15:00.039957
6223	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 10:15:00.039957
6224	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:15:00.039957
6225	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:15:00.039957
6226	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:16:00.142529
6227	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 10:16:00.142529
6228	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:16:00.142529
6229	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 10:16:00.142529
6230	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 10:16:00.142529
6231	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 10:17:00.057212
6232	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:17:00.057212
6233	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 10:17:00.057212
6234	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 10:17:00.057212
6235	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 10:17:00.057212
6236	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 10:18:00.094326
6237	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 10:18:00.094326
6238	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:18:00.094326
6239	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:18:00.094326
6240	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 10:18:00.094326
6241	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 10:19:00.105637
6242	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 10:19:00.105637
6243	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 10:19:00.105637
6244	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-04 10:19:00.105637
6245	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 10:19:00.105637
6246	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 10:20:00.090887
6247	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 10:20:00.090887
6248	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 10:20:00.090887
6249	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 10:20:00.090887
6250	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 10:20:00.090887
6251	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 10:21:00.044526
6252	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 10:21:00.044526
6253	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:21:00.044526
6254	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:21:00.044526
6255	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 10:21:00.044526
6256	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:22:00.009839
6257	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:22:00.009839
6258	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 10:22:00.009839
6259	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 10:22:00.009839
6260	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 10:22:00.009839
6261	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 10:23:00.033117
6262	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:23:00.033117
6263	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:23:00.033117
6264	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 10:23:00.033117
6265	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 10:23:00.033117
6266	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 10:24:00.053047
6267	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 10:24:00.053047
6268	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 10:24:00.053047
6269	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 10:24:00.053047
6270	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:24:00.053047
6271	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:25:00.127871
6272	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 10:25:00.127871
6273	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 10:25:00.127871
6274	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 10:25:00.127871
6275	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 10:25:00.127871
6276	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 10:26:00.178497
6277	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 10:26:00.178497
6278	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 10:26:00.178497
6279	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 10:26:00.178497
6280	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:26:00.178497
6281	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 10:27:00.003304
6282	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 10:27:00.003304
6283	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:27:00.003304
6284	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 10:27:00.003304
6285	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 10:27:00.003304
6286	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 10:28:00.207964
6287	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 10:28:00.207964
6288	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:28:00.207964
6289	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 10:28:00.207964
6290	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 10:28:00.207964
6291	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:29:00.036441
6292	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:29:00.036441
6293	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 10:29:00.036441
6294	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 10:29:00.036441
6295	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 10:29:00.036441
6296	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:30:00.160462
6297	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:30:00.160462
6298	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 10:30:00.160462
6299	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 10:30:00.160462
6300	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 10:30:00.160462
6301	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 10:31:00.020996
6302	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 10:31:00.020996
6303	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:31:00.020996
6304	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 10:31:00.020996
6305	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:31:00.020996
6306	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 10:32:00.005285
6307	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:32:00.005285
6308	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 10:32:00.005285
6309	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:32:00.005285
6310	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 10:32:00.005285
6311	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 10:33:00.251909
6312	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 10:33:00.251909
6313	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 10:33:00.251909
6314	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:33:00.251909
6315	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-04 10:33:00.251909
6316	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:34:00.019922
6317	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-04 10:34:00.019922
6318	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:34:00.019922
6319	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:34:00.019922
6320	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:34:00.019922
6321	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:35:00.033653
6322	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 10:35:00.033653
6323	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:35:00.033653
6324	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:35:00.033653
6325	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-04 10:35:00.033653
6326	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-04 10:36:00.131985
6327	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:36:00.131985
6328	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:36:00.131985
6329	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:36:00.131985
6330	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:36:00.131985
6331	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 10:37:00.125716
6332	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:37:00.125716
6333	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-04 10:37:00.125716
6334	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:37:00.125716
6335	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 10:37:00.125716
6336	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:38:00.088386
6337	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:38:00.088386
6338	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:38:00.088386
6339	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:38:00.088386
6340	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:38:00.088386
6341	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:39:00.042418
6342	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:39:00.042418
6343	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 10:39:00.042418
6344	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:39:00.042418
6345	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 10:39:00.042418
6346	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 10:40:00.039087
6347	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:40:00.039087
6348	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-04 10:40:00.039087
6349	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 10:40:00.039087
6350	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 10:40:00.039087
6351	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 10:41:00.005882
6352	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:41:00.005882
6353	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:41:00.005882
6354	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-04 10:41:00.005882
6355	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 10:41:00.005882
6356	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:42:00.078933
6357	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:42:00.078933
6358	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 10:42:00.078933
6359	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-04 10:42:00.078933
6360	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 10:42:00.078933
6361	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:43:00.022571
6362	5	Ex- Barista Robot	main_area	10	8	Crowded	80.00	2026-02-04 10:43:00.022571
6363	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:43:00.022571
6364	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:43:00.022571
6365	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:43:00.022571
6366	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 10:44:00.382803
6367	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:44:00.382803
6368	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:44:00.382803
6369	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:44:00.382803
6370	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-04 10:44:00.382803
6371	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:45:00.044099
6372	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 10:45:00.044099
6373	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:45:00.044099
6374	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:45:00.044099
6375	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-04 10:45:00.044099
6376	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:46:00.003873
6377	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-04 10:46:00.003873
6378	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:46:00.003873
6379	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 10:46:00.003873
6380	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:46:00.003873
6381	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:47:00.119961
6382	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:47:00.119961
6383	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:47:00.119961
6384	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-04 10:47:00.119961
6385	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:47:00.119961
6386	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:48:00.003269
6387	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-04 10:48:00.003269
6388	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:48:00.003269
6389	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:48:00.003269
6390	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:48:00.003269
6391	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:49:00.052083
6392	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:49:00.052083
6393	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:49:00.052083
6394	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 10:49:00.052083
6395	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:49:00.052083
6396	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-04 10:50:00.032373
6397	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:50:00.032373
6398	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 10:50:00.032373
6399	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:50:00.032373
6400	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:50:00.032373
6401	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:51:00.047488
6402	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 10:51:00.047488
6403	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:51:00.047488
6404	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:51:00.047488
6405	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:51:00.047488
6406	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:52:00.132907
6407	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:52:00.132907
6408	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:52:00.132907
6409	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:52:00.132907
6410	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:52:00.132907
6411	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:53:00.14437
6412	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:53:00.14437
6413	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:53:00.14437
6414	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:53:00.14437
6415	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:53:00.14437
6416	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:54:00.210447
6417	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:54:00.210447
6418	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:54:00.210447
6419	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:54:00.210447
6420	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:54:00.210447
6421	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:55:00.00454
6422	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:55:00.00454
6423	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:55:00.00454
6424	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:55:00.00454
6425	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:55:00.00454
6426	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:56:00.081067
6427	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 10:56:00.081067
6428	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 10:56:00.081067
6429	4	Ex- Drones	main_area	10	4	Moderate	40.00	2026-02-04 10:56:00.081067
6430	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:56:00.081067
6431	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:57:00.019125
6432	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:57:00.019125
6433	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:57:00.019125
6434	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 10:57:00.019125
6435	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 10:57:00.019125
6436	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:58:00.113348
6437	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 10:58:00.113348
6438	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 10:58:00.113348
6439	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 10:58:00.113348
6440	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 10:58:00.113348
6441	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 10:59:00.038506
6442	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 10:59:00.038506
6443	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 10:59:00.038506
6444	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 10:59:00.038506
6445	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 10:59:00.038506
6446	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 11:00:00.076039
6447	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 11:00:00.076039
6448	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 11:00:00.076039
6449	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 11:00:00.076039
6450	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:00:00.076039
6451	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:01:00.014902
6452	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 11:01:00.014902
6453	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:01:00.014902
6454	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:01:00.014902
6455	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 11:01:00.014902
6456	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:02:00.005369
6457	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 11:02:00.005369
6458	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:02:00.005369
6459	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 11:02:00.005369
6460	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:02:00.005369
6461	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 11:03:00.041449
6462	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:03:00.041449
6463	4	Ex- Drones	main_area	10	4	Moderate	40.00	2026-02-04 11:03:00.041449
6464	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:03:00.041449
6465	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:03:00.041449
6466	4	Ex- Drones	main_area	10	4	Moderate	40.00	2026-02-04 11:04:00.061718
6467	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:04:00.061718
6468	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:04:00.061718
6469	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 11:04:00.061718
6470	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:04:00.061718
6471	4	Ex- Drones	main_area	10	4	Moderate	40.00	2026-02-04 11:05:00.018819
6472	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:05:00.018819
6473	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 11:05:00.018819
6474	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 11:05:00.018819
6475	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 11:05:00.018819
6476	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:06:00.632467
6477	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 11:06:00.632467
6478	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:06:00.632467
6479	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:06:00.632467
6480	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 11:06:00.632467
6481	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 11:07:00.025301
6482	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 11:07:00.025301
6483	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:07:00.025301
6484	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:07:00.025301
6485	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:07:00.025301
6486	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-04 11:08:00.022268
6487	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:08:00.022268
6488	4	Ex- Drones	main_area	10	4	Moderate	40.00	2026-02-04 11:08:00.022268
6489	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:08:00.022268
6490	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 11:08:00.022268
6491	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-04 11:09:00.053939
6492	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 11:09:00.053939
6493	4	Ex- Drones	main_area	10	4	Moderate	40.00	2026-02-04 11:09:00.053939
6494	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:09:00.053939
6495	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 11:09:00.053939
6496	4	Ex- Drones	main_area	10	4	Moderate	40.00	2026-02-04 11:10:00.083458
6497	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:10:00.083458
6498	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 11:10:00.083458
6499	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-04 11:10:00.083458
6500	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 11:10:00.083458
6501	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:11:00.112019
6502	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 11:11:00.112019
6503	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:11:00.112019
6504	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 11:11:00.112019
6505	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:11:00.112019
6506	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 11:12:00.11075
6507	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:12:00.11075
6508	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 11:12:00.11075
6509	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-04 11:12:00.11075
6510	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 11:12:00.11075
6511	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 11:13:00.183562
6512	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 11:13:00.183562
6513	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:13:00.183562
6514	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:13:00.183562
6515	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 11:13:00.183562
6516	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 11:14:01.009095
6517	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 11:14:01.009095
6518	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 11:14:01.009095
6519	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 11:14:01.009095
6520	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:14:01.009095
6521	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:15:00.001465
6522	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:15:00.001465
6523	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-04 11:15:00.001465
6524	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:15:00.001465
6525	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 11:15:00.001465
6526	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 11:16:00.006037
6527	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:16:00.006037
6528	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 11:16:00.006037
6529	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:16:00.006037
6530	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:16:00.006037
6531	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 11:17:00.001823
6532	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 11:17:00.001823
6533	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:17:00.001823
6534	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 11:17:00.001823
6535	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 11:17:00.001823
6536	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 11:18:00.44651
6537	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 11:18:00.44651
6538	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 11:18:00.44651
6539	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 11:18:00.44651
6540	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:18:00.44651
6541	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:19:27.91229
6542	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 11:19:27.91229
6543	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 11:19:27.91229
6544	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:19:27.91229
6545	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 11:19:27.91229
6546	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:20:42.074162
6547	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 11:20:42.074162
6548	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 11:20:42.074162
6549	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 11:20:42.074162
6550	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 11:21:03.513673
6551	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 11:21:03.513673
6552	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 11:21:03.513673
6553	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:21:03.513673
6554	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 11:24:00.005315
6555	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 11:24:00.005315
6556	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 11:24:00.005315
6557	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:24:00.005315
6558	2	In - V-BAT aircraft	main_area	5	8	Crowded	160.00	2026-02-04 11:24:00.005315
6559	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 11:40:00.096263
6560	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 11:40:00.096263
6561	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 11:40:00.096263
6562	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:40:00.096263
6563	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:40:00.096263
6564	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:41:00.175081
6565	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 11:41:00.175081
6566	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 11:41:00.175081
6567	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 11:41:00.175081
6568	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:41:00.175081
6569	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:42:00.009091
6570	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 11:42:00.009091
6571	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 11:42:00.009091
6572	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 11:42:00.009091
6573	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:42:00.009091
6574	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 11:43:00.08764
6575	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 11:43:00.08764
6576	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 11:43:00.08764
6577	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:43:00.08764
6578	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 11:43:00.08764
6579	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 11:44:00.055784
6580	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 11:44:00.055784
6581	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 11:44:00.055784
6582	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 11:44:00.055784
6583	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:44:00.055784
6584	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 11:45:00.143389
6585	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:45:00.143389
6586	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 11:45:00.143389
6587	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:45:00.143389
6588	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 11:45:00.143389
6589	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 11:46:00.027584
6590	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:46:00.027584
6591	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 11:46:00.027584
6592	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:46:00.027584
6593	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:46:00.027584
6594	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:47:00.014904
6595	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 11:47:00.014904
6596	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:47:00.014904
6597	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 11:47:00.014904
6598	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:47:00.014904
6599	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:48:00.002586
6600	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 11:48:00.002586
6601	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:48:00.002586
6602	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:48:00.002586
6603	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:48:00.002586
6604	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 11:49:00.189662
6605	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:49:00.189662
6606	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 11:49:00.189662
6607	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 11:49:00.189662
6608	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 11:49:00.189662
6609	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 11:50:00.044345
6610	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 11:50:00.044345
6611	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:50:00.044345
6612	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 11:50:00.044345
6613	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 11:50:00.044345
6614	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:51:00.025554
6615	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:51:00.025554
6616	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:51:00.025554
6617	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 11:51:00.025554
6618	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 11:51:00.025554
6619	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 11:52:00.093177
6620	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:52:00.093177
6621	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 11:52:00.093177
6622	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:52:00.093177
6623	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 11:52:00.093177
6624	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:53:00.122027
6625	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:53:00.122027
6626	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:53:00.122027
6627	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 11:53:00.122027
6628	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:53:00.122027
6629	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 11:54:00.090548
6630	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:54:00.090548
6631	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:54:00.090548
6632	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 11:54:00.090548
6633	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:54:00.090548
6634	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:55:00.080107
6635	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 11:55:00.080107
6636	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:55:00.080107
6637	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-04 11:55:00.080107
6638	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 11:55:00.080107
6639	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:56:00.11179
6640	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 11:56:00.11179
6641	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 11:56:00.11179
6642	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:56:00.11179
6643	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-04 11:56:00.11179
6644	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 11:57:00.018961
6645	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 11:57:00.018961
6646	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:57:00.018961
6647	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 11:57:00.018961
6648	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 11:57:00.018961
6649	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:58:00.010764
6650	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:58:00.010764
6651	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 11:58:00.010764
6652	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 11:58:00.010764
6653	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 11:58:00.010764
6654	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 11:59:00.103424
6655	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 11:59:00.103424
6656	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 11:59:00.103424
6657	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 11:59:00.103424
6658	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 11:59:00.103424
6659	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:00:00.011787
6660	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 12:00:00.011787
6661	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-04 12:00:00.011787
6662	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 12:00:00.011787
6663	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 12:00:00.011787
6664	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 12:01:00.029028
6665	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-04 12:01:00.029028
6666	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:01:00.029028
6667	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:01:00.029028
6668	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 12:01:00.029028
6669	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:02:00.006548
6670	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:02:00.006548
6671	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 12:02:00.006548
6672	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 12:02:00.006548
6673	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:02:00.006548
6674	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 12:03:00.001228
6675	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 12:03:00.001228
6676	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:03:00.001228
6677	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 12:03:00.001228
6678	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:03:00.001228
6679	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 12:04:00.016753
6680	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:04:00.016753
6681	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:04:00.016753
6682	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 12:04:00.016753
6683	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 12:04:00.016753
6684	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 12:05:00.068798
6685	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 12:05:00.068798
6686	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:05:00.068798
6687	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:05:00.068798
6688	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:05:00.068798
6689	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:06:00.003631
6690	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 12:06:00.003631
6691	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 12:06:00.003631
6692	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:06:00.003631
6693	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 12:06:00.003631
6694	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:07:00.03168
6695	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:07:00.03168
6696	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:07:00.03168
6697	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 12:07:00.03168
6698	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:07:00.03168
6699	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:08:00.103387
6700	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:08:00.103387
6701	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:08:00.103387
6702	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 12:08:00.103387
6703	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 12:08:00.103387
6704	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:09:00.020941
6705	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:09:00.020941
6706	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 12:09:00.020941
6707	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:09:00.020941
6708	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:09:00.020941
6709	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 12:10:00.049792
6710	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:10:00.049792
6711	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:10:00.049792
6712	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:10:00.049792
6713	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 12:10:00.049792
6714	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:11:00.007781
6715	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 12:11:00.007781
6716	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:11:00.007781
6717	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 12:11:00.007781
6718	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:11:00.007781
6719	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 12:12:00.052598
6720	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 12:12:00.052598
6721	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:12:00.052598
6722	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:12:00.052598
6723	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:12:00.052598
6724	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:13:00.017033
6725	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 12:13:00.017033
6726	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 12:13:00.017033
6727	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 12:13:00.017033
6728	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:13:00.017033
6729	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:14:00.090269
6730	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:14:00.090269
6731	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:14:00.090269
6732	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:14:00.090269
6733	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 12:14:00.090269
6734	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:15:00.103548
6735	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:15:00.103548
6736	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:15:00.103548
6737	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 12:15:00.103548
6738	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:15:00.103548
6739	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 12:16:00.079441
6740	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:16:00.079441
6741	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 12:16:00.079441
6742	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:16:00.079441
6743	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:16:00.079441
6744	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:17:00.155157
6745	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-04 12:17:00.155157
6746	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:17:00.155157
6747	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:17:00.155157
6748	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 12:17:00.155157
6749	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:18:00.039607
6750	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 12:18:00.039607
6751	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:18:00.039607
6752	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:18:00.039607
6753	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 12:18:00.039607
6754	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 12:19:00.004861
6755	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:19:00.004861
6756	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 12:19:00.004861
6757	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:19:00.004861
6758	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:19:00.004861
6759	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 12:20:00.116268
6760	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:20:00.116268
6761	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:20:00.116268
6762	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:20:00.116268
6763	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 12:20:00.116268
6764	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:21:00.03764
6765	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 12:21:00.03764
6766	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:21:00.03764
6767	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 12:21:00.03764
6768	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:21:00.03764
6769	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:22:00.074691
6770	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:22:00.074691
6771	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 12:22:00.074691
6772	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:22:00.074691
6773	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:22:00.074691
6774	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:23:00.092813
6775	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 12:23:00.092813
6776	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:23:00.092813
6777	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:23:00.092813
6778	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 12:23:00.092813
6779	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:24:00.055626
6780	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 12:24:00.055626
6781	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:24:00.055626
6782	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:24:00.055626
6783	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 12:24:00.055626
6784	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 12:25:00.004077
6785	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:25:00.004077
6786	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:25:00.004077
6787	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 12:25:00.004077
6788	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:25:00.004077
6789	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:26:00.005589
6790	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:26:00.005589
6791	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 12:26:00.005589
6792	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:26:00.005589
6793	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 12:26:00.005589
6794	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:27:00.029812
6795	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:27:00.029812
6796	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 12:27:00.029812
6797	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 12:27:00.029812
6798	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 12:27:00.029812
6799	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 12:28:00.027539
6800	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 12:28:00.027539
6801	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 12:28:00.027539
6802	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:28:00.027539
6803	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:28:00.027539
6804	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 12:29:00.125941
6805	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:29:00.125941
6806	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 12:29:00.125941
6807	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:29:00.125941
6808	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:29:00.125941
6809	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:30:00.228227
6810	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:30:00.228227
6811	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 12:30:00.228227
6812	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:30:00.228227
6813	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:30:00.228227
6814	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:31:00.012818
6815	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:31:00.012818
6816	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:31:00.012818
6817	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:31:00.012818
6818	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 12:31:00.012818
6819	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:32:00.004241
6820	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:32:00.004241
6821	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:32:00.004241
6822	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 12:32:00.004241
6823	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:32:00.004241
6824	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 12:33:00.023015
6825	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:33:00.023015
6826	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:33:00.023015
6827	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 12:33:00.023015
6828	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:33:00.023015
6829	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:34:00.087433
6830	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:34:00.087433
6831	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:34:00.087433
6832	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:34:00.087433
6833	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:34:00.087433
6834	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:35:00.009366
6835	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 12:35:00.009366
6836	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 12:35:00.009366
6837	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:35:00.009366
6838	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 12:35:00.009366
6839	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:36:00.160083
6840	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:36:00.160083
6841	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 12:36:00.160083
6842	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 12:36:00.160083
6843	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:36:00.160083
6844	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:37:00.082234
6845	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:37:00.082234
6846	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 12:37:00.082234
6847	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:37:00.082234
6848	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 12:37:00.082234
6849	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:38:00.046449
6850	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 12:38:00.046449
6851	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:38:00.046449
6852	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:38:00.046449
6853	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 12:38:00.046449
6854	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:39:00.139489
6855	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 12:39:00.139489
6856	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:39:00.139489
6857	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:39:00.139489
6858	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:39:00.139489
6859	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:40:00.120157
6860	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:40:00.120157
6861	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:40:00.120157
6862	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:40:00.120157
6863	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 12:40:00.120157
6864	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:41:00.013715
6865	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 12:41:00.013715
6866	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 12:41:00.013715
6867	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:41:00.013715
6868	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 12:41:00.013715
6869	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:43:00.036372
6870	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:43:00.036372
6871	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:43:00.036372
6872	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 12:43:00.036372
6873	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-04 12:43:00.036372
6874	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:44:00.000423
6875	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:44:00.000423
6876	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 12:44:00.000423
6877	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:44:00.000423
6878	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-04 12:44:00.000423
6879	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 12:45:00.000501
6880	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-04 12:45:00.000501
6881	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:45:00.000501
6882	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:45:00.000501
6883	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:45:00.000501
6884	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:46:00.029322
6885	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:46:00.029322
6886	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:46:00.029322
6887	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 12:46:00.029322
6888	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 12:46:00.029322
6889	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:47:00.028672
6890	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:47:00.028672
6891	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:47:00.028672
6892	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:47:00.028672
6893	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 12:47:00.028672
6894	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:48:00.040085
6895	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:48:00.040085
6896	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:48:00.040085
6897	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 12:48:00.040085
6898	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 12:48:00.040085
6899	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:49:00.060674
6900	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:49:00.060674
6901	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 12:49:00.060674
6902	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:49:00.060674
6903	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:49:00.060674
6904	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:50:00.025925
6905	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:50:00.025925
6906	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:50:00.025925
6907	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:50:00.025925
6908	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:50:00.025925
6909	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 12:51:00.054371
6910	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:51:00.054371
6911	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:51:00.054371
6912	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:51:00.054371
6913	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 12:51:00.054371
6914	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:52:00.017165
6915	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:52:00.017165
6916	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:52:00.017165
6917	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 12:52:00.017165
6918	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 12:52:00.017165
6919	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:53:00.04917
6920	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:53:00.04917
6921	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:53:00.04917
6922	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:53:00.04917
6923	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 12:53:00.04917
6924	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:54:00.002978
6925	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 12:54:00.002978
6926	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:54:00.002978
6927	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:54:00.002978
6928	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:54:00.002978
6929	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 12:55:00.039519
6930	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 12:55:00.039519
6931	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:55:00.039519
6932	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:55:00.039519
6933	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:55:00.039519
6934	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 12:56:00.016079
6935	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 12:56:00.016079
6936	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 12:56:00.016079
6937	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:56:00.016079
6938	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:56:00.016079
6939	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:57:00.021677
6940	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 12:57:00.021677
6941	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 12:57:00.021677
6942	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 12:57:00.021677
6943	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 12:57:00.021677
6944	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:58:00.013479
6945	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 12:58:00.013479
6946	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 12:58:00.013479
6947	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:58:00.013479
6948	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 12:58:00.013479
6949	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 12:59:00.058412
6950	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 12:59:00.058412
6951	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 12:59:00.058412
6952	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 12:59:00.058412
6953	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 12:59:00.058412
6954	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 13:00:00.061427
6955	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 13:00:00.061427
6956	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 13:00:00.061427
6957	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:00:00.061427
6958	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:00:00.061427
6959	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:01:00.011598
6960	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:01:00.011598
6961	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 13:01:00.011598
6962	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 13:01:00.011598
6963	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:01:00.011598
6964	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:02:00.110816
6965	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 13:02:00.110816
6966	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:02:00.110816
6967	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 13:02:00.110816
6968	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:02:00.110816
6969	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 13:03:00.032687
6970	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 13:03:00.032687
6971	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:03:00.032687
6972	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 13:03:00.032687
6973	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:03:00.032687
6974	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 13:04:00.005683
6975	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 13:04:00.005683
6976	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:04:00.005683
6977	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:04:00.005683
6978	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 13:04:00.005683
6979	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:05:00.104485
6980	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 13:05:00.104485
6981	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 13:05:00.104485
6982	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:05:00.104485
6983	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 13:05:00.104485
6984	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:06:00.048108
6985	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 13:06:00.048108
6986	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 13:06:00.048108
6987	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 13:06:00.048108
6988	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:06:00.048108
6989	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:07:00.004137
6990	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:07:00.004137
6991	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 13:07:00.004137
6992	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:07:00.004137
6993	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 13:07:00.004137
6994	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 13:08:00.003818
6995	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:08:00.003818
6996	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:08:00.003818
6997	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:08:00.003818
6998	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 13:08:00.003818
6999	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 13:09:00.003382
7000	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:09:00.003382
7001	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 13:09:00.003382
7002	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:09:00.003382
7003	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:09:00.003382
7004	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:10:00.012741
7005	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:10:00.012741
7006	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:10:00.012741
7007	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 13:10:00.012741
7008	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 13:10:00.012741
7009	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:11:00.057065
7010	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:11:00.057065
7011	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 13:11:00.057065
7012	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:11:00.057065
7013	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 13:11:00.057065
7014	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-04 13:12:00.025528
7015	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:12:00.025528
7016	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:12:00.025528
7017	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 13:12:00.025528
7018	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:12:00.025528
7019	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 13:13:00.030341
7020	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:13:00.030341
7021	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 13:13:00.030341
7022	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:13:00.030341
7023	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:13:00.030341
7024	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:14:00.072449
7025	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 13:14:00.072449
7026	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:14:00.072449
7027	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 13:14:00.072449
7028	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:14:00.072449
7029	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:15:00.07615
7030	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:15:00.07615
7031	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 13:15:00.07615
7032	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 13:15:00.07615
7033	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:15:00.07615
7034	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:16:00.109331
7035	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 13:16:00.109331
7036	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 13:16:00.109331
7037	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:16:00.109331
7038	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:16:00.109331
7039	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:17:00.038947
7040	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:17:00.038947
7041	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:17:00.038947
7042	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 13:17:00.038947
7043	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:17:00.038947
7044	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:18:00.07012
7045	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:18:00.07012
7046	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 13:18:00.07012
7047	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:18:00.07012
7048	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:18:00.07012
7049	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:19:00.019246
7050	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:19:00.019246
7051	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:19:00.019246
7052	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 13:19:00.019246
7053	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:19:00.019246
7054	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:20:00.086295
7055	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:20:00.086295
7056	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 13:20:00.086295
7057	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:20:00.086295
7058	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:20:00.086295
7059	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:21:00.056252
7060	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:21:00.056252
7061	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 13:21:00.056252
7062	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:21:00.056252
7063	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 13:21:00.056252
7064	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:22:00.019596
7065	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:22:00.019596
7066	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 13:22:00.019596
7067	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:22:00.019596
7068	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:22:00.019596
7069	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:23:00.014338
7070	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 13:23:00.014338
7071	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:23:00.014338
7072	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 13:23:00.014338
7073	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:23:00.014338
7074	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:24:00.079508
7075	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:24:00.079508
7076	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 13:24:00.079508
7077	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 13:24:00.079508
7078	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:24:00.079508
7079	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 13:25:00.033169
7080	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:25:00.033169
7081	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:25:00.033169
7082	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 13:25:00.033169
7083	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:25:00.033169
7084	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:26:00.001525
7085	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:26:00.001525
7086	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 13:26:00.001525
7087	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 13:26:00.001525
7088	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:26:00.001525
7089	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 13:27:00.053144
7090	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:27:00.053144
7091	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:27:00.053144
7092	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 13:27:00.053144
7093	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:27:00.053144
7094	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:28:00.052626
7095	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 13:28:00.052626
7096	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:28:00.052626
7097	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:28:00.052626
7098	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:28:00.052626
7099	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 13:29:00.003731
7100	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:29:00.003731
7101	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 13:29:00.003731
7102	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:29:00.003731
7103	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:29:00.003731
7104	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 13:30:00.059685
7105	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 13:30:00.059685
7106	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:30:00.059685
7107	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:30:00.059685
7108	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:30:00.059685
7109	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 13:31:00.045276
7110	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 13:31:00.045276
7111	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:31:00.045276
7112	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:31:00.045276
7113	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:31:00.045276
7114	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:32:00.036895
7115	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:32:00.036895
7116	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:32:00.036895
7117	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:32:00.036895
7118	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:32:00.036895
7119	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:33:00.059094
7120	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:33:00.059094
7121	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 13:33:00.059094
7122	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:33:00.059094
7123	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:33:00.059094
7124	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:34:00.006084
7125	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:34:00.006084
7126	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:34:00.006084
7127	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 13:34:00.006084
7128	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:34:00.006084
7129	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:35:00.001455
7130	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:35:00.001455
7131	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:35:00.001455
7132	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 13:35:00.001455
7133	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 13:35:00.001455
7134	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:36:00.045384
7135	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:36:00.045384
7136	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:36:00.045384
7137	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:36:00.045384
7138	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:36:00.045384
7139	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:37:00.001567
7140	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:37:00.001567
7141	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:37:00.001567
7142	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:37:00.001567
7143	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:37:00.001567
7144	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 13:38:00.041208
7145	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:38:00.041208
7146	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:38:00.041208
7147	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:38:00.041208
7148	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:38:00.041208
7149	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:39:00.006224
7150	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:39:00.006224
7151	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:39:00.006224
7152	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:39:00.006224
7153	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:39:00.006224
7154	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 13:40:00.040801
7155	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:40:00.040801
7156	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:40:00.040801
7157	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 13:40:00.040801
7158	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 13:40:00.040801
7159	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:41:00.014726
7160	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 13:41:00.014726
7161	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:41:00.014726
7162	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:41:00.014726
7163	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:41:00.014726
7164	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:42:00.030718
7165	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:42:00.030718
7166	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:42:00.030718
7167	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:42:00.030718
7168	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:42:00.030718
7169	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:43:00.047996
7170	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:43:00.047996
7171	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 13:43:00.047996
7172	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:43:00.047996
7173	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:43:00.047996
7174	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:44:00.011418
7175	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:44:00.011418
7176	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:44:00.011418
7177	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:44:00.011418
7178	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:44:00.011418
7179	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:45:00.006669
7180	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:45:00.006669
7181	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 13:45:00.006669
7182	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:45:00.006669
7183	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 13:45:00.006669
7184	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:46:00.038461
7185	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:46:00.038461
7186	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:46:00.038461
7187	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 13:46:00.038461
7188	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:46:00.038461
7189	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 13:47:00.067938
7190	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:47:00.067938
7191	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 13:47:00.067938
7192	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:47:00.067938
7193	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:47:00.067938
7194	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:48:00.00437
7195	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:48:00.00437
7196	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:48:00.00437
7197	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:48:00.00437
7198	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:48:00.00437
7199	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:49:00.037076
7200	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:49:00.037076
7201	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:49:00.037076
7202	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:49:00.037076
7203	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:49:00.037076
7204	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:50:00.002742
7205	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:50:00.002742
7206	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:50:00.002742
7207	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:50:00.002742
7208	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 13:50:00.002742
7209	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 13:51:00.035684
7210	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 13:51:00.035684
7211	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 13:51:00.035684
7212	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:51:00.035684
7213	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:51:00.035684
7214	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:52:00.078909
7215	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 13:52:00.078909
7216	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 13:52:00.078909
7217	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:52:00.078909
7218	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:52:00.078909
7219	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 13:53:00.025177
7220	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:53:00.025177
7221	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 13:53:00.025177
7222	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:53:00.025177
7223	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:53:00.025177
7224	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 13:54:00.006097
7225	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:54:00.006097
7226	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 13:54:00.006097
7227	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:54:00.006097
7228	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:54:00.006097
7229	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 13:55:00.02702
7230	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:55:00.02702
7231	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 13:55:00.02702
7232	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:55:00.02702
7233	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:55:00.02702
7234	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 13:56:00.046858
7235	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:56:00.046858
7236	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:56:00.046858
7237	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 13:56:00.046858
7238	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-04 13:56:00.046858
7239	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 13:57:00.004212
7240	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:57:00.004212
7241	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 13:57:00.004212
7242	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:57:00.004212
7243	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:57:00.004212
7244	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 13:58:00.022961
7245	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:58:00.022961
7246	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 13:58:00.022961
7247	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 13:58:00.022961
7248	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 13:58:00.022961
7249	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 13:59:00.012352
7250	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 13:59:00.012352
7251	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 13:59:00.012352
7252	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 13:59:00.012352
7253	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 13:59:00.012352
7254	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:00:00.011187
7255	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:00:00.011187
7256	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:00:00.011187
7257	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 14:00:00.011187
7258	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:00:00.011187
7259	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:01:00.055509
7260	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:01:00.055509
7261	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:01:00.055509
7262	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:01:00.055509
7263	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:01:00.055509
7264	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:02:00.061758
7265	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:02:00.061758
7266	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:02:00.061758
7267	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:02:00.061758
7268	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:02:00.061758
7269	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:03:00.001974
7270	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:03:00.001974
7271	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:03:00.001974
7272	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:03:00.001974
7273	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:03:00.001974
7274	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:04:00.062255
7275	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:04:00.062255
7276	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:04:00.062255
7277	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 14:04:00.062255
7278	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 14:04:00.062255
7279	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:05:00.010829
7280	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:05:00.010829
7281	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:05:00.010829
7282	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 14:05:00.010829
7283	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:05:00.010829
7284	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:06:00.051639
7285	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:06:00.051639
7286	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 14:06:00.051639
7287	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:06:00.051639
7288	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:06:00.051639
7289	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:07:00.024907
7290	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:07:00.024907
7291	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:07:00.024907
7292	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:07:00.024907
7293	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:07:00.024907
7294	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:08:00.009328
7295	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:08:00.009328
7296	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:08:00.009328
7297	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:08:00.009328
7298	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:08:00.009328
7299	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:09:00.00137
7300	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:09:00.00137
7301	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:09:00.00137
7302	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:09:00.00137
7303	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:09:00.00137
7304	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:10:00.027118
7305	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:10:00.027118
7306	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:10:00.027118
7307	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 14:10:00.027118
7308	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:10:00.027118
7309	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:11:00.020605
7310	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:11:00.020605
7311	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:11:00.020605
7312	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:11:00.020605
7313	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:11:00.020605
7314	1	Ex - FlyNow	main_area	10	5	Moderate	50.00	2026-02-04 14:12:00.024312
7315	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:12:00.024312
7316	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:12:00.024312
7317	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 14:12:00.024312
7318	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:12:00.024312
7319	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 14:13:00.08801
7320	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:13:00.08801
7321	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 14:13:00.08801
7322	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:13:00.08801
7323	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:13:00.08801
7324	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 14:14:00.040506
7325	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:14:00.040506
7326	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:14:00.040506
7327	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 14:14:00.040506
7328	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:14:00.040506
7329	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 14:15:00.047214
7330	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:15:00.047214
7331	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 14:15:00.047214
7332	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 14:15:00.047214
7333	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:15:00.047214
7334	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 14:16:00.004175
7335	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:16:00.004175
7336	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:16:00.004175
7337	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 14:16:00.004175
7338	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:16:00.004175
7339	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:17:00.052947
7340	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 14:17:00.052947
7341	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 14:17:00.052947
7342	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:17:00.052947
7343	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:17:00.052947
7344	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:18:00.009296
7345	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:18:00.009296
7346	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:18:00.009296
7347	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:18:00.009296
7348	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 14:18:00.009296
7349	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:19:00.057567
7350	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 14:19:00.057567
7351	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:19:00.057567
7352	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 14:19:00.057567
7353	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:19:00.057567
7354	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:20:00.019775
7355	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 14:20:00.019775
7356	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 14:20:00.019775
7357	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:20:00.019775
7358	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 14:20:00.019775
7359	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:21:00.061355
7360	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 14:21:00.061355
7361	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 14:21:00.061355
7362	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 14:21:00.061355
7363	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 14:21:00.061355
7364	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-04 14:22:00.04068
7365	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 14:22:00.04068
7366	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:22:00.04068
7367	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:22:00.04068
7368	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 14:22:00.04068
7369	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 14:23:00.018466
7370	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:23:00.018466
7371	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 14:23:00.018466
7372	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 14:23:00.018466
7373	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 14:23:00.018466
7374	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:24:00.02839
7375	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-04 14:24:00.02839
7376	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 14:24:00.02839
7377	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 14:24:00.02839
7378	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:24:00.02839
7379	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 14:25:00.025629
7380	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:25:00.025629
7381	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 14:25:00.025629
7382	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 14:25:00.025629
7383	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:25:00.025629
7384	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 14:26:01.912153
7385	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 14:26:01.912153
7386	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 14:26:01.912153
7387	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 14:26:01.912153
7388	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 14:26:01.912153
7389	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 14:27:00.004816
7390	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 14:27:00.004816
7391	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 14:27:00.004816
7392	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:27:00.004816
7393	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 14:27:00.004816
7394	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:28:00.021084
7395	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 14:28:00.021084
7396	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:28:00.021084
7397	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 14:28:00.021084
7398	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:28:00.021084
7399	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 14:29:00.121506
7400	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 14:29:00.121506
7401	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 14:29:00.121506
7402	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 14:29:00.121506
7403	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:29:00.121506
7404	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:30:00.010775
7405	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:30:00.010775
7406	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:30:00.010775
7407	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 14:30:00.010775
7408	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 14:30:00.010775
7409	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 14:31:00.076016
7410	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:31:00.076016
7411	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:31:00.076016
7412	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 14:31:00.076016
7413	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:31:00.076016
7414	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 14:32:00.03279
7415	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:32:00.03279
7416	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 14:32:00.03279
7417	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:32:00.03279
7418	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:32:00.03279
7419	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:33:00.009034
7420	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 14:33:00.009034
7421	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 14:33:00.009034
7422	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 14:33:00.009034
7423	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:33:00.009034
7424	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 14:34:00.078204
7425	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:34:00.078204
7426	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 14:34:00.078204
7427	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:34:00.078204
7428	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 14:34:00.078204
7429	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 14:35:00.058577
7430	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 14:35:00.058577
7431	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 14:35:00.058577
7432	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:35:00.058577
7433	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:35:00.058577
7434	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:36:00.034062
7435	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 14:36:00.034062
7436	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-04 14:36:00.034062
7437	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 14:36:00.034062
7438	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:36:00.034062
7439	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:37:00.021739
7440	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 14:37:00.021739
7441	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:37:00.021739
7442	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:37:00.021739
7443	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 14:37:00.021739
7444	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:38:00.032877
7445	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 14:38:00.032877
7446	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:38:00.032877
7447	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:38:00.032877
7448	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 14:38:00.032877
7449	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 14:39:00.065387
7450	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:39:00.065387
7451	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:39:00.065387
7452	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 14:39:00.065387
7453	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:39:00.065387
7454	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:40:00.000682
7455	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:40:00.000682
7456	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:40:00.000682
7457	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:40:00.000682
7458	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:40:00.000682
7459	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:41:00.014922
7460	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:41:00.014922
7461	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:41:00.014922
7462	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 14:41:00.014922
7463	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:41:00.014922
7464	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:42:00.069685
7465	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:42:00.069685
7466	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:42:00.069685
7467	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:42:00.069685
7468	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:42:00.069685
7469	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:43:00.06535
7470	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:43:00.06535
7471	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-04 14:43:00.06535
7472	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:43:00.06535
7473	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:43:00.06535
7474	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 14:44:00.025922
7475	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:44:00.025922
7476	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 14:44:00.025922
7477	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:44:00.025922
7478	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:44:00.025922
7479	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:45:00.076632
7480	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:45:00.076632
7481	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:45:00.076632
7482	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 14:45:00.076632
7483	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 14:45:00.076632
7484	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:46:00.013785
7485	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 14:46:00.013785
7486	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:46:00.013785
7487	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 14:46:00.013785
7488	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 14:46:00.013785
7489	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 14:47:00.004973
7490	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 14:47:00.004973
7491	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:47:00.004973
7492	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 14:47:00.004973
7493	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:47:00.004973
7494	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:48:00.055953
7495	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 14:48:00.055953
7496	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 14:48:00.055953
7497	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 14:48:00.055953
7498	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:48:00.055953
7499	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:49:00.012438
7500	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:49:00.012438
7501	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 14:49:00.012438
7502	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 14:49:00.012438
7503	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-04 14:49:00.012438
7504	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:50:00.050483
7505	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-04 14:50:00.050483
7506	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:50:00.050483
7507	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:50:00.050483
7508	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-04 14:50:00.050483
7509	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:51:00.054119
7510	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:51:00.054119
7511	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:51:00.054119
7512	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 14:51:00.054119
7513	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 14:51:00.054119
7514	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-04 14:52:00.016111
7515	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:52:00.016111
7516	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-04 14:52:00.016111
7517	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:52:00.016111
7518	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:52:00.016111
7519	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:53:00.015044
7520	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-04 14:53:00.015044
7521	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 14:53:00.015044
7522	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-04 14:53:00.015044
7523	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:53:00.015044
7524	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:54:00.08885
7525	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:54:00.08885
7526	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:54:00.08885
7527	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:54:00.08885
7528	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:54:00.08885
7529	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 14:55:00.011069
7530	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:55:00.011069
7531	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:55:00.011069
7532	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:55:00.011069
7533	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:55:00.011069
7534	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:56:00.056828
7535	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 14:56:00.056828
7536	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:56:00.056828
7537	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 14:56:00.056828
7538	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 14:56:00.056828
7539	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 14:57:00.063056
7540	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:57:00.063056
7541	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-04 14:57:00.063056
7542	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 14:57:00.063056
7543	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:57:00.063056
7544	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:58:00.004475
7545	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 14:58:00.004475
7546	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:58:00.004475
7547	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 14:58:00.004475
7548	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:58:00.004475
7549	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 14:59:00.170563
7550	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-04 14:59:00.170563
7551	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 14:59:00.170563
7552	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 14:59:00.170563
7553	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 14:59:00.170563
7554	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 15:00:00.011936
7555	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 15:00:00.011936
7556	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 15:00:00.011936
7557	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-04 15:00:00.011936
7558	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 15:00:00.011936
7559	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 15:01:00.015941
7560	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 15:01:00.015941
7561	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 15:01:00.015941
7562	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 15:01:00.015941
7563	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-04 15:01:00.015941
7564	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-04 15:02:00.081282
7565	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 15:02:00.081282
7566	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-04 15:02:00.081282
7567	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-04 15:02:00.081282
7568	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 15:02:00.081282
7569	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 15:03:00.011404
7570	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 15:03:00.011404
7571	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 15:03:00.011404
7572	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 15:03:00.011404
7573	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 15:03:00.011404
7574	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-04 15:04:00.003636
7575	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-04 15:04:00.003636
7576	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-04 15:04:00.003636
7577	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-04 15:04:00.003636
7578	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-04 15:04:00.003636
7579	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 12:45:01.884531
7580	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 12:45:01.884531
7581	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 12:45:01.884531
7582	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 12:46:00.172394
7583	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 12:46:00.172394
7584	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 12:46:00.172394
7585	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 12:47:02.917598
7586	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 12:47:02.917598
7587	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 12:47:02.917598
7588	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 12:48:00.344145
7589	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 12:48:00.344145
7590	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 12:48:00.344145
7591	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 12:49:00.179662
7592	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 12:49:00.179662
7593	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-05 12:49:00.179662
7594	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 12:50:00.114111
7595	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 12:50:00.114111
7596	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 12:50:00.114111
7597	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 12:51:00.163661
7598	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 12:51:00.163661
7599	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 12:51:00.163661
7600	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 12:52:01.561052
7601	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 12:52:01.561052
7602	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 12:52:01.561052
7603	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 12:53:00.028431
7604	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 12:53:00.028431
7605	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 12:53:00.028431
7606	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 12:54:00.356573
7607	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 12:54:00.356573
7608	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 12:54:00.356573
7609	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-05 12:55:00.390809
7610	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 12:55:00.390809
7611	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 12:55:00.390809
7612	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:00:23.955817
7613	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:00:23.955817
7614	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:00:23.955817
7615	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:01:01.034846
7616	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:01:01.034846
7617	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:01:01.034846
7618	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:02:03.64413
7619	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:02:03.64413
7620	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:02:03.64413
7621	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:03:00.403904
7622	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:03:00.403904
7623	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:03:00.403904
7624	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:04:03.473269
7625	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:04:03.473269
7626	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:04:03.473269
7627	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:05:20.721278
7628	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:05:20.721278
7629	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:05:20.721278
7630	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:06:02.324017
7631	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:06:02.324017
7632	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:06:02.324017
7633	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:07:04.253263
7634	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:07:04.253263
7635	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:07:04.253263
7636	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:07:04.253263
7637	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 13:07:04.253263
7638	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:08:00.656713
7639	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:08:00.656713
7640	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:08:00.656713
7641	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-05 13:08:00.656713
7642	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:08:00.656713
7643	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 13:09:02.330179
7644	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:09:02.330179
7645	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:09:02.330179
7646	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:09:02.330179
7647	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:09:02.330179
7648	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:10:00.040233
7649	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:10:00.040233
7650	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:10:00.040233
7651	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:10:00.040233
7652	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:10:00.040233
7653	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:11:00.437415
7654	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:11:00.437415
7655	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:11:00.437415
7656	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 13:11:00.437415
7657	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:11:00.437415
7658	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:12:01.148782
7659	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:12:01.148782
7660	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:12:01.148782
7661	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:12:01.148782
7662	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:12:01.148782
7663	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:13:00.863561
7664	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 13:13:00.863561
7665	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:13:00.863561
7666	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:13:00.863561
7667	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:13:00.863561
7668	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:14:00.327218
7669	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:14:00.327218
7670	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:14:00.327218
7671	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:14:00.327218
7672	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:14:00.327218
7673	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:15:05.67779
7674	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:15:05.67779
7675	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:15:05.67779
7676	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:15:05.67779
7677	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:15:05.67779
7678	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:16:01.601001
7679	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:16:01.601001
7680	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:16:01.601001
7681	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:16:01.601001
7682	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:16:01.601001
7683	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:17:00.286465
7684	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:17:00.286465
7685	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-05 13:17:00.286465
7686	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:17:00.286465
7687	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:17:00.286465
7688	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:18:00.02054
7689	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-05 13:18:00.02054
7690	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:18:00.02054
7691	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 13:18:00.02054
7692	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:18:00.02054
7693	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:19:02.017798
7694	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:19:02.017798
7695	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:19:02.017798
7696	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:19:02.017798
7697	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 13:19:02.017798
7698	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:20:00.77181
7699	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:20:00.77181
7700	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:20:00.77181
7701	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:20:00.77181
7702	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:20:00.77181
7703	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 13:21:00.791046
7704	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:21:00.791046
7705	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:21:00.791046
7706	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:21:00.791046
7707	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:21:00.791046
7708	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:22:00.551566
7709	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:22:00.551566
7710	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:22:00.551566
7711	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:22:00.551566
7712	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:22:00.551566
7713	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:23:00.600246
7714	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 13:23:00.600246
7715	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:23:00.600246
7716	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:23:00.600246
7717	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:23:00.600246
7718	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:24:00.081344
7719	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:24:00.081344
7720	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 13:24:00.081344
7721	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:24:00.081344
7722	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:24:00.081344
7723	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:25:00.668972
7724	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 13:25:00.668972
7725	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:25:00.668972
7726	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:25:00.668972
7727	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:25:00.668972
7728	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:26:00.262256
7729	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:26:00.262256
7730	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 13:26:00.262256
7731	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:26:00.262256
7732	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:26:00.262256
7733	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:27:00.158379
7734	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:27:00.158379
7735	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:27:00.158379
7736	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:27:00.158379
7737	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:27:00.158379
7738	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:28:00.5379
7739	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:28:00.5379
7740	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:28:00.5379
7741	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:28:00.5379
7742	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:28:00.5379
7743	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:29:00.389325
7744	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:29:00.389325
7745	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:29:00.389325
7746	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 13:29:00.389325
7747	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:29:00.389325
7748	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:30:00.252731
7749	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:30:00.252731
7750	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:30:00.252731
7751	1	Ex - FlyNow	main_area	10	5	Moderate	50.00	2026-02-05 13:30:00.252731
7752	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:30:00.252731
7753	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:31:00.559697
7754	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:31:00.559697
7755	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:31:00.559697
7756	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:31:00.559697
7757	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:31:00.559697
7758	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 13:32:00.245755
7759	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:32:00.245755
7760	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:32:00.245755
7761	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:32:00.245755
7762	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:32:00.245755
7763	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:33:00.261674
7764	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:33:00.261674
7765	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:33:00.261674
7766	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:33:00.261674
7767	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:33:00.261674
7768	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:34:00.426563
7769	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:34:00.426563
7770	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:34:00.426563
7771	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:34:00.426563
7772	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:34:00.426563
7773	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 13:35:00.259035
7774	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:35:00.259035
7775	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:35:00.259035
7776	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:35:00.259035
7777	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:35:00.259035
7778	3	In- Fixar aircraft	main_area	5	0	Low	0.00	2026-02-05 13:36:00.538155
7779	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:36:00.538155
7780	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 13:36:00.538155
7781	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:36:00.538155
7782	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:36:00.538155
7783	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-05 13:44:00.237005
7784	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 13:44:00.237005
7785	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:44:00.237005
7786	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 13:44:00.237005
7787	1	Ex - FlyNow	main_area	10	6	Moderate	60.00	2026-02-05 13:44:00.237005
7788	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:45:00.03325
7789	1	Ex - FlyNow	main_area	10	5	Moderate	50.00	2026-02-05 13:45:00.03325
7790	2	In - V-BAT aircraft	main_area	5	8	Crowded	160.00	2026-02-05 13:45:00.03325
7791	3	In- Fixar aircraft	main_area	5	8	Crowded	160.00	2026-02-05 13:45:00.03325
7792	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 13:45:00.03325
7793	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 13:46:00.07403
7794	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-05 13:46:00.07403
7795	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:46:00.07403
7796	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 13:46:00.07403
7797	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 13:46:00.07403
7798	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 13:47:00.356687
7799	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 13:47:00.356687
7800	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:47:00.356687
7801	2	In - V-BAT aircraft	main_area	5	9	Crowded	180.00	2026-02-05 13:47:00.356687
7802	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 13:47:00.356687
7803	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:48:00.311416
7804	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 13:48:00.311416
7805	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 13:48:00.311416
7806	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-05 13:48:00.311416
7807	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 13:48:00.311416
7808	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:49:00.098877
7809	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 13:49:00.098877
7810	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-05 13:49:00.098877
7811	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 13:49:00.098877
7812	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 13:49:00.098877
7813	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-05 13:50:00.112107
7814	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 13:50:00.112107
7815	3	In- Fixar aircraft	main_area	5	6	Crowded	120.00	2026-02-05 13:50:00.112107
7816	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:50:00.112107
7817	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-05 13:50:00.112107
7818	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 13:51:01.775502
7819	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:51:01.775502
7820	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 13:51:01.775502
7821	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 13:51:01.775502
7822	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-05 13:51:01.775502
7823	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 13:52:00.922907
7824	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-05 13:52:00.922907
7825	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 13:52:00.922907
7826	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 13:52:00.922907
7827	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:52:00.922907
7828	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 13:53:00.026763
7829	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 13:53:00.026763
7830	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 13:53:00.026763
7831	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:53:00.026763
7832	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:53:00.026763
7833	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 13:54:00.023926
7834	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 13:54:00.023926
7835	4	Ex- Drones	main_area	10	4	Moderate	40.00	2026-02-05 13:54:00.023926
7836	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:54:00.023926
7837	3	In- Fixar aircraft	main_area	5	6	Crowded	120.00	2026-02-05 13:54:00.023926
7838	4	Ex- Drones	main_area	10	5	Moderate	50.00	2026-02-05 13:55:00.010233
7839	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 13:55:00.010233
7840	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 13:55:00.010233
7841	3	In- Fixar aircraft	main_area	5	6	Crowded	120.00	2026-02-05 13:55:00.010233
7842	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 13:55:00.010233
7843	3	In- Fixar aircraft	main_area	5	6	Crowded	120.00	2026-02-05 13:56:00.068149
7844	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:56:00.068149
7845	1	Ex - FlyNow	main_area	10	5	Moderate	50.00	2026-02-05 13:56:00.068149
7846	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 13:56:00.068149
7847	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 13:56:00.068149
7848	2	In - V-BAT aircraft	main_area	5	8	Crowded	160.00	2026-02-05 13:57:00.635948
7849	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 13:57:00.635948
7850	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 13:57:00.635948
7851	3	In- Fixar aircraft	main_area	5	9	Crowded	180.00	2026-02-05 13:57:00.635948
7852	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 13:57:00.635948
7853	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 13:58:00.014166
7854	2	In - V-BAT aircraft	main_area	5	9	Crowded	180.00	2026-02-05 13:58:00.014166
7855	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 13:58:00.014166
7856	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:58:00.014166
7857	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 13:58:00.014166
7858	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-05 13:59:02.448378
7859	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 13:59:02.448378
7860	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 13:59:02.448378
7861	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 13:59:02.448378
7862	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 13:59:02.448378
7863	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-05 14:00:00.130768
7864	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:00:00.130768
7865	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 14:00:00.130768
7866	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:00:00.130768
7867	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-05 14:00:00.130768
7868	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 14:01:00.117362
7869	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:01:00.117362
7870	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-05 14:01:00.117362
7871	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:01:00.117362
7872	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:01:00.117362
7873	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:02:01.053236
7874	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:02:01.053236
7875	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-05 14:02:01.053236
7876	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 14:02:01.053236
7877	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:02:01.053236
7878	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:03:00.105528
7879	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-05 14:03:00.105528
7880	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 14:03:00.105528
7881	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:03:00.105528
7882	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-05 14:03:00.105528
7883	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:04:00.169984
7884	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 14:04:00.169984
7885	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:04:00.169984
7886	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:04:00.169984
7887	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-05 14:04:00.169984
7888	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-05 14:05:00.535996
7889	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:05:00.535996
7890	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:05:00.535996
7891	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:05:00.535996
7892	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 14:05:00.535996
7893	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:06:00.403961
7894	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:06:00.403961
7895	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 14:06:00.403961
7896	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-05 14:06:00.403961
7897	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:06:00.403961
7898	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:07:00.255323
7899	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 14:07:00.255323
7900	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-05 14:07:00.255323
7901	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:07:00.255323
7902	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 14:07:00.255323
7903	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:08:00.127984
7904	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 14:08:00.127984
7905	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:08:00.127984
7906	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 14:08:00.127984
7907	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:08:00.127984
7908	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 14:09:00.965073
7909	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 14:09:00.965073
7910	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:09:00.965073
7911	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 14:09:00.965073
7912	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:09:00.965073
7913	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:10:00.27332
7914	3	In- Fixar aircraft	main_area	5	6	Crowded	120.00	2026-02-05 14:10:00.27332
7915	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:10:00.27332
7916	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 14:10:00.27332
7917	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 14:10:00.27332
7918	3	In- Fixar aircraft	main_area	5	6	Crowded	120.00	2026-02-05 14:11:00.196813
7919	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 14:11:00.196813
7920	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:11:00.196813
7921	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:11:00.196813
7922	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 14:11:00.196813
7923	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:12:00.046306
7924	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:12:00.046306
7925	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:12:00.046306
7926	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:12:00.046306
7927	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:12:00.046306
7928	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:13:00.647505
7929	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:13:00.647505
7930	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:13:00.647505
7931	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:13:00.647505
7932	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:13:00.647505
7933	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:14:00.235603
7934	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 14:14:00.235603
7935	3	In- Fixar aircraft	main_area	5	4	Crowded	80.00	2026-02-05 14:14:00.235603
7936	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:14:00.235603
7937	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:14:00.235603
7938	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:15:00.874358
7939	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 14:15:00.874358
7940	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 14:15:00.874358
7941	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-05 14:15:00.874358
7942	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-05 14:15:00.874358
7943	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 14:16:00.091701
7944	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-05 14:16:00.091701
7945	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:16:00.091701
7946	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:16:00.091701
7947	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:16:00.091701
7948	3	In- Fixar aircraft	main_area	5	1	Low	20.00	2026-02-05 14:17:00.407168
7949	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:17:00.407168
7950	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:17:00.407168
7951	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:17:00.407168
7952	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:17:00.407168
7953	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-05 14:18:01.280256
7954	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:18:01.280256
7955	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:18:01.280256
7956	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:18:01.280256
7957	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 14:18:01.280256
7958	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:19:00.07728
7959	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:19:00.07728
7960	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:19:00.07728
7961	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:19:00.07728
7962	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:19:00.07728
7963	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 14:20:00.056593
7964	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:20:00.056593
7965	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 14:20:00.056593
7966	3	In- Fixar aircraft	main_area	5	6	Crowded	120.00	2026-02-05 14:20:00.056593
7967	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:20:00.056593
7968	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 14:21:00.305637
7969	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:21:00.305637
7970	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:21:00.305637
7971	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:21:00.305637
7972	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 14:21:00.305637
7973	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:22:00.167703
7974	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:22:00.167703
7975	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:22:00.167703
7976	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:22:00.167703
7977	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:22:00.167703
7978	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:23:00.583436
7979	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:23:00.583436
7980	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 14:23:00.583436
7981	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-05 14:23:00.583436
7982	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:23:00.583436
7983	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 14:24:00.405159
7984	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 14:24:00.405159
7985	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 14:24:00.405159
7986	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 14:24:00.405159
7987	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-05 14:24:00.405159
7988	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:25:00.2877
7989	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:25:00.2877
7990	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:25:00.2877
7991	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:25:00.2877
7992	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 14:25:00.2877
7993	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:26:00.048247
7994	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:26:00.048247
7995	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 14:26:00.048247
7996	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 14:26:00.048247
7997	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-05 14:26:00.048247
7998	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 14:27:00.615745
7999	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-05 14:27:00.615745
8000	2	In - V-BAT aircraft	main_area	5	0	Low	0.00	2026-02-05 14:27:00.615745
8001	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 14:27:00.615745
8002	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:27:00.615745
8003	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:28:00.557229
8004	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:28:00.557229
8005	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:28:00.557229
8006	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:28:00.557229
8007	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:28:00.557229
8008	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-05 14:29:00.085873
8009	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 14:29:00.085873
8010	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:29:00.085873
8011	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 14:29:00.085873
8012	3	In- Fixar aircraft	main_area	5	6	Crowded	120.00	2026-02-05 14:29:00.085873
8013	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:30:00.119277
8014	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:30:00.119277
8015	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:30:00.119277
8016	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 14:30:00.119277
8017	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 14:30:00.119277
8018	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:31:00.172125
8019	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:31:00.172125
8020	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:31:00.172125
8021	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-05 14:31:00.172125
8022	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 14:31:00.172125
8023	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-05 14:32:01.194209
8024	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:32:01.194209
8025	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:32:01.194209
8026	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 14:32:01.194209
8027	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:32:01.194209
8028	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-05 14:33:00.911576
8029	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 14:33:00.911576
8030	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 14:33:00.911576
8031	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:33:00.911576
8032	3	In- Fixar aircraft	main_area	5	6	Crowded	120.00	2026-02-05 14:33:00.911576
8033	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 14:34:00.199334
8034	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:34:00.199334
8035	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-05 14:34:00.199334
8036	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-05 14:34:00.199334
8037	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:34:00.199334
8038	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:35:00.022803
8039	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:35:00.022803
8040	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-05 14:35:00.022803
8041	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-05 14:35:00.022803
8042	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 14:35:00.022803
8043	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 14:36:00.218098
8044	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:36:00.218098
8045	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:36:00.218098
8046	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:36:00.218098
8047	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-05 14:36:00.218098
8048	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:37:02.357736
8049	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 14:37:02.357736
8050	3	In- Fixar aircraft	main_area	5	6	Crowded	120.00	2026-02-05 14:37:02.357736
8051	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-05 14:37:02.357736
8052	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:37:02.357736
8053	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:38:00.890855
8054	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 14:38:00.890855
8055	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:38:00.890855
8056	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:38:00.890855
8057	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-05 14:38:00.890855
8058	3	In- Fixar aircraft	main_area	5	3	Moderate	60.00	2026-02-05 14:39:00.011587
8059	2	In - V-BAT aircraft	main_area	5	1	Low	20.00	2026-02-05 14:39:00.011587
8060	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 14:39:00.011587
8061	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:39:00.011587
8062	1	Ex - FlyNow	main_area	10	0	Low	0.00	2026-02-05 14:39:00.011587
8063	2	In - V-BAT aircraft	main_area	5	3	Moderate	60.00	2026-02-05 14:40:01.95437
8064	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 14:40:01.95437
8065	3	In- Fixar aircraft	main_area	5	8	Crowded	160.00	2026-02-05 14:40:01.95437
8066	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 14:40:01.95437
8067	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 14:40:01.95437
8068	2	In - V-BAT aircraft	main_area	5	2	Moderate	40.00	2026-02-05 14:41:02.294963
8069	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 14:41:02.294963
8070	3	In- Fixar aircraft	main_area	5	12	Crowded	240.00	2026-02-05 14:41:02.294963
8071	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 14:41:02.294963
8072	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-05 14:41:02.294963
8073	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 14:42:00.025608
8074	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-05 14:42:00.025608
8075	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:42:00.025608
8076	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 14:42:00.025608
8077	3	In- Fixar aircraft	main_area	5	11	Crowded	220.00	2026-02-05 14:42:00.025608
8078	3	In- Fixar aircraft	main_area	5	11	Crowded	220.00	2026-02-05 14:43:00.011459
8079	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-05 14:43:00.011459
8080	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:43:00.011459
8081	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-05 14:43:00.011459
8082	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 14:43:00.011459
8083	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 14:44:00.020048
8084	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-05 14:44:00.020048
8085	3	In- Fixar aircraft	main_area	5	12	Crowded	240.00	2026-02-05 14:44:00.020048
8086	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-05 14:44:00.020048
8087	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 14:44:00.020048
8088	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-05 14:45:00.030768
8089	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-05 14:45:00.030768
8090	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-05 14:45:00.030768
8091	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 14:45:00.030768
8092	3	In- Fixar aircraft	main_area	5	9	Crowded	180.00	2026-02-05 14:45:00.030768
8093	3	In- Fixar aircraft	main_area	5	10	Crowded	200.00	2026-02-05 14:46:00.25124
8094	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-05 14:46:00.25124
8095	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-05 14:46:00.25124
8096	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 14:46:00.25124
8097	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:46:00.25124
8098	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-05 14:47:00.084168
8099	1	Ex - FlyNow	main_area	10	5	Moderate	50.00	2026-02-05 14:47:00.084168
8100	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:47:00.084168
8101	3	In- Fixar aircraft	main_area	5	11	Crowded	220.00	2026-02-05 14:47:00.084168
8102	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-05 14:47:00.084168
8103	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 14:48:00.744788
8104	1	Ex - FlyNow	main_area	10	6	Moderate	60.00	2026-02-05 14:48:00.744788
8105	2	In - V-BAT aircraft	main_area	5	8	Crowded	160.00	2026-02-05 14:48:00.744788
8106	3	In- Fixar aircraft	main_area	5	10	Crowded	200.00	2026-02-05 14:48:00.744788
8107	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 14:48:00.744788
8108	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-05 14:49:01.53266
8109	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-05 14:49:01.53266
8110	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-05 14:49:01.53266
8111	2	In - V-BAT aircraft	main_area	5	10	Crowded	200.00	2026-02-05 14:49:01.53266
8112	3	In- Fixar aircraft	main_area	5	10	Crowded	200.00	2026-02-05 14:49:01.53266
8113	2	In - V-BAT aircraft	main_area	5	8	Crowded	160.00	2026-02-05 14:50:03.983544
8114	1	Ex - FlyNow	main_area	10	5	Moderate	50.00	2026-02-05 14:50:03.983544
8115	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-05 14:50:03.983544
8116	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-05 14:50:03.983544
8117	3	In- Fixar aircraft	main_area	5	9	Crowded	180.00	2026-02-05 14:50:03.983544
8118	2	In - V-BAT aircraft	main_area	5	10	Crowded	200.00	2026-02-05 14:51:11.260252
8119	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:51:11.260252
8120	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 14:51:11.260252
8121	3	In- Fixar aircraft	main_area	5	2	Moderate	40.00	2026-02-05 14:51:11.260252
8122	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-05 14:51:11.260252
8123	1	Ex - FlyNow	main_area	10	5	Moderate	50.00	2026-02-05 14:52:00.327601
8124	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 14:52:00.327601
8125	2	In - V-BAT aircraft	main_area	5	10	Crowded	200.00	2026-02-05 14:52:00.327601
8126	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-05 14:52:00.327601
8127	3	In- Fixar aircraft	main_area	5	8	Crowded	160.00	2026-02-05 14:52:00.327601
8128	3	In- Fixar aircraft	main_area	5	9	Crowded	180.00	2026-02-05 14:53:00.051679
8129	2	In - V-BAT aircraft	main_area	5	8	Crowded	160.00	2026-02-05 14:53:00.051679
8130	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 14:53:00.051679
8131	1	Ex - FlyNow	main_area	10	7	Crowded	70.00	2026-02-05 14:53:00.051679
8132	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-05 14:53:00.051679
8133	1	Ex - FlyNow	main_area	10	7	Crowded	70.00	2026-02-05 14:54:02.944557
8134	3	In- Fixar aircraft	main_area	5	9	Crowded	180.00	2026-02-05 14:54:02.944557
8135	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 14:54:02.944557
8136	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 14:54:02.944557
8137	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-05 14:54:02.944557
8138	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-05 14:55:01.020911
8139	1	Ex - FlyNow	main_area	10	7	Crowded	70.00	2026-02-05 14:55:01.020911
8140	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-05 14:55:01.020911
8141	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 14:55:01.020911
8142	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 14:55:01.020911
8143	1	Ex - FlyNow	main_area	10	8	Crowded	80.00	2026-02-05 14:56:09.690017
8144	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 14:56:09.690017
8145	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 14:56:09.690017
8146	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-05 14:56:09.690017
8147	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-05 14:56:09.690017
8148	1	Ex - FlyNow	main_area	10	6	Moderate	60.00	2026-02-05 14:57:00.934236
8149	2	In - V-BAT aircraft	main_area	5	10	Crowded	200.00	2026-02-05 14:57:00.934236
8150	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-05 14:57:00.934236
8151	3	In- Fixar aircraft	main_area	5	9	Crowded	180.00	2026-02-05 14:57:00.934236
8152	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:57:00.934236
8153	3	In- Fixar aircraft	main_area	5	8	Crowded	160.00	2026-02-05 14:58:01.421832
8154	2	In - V-BAT aircraft	main_area	5	8	Crowded	160.00	2026-02-05 14:58:01.421832
8155	1	Ex - FlyNow	main_area	10	5	Moderate	50.00	2026-02-05 14:58:01.421832
8156	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-05 14:58:01.421832
8157	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 14:58:01.421832
8158	2	In - V-BAT aircraft	main_area	5	9	Crowded	180.00	2026-02-05 14:59:00.739303
8159	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-05 14:59:00.739303
8160	5	Ex- Barista Robot	main_area	10	4	Moderate	40.00	2026-02-05 14:59:00.739303
8161	3	In- Fixar aircraft	main_area	5	8	Crowded	160.00	2026-02-05 14:59:00.739303
8162	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 14:59:00.739303
8163	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-05 15:00:00.628222
8164	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-05 15:00:00.628222
8165	3	In- Fixar aircraft	main_area	5	9	Crowded	180.00	2026-02-05 15:00:00.628222
8166	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 15:00:00.628222
8167	2	In - V-BAT aircraft	main_area	5	8	Crowded	160.00	2026-02-05 15:00:00.628222
8168	3	In- Fixar aircraft	main_area	5	8	Crowded	160.00	2026-02-05 15:01:01.20376
8169	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-05 15:01:01.20376
8170	2	In - V-BAT aircraft	main_area	5	5	Crowded	100.00	2026-02-05 15:01:01.20376
8171	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 15:01:01.20376
8172	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 15:01:01.20376
8173	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 15:02:01.132304
8174	2	In - V-BAT aircraft	main_area	5	4	Crowded	80.00	2026-02-05 15:02:01.132304
8175	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-05 15:02:01.132304
8176	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 15:02:01.132304
8177	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 15:02:01.132304
8178	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 15:03:28.73109
8179	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-05 15:03:28.73109
8180	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 15:03:28.73109
8181	5	Ex- Barista Robot	main_area	10	1	Low	10.00	2026-02-05 15:03:28.73109
8182	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 15:03:28.73109
8183	2	In - V-BAT aircraft	main_area	5	9	Crowded	180.00	2026-02-05 15:04:00.22341
8184	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 15:04:00.22341
8185	3	In- Fixar aircraft	main_area	5	9	Crowded	180.00	2026-02-05 15:04:00.22341
8186	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-05 15:04:00.22341
8187	5	Ex- Barista Robot	main_area	10	0	Low	0.00	2026-02-05 15:04:00.22341
8188	4	Ex- Drones	main_area	10	2	Low	20.00	2026-02-05 15:05:00.591209
8189	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 15:05:00.591209
8190	2	In - V-BAT aircraft	main_area	5	8	Crowded	160.00	2026-02-05 15:05:00.591209
8191	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 15:05:00.591209
8192	5	Ex- Barista Robot	main_area	10	2	Low	20.00	2026-02-05 15:05:00.591209
8193	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 15:06:00.780356
8194	2	In - V-BAT aircraft	main_area	5	9	Crowded	180.00	2026-02-05 15:06:00.780356
8195	1	Ex - FlyNow	main_area	10	1	Low	10.00	2026-02-05 15:06:00.780356
8196	4	Ex- Drones	main_area	10	3	Low	30.00	2026-02-05 15:06:00.780356
8197	3	In- Fixar aircraft	main_area	5	8	Crowded	160.00	2026-02-05 15:06:00.780356
8198	3	In- Fixar aircraft	main_area	5	8	Crowded	160.00	2026-02-05 15:07:00.549833
8199	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 15:07:00.549833
8200	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-05 15:07:00.549833
8201	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 15:07:00.549833
8202	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 15:07:00.549833
8203	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 15:08:00.013095
8204	2	In - V-BAT aircraft	main_area	5	12	Crowded	240.00	2026-02-05 15:08:00.013095
8205	3	In- Fixar aircraft	main_area	5	9	Crowded	180.00	2026-02-05 15:08:00.013095
8206	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 15:08:00.013095
8207	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 15:08:00.013095
8208	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 15:09:00.585747
8209	2	In - V-BAT aircraft	main_area	5	12	Crowded	240.00	2026-02-05 15:09:00.585747
8210	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-05 15:09:00.585747
8211	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 15:09:00.585747
8212	3	In- Fixar aircraft	main_area	5	8	Crowded	160.00	2026-02-05 15:09:00.585747
8213	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 15:10:00.160941
8214	3	In- Fixar aircraft	main_area	5	10	Crowded	200.00	2026-02-05 15:10:00.160941
8215	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 15:10:00.160941
8216	2	In - V-BAT aircraft	main_area	5	11	Crowded	220.00	2026-02-05 15:10:00.160941
8217	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-05 15:10:00.160941
8218	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 15:11:00.237868
8219	1	Ex - FlyNow	main_area	10	2	Low	20.00	2026-02-05 15:11:00.237868
8220	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 15:11:00.237868
8221	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-05 15:11:00.237868
8222	2	In - V-BAT aircraft	main_area	5	8	Crowded	160.00	2026-02-05 15:11:00.237868
8223	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 15:12:00.13378
8224	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 15:12:00.13378
8225	3	In- Fixar aircraft	main_area	5	7	Crowded	140.00	2026-02-05 15:12:00.13378
8226	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-05 15:12:00.13378
8227	2	In - V-BAT aircraft	main_area	5	9	Crowded	180.00	2026-02-05 15:12:00.13378
8228	3	In- Fixar aircraft	main_area	5	8	Crowded	160.00	2026-02-05 15:13:00.716683
8229	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 15:13:00.716683
8230	2	In - V-BAT aircraft	main_area	5	9	Crowded	180.00	2026-02-05 15:13:00.716683
8231	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 15:13:00.716683
8232	5	Ex- Barista Robot	main_area	10	8	Crowded	80.00	2026-02-05 15:13:00.716683
8233	3	In- Fixar aircraft	main_area	5	5	Crowded	100.00	2026-02-05 15:14:00.463193
8234	2	In - V-BAT aircraft	main_area	5	8	Crowded	160.00	2026-02-05 15:14:00.463193
8235	1	Ex - FlyNow	main_area	10	3	Low	30.00	2026-02-05 15:14:00.463193
8236	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 15:14:00.463193
8237	5	Ex- Barista Robot	main_area	10	5	Moderate	50.00	2026-02-05 15:14:00.463193
8238	2	In - V-BAT aircraft	main_area	5	6	Crowded	120.00	2026-02-05 15:15:00.072803
8239	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 15:15:00.072803
8240	5	Ex- Barista Robot	main_area	10	7	Crowded	70.00	2026-02-05 15:15:00.072803
8241	1	Ex - FlyNow	main_area	10	4	Moderate	40.00	2026-02-05 15:15:00.072803
8242	3	In- Fixar aircraft	main_area	5	6	Crowded	120.00	2026-02-05 15:15:00.072803
8243	2	In - V-BAT aircraft	main_area	5	11	Crowded	220.00	2026-02-05 15:16:00.479085
8244	4	Ex- Drones	main_area	10	1	Low	10.00	2026-02-05 15:16:00.479085
8245	1	Ex - FlyNow	main_area	10	6	Moderate	60.00	2026-02-05 15:16:00.479085
8246	5	Ex- Barista Robot	main_area	10	8	Crowded	80.00	2026-02-05 15:16:00.479085
8247	3	In- Fixar aircraft	main_area	5	10	Crowded	200.00	2026-02-05 15:16:00.479085
8248	1	Ex - FlyNow	main_area	10	6	Moderate	60.00	2026-02-05 15:17:00.898176
8249	2	In - V-BAT aircraft	main_area	5	10	Crowded	200.00	2026-02-05 15:17:00.898176
8250	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 15:17:00.898176
8251	5	Ex- Barista Robot	main_area	10	6	Moderate	60.00	2026-02-05 15:17:00.898176
8252	3	In- Fixar aircraft	main_area	5	9	Crowded	180.00	2026-02-05 15:17:00.898176
8253	1	Ex - FlyNow	main_area	10	6	Moderate	60.00	2026-02-05 15:18:00.097695
8254	3	In- Fixar aircraft	main_area	5	9	Crowded	180.00	2026-02-05 15:18:00.097695
8255	5	Ex- Barista Robot	main_area	10	3	Low	30.00	2026-02-05 15:18:00.097695
8256	2	In - V-BAT aircraft	main_area	5	7	Crowded	140.00	2026-02-05 15:18:00.097695
8257	4	Ex- Drones	main_area	10	0	Low	0.00	2026-02-05 15:18:00.097695
8258	2	In - V-BAT aircraft	main_area	35	10	Low	28.57	2026-02-05 15:55:00.147953
8259	3	In- Fixar aircraft	main_area	35	7	Low	20.00	2026-02-05 15:55:00.147953
8260	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 15:55:00.147953
8261	5	Ex- Barista Robot	main_area	35	1	Low	2.86	2026-02-05 15:55:00.147953
8262	1	Ex - FlyNow	main_area	35	9	Low	25.71	2026-02-05 15:55:00.147953
8263	2	In - V-BAT aircraft	main_area	35	11	Low	31.43	2026-02-05 15:56:01.590988
8264	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 15:56:01.590988
8265	5	Ex- Barista Robot	main_area	35	5	Low	14.29	2026-02-05 15:56:01.590988
8266	3	In- Fixar aircraft	main_area	35	10	Low	28.57	2026-02-05 15:56:01.590988
8267	1	Ex - FlyNow	main_area	35	7	Low	20.00	2026-02-05 15:56:01.590988
8268	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 15:57:03.612822
8269	5	Ex- Barista Robot	main_area	35	4	Low	11.43	2026-02-05 15:57:03.612822
8270	3	In- Fixar aircraft	main_area	35	9	Low	25.71	2026-02-05 15:57:03.612822
8271	1	Ex - FlyNow	main_area	35	4	Low	11.43	2026-02-05 15:57:03.612822
8272	2	In - V-BAT aircraft	main_area	35	12	Low	34.29	2026-02-05 15:57:03.612822
8273	2	In - V-BAT aircraft	main_area	35	16	Moderate	45.71	2026-02-05 15:59:00.54616
8274	3	In- Fixar aircraft	main_area	35	10	Low	28.57	2026-02-05 15:59:00.54616
8275	4	Ex- Drones	main_area	35	2	Low	5.71	2026-02-05 15:59:00.54616
8276	5	Ex- Barista Robot	main_area	35	0	Low	0.00	2026-02-05 15:59:00.54616
8277	1	Ex - FlyNow	main_area	35	3	Low	8.57	2026-02-05 15:59:00.54616
8278	3	In- Fixar aircraft	main_area	35	8	Low	22.86	2026-02-05 16:00:00.392399
8279	5	Ex- Barista Robot	main_area	35	2	Low	5.71	2026-02-05 16:00:00.392399
8280	2	In - V-BAT aircraft	main_area	35	14	Moderate	40.00	2026-02-05 16:00:00.392399
8281	1	Ex - FlyNow	main_area	35	4	Low	11.43	2026-02-05 16:00:00.392399
8282	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:00:00.392399
8283	3	In- Fixar aircraft	main_area	35	7	Low	20.00	2026-02-05 16:01:00.046395
8284	1	Ex - FlyNow	main_area	35	3	Low	8.57	2026-02-05 16:01:00.046395
8285	5	Ex- Barista Robot	main_area	35	1	Low	2.86	2026-02-05 16:01:00.046395
8286	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:01:00.046395
8287	2	In - V-BAT aircraft	main_area	35	15	Moderate	42.86	2026-02-05 16:01:00.046395
8288	1	Ex - FlyNow	main_area	35	2	Low	5.71	2026-02-05 16:02:03.118026
8289	2	In - V-BAT aircraft	main_area	35	11	Low	31.43	2026-02-05 16:02:03.118026
8290	3	In- Fixar aircraft	main_area	35	10	Low	28.57	2026-02-05 16:02:03.118026
8291	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:02:03.118026
8292	5	Ex- Barista Robot	main_area	35	6	Low	17.14	2026-02-05 16:02:03.118026
8293	1	Ex - FlyNow	main_area	35	3	Low	8.57	2026-02-05 16:03:02.819492
8294	2	In - V-BAT aircraft	main_area	35	13	Low	37.14	2026-02-05 16:03:02.819492
8295	5	Ex- Barista Robot	main_area	35	3	Low	8.57	2026-02-05 16:03:02.819492
8296	3	In- Fixar aircraft	main_area	35	8	Low	22.86	2026-02-05 16:03:02.819492
8297	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:03:02.819492
8298	2	In - V-BAT aircraft	main_area	35	12	Low	34.29	2026-02-05 16:04:05.546586
8299	5	Ex- Barista Robot	main_area	35	2	Low	5.71	2026-02-05 16:04:05.546586
8300	3	In- Fixar aircraft	main_area	35	5	Low	14.29	2026-02-05 16:04:05.546586
8301	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:04:05.546586
8302	1	Ex - FlyNow	main_area	35	3	Low	8.57	2026-02-05 16:04:05.546586
8303	5	Ex- Barista Robot	main_area	35	1	Low	2.86	2026-02-05 16:05:07.238395
8304	1	Ex - FlyNow	main_area	35	2	Low	5.71	2026-02-05 16:05:07.238395
8305	2	In - V-BAT aircraft	main_area	35	12	Low	34.29	2026-02-05 16:05:07.238395
8306	3	In- Fixar aircraft	main_area	35	7	Low	20.00	2026-02-05 16:05:07.238395
8307	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:05:07.238395
8308	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:06:02.045665
8309	3	In- Fixar aircraft	main_area	35	3	Low	8.57	2026-02-05 16:06:02.045665
8310	2	In - V-BAT aircraft	main_area	35	13	Low	37.14	2026-02-05 16:06:02.045665
8311	5	Ex- Barista Robot	main_area	35	1	Low	2.86	2026-02-05 16:06:02.045665
8312	1	Ex - FlyNow	main_area	35	2	Low	5.71	2026-02-05 16:06:02.045665
8313	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:07:00.414682
8314	1	Ex - FlyNow	main_area	35	3	Low	8.57	2026-02-05 16:07:00.414682
8315	2	In - V-BAT aircraft	main_area	35	13	Low	37.14	2026-02-05 16:07:00.414682
8316	5	Ex- Barista Robot	main_area	35	2	Low	5.71	2026-02-05 16:07:00.414682
8317	3	In- Fixar aircraft	main_area	35	7	Low	20.00	2026-02-05 16:07:00.414682
8318	1	Ex - FlyNow	main_area	35	2	Low	5.71	2026-02-05 16:08:00.2624
8319	2	In - V-BAT aircraft	main_area	35	14	Moderate	40.00	2026-02-05 16:08:00.2624
8320	3	In- Fixar aircraft	main_area	35	5	Low	14.29	2026-02-05 16:08:00.2624
8321	5	Ex- Barista Robot	main_area	35	2	Low	5.71	2026-02-05 16:08:00.2624
8322	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:08:00.2624
8323	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:09:00.115587
8324	3	In- Fixar aircraft	main_area	35	4	Low	11.43	2026-02-05 16:09:00.115587
8325	5	Ex- Barista Robot	main_area	35	2	Low	5.71	2026-02-05 16:09:00.115587
8326	1	Ex - FlyNow	main_area	35	5	Low	14.29	2026-02-05 16:09:00.115587
8327	2	In - V-BAT aircraft	main_area	35	10	Low	28.57	2026-02-05 16:09:00.115587
8328	2	In - V-BAT aircraft	main_area	35	11	Low	31.43	2026-02-05 16:10:00.721819
8329	5	Ex- Barista Robot	main_area	35	3	Low	8.57	2026-02-05 16:10:00.721819
8330	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:10:00.721819
8331	1	Ex - FlyNow	main_area	35	4	Low	11.43	2026-02-05 16:10:00.721819
8332	3	In- Fixar aircraft	main_area	35	4	Low	11.43	2026-02-05 16:10:00.721819
8333	1	Ex - FlyNow	main_area	35	6	Low	17.14	2026-02-05 16:12:00.826748
8334	3	In- Fixar aircraft	main_area	35	1	Low	2.86	2026-02-05 16:12:00.826748
8335	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:12:00.826748
8336	2	In - V-BAT aircraft	main_area	35	7	Low	20.00	2026-02-05 16:12:00.826748
8337	5	Ex- Barista Robot	main_area	35	1	Low	2.86	2026-02-05 16:12:00.826748
8338	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:13:00.173685
8339	2	In - V-BAT aircraft	main_area	35	10	Low	28.57	2026-02-05 16:13:00.173685
8340	3	In- Fixar aircraft	main_area	35	2	Low	5.71	2026-02-05 16:13:00.173685
8341	5	Ex- Barista Robot	main_area	35	1	Low	2.86	2026-02-05 16:13:00.173685
8342	1	Ex - FlyNow	main_area	35	2	Low	5.71	2026-02-05 16:13:00.173685
8343	2	In - V-BAT aircraft	main_area	35	10	Low	28.57	2026-02-05 16:14:00.366854
8344	1	Ex - FlyNow	main_area	35	2	Low	5.71	2026-02-05 16:14:00.366854
8345	3	In- Fixar aircraft	main_area	35	1	Low	2.86	2026-02-05 16:14:00.366854
8346	5	Ex- Barista Robot	main_area	35	0	Low	0.00	2026-02-05 16:14:00.366854
8347	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:14:00.366854
8348	3	In- Fixar aircraft	main_area	35	1	Low	2.86	2026-02-05 16:15:00.442968
8349	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:15:00.442968
8350	2	In - V-BAT aircraft	main_area	35	8	Low	22.86	2026-02-05 16:15:00.442968
8351	5	Ex- Barista Robot	main_area	35	1	Low	2.86	2026-02-05 16:15:00.442968
8352	1	Ex - FlyNow	main_area	35	2	Low	5.71	2026-02-05 16:15:00.442968
8353	1	Ex - FlyNow	main_area	35	2	Low	5.71	2026-02-05 16:16:00.251216
8354	2	In - V-BAT aircraft	main_area	35	9	Low	25.71	2026-02-05 16:16:00.251216
8355	5	Ex- Barista Robot	main_area	35	0	Low	0.00	2026-02-05 16:16:00.251216
8356	3	In- Fixar aircraft	main_area	35	2	Low	5.71	2026-02-05 16:16:00.251216
8357	4	Ex- Drones	main_area	35	1	Low	2.86	2026-02-05 16:16:00.251216
8358	5	Ex- Barista Robot	main_area	35	1	Low	2.86	2026-02-05 16:17:00.045132
8359	1	Ex - FlyNow	main_area	35	2	Low	5.71	2026-02-05 16:17:00.045132
8360	3	In- Fixar aircraft	main_area	35	3	Low	8.57	2026-02-05 16:17:00.045132
8361	4	Ex- Drones	main_area	35	1	Low	2.86	2026-02-05 16:17:00.045132
8362	2	In - V-BAT aircraft	main_area	35	9	Low	25.71	2026-02-05 16:17:00.045132
8363	5	Ex- Barista Robot	main_area	35	1	Low	2.86	2026-02-05 16:18:00.007304
8364	3	In- Fixar aircraft	main_area	35	3	Low	8.57	2026-02-05 16:18:00.007304
8365	1	Ex - FlyNow	main_area	35	2	Low	5.71	2026-02-05 16:18:00.007304
8366	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:18:00.007304
8367	2	In - V-BAT aircraft	main_area	35	9	Low	25.71	2026-02-05 16:18:00.007304
8368	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:19:01.557748
8369	5	Ex- Barista Robot	main_area	35	1	Low	2.86	2026-02-05 16:19:01.557748
8370	3	In- Fixar aircraft	main_area	35	3	Low	8.57	2026-02-05 16:19:01.557748
8371	2	In - V-BAT aircraft	main_area	35	8	Low	22.86	2026-02-05 16:19:01.557748
8372	1	Ex - FlyNow	main_area	35	2	Low	5.71	2026-02-05 16:19:01.557748
8373	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:20:00.365452
8374	1	Ex - FlyNow	main_area	35	2	Low	5.71	2026-02-05 16:20:00.365452
8375	2	In - V-BAT aircraft	main_area	35	6	Low	17.14	2026-02-05 16:20:00.365452
8376	3	In- Fixar aircraft	main_area	35	3	Low	8.57	2026-02-05 16:20:00.365452
8377	5	Ex- Barista Robot	main_area	35	1	Low	2.86	2026-02-05 16:20:00.365452
8378	3	In- Fixar aircraft	main_area	35	4	Low	11.43	2026-02-05 16:21:19.159368
8379	2	In - V-BAT aircraft	main_area	35	7	Low	20.00	2026-02-05 16:21:19.159368
8380	1	Ex - FlyNow	main_area	35	3	Low	8.57	2026-02-05 16:21:19.159368
8381	5	Ex- Barista Robot	main_area	35	3	Low	8.57	2026-02-05 16:21:19.159368
8382	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:21:19.159368
8383	1	Ex - FlyNow	main_area	35	4	Low	11.43	2026-02-05 16:22:00.525084
8384	2	In - V-BAT aircraft	main_area	35	10	Low	28.57	2026-02-05 16:22:00.525084
8385	4	Ex- Drones	main_area	35	0	Low	0.00	2026-02-05 16:22:00.525084
8386	5	Ex- Barista Robot	main_area	35	1	Low	2.86	2026-02-05 16:22:00.525084
8387	3	In- Fixar aircraft	main_area	35	8	Low	22.86	2026-02-05 16:22:00.525084
\.


--
-- TOC entry 3718 (class 0 OID 16476)
-- Dependencies: 215
-- Data for Name: crowd_data_03_2025; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_03_2025 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3719 (class 0 OID 16481)
-- Dependencies: 216
-- Data for Name: crowd_data_03_2026; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_03_2026 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3720 (class 0 OID 16486)
-- Dependencies: 217
-- Data for Name: crowd_data_04_2025; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_04_2025 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3721 (class 0 OID 16491)
-- Dependencies: 218
-- Data for Name: crowd_data_04_2026; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_04_2026 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3722 (class 0 OID 16496)
-- Dependencies: 219
-- Data for Name: crowd_data_05_2025; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_05_2025 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3723 (class 0 OID 16501)
-- Dependencies: 220
-- Data for Name: crowd_data_05_2026; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_05_2026 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3724 (class 0 OID 16506)
-- Dependencies: 221
-- Data for Name: crowd_data_06_2025; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_06_2025 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3725 (class 0 OID 16511)
-- Dependencies: 222
-- Data for Name: crowd_data_06_2026; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_06_2026 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3726 (class 0 OID 16516)
-- Dependencies: 223
-- Data for Name: crowd_data_07_2025; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_07_2025 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3727 (class 0 OID 16521)
-- Dependencies: 224
-- Data for Name: crowd_data_07_2026; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_07_2026 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3728 (class 0 OID 16526)
-- Dependencies: 225
-- Data for Name: crowd_data_08_2025; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_08_2025 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3729 (class 0 OID 16531)
-- Dependencies: 226
-- Data for Name: crowd_data_08_2026; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_08_2026 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3730 (class 0 OID 16536)
-- Dependencies: 227
-- Data for Name: crowd_data_09_2025; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_09_2025 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3731 (class 0 OID 16541)
-- Dependencies: 228
-- Data for Name: crowd_data_09_2026; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_09_2026 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3732 (class 0 OID 16546)
-- Dependencies: 229
-- Data for Name: crowd_data_10_2025; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_10_2025 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3733 (class 0 OID 16551)
-- Dependencies: 230
-- Data for Name: crowd_data_10_2026; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_10_2026 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3734 (class 0 OID 16556)
-- Dependencies: 231
-- Data for Name: crowd_data_11_2025; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_11_2025 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3735 (class 0 OID 16561)
-- Dependencies: 232
-- Data for Name: crowd_data_11_2026; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_11_2026 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3736 (class 0 OID 16566)
-- Dependencies: 233
-- Data for Name: crowd_data_12_2024; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_12_2024 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3737 (class 0 OID 16571)
-- Dependencies: 234
-- Data for Name: crowd_data_12_2025; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_12_2025 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3738 (class 0 OID 16576)
-- Dependencies: 235
-- Data for Name: crowd_data_12_2026; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crowd_data_12_2026 (measurement_id, camera_id, zone_name, area_name, capacity, number_of_people, crowding_level, crowding_percentage, measured_at) FROM stdin;
\.


--
-- TOC entry 3739 (class 0 OID 16581)
-- Dependencies: 236
-- Data for Name: face_recognition; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.face_recognition (zone, camera_id, person_name, "position", status, "timestamp") FROM stdin;
robotics_lab	3	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-03 08:30:38
robotics_lab	2	Mohammed_Hussain	Robotics Engineer	white	2026-02-03 08:39:09
robotics_lab	3	Ibrahim_SheikhMohammed	Robotics Engineer	white	2026-02-03 08:48:09
robotics_lab	3	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-03 08:50:39
robotics_lab	3	Said Ankoud	Head of Logistics	black	2026-02-03 09:02:53
showroom	4	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-03 09:08:13
robotics_lab	3	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-03 09:15:59
robotics_lab	2	Mahmoud_Alhayes	UAV Engineer	black	2026-02-03 09:16:30
marketing-&-sales	5	Mahmoud_Alhayes	UAV Engineer	black	2026-02-03 09:16:38
marketing-&-sales	5	Ibrahim_Alrumikhany	Account Manager	white	2026-02-03 09:24:07
robotics_lab	2	Mohammed_Hussain	Robotics Engineer	white	2026-02-03 09:29:31
robotics_lab	2	Ibrahim_SheikhMohammed	Robotics Engineer	white	2026-02-03 09:33:38
marketing-&-sales	5	Mohammed_Hussain	Robotics Engineer	white	2026-02-03 12:41:20
marketing-&-sales	5	Nabil	Software developer	white	2026-02-03 12:46:05
robotics_lab	2	Mohammed_AlTalla	Humanoid Robot	black	2026-02-03 12:53:00
marketing-&-sales	5	Sarah_AlTujjar	AI Developer	white	2026-02-03 12:58:57
marketing-&-sales	5	Said Ankoud	Head of Logistics	black	2026-02-03 13:00:15
robotics_lab	2	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-03 13:06:22
robotics_lab	3	Momin_Ali	Senior AI Engineer	white	2026-02-03 13:16:30
robotics_lab	2	Said Ankoud	Head of Logistics	black	2026-02-03 13:17:15
marketing-&-sales	5	Ibrahim_SheikhMohammed	Robotics Engineer	white	2026-02-03 13:24:54
marketing-&-sales	5	Yousef_Fathallah	VP of Operation	black	2026-02-03 13:26:01
robotics_lab	3	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-03 13:26:24
marketing-&-sales	5	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-03 13:26:37
marketing-&-sales	5	Sarah_AlTujjar	AI Developer	white	2026-02-03 13:32:08
robotics_lab	2	Ibrahim_SheikhMohammed	Robotics Engineer	white	2026-02-03 13:35:11
robotics_lab	3	Abdullah_Yahya	Automation Section Head	white	2026-02-03 13:45:21
marketing-&-sales	5	Abdullah_Yahya	Automation Section Head	white	2026-02-03 13:46:09
robotics_lab	2	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-03 13:46:46
robotics_lab	2	Mohammed_Hussain	Robotics Engineer	white	2026-02-03 13:56:25
robotics_lab	2	Ibrahim_SheikhMohammed	Robotics Engineer	white	2026-02-03 13:59:23
robotics_lab	2	Mahmoud_Alhayes	UAV Engineer	black	2026-02-03 14:02:17
robotics_lab	2	Abdullah_Yahya	Automation Section Head	white	2026-02-03 14:05:22
robotics_lab	2	Helmi_Judeh	Commercial VP	black	2026-02-03 14:08:10
robotics_lab	2	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-03 14:28:21
robotics_lab	2	Mahmoud_Alhayes	UAV Engineer	black	2026-02-03 14:29:12
robotics_lab	2	Ibrahim_SheikhMohammed	Robotics Engineer	white	2026-02-03 14:34:31
robotics_lab	3	Mohammed_AlTalla	Humanoid Robot	black	2026-02-03 14:34:35
robotics_lab	1	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-03 15:08:49
robotics_lab	2	Mahmoud_Alhayes	UAV Engineer	black	2026-02-03 15:23:19
marketing-&-sales	5	Mohammed_AlTalla	Humanoid Robot	black	2026-02-03 15:23:22
marketing-&-sales	5	Mahmoud_Alhayes	UAV Engineer	black	2026-02-03 15:24:37
robotics_lab	2	Ibrahim_SheikhMohammed	Robotics Engineer	white	2026-02-03 15:24:46
showroom	4	Jehad_Shaheen	Software Engineer	white	2026-02-03 15:37:50
robotics_lab	3	Mohammed_Hussain	Robotics Engineer	white	2026-02-03 15:39:36
robotics_lab	3	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-03 15:41:17
marketing-&-sales	5	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-03 15:43:14
robotics_lab	2	Abdullah_Yahya	Automation Section Head	white	2026-02-03 15:44:41
marketing-&-sales	5	Mohammed_AlTalla	Humanoid Robot	black	2026-02-03 15:46:51
robotics_lab	3	Mahmoud_Alhayes	UAV Engineer	black	2026-02-03 15:49:14
robotics_lab	1	Mohammed_AlTalla	Humanoid Robot	black	2026-02-03 15:55:03
robotics_lab	1	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-03 16:01:30
robotics_lab	2	Mohammed_Hussain	Robotics Engineer	white	2026-02-03 16:06:45
marketing-&-sales	5	Ibrahim_SheikhMohammed	Robotics Engineer	white	2026-02-03 16:17:24
robotics_lab	2	Ibrahim_SheikhMohammed	Robotics Engineer	white	2026-02-03 16:18:06
robotics_lab	1	Mahmoud_Alhayes	UAV Engineer	black	2026-02-03 16:21:57
robotics_lab	2	Abdullah_Yahya	Automation Section Head	white	2026-02-03 16:22:14
robotics_lab	1	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-03 16:22:34
marketing-&-sales	5	Nabil	Software developer	white	2026-02-03 16:36:18
robotics_lab	1	Abdullah_Yahya	Automation Section Head	white	2026-02-03 17:05:50
robotics_lab	2	Ibrahim_SheikhMohammed	Robotics Engineer	white	2026-02-03 17:14:48
marketing-&-sales	5	Abdullah_Yahya	Automation Section Head	white	2026-02-03 17:17:09
showroom	4	Ibrahim_SheikhMohammed	Robotics Engineer	white	2026-02-03 17:20:15
robotics_lab	2	Mahmoud_Alhayes	UAV Engineer	black	2026-02-03 17:31:01
robotics_lab	2	Ibrahim_SheikhMohammed	Robotics Engineer	white	2026-02-03 17:35:26
robotics_lab	2	Abdullah_Yahya	Automation Section Head	white	2026-02-03 17:38:03
showroom	4	Abdullah_Yahya	Automation Section Head	white	2026-02-03 17:39:26
marketing-&-sales	5	Abdullah_Yahya	Automation Section Head	white	2026-02-03 17:51:27
robotics_lab	2	Mahmoud_Alhayes	UAV Engineer	black	2026-02-03 17:55:16
robotics_lab	2	Abdullah_Yahya	Automation Section Head	white	2026-02-03 17:59:51
marketing-&-sales	5	Bilal_Anwar	frontend Developer	black	2026-02-03 18:09:34
robotics_lab	2	Abdullah_Yahya	Automation Section Head	white	2026-02-03 18:19:58
robotics_lab	2	Ibrahim_SheikhMohammed	Robotics Engineer	white	2026-02-03 18:50:10
robotics_lab	2	Mahmoud_Alhayes	UAV Engineer	black	2026-02-03 18:57:40
robotics_lab	2	Abdullah_Yahya	Automation Section Head	white	2026-02-03 18:58:19
robotics_lab	2	Abdullah_Yahya	Automation Section Head	white	2026-02-03 19:20:56
robotics_lab	2	Mahmoud_Alhayes	UAV Engineer	black	2026-02-03 19:35:30
robotics_lab	2	Abdullah_Yahya	Automation Section Head	white	2026-02-03 19:41:02
marketing-&-sales	5	Nabil	Software developer	white	2026-02-03 19:52:35
robotics_lab	3	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 07:52:30
marketing-&-sales	5	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 07:54:10
robotics_lab	3	Mohammed_AlTalla	Humanoid Robot	black	2026-02-04 08:41:07
robotics_lab	1	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 08:45:31
robotics_lab	3	Mohammed_Hussain	Robotics Engineer	white	2026-02-04 08:48:09
robotics_lab	1	Mohammed_AlTalla	Humanoid Robot	black	2026-02-04 09:01:11
robotics_lab	1	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 09:05:59
marketing-&-sales	5	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 09:09:26
robotics_lab	3	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 09:26:33
robotics_lab	1	Yousef_Fathallah	VP of Operation	black	2026-02-04 09:35:30
robotics_lab	1	Mohammed_AlTalla	Humanoid Robot	black	2026-02-04 09:44:16
marketing-&-sales	5	Mohammed_AlTalla	Humanoid Robot	black	2026-02-04 09:44:25
robotics_lab	3	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 09:48:25
Robotics lab	2	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 09:53:57
Robotics lab	3	Mohammed_AlTalla	Humanoid Robot	black	2026-02-04 09:54:42
Robotics lab	2	Mohammed_Hussain	Robotics Engineer	white	2026-02-04 09:56:52
Robotics lab	1	Mahmoud_Alhayes	UAV Engineer	black	2026-02-04 10:10:32
In - V-BAT aircraft	2	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 10:16:22
In - V-BAT aircraft	2	Abdullah_Yahya	Automation Section Head	white	2026-02-04 10:21:15
In - V-BAT aircraft	2	Mohammed_Hussain	Robotics Engineer	white	2026-02-04 10:29:37
In - V-BAT aircraft	2	Jehad_Shaheen	Software Engineer	white	2026-02-04 10:30:05
Ex - FlyNow	1	Jehad_Shaheen	Software Engineer	white	2026-02-04 10:30:34
In- Fixar aircraft	3	Jehad_Shaheen	Software Engineer	white	2026-02-04 10:30:35
Ex - FlyNow	1	Mohammed_AlTalla	Humanoid Robot	black	2026-02-04 10:30:40
Ex- Barista Robot	5	Jehad_Shaheen	Software Engineer	white	2026-02-04 10:36:08
In - V-BAT aircraft	2	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 10:36:24
In - V-BAT aircraft	2	Abdullah_Yahya	Automation Section Head	white	2026-02-04 10:48:07
Ex- Barista Robot	5	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 10:51:05
Ex - FlyNow	1	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 10:53:19
In- Fixar aircraft	3	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 10:53:20
In - V-BAT aircraft	2	Mohammed_Hussain	Robotics Engineer	white	2026-02-04 10:53:50
Ex- Barista Robot	5	Abdullah_Yahya	Automation Section Head	white	2026-02-04 10:54:01
In- Fixar aircraft	3	Mohammed_Hussain	Robotics Engineer	white	2026-02-04 11:00:09
Ex - FlyNow	1	Mohammed_Hussain	Robotics Engineer	white	2026-02-04 11:00:09
In- Fixar aircraft	3	Abdullah_Yahya	Automation Section Head	white	2026-02-04 11:02:24
Ex - FlyNow	1	Abdullah_Yahya	Automation Section Head	white	2026-02-04 11:02:46
In - V-BAT aircraft	2	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 11:04:43
Ex - FlyNow	1	Mohammed_AlTalla	Humanoid Robot	black	2026-02-04 11:07:07
In - V-BAT aircraft	2	Abdullah_Yahya	Automation Section Head	white	2026-02-04 11:08:16
In- Fixar aircraft	3	Mohammed_AlTalla	Humanoid Robot	black	2026-02-04 11:09:20
Ex- Barista Robot	5	Jehad_Shaheen	Software Engineer	white	2026-02-04 11:12:39
In - V-BAT aircraft	2	Yousef_Fathallah	VP of Operation	black	2026-02-04 11:15:09
Ex - FlyNow	1	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 11:15:14
In- Fixar aircraft	3	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 11:15:15
In - V-BAT aircraft	2	Abdullah_Yahya	Automation Section Head	white	2026-02-04 11:39:46
In - V-BAT aircraft	2	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 11:41:05
Ex- Barista Robot	5	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 11:41:20
Ex- Barista Robot	5	Dania_Hamdallah	Senior AI Engineer	white	2026-02-04 11:44:42
Ex- Drones	4	Abdullah_Yahya	Automation Section Head	white	2026-02-04 11:57:18
In - V-BAT aircraft	2	Abdullah_Yahya	Automation Section Head	white	2026-02-04 12:00:01
In- Fixar aircraft	3	Mohammed_AlTalla	Humanoid Robot	black	2026-02-04 12:00:27
Ex - FlyNow	1	Abdullah_Yahya	Automation Section Head	white	2026-02-04 12:01:39
In- Fixar aircraft	3	Abdullah_Yahya	Automation Section Head	white	2026-02-04 12:01:40
Ex- Barista Robot	5	Abdullah_Yahya	Automation Section Head	white	2026-02-04 12:02:21
In - V-BAT aircraft	2	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 12:03:16
In - V-BAT aircraft	2	Mahmoud_Alhayes	UAV Engineer	black	2026-02-04 12:05:14
Ex - FlyNow	1	Mohammed_AlTalla	Humanoid Robot	black	2026-02-04 12:09:45
In - V-BAT aircraft	2	Mohammed_AlTalla	Humanoid Robot	black	2026-02-04 12:16:08
Ex- Barista Robot	5	Mohammed_Hussain	Robotics Engineer	white	2026-02-04 12:18:30
Ex- Barista Robot	5	Mohammed_AlTalla	Humanoid Robot	black	2026-02-04 12:19:04
Ex- Drones	4	Jehad_Shaheen	Software Engineer	white	2026-02-04 12:19:33
Ex- Barista Robot	5	Mahmoud_Alhayes	UAV Engineer	black	2026-02-04 12:22:34
In- Fixar aircraft	3	Mohammed_Hussain	Robotics Engineer	white	2026-02-04 12:23:56
In - V-BAT aircraft	2	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 12:24:01
In - V-BAT aircraft	2	Mohammed_Hussain	Robotics Engineer	white	2026-02-04 12:24:37
In - V-BAT aircraft	2	Abdullah_Yahya	Automation Section Head	white	2026-02-04 12:24:48
Ex - FlyNow	1	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 12:27:09
In- Fixar aircraft	3	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 12:27:10
In - V-BAT aircraft	2	Mahmoud_Alhayes	UAV Engineer	black	2026-02-04 12:31:41
Ex- Barista Robot	5	Abdullah_Yahya	Automation Section Head	white	2026-02-04 12:36:56
Ex- Barista Robot	5	Mohammed_Mousa	Senior 3D Printing Specialist	black	2026-02-04 12:38:42
ie-face	10	Sarah_AlTujjar	AI Developer	white	2026-02-05 16:02:00
ie-face2	11	Sarah_AlTujjar	AI Developer	white	2026-02-05 16:02:20
\.


--
-- TOC entry 3746 (class 0 OID 0)
-- Dependencies: 210
-- Name: crowd_measurements_measurement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.crowd_measurements_measurement_id_seq', 8387, true);


--
-- TOC entry 3396 (class 2606 OID 16588)
-- Name: crowd_measurements crowd_measurements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_measurements
    ADD CONSTRAINT crowd_measurements_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3402 (class 2606 OID 16590)
-- Name: crowd_data_01_2025 crowd_data_01_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_01_2025
    ADD CONSTRAINT crowd_data_01_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3406 (class 2606 OID 16592)
-- Name: crowd_data_01_2026 crowd_data_01_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_01_2026
    ADD CONSTRAINT crowd_data_01_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3410 (class 2606 OID 16594)
-- Name: crowd_data_02_2025 crowd_data_02_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_02_2025
    ADD CONSTRAINT crowd_data_02_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3414 (class 2606 OID 16596)
-- Name: crowd_data_02_2026 crowd_data_02_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_02_2026
    ADD CONSTRAINT crowd_data_02_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3418 (class 2606 OID 16598)
-- Name: crowd_data_03_2025 crowd_data_03_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_03_2025
    ADD CONSTRAINT crowd_data_03_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3422 (class 2606 OID 16600)
-- Name: crowd_data_03_2026 crowd_data_03_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_03_2026
    ADD CONSTRAINT crowd_data_03_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3426 (class 2606 OID 16602)
-- Name: crowd_data_04_2025 crowd_data_04_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_04_2025
    ADD CONSTRAINT crowd_data_04_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3430 (class 2606 OID 16604)
-- Name: crowd_data_04_2026 crowd_data_04_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_04_2026
    ADD CONSTRAINT crowd_data_04_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3434 (class 2606 OID 16606)
-- Name: crowd_data_05_2025 crowd_data_05_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_05_2025
    ADD CONSTRAINT crowd_data_05_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3438 (class 2606 OID 16608)
-- Name: crowd_data_05_2026 crowd_data_05_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_05_2026
    ADD CONSTRAINT crowd_data_05_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3442 (class 2606 OID 16610)
-- Name: crowd_data_06_2025 crowd_data_06_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_06_2025
    ADD CONSTRAINT crowd_data_06_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3446 (class 2606 OID 16612)
-- Name: crowd_data_06_2026 crowd_data_06_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_06_2026
    ADD CONSTRAINT crowd_data_06_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3450 (class 2606 OID 16614)
-- Name: crowd_data_07_2025 crowd_data_07_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_07_2025
    ADD CONSTRAINT crowd_data_07_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3454 (class 2606 OID 16616)
-- Name: crowd_data_07_2026 crowd_data_07_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_07_2026
    ADD CONSTRAINT crowd_data_07_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3458 (class 2606 OID 16618)
-- Name: crowd_data_08_2025 crowd_data_08_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_08_2025
    ADD CONSTRAINT crowd_data_08_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3462 (class 2606 OID 16620)
-- Name: crowd_data_08_2026 crowd_data_08_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_08_2026
    ADD CONSTRAINT crowd_data_08_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3466 (class 2606 OID 16622)
-- Name: crowd_data_09_2025 crowd_data_09_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_09_2025
    ADD CONSTRAINT crowd_data_09_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3470 (class 2606 OID 16624)
-- Name: crowd_data_09_2026 crowd_data_09_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_09_2026
    ADD CONSTRAINT crowd_data_09_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3474 (class 2606 OID 16626)
-- Name: crowd_data_10_2025 crowd_data_10_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_10_2025
    ADD CONSTRAINT crowd_data_10_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3478 (class 2606 OID 16628)
-- Name: crowd_data_10_2026 crowd_data_10_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_10_2026
    ADD CONSTRAINT crowd_data_10_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3482 (class 2606 OID 16630)
-- Name: crowd_data_11_2025 crowd_data_11_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_11_2025
    ADD CONSTRAINT crowd_data_11_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3486 (class 2606 OID 16632)
-- Name: crowd_data_11_2026 crowd_data_11_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_11_2026
    ADD CONSTRAINT crowd_data_11_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3490 (class 2606 OID 16634)
-- Name: crowd_data_12_2024 crowd_data_12_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_12_2024
    ADD CONSTRAINT crowd_data_12_2024_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3494 (class 2606 OID 16636)
-- Name: crowd_data_12_2025 crowd_data_12_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_12_2025
    ADD CONSTRAINT crowd_data_12_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3498 (class 2606 OID 16638)
-- Name: crowd_data_12_2026 crowd_data_12_2026_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crowd_data_12_2026
    ADD CONSTRAINT crowd_data_12_2026_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- TOC entry 3397 (class 1259 OID 16639)
-- Name: idx_crowd_measurements_camera_zone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_crowd_measurements_camera_zone ON ONLY public.crowd_measurements USING btree (camera_id, zone_name);


--
-- TOC entry 3399 (class 1259 OID 16640)
-- Name: crowd_data_01_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_01_2025_camera_id_zone_name_idx ON public.crowd_data_01_2025 USING btree (camera_id, zone_name);


--
-- TOC entry 3398 (class 1259 OID 16641)
-- Name: idx_crowd_measurements_measured_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_crowd_measurements_measured_at ON ONLY public.crowd_measurements USING btree (measured_at);


--
-- TOC entry 3400 (class 1259 OID 16642)
-- Name: crowd_data_01_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_01_2025_measured_at_idx ON public.crowd_data_01_2025 USING btree (measured_at);


--
-- TOC entry 3403 (class 1259 OID 16643)
-- Name: crowd_data_01_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_01_2026_camera_id_zone_name_idx ON public.crowd_data_01_2026 USING btree (camera_id, zone_name);


--
-- TOC entry 3404 (class 1259 OID 16644)
-- Name: crowd_data_01_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_01_2026_measured_at_idx ON public.crowd_data_01_2026 USING btree (measured_at);


--
-- TOC entry 3407 (class 1259 OID 16645)
-- Name: crowd_data_02_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_02_2025_camera_id_zone_name_idx ON public.crowd_data_02_2025 USING btree (camera_id, zone_name);


--
-- TOC entry 3408 (class 1259 OID 16646)
-- Name: crowd_data_02_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_02_2025_measured_at_idx ON public.crowd_data_02_2025 USING btree (measured_at);


--
-- TOC entry 3411 (class 1259 OID 16647)
-- Name: crowd_data_02_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_02_2026_camera_id_zone_name_idx ON public.crowd_data_02_2026 USING btree (camera_id, zone_name);


--
-- TOC entry 3412 (class 1259 OID 16648)
-- Name: crowd_data_02_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_02_2026_measured_at_idx ON public.crowd_data_02_2026 USING btree (measured_at);


--
-- TOC entry 3415 (class 1259 OID 16649)
-- Name: crowd_data_03_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_03_2025_camera_id_zone_name_idx ON public.crowd_data_03_2025 USING btree (camera_id, zone_name);


--
-- TOC entry 3416 (class 1259 OID 16650)
-- Name: crowd_data_03_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_03_2025_measured_at_idx ON public.crowd_data_03_2025 USING btree (measured_at);


--
-- TOC entry 3419 (class 1259 OID 16651)
-- Name: crowd_data_03_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_03_2026_camera_id_zone_name_idx ON public.crowd_data_03_2026 USING btree (camera_id, zone_name);


--
-- TOC entry 3420 (class 1259 OID 16652)
-- Name: crowd_data_03_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_03_2026_measured_at_idx ON public.crowd_data_03_2026 USING btree (measured_at);


--
-- TOC entry 3423 (class 1259 OID 16653)
-- Name: crowd_data_04_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_04_2025_camera_id_zone_name_idx ON public.crowd_data_04_2025 USING btree (camera_id, zone_name);


--
-- TOC entry 3424 (class 1259 OID 16654)
-- Name: crowd_data_04_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_04_2025_measured_at_idx ON public.crowd_data_04_2025 USING btree (measured_at);


--
-- TOC entry 3427 (class 1259 OID 16655)
-- Name: crowd_data_04_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_04_2026_camera_id_zone_name_idx ON public.crowd_data_04_2026 USING btree (camera_id, zone_name);


--
-- TOC entry 3428 (class 1259 OID 16656)
-- Name: crowd_data_04_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_04_2026_measured_at_idx ON public.crowd_data_04_2026 USING btree (measured_at);


--
-- TOC entry 3431 (class 1259 OID 16657)
-- Name: crowd_data_05_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_05_2025_camera_id_zone_name_idx ON public.crowd_data_05_2025 USING btree (camera_id, zone_name);


--
-- TOC entry 3432 (class 1259 OID 16658)
-- Name: crowd_data_05_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_05_2025_measured_at_idx ON public.crowd_data_05_2025 USING btree (measured_at);


--
-- TOC entry 3435 (class 1259 OID 16659)
-- Name: crowd_data_05_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_05_2026_camera_id_zone_name_idx ON public.crowd_data_05_2026 USING btree (camera_id, zone_name);


--
-- TOC entry 3436 (class 1259 OID 16660)
-- Name: crowd_data_05_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_05_2026_measured_at_idx ON public.crowd_data_05_2026 USING btree (measured_at);


--
-- TOC entry 3439 (class 1259 OID 16661)
-- Name: crowd_data_06_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_06_2025_camera_id_zone_name_idx ON public.crowd_data_06_2025 USING btree (camera_id, zone_name);


--
-- TOC entry 3440 (class 1259 OID 16662)
-- Name: crowd_data_06_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_06_2025_measured_at_idx ON public.crowd_data_06_2025 USING btree (measured_at);


--
-- TOC entry 3443 (class 1259 OID 16663)
-- Name: crowd_data_06_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_06_2026_camera_id_zone_name_idx ON public.crowd_data_06_2026 USING btree (camera_id, zone_name);


--
-- TOC entry 3444 (class 1259 OID 16664)
-- Name: crowd_data_06_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_06_2026_measured_at_idx ON public.crowd_data_06_2026 USING btree (measured_at);


--
-- TOC entry 3447 (class 1259 OID 16665)
-- Name: crowd_data_07_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_07_2025_camera_id_zone_name_idx ON public.crowd_data_07_2025 USING btree (camera_id, zone_name);


--
-- TOC entry 3448 (class 1259 OID 16666)
-- Name: crowd_data_07_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_07_2025_measured_at_idx ON public.crowd_data_07_2025 USING btree (measured_at);


--
-- TOC entry 3451 (class 1259 OID 16667)
-- Name: crowd_data_07_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_07_2026_camera_id_zone_name_idx ON public.crowd_data_07_2026 USING btree (camera_id, zone_name);


--
-- TOC entry 3452 (class 1259 OID 16668)
-- Name: crowd_data_07_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_07_2026_measured_at_idx ON public.crowd_data_07_2026 USING btree (measured_at);


--
-- TOC entry 3455 (class 1259 OID 16669)
-- Name: crowd_data_08_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_08_2025_camera_id_zone_name_idx ON public.crowd_data_08_2025 USING btree (camera_id, zone_name);


--
-- TOC entry 3456 (class 1259 OID 16670)
-- Name: crowd_data_08_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_08_2025_measured_at_idx ON public.crowd_data_08_2025 USING btree (measured_at);


--
-- TOC entry 3459 (class 1259 OID 16671)
-- Name: crowd_data_08_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_08_2026_camera_id_zone_name_idx ON public.crowd_data_08_2026 USING btree (camera_id, zone_name);


--
-- TOC entry 3460 (class 1259 OID 16672)
-- Name: crowd_data_08_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_08_2026_measured_at_idx ON public.crowd_data_08_2026 USING btree (measured_at);


--
-- TOC entry 3463 (class 1259 OID 16673)
-- Name: crowd_data_09_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_09_2025_camera_id_zone_name_idx ON public.crowd_data_09_2025 USING btree (camera_id, zone_name);


--
-- TOC entry 3464 (class 1259 OID 16674)
-- Name: crowd_data_09_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_09_2025_measured_at_idx ON public.crowd_data_09_2025 USING btree (measured_at);


--
-- TOC entry 3467 (class 1259 OID 16675)
-- Name: crowd_data_09_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_09_2026_camera_id_zone_name_idx ON public.crowd_data_09_2026 USING btree (camera_id, zone_name);


--
-- TOC entry 3468 (class 1259 OID 16676)
-- Name: crowd_data_09_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_09_2026_measured_at_idx ON public.crowd_data_09_2026 USING btree (measured_at);


--
-- TOC entry 3471 (class 1259 OID 16677)
-- Name: crowd_data_10_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_10_2025_camera_id_zone_name_idx ON public.crowd_data_10_2025 USING btree (camera_id, zone_name);


--
-- TOC entry 3472 (class 1259 OID 16678)
-- Name: crowd_data_10_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_10_2025_measured_at_idx ON public.crowd_data_10_2025 USING btree (measured_at);


--
-- TOC entry 3475 (class 1259 OID 16679)
-- Name: crowd_data_10_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_10_2026_camera_id_zone_name_idx ON public.crowd_data_10_2026 USING btree (camera_id, zone_name);


--
-- TOC entry 3476 (class 1259 OID 16680)
-- Name: crowd_data_10_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_10_2026_measured_at_idx ON public.crowd_data_10_2026 USING btree (measured_at);


--
-- TOC entry 3479 (class 1259 OID 16681)
-- Name: crowd_data_11_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_11_2025_camera_id_zone_name_idx ON public.crowd_data_11_2025 USING btree (camera_id, zone_name);


--
-- TOC entry 3480 (class 1259 OID 16682)
-- Name: crowd_data_11_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_11_2025_measured_at_idx ON public.crowd_data_11_2025 USING btree (measured_at);


--
-- TOC entry 3483 (class 1259 OID 16683)
-- Name: crowd_data_11_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_11_2026_camera_id_zone_name_idx ON public.crowd_data_11_2026 USING btree (camera_id, zone_name);


--
-- TOC entry 3484 (class 1259 OID 16684)
-- Name: crowd_data_11_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_11_2026_measured_at_idx ON public.crowd_data_11_2026 USING btree (measured_at);


--
-- TOC entry 3487 (class 1259 OID 16685)
-- Name: crowd_data_12_2024_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_12_2024_camera_id_zone_name_idx ON public.crowd_data_12_2024 USING btree (camera_id, zone_name);


--
-- TOC entry 3488 (class 1259 OID 16686)
-- Name: crowd_data_12_2024_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_12_2024_measured_at_idx ON public.crowd_data_12_2024 USING btree (measured_at);


--
-- TOC entry 3491 (class 1259 OID 16687)
-- Name: crowd_data_12_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_12_2025_camera_id_zone_name_idx ON public.crowd_data_12_2025 USING btree (camera_id, zone_name);


--
-- TOC entry 3492 (class 1259 OID 16688)
-- Name: crowd_data_12_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_12_2025_measured_at_idx ON public.crowd_data_12_2025 USING btree (measured_at);


--
-- TOC entry 3495 (class 1259 OID 16689)
-- Name: crowd_data_12_2026_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_12_2026_camera_id_zone_name_idx ON public.crowd_data_12_2026 USING btree (camera_id, zone_name);


--
-- TOC entry 3496 (class 1259 OID 16690)
-- Name: crowd_data_12_2026_measured_at_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX crowd_data_12_2026_measured_at_idx ON public.crowd_data_12_2026 USING btree (measured_at);


--
-- TOC entry 3499 (class 0 OID 0)
-- Name: crowd_data_01_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_01_2025_camera_id_zone_name_idx;


--
-- TOC entry 3500 (class 0 OID 0)
-- Name: crowd_data_01_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_01_2025_measured_at_idx;


--
-- TOC entry 3501 (class 0 OID 0)
-- Name: crowd_data_01_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_01_2025_pkey;


--
-- TOC entry 3502 (class 0 OID 0)
-- Name: crowd_data_01_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_01_2026_camera_id_zone_name_idx;


--
-- TOC entry 3503 (class 0 OID 0)
-- Name: crowd_data_01_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_01_2026_measured_at_idx;


--
-- TOC entry 3504 (class 0 OID 0)
-- Name: crowd_data_01_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_01_2026_pkey;


--
-- TOC entry 3505 (class 0 OID 0)
-- Name: crowd_data_02_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_02_2025_camera_id_zone_name_idx;


--
-- TOC entry 3506 (class 0 OID 0)
-- Name: crowd_data_02_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_02_2025_measured_at_idx;


--
-- TOC entry 3507 (class 0 OID 0)
-- Name: crowd_data_02_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_02_2025_pkey;


--
-- TOC entry 3508 (class 0 OID 0)
-- Name: crowd_data_02_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_02_2026_camera_id_zone_name_idx;


--
-- TOC entry 3509 (class 0 OID 0)
-- Name: crowd_data_02_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_02_2026_measured_at_idx;


--
-- TOC entry 3510 (class 0 OID 0)
-- Name: crowd_data_02_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_02_2026_pkey;


--
-- TOC entry 3511 (class 0 OID 0)
-- Name: crowd_data_03_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_03_2025_camera_id_zone_name_idx;


--
-- TOC entry 3512 (class 0 OID 0)
-- Name: crowd_data_03_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_03_2025_measured_at_idx;


--
-- TOC entry 3513 (class 0 OID 0)
-- Name: crowd_data_03_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_03_2025_pkey;


--
-- TOC entry 3514 (class 0 OID 0)
-- Name: crowd_data_03_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_03_2026_camera_id_zone_name_idx;


--
-- TOC entry 3515 (class 0 OID 0)
-- Name: crowd_data_03_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_03_2026_measured_at_idx;


--
-- TOC entry 3516 (class 0 OID 0)
-- Name: crowd_data_03_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_03_2026_pkey;


--
-- TOC entry 3517 (class 0 OID 0)
-- Name: crowd_data_04_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_04_2025_camera_id_zone_name_idx;


--
-- TOC entry 3518 (class 0 OID 0)
-- Name: crowd_data_04_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_04_2025_measured_at_idx;


--
-- TOC entry 3519 (class 0 OID 0)
-- Name: crowd_data_04_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_04_2025_pkey;


--
-- TOC entry 3520 (class 0 OID 0)
-- Name: crowd_data_04_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_04_2026_camera_id_zone_name_idx;


--
-- TOC entry 3521 (class 0 OID 0)
-- Name: crowd_data_04_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_04_2026_measured_at_idx;


--
-- TOC entry 3522 (class 0 OID 0)
-- Name: crowd_data_04_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_04_2026_pkey;


--
-- TOC entry 3523 (class 0 OID 0)
-- Name: crowd_data_05_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_05_2025_camera_id_zone_name_idx;


--
-- TOC entry 3524 (class 0 OID 0)
-- Name: crowd_data_05_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_05_2025_measured_at_idx;


--
-- TOC entry 3525 (class 0 OID 0)
-- Name: crowd_data_05_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_05_2025_pkey;


--
-- TOC entry 3526 (class 0 OID 0)
-- Name: crowd_data_05_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_05_2026_camera_id_zone_name_idx;


--
-- TOC entry 3527 (class 0 OID 0)
-- Name: crowd_data_05_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_05_2026_measured_at_idx;


--
-- TOC entry 3528 (class 0 OID 0)
-- Name: crowd_data_05_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_05_2026_pkey;


--
-- TOC entry 3529 (class 0 OID 0)
-- Name: crowd_data_06_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_06_2025_camera_id_zone_name_idx;


--
-- TOC entry 3530 (class 0 OID 0)
-- Name: crowd_data_06_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_06_2025_measured_at_idx;


--
-- TOC entry 3531 (class 0 OID 0)
-- Name: crowd_data_06_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_06_2025_pkey;


--
-- TOC entry 3532 (class 0 OID 0)
-- Name: crowd_data_06_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_06_2026_camera_id_zone_name_idx;


--
-- TOC entry 3533 (class 0 OID 0)
-- Name: crowd_data_06_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_06_2026_measured_at_idx;


--
-- TOC entry 3534 (class 0 OID 0)
-- Name: crowd_data_06_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_06_2026_pkey;


--
-- TOC entry 3535 (class 0 OID 0)
-- Name: crowd_data_07_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_07_2025_camera_id_zone_name_idx;


--
-- TOC entry 3536 (class 0 OID 0)
-- Name: crowd_data_07_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_07_2025_measured_at_idx;


--
-- TOC entry 3537 (class 0 OID 0)
-- Name: crowd_data_07_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_07_2025_pkey;


--
-- TOC entry 3538 (class 0 OID 0)
-- Name: crowd_data_07_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_07_2026_camera_id_zone_name_idx;


--
-- TOC entry 3539 (class 0 OID 0)
-- Name: crowd_data_07_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_07_2026_measured_at_idx;


--
-- TOC entry 3540 (class 0 OID 0)
-- Name: crowd_data_07_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_07_2026_pkey;


--
-- TOC entry 3541 (class 0 OID 0)
-- Name: crowd_data_08_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_08_2025_camera_id_zone_name_idx;


--
-- TOC entry 3542 (class 0 OID 0)
-- Name: crowd_data_08_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_08_2025_measured_at_idx;


--
-- TOC entry 3543 (class 0 OID 0)
-- Name: crowd_data_08_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_08_2025_pkey;


--
-- TOC entry 3544 (class 0 OID 0)
-- Name: crowd_data_08_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_08_2026_camera_id_zone_name_idx;


--
-- TOC entry 3545 (class 0 OID 0)
-- Name: crowd_data_08_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_08_2026_measured_at_idx;


--
-- TOC entry 3546 (class 0 OID 0)
-- Name: crowd_data_08_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_08_2026_pkey;


--
-- TOC entry 3547 (class 0 OID 0)
-- Name: crowd_data_09_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_09_2025_camera_id_zone_name_idx;


--
-- TOC entry 3548 (class 0 OID 0)
-- Name: crowd_data_09_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_09_2025_measured_at_idx;


--
-- TOC entry 3549 (class 0 OID 0)
-- Name: crowd_data_09_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_09_2025_pkey;


--
-- TOC entry 3550 (class 0 OID 0)
-- Name: crowd_data_09_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_09_2026_camera_id_zone_name_idx;


--
-- TOC entry 3551 (class 0 OID 0)
-- Name: crowd_data_09_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_09_2026_measured_at_idx;


--
-- TOC entry 3552 (class 0 OID 0)
-- Name: crowd_data_09_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_09_2026_pkey;


--
-- TOC entry 3553 (class 0 OID 0)
-- Name: crowd_data_10_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_10_2025_camera_id_zone_name_idx;


--
-- TOC entry 3554 (class 0 OID 0)
-- Name: crowd_data_10_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_10_2025_measured_at_idx;


--
-- TOC entry 3555 (class 0 OID 0)
-- Name: crowd_data_10_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_10_2025_pkey;


--
-- TOC entry 3556 (class 0 OID 0)
-- Name: crowd_data_10_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_10_2026_camera_id_zone_name_idx;


--
-- TOC entry 3557 (class 0 OID 0)
-- Name: crowd_data_10_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_10_2026_measured_at_idx;


--
-- TOC entry 3558 (class 0 OID 0)
-- Name: crowd_data_10_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_10_2026_pkey;


--
-- TOC entry 3559 (class 0 OID 0)
-- Name: crowd_data_11_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_11_2025_camera_id_zone_name_idx;


--
-- TOC entry 3560 (class 0 OID 0)
-- Name: crowd_data_11_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_11_2025_measured_at_idx;


--
-- TOC entry 3561 (class 0 OID 0)
-- Name: crowd_data_11_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_11_2025_pkey;


--
-- TOC entry 3562 (class 0 OID 0)
-- Name: crowd_data_11_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_11_2026_camera_id_zone_name_idx;


--
-- TOC entry 3563 (class 0 OID 0)
-- Name: crowd_data_11_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_11_2026_measured_at_idx;


--
-- TOC entry 3564 (class 0 OID 0)
-- Name: crowd_data_11_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_11_2026_pkey;


--
-- TOC entry 3565 (class 0 OID 0)
-- Name: crowd_data_12_2024_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_12_2024_camera_id_zone_name_idx;


--
-- TOC entry 3566 (class 0 OID 0)
-- Name: crowd_data_12_2024_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_12_2024_measured_at_idx;


--
-- TOC entry 3567 (class 0 OID 0)
-- Name: crowd_data_12_2024_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_12_2024_pkey;


--
-- TOC entry 3568 (class 0 OID 0)
-- Name: crowd_data_12_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_12_2025_camera_id_zone_name_idx;


--
-- TOC entry 3569 (class 0 OID 0)
-- Name: crowd_data_12_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_12_2025_measured_at_idx;


--
-- TOC entry 3570 (class 0 OID 0)
-- Name: crowd_data_12_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_12_2025_pkey;


--
-- TOC entry 3571 (class 0 OID 0)
-- Name: crowd_data_12_2026_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_12_2026_camera_id_zone_name_idx;


--
-- TOC entry 3572 (class 0 OID 0)
-- Name: crowd_data_12_2026_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_12_2026_measured_at_idx;


--
-- TOC entry 3573 (class 0 OID 0)
-- Name: crowd_data_12_2026_pkey; Type: INDEX ATTACH; Schema: public; Owner: -
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_12_2026_pkey;


-- Completed on 2026-02-05 16:22:44 +03

--
-- PostgreSQL database dump complete
--

\unrestrict MtiULA0JqByUVlNLq9zK0BV2Nnz0yQ6HuEWVS5LrLk27jThEygDG52Z4KWWNBH8

