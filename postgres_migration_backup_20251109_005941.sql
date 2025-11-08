--
-- PostgreSQL database dump
--

\restrict RTISGEWTik9vxydAtRAVWdh8gSgXfAPwZO7VfRUm66243FpKHg3hoiYa3Jffj4R

-- Dumped from database version 15.14 (Debian 15.14-1.pgdg13+1)
-- Dumped by pg_dump version 15.14 (Debian 15.14-1.pgdg13+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: crawling_tasks; Type: TABLE; Schema: public; Owner: bettafish
--

CREATE TABLE public.crawling_tasks (
    id integer NOT NULL,
    task_name character varying(200) NOT NULL,
    platform character varying(50),
    status character varying(20),
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    result_count integer,
    error_message text,
    created_at timestamp without time zone
);


ALTER TABLE public.crawling_tasks OWNER TO bettafish;

--
-- Name: COLUMN crawling_tasks.task_name; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.crawling_tasks.task_name IS '任务名称';


--
-- Name: COLUMN crawling_tasks.platform; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.crawling_tasks.platform IS '平台名称';


--
-- Name: COLUMN crawling_tasks.status; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.crawling_tasks.status IS '任务状态';


--
-- Name: COLUMN crawling_tasks.start_time; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.crawling_tasks.start_time IS '开始时间';


--
-- Name: COLUMN crawling_tasks.end_time; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.crawling_tasks.end_time IS '结束时间';


--
-- Name: COLUMN crawling_tasks.result_count; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.crawling_tasks.result_count IS '结果数量';


--
-- Name: COLUMN crawling_tasks.error_message; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.crawling_tasks.error_message IS '错误信息';


--
-- Name: COLUMN crawling_tasks.created_at; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.crawling_tasks.created_at IS '创建时间';


--
-- Name: crawling_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: bettafish
--

CREATE SEQUENCE public.crawling_tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.crawling_tasks_id_seq OWNER TO bettafish;

--
-- Name: crawling_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bettafish
--

ALTER SEQUENCE public.crawling_tasks_id_seq OWNED BY public.crawling_tasks.id;


--
-- Name: daily_news; Type: TABLE; Schema: public; Owner: bettafish
--

CREATE TABLE public.daily_news (
    id integer NOT NULL,
    title character varying(500) NOT NULL,
    content text,
    source character varying(100),
    url character varying(1000),
    publish_time timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.daily_news OWNER TO bettafish;

--
-- Name: COLUMN daily_news.title; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.daily_news.title IS '新闻标题';


--
-- Name: COLUMN daily_news.content; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.daily_news.content IS '新闻内容';


--
-- Name: COLUMN daily_news.source; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.daily_news.source IS '新闻来源';


--
-- Name: COLUMN daily_news.url; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.daily_news.url IS '原始链接';


--
-- Name: COLUMN daily_news.publish_time; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.daily_news.publish_time IS '发布时间';


--
-- Name: COLUMN daily_news.created_at; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.daily_news.created_at IS '创建时间';


--
-- Name: COLUMN daily_news.updated_at; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.daily_news.updated_at IS '更新时间';


--
-- Name: daily_news_id_seq; Type: SEQUENCE; Schema: public; Owner: bettafish
--

CREATE SEQUENCE public.daily_news_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.daily_news_id_seq OWNER TO bettafish;

--
-- Name: daily_news_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bettafish
--

ALTER SEQUENCE public.daily_news_id_seq OWNED BY public.daily_news.id;


--
-- Name: daily_topics; Type: TABLE; Schema: public; Owner: bettafish
--

CREATE TABLE public.daily_topics (
    id integer NOT NULL,
    topic character varying(200) NOT NULL,
    platform character varying(50),
    heat_score double precision,
    category character varying(100),
    created_at timestamp without time zone
);


ALTER TABLE public.daily_topics OWNER TO bettafish;

--
-- Name: COLUMN daily_topics.topic; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.daily_topics.topic IS '话题内容';


--
-- Name: COLUMN daily_topics.platform; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.daily_topics.platform IS '平台名称';


--
-- Name: COLUMN daily_topics.heat_score; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.daily_topics.heat_score IS '热度分数';


--
-- Name: COLUMN daily_topics.category; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.daily_topics.category IS '话题分类';


--
-- Name: COLUMN daily_topics.created_at; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.daily_topics.created_at IS '创建时间';


--
-- Name: daily_topics_id_seq; Type: SEQUENCE; Schema: public; Owner: bettafish
--

CREATE SEQUENCE public.daily_topics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.daily_topics_id_seq OWNER TO bettafish;

--
-- Name: daily_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bettafish
--

ALTER SEQUENCE public.daily_topics_id_seq OWNED BY public.daily_topics.id;


--
-- Name: topic_news_relation; Type: TABLE; Schema: public; Owner: bettafish
--

CREATE TABLE public.topic_news_relation (
    id integer NOT NULL,
    topic_id integer NOT NULL,
    news_id integer NOT NULL,
    relevance_score double precision,
    created_at timestamp without time zone
);


ALTER TABLE public.topic_news_relation OWNER TO bettafish;

--
-- Name: COLUMN topic_news_relation.topic_id; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.topic_news_relation.topic_id IS '话题ID';


--
-- Name: COLUMN topic_news_relation.news_id; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.topic_news_relation.news_id IS '新闻ID';


--
-- Name: COLUMN topic_news_relation.relevance_score; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.topic_news_relation.relevance_score IS '相关度分数';


--
-- Name: COLUMN topic_news_relation.created_at; Type: COMMENT; Schema: public; Owner: bettafish
--

COMMENT ON COLUMN public.topic_news_relation.created_at IS '创建时间';


--
-- Name: topic_news_relation_id_seq; Type: SEQUENCE; Schema: public; Owner: bettafish
--

CREATE SEQUENCE public.topic_news_relation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.topic_news_relation_id_seq OWNER TO bettafish;

--
-- Name: topic_news_relation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: bettafish
--

ALTER SEQUENCE public.topic_news_relation_id_seq OWNED BY public.topic_news_relation.id;


--
-- Name: crawling_tasks id; Type: DEFAULT; Schema: public; Owner: bettafish
--

ALTER TABLE ONLY public.crawling_tasks ALTER COLUMN id SET DEFAULT nextval('public.crawling_tasks_id_seq'::regclass);


--
-- Name: daily_news id; Type: DEFAULT; Schema: public; Owner: bettafish
--

ALTER TABLE ONLY public.daily_news ALTER COLUMN id SET DEFAULT nextval('public.daily_news_id_seq'::regclass);


--
-- Name: daily_topics id; Type: DEFAULT; Schema: public; Owner: bettafish
--

ALTER TABLE ONLY public.daily_topics ALTER COLUMN id SET DEFAULT nextval('public.daily_topics_id_seq'::regclass);


--
-- Name: topic_news_relation id; Type: DEFAULT; Schema: public; Owner: bettafish
--

ALTER TABLE ONLY public.topic_news_relation ALTER COLUMN id SET DEFAULT nextval('public.topic_news_relation_id_seq'::regclass);


--
-- Data for Name: crawling_tasks; Type: TABLE DATA; Schema: public; Owner: bettafish
--

COPY public.crawling_tasks (id, task_name, platform, status, start_time, end_time, result_count, error_message, created_at) FROM stdin;
\.


--
-- Data for Name: daily_news; Type: TABLE DATA; Schema: public; Owner: bettafish
--

COPY public.daily_news (id, title, content, source, url, publish_time, created_at, updated_at) FROM stdin;
1	PostgreSQL迁移测试	这是一个PostgreSQL数据库迁移测试	测试程序	https://example.com	\N	2025-11-08 13:59:19.954803	\N
\.


--
-- Data for Name: daily_topics; Type: TABLE DATA; Schema: public; Owner: bettafish
--

COPY public.daily_topics (id, topic, platform, heat_score, category, created_at) FROM stdin;
\.


--
-- Data for Name: topic_news_relation; Type: TABLE DATA; Schema: public; Owner: bettafish
--

COPY public.topic_news_relation (id, topic_id, news_id, relevance_score, created_at) FROM stdin;
\.


--
-- Name: crawling_tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bettafish
--

SELECT pg_catalog.setval('public.crawling_tasks_id_seq', 1, false);


--
-- Name: daily_news_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bettafish
--

SELECT pg_catalog.setval('public.daily_news_id_seq', 1, true);


--
-- Name: daily_topics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bettafish
--

SELECT pg_catalog.setval('public.daily_topics_id_seq', 1, false);


--
-- Name: topic_news_relation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: bettafish
--

SELECT pg_catalog.setval('public.topic_news_relation_id_seq', 1, false);


--
-- Name: crawling_tasks crawling_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: bettafish
--

ALTER TABLE ONLY public.crawling_tasks
    ADD CONSTRAINT crawling_tasks_pkey PRIMARY KEY (id);


--
-- Name: daily_news daily_news_pkey; Type: CONSTRAINT; Schema: public; Owner: bettafish
--

ALTER TABLE ONLY public.daily_news
    ADD CONSTRAINT daily_news_pkey PRIMARY KEY (id);


--
-- Name: daily_topics daily_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: bettafish
--

ALTER TABLE ONLY public.daily_topics
    ADD CONSTRAINT daily_topics_pkey PRIMARY KEY (id);


--
-- Name: topic_news_relation topic_news_relation_pkey; Type: CONSTRAINT; Schema: public; Owner: bettafish
--

ALTER TABLE ONLY public.topic_news_relation
    ADD CONSTRAINT topic_news_relation_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict RTISGEWTik9vxydAtRAVWdh8gSgXfAPwZO7VfRUm66243FpKHg3hoiYa3Jffj4R

