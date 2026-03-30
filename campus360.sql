--
-- PostgreSQL database dump
--

\restrict 654KGve1EXJdU8LD7vs0W3dVAxkAKBDIc2p11Ukf2Q5XhbVkbSdmbw64Xnxu1g9

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

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
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admission_applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admission_applications (
    application_id bigint NOT NULL,
    applicant_id bigint NOT NULL,
    program_id bigint NOT NULL,
    application_number character varying(50) NOT NULL,
    session_year integer NOT NULL,
    session_type character varying(20) NOT NULL,
    applied_under_quota character varying(30) DEFAULT 'open_merit'::character varying NOT NULL,
    status character varying(30) DEFAULT 'draft'::character varying NOT NULL,
    is_fee_paid boolean DEFAULT false NOT NULL,
    is_eligible boolean,
    is_documents_verified boolean DEFAULT false NOT NULL,
    application_date date DEFAULT CURRENT_DATE NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    submitted_at timestamp without time zone,
    reviewed_at timestamp without time zone,
    decision_at timestamp without time zone,
    CONSTRAINT admission_applications_applied_under_quota_check CHECK (((applied_under_quota)::text = ANY ((ARRAY['open_merit'::character varying, 'minority'::character varying, 'disabled'::character varying, 'sports'::character varying])::text[]))),
    CONSTRAINT admission_applications_session_type_check CHECK (((session_type)::text = ANY ((ARRAY['spring'::character varying, 'fall'::character varying, 'summer'::character varying])::text[]))),
    CONSTRAINT admission_applications_status_check CHECK (((status)::text = ANY ((ARRAY['draft'::character varying, 'submitted'::character varying, 'under_review'::character varying, 'documents_pending'::character varying, 'approved'::character varying, 'rejected'::character varying, 'waitlist'::character varying, 'registered'::character varying])::text[])))
);


ALTER TABLE public.admission_applications OWNER TO postgres;

--
-- Name: admission_applications_application_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admission_applications_application_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admission_applications_application_id_seq OWNER TO postgres;

--
-- Name: admission_applications_application_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admission_applications_application_id_seq OWNED BY public.admission_applications.application_id;


--
-- Name: admission_decisions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admission_decisions (
    decision_id bigint NOT NULL,
    application_id bigint NOT NULL,
    decision character varying(20) NOT NULL,
    decided_by bigint NOT NULL,
    decision_date date DEFAULT CURRENT_DATE NOT NULL,
    remarks text,
    registration_deadline date,
    offered_section character varying(20),
    rejection_reason text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT admission_decisions_decision_check CHECK (((decision)::text = ANY ((ARRAY['approved'::character varying, 'rejected'::character varying, 'waitlist'::character varying])::text[])))
);


ALTER TABLE public.admission_decisions OWNER TO postgres;

--
-- Name: admission_decisions_decision_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admission_decisions_decision_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admission_decisions_decision_id_seq OWNER TO postgres;

--
-- Name: admission_decisions_decision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admission_decisions_decision_id_seq OWNED BY public.admission_decisions.decision_id;


--
-- Name: admission_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admission_logs (
    log_id bigint NOT NULL,
    application_id bigint NOT NULL,
    action_type character varying(50) NOT NULL,
    performed_by bigint NOT NULL,
    previous_status character varying(30),
    new_status character varying(30),
    remarks text,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ip_address inet,
    CONSTRAINT admission_logs_action_type_check CHECK (((action_type)::text = ANY ((ARRAY['created'::character varying, 'submitted'::character varying, 'reviewed'::character varying, 'documents_verified'::character varying, 'approved'::character varying, 'rejected'::character varying, 'waitlisted'::character varying])::text[])))
);


ALTER TABLE public.admission_logs OWNER TO postgres;

--
-- Name: admission_logs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admission_logs_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admission_logs_log_id_seq OWNER TO postgres;

--
-- Name: admission_logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admission_logs_log_id_seq OWNED BY public.admission_logs.log_id;


--
-- Name: ai_degree_recommendations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ai_degree_recommendations (
    recommendation_id bigint NOT NULL,
    applicant_id bigint NOT NULL,
    recommended_program_id bigint NOT NULL,
    confidence_score numeric(3,2),
    recommendation_basis jsonb,
    rank integer,
    generated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    applicant_viewed boolean DEFAULT false NOT NULL,
    applicant_interested boolean,
    feedback_date timestamp without time zone,
    CONSTRAINT ai_degree_recommendations_confidence_score_check CHECK (((confidence_score >= (0)::numeric) AND (confidence_score <= (1)::numeric))),
    CONSTRAINT ai_degree_recommendations_rank_check CHECK ((rank > 0))
);


ALTER TABLE public.ai_degree_recommendations OWNER TO postgres;

--
-- Name: ai_degree_recommendations_recommendation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ai_degree_recommendations_recommendation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ai_degree_recommendations_recommendation_id_seq OWNER TO postgres;

--
-- Name: ai_degree_recommendations_recommendation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ai_degree_recommendations_recommendation_id_seq OWNED BY public.ai_degree_recommendations.recommendation_id;


--
-- Name: announcements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.announcements (
    announcement_id bigint NOT NULL,
    title character varying(200) NOT NULL,
    content text NOT NULL,
    announcement_type character varying(50) NOT NULL,
    target_audience character varying(50) DEFAULT 'all'::character varying NOT NULL,
    target_program_id bigint,
    target_semester_id bigint,
    priority character varying(20) DEFAULT 'normal'::character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    published_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expires_date timestamp without time zone,
    created_by bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT announcements_announcement_type_check CHECK (((announcement_type)::text = ANY ((ARRAY['academic'::character varying, 'event'::character varying, 'holiday'::character varying, 'examination'::character varying, 'admission'::character varying, 'general'::character varying])::text[]))),
    CONSTRAINT announcements_priority_check CHECK (((priority)::text = ANY ((ARRAY['low'::character varying, 'normal'::character varying, 'high'::character varying, 'urgent'::character varying])::text[]))),
    CONSTRAINT announcements_target_audience_check CHECK (((target_audience)::text = ANY ((ARRAY['all'::character varying, 'students'::character varying, 'faculty'::character varying, 'staff'::character varying, 'specific_program'::character varying])::text[])))
);


ALTER TABLE public.announcements OWNER TO postgres;

--
-- Name: announcements_announcement_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.announcements_announcement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.announcements_announcement_id_seq OWNER TO postgres;

--
-- Name: announcements_announcement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.announcements_announcement_id_seq OWNED BY public.announcements.announcement_id;


--
-- Name: applicant_academic_background; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicant_academic_background (
    background_id bigint NOT NULL,
    applicant_id bigint NOT NULL,
    education_level character varying(50) NOT NULL,
    institution_name character varying(200) NOT NULL,
    board_university_name character varying(200) NOT NULL,
    roll_number character varying(50),
    passing_year integer NOT NULL,
    degree_title character varying(200),
    major_subject character varying(100),
    group_name character varying(50),
    total_marks numeric(6,2),
    obtained_marks numeric(6,2),
    percentage numeric(5,2),
    cgpa numeric(3,2),
    grade character varying(10),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT applicant_academic_background_cgpa_check CHECK (((cgpa IS NULL) OR ((cgpa >= (0)::numeric) AND (cgpa <= (4)::numeric)))),
    CONSTRAINT applicant_academic_background_education_level_check CHECK (((education_level)::text = ANY ((ARRAY['matric'::character varying, 'intermediate'::character varying, 'bachelor'::character varying, 'master'::character varying])::text[]))),
    CONSTRAINT applicant_academic_background_passing_year_check CHECK (((passing_year >= 1950) AND ((passing_year)::numeric <= EXTRACT(year FROM CURRENT_DATE)))),
    CONSTRAINT applicant_academic_background_percentage_check CHECK (((percentage IS NULL) OR ((percentage >= (0)::numeric) AND (percentage <= (100)::numeric))))
);


ALTER TABLE public.applicant_academic_background OWNER TO postgres;

--
-- Name: applicant_academic_background_background_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.applicant_academic_background_background_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.applicant_academic_background_background_id_seq OWNER TO postgres;

--
-- Name: applicant_academic_background_background_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.applicant_academic_background_background_id_seq OWNED BY public.applicant_academic_background.background_id;


--
-- Name: applicant_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicant_documents (
    document_id bigint NOT NULL,
    applicant_id bigint NOT NULL,
    document_type character varying(50) NOT NULL,
    file_name character varying(255) NOT NULL,
    file_path character varying(500) NOT NULL,
    file_size integer NOT NULL,
    file_type character varying(50) NOT NULL,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    verified_by bigint,
    verified_at timestamp without time zone,
    verification_remarks text,
    CONSTRAINT applicant_documents_document_type_check CHECK (((document_type)::text = ANY ((ARRAY['matric_certificate'::character varying, 'fsc_certificate'::character varying, 'cnic_front'::character varying, 'cnic_back'::character varying, 'photo'::character varying, 'domicile'::character varying, 'father_cnic'::character varying, 'bachelor_transcript'::character varying, 'master_transcript'::character varying, 'other'::character varying])::text[])))
);


ALTER TABLE public.applicant_documents OWNER TO postgres;

--
-- Name: applicant_documents_document_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.applicant_documents_document_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.applicant_documents_document_id_seq OWNER TO postgres;

--
-- Name: applicant_documents_document_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.applicant_documents_document_id_seq OWNED BY public.applicant_documents.document_id;


--
-- Name: applicants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.applicants (
    applicant_id bigint NOT NULL,
    user_id bigint NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    father_name character varying(100) NOT NULL,
    cnic character varying(15) NOT NULL,
    date_of_birth date NOT NULL,
    gender character varying(10) NOT NULL,
    nationality character varying(50) DEFAULT 'Pakistani'::character varying NOT NULL,
    religion character varying(50),
    phone_number character varying(20) NOT NULL,
    alternate_phone character varying(20),
    current_address text,
    city character varying(100) NOT NULL,
    province character varying(50) NOT NULL,
    postal_code character varying(10),
    country character varying(50) DEFAULT 'Pakistan'::character varying NOT NULL,
    emergency_contact_name character varying(100) NOT NULL,
    emergency_contact_relation character varying(50) NOT NULL,
    emergency_contact_phone character varying(20) NOT NULL,
    profile_completed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT applicants_gender_check CHECK (((gender)::text = ANY ((ARRAY['male'::character varying, 'female'::character varying, 'other'::character varying])::text[])))
);


ALTER TABLE public.applicants OWNER TO postgres;

--
-- Name: applicants_applicant_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.applicants_applicant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.applicants_applicant_id_seq OWNER TO postgres;

--
-- Name: applicants_applicant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.applicants_applicant_id_seq OWNED BY public.applicants.applicant_id;


--
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance (
    attendance_id bigint NOT NULL,
    section_id bigint NOT NULL,
    attendance_date date NOT NULL,
    lecture_number integer,
    topic_covered text,
    marked_by bigint NOT NULL,
    marked_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendance_attendance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendance_attendance_id_seq OWNER TO postgres;

--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_attendance_id_seq OWNED BY public.attendance.attendance_id;


--
-- Name: attendance_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance_records (
    record_id bigint NOT NULL,
    attendance_id bigint NOT NULL,
    student_id bigint NOT NULL,
    registration_id bigint NOT NULL,
    status character varying(20) NOT NULL,
    remarks text,
    CONSTRAINT attendance_records_status_check CHECK (((status)::text = ANY ((ARRAY['present'::character varying, 'absent'::character varying, 'late'::character varying, 'leave'::character varying, 'excused'::character varying])::text[])))
);


ALTER TABLE public.attendance_records OWNER TO postgres;

--
-- Name: attendance_records_record_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendance_records_record_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendance_records_record_id_seq OWNER TO postgres;

--
-- Name: attendance_records_record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_records_record_id_seq OWNED BY public.attendance_records.record_id;


--
-- Name: attendance_reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance_reports (
    report_id bigint NOT NULL,
    course_id bigint NOT NULL,
    semester_id bigint NOT NULL,
    generated_by bigint NOT NULL,
    generated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.attendance_reports OWNER TO postgres;

--
-- Name: attendance_reports_report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendance_reports_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendance_reports_report_id_seq OWNER TO postgres;

--
-- Name: attendance_reports_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_reports_report_id_seq OWNED BY public.attendance_reports.report_id;


--
-- Name: attendance_statistics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance_statistics (
    stat_id bigint NOT NULL,
    semester_id bigint NOT NULL,
    department_id bigint NOT NULL,
    average_attendance numeric(5,2),
    calculated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.attendance_statistics OWNER TO postgres;

--
-- Name: attendance_statistics_stat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendance_statistics_stat_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendance_statistics_stat_id_seq OWNER TO postgres;

--
-- Name: attendance_statistics_stat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_statistics_stat_id_seq OWNED BY public.attendance_statistics.stat_id;


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    log_id bigint NOT NULL,
    user_id bigint,
    action_type character varying(50) NOT NULL,
    table_name character varying(100) NOT NULL,
    record_id bigint,
    old_value jsonb,
    new_value jsonb,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ip_address inet
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- Name: audit_logs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_logs_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_log_id_seq OWNER TO postgres;

--
-- Name: audit_logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_logs_log_id_seq OWNED BY public.audit_logs.log_id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: backup_schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.backup_schedules (
    schedule_id bigint NOT NULL,
    schedule_name character varying(100) NOT NULL,
    frequency character varying(20) NOT NULL,
    backup_time time without time zone NOT NULL,
    retention_days integer NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    CONSTRAINT backup_schedules_frequency_check CHECK (((frequency)::text = ANY ((ARRAY['daily'::character varying, 'weekly'::character varying, 'monthly'::character varying])::text[]))),
    CONSTRAINT backup_schedules_retention_days_check CHECK ((retention_days > 0))
);


ALTER TABLE public.backup_schedules OWNER TO postgres;

--
-- Name: backup_schedules_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.backup_schedules_schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.backup_schedules_schedule_id_seq OWNER TO postgres;

--
-- Name: backup_schedules_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.backup_schedules_schedule_id_seq OWNED BY public.backup_schedules.schedule_id;


--
-- Name: backups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.backups (
    backup_id bigint NOT NULL,
    schedule_id bigint NOT NULL,
    backup_path character varying(500) NOT NULL,
    backup_size bigint,
    status character varying(20) NOT NULL,
    started_at timestamp without time zone NOT NULL,
    completed_at timestamp without time zone,
    CONSTRAINT backups_status_check CHECK (((status)::text = ANY ((ARRAY['success'::character varying, 'failed'::character varying, 'in_progress'::character varying])::text[])))
);


ALTER TABLE public.backups OWNER TO postgres;

--
-- Name: backups_backup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.backups_backup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.backups_backup_id_seq OWNER TO postgres;

--
-- Name: backups_backup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.backups_backup_id_seq OWNED BY public.backups.backup_id;


--
-- Name: challans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.challans (
    challan_id bigint NOT NULL,
    challan_number character varying(50) NOT NULL,
    student_id bigint NOT NULL,
    semester_id bigint NOT NULL,
    issue_date date DEFAULT CURRENT_DATE NOT NULL,
    due_date date NOT NULL,
    tuition_fee numeric(10,2) NOT NULL,
    lab_fee numeric(10,2) DEFAULT 0 NOT NULL,
    library_fee numeric(10,2) DEFAULT 0 NOT NULL,
    sports_fee numeric(10,2) DEFAULT 0 NOT NULL,
    exam_fee numeric(10,2) DEFAULT 0 NOT NULL,
    late_fee numeric(10,2) DEFAULT 0 NOT NULL,
    discount numeric(10,2) DEFAULT 0 NOT NULL,
    subtotal numeric(10,2) NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    amount_paid numeric(10,2) DEFAULT 0 NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    bank_name character varying(100),
    generated_by bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT challans_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'partial'::character varying, 'paid'::character varying, 'overdue'::character varying, 'cancelled'::character varying])::text[])))
);


ALTER TABLE public.challans OWNER TO postgres;

--
-- Name: challans_challan_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.challans_challan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.challans_challan_id_seq OWNER TO postgres;

--
-- Name: challans_challan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.challans_challan_id_seq OWNED BY public.challans.challan_id;


--
-- Name: communication_threads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.communication_threads (
    thread_id bigint NOT NULL,
    complaint_id bigint,
    subject character varying(200) NOT NULL,
    created_by bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.communication_threads OWNER TO postgres;

--
-- Name: communication_threads_thread_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.communication_threads_thread_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.communication_threads_thread_id_seq OWNER TO postgres;

--
-- Name: communication_threads_thread_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.communication_threads_thread_id_seq OWNED BY public.communication_threads.thread_id;


--
-- Name: complaint_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.complaint_assignments (
    assignment_id bigint NOT NULL,
    complaint_id bigint NOT NULL,
    assigned_to bigint NOT NULL,
    assigned_by bigint NOT NULL,
    assigned_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    remarks text
);


ALTER TABLE public.complaint_assignments OWNER TO postgres;

--
-- Name: complaint_assignments_assignment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.complaint_assignments_assignment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.complaint_assignments_assignment_id_seq OWNER TO postgres;

--
-- Name: complaint_assignments_assignment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.complaint_assignments_assignment_id_seq OWNED BY public.complaint_assignments.assignment_id;


--
-- Name: complaint_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.complaint_categories (
    category_id bigint NOT NULL,
    category_name character varying(100) NOT NULL,
    description text
);


ALTER TABLE public.complaint_categories OWNER TO postgres;

--
-- Name: complaint_categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.complaint_categories_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.complaint_categories_category_id_seq OWNER TO postgres;

--
-- Name: complaint_categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.complaint_categories_category_id_seq OWNED BY public.complaint_categories.category_id;


--
-- Name: complaint_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.complaint_logs (
    log_id bigint NOT NULL,
    complaint_id bigint NOT NULL,
    action_type character varying(50) NOT NULL,
    performed_by bigint NOT NULL,
    previous_status character varying(30),
    new_status character varying(30),
    remarks text,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT complaint_logs_action_type_check CHECK (((action_type)::text = ANY ((ARRAY['submitted'::character varying, 'assigned'::character varying, 'updated'::character varying, 'resolved'::character varying, 'closed'::character varying, 'rejected'::character varying])::text[])))
);


ALTER TABLE public.complaint_logs OWNER TO postgres;

--
-- Name: complaint_logs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.complaint_logs_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.complaint_logs_log_id_seq OWNER TO postgres;

--
-- Name: complaint_logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.complaint_logs_log_id_seq OWNED BY public.complaint_logs.log_id;


--
-- Name: complaints; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.complaints (
    complaint_id bigint NOT NULL,
    submitted_by bigint NOT NULL,
    category_id bigint NOT NULL,
    subject character varying(200) NOT NULL,
    description text NOT NULL,
    priority character varying(20) DEFAULT 'medium'::character varying NOT NULL,
    status character varying(30) DEFAULT 'pending'::character varying NOT NULL,
    submitted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    resolved_at timestamp without time zone,
    attachments character varying(500),
    CONSTRAINT complaints_priority_check CHECK (((priority)::text = ANY ((ARRAY['low'::character varying, 'medium'::character varying, 'high'::character varying, 'urgent'::character varying])::text[]))),
    CONSTRAINT complaints_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'assigned'::character varying, 'in_progress'::character varying, 'resolved'::character varying, 'closed'::character varying, 'rejected'::character varying])::text[])))
);


