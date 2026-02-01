--
-- PostgreSQL database dump
--

\restrict SbdXV0LmRecoOSxLbUWkxbG6p5Q207fmsCsSeEL2SSKPgGbOrrRvdUnd7e7ouY9

-- Dumped from database version 14.19 (Ubuntu 14.19-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.19 (Ubuntu 14.19-0ubuntu0.22.04.1)

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

SET default_table_access_method = heap;

--
-- Name: areas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.areas (
    area_id integer NOT NULL,
    zone_id integer,
    area_name character varying(100) NOT NULL
);


ALTER TABLE public.areas OWNER TO postgres;

--
-- Name: areas_area_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.areas_area_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.areas_area_id_seq OWNER TO postgres;

--
-- Name: areas_area_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.areas_area_id_seq OWNED BY public.areas.area_id;


--
-- Name: camera_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.camera_config (
    config_id integer NOT NULL,
    resize_scale double precision NOT NULL,
    reconnect_delay integer NOT NULL,
    max_retries integer NOT NULL,
    status_update_interval integer NOT NULL,
    frame_rate integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.camera_config OWNER TO postgres;

--
-- Name: camera_config_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.camera_config_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.camera_config_config_id_seq OWNER TO postgres;

--
-- Name: camera_config_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.camera_config_config_id_seq OWNED BY public.camera_config.config_id;


--
-- Name: cameras; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cameras (
    camera_id integer NOT NULL,
    area_id integer,
    ip_address character varying(15) NOT NULL,
    port character varying(5) NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(50) NOT NULL,
    channel character varying(10) NOT NULL,
    rtsp_url text NOT NULL,
    capacities integer NOT NULL,
    enabled boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.cameras OWNER TO postgres;

--
-- Name: cameras_camera_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cameras_camera_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cameras_camera_id_seq OWNER TO postgres;

--
-- Name: cameras_camera_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cameras_camera_id_seq OWNED BY public.cameras.camera_id;


--
-- Name: zones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zones (
    zone_id integer NOT NULL,
    zone_name character varying(100) NOT NULL
);


ALTER TABLE public.zones OWNER TO postgres;

--
-- Name: zones_zone_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.zones_zone_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.zones_zone_id_seq OWNER TO postgres;

--
-- Name: zones_zone_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.zones_zone_id_seq OWNED BY public.zones.zone_id;


--
-- Name: areas area_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas ALTER COLUMN area_id SET DEFAULT nextval('public.areas_area_id_seq'::regclass);


--
-- Name: camera_config config_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera_config ALTER COLUMN config_id SET DEFAULT nextval('public.camera_config_config_id_seq'::regclass);


--
-- Name: cameras camera_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cameras ALTER COLUMN camera_id SET DEFAULT nextval('public.cameras_camera_id_seq'::regclass);


--
-- Name: zones zone_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zones ALTER COLUMN zone_id SET DEFAULT nextval('public.zones_zone_id_seq'::regclass);


--
-- Data for Name: areas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.areas (area_id, zone_id, area_name) FROM stdin;
1	1	main_area
2	2	main_area
3	3	main_area
4	4	main_area
\.


--
-- Data for Name: camera_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.camera_config (config_id, resize_scale, reconnect_delay, max_retries, status_update_interval, frame_rate, created_at, updated_at) FROM stdin;
1	0.5	1	3	30	30	2024-12-04 11:06:28.791623	2024-12-04 11:06:28.791623
\.


--
-- Data for Name: cameras; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cameras (camera_id, area_id, ip_address, port, username, password, channel, rtsp_url, capacities, enabled, created_at, updated_at) FROM stdin;
3	2	192.168.100.98	80	admin	QSS2030qss@	101	rtsp://admin:QSS2030qss@@192.168.100.98/Streaming/Channels/101	5	t	2024-12-04 02:06:28	2025-08-31 12:11:31.22957
4	3	192.168.100.250	80	admin	QSS2030qss@	101	rtsp://admin:QSS2030qss@@192.168.100.250/Streaming/Channels/101	10	t	2024-12-03 23:06:28	2025-08-31 14:29:40.998279
1	1	192.168.100.208	80	admin	QSS2030QSS	101	rtsp://admin:QSS2030QSS@192.168.100.208/Streaming/Channels/101	10	t	2024-12-04 08:06:28	2025-08-31 14:29:57.191848
2	2	192.168.100.96	80	admin	QSS2030qss@	101	rtsp://admin:QSS2030qss@@192.168.100.96/Streaming/Channels/101	5	t	2024-12-03 20:06:28	2025-09-01 14:08:34.885089
5	4	192.168.100.205	80	admin	QSS2030qss@	101	rtsp://admin:QSS2030qss@@192.168.100.205/Streaming/Channels/101	10	t	2024-12-03 20:06:28	2025-10-20 11:41:46.240179
\.


--
-- Data for Name: zones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.zones (zone_id, zone_name) FROM stdin;
1	software_lab
2	robotics_lab
3	showroom
4	marketing-&-sales
\.


--
-- Name: areas_area_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.areas_area_id_seq', 4, true);


--
-- Name: camera_config_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.camera_config_config_id_seq', 1, true);


--
-- Name: cameras_camera_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cameras_camera_id_seq', 6, true);


--
-- Name: zones_zone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.zones_zone_id_seq', 4, true);


--
-- Name: areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (area_id);


--
-- Name: areas areas_zone_id_area_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_zone_id_area_name_key UNIQUE (zone_id, area_name);


--
-- Name: camera_config camera_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.camera_config
    ADD CONSTRAINT camera_config_pkey PRIMARY KEY (config_id);


--
-- Name: cameras cameras_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cameras
    ADD CONSTRAINT cameras_pkey PRIMARY KEY (camera_id);


--
-- Name: zones zones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zones
    ADD CONSTRAINT zones_pkey PRIMARY KEY (zone_id);


--
-- Name: zones zones_zone_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zones
    ADD CONSTRAINT zones_zone_name_key UNIQUE (zone_name);


--
-- Name: idx_cameras_ip; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cameras_ip ON public.cameras USING btree (ip_address);


--
-- Name: camera_config update_camera_config_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_camera_config_updated_at BEFORE UPDATE ON public.camera_config FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: cameras update_cameras_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_cameras_updated_at BEFORE UPDATE ON public.cameras FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: areas areas_zone_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.areas
    ADD CONSTRAINT areas_zone_id_fkey FOREIGN KEY (zone_id) REFERENCES public.zones(zone_id);


--
-- Name: cameras cameras_area_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cameras
    ADD CONSTRAINT cameras_area_id_fkey FOREIGN KEY (area_id) REFERENCES public.areas(area_id);


--
-- PostgreSQL database dump complete
--

\unrestrict SbdXV0LmRecoOSxLbUWkxbG6p5Q207fmsCsSeEL2SSKPgGbOrrRvdUnd7e7ouY9

