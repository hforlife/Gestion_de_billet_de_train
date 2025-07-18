PGDMP      -    	            }            projet_1    17.4    17.4 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    91455    projet_1    DATABASE     n   CREATE DATABASE projet_1 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'fr-FR';
    DROP DATABASE projet_1;
                     postgres    false            �            1259    91612    bagages    TABLE       CREATE TABLE public.bagages (
    id bigint NOT NULL,
    vente_id bigint NOT NULL,
    poids numeric(8,2) NOT NULL,
    tarif numeric(10,2) NOT NULL,
    description character varying(255),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.bagages;
       public         heap r       postgres    false            �            1259    91611    bagages_id_seq    SEQUENCE     w   CREATE SEQUENCE public.bagages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.bagages_id_seq;
       public               postgres    false    241            �           0    0    bagages_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.bagages_id_seq OWNED BY public.bagages.id;
          public               postgres    false    240            �            1259    91490    cache    TABLE     �   CREATE TABLE public.cache (
    key character varying(255) NOT NULL,
    value text NOT NULL,
    expiration integer NOT NULL
);
    DROP TABLE public.cache;
       public         heap r       postgres    false            �            1259    91497    cache_locks    TABLE     �   CREATE TABLE public.cache_locks (
    key character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    expiration integer NOT NULL
);
    DROP TABLE public.cache_locks;
       public         heap r       postgres    false            �            1259    91624    colis    TABLE       CREATE TABLE public.colis (
    id bigint NOT NULL,
    user1 character varying(255) NOT NULL,
    user2 character varying(255) NOT NULL,
    poids numeric(8,2) NOT NULL,
    tarif numeric(10,2) NOT NULL,
    statut character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT colis_statut_check CHECK (((statut)::text = ANY ((ARRAY['enregistré'::character varying, 'perdu'::character varying, 'livré'::character varying])::text[])))
);
    DROP TABLE public.colis;
       public         heap r       postgres    false            �            1259    91623    colis_id_seq    SEQUENCE     u   CREATE SEQUENCE public.colis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.colis_id_seq;
       public               postgres    false    243            �           0    0    colis_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.colis_id_seq OWNED BY public.colis.id;
          public               postgres    false    242            �            1259    91522    failed_jobs    TABLE     &  CREATE TABLE public.failed_jobs (
    id bigint NOT NULL,
    uuid character varying(255) NOT NULL,
    connection text NOT NULL,
    queue text NOT NULL,
    payload text NOT NULL,
    exception text NOT NULL,
    failed_at timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
    DROP TABLE public.failed_jobs;
       public         heap r       postgres    false            �            1259    91521    failed_jobs_id_seq    SEQUENCE     {   CREATE SEQUENCE public.failed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.failed_jobs_id_seq;
       public               postgres    false    229            �           0    0    failed_jobs_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.failed_jobs_id_seq OWNED BY public.failed_jobs.id;
          public               postgres    false    228            �            1259    91546    gares    TABLE     �   CREATE TABLE public.gares (
    id bigint NOT NULL,
    nom character varying(255) NOT NULL,
    adresse character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.gares;
       public         heap r       postgres    false            �            1259    91545    gares_id_seq    SEQUENCE     u   CREATE SEQUENCE public.gares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.gares_id_seq;
       public               postgres    false    233            �           0    0    gares_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.gares_id_seq OWNED BY public.gares.id;
          public               postgres    false    232            �            1259    91514    job_batches    TABLE     d  CREATE TABLE public.job_batches (
    id character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    total_jobs integer NOT NULL,
    pending_jobs integer NOT NULL,
    failed_jobs integer NOT NULL,
    failed_job_ids text NOT NULL,
    options text,
    cancelled_at integer,
    created_at integer NOT NULL,
    finished_at integer
);
    DROP TABLE public.job_batches;
       public         heap r       postgres    false            �            1259    91505    jobs    TABLE     �   CREATE TABLE public.jobs (
    id bigint NOT NULL,
    queue character varying(255) NOT NULL,
    payload text NOT NULL,
    attempts smallint NOT NULL,
    reserved_at integer,
    available_at integer NOT NULL,
    created_at integer NOT NULL
);
    DROP TABLE public.jobs;
       public         heap r       postgres    false            �            1259    91504    jobs_id_seq    SEQUENCE     t   CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.jobs_id_seq;
       public               postgres    false    226            �           0    0    jobs_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE public.jobs_id_seq OWNED BY public.jobs.id;
          public               postgres    false    225            �            1259    91457 
   migrations    TABLE     �   CREATE TABLE public.migrations (
    id integer NOT NULL,
    migration character varying(255) NOT NULL,
    batch integer NOT NULL
);
    DROP TABLE public.migrations;
       public         heap r       postgres    false            �            1259    91456    migrations_id_seq    SEQUENCE     �   CREATE SEQUENCE public.migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.migrations_id_seq;
       public               postgres    false    218            �           0    0    migrations_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.migrations_id_seq OWNED BY public.migrations.id;
          public               postgres    false    217            �            1259    91669    model_has_permissions    TABLE     �   CREATE TABLE public.model_has_permissions (
    permission_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);
 )   DROP TABLE public.model_has_permissions;
       public         heap r       postgres    false            �            1259    91680    model_has_roles    TABLE     �   CREATE TABLE public.model_has_roles (
    role_id bigint NOT NULL,
    model_type character varying(255) NOT NULL,
    model_id bigint NOT NULL
);
 #   DROP TABLE public.model_has_roles;
       public         heap r       postgres    false            �            1259    91474    password_reset_tokens    TABLE     �   CREATE TABLE public.password_reset_tokens (
    email character varying(255) NOT NULL,
    token character varying(255) NOT NULL,
    created_at timestamp(0) without time zone
);
 )   DROP TABLE public.password_reset_tokens;
       public         heap r       postgres    false            �            1259    91648    permissions    TABLE     �   CREATE TABLE public.permissions (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.permissions;
       public         heap r       postgres    false            �            1259    91647    permissions_id_seq    SEQUENCE     {   CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.permissions_id_seq;
       public               postgres    false    247            �           0    0    permissions_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;
          public               postgres    false    246            �            1259    91534    personal_access_tokens    TABLE     �  CREATE TABLE public.personal_access_tokens (
    id bigint NOT NULL,
    tokenable_type character varying(255) NOT NULL,
    tokenable_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    token character varying(64) NOT NULL,
    abilities text,
    last_used_at timestamp(0) without time zone,
    expires_at timestamp(0) without time zone,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
 *   DROP TABLE public.personal_access_tokens;
       public         heap r       postgres    false            �            1259    91533    personal_access_tokens_id_seq    SEQUENCE     �   CREATE SEQUENCE public.personal_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.personal_access_tokens_id_seq;
       public               postgres    false    231            �           0    0    personal_access_tokens_id_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE public.personal_access_tokens_id_seq OWNED BY public.personal_access_tokens.id;
          public               postgres    false    230            �            1259    91634    rapports    TABLE       CREATE TABLE public.rapports (
    id bigint NOT NULL,
    chef_gare_id bigint NOT NULL,
    contenu text NOT NULL,
    date timestamp(0) without time zone NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.rapports;
       public         heap r       postgres    false            �            1259    91633    rapports_id_seq    SEQUENCE     x   CREATE SEQUENCE public.rapports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.rapports_id_seq;
       public               postgres    false    245            �           0    0    rapports_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.rapports_id_seq OWNED BY public.rapports.id;
          public               postgres    false    244            �            1259    91691    role_has_permissions    TABLE     m   CREATE TABLE public.role_has_permissions (
    permission_id bigint NOT NULL,
    role_id bigint NOT NULL
);
 (   DROP TABLE public.role_has_permissions;
       public         heap r       postgres    false            �            1259    91659    roles    TABLE     �   CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    guard_name character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.roles;
       public         heap r       postgres    false            �            1259    91658    roles_id_seq    SEQUENCE     u   CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.roles_id_seq;
       public               postgres    false    249            �           0    0    roles_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;
          public               postgres    false    248            �            1259    91481    sessions    TABLE     �   CREATE TABLE public.sessions (
    id character varying(255) NOT NULL,
    user_id bigint,
    ip_address character varying(45),
    user_agent text,
    payload text NOT NULL,
    last_activity integer NOT NULL
);
    DROP TABLE public.sessions;
       public         heap r       postgres    false            �            1259    91555    trains    TABLE     �  CREATE TABLE public.trains (
    id bigint NOT NULL,
    numero character varying(255) NOT NULL,
    capacite integer NOT NULL,
    etat character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT trains_etat_check CHECK (((etat)::text = ANY ((ARRAY['actif'::character varying, 'en_maintenance'::character varying])::text[])))
);
    DROP TABLE public.trains;
       public         heap r       postgres    false            �            1259    91554    trains_id_seq    SEQUENCE     v   CREATE SEQUENCE public.trains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.trains_id_seq;
       public               postgres    false    235            �           0    0    trains_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.trains_id_seq OWNED BY public.trains.id;
          public               postgres    false    234            �            1259    91464    users    TABLE     x  CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    email_verified_at timestamp(0) without time zone,
    password character varying(255) NOT NULL,
    remember_token character varying(100),
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone
);
    DROP TABLE public.users;
       public         heap r       postgres    false            �            1259    91463    users_id_seq    SEQUENCE     u   CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public               postgres    false    220            �           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public               postgres    false    219            �            1259    91590    ventes    TABLE     j  CREATE TABLE public.ventes (
    id bigint NOT NULL,
    client_nom character varying(255),
    voyage_id bigint NOT NULL,
    train_id bigint NOT NULL,
    prix numeric(8,2) NOT NULL,
    bagage boolean DEFAULT false NOT NULL,
    poids_bagage numeric(8,2) NOT NULL,
    statut character varying(255) DEFAULT 'payé'::character varying NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT ventes_statut_check CHECK (((statut)::text = ANY ((ARRAY['payé'::character varying, 'annulé'::character varying, 'réservé'::character varying])::text[])))
);
    DROP TABLE public.ventes;
       public         heap r       postgres    false            �            1259    91589    ventes_id_seq    SEQUENCE     v   CREATE SEQUENCE public.ventes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.ventes_id_seq;
       public               postgres    false    239            �           0    0    ventes_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.ventes_id_seq OWNED BY public.ventes.id;
          public               postgres    false    238            �            1259    91565    voyages    TABLE     �  CREATE TABLE public.voyages (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    train_id bigint NOT NULL,
    gare_depart_id bigint NOT NULL,
    gare_arrivee_id bigint NOT NULL,
    date_depart timestamp(0) without time zone NOT NULL,
    date_arrivee timestamp(0) without time zone,
    prix numeric(10,2) NOT NULL,
    statut character varying(255) NOT NULL,
    created_at timestamp(0) without time zone,
    updated_at timestamp(0) without time zone,
    CONSTRAINT voyages_statut_check CHECK (((statut)::text = ANY ((ARRAY['programmé'::character varying, 'en_cours'::character varying, 'terminé'::character varying, 'annulé'::character varying])::text[])))
);
    DROP TABLE public.voyages;
       public         heap r       postgres    false            �            1259    91564    voyages_id_seq    SEQUENCE     w   CREATE SEQUENCE public.voyages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.voyages_id_seq;
       public               postgres    false    237            �           0    0    voyages_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE public.voyages_id_seq OWNED BY public.voyages.id;
          public               postgres    false    236            �           2604    91615 
   bagages id    DEFAULT     h   ALTER TABLE ONLY public.bagages ALTER COLUMN id SET DEFAULT nextval('public.bagages_id_seq'::regclass);
 9   ALTER TABLE public.bagages ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    240    241    241            �           2604    91627    colis id    DEFAULT     d   ALTER TABLE ONLY public.colis ALTER COLUMN id SET DEFAULT nextval('public.colis_id_seq'::regclass);
 7   ALTER TABLE public.colis ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    242    243    243            �           2604    91525    failed_jobs id    DEFAULT     p   ALTER TABLE ONLY public.failed_jobs ALTER COLUMN id SET DEFAULT nextval('public.failed_jobs_id_seq'::regclass);
 =   ALTER TABLE public.failed_jobs ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    228    229    229            �           2604    91549    gares id    DEFAULT     d   ALTER TABLE ONLY public.gares ALTER COLUMN id SET DEFAULT nextval('public.gares_id_seq'::regclass);
 7   ALTER TABLE public.gares ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    232    233    233            �           2604    91508    jobs id    DEFAULT     b   ALTER TABLE ONLY public.jobs ALTER COLUMN id SET DEFAULT nextval('public.jobs_id_seq'::regclass);
 6   ALTER TABLE public.jobs ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    226    225    226            �           2604    91460    migrations id    DEFAULT     n   ALTER TABLE ONLY public.migrations ALTER COLUMN id SET DEFAULT nextval('public.migrations_id_seq'::regclass);
 <   ALTER TABLE public.migrations ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    217    218    218            �           2604    91651    permissions id    DEFAULT     p   ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);
 =   ALTER TABLE public.permissions ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    247    246    247            �           2604    91537    personal_access_tokens id    DEFAULT     �   ALTER TABLE ONLY public.personal_access_tokens ALTER COLUMN id SET DEFAULT nextval('public.personal_access_tokens_id_seq'::regclass);
 H   ALTER TABLE public.personal_access_tokens ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    231    230    231            �           2604    91637    rapports id    DEFAULT     j   ALTER TABLE ONLY public.rapports ALTER COLUMN id SET DEFAULT nextval('public.rapports_id_seq'::regclass);
 :   ALTER TABLE public.rapports ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    245    244    245            �           2604    91662    roles id    DEFAULT     d   ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);
 7   ALTER TABLE public.roles ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    249    248    249            �           2604    91558 	   trains id    DEFAULT     f   ALTER TABLE ONLY public.trains ALTER COLUMN id SET DEFAULT nextval('public.trains_id_seq'::regclass);
 8   ALTER TABLE public.trains ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    235    234    235            �           2604    91467    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    220    219    220            �           2604    91593 	   ventes id    DEFAULT     f   ALTER TABLE ONLY public.ventes ALTER COLUMN id SET DEFAULT nextval('public.ventes_id_seq'::regclass);
 8   ALTER TABLE public.ventes ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    239    238    239            �           2604    91568 
   voyages id    DEFAULT     h   ALTER TABLE ONLY public.voyages ALTER COLUMN id SET DEFAULT nextval('public.voyages_id_seq'::regclass);
 9   ALTER TABLE public.voyages ALTER COLUMN id DROP DEFAULT;
       public               postgres    false    237    236    237            �          0    91612    bagages 
   TABLE DATA           b   COPY public.bagages (id, vente_id, poids, tarif, description, created_at, updated_at) FROM stdin;
    public               postgres    false    241   /�       �          0    91490    cache 
   TABLE DATA           7   COPY public.cache (key, value, expiration) FROM stdin;
    public               postgres    false    223   L�       �          0    91497    cache_locks 
   TABLE DATA           =   COPY public.cache_locks (key, owner, expiration) FROM stdin;
    public               postgres    false    224   i�       �          0    91624    colis 
   TABLE DATA           _   COPY public.colis (id, user1, user2, poids, tarif, statut, created_at, updated_at) FROM stdin;
    public               postgres    false    243   ��       �          0    91522    failed_jobs 
   TABLE DATA           a   COPY public.failed_jobs (id, uuid, connection, queue, payload, exception, failed_at) FROM stdin;
    public               postgres    false    229   ��       �          0    91546    gares 
   TABLE DATA           I   COPY public.gares (id, nom, adresse, created_at, updated_at) FROM stdin;
    public               postgres    false    233   ��       �          0    91514    job_batches 
   TABLE DATA           �   COPY public.job_batches (id, name, total_jobs, pending_jobs, failed_jobs, failed_job_ids, options, cancelled_at, created_at, finished_at) FROM stdin;
    public               postgres    false    227   ݹ       �          0    91505    jobs 
   TABLE DATA           c   COPY public.jobs (id, queue, payload, attempts, reserved_at, available_at, created_at) FROM stdin;
    public               postgres    false    226   ��       �          0    91457 
   migrations 
   TABLE DATA           :   COPY public.migrations (id, migration, batch) FROM stdin;
    public               postgres    false    218   �       �          0    91669    model_has_permissions 
   TABLE DATA           T   COPY public.model_has_permissions (permission_id, model_type, model_id) FROM stdin;
    public               postgres    false    250   ��       �          0    91680    model_has_roles 
   TABLE DATA           H   COPY public.model_has_roles (role_id, model_type, model_id) FROM stdin;
    public               postgres    false    251   к       �          0    91474    password_reset_tokens 
   TABLE DATA           I   COPY public.password_reset_tokens (email, token, created_at) FROM stdin;
    public               postgres    false    221   �       �          0    91648    permissions 
   TABLE DATA           S   COPY public.permissions (id, name, guard_name, created_at, updated_at) FROM stdin;
    public               postgres    false    247   !�       �          0    91534    personal_access_tokens 
   TABLE DATA           �   COPY public.personal_access_tokens (id, tokenable_type, tokenable_id, name, token, abilities, last_used_at, expires_at, created_at, updated_at) FROM stdin;
    public               postgres    false    231   >�       �          0    91634    rapports 
   TABLE DATA           [   COPY public.rapports (id, chef_gare_id, contenu, date, created_at, updated_at) FROM stdin;
    public               postgres    false    245   [�       �          0    91691    role_has_permissions 
   TABLE DATA           F   COPY public.role_has_permissions (permission_id, role_id) FROM stdin;
    public               postgres    false    252   x�       �          0    91659    roles 
   TABLE DATA           M   COPY public.roles (id, name, guard_name, created_at, updated_at) FROM stdin;
    public               postgres    false    249   ��       �          0    91481    sessions 
   TABLE DATA           _   COPY public.sessions (id, user_id, ip_address, user_agent, payload, last_activity) FROM stdin;
    public               postgres    false    222   �       �          0    91555    trains 
   TABLE DATA           T   COPY public.trains (id, numero, capacite, etat, created_at, updated_at) FROM stdin;
    public               postgres    false    235   �       �          0    91464    users 
   TABLE DATA           u   COPY public.users (id, name, email, email_verified_at, password, remember_token, created_at, updated_at) FROM stdin;
    public               postgres    false    220   #�       �          0    91590    ventes 
   TABLE DATA           �   COPY public.ventes (id, client_nom, voyage_id, train_id, prix, bagage, poids_bagage, statut, created_at, updated_at) FROM stdin;
    public               postgres    false    239   M�       �          0    91565    voyages 
   TABLE DATA           �   COPY public.voyages (id, name, train_id, gare_depart_id, gare_arrivee_id, date_depart, date_arrivee, prix, statut, created_at, updated_at) FROM stdin;
    public               postgres    false    237   j�       �           0    0    bagages_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.bagages_id_seq', 1, false);
          public               postgres    false    240            �           0    0    colis_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.colis_id_seq', 1, false);
          public               postgres    false    242            �           0    0    failed_jobs_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.failed_jobs_id_seq', 1, false);
          public               postgres    false    228            �           0    0    gares_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.gares_id_seq', 1, false);
          public               postgres    false    232            �           0    0    jobs_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.jobs_id_seq', 1, false);
          public               postgres    false    225            �           0    0    migrations_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.migrations_id_seq', 6, true);
          public               postgres    false    217            �           0    0    permissions_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.permissions_id_seq', 1, false);
          public               postgres    false    246            �           0    0    personal_access_tokens_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.personal_access_tokens_id_seq', 1, false);
          public               postgres    false    230            �           0    0    rapports_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.rapports_id_seq', 1, false);
          public               postgres    false    244            �           0    0    roles_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.roles_id_seq', 3, true);
          public               postgres    false    248            �           0    0    trains_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.trains_id_seq', 1, false);
          public               postgres    false    234            �           0    0    users_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.users_id_seq', 11, true);
          public               postgres    false    219            �           0    0    ventes_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.ventes_id_seq', 1, false);
          public               postgres    false    238            �           0    0    voyages_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.voyages_id_seq', 1, false);
          public               postgres    false    236            �           2606    91617    bagages bagages_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.bagages
    ADD CONSTRAINT bagages_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.bagages DROP CONSTRAINT bagages_pkey;
       public                 postgres    false    241            �           2606    91503    cache_locks cache_locks_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.cache_locks
    ADD CONSTRAINT cache_locks_pkey PRIMARY KEY (key);
 F   ALTER TABLE ONLY public.cache_locks DROP CONSTRAINT cache_locks_pkey;
       public                 postgres    false    224            �           2606    91496    cache cache_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY public.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);
 :   ALTER TABLE ONLY public.cache DROP CONSTRAINT cache_pkey;
       public                 postgres    false    223            �           2606    91632    colis colis_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.colis
    ADD CONSTRAINT colis_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.colis DROP CONSTRAINT colis_pkey;
       public                 postgres    false    243            �           2606    91530    failed_jobs failed_jobs_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_pkey;
       public                 postgres    false    229            �           2606    91532 #   failed_jobs failed_jobs_uuid_unique 
   CONSTRAINT     ^   ALTER TABLE ONLY public.failed_jobs
    ADD CONSTRAINT failed_jobs_uuid_unique UNIQUE (uuid);
 M   ALTER TABLE ONLY public.failed_jobs DROP CONSTRAINT failed_jobs_uuid_unique;
       public                 postgres    false    229            �           2606    91553    gares gares_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.gares
    ADD CONSTRAINT gares_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.gares DROP CONSTRAINT gares_pkey;
       public                 postgres    false    233            �           2606    91520    job_batches job_batches_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.job_batches
    ADD CONSTRAINT job_batches_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.job_batches DROP CONSTRAINT job_batches_pkey;
       public                 postgres    false    227            �           2606    91512    jobs jobs_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY public.jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.jobs DROP CONSTRAINT jobs_pkey;
       public                 postgres    false    226            �           2606    91462    migrations migrations_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.migrations DROP CONSTRAINT migrations_pkey;
       public                 postgres    false    218                       2606    91679 0   model_has_permissions model_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_pkey PRIMARY KEY (permission_id, model_id, model_type);
 Z   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_pkey;
       public                 postgres    false    250    250    250                       2606    91690 $   model_has_roles model_has_roles_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_pkey PRIMARY KEY (role_id, model_id, model_type);
 N   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_pkey;
       public                 postgres    false    251    251    251            �           2606    91480 0   password_reset_tokens password_reset_tokens_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.password_reset_tokens
    ADD CONSTRAINT password_reset_tokens_pkey PRIMARY KEY (email);
 Z   ALTER TABLE ONLY public.password_reset_tokens DROP CONSTRAINT password_reset_tokens_pkey;
       public                 postgres    false    221            �           2606    91657 .   permissions permissions_name_guard_name_unique 
   CONSTRAINT     u   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_name_guard_name_unique UNIQUE (name, guard_name);
 X   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_name_guard_name_unique;
       public                 postgres    false    247    247            �           2606    91655    permissions permissions_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.permissions DROP CONSTRAINT permissions_pkey;
       public                 postgres    false    247            �           2606    91541 2   personal_access_tokens personal_access_tokens_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_pkey;
       public                 postgres    false    231            �           2606    91544 :   personal_access_tokens personal_access_tokens_token_unique 
   CONSTRAINT     v   ALTER TABLE ONLY public.personal_access_tokens
    ADD CONSTRAINT personal_access_tokens_token_unique UNIQUE (token);
 d   ALTER TABLE ONLY public.personal_access_tokens DROP CONSTRAINT personal_access_tokens_token_unique;
       public                 postgres    false    231            �           2606    91641    rapports rapports_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.rapports
    ADD CONSTRAINT rapports_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.rapports DROP CONSTRAINT rapports_pkey;
       public                 postgres    false    245                       2606    91705 .   role_has_permissions role_has_permissions_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_pkey PRIMARY KEY (permission_id, role_id);
 X   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_pkey;
       public                 postgres    false    252    252            �           2606    91668 "   roles roles_name_guard_name_unique 
   CONSTRAINT     i   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_guard_name_unique UNIQUE (name, guard_name);
 L   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_name_guard_name_unique;
       public                 postgres    false    249    249                        2606    91666    roles roles_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.roles DROP CONSTRAINT roles_pkey;
       public                 postgres    false    249            �           2606    91487    sessions sessions_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.sessions DROP CONSTRAINT sessions_pkey;
       public                 postgres    false    222            �           2606    91563    trains trains_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.trains
    ADD CONSTRAINT trains_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.trains DROP CONSTRAINT trains_pkey;
       public                 postgres    false    235            �           2606    91473    users users_email_unique 
   CONSTRAINT     T   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);
 B   ALTER TABLE ONLY public.users DROP CONSTRAINT users_email_unique;
       public                 postgres    false    220            �           2606    91471    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public                 postgres    false    220            �           2606    91600    ventes ventes_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.ventes
    ADD CONSTRAINT ventes_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.ventes DROP CONSTRAINT ventes_pkey;
       public                 postgres    false    239            �           2606    91573    voyages voyages_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.voyages
    ADD CONSTRAINT voyages_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.voyages DROP CONSTRAINT voyages_pkey;
       public                 postgres    false    237            �           1259    91513    jobs_queue_index    INDEX     B   CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);
 $   DROP INDEX public.jobs_queue_index;
       public                 postgres    false    226                       1259    91672 /   model_has_permissions_model_id_model_type_index    INDEX     �   CREATE INDEX model_has_permissions_model_id_model_type_index ON public.model_has_permissions USING btree (model_id, model_type);
 C   DROP INDEX public.model_has_permissions_model_id_model_type_index;
       public                 postgres    false    250    250                       1259    91683 )   model_has_roles_model_id_model_type_index    INDEX     u   CREATE INDEX model_has_roles_model_id_model_type_index ON public.model_has_roles USING btree (model_id, model_type);
 =   DROP INDEX public.model_has_roles_model_id_model_type_index;
       public                 postgres    false    251    251            �           1259    91542 8   personal_access_tokens_tokenable_type_tokenable_id_index    INDEX     �   CREATE INDEX personal_access_tokens_tokenable_type_tokenable_id_index ON public.personal_access_tokens USING btree (tokenable_type, tokenable_id);
 L   DROP INDEX public.personal_access_tokens_tokenable_type_tokenable_id_index;
       public                 postgres    false    231    231            �           1259    91489    sessions_last_activity_index    INDEX     Z   CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);
 0   DROP INDEX public.sessions_last_activity_index;
       public                 postgres    false    222            �           1259    91488    sessions_user_id_index    INDEX     N   CREATE INDEX sessions_user_id_index ON public.sessions USING btree (user_id);
 *   DROP INDEX public.sessions_user_id_index;
       public                 postgres    false    222                       2606    91618     bagages bagages_vente_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.bagages
    ADD CONSTRAINT bagages_vente_id_foreign FOREIGN KEY (vente_id) REFERENCES public.ventes(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.bagages DROP CONSTRAINT bagages_vente_id_foreign;
       public               postgres    false    4850    239    241                       2606    91673 A   model_has_permissions model_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_permissions
    ADD CONSTRAINT model_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 k   ALTER TABLE ONLY public.model_has_permissions DROP CONSTRAINT model_has_permissions_permission_id_foreign;
       public               postgres    false    250    247    4860                       2606    91684 /   model_has_roles model_has_roles_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.model_has_roles
    ADD CONSTRAINT model_has_roles_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 Y   ALTER TABLE ONLY public.model_has_roles DROP CONSTRAINT model_has_roles_role_id_foreign;
       public               postgres    false    4864    249    251                       2606    91642 &   rapports rapports_chef_gare_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.rapports
    ADD CONSTRAINT rapports_chef_gare_id_foreign FOREIGN KEY (chef_gare_id) REFERENCES public.users(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.rapports DROP CONSTRAINT rapports_chef_gare_id_foreign;
       public               postgres    false    220    4818    245                       2606    91694 ?   role_has_permissions role_has_permissions_permission_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_permission_id_foreign FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;
 i   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_permission_id_foreign;
       public               postgres    false    247    4860    252                       2606    91699 9   role_has_permissions role_has_permissions_role_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.role_has_permissions
    ADD CONSTRAINT role_has_permissions_role_id_foreign FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;
 c   ALTER TABLE ONLY public.role_has_permissions DROP CONSTRAINT role_has_permissions_role_id_foreign;
       public               postgres    false    4864    249    252                       2606    91606    ventes ventes_train_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.ventes
    ADD CONSTRAINT ventes_train_id_foreign FOREIGN KEY (train_id) REFERENCES public.trains(id) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.ventes DROP CONSTRAINT ventes_train_id_foreign;
       public               postgres    false    239    235    4846                       2606    91601    ventes ventes_voyage_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.ventes
    ADD CONSTRAINT ventes_voyage_id_foreign FOREIGN KEY (voyage_id) REFERENCES public.voyages(id) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.ventes DROP CONSTRAINT ventes_voyage_id_foreign;
       public               postgres    false    237    4848    239            	           2606    91584 '   voyages voyages_gare_arrivee_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.voyages
    ADD CONSTRAINT voyages_gare_arrivee_id_foreign FOREIGN KEY (gare_arrivee_id) REFERENCES public.gares(id) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.voyages DROP CONSTRAINT voyages_gare_arrivee_id_foreign;
       public               postgres    false    237    4844    233            
           2606    91579 &   voyages voyages_gare_depart_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.voyages
    ADD CONSTRAINT voyages_gare_depart_id_foreign FOREIGN KEY (gare_depart_id) REFERENCES public.gares(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.voyages DROP CONSTRAINT voyages_gare_depart_id_foreign;
       public               postgres    false    233    237    4844                       2606    91574     voyages voyages_train_id_foreign    FK CONSTRAINT     �   ALTER TABLE ONLY public.voyages
    ADD CONSTRAINT voyages_train_id_foreign FOREIGN KEY (train_id) REFERENCES public.trains(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.voyages DROP CONSTRAINT voyages_train_id_foreign;
       public               postgres    false    235    4846    237            �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x�e�K�0D��a��4Q���KJ��r§)R��͛g�  ��Q����ʬ��0I���@\���"t;Ю����,XO��d�؄���d��S��r��-}[b${�3ז�]�V[ D���Gձ�L+~:c^�aM�      �      x������ � �      �   $   x�3�t,(����OI�)��	-N-�44����� ���      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   D   x�3�LL����,OM�4202�50�52S0��21�21�&�eę���F�c��������"����qqq �M"�      �      x������ � �      �      x������ � �      �     x���;s�0�Z�*҆�N���������7 #$[��ί_��I��"4*(4g��E��sP�P��YNN�Qh&е~��=GC�&�i�צwm{��8��G��˕e_�������k�%Z��R;k!_�i�Ư�~���gђ�^��Q>!Q|�N������o���A�@�"AUJAg3R}���|qcY�<�ޏt:x�w���.	XY��@�%eΈ�Pa�����R�?o�O�+����쐠�x����JV���p�v�pg�*Z���1�%<1Aǌ�$�3VaR�j7��y��>OAc��?�9*�	}�3&*�-+#�2�J��>��p��7V�>_�9]#Y1�N2�0��ž�F�ɟ������O�X׀�9h��1*k����v����xx|�4��0A^�4���A���Bjm�)���I�8[ܲ}`5_`�$���^:bq�dXj����-/�y�H��nٹ9�"�L|�M���Јz�`|Ϸ[1�w�p;���w�v�W"<dQ*��yP�hc�T�ϼq>�w�y�N��ÓM      �      x������ � �      �      x������ � �     