ALTER TABLE public.complaints OWNER TO postgres;

--
-- Name: complaints_complaint_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.complaints_complaint_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.complaints_complaint_id_seq OWNER TO postgres;

--
-- Name: complaints_complaint_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.complaints_complaint_id_seq OWNED BY public.complaints.complaint_id;


--
-- Name: compliance_policies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compliance_policies (
    policy_id bigint NOT NULL,
    policy_title character varying(200) NOT NULL,
    regulation_reference character varying(100),
    description text NOT NULL,
    compliance_requirements jsonb,
    responsible_department_id bigint,
    effective_from date NOT NULL,
    review_date date,
    status character varying(30) DEFAULT 'active'::character varying NOT NULL,
    created_by bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT compliance_policies_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'under_review'::character varying, 'archived'::character varying])::text[])))
);


ALTER TABLE public.compliance_policies OWNER TO postgres;

--
-- Name: compliance_policies_policy_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.compliance_policies_policy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.compliance_policies_policy_id_seq OWNER TO postgres;

--
-- Name: compliance_policies_policy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.compliance_policies_policy_id_seq OWNED BY public.compliance_policies.policy_id;


--
-- Name: course_registrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_registrations (
    registration_id bigint NOT NULL,
    enrollment_id bigint NOT NULL,
    course_id bigint NOT NULL,
    section_id bigint NOT NULL,
    student_id bigint NOT NULL,
    registration_date date DEFAULT CURRENT_DATE NOT NULL,
    status character varying(20) DEFAULT 'registered'::character varying NOT NULL,
    dropped_date date,
    drop_reason text,
    final_grade_id bigint,
    grade_points numeric(3,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT course_registrations_status_check CHECK (((status)::text = ANY ((ARRAY['registered'::character varying, 'dropped'::character varying, 'withdrawn'::character varying, 'completed'::character varying])::text[])))
);


ALTER TABLE public.course_registrations OWNER TO postgres;

--
-- Name: course_registrations_registration_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_registrations_registration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.course_registrations_registration_id_seq OWNER TO postgres;

--
-- Name: course_registrations_registration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_registrations_registration_id_seq OWNED BY public.course_registrations.registration_id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    course_id bigint NOT NULL,
    department_id bigint NOT NULL,
    course_code character varying(20) NOT NULL,
    course_name character varying(200) NOT NULL,
    credit_hours integer NOT NULL,
    theory_credit_hours integer DEFAULT 0 NOT NULL,
    lab_credit_hours integer DEFAULT 0 NOT NULL,
    course_type character varying(20) NOT NULL,
    description text,
    course_outline text,
    learning_outcomes text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT courses_course_type_check CHECK (((course_type)::text = ANY ((ARRAY['core'::character varying, 'elective'::character varying, 'university_requirement'::character varying])::text[]))),
    CONSTRAINT courses_credit_hours_check CHECK (((credit_hours >= 1) AND (credit_hours <= 6)))
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- Name: courses_course_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.courses_course_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.courses_course_id_seq OWNER TO postgres;

--
-- Name: courses_course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.courses_course_id_seq OWNED BY public.courses.course_id;


--
-- Name: degree_programs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.degree_programs (
    program_id bigint NOT NULL,
    department_id bigint NOT NULL,
    program_name character varying(200) NOT NULL,
    program_code character varying(20) NOT NULL,
    degree_level character varying(20) NOT NULL,
    duration_years integer NOT NULL,
    total_semesters integer NOT NULL,
    total_credit_hours integer NOT NULL,
    program_type character varying(30) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    description text,
    fee_per_semester numeric(10,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT degree_programs_degree_level_check CHECK (((degree_level)::text = ANY ((ARRAY['BS'::character varying, 'MS'::character varying, 'PhD'::character varying])::text[]))),
    CONSTRAINT degree_programs_duration_years_check CHECK (((duration_years >= 1) AND (duration_years <= 8))),
    CONSTRAINT degree_programs_program_type_check CHECK (((program_type)::text = ANY ((ARRAY['morning'::character varying, 'evening'::character varying, 'self_support'::character varying, 'distance_learning'::character varying])::text[]))),
    CONSTRAINT degree_programs_total_credit_hours_check CHECK ((total_credit_hours >= 60)),
    CONSTRAINT degree_programs_total_semesters_check CHECK (((total_semesters >= 2) AND (total_semesters <= 16)))
);


ALTER TABLE public.degree_programs OWNER TO postgres;

--
-- Name: degree_programs_program_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.degree_programs_program_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.degree_programs_program_id_seq OWNER TO postgres;

--
-- Name: degree_programs_program_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.degree_programs_program_id_seq OWNED BY public.degree_programs.program_id;


--
-- Name: degree_verification_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.degree_verification_requests (
    request_id bigint NOT NULL,
    student_id bigint NOT NULL,
    requested_by_name character varying(200) NOT NULL,
    requested_by_email character varying(255) NOT NULL,
    requested_by_phone character varying(20),
    purpose text NOT NULL,
    request_date date DEFAULT CURRENT_DATE NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    verified_by bigint,
    verification_date date,
    verification_document_path character varying(500),
    remarks text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT degree_verification_requests_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'in_progress'::character varying, 'verified'::character varying, 'rejected'::character varying])::text[])))
);


ALTER TABLE public.degree_verification_requests OWNER TO postgres;

--
-- Name: degree_verification_requests_request_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.degree_verification_requests_request_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.degree_verification_requests_request_id_seq OWNER TO postgres;

--
-- Name: degree_verification_requests_request_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.degree_verification_requests_request_id_seq OWNED BY public.degree_verification_requests.request_id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    department_id bigint NOT NULL,
    department_name character varying(100) NOT NULL,
    department_code character varying(20) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departments_department_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departments_department_id_seq OWNER TO postgres;

--
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departments_department_id_seq OWNED BY public.departments.department_id;


--
-- Name: designations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.designations (
    designation_id bigint NOT NULL,
    designation_title character varying(100) NOT NULL,
    designation_level integer,
    job_description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.designations OWNER TO postgres;

--
-- Name: designations_designation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.designations_designation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.designations_designation_id_seq OWNER TO postgres;

--
-- Name: designations_designation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.designations_designation_id_seq OWNED BY public.designations.designation_id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: eligibility_criteria; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.eligibility_criteria (
    criteria_id bigint NOT NULL,
    program_id bigint NOT NULL,
    min_matric_percentage numeric(5,2),
    min_fsc_percentage numeric(5,2),
    min_bachelor_cgpa numeric(3,2),
    min_master_cgpa numeric(3,2),
    required_fsc_group character varying(50),
    other_requirements jsonb,
    effective_from date NOT NULL,
    effective_to date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT eligibility_criteria_min_bachelor_cgpa_check CHECK (((min_bachelor_cgpa IS NULL) OR ((min_bachelor_cgpa >= (0)::numeric) AND (min_bachelor_cgpa <= (4)::numeric)))),
    CONSTRAINT eligibility_criteria_min_fsc_percentage_check CHECK (((min_fsc_percentage IS NULL) OR ((min_fsc_percentage >= (0)::numeric) AND (min_fsc_percentage <= (100)::numeric)))),
    CONSTRAINT eligibility_criteria_min_master_cgpa_check CHECK (((min_master_cgpa IS NULL) OR ((min_master_cgpa >= (0)::numeric) AND (min_master_cgpa <= (4)::numeric)))),
    CONSTRAINT eligibility_criteria_min_matric_percentage_check CHECK (((min_matric_percentage IS NULL) OR ((min_matric_percentage >= (0)::numeric) AND (min_matric_percentage <= (100)::numeric))))
);


ALTER TABLE public.eligibility_criteria OWNER TO postgres;

--
-- Name: eligibility_criteria_criteria_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.eligibility_criteria_criteria_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eligibility_criteria_criteria_id_seq OWNER TO postgres;

--
-- Name: eligibility_criteria_criteria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.eligibility_criteria_criteria_id_seq OWNED BY public.eligibility_criteria.criteria_id;


--
-- Name: email_verifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_verifications (
    verification_id bigint NOT NULL,
    user_id bigint NOT NULL,
    verification_token text NOT NULL,
    password text NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    verified_at timestamp without time zone,
    is_verified boolean DEFAULT false NOT NULL
);


ALTER TABLE public.email_verifications OWNER TO postgres;

--
-- Name: email_verifications_verification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.email_verifications_verification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.email_verifications_verification_id_seq OWNER TO postgres;

--
-- Name: email_verifications_verification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.email_verifications_verification_id_seq OWNED BY public.email_verifications.verification_id;


--
-- Name: employee_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_profiles (
    profile_id bigint NOT NULL,
    employee_id bigint NOT NULL,
    employee_type character varying(10) NOT NULL,
    cnic character varying(15) NOT NULL,
    date_of_birth date NOT NULL,
    gender character varying(10),
    phone_number character varying(20) NOT NULL,
    emergency_contact_name character varying(100) NOT NULL,
    emergency_contact_phone character varying(20) NOT NULL,
    emergency_contact_relation character varying(50) NOT NULL,
    current_address text NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT employee_profiles_employee_type_check CHECK (((employee_type)::text = ANY ((ARRAY['faculty'::character varying, 'staff'::character varying])::text[]))),
    CONSTRAINT employee_profiles_gender_check CHECK (((gender)::text = ANY ((ARRAY['male'::character varying, 'female'::character varying, 'other'::character varying])::text[])))
);


ALTER TABLE public.employee_profiles OWNER TO postgres;

--
-- Name: employee_profiles_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employee_profiles_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employee_profiles_profile_id_seq OWNER TO postgres;

--
-- Name: employee_profiles_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employee_profiles_profile_id_seq OWNED BY public.employee_profiles.profile_id;


--
-- Name: enrollments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enrollments (
    enrollment_id bigint NOT NULL,
    student_id bigint NOT NULL,
    semester_id bigint NOT NULL,
    enrollment_date date DEFAULT CURRENT_DATE NOT NULL,
    status character varying(20) DEFAULT 'enrolled'::character varying NOT NULL,
    total_credit_hours_registered integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT enrollments_status_check CHECK (((status)::text = ANY ((ARRAY['enrolled'::character varying, 'completed'::character varying, 'withdrawn'::character varying])::text[])))
);


ALTER TABLE public.enrollments OWNER TO postgres;

--
-- Name: enrollments_enrollment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.enrollments_enrollment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.enrollments_enrollment_id_seq OWNER TO postgres;

--
-- Name: enrollments_enrollment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.enrollments_enrollment_id_seq OWNED BY public.enrollments.enrollment_id;


--
-- Name: error_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.error_logs (
    error_id bigint NOT NULL,
    user_id bigint,
    error_code character varying(50),
    error_message text NOT NULL,
    stack_trace text,
    occurred_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.error_logs OWNER TO postgres;

--
-- Name: error_logs_error_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.error_logs_error_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.error_logs_error_id_seq OWNER TO postgres;

--
-- Name: error_logs_error_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.error_logs_error_id_seq OWNED BY public.error_logs.error_id;


--
-- Name: exam_schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exam_schedules (
    schedule_id bigint NOT NULL,
    exam_id bigint NOT NULL,
    exam_date date NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    duration_minutes integer,
    room_number character varying(20) NOT NULL,
    building_name character varying(100),
    student_count integer,
    invigilator_id bigint,
    created_by bigint,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.exam_schedules OWNER TO postgres;

--
-- Name: exam_schedules_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exam_schedules_schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exam_schedules_schedule_id_seq OWNER TO postgres;

--
-- Name: exam_schedules_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exam_schedules_schedule_id_seq OWNED BY public.exam_schedules.schedule_id;


--
-- Name: exam_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exam_types (
    exam_type_id bigint NOT NULL,
    type_name character varying(50) NOT NULL,
    weightage_percentage numeric(5,2) NOT NULL,
    description text,
    CONSTRAINT exam_types_weightage_percentage_check CHECK (((weightage_percentage >= (0)::numeric) AND (weightage_percentage <= (100)::numeric)))
);


ALTER TABLE public.exam_types OWNER TO postgres;

--
-- Name: exam_types_exam_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exam_types_exam_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.exam_types_exam_type_id_seq OWNER TO postgres;

--
-- Name: exam_types_exam_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exam_types_exam_type_id_seq OWNED BY public.exam_types.exam_type_id;


--
-- Name: examinations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.examinations (
    exam_id bigint NOT NULL,
    course_id bigint NOT NULL,
    semester_id bigint NOT NULL,
    section_id bigint NOT NULL,
    exam_type_id bigint NOT NULL,
    exam_name character varying(200) NOT NULL,
    exam_date date NOT NULL,
    start_time time without time zone,
    end_time time without time zone,
    duration_minutes integer,
    total_marks numeric(6,2) NOT NULL,
    passing_marks numeric(6,2) NOT NULL,
    created_by bigint,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.examinations OWNER TO postgres;

--
-- Name: examinations_exam_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.examinations_exam_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.examinations_exam_id_seq OWNER TO postgres;

--
-- Name: examinations_exam_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.examinations_exam_id_seq OWNED BY public.examinations.exam_id;


--
-- Name: faculty; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faculty (
    faculty_id bigint NOT NULL,
    user_id bigint NOT NULL,
    department_id bigint NOT NULL,
    designation_id bigint NOT NULL,
    employee_code character varying(50) NOT NULL,
    qualification character varying(100) NOT NULL,
    specialization character varying(200),
    joining_date date NOT NULL,
    employment_type character varying(30) NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    office_floor character varying(20),
    office_hours character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT faculty_employment_type_check CHECK (((employment_type)::text = ANY ((ARRAY['permanent'::character varying, 'visiting'::character varying, 'contractual'::character varying])::text[]))),
    CONSTRAINT faculty_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'on_leave'::character varying, 'resigned'::character varying, 'retired'::character varying])::text[])))
);


ALTER TABLE public.faculty OWNER TO postgres;

--
-- Name: faculty_faculty_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faculty_faculty_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_faculty_id_seq OWNER TO postgres;

--
-- Name: faculty_faculty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faculty_faculty_id_seq OWNED BY public.faculty.faculty_id;


--
-- Name: fee_structures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fee_structures (
    structure_id bigint NOT NULL,
    program_id bigint NOT NULL,
    semester_number integer,
    fee_type character varying(50) NOT NULL,
    tuition_fee numeric(10,2) DEFAULT 0 NOT NULL,
    lab_fee numeric(10,2) DEFAULT 0 NOT NULL,
    library_fee numeric(10,2) DEFAULT 0 NOT NULL,
    sports_fee numeric(10,2) DEFAULT 0 NOT NULL,
    exam_fee numeric(10,2) DEFAULT 0 NOT NULL,
    other_charges numeric(10,2) DEFAULT 0 NOT NULL,
    total_fee numeric(10,2) GENERATED ALWAYS AS ((((((tuition_fee + lab_fee) + library_fee) + sports_fee) + exam_fee) + other_charges)) STORED,
    effective_from date NOT NULL,
    effective_to date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fee_structures_fee_type_check CHECK (((fee_type)::text = ANY ((ARRAY['semester_fee'::character varying, 'admission_fee'::character varying, 'examination_fee'::character varying, 'library_fee'::character varying])::text[]))),
    CONSTRAINT fee_structures_semester_number_check CHECK (((semester_number IS NULL) OR ((semester_number >= 1) AND (semester_number <= 16))))
);


ALTER TABLE public.fee_structures OWNER TO postgres;

--
-- Name: fee_structures_structure_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fee_structures_structure_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fee_structures_structure_id_seq OWNER TO postgres;

--
-- Name: fee_structures_structure_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fee_structures_structure_id_seq OWNED BY public.fee_structures.structure_id;


