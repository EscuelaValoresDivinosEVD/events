\restrict GY3RbdugoBDDwSSd8c7uA78zF2egyq2Uv2EefArnT3dr0VKaxpmHOMchw8y1yCY

-- Dumped from database version 17.2
-- Dumped by pg_dump version 17.10 (Debian 17.10-1.pgdg12+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: air_tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.air_tickets (
    id integer NOT NULL,
    participant_id integer,
    arrive_at timestamp without time zone,
    arrive_to character varying,
    leave_at timestamp without time zone,
    leave_from character varying,
    estimated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: air_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.air_tickets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: air_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.air_tickets_id_seq OWNED BY public.air_tickets.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: beds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.beds (
    id integer NOT NULL,
    number integer NOT NULL,
    room_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    usable boolean DEFAULT true,
    deleted_at timestamp without time zone
);


--
-- Name: beds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.beds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: beds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.beds_id_seq OWNED BY public.beds.id;


--
-- Name: bookings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.bookings (
    id integer NOT NULL,
    start_date date NOT NULL,
    end_date date,
    bed_id integer NOT NULL,
    guest_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    amount numeric,
    deposit_amount numeric,
    deposit_state character varying DEFAULT 'pending'::character varying,
    deleted_at timestamp without time zone
);


--
-- Name: bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.bookings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.bookings_id_seq OWNED BY public.bookings.id;


--
-- Name: change_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.change_logs (
    id integer NOT NULL,
    change text NOT NULL,
    author_id integer,
    reviewer_id integer,
    is_reviewed boolean DEFAULT true,
    reviewed_at timestamp without time zone,
    logable_type character varying,
    logable_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: change_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.change_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: change_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.change_logs_id_seq OWNED BY public.change_logs.id;


--
-- Name: compositions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.compositions (
    id integer NOT NULL,
    modality_id integer,
    submodality_id integer,
    discount numeric,
    deleted_at timestamp without time zone
);


--
-- Name: compositions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.compositions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: compositions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.compositions_id_seq OWNED BY public.compositions.id;


--
-- Name: configurations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.configurations (
    id integer NOT NULL,
    name character varying,
    value text
);


--
-- Name: configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.configurations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.configurations_id_seq OWNED BY public.configurations.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id integer NOT NULL,
    name character varying,
    start_at date,
    end_at date,
    active boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deposit_amount numeric DEFAULT 0.0,
    international boolean DEFAULT false,
    deleted_at timestamp without time zone
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: guests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guests (
    id integer NOT NULL,
    name character varying NOT NULL,
    surname character varying NOT NULL,
    email character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    country character varying,
    city character varying,
    phone_number character varying,
    mobile_number character varying,
    identification character varying,
    civil_status character varying,
    profession character varying,
    nationality character varying,
    health_condition text,
    receive_drug text,
    symptoms text,
    contact_name character varying,
    contact_kin character varying,
    contact_number character varying,
    hotel character varying,
    local_number character varying,
    comments text,
    is_initiate boolean,
    age integer,
    outside boolean DEFAULT false,
    deleted_at timestamp without time zone,
    swami_name character varying,
    birth_date date
);


--
-- Name: guests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.guests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: guests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.guests_id_seq OWNED BY public.guests.id;


--
-- Name: historicals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.historicals (
    id integer NOT NULL,
    name character varying,
    value numeric,
    start_date date,
    location_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: historicals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.historicals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: historicals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.historicals_id_seq OWNED BY public.historicals.id;


--
-- Name: houses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.houses (
    id integer NOT NULL,
    name character varying NOT NULL,
    sketch character varying,
    location_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    open_stay boolean DEFAULT false,
    deleted_at timestamp without time zone
);


--
-- Name: houses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.houses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: houses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.houses_id_seq OWNED BY public.houses.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: modalities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.modalities (
    id integer NOT NULL,
    name character varying,
    event_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    is_composed boolean DEFAULT false NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: modalities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.modalities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: modalities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.modalities_id_seq OWNED BY public.modalities.id;


--
-- Name: participant_spaces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.participant_spaces (
    id integer NOT NULL,
    participant_id integer,
    space_id integer,
    note character varying,
    deleted_at timestamp without time zone
);


--
-- Name: participant_spaces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.participant_spaces_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participant_spaces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.participant_spaces_id_seq OWNED BY public.participant_spaces.id;


--
-- Name: participants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.participants (
    id integer NOT NULL,
    guest_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deposit_state character varying DEFAULT 'pending'::character varying,
    deleted_at timestamp without time zone
);


--
-- Name: participants_bookings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.participants_bookings (
    participant_id integer,
    booking_id integer
);


--
-- Name: participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.participants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.participants_id_seq OWNED BY public.participants.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    paid_at timestamp without time zone,
    amount numeric,
    description text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    method character varying,
    reason character varying DEFAULT 'Evento'::character varying,
    payable_type character varying,
    payable_id integer,
    deleted_at timestamp without time zone
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: places; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.places (
    id integer NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: places_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.places_events (
    id integer NOT NULL,
    place_id integer,
    event_id integer
);


--
-- Name: places_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.places_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: places_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.places_events_id_seq OWNED BY public.places_events.id;


--
-- Name: places_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.places_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.places_id_seq OWNED BY public.places.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id integer NOT NULL,
    name character varying
);


--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.profiles_id_seq OWNED BY public.profiles.id;


--
-- Name: profiles_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles_users (
    id integer NOT NULL,
    user_id integer,
    profile_id integer
);


--
-- Name: profiles_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.profiles_users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profiles_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.profiles_users_id_seq OWNED BY public.profiles_users.id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rooms (
    id integer NOT NULL,
    name character varying NOT NULL,
    house_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rooms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rooms_id_seq OWNED BY public.rooms.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: spaces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.spaces (
    id integer NOT NULL,
    modality_id integer,
    place_id integer,
    amount numeric DEFAULT 0.0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: spaces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.spaces_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: spaces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.spaces_id_seq OWNED BY public.spaces.id;


--
-- Name: stays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stays (
    id integer NOT NULL,
    participant_id integer,
    place_id integer,
    start_at timestamp without time zone,
    end_at timestamp without time zone,
    amount numeric,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: stays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stays_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stays_id_seq OWNED BY public.stays.id;


--
-- Name: token_controls; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.token_controls (
    id integer NOT NULL,
    guest_id integer,
    auth_token text,
    state character varying DEFAULT 'pending'::character varying
);


--
-- Name: token_controls_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.token_controls_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: token_controls_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.token_controls_id_seq OWNED BY public.token_controls.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    country character varying,
    name character varying,
    surname character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: air_tickets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.air_tickets ALTER COLUMN id SET DEFAULT nextval('public.air_tickets_id_seq'::regclass);


--
-- Name: beds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.beds ALTER COLUMN id SET DEFAULT nextval('public.beds_id_seq'::regclass);


--
-- Name: bookings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings ALTER COLUMN id SET DEFAULT nextval('public.bookings_id_seq'::regclass);


--
-- Name: change_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.change_logs ALTER COLUMN id SET DEFAULT nextval('public.change_logs_id_seq'::regclass);


--
-- Name: compositions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compositions ALTER COLUMN id SET DEFAULT nextval('public.compositions_id_seq'::regclass);


--
-- Name: configurations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configurations ALTER COLUMN id SET DEFAULT nextval('public.configurations_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: guests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guests ALTER COLUMN id SET DEFAULT nextval('public.guests_id_seq'::regclass);


--
-- Name: historicals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historicals ALTER COLUMN id SET DEFAULT nextval('public.historicals_id_seq'::regclass);


--
-- Name: houses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.houses ALTER COLUMN id SET DEFAULT nextval('public.houses_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: modalities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.modalities ALTER COLUMN id SET DEFAULT nextval('public.modalities_id_seq'::regclass);


--
-- Name: participant_spaces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participant_spaces ALTER COLUMN id SET DEFAULT nextval('public.participant_spaces_id_seq'::regclass);


--
-- Name: participants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants ALTER COLUMN id SET DEFAULT nextval('public.participants_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: places id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places ALTER COLUMN id SET DEFAULT nextval('public.places_id_seq'::regclass);


--
-- Name: places_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places_events ALTER COLUMN id SET DEFAULT nextval('public.places_events_id_seq'::regclass);


--
-- Name: profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles ALTER COLUMN id SET DEFAULT nextval('public.profiles_id_seq'::regclass);


--
-- Name: profiles_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles_users ALTER COLUMN id SET DEFAULT nextval('public.profiles_users_id_seq'::regclass);


--
-- Name: rooms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms ALTER COLUMN id SET DEFAULT nextval('public.rooms_id_seq'::regclass);


--
-- Name: spaces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spaces ALTER COLUMN id SET DEFAULT nextval('public.spaces_id_seq'::regclass);


--
-- Name: stays id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stays ALTER COLUMN id SET DEFAULT nextval('public.stays_id_seq'::regclass);


--
-- Name: token_controls id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.token_controls ALTER COLUMN id SET DEFAULT nextval('public.token_controls_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: air_tickets air_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.air_tickets
    ADD CONSTRAINT air_tickets_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: beds beds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.beds
    ADD CONSTRAINT beds_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: change_logs change_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.change_logs
    ADD CONSTRAINT change_logs_pkey PRIMARY KEY (id);


--
-- Name: compositions compositions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.compositions
    ADD CONSTRAINT compositions_pkey PRIMARY KEY (id);


--
-- Name: configurations configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.configurations
    ADD CONSTRAINT configurations_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: guests guests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guests
    ADD CONSTRAINT guests_pkey PRIMARY KEY (id);


--
-- Name: historicals historicals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historicals
    ADD CONSTRAINT historicals_pkey PRIMARY KEY (id);


--
-- Name: houses houses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.houses
    ADD CONSTRAINT houses_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: modalities modalities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.modalities
    ADD CONSTRAINT modalities_pkey PRIMARY KEY (id);


--
-- Name: participant_spaces participant_spaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participant_spaces
    ADD CONSTRAINT participant_spaces_pkey PRIMARY KEY (id);


--
-- Name: participants participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: places_events places_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places_events
    ADD CONSTRAINT places_events_pkey PRIMARY KEY (id);


--
-- Name: places places_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: profiles_users profiles_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles_users
    ADD CONSTRAINT profiles_users_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: spaces spaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spaces
    ADD CONSTRAINT spaces_pkey PRIMARY KEY (id);


--
-- Name: stays stays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stays
    ADD CONSTRAINT stays_pkey PRIMARY KEY (id);


--
-- Name: token_controls token_controls_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.token_controls
    ADD CONSTRAINT token_controls_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_air_tickets_on_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_air_tickets_on_participant_id ON public.air_tickets USING btree (participant_id);


--
-- Name: index_beds_on_room_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_beds_on_room_id ON public.beds USING btree (room_id);


--
-- Name: index_bookings_on_bed_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookings_on_bed_id ON public.bookings USING btree (bed_id);


--
-- Name: index_bookings_on_guest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookings_on_guest_id ON public.bookings USING btree (guest_id);


--
-- Name: index_bookings_on_start_date_and_end_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_bookings_on_start_date_and_end_date ON public.bookings USING btree (start_date, end_date);


--
-- Name: index_change_logs_on_logable_type_and_logable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_change_logs_on_logable_type_and_logable_id ON public.change_logs USING btree (logable_type, logable_id);


--
-- Name: index_compositions_on_modality_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_compositions_on_modality_id ON public.compositions USING btree (modality_id);


--
-- Name: index_compositions_on_submodality_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_compositions_on_submodality_id ON public.compositions USING btree (submodality_id);


--
-- Name: index_historicals_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_historicals_on_location_id ON public.historicals USING btree (location_id);


--
-- Name: index_houses_on_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_houses_on_location_id ON public.houses USING btree (location_id);


--
-- Name: index_modalities_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_modalities_on_event_id ON public.modalities USING btree (event_id);


--
-- Name: index_participant_spaces_on_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participant_spaces_on_participant_id ON public.participant_spaces USING btree (participant_id);


--
-- Name: index_participant_spaces_on_space_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participant_spaces_on_space_id ON public.participant_spaces USING btree (space_id);


--
-- Name: index_participants_bookings_on_booking_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participants_bookings_on_booking_id ON public.participants_bookings USING btree (booking_id);


--
-- Name: index_participants_bookings_on_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participants_bookings_on_participant_id ON public.participants_bookings USING btree (participant_id);


--
-- Name: index_participants_on_guest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_participants_on_guest_id ON public.participants USING btree (guest_id);


--
-- Name: index_payments_on_payable_type_and_payable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payments_on_payable_type_and_payable_id ON public.payments USING btree (payable_type, payable_id);


--
-- Name: index_places_events_on_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_places_events_on_event_id ON public.places_events USING btree (event_id);


--
-- Name: index_places_events_on_place_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_places_events_on_place_id ON public.places_events USING btree (place_id);


--
-- Name: index_profiles_users_on_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_profiles_users_on_profile_id ON public.profiles_users USING btree (profile_id);


--
-- Name: index_profiles_users_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_profiles_users_on_user_id ON public.profiles_users USING btree (user_id);


--
-- Name: index_rooms_on_house_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rooms_on_house_id ON public.rooms USING btree (house_id);


--
-- Name: index_spaces_on_modality_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spaces_on_modality_id ON public.spaces USING btree (modality_id);


--
-- Name: index_spaces_on_place_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_spaces_on_place_id ON public.spaces USING btree (place_id);


--
-- Name: index_stays_on_participant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stays_on_participant_id ON public.stays USING btree (participant_id);


--
-- Name: index_stays_on_place_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stays_on_place_id ON public.stays USING btree (place_id);


--
-- Name: index_token_controls_on_guest_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_token_controls_on_guest_id ON public.token_controls USING btree (guest_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: participants_bookings fk_rails_2a8fcefe31; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants_bookings
    ADD CONSTRAINT fk_rails_2a8fcefe31 FOREIGN KEY (booking_id) REFERENCES public.bookings(id);


--
-- Name: stays fk_rails_36f663a6f0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stays
    ADD CONSTRAINT fk_rails_36f663a6f0 FOREIGN KEY (participant_id) REFERENCES public.participants(id);


--
-- Name: participant_spaces fk_rails_400c846ea9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participant_spaces
    ADD CONSTRAINT fk_rails_400c846ea9 FOREIGN KEY (space_id) REFERENCES public.spaces(id);


--
-- Name: spaces fk_rails_48b93914f0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spaces
    ADD CONSTRAINT fk_rails_48b93914f0 FOREIGN KEY (place_id) REFERENCES public.places(id);


--
-- Name: token_controls fk_rails_5f059d47cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.token_controls
    ADD CONSTRAINT fk_rails_5f059d47cc FOREIGN KEY (guest_id) REFERENCES public.guests(id);


--
-- Name: rooms fk_rails_7b991d0f09; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT fk_rails_7b991d0f09 FOREIGN KEY (house_id) REFERENCES public.houses(id);


--
-- Name: air_tickets fk_rails_819318808c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.air_tickets
    ADD CONSTRAINT fk_rails_819318808c FOREIGN KEY (participant_id) REFERENCES public.participants(id);


--
-- Name: spaces fk_rails_88f394a196; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.spaces
    ADD CONSTRAINT fk_rails_88f394a196 FOREIGN KEY (modality_id) REFERENCES public.modalities(id);


--
-- Name: bookings fk_rails_8a4f061ab6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_rails_8a4f061ab6 FOREIGN KEY (bed_id) REFERENCES public.beds(id);


--
-- Name: participant_spaces fk_rails_8bbbb33a95; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participant_spaces
    ADD CONSTRAINT fk_rails_8bbbb33a95 FOREIGN KEY (participant_id) REFERENCES public.participants(id);


--
-- Name: modalities fk_rails_8bcf7ab06a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.modalities
    ADD CONSTRAINT fk_rails_8bcf7ab06a FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: participants_bookings fk_rails_8ca3b99a26; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants_bookings
    ADD CONSTRAINT fk_rails_8ca3b99a26 FOREIGN KEY (participant_id) REFERENCES public.participants(id);


--
-- Name: historicals fk_rails_afc2f264f6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.historicals
    ADD CONSTRAINT fk_rails_afc2f264f6 FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: participants fk_rails_bd0f1059a5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT fk_rails_bd0f1059a5 FOREIGN KEY (guest_id) REFERENCES public.guests(id);


--
-- Name: places_events fk_rails_c22f61bc37; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places_events
    ADD CONSTRAINT fk_rails_c22f61bc37 FOREIGN KEY (event_id) REFERENCES public.events(id);


--
-- Name: stays fk_rails_cda71e757b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stays
    ADD CONSTRAINT fk_rails_cda71e757b FOREIGN KEY (place_id) REFERENCES public.places(id);


--
-- Name: beds fk_rails_d65c5f355a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.beds
    ADD CONSTRAINT fk_rails_d65c5f355a FOREIGN KEY (room_id) REFERENCES public.rooms(id);


--
-- Name: houses fk_rails_dc56e8f04e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.houses
    ADD CONSTRAINT fk_rails_dc56e8f04e FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: bookings fk_rails_e6267ecbed; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT fk_rails_e6267ecbed FOREIGN KEY (guest_id) REFERENCES public.guests(id);


--
-- Name: places_events fk_rails_ff765d818f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.places_events
    ADD CONSTRAINT fk_rails_ff765d818f FOREIGN KEY (place_id) REFERENCES public.places(id);


--
-- PostgreSQL database dump complete
--

\unrestrict GY3RbdugoBDDwSSd8c7uA78zF2egyq2Uv2EefArnT3dr0VKaxpmHOMchw8y1yCY

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20260416031000'),
('20230807010424'),
('20220513033918'),
('20191220150204'),
('20191220142020'),
('20181203025216'),
('20181203014110'),
('20181203004335'),
('20180503062943'),
('20180503043852'),
('20180430195834'),
('20180401022849'),
('20180401005733'),
('20180331215544'),
('20180331201331'),
('20180331195323'),
('20171218173647'),
('20171102184827'),
('20170727010659'),
('20170720010645'),
('20170705164854'),
('20170705032632'),
('20170705014159'),
('20170628023302'),
('20170628014850'),
('20170626050435'),
('20170626044501'),
('20170626020107'),
('20170625212559'),
('20170621142819'),
('20170618141732'),
('20170618140726'),
('20170618140522'),
('20170618140358'),
('20170618135818'),
('20170618134344'),
('20170618133334'),
('20170618082148'),
('20170618082053'),
('20170618070221'),
('20170209030519'),
('20170209029833'),
('20160726175948'),
('20160117042101'),
('20160117035235'),
('20160117035205'),
('20160117035019'),
('20160117034228'),
('20160117031750'),
('20160117015536');

