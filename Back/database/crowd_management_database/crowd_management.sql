--
-- PostgreSQL database dump
--

-- Dumped from database version 14.17 (Ubuntu 14.17-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.17 (Ubuntu 14.17-0ubuntu0.22.04.1)

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
-- Name: face_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.face_status AS ENUM (
    'authorized',
    'unauthorized',
    'visitor',
    'employee'
);


ALTER TYPE public.face_status OWNER TO postgres;

--
-- Name: create_monthly_partition(); Type: FUNCTION; Schema: public; Owner: postgres
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


ALTER FUNCTION public.create_monthly_partition() OWNER TO postgres;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: crowd_measurements; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.crowd_measurements OWNER TO postgres;

--
-- Name: crowd_measurements_measurement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.crowd_measurements_measurement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.crowd_measurements_measurement_id_seq OWNER TO postgres;

--
-- Name: crowd_measurements_measurement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.crowd_measurements_measurement_id_seq OWNED BY public.crowd_measurements.measurement_id;


SET default_table_access_method = heap;

--
-- Name: crowd_data_01_2025; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.crowd_data_01_2025 OWNER TO postgres;

--
-- Name: crowd_data_02_2025; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.crowd_data_02_2025 OWNER TO postgres;

--
-- Name: crowd_data_03_2025; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.crowd_data_03_2025 OWNER TO postgres;

--
-- Name: crowd_data_04_2025; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.crowd_data_04_2025 OWNER TO postgres;

--
-- Name: crowd_data_06_2025; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.crowd_data_06_2025 OWNER TO postgres;

--
-- Name: crowd_data_07_2025; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.crowd_data_07_2025 OWNER TO postgres;

--
-- Name: crowd_data_08_2025; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.crowd_data_08_2025 OWNER TO postgres;

--
-- Name: crowd_data_09_2025; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.crowd_data_09_2025 OWNER TO postgres;

--
-- Name: crowd_data_10_2025; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.crowd_data_10_2025 OWNER TO postgres;

--
-- Name: crowd_data_11_2025; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.crowd_data_11_2025 OWNER TO postgres;

--
-- Name: crowd_data_12_2024; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.crowd_data_12_2024 OWNER TO postgres;

--
-- Name: crowd_data_12_2025; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.crowd_data_12_2025 OWNER TO postgres;

--
-- Name: face_recognition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.face_recognition (
    zone text,
    camera_id text,
    person_name text,
    "position" text,
    status text,
    "timestamp" timestamp without time zone
);


ALTER TABLE public.face_recognition OWNER TO postgres;

--
-- Name: crowd_data_01_2025; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_01_2025 FOR VALUES FROM ('2025-01-01 00:00:00') TO ('2025-02-01 00:00:00');


--
-- Name: crowd_data_02_2025; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_02_2025 FOR VALUES FROM ('2025-02-01 00:00:00') TO ('2025-03-01 00:00:00');


--
-- Name: crowd_data_03_2025; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_03_2025 FOR VALUES FROM ('2025-03-01 00:00:00') TO ('2025-04-01 00:00:00');


--
-- Name: crowd_data_04_2025; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_04_2025 FOR VALUES FROM ('2025-04-01 00:00:00') TO ('2025-05-01 00:00:00');


--
-- Name: crowd_data_12_2024; Type: TABLE ATTACH; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_measurements ATTACH PARTITION public.crowd_data_12_2024 FOR VALUES FROM ('2024-12-01 00:00:00') TO ('2025-01-01 00:00:00');


--
-- Name: crowd_measurements measurement_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_measurements ALTER COLUMN measurement_id SET DEFAULT nextval('public.crowd_measurements_measurement_id_seq'::regclass);


--
-- Name: crowd_measurements crowd_measurements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_measurements
    ADD CONSTRAINT crowd_measurements_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_01_2025 crowd_data_01_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_data_01_2025
    ADD CONSTRAINT crowd_data_01_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_02_2025 crowd_data_02_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_data_02_2025
    ADD CONSTRAINT crowd_data_02_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_03_2025 crowd_data_03_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_data_03_2025
    ADD CONSTRAINT crowd_data_03_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_04_2025 crowd_data_04_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_data_04_2025
    ADD CONSTRAINT crowd_data_04_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_06_2025 crowd_data_06_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_data_06_2025
    ADD CONSTRAINT crowd_data_06_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_07_2025 crowd_data_07_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_data_07_2025
    ADD CONSTRAINT crowd_data_07_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_08_2025 crowd_data_08_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_data_08_2025
    ADD CONSTRAINT crowd_data_08_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_09_2025 crowd_data_09_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_data_09_2025
    ADD CONSTRAINT crowd_data_09_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_10_2025 crowd_data_10_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_data_10_2025
    ADD CONSTRAINT crowd_data_10_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_11_2025 crowd_data_11_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_data_11_2025
    ADD CONSTRAINT crowd_data_11_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_12_2024 crowd_data_12_2024_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_data_12_2024
    ADD CONSTRAINT crowd_data_12_2024_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: crowd_data_12_2025 crowd_data_12_2025_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.crowd_data_12_2025
    ADD CONSTRAINT crowd_data_12_2025_pkey PRIMARY KEY (measurement_id, measured_at);


--
-- Name: idx_crowd_measurements_camera_zone; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_crowd_measurements_camera_zone ON ONLY public.crowd_measurements USING btree (camera_id, zone_name);


--
-- Name: crowd_data_01_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_01_2025_camera_id_zone_name_idx ON public.crowd_data_01_2025 USING btree (camera_id, zone_name);


--
-- Name: idx_crowd_measurements_measured_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_crowd_measurements_measured_at ON ONLY public.crowd_measurements USING btree (measured_at);


--
-- Name: crowd_data_01_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_01_2025_measured_at_idx ON public.crowd_data_01_2025 USING btree (measured_at);


--
-- Name: crowd_data_02_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_02_2025_camera_id_zone_name_idx ON public.crowd_data_02_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_02_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_02_2025_measured_at_idx ON public.crowd_data_02_2025 USING btree (measured_at);


--
-- Name: crowd_data_03_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_03_2025_camera_id_zone_name_idx ON public.crowd_data_03_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_03_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_03_2025_measured_at_idx ON public.crowd_data_03_2025 USING btree (measured_at);


--
-- Name: crowd_data_04_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_04_2025_camera_id_zone_name_idx ON public.crowd_data_04_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_04_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_04_2025_measured_at_idx ON public.crowd_data_04_2025 USING btree (measured_at);


--
-- Name: crowd_data_06_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_06_2025_camera_id_zone_name_idx ON public.crowd_data_06_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_06_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_06_2025_measured_at_idx ON public.crowd_data_06_2025 USING btree (measured_at);


--
-- Name: crowd_data_07_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_07_2025_camera_id_zone_name_idx ON public.crowd_data_07_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_07_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_07_2025_measured_at_idx ON public.crowd_data_07_2025 USING btree (measured_at);


--
-- Name: crowd_data_08_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_08_2025_camera_id_zone_name_idx ON public.crowd_data_08_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_08_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_08_2025_measured_at_idx ON public.crowd_data_08_2025 USING btree (measured_at);


--
-- Name: crowd_data_09_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_09_2025_camera_id_zone_name_idx ON public.crowd_data_09_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_09_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_09_2025_measured_at_idx ON public.crowd_data_09_2025 USING btree (measured_at);


--
-- Name: crowd_data_10_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_10_2025_camera_id_zone_name_idx ON public.crowd_data_10_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_10_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_10_2025_measured_at_idx ON public.crowd_data_10_2025 USING btree (measured_at);


--
-- Name: crowd_data_11_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_11_2025_camera_id_zone_name_idx ON public.crowd_data_11_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_11_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_11_2025_measured_at_idx ON public.crowd_data_11_2025 USING btree (measured_at);


--
-- Name: crowd_data_12_2024_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_12_2024_camera_id_zone_name_idx ON public.crowd_data_12_2024 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_12_2024_measured_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_12_2024_measured_at_idx ON public.crowd_data_12_2024 USING btree (measured_at);


--
-- Name: crowd_data_12_2025_camera_id_zone_name_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_12_2025_camera_id_zone_name_idx ON public.crowd_data_12_2025 USING btree (camera_id, zone_name);


--
-- Name: crowd_data_12_2025_measured_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX crowd_data_12_2025_measured_at_idx ON public.crowd_data_12_2025 USING btree (measured_at);


--
-- Name: crowd_data_01_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_01_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_01_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_01_2025_measured_at_idx;


--
-- Name: crowd_data_01_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_01_2025_pkey;


--
-- Name: crowd_data_02_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_02_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_02_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_02_2025_measured_at_idx;


--
-- Name: crowd_data_02_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_02_2025_pkey;


--
-- Name: crowd_data_03_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_03_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_03_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_03_2025_measured_at_idx;


--
-- Name: crowd_data_03_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_03_2025_pkey;


--
-- Name: crowd_data_04_2025_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_04_2025_camera_id_zone_name_idx;


--
-- Name: crowd_data_04_2025_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_04_2025_measured_at_idx;


--
-- Name: crowd_data_04_2025_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_04_2025_pkey;


--
-- Name: crowd_data_12_2024_camera_id_zone_name_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.idx_crowd_measurements_camera_zone ATTACH PARTITION public.crowd_data_12_2024_camera_id_zone_name_idx;


--
-- Name: crowd_data_12_2024_measured_at_idx; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.idx_crowd_measurements_measured_at ATTACH PARTITION public.crowd_data_12_2024_measured_at_idx;


--
-- Name: crowd_data_12_2024_pkey; Type: INDEX ATTACH; Schema: public; Owner: postgres
--

ALTER INDEX public.crowd_measurements_pkey ATTACH PARTITION public.crowd_data_12_2024_pkey;


--
-- PostgreSQL database dump complete
--