--
-- Name: feedback; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feedback (
    feedback_id bigint NOT NULL,
    complaint_id bigint NOT NULL,
    user_id bigint NOT NULL,
    rating integer,
    comments text,
    submitted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT feedback_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.feedback OWNER TO postgres;

--
-- Name: feedback_feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feedback_feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.feedback_feedback_id_seq OWNER TO postgres;

--
-- Name: feedback_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feedback_feedback_id_seq OWNED BY public.feedback.feedback_id;


--
-- Name: final_grades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.final_grades (
    final_grade_id bigint NOT NULL,
    registration_id bigint NOT NULL,
    student_id bigint NOT NULL,
    course_id bigint NOT NULL,
    semester_id bigint NOT NULL,
    total_obtained_marks numeric(6,2) NOT NULL,
    total_marks numeric(6,2) NOT NULL,
    percentage numeric(5,2) NOT NULL,
    grade_id bigint NOT NULL,
    status character varying(20) NOT NULL,
    verified_by bigint,
    verified_at timestamp without time zone,
    CONSTRAINT final_grades_status_check CHECK (((status)::text = ANY ((ARRAY['pass'::character varying, 'fail'::character varying, 'incomplete'::character varying, 'withdrawn'::character varying])::text[])))
);


ALTER TABLE public.final_grades OWNER TO postgres;

--
-- Name: final_grades_final_grade_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.final_grades_final_grade_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.final_grades_final_grade_id_seq OWNER TO postgres;

--
-- Name: final_grades_final_grade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.final_grades_final_grade_id_seq OWNED BY public.final_grades.final_grade_id;


--
-- Name: financial_reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.financial_reports (
    report_id bigint NOT NULL,
    report_type character varying(100) NOT NULL,
    period_from date NOT NULL,
    period_to date NOT NULL,
    total_revenue numeric(12,2),
    total_outstanding numeric(12,2),
    total_scholarships numeric(12,2),
    report_data jsonb,
    file_path character varying(500),
    generated_by bigint NOT NULL,
    generated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT financial_reports_report_type_check CHECK (((report_type)::text = ANY ((ARRAY['monthly_collection'::character varying, 'outstanding_dues'::character varying, 'scholarship_disbursement'::character varying, 'program_wise_revenue'::character varying])::text[])))
);


ALTER TABLE public.financial_reports OWNER TO postgres;

--
-- Name: financial_reports_report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.financial_reports_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.financial_reports_report_id_seq OWNER TO postgres;

--
-- Name: financial_reports_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.financial_reports_report_id_seq OWNED BY public.financial_reports.report_id;


--
-- Name: grade; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grade (
    grade_id bigint NOT NULL,
    grade_letter character varying(5) NOT NULL,
    min_percentage numeric(5,2) NOT NULL,
    max_percentage numeric(5,2) NOT NULL,
    grade_points numeric(3,2) NOT NULL,
    status character varying(10) NOT NULL,
    description text,
    CONSTRAINT check_percentage_range CHECK ((min_percentage < max_percentage)),
    CONSTRAINT grade_grade_points_check CHECK (((grade_points >= (0)::numeric) AND (grade_points <= (4)::numeric))),
    CONSTRAINT grade_max_percentage_check CHECK (((max_percentage >= (0)::numeric) AND (max_percentage <= (100)::numeric))),
    CONSTRAINT grade_min_percentage_check CHECK (((min_percentage >= (0)::numeric) AND (min_percentage <= (100)::numeric))),
    CONSTRAINT grade_status_check CHECK (((status)::text = ANY ((ARRAY['pass'::character varying, 'fail'::character varying])::text[])))
);


ALTER TABLE public.grade OWNER TO postgres;

--
-- Name: grade_grade_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grade_grade_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.grade_grade_id_seq OWNER TO postgres;

--
-- Name: grade_grade_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grade_grade_id_seq OWNED BY public.grade.grade_id;


--
-- Name: login_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.login_sessions (
    session_id bigint NOT NULL,
    user_id bigint NOT NULL,
    login_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    logout_time timestamp without time zone,
    ip_address inet,
    device_info text,
    session_token text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    expires_at timestamp without time zone NOT NULL
);


ALTER TABLE public.login_sessions OWNER TO postgres;

--
-- Name: login_sessions_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.login_sessions_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.login_sessions_session_id_seq OWNER TO postgres;

--
-- Name: login_sessions_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.login_sessions_session_id_seq OWNED BY public.login_sessions.session_id;


--
-- Name: maintenance_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maintenance_logs (
    maintenance_id bigint NOT NULL,
    maintenance_type character varying(50) NOT NULL,
    description text NOT NULL,
    scheduled_start timestamp without time zone NOT NULL,
    scheduled_end timestamp without time zone NOT NULL,
    actual_start timestamp without time zone,
    actual_end timestamp without time zone,
    performed_by bigint NOT NULL,
    status character varying(30) DEFAULT 'scheduled'::character varying NOT NULL,
    impact_level character varying(20) NOT NULL,
    affected_modules jsonb,
    remarks text,
    CONSTRAINT maintenance_logs_impact_level_check CHECK (((impact_level)::text = ANY ((ARRAY['low'::character varying, 'medium'::character varying, 'high'::character varying, 'critical'::character varying])::text[]))),
    CONSTRAINT maintenance_logs_maintenance_type_check CHECK (((maintenance_type)::text = ANY ((ARRAY['scheduled_maintenance'::character varying, 'emergency_maintenance'::character varying, 'system_upgrade'::character varying, 'data_migration'::character varying])::text[]))),
    CONSTRAINT maintenance_logs_status_check CHECK (((status)::text = ANY ((ARRAY['scheduled'::character varying, 'in_progress'::character varying, 'completed'::character varying, 'cancelled'::character varying])::text[])))
);


ALTER TABLE public.maintenance_logs OWNER TO postgres;

--
-- Name: maintenance_logs_maintenance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.maintenance_logs_maintenance_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.maintenance_logs_maintenance_id_seq OWNER TO postgres;

--
-- Name: maintenance_logs_maintenance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.maintenance_logs_maintenance_id_seq OWNED BY public.maintenance_logs.maintenance_id;


--
-- Name: marks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.marks (
    marks_id bigint NOT NULL,
    exam_id bigint NOT NULL,
    student_id bigint NOT NULL,
    registration_id bigint NOT NULL,
    obtained_marks numeric(6,2),
    is_absent boolean DEFAULT false NOT NULL,
    remarks text,
    entered_by bigint NOT NULL,
    entered_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by bigint,
    modified_at timestamp without time zone
);


ALTER TABLE public.marks OWNER TO postgres;

--
-- Name: marks_marks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.marks_marks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.marks_marks_id_seq OWNER TO postgres;

--
-- Name: marks_marks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.marks_marks_id_seq OWNED BY public.marks.marks_id;


--
-- Name: marksheets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.marksheets (
    marksheet_id bigint NOT NULL,
    result_id bigint NOT NULL,
    student_id bigint NOT NULL,
    semester_id bigint NOT NULL,
    marksheet_number character varying(50) NOT NULL,
    issue_date date DEFAULT CURRENT_DATE NOT NULL,
    verified_by bigint,
    verification_date date,
    is_official boolean DEFAULT true NOT NULL
);


ALTER TABLE public.marksheets OWNER TO postgres;

--
-- Name: marksheets_marksheet_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.marksheets_marksheet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.marksheets_marksheet_id_seq OWNER TO postgres;

--
-- Name: marksheets_marksheet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.marksheets_marksheet_id_seq OWNED BY public.marksheets.marksheet_id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    message_id bigint NOT NULL,
    thread_id bigint NOT NULL,
    sender_id bigint NOT NULL,
    message_text text NOT NULL,
    sent_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_read boolean DEFAULT false NOT NULL
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: messages_message_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.messages_message_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.messages_message_id_seq OWNER TO postgres;

--
-- Name: messages_message_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.messages_message_id_seq OWNED BY public.messages.message_id;


--
-- Name: notification_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_type (
    type_id bigint NOT NULL,
    type_name character varying(50) NOT NULL,
    template text,
    description text
);


ALTER TABLE public.notification_type OWNER TO postgres;

--
-- Name: notification_type_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_type_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notification_type_type_id_seq OWNER TO postgres;

--
-- Name: notification_type_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_type_type_id_seq OWNED BY public.notification_type.type_id;


--
-- Name: password_resets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_resets (
    reset_id bigint NOT NULL,
    user_id bigint NOT NULL,
    reset_token text NOT NULL,
    requested_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    used_at timestamp without time zone,
    is_used boolean DEFAULT false NOT NULL
);


ALTER TABLE public.password_resets OWNER TO postgres;

--
-- Name: password_resets_reset_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.password_resets_reset_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.password_resets_reset_id_seq OWNER TO postgres;

--
-- Name: password_resets_reset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.password_resets_reset_id_seq OWNED BY public.password_resets.reset_id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    payment_id bigint NOT NULL,
    challan_id bigint NOT NULL,
    student_id bigint NOT NULL,
    amount numeric(10,2) NOT NULL,
    payment_date date DEFAULT CURRENT_DATE NOT NULL,
    payment_time time without time zone DEFAULT CURRENT_TIME NOT NULL,
    payment_method character varying(20) NOT NULL,
    bank_name character varying(100),
    transaction_id character varying(100),
    receipt_number character varying(50) NOT NULL,
    recorded_by bigint NOT NULL,
    verified_by bigint,
    remarks text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT payments_payment_method_check CHECK (((payment_method)::text = ANY ((ARRAY['bank_challan'::character varying, 'cash'::character varying])::text[])))
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_payment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_payment_id_seq OWNER TO postgres;

--
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    permission_id bigint NOT NULL,
    permission_name character varying(100) NOT NULL,
    module_name character varying(50) NOT NULL,
    action_type character varying(50) NOT NULL,
    description text,
    CONSTRAINT permissions_action_type_check CHECK (((action_type)::text = ANY ((ARRAY['create'::character varying, 'read'::character varying, 'update'::character varying, 'delete'::character varying, 'approve'::character varying, 'export'::character varying])::text[])))
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: permissions_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permissions_permission_id_seq OWNER TO postgres;

--
-- Name: permissions_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_permission_id_seq OWNED BY public.permissions.permission_id;


--
-- Name: prerequisites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prerequisites (
    prerequisite_id bigint NOT NULL,
    course_id bigint NOT NULL,
    prerequisite_course_id bigint NOT NULL,
    is_mandatory boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_prerequisites_no_self_reference CHECK ((course_id <> prerequisite_course_id))
);


ALTER TABLE public.prerequisites OWNER TO postgres;

--
-- Name: prerequisites_prerequisite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prerequisites_prerequisite_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.prerequisites_prerequisite_id_seq OWNER TO postgres;

--
-- Name: prerequisites_prerequisite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prerequisites_prerequisite_id_seq OWNED BY public.prerequisites.prerequisite_id;


--
-- Name: program_courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.program_courses (
    program_course_id bigint NOT NULL,
    program_id bigint NOT NULL,
    course_id bigint NOT NULL,
    semester_number integer NOT NULL,
    is_core boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT program_courses_semester_number_check CHECK (((semester_number >= 1) AND (semester_number <= 16)))
);


ALTER TABLE public.program_courses OWNER TO postgres;

--
-- Name: program_courses_program_course_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.program_courses_program_course_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.program_courses_program_course_id_seq OWNER TO postgres;

--
-- Name: program_courses_program_course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.program_courses_program_course_id_seq OWNED BY public.program_courses.program_course_id;


--
-- Name: report_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.report_types (
    report_type_id bigint NOT NULL,
    report_name character varying(100) NOT NULL,
    description text,
    module_name character varying(50)
);


ALTER TABLE public.report_types OWNER TO postgres;

--
-- Name: report_types_report_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.report_types_report_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.report_types_report_type_id_seq OWNER TO postgres;

--
-- Name: report_types_report_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.report_types_report_type_id_seq OWNED BY public.report_types.report_type_id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reports (
    report_id bigint NOT NULL,
    report_type_id bigint NOT NULL,
    generated_by bigint NOT NULL,
    parameters jsonb,
    file_path character varying(500),
    generated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.reports OWNER TO postgres;

--
-- Name: reports_report_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.reports_report_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reports_report_id_seq OWNER TO postgres;

--
-- Name: reports_report_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.reports_report_id_seq OWNED BY public.reports.report_id;


--
-- Name: result_approvals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.result_approvals (
    approval_id bigint NOT NULL,
    result_id bigint NOT NULL,
    approved_by bigint NOT NULL,
    approval_date date DEFAULT CURRENT_DATE NOT NULL,
    remarks text
);


ALTER TABLE public.result_approvals OWNER TO postgres;

--
-- Name: result_approvals_approval_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.result_approvals_approval_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.result_approvals_approval_id_seq OWNER TO postgres;

--
-- Name: result_approvals_approval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.result_approvals_approval_id_seq OWNED BY public.result_approvals.approval_id;


--
-- Name: results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.results (
    result_id bigint NOT NULL,
    student_id bigint NOT NULL,
    semester_id bigint NOT NULL,
    sgpa numeric(3,2),
    cgpa numeric(3,2),
    total_credit_hours_attempted integer,
    total_credit_hours_earned integer,
    status character varying(20) NOT NULL,
    published_date date,
    published_by bigint,
    is_published boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT results_cgpa_check CHECK (((cgpa IS NULL) OR ((cgpa >= (0)::numeric) AND (cgpa <= (4)::numeric)))),
    CONSTRAINT results_sgpa_check CHECK (((sgpa IS NULL) OR ((sgpa >= (0)::numeric) AND (sgpa <= (4)::numeric)))),
    CONSTRAINT results_status_check CHECK (((status)::text = ANY ((ARRAY['pass'::character varying, 'fail'::character varying, 'incomplete'::character varying, 'probation'::character varying])::text[])))
);


ALTER TABLE public.results OWNER TO postgres;

--
-- Name: results_result_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.results_result_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.results_result_id_seq OWNER TO postgres;

--
-- Name: results_result_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.results_result_id_seq OWNED BY public.results.result_id;


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role_permissions (
    role_permission_id bigint NOT NULL,
    role_id bigint NOT NULL,
    permission_id bigint NOT NULL,
    granted_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO postgres;

--
-- Name: role_permissions_role_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_permissions_role_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_permissions_role_permission_id_seq OWNER TO postgres;

--
-- Name: role_permissions_role_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_permissions_role_permission_id_seq OWNED BY public.role_permissions.role_permission_id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id bigint NOT NULL,
    role_name character varying(50) NOT NULL,
    description text,
    is_system_role boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_role_id_seq OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_role_id_seq OWNED BY public.roles.role_id;


--
-- Name: scholarships; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scholarships (
    scholarship_id bigint NOT NULL,
    student_id bigint NOT NULL,
    scholarship_type character varying(50) NOT NULL,
    amount numeric(10,2),
    percentage numeric(5,2),
    semester_id bigint,
    start_date date NOT NULL,
    end_date date,
    is_active boolean DEFAULT true NOT NULL,
    awarded_date date DEFAULT CURRENT_DATE NOT NULL,
    awarded_by bigint,
    remarks text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT scholarships_percentage_check CHECK (((percentage IS NULL) OR ((percentage >= (0)::numeric) AND (percentage <= (100)::numeric)))),
    CONSTRAINT scholarships_scholarship_type_check CHECK (((scholarship_type)::text = ANY ((ARRAY['merit'::character varying, 'need_based'::character varying, 'sports'::character varying, 'employee_child'::character varying, 'minority'::character varying, 'disability'::character varying, 'other'::character varying])::text[])))
);


ALTER TABLE public.scholarships OWNER TO postgres;

--
-- Name: scholarships_scholarship_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scholarships_scholarship_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.scholarships_scholarship_id_seq OWNER TO postgres;

--
-- Name: scholarships_scholarship_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scholarships_scholarship_id_seq OWNED BY public.scholarships.scholarship_id;


--
-- Name: section_schedules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.section_schedules (
    schedule_id bigint NOT NULL,
    section_id bigint NOT NULL,
    day_of_week character varying(10) NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    room_number character varying(20) NOT NULL,
    building_name character varying(100),
    schedule_type character varying(20) DEFAULT 'lecture'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_schedule_time CHECK ((end_time > start_time)),
    CONSTRAINT section_schedules_day_of_week_check CHECK (((day_of_week)::text = ANY ((ARRAY['Monday'::character varying, 'Tuesday'::character varying, 'Wednesday'::character varying, 'Thursday'::character varying, 'Friday'::character varying, 'Saturday'::character varying, 'Sunday'::character varying])::text[]))),
    CONSTRAINT section_schedules_schedule_type_check CHECK (((schedule_type)::text = ANY ((ARRAY['lecture'::character varying, 'lab'::character varying, 'tutorial'::character varying])::text[])))
);


ALTER TABLE public.section_schedules OWNER TO postgres;

--
-- Name: section_schedules_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.section_schedules_schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.section_schedules_schedule_id_seq OWNER TO postgres;

--
-- Name: section_schedules_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.section_schedules_schedule_id_seq OWNED BY public.section_schedules.schedule_id;


--
-- Name: sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sections (
    section_id bigint NOT NULL,
    course_id bigint NOT NULL,
    semester_id bigint NOT NULL,
    faculty_id bigint NOT NULL,
    section_name character varying(5) NOT NULL,
    section_type character varying(30) NOT NULL,
    max_capacity integer NOT NULL,
    enrolled_count integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT sections_max_capacity_check CHECK ((max_capacity > 0)),
    CONSTRAINT sections_section_type_check CHECK (((section_type)::text = ANY ((ARRAY['theory'::character varying, 'lab'::character varying, 'theory_lab_combined'::character varying])::text[])))
);


ALTER TABLE public.sections OWNER TO postgres;

--
-- Name: sections_section_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sections_section_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sections_section_id_seq OWNER TO postgres;

--
-- Name: sections_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sections_section_id_seq OWNED BY public.sections.section_id;


--
-- Name: security_policies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.security_policies (
    policy_id bigint NOT NULL,
    policy_name character varying(100) NOT NULL,
    policy_type character varying(50) NOT NULL,
    policy_content jsonb NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    effective_from date NOT NULL,
    effective_to date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updates_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT security_policies_policy_type_check CHECK (((policy_type)::text = ANY ((ARRAY['password_policy'::character varying, 'session_policy'::character varying, 'access_policy'::character varying])::text[])))
);


ALTER TABLE public.security_policies OWNER TO postgres;

--
-- Name: security_policies_policy_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.security_policies_policy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.security_policies_policy_id_seq OWNER TO postgres;

--
-- Name: security_policies_policy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.security_policies_policy_id_seq OWNED BY public.security_policies.policy_id;


--
-- Name: semesters; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.semesters (
    semester_id bigint NOT NULL,
    semester_name character varying(50) NOT NULL,
    academic_year integer NOT NULL,
    semester_type character varying(20) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    is_current boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT check_semester_dates CHECK ((end_date > start_date)),
    CONSTRAINT semesters_semester_type_check CHECK (((semester_type)::text = ANY ((ARRAY['fall'::character varying, 'spring'::character varying, 'summer'::character varying])::text[])))
);


ALTER TABLE public.semesters OWNER TO postgres;

--
-- Name: semesters_semester_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.semesters_semester_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.semesters_semester_id_seq OWNER TO postgres;

--
-- Name: semesters_semester_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.semesters_semester_id_seq OWNED BY public.semesters.semester_id;


--
-- Name: staff_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.staff_members (
    staff_id bigint NOT NULL,
    user_id bigint NOT NULL,
    department_id bigint NOT NULL,
    designation_id bigint NOT NULL,
    employee_code character varying(50) NOT NULL,
    joining_date date NOT NULL,
    employment_type character varying(30) NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT staff_members_employment_type_check CHECK (((employment_type)::text = ANY ((ARRAY['permanent'::character varying, 'contractual'::character varying, 'temporary'::character varying])::text[]))),
    CONSTRAINT staff_members_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'on_leave'::character varying, 'resigned'::character varying, 'retired'::character varying])::text[])))
);


