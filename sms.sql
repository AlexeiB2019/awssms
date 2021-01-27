--
-- Name: sms; Type: TABLE; Schema: public; Owner: sana
--

CREATE TABLE public.sms (
    id integer NOT NULL,
    url text,
    method text,
    body text,
    origination_number text,
    destination_number text,
    message_body text,
    created timestamp without time zone DEFAULT now()
);


ALTER TABLE public.sms OWNER TO "sana";

--
-- Name: sms_id_seq; Type: SEQUENCE; Schema: public; Owner: sana
--

CREATE SEQUENCE public.sms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sms_id_seq OWNER TO "sana";

--
-- Name: sms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sana
--

ALTER SEQUENCE public.sms_id_seq OWNED BY public.sms.id;

--
-- Name: sms id; Type: DEFAULT; Schema: public; Owner: sana
--

ALTER TABLE ONLY public.sms ALTER COLUMN id SET DEFAULT nextval('public.sms_id_seq'::regclass);