ALTER TABLE public.staff_members OWNER TO postgres;

--
-- Name: staff_members_staff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.staff_members_staff_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.staff_members_staff_id_seq OWNER TO postgres;

--
-- Name: staff_members_staff_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.staff_members_staff_id_seq OWNED BY public.staff_members.staff_id;


--
-- Name: student_academic_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_academic_records (
    record_id bigint NOT NULL,
    student_id bigint NOT NULL,
    semester_id bigint NOT NULL,
    semester_number integer NOT NULL,
    sgpa numeric(3,2),
    cgpa numeric(3,2),
    total_credit_hours_semester integer,
    earned_credit_hours_semester integer,
    total_credit_hours_cumulative integer,
    earned_credit_hours_cumulative integer,
    semester_status character varying(20) DEFAULT 'in_progress'::character varying NOT NULL,
    calculated_at timestamp without time zone,
    verified_by bigint,
    verified_at timestamp without time zone,
    CONSTRAINT student_academic_records_cgpa_check CHECK (((cgpa IS NULL) OR ((cgpa >= (0)::numeric) AND (cgpa <= (4)::numeric)))),
    CONSTRAINT student_academic_records_semester_status_check CHECK (((semester_status)::text = ANY ((ARRAY['in_progress'::character varying, 'completed'::character varying, 'dropped'::character varying, 'failed'::character varying])::text[]))),
    CONSTRAINT student_academic_records_sgpa_check CHECK (((sgpa IS NULL) OR ((sgpa >= (0)::numeric) AND (sgpa <= (4)::numeric))))
);


ALTER TABLE public.student_academic_records OWNER TO postgres;

--
-- Name: student_academic_records_record_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_academic_records_record_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_academic_records_record_id_seq OWNER TO postgres;

--
-- Name: student_academic_records_record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_academic_records_record_id_seq OWNED BY public.student_academic_records.record_id;


--
-- Name: student_attendance_summaries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_attendance_summaries (
    summary_id bigint NOT NULL,
    student_id bigint NOT NULL,
    course_id bigint NOT NULL,
    section_id bigint NOT NULL,
    semester_id bigint NOT NULL,
    total_lectures integer DEFAULT 0 NOT NULL,
    attended_lectures integer DEFAULT 0 NOT NULL,
    late_count integer DEFAULT 0 NOT NULL,
    leave_count integer DEFAULT 0 NOT NULL,
    attendance_percentage numeric(5,2),
    is_below_threshold boolean DEFAULT false NOT NULL,
    last_updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.student_attendance_summaries OWNER TO postgres;

--
-- Name: student_attendance_summaries_summary_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_attendance_summaries_summary_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_attendance_summaries_summary_id_seq OWNER TO postgres;

--
-- Name: student_attendance_summaries_summary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_attendance_summaries_summary_id_seq OWNED BY public.student_attendance_summaries.summary_id;


--
-- Name: student_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_history (
    history_id bigint NOT NULL,
    student_id bigint NOT NULL,
    event_type character varying(50) NOT NULL,
    event_date date NOT NULL,
    from_status character varying(20),
    to_status character varying(20),
    description text,
    recorded_by bigint NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT student_history_event_type_check CHECK (((event_type)::text = ANY ((ARRAY['enrollment'::character varying, 'semester_completion'::character varying, 'promotion'::character varying, 'transfer'::character varying, 'suspension'::character varying, 'leave'::character varying, 'graduation'::character varying, 'dropout'::character varying, 'expulsion'::character varying])::text[])))
);


ALTER TABLE public.student_history OWNER TO postgres;

--
-- Name: student_history_history_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_history_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_history_history_id_seq OWNER TO postgres;

--
-- Name: student_history_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_history_history_id_seq OWNED BY public.student_history.history_id;


--
-- Name: student_leave_applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_leave_applications (
    leave_id bigint NOT NULL,
    student_id bigint NOT NULL,
    leave_type character varying(30) NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL,
    total_days integer,
    reason text NOT NULL,
    supporting_document_path character varying(500),
    applied_date date DEFAULT CURRENT_DATE NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    CONSTRAINT chk_leave_dates CHECK ((to_date >= from_date)),
    CONSTRAINT student_leave_applications_leave_type_check CHECK (((leave_type)::text = ANY ((ARRAY['medical'::character varying, 'emergency'::character varying, 'personal'::character varying, 'academic'::character varying])::text[]))),
    CONSTRAINT student_leave_applications_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'approved'::character varying, 'rejected'::character varying])::text[])))
);


ALTER TABLE public.student_leave_applications OWNER TO postgres;

--
-- Name: student_leave_applications_leave_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_leave_applications_leave_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_leave_applications_leave_id_seq OWNER TO postgres;

--
-- Name: student_leave_applications_leave_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_leave_applications_leave_id_seq OWNED BY public.student_leave_applications.leave_id;


--
-- Name: student_leave_decisions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_leave_decisions (
    decision_id bigint NOT NULL,
    leave_id bigint NOT NULL,
    decided_by bigint NOT NULL,
    decision character varying(20) NOT NULL,
    decision_date date DEFAULT CURRENT_DATE NOT NULL,
    remarks text,
    CONSTRAINT student_leave_decisions_decision_check CHECK (((decision)::text = ANY ((ARRAY['approved'::character varying, 'rejected'::character varying])::text[])))
);


ALTER TABLE public.student_leave_decisions OWNER TO postgres;

--
-- Name: student_leave_decisions_decision_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_leave_decisions_decision_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_leave_decisions_decision_id_seq OWNER TO postgres;

--
-- Name: student_leave_decisions_decision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_leave_decisions_decision_id_seq OWNED BY public.student_leave_decisions.decision_id;


--
-- Name: student_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_profiles (
    profile_id bigint NOT NULL,
    student_id bigint NOT NULL,
    blood_group character varying(5),
    medical_conditions text,
    disabilities text,
    previous_university character varying(200),
    previous_cgpa numeric(3,2),
    guardian_name character varying(100),
    guardian_cnic character varying(15),
    guardian_phone character varying(20),
    guardian_occupation character varying(100),
    residential_address text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT student_profiles_previous_cgpa_check CHECK (((previous_cgpa IS NULL) OR ((previous_cgpa >= (0)::numeric) AND (previous_cgpa <= (4)::numeric))))
);


ALTER TABLE public.student_profiles OWNER TO postgres;

--
-- Name: student_profiles_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_profiles_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_profiles_profile_id_seq OWNER TO postgres;

--
-- Name: student_profiles_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_profiles_profile_id_seq OWNED BY public.student_profiles.profile_id;


--
-- Name: student_scholarship_applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_scholarship_applications (
    scholarship_app_id bigint NOT NULL,
    student_id bigint NOT NULL,
    scholarship_type character varying(50) NOT NULL,
    applied_date date DEFAULT CURRENT_DATE NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    documents_submitted text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT student_scholarship_applications_scholarship_type_check CHECK (((scholarship_type)::text = ANY ((ARRAY['merit'::character varying, 'need_based'::character varying, 'sports'::character varying, 'employee_child'::character varying, 'minority'::character varying, 'disability'::character varying])::text[]))),
    CONSTRAINT student_scholarship_applications_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'under_review'::character varying, 'approved'::character varying, 'rejected'::character varying])::text[])))
);


ALTER TABLE public.student_scholarship_applications OWNER TO postgres;

--
-- Name: student_scholarship_applications_scholarship_app_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_scholarship_applications_scholarship_app_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_scholarship_applications_scholarship_app_id_seq OWNER TO postgres;

--
-- Name: student_scholarship_applications_scholarship_app_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_scholarship_applications_scholarship_app_id_seq OWNED BY public.student_scholarship_applications.scholarship_app_id;


--
-- Name: student_scholarship_decisions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_scholarship_decisions (
    decision_id bigint NOT NULL,
    scholarship_app_id bigint NOT NULL,
    approved_by bigint NOT NULL,
    decision character varying(20) NOT NULL,
    amount_awarded numeric(10,2),
    decision_date date DEFAULT CURRENT_DATE NOT NULL,
    remarks text,
    CONSTRAINT student_scholarship_decisions_decision_check CHECK (((decision)::text = ANY ((ARRAY['approved'::character varying, 'rejected'::character varying])::text[])))
);


ALTER TABLE public.student_scholarship_decisions OWNER TO postgres;

--
-- Name: student_scholarship_decisions_decision_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_scholarship_decisions_decision_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_scholarship_decisions_decision_id_seq OWNER TO postgres;

--
-- Name: student_scholarship_decisions_decision_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_scholarship_decisions_decision_id_seq OWNED BY public.student_scholarship_decisions.decision_id;


--
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    student_id bigint NOT NULL,
    user_id bigint NOT NULL,
    applicant_id bigint,
    program_id bigint NOT NULL,
    registration_number character varying(50) NOT NULL,
    batch_year integer NOT NULL,
    current_semester integer DEFAULT 1 NOT NULL,
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    cgpa numeric(3,2) DEFAULT 0.00 NOT NULL,
    total_credit_hours_completed integer DEFAULT 0 NOT NULL,
    admission_date date NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT students_cgpa_check CHECK (((cgpa >= (0)::numeric) AND (cgpa <= (4)::numeric))),
    CONSTRAINT students_current_semester_check CHECK (((current_semester >= 1) AND (current_semester <= 16))),
    CONSTRAINT students_status_check CHECK (((status)::text = ANY ((ARRAY['active'::character varying, 'on_leave'::character varying, 'suspended'::character varying, 'graduated'::character varying, 'dropped'::character varying, 'expelled'::character varying])::text[])))
);


ALTER TABLE public.students OWNER TO postgres;

--
-- Name: students_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_student_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_student_id_seq OWNER TO postgres;

--
-- Name: students_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_student_id_seq OWNED BY public.students.student_id;


--
-- Name: system_configuration; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_configuration (
    config_id bigint NOT NULL,
    config_key character varying(100) NOT NULL,
    config_value text NOT NULL,
    data_type character varying(20) NOT NULL,
    category character varying(50) NOT NULL,
    description text,
    is_editable boolean DEFAULT true NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_by bigint,
    CONSTRAINT system_configuration_category_check CHECK (((category)::text = ANY ((ARRAY['general'::character varying, 'academic'::character varying, 'financial'::character varying, 'security'::character varying])::text[]))),
    CONSTRAINT system_configuration_data_type_check CHECK (((data_type)::text = ANY ((ARRAY['string'::character varying, 'number'::character varying, 'boolean'::character varying, 'date'::character varying, 'json'::character varying])::text[])))
);


ALTER TABLE public.system_configuration OWNER TO postgres;

--
-- Name: system_configuration_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.system_configuration_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_configuration_config_id_seq OWNER TO postgres;

--
-- Name: system_configuration_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.system_configuration_config_id_seq OWNED BY public.system_configuration.config_id;


--
-- Name: system_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_logs (
    log_id bigint NOT NULL,
    log_level character varying(20) NOT NULL,
    module_name character varying(50) NOT NULL,
    event_type character varying(50),
    user_id bigint,
    message text NOT NULL,
    stack_trace text,
    ip_address inet,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT system_logs_log_level_check CHECK (((log_level)::text = ANY ((ARRAY['debug'::character varying, 'info'::character varying, 'warning'::character varying, 'error'::character varying, 'critical'::character varying])::text[])))
);


ALTER TABLE public.system_logs OWNER TO postgres;

--
-- Name: system_logs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.system_logs_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_logs_log_id_seq OWNER TO postgres;

--
-- Name: system_logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.system_logs_log_id_seq OWNED BY public.system_logs.log_id;


--
-- Name: transcript_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transcript_requests (
    transcript_id bigint NOT NULL,
    student_id bigint NOT NULL,
    request_date date DEFAULT CURRENT_DATE NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    fee_amount numeric(10,2),
    fee_paid boolean DEFAULT false NOT NULL,
    processed_by bigint,
    processed_date date,
    dispatch_date date,
    tracking_number character varying(100),
    remarks text,
    CONSTRAINT transcript_requests_status_check CHECK (((status)::text = ANY ((ARRAY['pending'::character varying, 'processing'::character varying, 'ready'::character varying, 'dispatched'::character varying, 'delivered'::character varying])::text[])))
);


ALTER TABLE public.transcript_requests OWNER TO postgres;

--
-- Name: transcript_requests_transcript_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transcript_requests_transcript_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transcript_requests_transcript_id_seq OWNER TO postgres;

--
-- Name: transcript_requests_transcript_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transcript_requests_transcript_id_seq OWNED BY public.transcript_requests.transcript_id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    user_role_id bigint NOT NULL,
    user_id bigint NOT NULL,
    role_id bigint NOT NULL,
    assigned_date timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    assigned_by bigint,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: user_roles_user_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_roles_user_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_roles_user_role_id_seq OWNER TO postgres;

--
-- Name: user_roles_user_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_roles_user_role_id_seq OWNED BY public.user_roles.user_role_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id bigint NOT NULL,
    username character varying(50) NOT NULL,
    password text NOT NULL,
    is_email_active boolean DEFAULT true NOT NULL,
    last_login timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: workload_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.workload_assignments (
    workload_id bigint NOT NULL,
    faculty_id bigint NOT NULL,
    semester_id bigint NOT NULL,
    total_sections integer DEFAULT 0 NOT NULL,
    total_credit_hours integer DEFAULT 0 NOT NULL,
    total_students integer DEFAULT 0 NOT NULL,
    administrative_duties jsonb,
    last_calculated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.workload_assignments OWNER TO postgres;

--
-- Name: workload_assignments_workload_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.workload_assignments_workload_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.workload_assignments_workload_id_seq OWNER TO postgres;

--
-- Name: workload_assignments_workload_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.workload_assignments_workload_id_seq OWNED BY public.workload_assignments.workload_id;


--
-- Name: admission_applications application_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_applications ALTER COLUMN application_id SET DEFAULT nextval('public.admission_applications_application_id_seq'::regclass);


--
-- Name: admission_decisions decision_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_decisions ALTER COLUMN decision_id SET DEFAULT nextval('public.admission_decisions_decision_id_seq'::regclass);


--
-- Name: admission_logs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_logs ALTER COLUMN log_id SET DEFAULT nextval('public.admission_logs_log_id_seq'::regclass);


--
-- Name: ai_degree_recommendations recommendation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_degree_recommendations ALTER COLUMN recommendation_id SET DEFAULT nextval('public.ai_degree_recommendations_recommendation_id_seq'::regclass);


--
-- Name: announcements announcement_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements ALTER COLUMN announcement_id SET DEFAULT nextval('public.announcements_announcement_id_seq'::regclass);


--
-- Name: applicant_academic_background background_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_academic_background ALTER COLUMN background_id SET DEFAULT nextval('public.applicant_academic_background_background_id_seq'::regclass);


--
-- Name: applicant_documents document_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_documents ALTER COLUMN document_id SET DEFAULT nextval('public.applicant_documents_document_id_seq'::regclass);


--
-- Name: applicants applicant_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicants ALTER COLUMN applicant_id SET DEFAULT nextval('public.applicants_applicant_id_seq'::regclass);


--
-- Name: attendance attendance_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance ALTER COLUMN attendance_id SET DEFAULT nextval('public.attendance_attendance_id_seq'::regclass);


--
-- Name: attendance_records record_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_records ALTER COLUMN record_id SET DEFAULT nextval('public.attendance_records_record_id_seq'::regclass);


--
-- Name: attendance_reports report_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_reports ALTER COLUMN report_id SET DEFAULT nextval('public.attendance_reports_report_id_seq'::regclass);


--
-- Name: attendance_statistics stat_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_statistics ALTER COLUMN stat_id SET DEFAULT nextval('public.attendance_statistics_stat_id_seq'::regclass);


--
-- Name: audit_logs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN log_id SET DEFAULT nextval('public.audit_logs_log_id_seq'::regclass);


--
-- Name: backup_schedules schedule_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.backup_schedules ALTER COLUMN schedule_id SET DEFAULT nextval('public.backup_schedules_schedule_id_seq'::regclass);


--
-- Name: backups backup_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.backups ALTER COLUMN backup_id SET DEFAULT nextval('public.backups_backup_id_seq'::regclass);


--
-- Name: challans challan_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challans ALTER COLUMN challan_id SET DEFAULT nextval('public.challans_challan_id_seq'::regclass);


--
-- Name: communication_threads thread_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.communication_threads ALTER COLUMN thread_id SET DEFAULT nextval('public.communication_threads_thread_id_seq'::regclass);


--
-- Name: complaint_assignments assignment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint_assignments ALTER COLUMN assignment_id SET DEFAULT nextval('public.complaint_assignments_assignment_id_seq'::regclass);


--
-- Name: complaint_categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint_categories ALTER COLUMN category_id SET DEFAULT nextval('public.complaint_categories_category_id_seq'::regclass);


--
-- Name: complaint_logs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint_logs ALTER COLUMN log_id SET DEFAULT nextval('public.complaint_logs_log_id_seq'::regclass);


--
-- Name: complaints complaint_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaints ALTER COLUMN complaint_id SET DEFAULT nextval('public.complaints_complaint_id_seq'::regclass);


--
-- Name: compliance_policies policy_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compliance_policies ALTER COLUMN policy_id SET DEFAULT nextval('public.compliance_policies_policy_id_seq'::regclass);


--
-- Name: course_registrations registration_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_registrations ALTER COLUMN registration_id SET DEFAULT nextval('public.course_registrations_registration_id_seq'::regclass);


--
-- Name: courses course_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses ALTER COLUMN course_id SET DEFAULT nextval('public.courses_course_id_seq'::regclass);


--
-- Name: degree_programs program_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degree_programs ALTER COLUMN program_id SET DEFAULT nextval('public.degree_programs_program_id_seq'::regclass);


--
-- Name: degree_verification_requests request_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degree_verification_requests ALTER COLUMN request_id SET DEFAULT nextval('public.degree_verification_requests_request_id_seq'::regclass);


--
-- Name: departments department_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN department_id SET DEFAULT nextval('public.departments_department_id_seq'::regclass);


--
-- Name: designations designation_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designations ALTER COLUMN designation_id SET DEFAULT nextval('public.designations_designation_id_seq'::regclass);


--
-- Name: eligibility_criteria criteria_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eligibility_criteria ALTER COLUMN criteria_id SET DEFAULT nextval('public.eligibility_criteria_criteria_id_seq'::regclass);


--
-- Name: email_verifications verification_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_verifications ALTER COLUMN verification_id SET DEFAULT nextval('public.email_verifications_verification_id_seq'::regclass);


--
-- Name: employee_profiles profile_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_profiles ALTER COLUMN profile_id SET DEFAULT nextval('public.employee_profiles_profile_id_seq'::regclass);


--
-- Name: enrollments enrollment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments ALTER COLUMN enrollment_id SET DEFAULT nextval('public.enrollments_enrollment_id_seq'::regclass);


--
-- Name: error_logs error_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.error_logs ALTER COLUMN error_id SET DEFAULT nextval('public.error_logs_error_id_seq'::regclass);


--
-- Name: exam_schedules schedule_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_schedules ALTER COLUMN schedule_id SET DEFAULT nextval('public.exam_schedules_schedule_id_seq'::regclass);


--
-- Name: exam_types exam_type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_types ALTER COLUMN exam_type_id SET DEFAULT nextval('public.exam_types_exam_type_id_seq'::regclass);


--
-- Name: examinations exam_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examinations ALTER COLUMN exam_id SET DEFAULT nextval('public.examinations_exam_id_seq'::regclass);


--
-- Name: faculty faculty_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty ALTER COLUMN faculty_id SET DEFAULT nextval('public.faculty_faculty_id_seq'::regclass);


--
-- Name: fee_structures structure_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fee_structures ALTER COLUMN structure_id SET DEFAULT nextval('public.fee_structures_structure_id_seq'::regclass);


--
-- Name: feedback feedback_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback ALTER COLUMN feedback_id SET DEFAULT nextval('public.feedback_feedback_id_seq'::regclass);


--
-- Name: final_grades final_grade_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_grades ALTER COLUMN final_grade_id SET DEFAULT nextval('public.final_grades_final_grade_id_seq'::regclass);


--
-- Name: financial_reports report_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financial_reports ALTER COLUMN report_id SET DEFAULT nextval('public.financial_reports_report_id_seq'::regclass);


--
-- Name: grade grade_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade ALTER COLUMN grade_id SET DEFAULT nextval('public.grade_grade_id_seq'::regclass);


--
-- Name: login_sessions session_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_sessions ALTER COLUMN session_id SET DEFAULT nextval('public.login_sessions_session_id_seq'::regclass);


--
-- Name: maintenance_logs maintenance_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_logs ALTER COLUMN maintenance_id SET DEFAULT nextval('public.maintenance_logs_maintenance_id_seq'::regclass);


--
-- Name: marks marks_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marks ALTER COLUMN marks_id SET DEFAULT nextval('public.marks_marks_id_seq'::regclass);


--
-- Name: marksheets marksheet_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marksheets ALTER COLUMN marksheet_id SET DEFAULT nextval('public.marksheets_marksheet_id_seq'::regclass);


--
-- Name: messages message_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages ALTER COLUMN message_id SET DEFAULT nextval('public.messages_message_id_seq'::regclass);


--
-- Name: notification_type type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_type ALTER COLUMN type_id SET DEFAULT nextval('public.notification_type_type_id_seq'::regclass);


--
-- Name: password_resets reset_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_resets ALTER COLUMN reset_id SET DEFAULT nextval('public.password_resets_reset_id_seq'::regclass);


--
-- Name: payments payment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- Name: permissions permission_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN permission_id SET DEFAULT nextval('public.permissions_permission_id_seq'::regclass);


--
-- Name: prerequisites prerequisite_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prerequisites ALTER COLUMN prerequisite_id SET DEFAULT nextval('public.prerequisites_prerequisite_id_seq'::regclass);


--
-- Name: program_courses program_course_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_courses ALTER COLUMN program_course_id SET DEFAULT nextval('public.program_courses_program_course_id_seq'::regclass);


--
-- Name: report_types report_type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_types ALTER COLUMN report_type_id SET DEFAULT nextval('public.report_types_report_type_id_seq'::regclass);


--
-- Name: reports report_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports ALTER COLUMN report_id SET DEFAULT nextval('public.reports_report_id_seq'::regclass);


--
-- Name: result_approvals approval_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.result_approvals ALTER COLUMN approval_id SET DEFAULT nextval('public.result_approvals_approval_id_seq'::regclass);


--
-- Name: results result_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results ALTER COLUMN result_id SET DEFAULT nextval('public.results_result_id_seq'::regclass);


--
-- Name: role_permissions role_permission_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions ALTER COLUMN role_permission_id SET DEFAULT nextval('public.role_permissions_role_permission_id_seq'::regclass);


--
-- Name: roles role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN role_id SET DEFAULT nextval('public.roles_role_id_seq'::regclass);


--
-- Name: scholarships scholarship_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scholarships ALTER COLUMN scholarship_id SET DEFAULT nextval('public.scholarships_scholarship_id_seq'::regclass);


--
-- Name: section_schedules schedule_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section_schedules ALTER COLUMN schedule_id SET DEFAULT nextval('public.section_schedules_schedule_id_seq'::regclass);


--
-- Name: sections section_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections ALTER COLUMN section_id SET DEFAULT nextval('public.sections_section_id_seq'::regclass);


--
-- Name: security_policies policy_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.security_policies ALTER COLUMN policy_id SET DEFAULT nextval('public.security_policies_policy_id_seq'::regclass);


--
-- Name: semesters semester_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semesters ALTER COLUMN semester_id SET DEFAULT nextval('public.semesters_semester_id_seq'::regclass);


--
-- Name: staff_members staff_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_members ALTER COLUMN staff_id SET DEFAULT nextval('public.staff_members_staff_id_seq'::regclass);


--
-- Name: student_academic_records record_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_academic_records ALTER COLUMN record_id SET DEFAULT nextval('public.student_academic_records_record_id_seq'::regclass);


--
-- Name: student_attendance_summaries summary_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_attendance_summaries ALTER COLUMN summary_id SET DEFAULT nextval('public.student_attendance_summaries_summary_id_seq'::regclass);


--
-- Name: student_history history_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_history ALTER COLUMN history_id SET DEFAULT nextval('public.student_history_history_id_seq'::regclass);


--
-- Name: student_leave_applications leave_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_leave_applications ALTER COLUMN leave_id SET DEFAULT nextval('public.student_leave_applications_leave_id_seq'::regclass);


--
-- Name: student_leave_decisions decision_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_leave_decisions ALTER COLUMN decision_id SET DEFAULT nextval('public.student_leave_decisions_decision_id_seq'::regclass);


--
-- Name: student_profiles profile_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profiles ALTER COLUMN profile_id SET DEFAULT nextval('public.student_profiles_profile_id_seq'::regclass);


--
-- Name: student_scholarship_applications scholarship_app_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_scholarship_applications ALTER COLUMN scholarship_app_id SET DEFAULT nextval('public.student_scholarship_applications_scholarship_app_id_seq'::regclass);


--
-- Name: student_scholarship_decisions decision_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_scholarship_decisions ALTER COLUMN decision_id SET DEFAULT nextval('public.student_scholarship_decisions_decision_id_seq'::regclass);


--
-- Name: students student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN student_id SET DEFAULT nextval('public.students_student_id_seq'::regclass);


--
-- Name: system_configuration config_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_configuration ALTER COLUMN config_id SET DEFAULT nextval('public.system_configuration_config_id_seq'::regclass);


--
-- Name: system_logs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_logs ALTER COLUMN log_id SET DEFAULT nextval('public.system_logs_log_id_seq'::regclass);


--
-- Name: transcript_requests transcript_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transcript_requests ALTER COLUMN transcript_id SET DEFAULT nextval('public.transcript_requests_transcript_id_seq'::regclass);


--
-- Name: user_roles user_role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN user_role_id SET DEFAULT nextval('public.user_roles_user_role_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: workload_assignments workload_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workload_assignments ALTER COLUMN workload_id SET DEFAULT nextval('public.workload_assignments_workload_id_seq'::regclass);


--
-- Data for Name: admission_applications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admission_applications (application_id, applicant_id, program_id, application_number, session_year, session_type, applied_under_quota, status, is_fee_paid, is_eligible, is_documents_verified, application_date, created_at, submitted_at, reviewed_at, decision_at) FROM stdin;
\.


--
-- Data for Name: admission_decisions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admission_decisions (decision_id, application_id, decision, decided_by, decision_date, remarks, registration_deadline, offered_section, rejection_reason, created_at) FROM stdin;
\.


--
-- Data for Name: admission_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admission_logs (log_id, application_id, action_type, performed_by, previous_status, new_status, remarks, "timestamp", ip_address) FROM stdin;
\.


--
-- Data for Name: ai_degree_recommendations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ai_degree_recommendations (recommendation_id, applicant_id, recommended_program_id, confidence_score, recommendation_basis, rank, generated_at, applicant_viewed, applicant_interested, feedback_date) FROM stdin;
\.


--
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.announcements (announcement_id, title, content, announcement_type, target_audience, target_program_id, target_semester_id, priority, is_active, published_date, expires_date, created_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: applicant_academic_background; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applicant_academic_background (background_id, applicant_id, education_level, institution_name, board_university_name, roll_number, passing_year, degree_title, major_subject, group_name, total_marks, obtained_marks, percentage, cgpa, grade, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: applicant_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applicant_documents (document_id, applicant_id, document_type, file_name, file_path, file_size, file_type, uploaded_at, is_verified, verified_by, verified_at, verification_remarks) FROM stdin;
\.


--
-- Data for Name: applicants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.applicants (applicant_id, user_id, first_name, last_name, father_name, cnic, date_of_birth, gender, nationality, religion, phone_number, alternate_phone, current_address, city, province, postal_code, country, emergency_contact_name, emergency_contact_relation, emergency_contact_phone, profile_completed, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (attendance_id, section_id, attendance_date, lecture_number, topic_covered, marked_by, marked_at) FROM stdin;
\.


--
-- Data for Name: attendance_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance_records (record_id, attendance_id, student_id, registration_id, status, remarks) FROM stdin;
\.


--
-- Data for Name: attendance_reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance_reports (report_id, course_id, semester_id, generated_by, generated_at) FROM stdin;
\.


--
-- Data for Name: attendance_statistics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance_statistics (stat_id, semester_id, department_id, average_attendance, calculated_at) FROM stdin;
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (log_id, user_id, action_type, table_name, record_id, old_value, new_value, "timestamp", ip_address) FROM stdin;
\.


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	3	add_permission
6	Can change permission	3	change_permission
7	Can delete permission	3	delete_permission
8	Can view permission	3	view_permission
9	Can add group	2	add_group
10	Can change group	2	change_group
11	Can delete group	2	delete_group
12	Can view group	2	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: backup_schedules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.backup_schedules (schedule_id, schedule_name, frequency, backup_time, retention_days, is_active) FROM stdin;
\.


--
-- Data for Name: backups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.backups (backup_id, schedule_id, backup_path, backup_size, status, started_at, completed_at) FROM stdin;
\.


--
-- Data for Name: challans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.challans (challan_id, challan_number, student_id, semester_id, issue_date, due_date, tuition_fee, lab_fee, library_fee, sports_fee, exam_fee, late_fee, discount, subtotal, total_amount, amount_paid, status, bank_name, generated_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: communication_threads; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.communication_threads (thread_id, complaint_id, subject, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: complaint_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.complaint_assignments (assignment_id, complaint_id, assigned_to, assigned_by, assigned_date, remarks) FROM stdin;
\.


--
-- Data for Name: complaint_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.complaint_categories (category_id, category_name, description) FROM stdin;
\.


--
-- Data for Name: complaint_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.complaint_logs (log_id, complaint_id, action_type, performed_by, previous_status, new_status, remarks, "timestamp") FROM stdin;
\.


--
-- Data for Name: complaints; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.complaints (complaint_id, submitted_by, category_id, subject, description, priority, status, submitted_at, resolved_at, attachments) FROM stdin;
\.


--
-- Data for Name: compliance_policies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compliance_policies (policy_id, policy_title, regulation_reference, description, compliance_requirements, responsible_department_id, effective_from, review_date, status, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: course_registrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_registrations (registration_id, enrollment_id, course_id, section_id, student_id, registration_date, status, dropped_date, drop_reason, final_grade_id, grade_points, created_at) FROM stdin;
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (course_id, department_id, course_code, course_name, credit_hours, theory_credit_hours, lab_credit_hours, course_type, description, course_outline, learning_outcomes, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: degree_programs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.degree_programs (program_id, department_id, program_name, program_code, degree_level, duration_years, total_semesters, total_credit_hours, program_type, is_active, description, fee_per_semester, created_at) FROM stdin;
\.


--
-- Data for Name: degree_verification_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.degree_verification_requests (request_id, student_id, requested_by_name, requested_by_email, requested_by_phone, purpose, request_date, status, verified_by, verification_date, verification_document_path, remarks, created_at) FROM stdin;
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (department_id, department_name, department_code, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: designations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.designations (designation_id, designation_title, designation_level, job_description, created_at) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	group
3	auth	permission
4	auth	user
5	contenttypes	contenttype
6	sessions	session
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2026-03-20 01:06:16.35499+05
2	auth	0001_initial	2026-03-20 01:06:16.871688+05
3	admin	0001_initial	2026-03-20 01:06:16.987298+05
4	admin	0002_logentry_remove_auto_add	2026-03-20 01:06:17.030261+05
5	admin	0003_logentry_add_action_flag_choices	2026-03-20 01:06:17.075209+05
6	contenttypes	0002_remove_content_type_name	2026-03-20 01:06:17.202235+05
7	auth	0002_alter_permission_name_max_length	2026-03-20 01:06:17.24463+05
8	auth	0003_alter_user_email_max_length	2026-03-20 01:06:17.317333+05
9	auth	0004_alter_user_username_opts	2026-03-20 01:06:17.365767+05
10	auth	0005_alter_user_last_login_null	2026-03-20 01:06:17.39536+05
11	auth	0006_require_contenttypes_0002	2026-03-20 01:06:17.414118+05
12	auth	0007_alter_validators_add_error_messages	2026-03-20 01:06:17.466825+05
13	auth	0008_alter_user_username_max_length	2026-03-20 01:06:17.645082+05
14	auth	0009_alter_user_last_name_max_length	2026-03-20 01:06:17.80681+05
15	auth	0010_alter_group_name_max_length	2026-03-20 01:06:17.864479+05
16	auth	0011_update_proxy_permissions	2026-03-20 01:06:17.896174+05
17	auth	0012_alter_user_first_name_max_length	2026-03-20 01:06:18.053465+05
18	sessions	0001_initial	2026-03-20 01:06:18.100408+05
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- Data for Name: eligibility_criteria; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.eligibility_criteria (criteria_id, program_id, min_matric_percentage, min_fsc_percentage, min_bachelor_cgpa, min_master_cgpa, required_fsc_group, other_requirements, effective_from, effective_to, created_at) FROM stdin;
\.


--
-- Data for Name: email_verifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.email_verifications (verification_id, user_id, verification_token, password, created_at, expires_at, verified_at, is_verified) FROM stdin;
\.


--
-- Data for Name: employee_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_profiles (profile_id, employee_id, employee_type, cnic, date_of_birth, gender, phone_number, emergency_contact_name, emergency_contact_phone, emergency_contact_relation, current_address, updated_at) FROM stdin;
\.


--
-- Data for Name: enrollments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.enrollments (enrollment_id, student_id, semester_id, enrollment_date, status, total_credit_hours_registered, created_at) FROM stdin;
\.


--
-- Data for Name: error_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.error_logs (error_id, user_id, error_code, error_message, stack_trace, occurred_at) FROM stdin;
\.


--
-- Data for Name: exam_schedules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exam_schedules (schedule_id, exam_id, exam_date, start_time, end_time, duration_minutes, room_number, building_name, student_count, invigilator_id, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: exam_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.exam_types (exam_type_id, type_name, weightage_percentage, description) FROM stdin;
\.


--
-- Data for Name: examinations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.examinations (exam_id, course_id, semester_id, section_id, exam_type_id, exam_name, exam_date, start_time, end_time, duration_minutes, total_marks, passing_marks, created_by, created_at) FROM stdin;
\.


--
-- Data for Name: faculty; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faculty (faculty_id, user_id, department_id, designation_id, employee_code, qualification, specialization, joining_date, employment_type, status, office_floor, office_hours, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: fee_structures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fee_structures (structure_id, program_id, semester_number, fee_type, tuition_fee, lab_fee, library_fee, sports_fee, exam_fee, other_charges, effective_from, effective_to, created_at) FROM stdin;
\.


--
-- Data for Name: feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feedback (feedback_id, complaint_id, user_id, rating, comments, submitted_at) FROM stdin;
\.


--
-- Data for Name: final_grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.final_grades (final_grade_id, registration_id, student_id, course_id, semester_id, total_obtained_marks, total_marks, percentage, grade_id, status, verified_by, verified_at) FROM stdin;
\.


--
-- Data for Name: financial_reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.financial_reports (report_id, report_type, period_from, period_to, total_revenue, total_outstanding, total_scholarships, report_data, file_path, generated_by, generated_at) FROM stdin;
\.


--
-- Data for Name: grade; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grade (grade_id, grade_letter, min_percentage, max_percentage, grade_points, status, description) FROM stdin;
\.


--
-- Data for Name: login_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.login_sessions (session_id, user_id, login_time, logout_time, ip_address, device_info, session_token, is_active, expires_at) FROM stdin;
\.


--
-- Data for Name: maintenance_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.maintenance_logs (maintenance_id, maintenance_type, description, scheduled_start, scheduled_end, actual_start, actual_end, performed_by, status, impact_level, affected_modules, remarks) FROM stdin;
\.


--
-- Data for Name: marks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.marks (marks_id, exam_id, student_id, registration_id, obtained_marks, is_absent, remarks, entered_by, entered_at, modified_by, modified_at) FROM stdin;
\.


--
-- Data for Name: marksheets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.marksheets (marksheet_id, result_id, student_id, semester_id, marksheet_number, issue_date, verified_by, verification_date, is_official) FROM stdin;
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.messages (message_id, thread_id, sender_id, message_text, sent_at, is_read) FROM stdin;
\.


--
-- Data for Name: notification_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_type (type_id, type_name, template, description) FROM stdin;
\.


--
-- Data for Name: password_resets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_resets (reset_id, user_id, reset_token, requested_at, expires_at, used_at, is_used) FROM stdin;
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (payment_id, challan_id, student_id, amount, payment_date, payment_time, payment_method, bank_name, transaction_id, receipt_number, recorded_by, verified_by, remarks, created_at) FROM stdin;
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (permission_id, permission_name, module_name, action_type, description) FROM stdin;
\.


--
-- Data for Name: prerequisites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.prerequisites (prerequisite_id, course_id, prerequisite_course_id, is_mandatory, created_at) FROM stdin;
\.


--
-- Data for Name: program_courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program_courses (program_course_id, program_id, course_id, semester_number, is_core, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: report_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.report_types (report_type_id, report_name, description, module_name) FROM stdin;
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.reports (report_id, report_type_id, generated_by, parameters, file_path, generated_at) FROM stdin;
\.


--
-- Data for Name: result_approvals; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.result_approvals (approval_id, result_id, approved_by, approval_date, remarks) FROM stdin;
\.


--
-- Data for Name: results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.results (result_id, student_id, semester_id, sgpa, cgpa, total_credit_hours_attempted, total_credit_hours_earned, status, published_date, published_by, is_published, created_at) FROM stdin;
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.role_permissions (role_permission_id, role_id, permission_id, granted_at) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role_id, role_name, description, is_system_role, created_at) FROM stdin;
\.


--
-- Data for Name: scholarships; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scholarships (scholarship_id, student_id, scholarship_type, amount, percentage, semester_id, start_date, end_date, is_active, awarded_date, awarded_by, remarks, created_at) FROM stdin;
\.


--
-- Data for Name: section_schedules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.section_schedules (schedule_id, section_id, day_of_week, start_time, end_time, room_number, building_name, schedule_type, created_at) FROM stdin;
\.


--
-- Data for Name: sections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sections (section_id, course_id, semester_id, faculty_id, section_name, section_type, max_capacity, enrolled_count, is_active, created_at) FROM stdin;
\.


--
-- Data for Name: security_policies; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.security_policies (policy_id, policy_name, policy_type, policy_content, is_active, effective_from, effective_to, created_at, updates_at) FROM stdin;
\.


--
-- Data for Name: semesters; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.semesters (semester_id, semester_name, academic_year, semester_type, start_date, end_date, is_current, created_at) FROM stdin;
\.


--
-- Data for Name: staff_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.staff_members (staff_id, user_id, department_id, designation_id, employee_code, joining_date, employment_type, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: student_academic_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_academic_records (record_id, student_id, semester_id, semester_number, sgpa, cgpa, total_credit_hours_semester, earned_credit_hours_semester, total_credit_hours_cumulative, earned_credit_hours_cumulative, semester_status, calculated_at, verified_by, verified_at) FROM stdin;
\.


--
-- Data for Name: student_attendance_summaries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_attendance_summaries (summary_id, student_id, course_id, section_id, semester_id, total_lectures, attended_lectures, late_count, leave_count, attendance_percentage, is_below_threshold, last_updated_at) FROM stdin;
\.


--
-- Data for Name: student_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_history (history_id, student_id, event_type, event_date, from_status, to_status, description, recorded_by, "timestamp") FROM stdin;
\.


--
-- Data for Name: student_leave_applications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_leave_applications (leave_id, student_id, leave_type, from_date, to_date, total_days, reason, supporting_document_path, applied_date, status) FROM stdin;
\.


--
-- Data for Name: student_leave_decisions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_leave_decisions (decision_id, leave_id, decided_by, decision, decision_date, remarks) FROM stdin;
\.


--
-- Data for Name: student_profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_profiles (profile_id, student_id, blood_group, medical_conditions, disabilities, previous_university, previous_cgpa, guardian_name, guardian_cnic, guardian_phone, guardian_occupation, residential_address, updated_at) FROM stdin;
\.


--
-- Data for Name: student_scholarship_applications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_scholarship_applications (scholarship_app_id, student_id, scholarship_type, applied_date, status, documents_submitted, created_at) FROM stdin;
\.


--
-- Data for Name: student_scholarship_decisions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_scholarship_decisions (decision_id, scholarship_app_id, approved_by, decision, amount_awarded, decision_date, remarks) FROM stdin;
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (student_id, user_id, applicant_id, program_id, registration_number, batch_year, current_semester, status, cgpa, total_credit_hours_completed, admission_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: system_configuration; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_configuration (config_id, config_key, config_value, data_type, category, description, is_editable, updated_at, updated_by) FROM stdin;
\.


--
-- Data for Name: system_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_logs (log_id, log_level, module_name, event_type, user_id, message, stack_trace, ip_address, "timestamp") FROM stdin;
\.


--
-- Data for Name: transcript_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transcript_requests (transcript_id, student_id, request_date, status, fee_amount, fee_paid, processed_by, processed_date, dispatch_date, tracking_number, remarks) FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (user_role_id, user_id, role_id, assigned_date, assigned_by, is_active) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, password, is_email_active, last_login, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: workload_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.workload_assignments (workload_id, faculty_id, semester_id, total_sections, total_credit_hours, total_students, administrative_duties, last_calculated_at) FROM stdin;
\.


--
-- Name: admission_applications_application_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admission_applications_application_id_seq', 1, false);


--
-- Name: admission_decisions_decision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admission_decisions_decision_id_seq', 1, false);


--
-- Name: admission_logs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admission_logs_log_id_seq', 1, false);


--
-- Name: ai_degree_recommendations_recommendation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ai_degree_recommendations_recommendation_id_seq', 1, false);


--
-- Name: announcements_announcement_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.announcements_announcement_id_seq', 1, false);


--
-- Name: applicant_academic_background_background_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applicant_academic_background_background_id_seq', 1, false);


--
-- Name: applicant_documents_document_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applicant_documents_document_id_seq', 1, false);


--
-- Name: applicants_applicant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.applicants_applicant_id_seq', 1, false);


--
-- Name: attendance_attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_attendance_id_seq', 1, false);


--
-- Name: attendance_records_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_records_record_id_seq', 1, false);


--
-- Name: attendance_reports_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_reports_report_id_seq', 1, false);


--
-- Name: attendance_statistics_stat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_statistics_stat_id_seq', 1, false);


--
-- Name: audit_logs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_logs_log_id_seq', 1, false);


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 24, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, false);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: backup_schedules_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.backup_schedules_schedule_id_seq', 1, false);


--
-- Name: backups_backup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.backups_backup_id_seq', 1, false);


--
-- Name: challans_challan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.challans_challan_id_seq', 1, false);


--
-- Name: communication_threads_thread_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.communication_threads_thread_id_seq', 1, false);


--
-- Name: complaint_assignments_assignment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.complaint_assignments_assignment_id_seq', 1, false);


--
-- Name: complaint_categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.complaint_categories_category_id_seq', 1, false);


--
-- Name: complaint_logs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.complaint_logs_log_id_seq', 1, false);


--
-- Name: complaints_complaint_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.complaints_complaint_id_seq', 1, false);


--
-- Name: compliance_policies_policy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.compliance_policies_policy_id_seq', 1, false);


--
-- Name: course_registrations_registration_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_registrations_registration_id_seq', 1, false);


--
-- Name: courses_course_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.courses_course_id_seq', 1, false);


--
-- Name: degree_programs_program_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.degree_programs_program_id_seq', 1, false);


--
-- Name: degree_verification_requests_request_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.degree_verification_requests_request_id_seq', 1, false);


--
-- Name: departments_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_department_id_seq', 1, false);


--
-- Name: designations_designation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.designations_designation_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 6, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 18, true);


--
-- Name: eligibility_criteria_criteria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eligibility_criteria_criteria_id_seq', 1, false);


--
-- Name: email_verifications_verification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.email_verifications_verification_id_seq', 1, false);


--
-- Name: employee_profiles_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employee_profiles_profile_id_seq', 1, false);


--
-- Name: enrollments_enrollment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enrollments_enrollment_id_seq', 1, false);


--
-- Name: error_logs_error_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.error_logs_error_id_seq', 1, false);


--
-- Name: exam_schedules_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exam_schedules_schedule_id_seq', 1, false);


--
-- Name: exam_types_exam_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.exam_types_exam_type_id_seq', 1, false);


--
-- Name: examinations_exam_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.examinations_exam_id_seq', 1, false);


--
-- Name: faculty_faculty_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.faculty_faculty_id_seq', 1, false);


--
-- Name: fee_structures_structure_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fee_structures_structure_id_seq', 1, false);


--
-- Name: feedback_feedback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feedback_feedback_id_seq', 1, false);


--
-- Name: final_grades_final_grade_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.final_grades_final_grade_id_seq', 1, false);


--
-- Name: financial_reports_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.financial_reports_report_id_seq', 1, false);


--
-- Name: grade_grade_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grade_grade_id_seq', 1, false);


--
-- Name: login_sessions_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.login_sessions_session_id_seq', 1, false);


--
-- Name: maintenance_logs_maintenance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.maintenance_logs_maintenance_id_seq', 1, false);


--
-- Name: marks_marks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.marks_marks_id_seq', 1, false);


--
-- Name: marksheets_marksheet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.marksheets_marksheet_id_seq', 1, false);


--
-- Name: messages_message_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.messages_message_id_seq', 1, false);


--
-- Name: notification_type_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_type_type_id_seq', 1, false);


--
-- Name: password_resets_reset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.password_resets_reset_id_seq', 1, false);


--
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 1, false);


--
-- Name: permissions_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_permission_id_seq', 1, false);


--
-- Name: prerequisites_prerequisite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prerequisites_prerequisite_id_seq', 1, false);


--
-- Name: program_courses_program_course_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.program_courses_program_course_id_seq', 1, false);


--
-- Name: report_types_report_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.report_types_report_type_id_seq', 1, false);


--
-- Name: reports_report_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.reports_report_id_seq', 1, false);


--
-- Name: result_approvals_approval_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.result_approvals_approval_id_seq', 1, false);


--
-- Name: results_result_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.results_result_id_seq', 1, false);


--
-- Name: role_permissions_role_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_permissions_role_permission_id_seq', 1, false);


--
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_role_id_seq', 1, false);


--
-- Name: scholarships_scholarship_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.scholarships_scholarship_id_seq', 1, false);


--
-- Name: section_schedules_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.section_schedules_schedule_id_seq', 1, false);


--
-- Name: sections_section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sections_section_id_seq', 1, false);


--
-- Name: security_policies_policy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.security_policies_policy_id_seq', 1, false);


--
-- Name: semesters_semester_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.semesters_semester_id_seq', 1, false);


--
-- Name: staff_members_staff_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.staff_members_staff_id_seq', 1, false);


--
-- Name: student_academic_records_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_academic_records_record_id_seq', 1, false);


--
-- Name: student_attendance_summaries_summary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_attendance_summaries_summary_id_seq', 1, false);


--
-- Name: student_history_history_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_history_history_id_seq', 1, false);


--
-- Name: student_leave_applications_leave_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_leave_applications_leave_id_seq', 1, false);


--
-- Name: student_leave_decisions_decision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_leave_decisions_decision_id_seq', 1, false);


--
-- Name: student_profiles_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_profiles_profile_id_seq', 1, false);


--
-- Name: student_scholarship_applications_scholarship_app_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_scholarship_applications_scholarship_app_id_seq', 1, false);


--
-- Name: student_scholarship_decisions_decision_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_scholarship_decisions_decision_id_seq', 1, false);


--
-- Name: students_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_student_id_seq', 1, false);


--
-- Name: system_configuration_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_configuration_config_id_seq', 1, false);


--
-- Name: system_logs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_logs_log_id_seq', 1, false);


--
-- Name: transcript_requests_transcript_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transcript_requests_transcript_id_seq', 1, false);


--
-- Name: user_roles_user_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_roles_user_role_id_seq', 1, false);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 1, false);


--
-- Name: workload_assignments_workload_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.workload_assignments_workload_id_seq', 1, false);


--
-- Name: admission_applications admission_applications_application_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_applications
    ADD CONSTRAINT admission_applications_application_number_key UNIQUE (application_number);


--
-- Name: admission_applications admission_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_applications
    ADD CONSTRAINT admission_applications_pkey PRIMARY KEY (application_id);


--
-- Name: admission_decisions admission_decisions_application_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_decisions
    ADD CONSTRAINT admission_decisions_application_id_key UNIQUE (application_id);


--
-- Name: admission_decisions admission_decisions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_decisions
    ADD CONSTRAINT admission_decisions_pkey PRIMARY KEY (decision_id);


--
-- Name: admission_logs admission_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_logs
    ADD CONSTRAINT admission_logs_pkey PRIMARY KEY (log_id);


--
-- Name: ai_degree_recommendations ai_degree_recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_degree_recommendations
    ADD CONSTRAINT ai_degree_recommendations_pkey PRIMARY KEY (recommendation_id);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (announcement_id);


--
-- Name: applicant_academic_background applicant_academic_background_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_academic_background
    ADD CONSTRAINT applicant_academic_background_pkey PRIMARY KEY (background_id);


--
-- Name: applicant_documents applicant_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_documents
    ADD CONSTRAINT applicant_documents_pkey PRIMARY KEY (document_id);


--
-- Name: applicants applicants_cnic_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT applicants_cnic_key UNIQUE (cnic);


--
-- Name: applicants applicants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT applicants_pkey PRIMARY KEY (applicant_id);


--
-- Name: applicants applicants_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT applicants_user_id_key UNIQUE (user_id);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (attendance_id);


--
-- Name: attendance_records attendance_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_records
    ADD CONSTRAINT attendance_records_pkey PRIMARY KEY (record_id);


--
-- Name: attendance_reports attendance_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_reports
    ADD CONSTRAINT attendance_reports_pkey PRIMARY KEY (report_id);


--
-- Name: attendance_statistics attendance_statistics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_statistics
    ADD CONSTRAINT attendance_statistics_pkey PRIMARY KEY (stat_id);


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (log_id);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: backup_schedules backup_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.backup_schedules
    ADD CONSTRAINT backup_schedules_pkey PRIMARY KEY (schedule_id);


--
-- Name: backups backups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.backups
    ADD CONSTRAINT backups_pkey PRIMARY KEY (backup_id);


--
-- Name: challans challans_challan_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challans
    ADD CONSTRAINT challans_challan_number_key UNIQUE (challan_number);


--
-- Name: challans challans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challans
    ADD CONSTRAINT challans_pkey PRIMARY KEY (challan_id);


--
-- Name: communication_threads communication_threads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.communication_threads
    ADD CONSTRAINT communication_threads_pkey PRIMARY KEY (thread_id);


--
-- Name: complaint_assignments complaint_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint_assignments
    ADD CONSTRAINT complaint_assignments_pkey PRIMARY KEY (assignment_id);


--
-- Name: complaint_categories complaint_categories_category_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint_categories
    ADD CONSTRAINT complaint_categories_category_name_key UNIQUE (category_name);


--
-- Name: complaint_categories complaint_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint_categories
    ADD CONSTRAINT complaint_categories_pkey PRIMARY KEY (category_id);


--
-- Name: complaint_logs complaint_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint_logs
    ADD CONSTRAINT complaint_logs_pkey PRIMARY KEY (log_id);


--
-- Name: complaints complaints_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaints
    ADD CONSTRAINT complaints_pkey PRIMARY KEY (complaint_id);


--
-- Name: compliance_policies compliance_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compliance_policies
    ADD CONSTRAINT compliance_policies_pkey PRIMARY KEY (policy_id);


--
-- Name: course_registrations course_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_registrations
    ADD CONSTRAINT course_registrations_pkey PRIMARY KEY (registration_id);


--
-- Name: courses courses_course_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_course_code_key UNIQUE (course_code);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (course_id);


--
-- Name: degree_programs degree_programs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degree_programs
    ADD CONSTRAINT degree_programs_pkey PRIMARY KEY (program_id);


--
-- Name: degree_programs degree_programs_program_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degree_programs
    ADD CONSTRAINT degree_programs_program_code_key UNIQUE (program_code);


--
-- Name: degree_verification_requests degree_verification_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degree_verification_requests
    ADD CONSTRAINT degree_verification_requests_pkey PRIMARY KEY (request_id);


--
-- Name: departments departments_department_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_department_code_key UNIQUE (department_code);


--
-- Name: departments departments_department_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_department_name_key UNIQUE (department_name);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- Name: designations designations_designation_title_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_designation_title_key UNIQUE (designation_title);


--
-- Name: designations designations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_pkey PRIMARY KEY (designation_id);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: eligibility_criteria eligibility_criteria_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eligibility_criteria
    ADD CONSTRAINT eligibility_criteria_pkey PRIMARY KEY (criteria_id);


--
-- Name: email_verifications email_verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_verifications
    ADD CONSTRAINT email_verifications_pkey PRIMARY KEY (verification_id);


--
-- Name: email_verifications email_verifications_verification_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_verifications
    ADD CONSTRAINT email_verifications_verification_token_key UNIQUE (verification_token);


--
-- Name: employee_profiles employee_profiles_cnic_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_profiles
    ADD CONSTRAINT employee_profiles_cnic_key UNIQUE (cnic);


--
-- Name: employee_profiles employee_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_profiles
    ADD CONSTRAINT employee_profiles_pkey PRIMARY KEY (profile_id);


--
-- Name: enrollments enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_pkey PRIMARY KEY (enrollment_id);


--
-- Name: error_logs error_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.error_logs
    ADD CONSTRAINT error_logs_pkey PRIMARY KEY (error_id);


--
-- Name: exam_schedules exam_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_schedules
    ADD CONSTRAINT exam_schedules_pkey PRIMARY KEY (schedule_id);


--
-- Name: exam_types exam_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_types
    ADD CONSTRAINT exam_types_pkey PRIMARY KEY (exam_type_id);


--
-- Name: exam_types exam_types_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_types
    ADD CONSTRAINT exam_types_type_name_key UNIQUE (type_name);


--
-- Name: examinations examinations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examinations
    ADD CONSTRAINT examinations_pkey PRIMARY KEY (exam_id);


--
-- Name: faculty faculty_employee_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_employee_code_key UNIQUE (employee_code);


--
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (faculty_id);


--
-- Name: faculty faculty_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_user_id_key UNIQUE (user_id);


--
-- Name: fee_structures fee_structures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fee_structures
    ADD CONSTRAINT fee_structures_pkey PRIMARY KEY (structure_id);


--
-- Name: feedback feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (feedback_id);


--
-- Name: final_grades final_grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_grades
    ADD CONSTRAINT final_grades_pkey PRIMARY KEY (final_grade_id);


--
-- Name: final_grades final_grades_registration_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_grades
    ADD CONSTRAINT final_grades_registration_id_key UNIQUE (registration_id);


--
-- Name: financial_reports financial_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financial_reports
    ADD CONSTRAINT financial_reports_pkey PRIMARY KEY (report_id);


--
-- Name: grade grade_grade_letter_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade
    ADD CONSTRAINT grade_grade_letter_key UNIQUE (grade_letter);


--
-- Name: grade grade_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grade
    ADD CONSTRAINT grade_pkey PRIMARY KEY (grade_id);


--
-- Name: login_sessions login_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_sessions
    ADD CONSTRAINT login_sessions_pkey PRIMARY KEY (session_id);


--
-- Name: login_sessions login_sessions_session_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_sessions
    ADD CONSTRAINT login_sessions_session_token_key UNIQUE (session_token);


--
-- Name: maintenance_logs maintenance_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_logs
    ADD CONSTRAINT maintenance_logs_pkey PRIMARY KEY (maintenance_id);


--
-- Name: marks marks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marks
    ADD CONSTRAINT marks_pkey PRIMARY KEY (marks_id);


--
-- Name: marksheets marksheets_marksheet_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marksheets
    ADD CONSTRAINT marksheets_marksheet_number_key UNIQUE (marksheet_number);


--
-- Name: marksheets marksheets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marksheets
    ADD CONSTRAINT marksheets_pkey PRIMARY KEY (marksheet_id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (message_id);


--
-- Name: notification_type notification_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_type
    ADD CONSTRAINT notification_type_pkey PRIMARY KEY (type_id);


--
-- Name: notification_type notification_type_type_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_type
    ADD CONSTRAINT notification_type_type_name_key UNIQUE (type_name);


--
-- Name: password_resets password_resets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_resets
    ADD CONSTRAINT password_resets_pkey PRIMARY KEY (reset_id);


--
-- Name: password_resets password_resets_reset_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_resets
    ADD CONSTRAINT password_resets_reset_token_key UNIQUE (reset_token);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- Name: payments payments_receipt_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_receipt_number_key UNIQUE (receipt_number);


--
-- Name: payments payments_transaction_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_transaction_id_key UNIQUE (transaction_id);


--
-- Name: permissions permissions_permission_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_permission_name_key UNIQUE (permission_name);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (permission_id);


--
-- Name: prerequisites prerequisites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prerequisites
    ADD CONSTRAINT prerequisites_pkey PRIMARY KEY (prerequisite_id);


--
-- Name: program_courses program_courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_courses
    ADD CONSTRAINT program_courses_pkey PRIMARY KEY (program_course_id);


--
-- Name: report_types report_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_types
    ADD CONSTRAINT report_types_pkey PRIMARY KEY (report_type_id);


--
-- Name: report_types report_types_report_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.report_types
    ADD CONSTRAINT report_types_report_name_key UNIQUE (report_name);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (report_id);


--
-- Name: result_approvals result_approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.result_approvals
    ADD CONSTRAINT result_approvals_pkey PRIMARY KEY (approval_id);


--
-- Name: result_approvals result_approvals_result_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.result_approvals
    ADD CONSTRAINT result_approvals_result_id_key UNIQUE (result_id);


--
-- Name: results results_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT results_pkey PRIMARY KEY (result_id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (role_permission_id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- Name: roles roles_role_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_role_name_key UNIQUE (role_name);


--
-- Name: scholarships scholarships_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scholarships
    ADD CONSTRAINT scholarships_pkey PRIMARY KEY (scholarship_id);


--
-- Name: section_schedules section_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section_schedules
    ADD CONSTRAINT section_schedules_pkey PRIMARY KEY (schedule_id);


--
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (section_id);


--
-- Name: security_policies security_policies_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.security_policies
    ADD CONSTRAINT security_policies_pkey PRIMARY KEY (policy_id);


--
-- Name: semesters semesters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semesters
    ADD CONSTRAINT semesters_pkey PRIMARY KEY (semester_id);


--
-- Name: semesters semesters_semester_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semesters
    ADD CONSTRAINT semesters_semester_name_key UNIQUE (semester_name);


--
-- Name: staff_members staff_members_employee_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_members
    ADD CONSTRAINT staff_members_employee_code_key UNIQUE (employee_code);


--
-- Name: staff_members staff_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_members
    ADD CONSTRAINT staff_members_pkey PRIMARY KEY (staff_id);


--
-- Name: staff_members staff_members_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_members
    ADD CONSTRAINT staff_members_user_id_key UNIQUE (user_id);


--
-- Name: student_academic_records student_academic_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_academic_records
    ADD CONSTRAINT student_academic_records_pkey PRIMARY KEY (record_id);


--
-- Name: student_attendance_summaries student_attendance_summaries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_attendance_summaries
    ADD CONSTRAINT student_attendance_summaries_pkey PRIMARY KEY (summary_id);


--
-- Name: student_history student_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_history
    ADD CONSTRAINT student_history_pkey PRIMARY KEY (history_id);


--
-- Name: student_leave_applications student_leave_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_leave_applications
    ADD CONSTRAINT student_leave_applications_pkey PRIMARY KEY (leave_id);


--
-- Name: student_leave_decisions student_leave_decisions_leave_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_leave_decisions
    ADD CONSTRAINT student_leave_decisions_leave_id_key UNIQUE (leave_id);


--
-- Name: student_leave_decisions student_leave_decisions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_leave_decisions
    ADD CONSTRAINT student_leave_decisions_pkey PRIMARY KEY (decision_id);


--
-- Name: student_profiles student_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_pkey PRIMARY KEY (profile_id);


--
-- Name: student_profiles student_profiles_student_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT student_profiles_student_id_key UNIQUE (student_id);


--
-- Name: student_scholarship_applications student_scholarship_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_scholarship_applications
    ADD CONSTRAINT student_scholarship_applications_pkey PRIMARY KEY (scholarship_app_id);


--
-- Name: student_scholarship_decisions student_scholarship_decisions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_scholarship_decisions
    ADD CONSTRAINT student_scholarship_decisions_pkey PRIMARY KEY (decision_id);


--
-- Name: student_scholarship_decisions student_scholarship_decisions_scholarship_app_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_scholarship_decisions
    ADD CONSTRAINT student_scholarship_decisions_scholarship_app_id_key UNIQUE (scholarship_app_id);


--
-- Name: students students_applicant_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_applicant_id_key UNIQUE (applicant_id);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (student_id);


--
-- Name: students students_registration_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_registration_number_key UNIQUE (registration_number);


--
-- Name: students students_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_key UNIQUE (user_id);


--
-- Name: system_configuration system_configuration_config_key_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_configuration
    ADD CONSTRAINT system_configuration_config_key_key UNIQUE (config_key);


--
-- Name: system_configuration system_configuration_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_configuration
    ADD CONSTRAINT system_configuration_pkey PRIMARY KEY (config_id);


--
-- Name: system_logs system_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_logs
    ADD CONSTRAINT system_logs_pkey PRIMARY KEY (log_id);


--
-- Name: transcript_requests transcript_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transcript_requests
    ADD CONSTRAINT transcript_requests_pkey PRIMARY KEY (transcript_id);


--
-- Name: applicant_documents uk_applicant_document_type; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_documents
    ADD CONSTRAINT uk_applicant_document_type UNIQUE (applicant_id, document_type);


--
-- Name: attendance_records uk_attendance_student; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_records
    ADD CONSTRAINT uk_attendance_student UNIQUE (attendance_id, student_id);


--
-- Name: prerequisites uk_course_prerequisite; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prerequisites
    ADD CONSTRAINT uk_course_prerequisite UNIQUE (course_id, prerequisite_course_id);


--
-- Name: eligibility_criteria uk_eligibility_program_effective; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eligibility_criteria
    ADD CONSTRAINT uk_eligibility_program_effective UNIQUE (program_id, effective_from);


--
-- Name: workload_assignments uk_faculty_semester_workload; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workload_assignments
    ADD CONSTRAINT uk_faculty_semester_workload UNIQUE (faculty_id, semester_id);


--
-- Name: fee_structures uk_fee_structure; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fee_structures
    ADD CONSTRAINT uk_fee_structure UNIQUE (program_id, semester_number, effective_from);


--
-- Name: program_courses uk_program_course_semester; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_courses
    ADD CONSTRAINT uk_program_course_semester UNIQUE (program_id, course_id, semester_number);


--
-- Name: role_permissions uk_role_permission; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT uk_role_permission UNIQUE (role_id, permission_id);


--
-- Name: sections uk_section_course_semester; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT uk_section_course_semester UNIQUE (course_id, semester_id, section_name);


--
-- Name: attendance uk_section_date_lecture; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT uk_section_date_lecture UNIQUE (section_id, attendance_date, lecture_number);


--
-- Name: student_attendance_summaries uk_student_section; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_attendance_summaries
    ADD CONSTRAINT uk_student_section UNIQUE (student_id, section_id);


--
-- Name: enrollments uk_student_semester; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT uk_student_semester UNIQUE (student_id, semester_id);


--
-- Name: student_academic_records uk_student_semester_record; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_academic_records
    ADD CONSTRAINT uk_student_semester_record UNIQUE (student_id, semester_id);


--
-- Name: results uk_student_semester_result; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT uk_student_semester_result UNIQUE (student_id, semester_id);


--
-- Name: user_roles uk_user_role; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT uk_user_role UNIQUE (user_id, role_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_role_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: workload_assignments workload_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workload_assignments
    ADD CONSTRAINT workload_assignments_pkey PRIMARY KEY (workload_id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: admission_applications fk_admission_applications_applicant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_applications
    ADD CONSTRAINT fk_admission_applications_applicant FOREIGN KEY (applicant_id) REFERENCES public.applicants(applicant_id) ON DELETE RESTRICT;


--
-- Name: admission_applications fk_admission_applications_program; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_applications
    ADD CONSTRAINT fk_admission_applications_program FOREIGN KEY (program_id) REFERENCES public.degree_programs(program_id) ON DELETE RESTRICT;


--
-- Name: admission_decisions fk_admission_decisions_application; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_decisions
    ADD CONSTRAINT fk_admission_decisions_application FOREIGN KEY (application_id) REFERENCES public.admission_applications(application_id) ON DELETE RESTRICT;


--
-- Name: admission_decisions fk_admission_decisions_decided_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_decisions
    ADD CONSTRAINT fk_admission_decisions_decided_by FOREIGN KEY (decided_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: admission_logs fk_admission_logs_application; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_logs
    ADD CONSTRAINT fk_admission_logs_application FOREIGN KEY (application_id) REFERENCES public.admission_applications(application_id) ON DELETE CASCADE;


--
-- Name: admission_logs fk_admission_logs_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admission_logs
    ADD CONSTRAINT fk_admission_logs_user FOREIGN KEY (performed_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: ai_degree_recommendations fk_ai_recommendations_applicant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_degree_recommendations
    ADD CONSTRAINT fk_ai_recommendations_applicant FOREIGN KEY (applicant_id) REFERENCES public.applicants(applicant_id) ON DELETE CASCADE;


--
-- Name: ai_degree_recommendations fk_ai_recommendations_program; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ai_degree_recommendations
    ADD CONSTRAINT fk_ai_recommendations_program FOREIGN KEY (recommended_program_id) REFERENCES public.degree_programs(program_id) ON DELETE CASCADE;


--
-- Name: announcements fk_announcements_creator; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT fk_announcements_creator FOREIGN KEY (created_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: announcements fk_announcements_program; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT fk_announcements_program FOREIGN KEY (target_program_id) REFERENCES public.degree_programs(program_id) ON DELETE SET NULL;


--
-- Name: announcements fk_announcements_semester; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT fk_announcements_semester FOREIGN KEY (target_semester_id) REFERENCES public.semesters(semester_id) ON DELETE SET NULL;


--
-- Name: applicant_academic_background fk_applicant_academic_background; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_academic_background
    ADD CONSTRAINT fk_applicant_academic_background FOREIGN KEY (applicant_id) REFERENCES public.applicants(applicant_id) ON DELETE CASCADE;


--
-- Name: applicant_documents fk_applicant_documents_applicant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_documents
    ADD CONSTRAINT fk_applicant_documents_applicant FOREIGN KEY (applicant_id) REFERENCES public.applicants(applicant_id) ON DELETE CASCADE;


--
-- Name: applicant_documents fk_applicant_documents_verifier; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicant_documents
    ADD CONSTRAINT fk_applicant_documents_verifier FOREIGN KEY (verified_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: applicants fk_applicants_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.applicants
    ADD CONSTRAINT fk_applicants_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: attendance fk_attendance_faculty; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT fk_attendance_faculty FOREIGN KEY (marked_by) REFERENCES public.faculty(faculty_id) ON DELETE RESTRICT;


--
-- Name: attendance_records fk_attendance_records_attendance; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_records
    ADD CONSTRAINT fk_attendance_records_attendance FOREIGN KEY (attendance_id) REFERENCES public.attendance(attendance_id) ON DELETE CASCADE;


--
-- Name: attendance_records fk_attendance_records_registration; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_records
    ADD CONSTRAINT fk_attendance_records_registration FOREIGN KEY (registration_id) REFERENCES public.course_registrations(registration_id) ON DELETE CASCADE;


--
-- Name: attendance_records fk_attendance_records_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_records
    ADD CONSTRAINT fk_attendance_records_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: attendance_reports fk_attendance_reports_course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_reports
    ADD CONSTRAINT fk_attendance_reports_course FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: attendance_reports fk_attendance_reports_semester; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_reports
    ADD CONSTRAINT fk_attendance_reports_semester FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id) ON DELETE CASCADE;


--
-- Name: attendance_reports fk_attendance_reports_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_reports
    ADD CONSTRAINT fk_attendance_reports_user FOREIGN KEY (generated_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: attendance fk_attendance_section; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT fk_attendance_section FOREIGN KEY (section_id) REFERENCES public.sections(section_id) ON DELETE CASCADE;


--
-- Name: attendance_statistics fk_attendance_statistics_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_statistics
    ADD CONSTRAINT fk_attendance_statistics_department FOREIGN KEY (department_id) REFERENCES public.departments(department_id) ON DELETE CASCADE;


--
-- Name: attendance_statistics fk_attendance_statistics_semester; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance_statistics
    ADD CONSTRAINT fk_attendance_statistics_semester FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id) ON DELETE CASCADE;


--
-- Name: student_attendance_summaries fk_attendance_summaries_course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_attendance_summaries
    ADD CONSTRAINT fk_attendance_summaries_course FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE RESTRICT;


--
-- Name: student_attendance_summaries fk_attendance_summaries_section; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_attendance_summaries
    ADD CONSTRAINT fk_attendance_summaries_section FOREIGN KEY (section_id) REFERENCES public.sections(section_id) ON DELETE RESTRICT;


--
-- Name: student_attendance_summaries fk_attendance_summaries_semester; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_attendance_summaries
    ADD CONSTRAINT fk_attendance_summaries_semester FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id) ON DELETE RESTRICT;


--
-- Name: student_attendance_summaries fk_attendance_summaries_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_attendance_summaries
    ADD CONSTRAINT fk_attendance_summaries_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: audit_logs fk_audit_logs_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT fk_audit_logs_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: backups fk_backups_schedule; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.backups
    ADD CONSTRAINT fk_backups_schedule FOREIGN KEY (schedule_id) REFERENCES public.backup_schedules(schedule_id) ON DELETE RESTRICT;


--
-- Name: challans fk_challans_generator; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challans
    ADD CONSTRAINT fk_challans_generator FOREIGN KEY (generated_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: challans fk_challans_semester; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challans
    ADD CONSTRAINT fk_challans_semester FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id) ON DELETE RESTRICT;


--
-- Name: challans fk_challans_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.challans
    ADD CONSTRAINT fk_challans_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE RESTRICT;


--
-- Name: communication_threads fk_communication_threads_complaint; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.communication_threads
    ADD CONSTRAINT fk_communication_threads_complaint FOREIGN KEY (complaint_id) REFERENCES public.complaints(complaint_id) ON DELETE SET NULL;


--
-- Name: communication_threads fk_communication_threads_creator; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.communication_threads
    ADD CONSTRAINT fk_communication_threads_creator FOREIGN KEY (created_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: complaint_assignments fk_complaint_assignments_assignee; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint_assignments
    ADD CONSTRAINT fk_complaint_assignments_assignee FOREIGN KEY (assigned_to) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: complaint_assignments fk_complaint_assignments_assigner; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint_assignments
    ADD CONSTRAINT fk_complaint_assignments_assigner FOREIGN KEY (assigned_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: complaint_assignments fk_complaint_assignments_complaint; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint_assignments
    ADD CONSTRAINT fk_complaint_assignments_complaint FOREIGN KEY (complaint_id) REFERENCES public.complaints(complaint_id) ON DELETE CASCADE;


--
-- Name: complaint_logs fk_complaint_logs_complaint; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint_logs
    ADD CONSTRAINT fk_complaint_logs_complaint FOREIGN KEY (complaint_id) REFERENCES public.complaints(complaint_id) ON DELETE CASCADE;


--
-- Name: complaint_logs fk_complaint_logs_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaint_logs
    ADD CONSTRAINT fk_complaint_logs_user FOREIGN KEY (performed_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: complaints fk_complaints_category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaints
    ADD CONSTRAINT fk_complaints_category FOREIGN KEY (category_id) REFERENCES public.complaint_categories(category_id) ON DELETE RESTRICT;


--
-- Name: complaints fk_complaints_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.complaints
    ADD CONSTRAINT fk_complaints_user FOREIGN KEY (submitted_by) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: compliance_policies fk_compliance_policies_creator; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compliance_policies
    ADD CONSTRAINT fk_compliance_policies_creator FOREIGN KEY (created_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: compliance_policies fk_compliance_policies_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compliance_policies
    ADD CONSTRAINT fk_compliance_policies_department FOREIGN KEY (responsible_department_id) REFERENCES public.departments(department_id) ON DELETE SET NULL;


--
-- Name: course_registrations fk_course_registrations_course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_registrations
    ADD CONSTRAINT fk_course_registrations_course FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE RESTRICT;


--
-- Name: course_registrations fk_course_registrations_enrollment; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_registrations
    ADD CONSTRAINT fk_course_registrations_enrollment FOREIGN KEY (enrollment_id) REFERENCES public.enrollments(enrollment_id) ON DELETE CASCADE;


--
-- Name: course_registrations fk_course_registrations_final_grade; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_registrations
    ADD CONSTRAINT fk_course_registrations_final_grade FOREIGN KEY (final_grade_id) REFERENCES public.final_grades(final_grade_id) ON DELETE SET NULL;


--
-- Name: course_registrations fk_course_registrations_section; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_registrations
    ADD CONSTRAINT fk_course_registrations_section FOREIGN KEY (section_id) REFERENCES public.sections(section_id) ON DELETE RESTRICT;


--
-- Name: course_registrations fk_course_registrations_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_registrations
    ADD CONSTRAINT fk_course_registrations_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: courses fk_courses_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT fk_courses_department FOREIGN KEY (department_id) REFERENCES public.departments(department_id) ON DELETE RESTRICT;


--
-- Name: degree_programs fk_degree_programs_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degree_programs
    ADD CONSTRAINT fk_degree_programs_department FOREIGN KEY (department_id) REFERENCES public.departments(department_id) ON DELETE RESTRICT;


--
-- Name: eligibility_criteria fk_eligibility_criteria_program; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.eligibility_criteria
    ADD CONSTRAINT fk_eligibility_criteria_program FOREIGN KEY (program_id) REFERENCES public.degree_programs(program_id) ON DELETE CASCADE;


--
-- Name: email_verifications fk_email_verifications_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_verifications
    ADD CONSTRAINT fk_email_verifications_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: enrollments fk_enrollments_semester; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT fk_enrollments_semester FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id) ON DELETE RESTRICT;


--
-- Name: enrollments fk_enrollments_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT fk_enrollments_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: error_logs fk_error_logs_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.error_logs
    ADD CONSTRAINT fk_error_logs_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: exam_schedules fk_exam_schedules_creator; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_schedules
    ADD CONSTRAINT fk_exam_schedules_creator FOREIGN KEY (created_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: exam_schedules fk_exam_schedules_exam; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_schedules
    ADD CONSTRAINT fk_exam_schedules_exam FOREIGN KEY (exam_id) REFERENCES public.examinations(exam_id) ON DELETE CASCADE;


--
-- Name: exam_schedules fk_exam_schedules_invigilator; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam_schedules
    ADD CONSTRAINT fk_exam_schedules_invigilator FOREIGN KEY (invigilator_id) REFERENCES public.faculty(faculty_id) ON DELETE SET NULL;


--
-- Name: examinations fk_examinations_course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examinations
    ADD CONSTRAINT fk_examinations_course FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: examinations fk_examinations_creator; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examinations
    ADD CONSTRAINT fk_examinations_creator FOREIGN KEY (created_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: examinations fk_examinations_section; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examinations
    ADD CONSTRAINT fk_examinations_section FOREIGN KEY (section_id) REFERENCES public.sections(section_id) ON DELETE CASCADE;


--
-- Name: examinations fk_examinations_semester; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examinations
    ADD CONSTRAINT fk_examinations_semester FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id) ON DELETE RESTRICT;


--
-- Name: examinations fk_examinations_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.examinations
    ADD CONSTRAINT fk_examinations_type FOREIGN KEY (exam_type_id) REFERENCES public.exam_types(exam_type_id) ON DELETE RESTRICT;


--
-- Name: faculty fk_faculty_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT fk_faculty_department FOREIGN KEY (department_id) REFERENCES public.departments(department_id) ON DELETE RESTRICT;


--
-- Name: faculty fk_faculty_designation; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT fk_faculty_designation FOREIGN KEY (designation_id) REFERENCES public.designations(designation_id) ON DELETE RESTRICT;


--
-- Name: faculty fk_faculty_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT fk_faculty_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: fee_structures fk_fee_structures_program; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fee_structures
    ADD CONSTRAINT fk_fee_structures_program FOREIGN KEY (program_id) REFERENCES public.degree_programs(program_id) ON DELETE CASCADE;


--
-- Name: feedback fk_feedback_complaint; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT fk_feedback_complaint FOREIGN KEY (complaint_id) REFERENCES public.complaints(complaint_id) ON DELETE CASCADE;


--
-- Name: feedback fk_feedback_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT fk_feedback_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: final_grades fk_final_grades_course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_grades
    ADD CONSTRAINT fk_final_grades_course FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE RESTRICT;


--
-- Name: final_grades fk_final_grades_grade; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_grades
    ADD CONSTRAINT fk_final_grades_grade FOREIGN KEY (grade_id) REFERENCES public.grade(grade_id) ON DELETE RESTRICT;


--
-- Name: final_grades fk_final_grades_registration; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_grades
    ADD CONSTRAINT fk_final_grades_registration FOREIGN KEY (registration_id) REFERENCES public.course_registrations(registration_id) ON DELETE CASCADE;


--
-- Name: final_grades fk_final_grades_semester; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_grades
    ADD CONSTRAINT fk_final_grades_semester FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id) ON DELETE RESTRICT;


--
-- Name: final_grades fk_final_grades_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_grades
    ADD CONSTRAINT fk_final_grades_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: final_grades fk_final_grades_verifier; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.final_grades
    ADD CONSTRAINT fk_final_grades_verifier FOREIGN KEY (verified_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: financial_reports fk_financial_reports_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.financial_reports
    ADD CONSTRAINT fk_financial_reports_user FOREIGN KEY (generated_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: student_leave_applications fk_leave_apps_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_leave_applications
    ADD CONSTRAINT fk_leave_apps_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: student_leave_decisions fk_leave_decisions_decider; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_leave_decisions
    ADD CONSTRAINT fk_leave_decisions_decider FOREIGN KEY (decided_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: student_leave_decisions fk_leave_decisions_leave; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_leave_decisions
    ADD CONSTRAINT fk_leave_decisions_leave FOREIGN KEY (leave_id) REFERENCES public.student_leave_applications(leave_id) ON DELETE CASCADE;


--
-- Name: login_sessions fk_login_sessions_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.login_sessions
    ADD CONSTRAINT fk_login_sessions_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: maintenance_logs fk_maintenance_logs_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maintenance_logs
    ADD CONSTRAINT fk_maintenance_logs_user FOREIGN KEY (performed_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: marks fk_marks_entered_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marks
    ADD CONSTRAINT fk_marks_entered_by FOREIGN KEY (entered_by) REFERENCES public.faculty(faculty_id) ON DELETE RESTRICT;


--
-- Name: marks fk_marks_exam; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marks
    ADD CONSTRAINT fk_marks_exam FOREIGN KEY (exam_id) REFERENCES public.examinations(exam_id) ON DELETE CASCADE;


--
-- Name: marks fk_marks_modified_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marks
    ADD CONSTRAINT fk_marks_modified_by FOREIGN KEY (modified_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: marks fk_marks_registration; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marks
    ADD CONSTRAINT fk_marks_registration FOREIGN KEY (registration_id) REFERENCES public.course_registrations(registration_id) ON DELETE CASCADE;


--
-- Name: marks fk_marks_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marks
    ADD CONSTRAINT fk_marks_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: marksheets fk_marksheets_result; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marksheets
    ADD CONSTRAINT fk_marksheets_result FOREIGN KEY (result_id) REFERENCES public.results(result_id) ON DELETE RESTRICT;


--
-- Name: marksheets fk_marksheets_semester; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marksheets
    ADD CONSTRAINT fk_marksheets_semester FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id) ON DELETE RESTRICT;


--
-- Name: marksheets fk_marksheets_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marksheets
    ADD CONSTRAINT fk_marksheets_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE RESTRICT;


--
-- Name: marksheets fk_marksheets_verifier; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.marksheets
    ADD CONSTRAINT fk_marksheets_verifier FOREIGN KEY (verified_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: messages fk_messages_sender; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_messages_sender FOREIGN KEY (sender_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: messages fk_messages_thread; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT fk_messages_thread FOREIGN KEY (thread_id) REFERENCES public.communication_threads(thread_id) ON DELETE CASCADE;


--
-- Name: password_resets fk_password_resets_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_resets
    ADD CONSTRAINT fk_password_resets_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: payments fk_payments_challan; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_payments_challan FOREIGN KEY (challan_id) REFERENCES public.challans(challan_id) ON DELETE RESTRICT;


--
-- Name: payments fk_payments_recorder; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_payments_recorder FOREIGN KEY (recorded_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: payments fk_payments_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_payments_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE RESTRICT;


--
-- Name: payments fk_payments_verifier; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_payments_verifier FOREIGN KEY (verified_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: prerequisites fk_prerequisites_course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prerequisites
    ADD CONSTRAINT fk_prerequisites_course FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: prerequisites fk_prerequisites_prerequisite_course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prerequisites
    ADD CONSTRAINT fk_prerequisites_prerequisite_course FOREIGN KEY (prerequisite_course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: program_courses fk_program_courses_course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_courses
    ADD CONSTRAINT fk_program_courses_course FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: program_courses fk_program_courses_program; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_courses
    ADD CONSTRAINT fk_program_courses_program FOREIGN KEY (program_id) REFERENCES public.degree_programs(program_id) ON DELETE CASCADE;


--
-- Name: reports fk_reports_generator; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT fk_reports_generator FOREIGN KEY (generated_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: reports fk_reports_type; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT fk_reports_type FOREIGN KEY (report_type_id) REFERENCES public.report_types(report_type_id) ON DELETE RESTRICT;


--
-- Name: result_approvals fk_result_approvals_approver; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.result_approvals
    ADD CONSTRAINT fk_result_approvals_approver FOREIGN KEY (approved_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: result_approvals fk_result_approvals_result; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.result_approvals
    ADD CONSTRAINT fk_result_approvals_result FOREIGN KEY (result_id) REFERENCES public.results(result_id) ON DELETE CASCADE;


--
-- Name: results fk_results_publisher; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT fk_results_publisher FOREIGN KEY (published_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: results fk_results_semester; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT fk_results_semester FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id) ON DELETE RESTRICT;


--
-- Name: results fk_results_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.results
    ADD CONSTRAINT fk_results_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: role_permissions fk_role_permissions_permission; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES public.permissions(permission_id) ON DELETE CASCADE;


--
-- Name: role_permissions fk_role_permissions_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- Name: student_scholarship_applications fk_scholarship_apps_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_scholarship_applications
    ADD CONSTRAINT fk_scholarship_apps_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: student_scholarship_decisions fk_scholarship_decisions_app; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_scholarship_decisions
    ADD CONSTRAINT fk_scholarship_decisions_app FOREIGN KEY (scholarship_app_id) REFERENCES public.student_scholarship_applications(scholarship_app_id) ON DELETE CASCADE;


--
-- Name: student_scholarship_decisions fk_scholarship_decisions_approver; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_scholarship_decisions
    ADD CONSTRAINT fk_scholarship_decisions_approver FOREIGN KEY (approved_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: scholarships fk_scholarships_awarder; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scholarships
    ADD CONSTRAINT fk_scholarships_awarder FOREIGN KEY (awarded_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: scholarships fk_scholarships_semester; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scholarships
    ADD CONSTRAINT fk_scholarships_semester FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id) ON DELETE SET NULL;


--
-- Name: scholarships fk_scholarships_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scholarships
    ADD CONSTRAINT fk_scholarships_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: section_schedules fk_section_schedules_section; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.section_schedules
    ADD CONSTRAINT fk_section_schedules_section FOREIGN KEY (section_id) REFERENCES public.sections(section_id) ON DELETE CASCADE;


--
-- Name: sections fk_sections_course; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT fk_sections_course FOREIGN KEY (course_id) REFERENCES public.courses(course_id) ON DELETE CASCADE;


--
-- Name: sections fk_sections_faculty; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT fk_sections_faculty FOREIGN KEY (faculty_id) REFERENCES public.faculty(faculty_id) ON DELETE RESTRICT;


--
-- Name: sections fk_sections_semester; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT fk_sections_semester FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id) ON DELETE CASCADE;


--
-- Name: staff_members fk_staff_department; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_members
    ADD CONSTRAINT fk_staff_department FOREIGN KEY (department_id) REFERENCES public.departments(department_id) ON DELETE RESTRICT;


--
-- Name: staff_members fk_staff_designation; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_members
    ADD CONSTRAINT fk_staff_designation FOREIGN KEY (designation_id) REFERENCES public.designations(designation_id) ON DELETE RESTRICT;


--
-- Name: staff_members fk_staff_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.staff_members
    ADD CONSTRAINT fk_staff_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: student_academic_records fk_student_academic_records_semester; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_academic_records
    ADD CONSTRAINT fk_student_academic_records_semester FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id) ON DELETE RESTRICT;


--
-- Name: student_academic_records fk_student_academic_records_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_academic_records
    ADD CONSTRAINT fk_student_academic_records_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: student_academic_records fk_student_academic_records_verifier; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_academic_records
    ADD CONSTRAINT fk_student_academic_records_verifier FOREIGN KEY (verified_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: student_history fk_student_history_recorder; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_history
    ADD CONSTRAINT fk_student_history_recorder FOREIGN KEY (recorded_by) REFERENCES public.users(user_id) ON DELETE RESTRICT;


--
-- Name: student_history fk_student_history_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_history
    ADD CONSTRAINT fk_student_history_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: student_profiles fk_student_profiles_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_profiles
    ADD CONSTRAINT fk_student_profiles_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: students fk_students_applicant; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT fk_students_applicant FOREIGN KEY (applicant_id) REFERENCES public.applicants(applicant_id) ON DELETE SET NULL;


--
-- Name: students fk_students_program; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT fk_students_program FOREIGN KEY (program_id) REFERENCES public.degree_programs(program_id) ON DELETE RESTRICT;


--
-- Name: students fk_students_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT fk_students_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: system_configuration fk_system_configuration_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_configuration
    ADD CONSTRAINT fk_system_configuration_user FOREIGN KEY (updated_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: system_logs fk_system_logs_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_logs
    ADD CONSTRAINT fk_system_logs_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: transcript_requests fk_transcript_requests_processor; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transcript_requests
    ADD CONSTRAINT fk_transcript_requests_processor FOREIGN KEY (processed_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: transcript_requests fk_transcript_requests_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transcript_requests
    ADD CONSTRAINT fk_transcript_requests_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE CASCADE;


--
-- Name: user_roles fk_user_roles_assigned_by; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fk_user_roles_assigned_by FOREIGN KEY (assigned_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: user_roles fk_user_roles_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES public.roles(role_id) ON DELETE CASCADE;


--
-- Name: user_roles fk_user_roles_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON DELETE CASCADE;


--
-- Name: degree_verification_requests fk_verification_requests_student; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degree_verification_requests
    ADD CONSTRAINT fk_verification_requests_student FOREIGN KEY (student_id) REFERENCES public.students(student_id) ON DELETE RESTRICT;


--
-- Name: degree_verification_requests fk_verification_requests_verifier; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.degree_verification_requests
    ADD CONSTRAINT fk_verification_requests_verifier FOREIGN KEY (verified_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- Name: workload_assignments fk_workload_assignments_faculty; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workload_assignments
    ADD CONSTRAINT fk_workload_assignments_faculty FOREIGN KEY (faculty_id) REFERENCES public.faculty(faculty_id) ON DELETE CASCADE;


--
-- Name: workload_assignments fk_workload_assignments_semester; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.workload_assignments
    ADD CONSTRAINT fk_workload_assignments_semester FOREIGN KEY (semester_id) REFERENCES public.semesters(semester_id) ON DELETE CASCADE;


--
-- Name: TABLE grade; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.grade TO PUBLIC;


--
-- Name: TABLE notification_type; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.notification_type TO PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict 654KGve1EXJdU8LD7vs0W3dVAxkAKBDIc2p11Ukf2Q5XhbVkbSdmbw64Xnxu1g9

