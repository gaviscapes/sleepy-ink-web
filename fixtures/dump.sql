PGDMP             	            v            mastodon_development    10.2    10.2 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           1262    218748    mastodon_development    DATABASE     �   CREATE DATABASE mastodon_development WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
 $   DROP DATABASE mastodon_development;
             nolan    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             nolan    false                        0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  nolan    false    3                        3079    12544    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false                       0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                       1255    218749    timestamp_id(text)    FUNCTION     Y  CREATE FUNCTION timestamp_id(table_name text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
  DECLARE
    time_part bigint;
    sequence_base bigint;
    tail bigint;
  BEGIN
    time_part := (
      -- Get the time in milliseconds
      ((date_part('epoch', now()) * 1000))::bigint
      -- And shift it over two bytes
      << 16);

    sequence_base := (
      'x' ||
      -- Take the first two bytes (four hex characters)
      substr(
        -- Of the MD5 hash of the data we documented
        md5(table_name ||
          '41569431c71b583685001be129fe54b0' ||
          time_part::text
        ),
        1, 4
      )
    -- And turn it into a bigint
    )::bit(16)::bigint;

    -- Finally, add our sequence number to our base, and chop
    -- it to the last two bytes
    tail := (
      (sequence_base + nextval(table_name || '_id_seq'))
      & 65535);

    -- Return the time part and the sequence part. OR appears
    -- faster here than addition, but they're equivalent:
    -- time_part has no trailing two bytes, and tail is only
    -- the last two bytes.
    RETURN time_part | tail;
  END
$$;
 4   DROP FUNCTION public.timestamp_id(table_name text);
       public       nolan    false    1    3            �            1259    218750    account_domain_blocks    TABLE     �   CREATE TABLE account_domain_blocks (
    id bigint NOT NULL,
    domain character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint
);
 )   DROP TABLE public.account_domain_blocks;
       public         nolan    false    3            �            1259    218756    account_domain_blocks_id_seq    SEQUENCE     ~   CREATE SEQUENCE account_domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.account_domain_blocks_id_seq;
       public       nolan    false    3    196                       0    0    account_domain_blocks_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE account_domain_blocks_id_seq OWNED BY account_domain_blocks.id;
            public       nolan    false    197            �            1259    218758    account_moderation_notes    TABLE       CREATE TABLE account_moderation_notes (
    id bigint NOT NULL,
    content text NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 ,   DROP TABLE public.account_moderation_notes;
       public         nolan    false    3            �            1259    218764    account_moderation_notes_id_seq    SEQUENCE     �   CREATE SEQUENCE account_moderation_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.account_moderation_notes_id_seq;
       public       nolan    false    3    198                       0    0    account_moderation_notes_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE account_moderation_notes_id_seq OWNED BY account_moderation_notes.id;
            public       nolan    false    199            �            1259    218766    accounts    TABLE       CREATE TABLE accounts (
    id bigint NOT NULL,
    username character varying DEFAULT ''::character varying NOT NULL,
    domain character varying,
    secret character varying DEFAULT ''::character varying NOT NULL,
    private_key text,
    public_key text DEFAULT ''::text NOT NULL,
    remote_url character varying DEFAULT ''::character varying NOT NULL,
    salmon_url character varying DEFAULT ''::character varying NOT NULL,
    hub_url character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    display_name character varying DEFAULT ''::character varying NOT NULL,
    uri character varying DEFAULT ''::character varying NOT NULL,
    url character varying,
    avatar_file_name character varying,
    avatar_content_type character varying,
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    header_file_name character varying,
    header_content_type character varying,
    header_file_size integer,
    header_updated_at timestamp without time zone,
    avatar_remote_url character varying,
    subscription_expires_at timestamp without time zone,
    silenced boolean DEFAULT false NOT NULL,
    suspended boolean DEFAULT false NOT NULL,
    locked boolean DEFAULT false NOT NULL,
    header_remote_url character varying DEFAULT ''::character varying NOT NULL,
    statuses_count integer DEFAULT 0 NOT NULL,
    followers_count integer DEFAULT 0 NOT NULL,
    following_count integer DEFAULT 0 NOT NULL,
    last_webfingered_at timestamp without time zone,
    inbox_url character varying DEFAULT ''::character varying NOT NULL,
    outbox_url character varying DEFAULT ''::character varying NOT NULL,
    shared_inbox_url character varying DEFAULT ''::character varying NOT NULL,
    followers_url character varying DEFAULT ''::character varying NOT NULL,
    protocol integer DEFAULT 0 NOT NULL,
    memorial boolean DEFAULT false NOT NULL,
    moved_to_account_id bigint
);
    DROP TABLE public.accounts;
       public         nolan    false    3            �            1259    218794    accounts_id_seq    SEQUENCE     q   CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.accounts_id_seq;
       public       nolan    false    200    3                       0    0    accounts_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;
            public       nolan    false    201            �            1259    218796    admin_action_logs    TABLE     o  CREATE TABLE admin_action_logs (
    id bigint NOT NULL,
    account_id bigint,
    action character varying DEFAULT ''::character varying NOT NULL,
    target_type character varying,
    target_id bigint,
    recorded_changes text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 %   DROP TABLE public.admin_action_logs;
       public         nolan    false    3            �            1259    218804    admin_action_logs_id_seq    SEQUENCE     z   CREATE SEQUENCE admin_action_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.admin_action_logs_id_seq;
       public       nolan    false    202    3                       0    0    admin_action_logs_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE admin_action_logs_id_seq OWNED BY admin_action_logs.id;
            public       nolan    false    203            �            1259    218806    ar_internal_metadata    TABLE     �   CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 (   DROP TABLE public.ar_internal_metadata;
       public         nolan    false    3            �            1259    218812    blocks    TABLE     �   CREATE TABLE blocks (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL
);
    DROP TABLE public.blocks;
       public         nolan    false    3            �            1259    218815    blocks_id_seq    SEQUENCE     o   CREATE SEQUENCE blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.blocks_id_seq;
       public       nolan    false    3    205                       0    0    blocks_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE blocks_id_seq OWNED BY blocks.id;
            public       nolan    false    206            �            1259    218817    conversation_mutes    TABLE     �   CREATE TABLE conversation_mutes (
    id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    account_id bigint NOT NULL
);
 &   DROP TABLE public.conversation_mutes;
       public         nolan    false    3            �            1259    218820    conversation_mutes_id_seq    SEQUENCE     {   CREATE SEQUENCE conversation_mutes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.conversation_mutes_id_seq;
       public       nolan    false    207    3                       0    0    conversation_mutes_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE conversation_mutes_id_seq OWNED BY conversation_mutes.id;
            public       nolan    false    208            �            1259    218822    conversations    TABLE     �   CREATE TABLE conversations (
    id bigint NOT NULL,
    uri character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 !   DROP TABLE public.conversations;
       public         nolan    false    3            �            1259    218828    conversations_id_seq    SEQUENCE     v   CREATE SEQUENCE conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.conversations_id_seq;
       public       nolan    false    3    209                       0    0    conversations_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE conversations_id_seq OWNED BY conversations.id;
            public       nolan    false    210            �            1259    218830    custom_emojis    TABLE     L  CREATE TABLE custom_emojis (
    id bigint NOT NULL,
    shortcode character varying DEFAULT ''::character varying NOT NULL,
    domain character varying,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    uri character varying,
    image_remote_url character varying,
    visible_in_picker boolean DEFAULT true NOT NULL
);
 !   DROP TABLE public.custom_emojis;
       public         nolan    false    3            �            1259    218839    custom_emojis_id_seq    SEQUENCE     v   CREATE SEQUENCE custom_emojis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.custom_emojis_id_seq;
       public       nolan    false    3    211            	           0    0    custom_emojis_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE custom_emojis_id_seq OWNED BY custom_emojis.id;
            public       nolan    false    212            �            1259    218841    domain_blocks    TABLE     7  CREATE TABLE domain_blocks (
    id bigint NOT NULL,
    domain character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    severity integer DEFAULT 0,
    reject_media boolean DEFAULT false NOT NULL
);
 !   DROP TABLE public.domain_blocks;
       public         nolan    false    3            �            1259    218850    domain_blocks_id_seq    SEQUENCE     v   CREATE SEQUENCE domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.domain_blocks_id_seq;
       public       nolan    false    213    3            
           0    0    domain_blocks_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE domain_blocks_id_seq OWNED BY domain_blocks.id;
            public       nolan    false    214            �            1259    218852    email_domain_blocks    TABLE     �   CREATE TABLE email_domain_blocks (
    id bigint NOT NULL,
    domain character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 '   DROP TABLE public.email_domain_blocks;
       public         nolan    false    3            �            1259    218859    email_domain_blocks_id_seq    SEQUENCE     |   CREATE SEQUENCE email_domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.email_domain_blocks_id_seq;
       public       nolan    false    215    3                       0    0    email_domain_blocks_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE email_domain_blocks_id_seq OWNED BY email_domain_blocks.id;
            public       nolan    false    216            �            1259    218861 
   favourites    TABLE     �   CREATE TABLE favourites (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    status_id bigint NOT NULL
);
    DROP TABLE public.favourites;
       public         nolan    false    3            �            1259    218864    favourites_id_seq    SEQUENCE     s   CREATE SEQUENCE favourites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.favourites_id_seq;
       public       nolan    false    3    217                       0    0    favourites_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE favourites_id_seq OWNED BY favourites.id;
            public       nolan    false    218            �            1259    218866    follow_requests    TABLE       CREATE TABLE follow_requests (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    show_reblogs boolean DEFAULT true NOT NULL
);
 #   DROP TABLE public.follow_requests;
       public         nolan    false    3            �            1259    218870    follow_requests_id_seq    SEQUENCE     x   CREATE SEQUENCE follow_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.follow_requests_id_seq;
       public       nolan    false    219    3                       0    0    follow_requests_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE follow_requests_id_seq OWNED BY follow_requests.id;
            public       nolan    false    220            �            1259    218872    follows    TABLE       CREATE TABLE follows (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    show_reblogs boolean DEFAULT true NOT NULL
);
    DROP TABLE public.follows;
       public         nolan    false    3            �            1259    218876    follows_id_seq    SEQUENCE     p   CREATE SEQUENCE follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.follows_id_seq;
       public       nolan    false    3    221                       0    0    follows_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE follows_id_seq OWNED BY follows.id;
            public       nolan    false    222            �            1259    218878    imports    TABLE     �  CREATE TABLE imports (
    id bigint NOT NULL,
    type integer NOT NULL,
    approved boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    data_file_name character varying,
    data_content_type character varying,
    data_file_size integer,
    data_updated_at timestamp without time zone,
    account_id bigint NOT NULL
);
    DROP TABLE public.imports;
       public         nolan    false    3            �            1259    218885    imports_id_seq    SEQUENCE     p   CREATE SEQUENCE imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.imports_id_seq;
       public       nolan    false    3    223                       0    0    imports_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE imports_id_seq OWNED BY imports.id;
            public       nolan    false    224            �            1259    218887    invites    TABLE     Y  CREATE TABLE invites (
    id bigint NOT NULL,
    user_id bigint,
    code character varying DEFAULT ''::character varying NOT NULL,
    expires_at timestamp without time zone,
    max_uses integer,
    uses integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.invites;
       public         nolan    false    3            �            1259    218895    invites_id_seq    SEQUENCE     p   CREATE SEQUENCE invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.invites_id_seq;
       public       nolan    false    225    3                       0    0    invites_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE invites_id_seq OWNED BY invites.id;
            public       nolan    false    226            �            1259    218897    list_accounts    TABLE     �   CREATE TABLE list_accounts (
    id bigint NOT NULL,
    list_id bigint NOT NULL,
    account_id bigint NOT NULL,
    follow_id bigint NOT NULL
);
 !   DROP TABLE public.list_accounts;
       public         nolan    false    3            �            1259    218900    list_accounts_id_seq    SEQUENCE     v   CREATE SEQUENCE list_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.list_accounts_id_seq;
       public       nolan    false    3    227                       0    0    list_accounts_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE list_accounts_id_seq OWNED BY list_accounts.id;
            public       nolan    false    228            �            1259    218902    lists    TABLE     �   CREATE TABLE lists (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.lists;
       public         nolan    false    3            �            1259    218909    lists_id_seq    SEQUENCE     n   CREATE SEQUENCE lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.lists_id_seq;
       public       nolan    false    3    229                       0    0    lists_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE lists_id_seq OWNED BY lists.id;
            public       nolan    false    230            �            1259    218911    media_attachments    TABLE     '  CREATE TABLE media_attachments (
    id bigint NOT NULL,
    status_id bigint,
    file_file_name character varying,
    file_content_type character varying,
    file_file_size integer,
    file_updated_at timestamp without time zone,
    remote_url character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    shortcode character varying,
    type integer DEFAULT 0 NOT NULL,
    file_meta json,
    account_id bigint,
    description text
);
 %   DROP TABLE public.media_attachments;
       public         nolan    false    3            �            1259    218919    media_attachments_id_seq    SEQUENCE     z   CREATE SEQUENCE media_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.media_attachments_id_seq;
       public       nolan    false    3    231                       0    0    media_attachments_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE media_attachments_id_seq OWNED BY media_attachments.id;
            public       nolan    false    232            �            1259    218921    mentions    TABLE     �   CREATE TABLE mentions (
    id bigint NOT NULL,
    status_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint
);
    DROP TABLE public.mentions;
       public         nolan    false    3            �            1259    218924    mentions_id_seq    SEQUENCE     q   CREATE SEQUENCE mentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.mentions_id_seq;
       public       nolan    false    3    233                       0    0    mentions_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE mentions_id_seq OWNED BY mentions.id;
            public       nolan    false    234            �            1259    218926    mutes    TABLE       CREATE TABLE mutes (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    hide_notifications boolean DEFAULT true NOT NULL
);
    DROP TABLE public.mutes;
       public         nolan    false    3            �            1259    218930    mutes_id_seq    SEQUENCE     n   CREATE SEQUENCE mutes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.mutes_id_seq;
       public       nolan    false    3    235                       0    0    mutes_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE mutes_id_seq OWNED BY mutes.id;
            public       nolan    false    236            �            1259    218932    notifications    TABLE       CREATE TABLE notifications (
    id bigint NOT NULL,
    activity_id bigint,
    activity_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint,
    from_account_id bigint
);
 !   DROP TABLE public.notifications;
       public         nolan    false    3            �            1259    218938    notifications_id_seq    SEQUENCE     v   CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.notifications_id_seq;
       public       nolan    false    3    237                       0    0    notifications_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;
            public       nolan    false    238            �            1259    218940    oauth_access_grants    TABLE     n  CREATE TABLE oauth_access_grants (
    id bigint NOT NULL,
    token character varying NOT NULL,
    expires_in integer NOT NULL,
    redirect_uri text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    scopes character varying,
    application_id bigint NOT NULL,
    resource_owner_id bigint NOT NULL
);
 '   DROP TABLE public.oauth_access_grants;
       public         nolan    false    3            �            1259    218946    oauth_access_grants_id_seq    SEQUENCE     |   CREATE SEQUENCE oauth_access_grants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.oauth_access_grants_id_seq;
       public       nolan    false    3    239                       0    0    oauth_access_grants_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE oauth_access_grants_id_seq OWNED BY oauth_access_grants.id;
            public       nolan    false    240            �            1259    218948    oauth_access_tokens    TABLE     X  CREATE TABLE oauth_access_tokens (
    id bigint NOT NULL,
    token character varying NOT NULL,
    refresh_token character varying,
    expires_in integer,
    revoked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    scopes character varying,
    application_id bigint,
    resource_owner_id bigint
);
 '   DROP TABLE public.oauth_access_tokens;
       public         nolan    false    3            �            1259    218954    oauth_access_tokens_id_seq    SEQUENCE     |   CREATE SEQUENCE oauth_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.oauth_access_tokens_id_seq;
       public       nolan    false    3    241                       0    0    oauth_access_tokens_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE oauth_access_tokens_id_seq OWNED BY oauth_access_tokens.id;
            public       nolan    false    242            �            1259    218956    oauth_applications    TABLE     �  CREATE TABLE oauth_applications (
    id bigint NOT NULL,
    name character varying NOT NULL,
    uid character varying NOT NULL,
    secret character varying NOT NULL,
    redirect_uri text NOT NULL,
    scopes character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    superapp boolean DEFAULT false NOT NULL,
    website character varying,
    owner_type character varying,
    owner_id bigint
);
 &   DROP TABLE public.oauth_applications;
       public         nolan    false    3            �            1259    218964    oauth_applications_id_seq    SEQUENCE     {   CREATE SEQUENCE oauth_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.oauth_applications_id_seq;
       public       nolan    false    3    243                       0    0    oauth_applications_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE oauth_applications_id_seq OWNED BY oauth_applications.id;
            public       nolan    false    244            �            1259    218966    preview_cards    TABLE       CREATE TABLE preview_cards (
    id bigint NOT NULL,
    url character varying DEFAULT ''::character varying NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    type integer DEFAULT 0 NOT NULL,
    html text DEFAULT ''::text NOT NULL,
    author_name character varying DEFAULT ''::character varying NOT NULL,
    author_url character varying DEFAULT ''::character varying NOT NULL,
    provider_name character varying DEFAULT ''::character varying NOT NULL,
    provider_url character varying DEFAULT ''::character varying NOT NULL,
    width integer DEFAULT 0 NOT NULL,
    height integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    embed_url character varying DEFAULT ''::character varying NOT NULL
);
 !   DROP TABLE public.preview_cards;
       public         nolan    false    3            �            1259    218984    preview_cards_id_seq    SEQUENCE     v   CREATE SEQUENCE preview_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.preview_cards_id_seq;
       public       nolan    false    3    245                       0    0    preview_cards_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE preview_cards_id_seq OWNED BY preview_cards.id;
            public       nolan    false    246            �            1259    218986    preview_cards_statuses    TABLE     l   CREATE TABLE preview_cards_statuses (
    preview_card_id bigint NOT NULL,
    status_id bigint NOT NULL
);
 *   DROP TABLE public.preview_cards_statuses;
       public         nolan    false    3            �            1259    218989    reports    TABLE     �  CREATE TABLE reports (
    id bigint NOT NULL,
    status_ids bigint[] DEFAULT '{}'::bigint[] NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    action_taken boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    action_taken_by_account_id bigint,
    target_account_id bigint NOT NULL
);
    DROP TABLE public.reports;
       public         nolan    false    3            �            1259    218998    reports_id_seq    SEQUENCE     p   CREATE SEQUENCE reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.reports_id_seq;
       public       nolan    false    3    248                       0    0    reports_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE reports_id_seq OWNED BY reports.id;
            public       nolan    false    249            �            1259    219000    schema_migrations    TABLE     K   CREATE TABLE schema_migrations (
    version character varying NOT NULL
);
 %   DROP TABLE public.schema_migrations;
       public         nolan    false    3            �            1259    219006    session_activations    TABLE     �  CREATE TABLE session_activations (
    id bigint NOT NULL,
    session_id character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_agent character varying DEFAULT ''::character varying NOT NULL,
    ip inet,
    access_token_id bigint,
    user_id bigint NOT NULL,
    web_push_subscription_id bigint
);
 '   DROP TABLE public.session_activations;
       public         nolan    false    3            �            1259    219013    session_activations_id_seq    SEQUENCE     |   CREATE SEQUENCE session_activations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.session_activations_id_seq;
       public       nolan    false    251    3                       0    0    session_activations_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE session_activations_id_seq OWNED BY session_activations.id;
            public       nolan    false    252            �            1259    219015    settings    TABLE     �   CREATE TABLE settings (
    id bigint NOT NULL,
    var character varying NOT NULL,
    value text,
    thing_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    thing_id bigint
);
    DROP TABLE public.settings;
       public         nolan    false    3            �            1259    219021    settings_id_seq    SEQUENCE     q   CREATE SEQUENCE settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.settings_id_seq;
       public       nolan    false    3    253                       0    0    settings_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE settings_id_seq OWNED BY settings.id;
            public       nolan    false    254            �            1259    219023    site_uploads    TABLE     �  CREATE TABLE site_uploads (
    id bigint NOT NULL,
    var character varying DEFAULT ''::character varying NOT NULL,
    file_file_name character varying,
    file_content_type character varying,
    file_file_size integer,
    file_updated_at timestamp without time zone,
    meta json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
     DROP TABLE public.site_uploads;
       public         nolan    false    3                        1259    219030    site_uploads_id_seq    SEQUENCE     u   CREATE SEQUENCE site_uploads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.site_uploads_id_seq;
       public       nolan    false    3    255                       0    0    site_uploads_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE site_uploads_id_seq OWNED BY site_uploads.id;
            public       nolan    false    256                       1259    219032    status_pins    TABLE     �   CREATE TABLE status_pins (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    status_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.status_pins;
       public         nolan    false    3                       1259    219037    status_pins_id_seq    SEQUENCE     t   CREATE SEQUENCE status_pins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.status_pins_id_seq;
       public       nolan    false    3    257                       0    0    status_pins_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE status_pins_id_seq OWNED BY status_pins.id;
            public       nolan    false    258                       1259    219039    statuses    TABLE       CREATE TABLE statuses (
    id bigint DEFAULT timestamp_id('statuses'::text) NOT NULL,
    uri character varying,
    text text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    in_reply_to_id bigint,
    reblog_of_id bigint,
    url character varying,
    sensitive boolean DEFAULT false NOT NULL,
    visibility integer DEFAULT 0 NOT NULL,
    spoiler_text text DEFAULT ''::text NOT NULL,
    reply boolean DEFAULT false NOT NULL,
    favourites_count integer DEFAULT 0 NOT NULL,
    reblogs_count integer DEFAULT 0 NOT NULL,
    language character varying,
    conversation_id bigint,
    local boolean,
    account_id bigint NOT NULL,
    application_id bigint,
    in_reply_to_account_id bigint
);
    DROP TABLE public.statuses;
       public         nolan    false    282    3                       1259    219053    statuses_id_seq    SEQUENCE     q   CREATE SEQUENCE statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.statuses_id_seq;
       public       nolan    false    3                       1259    219055    statuses_tags    TABLE     Z   CREATE TABLE statuses_tags (
    status_id bigint NOT NULL,
    tag_id bigint NOT NULL
);
 !   DROP TABLE public.statuses_tags;
       public         nolan    false    3                       1259    219058    stream_entries    TABLE     !  CREATE TABLE stream_entries (
    id bigint NOT NULL,
    activity_id bigint,
    activity_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    account_id bigint
);
 "   DROP TABLE public.stream_entries;
       public         nolan    false    3                       1259    219065    stream_entries_id_seq    SEQUENCE     w   CREATE SEQUENCE stream_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.stream_entries_id_seq;
       public       nolan    false    3    262                        0    0    stream_entries_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE stream_entries_id_seq OWNED BY stream_entries.id;
            public       nolan    false    263                       1259    219067    subscriptions    TABLE     �  CREATE TABLE subscriptions (
    id bigint NOT NULL,
    callback_url character varying DEFAULT ''::character varying NOT NULL,
    secret character varying,
    expires_at timestamp without time zone,
    confirmed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_successful_delivery_at timestamp without time zone,
    domain character varying,
    account_id bigint NOT NULL
);
 !   DROP TABLE public.subscriptions;
       public         nolan    false    3            	           1259    219075    subscriptions_id_seq    SEQUENCE     v   CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.subscriptions_id_seq;
       public       nolan    false    3    264            !           0    0    subscriptions_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;
            public       nolan    false    265            
           1259    219077    tags    TABLE     �   CREATE TABLE tags (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.tags;
       public         nolan    false    3                       1259    219084    tags_id_seq    SEQUENCE     m   CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.tags_id_seq;
       public       nolan    false    3    266            "           0    0    tags_id_seq    SEQUENCE OWNED BY     -   ALTER SEQUENCE tags_id_seq OWNED BY tags.id;
            public       nolan    false    267                       1259    219086    users    TABLE     �  CREATE TABLE users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    admin boolean DEFAULT false NOT NULL,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    locale character varying,
    encrypted_otp_secret character varying,
    encrypted_otp_secret_iv character varying,
    encrypted_otp_secret_salt character varying,
    consumed_timestep integer,
    otp_required_for_login boolean DEFAULT false NOT NULL,
    last_emailed_at timestamp without time zone,
    otp_backup_codes character varying[],
    filtered_languages character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    account_id bigint NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    moderator boolean DEFAULT false NOT NULL,
    invite_id bigint
);
    DROP TABLE public.users;
       public         nolan    false    3                       1259    219100    users_id_seq    SEQUENCE     n   CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public       nolan    false    3    268            #           0    0    users_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE users_id_seq OWNED BY users.id;
            public       nolan    false    269                       1259    219102    web_push_subscriptions    TABLE     6  CREATE TABLE web_push_subscriptions (
    id bigint NOT NULL,
    endpoint character varying NOT NULL,
    key_p256dh character varying NOT NULL,
    key_auth character varying NOT NULL,
    data json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 *   DROP TABLE public.web_push_subscriptions;
       public         nolan    false    3                       1259    219108    web_push_subscriptions_id_seq    SEQUENCE        CREATE SEQUENCE web_push_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.web_push_subscriptions_id_seq;
       public       nolan    false    3    270            $           0    0    web_push_subscriptions_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE web_push_subscriptions_id_seq OWNED BY web_push_subscriptions.id;
            public       nolan    false    271                       1259    219110    web_settings    TABLE     �   CREATE TABLE web_settings (
    id bigint NOT NULL,
    data json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id bigint
);
     DROP TABLE public.web_settings;
       public         nolan    false    3                       1259    219116    web_settings_id_seq    SEQUENCE     u   CREATE SEQUENCE web_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.web_settings_id_seq;
       public       nolan    false    272    3            %           0    0    web_settings_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE web_settings_id_seq OWNED BY web_settings.id;
            public       nolan    false    273            �	           2604    219118    account_domain_blocks id    DEFAULT     v   ALTER TABLE ONLY account_domain_blocks ALTER COLUMN id SET DEFAULT nextval('account_domain_blocks_id_seq'::regclass);
 G   ALTER TABLE public.account_domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    197    196            �	           2604    219119    account_moderation_notes id    DEFAULT     |   ALTER TABLE ONLY account_moderation_notes ALTER COLUMN id SET DEFAULT nextval('account_moderation_notes_id_seq'::regclass);
 J   ALTER TABLE public.account_moderation_notes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    199    198            
           2604    219120    accounts id    DEFAULT     \   ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);
 :   ALTER TABLE public.accounts ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    201    200            
           2604    219121    admin_action_logs id    DEFAULT     n   ALTER TABLE ONLY admin_action_logs ALTER COLUMN id SET DEFAULT nextval('admin_action_logs_id_seq'::regclass);
 C   ALTER TABLE public.admin_action_logs ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    203    202            
           2604    219122 	   blocks id    DEFAULT     X   ALTER TABLE ONLY blocks ALTER COLUMN id SET DEFAULT nextval('blocks_id_seq'::regclass);
 8   ALTER TABLE public.blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    206    205            
           2604    219123    conversation_mutes id    DEFAULT     p   ALTER TABLE ONLY conversation_mutes ALTER COLUMN id SET DEFAULT nextval('conversation_mutes_id_seq'::regclass);
 D   ALTER TABLE public.conversation_mutes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    208    207            
           2604    219124    conversations id    DEFAULT     f   ALTER TABLE ONLY conversations ALTER COLUMN id SET DEFAULT nextval('conversations_id_seq'::regclass);
 ?   ALTER TABLE public.conversations ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    210    209            
           2604    219125    custom_emojis id    DEFAULT     f   ALTER TABLE ONLY custom_emojis ALTER COLUMN id SET DEFAULT nextval('custom_emojis_id_seq'::regclass);
 ?   ALTER TABLE public.custom_emojis ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    212    211            
           2604    219126    domain_blocks id    DEFAULT     f   ALTER TABLE ONLY domain_blocks ALTER COLUMN id SET DEFAULT nextval('domain_blocks_id_seq'::regclass);
 ?   ALTER TABLE public.domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    214    213             
           2604    219127    email_domain_blocks id    DEFAULT     r   ALTER TABLE ONLY email_domain_blocks ALTER COLUMN id SET DEFAULT nextval('email_domain_blocks_id_seq'::regclass);
 E   ALTER TABLE public.email_domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    216    215            !
           2604    219128    favourites id    DEFAULT     `   ALTER TABLE ONLY favourites ALTER COLUMN id SET DEFAULT nextval('favourites_id_seq'::regclass);
 <   ALTER TABLE public.favourites ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    218    217            #
           2604    219129    follow_requests id    DEFAULT     j   ALTER TABLE ONLY follow_requests ALTER COLUMN id SET DEFAULT nextval('follow_requests_id_seq'::regclass);
 A   ALTER TABLE public.follow_requests ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    220    219            %
           2604    219130 
   follows id    DEFAULT     Z   ALTER TABLE ONLY follows ALTER COLUMN id SET DEFAULT nextval('follows_id_seq'::regclass);
 9   ALTER TABLE public.follows ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    222    221            '
           2604    219131 
   imports id    DEFAULT     Z   ALTER TABLE ONLY imports ALTER COLUMN id SET DEFAULT nextval('imports_id_seq'::regclass);
 9   ALTER TABLE public.imports ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    224    223            *
           2604    219132 
   invites id    DEFAULT     Z   ALTER TABLE ONLY invites ALTER COLUMN id SET DEFAULT nextval('invites_id_seq'::regclass);
 9   ALTER TABLE public.invites ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    226    225            +
           2604    219133    list_accounts id    DEFAULT     f   ALTER TABLE ONLY list_accounts ALTER COLUMN id SET DEFAULT nextval('list_accounts_id_seq'::regclass);
 ?   ALTER TABLE public.list_accounts ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    228    227            -
           2604    219134    lists id    DEFAULT     V   ALTER TABLE ONLY lists ALTER COLUMN id SET DEFAULT nextval('lists_id_seq'::regclass);
 7   ALTER TABLE public.lists ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    230    229            0
           2604    219135    media_attachments id    DEFAULT     n   ALTER TABLE ONLY media_attachments ALTER COLUMN id SET DEFAULT nextval('media_attachments_id_seq'::regclass);
 C   ALTER TABLE public.media_attachments ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    232    231            1
           2604    219136    mentions id    DEFAULT     \   ALTER TABLE ONLY mentions ALTER COLUMN id SET DEFAULT nextval('mentions_id_seq'::regclass);
 :   ALTER TABLE public.mentions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    234    233            3
           2604    219137    mutes id    DEFAULT     V   ALTER TABLE ONLY mutes ALTER COLUMN id SET DEFAULT nextval('mutes_id_seq'::regclass);
 7   ALTER TABLE public.mutes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    236    235            4
           2604    219138    notifications id    DEFAULT     f   ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);
 ?   ALTER TABLE public.notifications ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    238    237            5
           2604    219139    oauth_access_grants id    DEFAULT     r   ALTER TABLE ONLY oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('oauth_access_grants_id_seq'::regclass);
 E   ALTER TABLE public.oauth_access_grants ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    240    239            6
           2604    219140    oauth_access_tokens id    DEFAULT     r   ALTER TABLE ONLY oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('oauth_access_tokens_id_seq'::regclass);
 E   ALTER TABLE public.oauth_access_tokens ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    242    241            9
           2604    219141    oauth_applications id    DEFAULT     p   ALTER TABLE ONLY oauth_applications ALTER COLUMN id SET DEFAULT nextval('oauth_applications_id_seq'::regclass);
 D   ALTER TABLE public.oauth_applications ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    244    243            F
           2604    219142    preview_cards id    DEFAULT     f   ALTER TABLE ONLY preview_cards ALTER COLUMN id SET DEFAULT nextval('preview_cards_id_seq'::regclass);
 ?   ALTER TABLE public.preview_cards ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    246    245            J
           2604    219143 
   reports id    DEFAULT     Z   ALTER TABLE ONLY reports ALTER COLUMN id SET DEFAULT nextval('reports_id_seq'::regclass);
 9   ALTER TABLE public.reports ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    249    248            L
           2604    219144    session_activations id    DEFAULT     r   ALTER TABLE ONLY session_activations ALTER COLUMN id SET DEFAULT nextval('session_activations_id_seq'::regclass);
 E   ALTER TABLE public.session_activations ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    252    251            M
           2604    219145    settings id    DEFAULT     \   ALTER TABLE ONLY settings ALTER COLUMN id SET DEFAULT nextval('settings_id_seq'::regclass);
 :   ALTER TABLE public.settings ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    254    253            O
           2604    219146    site_uploads id    DEFAULT     d   ALTER TABLE ONLY site_uploads ALTER COLUMN id SET DEFAULT nextval('site_uploads_id_seq'::regclass);
 >   ALTER TABLE public.site_uploads ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    256    255            R
           2604    219147    status_pins id    DEFAULT     b   ALTER TABLE ONLY status_pins ALTER COLUMN id SET DEFAULT nextval('status_pins_id_seq'::regclass);
 =   ALTER TABLE public.status_pins ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    258    257            \
           2604    219148    stream_entries id    DEFAULT     h   ALTER TABLE ONLY stream_entries ALTER COLUMN id SET DEFAULT nextval('stream_entries_id_seq'::regclass);
 @   ALTER TABLE public.stream_entries ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    263    262            _
           2604    219149    subscriptions id    DEFAULT     f   ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);
 ?   ALTER TABLE public.subscriptions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    265    264            a
           2604    219150    tags id    DEFAULT     T   ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);
 6   ALTER TABLE public.tags ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    267    266            j
           2604    219151    users id    DEFAULT     V   ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    269    268            k
           2604    219152    web_push_subscriptions id    DEFAULT     x   ALTER TABLE ONLY web_push_subscriptions ALTER COLUMN id SET DEFAULT nextval('web_push_subscriptions_id_seq'::regclass);
 H   ALTER TABLE public.web_push_subscriptions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    271    270            l
           2604    219153    web_settings id    DEFAULT     d   ALTER TABLE ONLY web_settings ALTER COLUMN id SET DEFAULT nextval('web_settings_id_seq'::regclass);
 >   ALTER TABLE public.web_settings ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    273    272            �          0    218750    account_domain_blocks 
   TABLE DATA               X   COPY account_domain_blocks (id, domain, created_at, updated_at, account_id) FROM stdin;
    public       nolan    false    196   �      �          0    218758    account_moderation_notes 
   TABLE DATA               o   COPY account_moderation_notes (id, content, account_id, target_account_id, created_at, updated_at) FROM stdin;
    public       nolan    false    198   ;�      �          0    218766    accounts 
   TABLE DATA               E  COPY accounts (id, username, domain, secret, private_key, public_key, remote_url, salmon_url, hub_url, created_at, updated_at, note, display_name, uri, url, avatar_file_name, avatar_content_type, avatar_file_size, avatar_updated_at, header_file_name, header_content_type, header_file_size, header_updated_at, avatar_remote_url, subscription_expires_at, silenced, suspended, locked, header_remote_url, statuses_count, followers_count, following_count, last_webfingered_at, inbox_url, outbox_url, shared_inbox_url, followers_url, protocol, memorial, moved_to_account_id) FROM stdin;
    public       nolan    false    200   X�      �          0    218796    admin_action_logs 
   TABLE DATA               ~   COPY admin_action_logs (id, account_id, action, target_type, target_id, recorded_changes, created_at, updated_at) FROM stdin;
    public       nolan    false    202   �      �          0    218806    ar_internal_metadata 
   TABLE DATA               K   COPY ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public       nolan    false    204   �      �          0    218812    blocks 
   TABLE DATA               T   COPY blocks (id, created_at, updated_at, account_id, target_account_id) FROM stdin;
    public       nolan    false    205   �      �          0    218817    conversation_mutes 
   TABLE DATA               F   COPY conversation_mutes (id, conversation_id, account_id) FROM stdin;
    public       nolan    false    207         �          0    218822    conversations 
   TABLE DATA               A   COPY conversations (id, uri, created_at, updated_at) FROM stdin;
    public       nolan    false    209   5      �          0    218830    custom_emojis 
   TABLE DATA               �   COPY custom_emojis (id, shortcode, domain, image_file_name, image_content_type, image_file_size, image_updated_at, created_at, updated_at, disabled, uri, image_remote_url, visible_in_picker) FROM stdin;
    public       nolan    false    211   R      �          0    218841    domain_blocks 
   TABLE DATA               \   COPY domain_blocks (id, domain, created_at, updated_at, severity, reject_media) FROM stdin;
    public       nolan    false    213         �          0    218852    email_domain_blocks 
   TABLE DATA               J   COPY email_domain_blocks (id, domain, created_at, updated_at) FROM stdin;
    public       nolan    false    215         �          0    218861 
   favourites 
   TABLE DATA               P   COPY favourites (id, created_at, updated_at, account_id, status_id) FROM stdin;
    public       nolan    false    217   ;      �          0    218866    follow_requests 
   TABLE DATA               k   COPY follow_requests (id, created_at, updated_at, account_id, target_account_id, show_reblogs) FROM stdin;
    public       nolan    false    219   X      �          0    218872    follows 
   TABLE DATA               c   COPY follows (id, created_at, updated_at, account_id, target_account_id, show_reblogs) FROM stdin;
    public       nolan    false    221   u      �          0    218878    imports 
   TABLE DATA               �   COPY imports (id, type, approved, created_at, updated_at, data_file_name, data_content_type, data_file_size, data_updated_at, account_id) FROM stdin;
    public       nolan    false    223   �      �          0    218887    invites 
   TABLE DATA               a   COPY invites (id, user_id, code, expires_at, max_uses, uses, created_at, updated_at) FROM stdin;
    public       nolan    false    225   �      �          0    218897    list_accounts 
   TABLE DATA               D   COPY list_accounts (id, list_id, account_id, follow_id) FROM stdin;
    public       nolan    false    227         �          0    218902    lists 
   TABLE DATA               G   COPY lists (id, account_id, title, created_at, updated_at) FROM stdin;
    public       nolan    false    229   8      �          0    218911    media_attachments 
   TABLE DATA               �   COPY media_attachments (id, status_id, file_file_name, file_content_type, file_file_size, file_updated_at, remote_url, created_at, updated_at, shortcode, type, file_meta, account_id, description) FROM stdin;
    public       nolan    false    231   U      �          0    218921    mentions 
   TABLE DATA               N   COPY mentions (id, status_id, created_at, updated_at, account_id) FROM stdin;
    public       nolan    false    233   r      �          0    218926    mutes 
   TABLE DATA               g   COPY mutes (id, created_at, updated_at, account_id, target_account_id, hide_notifications) FROM stdin;
    public       nolan    false    235   �      �          0    218932    notifications 
   TABLE DATA               u   COPY notifications (id, activity_id, activity_type, created_at, updated_at, account_id, from_account_id) FROM stdin;
    public       nolan    false    237   �      �          0    218940    oauth_access_grants 
   TABLE DATA               �   COPY oauth_access_grants (id, token, expires_in, redirect_uri, created_at, revoked_at, scopes, application_id, resource_owner_id) FROM stdin;
    public       nolan    false    239   &      �          0    218948    oauth_access_tokens 
   TABLE DATA               �   COPY oauth_access_tokens (id, token, refresh_token, expires_in, revoked_at, created_at, scopes, application_id, resource_owner_id) FROM stdin;
    public       nolan    false    241   C      �          0    218956    oauth_applications 
   TABLE DATA               �   COPY oauth_applications (id, name, uid, secret, redirect_uri, scopes, created_at, updated_at, superapp, website, owner_type, owner_id) FROM stdin;
    public       nolan    false    243   �      �          0    218966    preview_cards 
   TABLE DATA               �   COPY preview_cards (id, url, title, description, image_file_name, image_content_type, image_file_size, image_updated_at, type, html, author_name, author_url, provider_name, provider_url, width, height, created_at, updated_at, embed_url) FROM stdin;
    public       nolan    false    245   W      �          0    218986    preview_cards_statuses 
   TABLE DATA               E   COPY preview_cards_statuses (preview_card_id, status_id) FROM stdin;
    public       nolan    false    247   t      �          0    218989    reports 
   TABLE DATA               �   COPY reports (id, status_ids, comment, action_taken, created_at, updated_at, account_id, action_taken_by_account_id, target_account_id) FROM stdin;
    public       nolan    false    248   �      �          0    219000    schema_migrations 
   TABLE DATA               -   COPY schema_migrations (version) FROM stdin;
    public       nolan    false    250   �      �          0    219006    session_activations 
   TABLE DATA               �   COPY session_activations (id, session_id, created_at, updated_at, user_agent, ip, access_token_id, user_id, web_push_subscription_id) FROM stdin;
    public       nolan    false    251   �      �          0    219015    settings 
   TABLE DATA               Y   COPY settings (id, var, value, thing_type, created_at, updated_at, thing_id) FROM stdin;
    public       nolan    false    253   L       �          0    219023    site_uploads 
   TABLE DATA               �   COPY site_uploads (id, var, file_file_name, file_content_type, file_file_size, file_updated_at, meta, created_at, updated_at) FROM stdin;
    public       nolan    false    255   i       �          0    219032    status_pins 
   TABLE DATA               Q   COPY status_pins (id, account_id, status_id, created_at, updated_at) FROM stdin;
    public       nolan    false    257   �       �          0    219039    statuses 
   TABLE DATA                 COPY statuses (id, uri, text, created_at, updated_at, in_reply_to_id, reblog_of_id, url, sensitive, visibility, spoiler_text, reply, favourites_count, reblogs_count, language, conversation_id, local, account_id, application_id, in_reply_to_account_id) FROM stdin;
    public       nolan    false    259   �       �          0    219055    statuses_tags 
   TABLE DATA               3   COPY statuses_tags (status_id, tag_id) FROM stdin;
    public       nolan    false    261   �       �          0    219058    stream_entries 
   TABLE DATA               m   COPY stream_entries (id, activity_id, activity_type, created_at, updated_at, hidden, account_id) FROM stdin;
    public       nolan    false    262   �       �          0    219067    subscriptions 
   TABLE DATA               �   COPY subscriptions (id, callback_url, secret, expires_at, confirmed, created_at, updated_at, last_successful_delivery_at, domain, account_id) FROM stdin;
    public       nolan    false    264   �       �          0    219077    tags 
   TABLE DATA               9   COPY tags (id, name, created_at, updated_at) FROM stdin;
    public       nolan    false    266   !      �          0    219086    users 
   TABLE DATA                 COPY users (id, email, created_at, updated_at, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, admin, confirmation_token, confirmed_at, confirmation_sent_at, unconfirmed_email, locale, encrypted_otp_secret, encrypted_otp_secret_iv, encrypted_otp_secret_salt, consumed_timestep, otp_required_for_login, last_emailed_at, otp_backup_codes, filtered_languages, account_id, disabled, moderator, invite_id) FROM stdin;
    public       nolan    false    268   4!      �          0    219102    web_push_subscriptions 
   TABLE DATA               k   COPY web_push_subscriptions (id, endpoint, key_p256dh, key_auth, data, created_at, updated_at) FROM stdin;
    public       nolan    false    270   $      �          0    219110    web_settings 
   TABLE DATA               J   COPY web_settings (id, data, created_at, updated_at, user_id) FROM stdin;
    public       nolan    false    272    $      &           0    0    account_domain_blocks_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('account_domain_blocks_id_seq', 1, false);
            public       nolan    false    197            '           0    0    account_moderation_notes_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('account_moderation_notes_id_seq', 1, false);
            public       nolan    false    199            (           0    0    accounts_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('accounts_id_seq', 5, true);
            public       nolan    false    201            )           0    0    admin_action_logs_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('admin_action_logs_id_seq', 3, true);
            public       nolan    false    203            *           0    0    blocks_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('blocks_id_seq', 1, false);
            public       nolan    false    206            +           0    0    conversation_mutes_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('conversation_mutes_id_seq', 1, false);
            public       nolan    false    208            ,           0    0    conversations_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('conversations_id_seq', 1, false);
            public       nolan    false    210            -           0    0    custom_emojis_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('custom_emojis_id_seq', 3, true);
            public       nolan    false    212            .           0    0    domain_blocks_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('domain_blocks_id_seq', 1, false);
            public       nolan    false    214            /           0    0    email_domain_blocks_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('email_domain_blocks_id_seq', 1, false);
            public       nolan    false    216            0           0    0    favourites_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('favourites_id_seq', 1, false);
            public       nolan    false    218            1           0    0    follow_requests_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('follow_requests_id_seq', 1, false);
            public       nolan    false    220            2           0    0    follows_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('follows_id_seq', 4, true);
            public       nolan    false    222            3           0    0    imports_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('imports_id_seq', 1, false);
            public       nolan    false    224            4           0    0    invites_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('invites_id_seq', 1, false);
            public       nolan    false    226            5           0    0    list_accounts_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('list_accounts_id_seq', 1, false);
            public       nolan    false    228            6           0    0    lists_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('lists_id_seq', 1, false);
            public       nolan    false    230            7           0    0    media_attachments_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('media_attachments_id_seq', 1, false);
            public       nolan    false    232            8           0    0    mentions_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('mentions_id_seq', 1, false);
            public       nolan    false    234            9           0    0    mutes_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('mutes_id_seq', 1, false);
            public       nolan    false    236            :           0    0    notifications_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('notifications_id_seq', 4, true);
            public       nolan    false    238            ;           0    0    oauth_access_grants_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('oauth_access_grants_id_seq', 1, false);
            public       nolan    false    240            <           0    0    oauth_access_tokens_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('oauth_access_tokens_id_seq', 6, true);
            public       nolan    false    242            =           0    0    oauth_applications_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('oauth_applications_id_seq', 1, true);
            public       nolan    false    244            >           0    0    preview_cards_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('preview_cards_id_seq', 1, false);
            public       nolan    false    246            ?           0    0    reports_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('reports_id_seq', 1, false);
            public       nolan    false    249            @           0    0    session_activations_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('session_activations_id_seq', 6, true);
            public       nolan    false    252            A           0    0    settings_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('settings_id_seq', 1, false);
            public       nolan    false    254            B           0    0    site_uploads_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('site_uploads_id_seq', 1, false);
            public       nolan    false    256            C           0    0    status_pins_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('status_pins_id_seq', 1, false);
            public       nolan    false    258            D           0    0    statuses_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('statuses_id_seq', 1, false);
            public       nolan    false    260            E           0    0    stream_entries_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('stream_entries_id_seq', 1, false);
            public       nolan    false    263            F           0    0    subscriptions_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('subscriptions_id_seq', 1, false);
            public       nolan    false    265            G           0    0    tags_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('tags_id_seq', 1, false);
            public       nolan    false    267            H           0    0    users_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('users_id_seq', 5, true);
            public       nolan    false    269            I           0    0    web_push_subscriptions_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('web_push_subscriptions_id_seq', 1, false);
            public       nolan    false    271            J           0    0    web_settings_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('web_settings_id_seq', 3, true);
            public       nolan    false    273            n
           2606    219159 0   account_domain_blocks account_domain_blocks_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY account_domain_blocks
    ADD CONSTRAINT account_domain_blocks_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.account_domain_blocks DROP CONSTRAINT account_domain_blocks_pkey;
       public         nolan    false    196            q
           2606    219161 6   account_moderation_notes account_moderation_notes_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT account_moderation_notes_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT account_moderation_notes_pkey;
       public         nolan    false    198            u
           2606    219163    accounts accounts_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.accounts DROP CONSTRAINT accounts_pkey;
       public         nolan    false    200            |
           2606    219165 (   admin_action_logs admin_action_logs_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY admin_action_logs
    ADD CONSTRAINT admin_action_logs_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.admin_action_logs DROP CONSTRAINT admin_action_logs_pkey;
       public         nolan    false    202            �
           2606    219167 .   ar_internal_metadata ar_internal_metadata_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);
 X   ALTER TABLE ONLY public.ar_internal_metadata DROP CONSTRAINT ar_internal_metadata_pkey;
       public         nolan    false    204            �
           2606    219169    blocks blocks_pkey 
   CONSTRAINT     I   ALTER TABLE ONLY blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.blocks DROP CONSTRAINT blocks_pkey;
       public         nolan    false    205            �
           2606    219171 *   conversation_mutes conversation_mutes_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT conversation_mutes_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT conversation_mutes_pkey;
       public         nolan    false    207            �
           2606    219173     conversations conversations_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.conversations DROP CONSTRAINT conversations_pkey;
       public         nolan    false    209            �
           2606    219175     custom_emojis custom_emojis_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY custom_emojis
    ADD CONSTRAINT custom_emojis_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.custom_emojis DROP CONSTRAINT custom_emojis_pkey;
       public         nolan    false    211            �
           2606    219177     domain_blocks domain_blocks_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY domain_blocks
    ADD CONSTRAINT domain_blocks_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.domain_blocks DROP CONSTRAINT domain_blocks_pkey;
       public         nolan    false    213            �
           2606    219179 ,   email_domain_blocks email_domain_blocks_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY email_domain_blocks
    ADD CONSTRAINT email_domain_blocks_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.email_domain_blocks DROP CONSTRAINT email_domain_blocks_pkey;
       public         nolan    false    215            �
           2606    219181    favourites favourites_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY favourites
    ADD CONSTRAINT favourites_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.favourites DROP CONSTRAINT favourites_pkey;
       public         nolan    false    217            �
           2606    219183 $   follow_requests follow_requests_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT follow_requests_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT follow_requests_pkey;
       public         nolan    false    219            �
           2606    219185    follows follows_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.follows DROP CONSTRAINT follows_pkey;
       public         nolan    false    221            �
           2606    219187    imports imports_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY imports
    ADD CONSTRAINT imports_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.imports DROP CONSTRAINT imports_pkey;
       public         nolan    false    223            �
           2606    219189    invites invites_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.invites DROP CONSTRAINT invites_pkey;
       public         nolan    false    225            �
           2606    219191     list_accounts list_accounts_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT list_accounts_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT list_accounts_pkey;
       public         nolan    false    227            �
           2606    219193    lists lists_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.lists DROP CONSTRAINT lists_pkey;
       public         nolan    false    229            �
           2606    219195 (   media_attachments media_attachments_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT media_attachments_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT media_attachments_pkey;
       public         nolan    false    231            �
           2606    219197    mentions mentions_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.mentions DROP CONSTRAINT mentions_pkey;
       public         nolan    false    233            �
           2606    219199    mutes mutes_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY mutes
    ADD CONSTRAINT mutes_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.mutes DROP CONSTRAINT mutes_pkey;
       public         nolan    false    235            �
           2606    219201     notifications notifications_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.notifications DROP CONSTRAINT notifications_pkey;
       public         nolan    false    237            �
           2606    219203 ,   oauth_access_grants oauth_access_grants_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT oauth_access_grants_pkey;
       public         nolan    false    239            �
           2606    219205 ,   oauth_access_tokens oauth_access_tokens_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT oauth_access_tokens_pkey;
       public         nolan    false    241            �
           2606    219207 *   oauth_applications oauth_applications_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.oauth_applications DROP CONSTRAINT oauth_applications_pkey;
       public         nolan    false    243            �
           2606    219209     preview_cards preview_cards_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY preview_cards
    ADD CONSTRAINT preview_cards_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.preview_cards DROP CONSTRAINT preview_cards_pkey;
       public         nolan    false    245            �
           2606    219211    reports reports_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.reports DROP CONSTRAINT reports_pkey;
       public         nolan    false    248            �
           2606    219213 (   schema_migrations schema_migrations_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
 R   ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
       public         nolan    false    250            �
           2606    219215 ,   session_activations session_activations_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT session_activations_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT session_activations_pkey;
       public         nolan    false    251            �
           2606    219217    settings settings_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pkey;
       public         nolan    false    253            �
           2606    219219    site_uploads site_uploads_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY site_uploads
    ADD CONSTRAINT site_uploads_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.site_uploads DROP CONSTRAINT site_uploads_pkey;
       public         nolan    false    255            �
           2606    219221    status_pins status_pins_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT status_pins_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT status_pins_pkey;
       public         nolan    false    257            �
           2606    219223    statuses statuses_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT statuses_pkey;
       public         nolan    false    259            �
           2606    219225 "   stream_entries stream_entries_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY stream_entries
    ADD CONSTRAINT stream_entries_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.stream_entries DROP CONSTRAINT stream_entries_pkey;
       public         nolan    false    262            �
           2606    219227     subscriptions subscriptions_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT subscriptions_pkey;
       public         nolan    false    264            �
           2606    219229    tags tags_pkey 
   CONSTRAINT     E   ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.tags DROP CONSTRAINT tags_pkey;
       public         nolan    false    266            �
           2606    219231    users users_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public         nolan    false    268            �
           2606    219233 2   web_push_subscriptions web_push_subscriptions_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY web_push_subscriptions
    ADD CONSTRAINT web_push_subscriptions_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.web_push_subscriptions DROP CONSTRAINT web_push_subscriptions_pkey;
       public         nolan    false    270            �
           2606    219235    web_settings web_settings_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY web_settings
    ADD CONSTRAINT web_settings_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.web_settings DROP CONSTRAINT web_settings_pkey;
       public         nolan    false    272            �
           1259    219236    account_activity    INDEX     l   CREATE UNIQUE INDEX account_activity ON notifications USING btree (account_id, activity_id, activity_type);
 $   DROP INDEX public.account_activity;
       public         nolan    false    237    237    237            �
           1259    219237    hashtag_search_index    INDEX     ^   CREATE INDEX hashtag_search_index ON tags USING btree (lower((name)::text) text_pattern_ops);
 (   DROP INDEX public.hashtag_search_index;
       public         nolan    false    266    266            o
           1259    219238 4   index_account_domain_blocks_on_account_id_and_domain    INDEX     �   CREATE UNIQUE INDEX index_account_domain_blocks_on_account_id_and_domain ON account_domain_blocks USING btree (account_id, domain);
 H   DROP INDEX public.index_account_domain_blocks_on_account_id_and_domain;
       public         nolan    false    196    196            r
           1259    219239 ,   index_account_moderation_notes_on_account_id    INDEX     p   CREATE INDEX index_account_moderation_notes_on_account_id ON account_moderation_notes USING btree (account_id);
 @   DROP INDEX public.index_account_moderation_notes_on_account_id;
       public         nolan    false    198            s
           1259    219240 3   index_account_moderation_notes_on_target_account_id    INDEX     ~   CREATE INDEX index_account_moderation_notes_on_target_account_id ON account_moderation_notes USING btree (target_account_id);
 G   DROP INDEX public.index_account_moderation_notes_on_target_account_id;
       public         nolan    false    198            v
           1259    219241    index_accounts_on_uri    INDEX     B   CREATE INDEX index_accounts_on_uri ON accounts USING btree (uri);
 )   DROP INDEX public.index_accounts_on_uri;
       public         nolan    false    200            w
           1259    219242    index_accounts_on_url    INDEX     B   CREATE INDEX index_accounts_on_url ON accounts USING btree (url);
 )   DROP INDEX public.index_accounts_on_url;
       public         nolan    false    200            x
           1259    219243 %   index_accounts_on_username_and_domain    INDEX     f   CREATE UNIQUE INDEX index_accounts_on_username_and_domain ON accounts USING btree (username, domain);
 9   DROP INDEX public.index_accounts_on_username_and_domain;
       public         nolan    false    200    200            y
           1259    219244 +   index_accounts_on_username_and_domain_lower    INDEX     �   CREATE INDEX index_accounts_on_username_and_domain_lower ON accounts USING btree (lower((username)::text), lower((domain)::text));
 ?   DROP INDEX public.index_accounts_on_username_and_domain_lower;
       public         nolan    false    200    200    200            }
           1259    219245 %   index_admin_action_logs_on_account_id    INDEX     b   CREATE INDEX index_admin_action_logs_on_account_id ON admin_action_logs USING btree (account_id);
 9   DROP INDEX public.index_admin_action_logs_on_account_id;
       public         nolan    false    202            ~
           1259    219246 4   index_admin_action_logs_on_target_type_and_target_id    INDEX     }   CREATE INDEX index_admin_action_logs_on_target_type_and_target_id ON admin_action_logs USING btree (target_type, target_id);
 H   DROP INDEX public.index_admin_action_logs_on_target_type_and_target_id;
       public         nolan    false    202    202            �
           1259    219247 0   index_blocks_on_account_id_and_target_account_id    INDEX     |   CREATE UNIQUE INDEX index_blocks_on_account_id_and_target_account_id ON blocks USING btree (account_id, target_account_id);
 D   DROP INDEX public.index_blocks_on_account_id_and_target_account_id;
       public         nolan    false    205    205            �
           1259    219248 :   index_conversation_mutes_on_account_id_and_conversation_id    INDEX     �   CREATE UNIQUE INDEX index_conversation_mutes_on_account_id_and_conversation_id ON conversation_mutes USING btree (account_id, conversation_id);
 N   DROP INDEX public.index_conversation_mutes_on_account_id_and_conversation_id;
       public         nolan    false    207    207            �
           1259    219249    index_conversations_on_uri    INDEX     S   CREATE UNIQUE INDEX index_conversations_on_uri ON conversations USING btree (uri);
 .   DROP INDEX public.index_conversations_on_uri;
       public         nolan    false    209            �
           1259    219250 +   index_custom_emojis_on_shortcode_and_domain    INDEX     r   CREATE UNIQUE INDEX index_custom_emojis_on_shortcode_and_domain ON custom_emojis USING btree (shortcode, domain);
 ?   DROP INDEX public.index_custom_emojis_on_shortcode_and_domain;
       public         nolan    false    211    211            �
           1259    219251    index_domain_blocks_on_domain    INDEX     Y   CREATE UNIQUE INDEX index_domain_blocks_on_domain ON domain_blocks USING btree (domain);
 1   DROP INDEX public.index_domain_blocks_on_domain;
       public         nolan    false    213            �
           1259    219252 #   index_email_domain_blocks_on_domain    INDEX     e   CREATE UNIQUE INDEX index_email_domain_blocks_on_domain ON email_domain_blocks USING btree (domain);
 7   DROP INDEX public.index_email_domain_blocks_on_domain;
       public         nolan    false    215            �
           1259    219253 %   index_favourites_on_account_id_and_id    INDEX     _   CREATE INDEX index_favourites_on_account_id_and_id ON favourites USING btree (account_id, id);
 9   DROP INDEX public.index_favourites_on_account_id_and_id;
       public         nolan    false    217    217            �
           1259    219254 ,   index_favourites_on_account_id_and_status_id    INDEX     t   CREATE UNIQUE INDEX index_favourites_on_account_id_and_status_id ON favourites USING btree (account_id, status_id);
 @   DROP INDEX public.index_favourites_on_account_id_and_status_id;
       public         nolan    false    217    217            �
           1259    219255    index_favourites_on_status_id    INDEX     R   CREATE INDEX index_favourites_on_status_id ON favourites USING btree (status_id);
 1   DROP INDEX public.index_favourites_on_status_id;
       public         nolan    false    217            �
           1259    219256 9   index_follow_requests_on_account_id_and_target_account_id    INDEX     �   CREATE UNIQUE INDEX index_follow_requests_on_account_id_and_target_account_id ON follow_requests USING btree (account_id, target_account_id);
 M   DROP INDEX public.index_follow_requests_on_account_id_and_target_account_id;
       public         nolan    false    219    219            �
           1259    219257 1   index_follows_on_account_id_and_target_account_id    INDEX     ~   CREATE UNIQUE INDEX index_follows_on_account_id_and_target_account_id ON follows USING btree (account_id, target_account_id);
 E   DROP INDEX public.index_follows_on_account_id_and_target_account_id;
       public         nolan    false    221    221            �
           1259    219258    index_invites_on_code    INDEX     I   CREATE UNIQUE INDEX index_invites_on_code ON invites USING btree (code);
 )   DROP INDEX public.index_invites_on_code;
       public         nolan    false    225            �
           1259    219259    index_invites_on_user_id    INDEX     H   CREATE INDEX index_invites_on_user_id ON invites USING btree (user_id);
 ,   DROP INDEX public.index_invites_on_user_id;
       public         nolan    false    225            �
           1259    219260 -   index_list_accounts_on_account_id_and_list_id    INDEX     v   CREATE UNIQUE INDEX index_list_accounts_on_account_id_and_list_id ON list_accounts USING btree (account_id, list_id);
 A   DROP INDEX public.index_list_accounts_on_account_id_and_list_id;
       public         nolan    false    227    227            �
           1259    219261     index_list_accounts_on_follow_id    INDEX     X   CREATE INDEX index_list_accounts_on_follow_id ON list_accounts USING btree (follow_id);
 4   DROP INDEX public.index_list_accounts_on_follow_id;
       public         nolan    false    227            �
           1259    219262 -   index_list_accounts_on_list_id_and_account_id    INDEX     o   CREATE INDEX index_list_accounts_on_list_id_and_account_id ON list_accounts USING btree (list_id, account_id);
 A   DROP INDEX public.index_list_accounts_on_list_id_and_account_id;
       public         nolan    false    227    227            �
           1259    219263    index_lists_on_account_id    INDEX     J   CREATE INDEX index_lists_on_account_id ON lists USING btree (account_id);
 -   DROP INDEX public.index_lists_on_account_id;
       public         nolan    false    229            �
           1259    219264 %   index_media_attachments_on_account_id    INDEX     b   CREATE INDEX index_media_attachments_on_account_id ON media_attachments USING btree (account_id);
 9   DROP INDEX public.index_media_attachments_on_account_id;
       public         nolan    false    231            �
           1259    219265 $   index_media_attachments_on_shortcode    INDEX     g   CREATE UNIQUE INDEX index_media_attachments_on_shortcode ON media_attachments USING btree (shortcode);
 8   DROP INDEX public.index_media_attachments_on_shortcode;
       public         nolan    false    231            �
           1259    219266 $   index_media_attachments_on_status_id    INDEX     `   CREATE INDEX index_media_attachments_on_status_id ON media_attachments USING btree (status_id);
 8   DROP INDEX public.index_media_attachments_on_status_id;
       public         nolan    false    231            �
           1259    219267 *   index_mentions_on_account_id_and_status_id    INDEX     p   CREATE UNIQUE INDEX index_mentions_on_account_id_and_status_id ON mentions USING btree (account_id, status_id);
 >   DROP INDEX public.index_mentions_on_account_id_and_status_id;
       public         nolan    false    233    233            �
           1259    219268    index_mentions_on_status_id    INDEX     N   CREATE INDEX index_mentions_on_status_id ON mentions USING btree (status_id);
 /   DROP INDEX public.index_mentions_on_status_id;
       public         nolan    false    233            �
           1259    219269 /   index_mutes_on_account_id_and_target_account_id    INDEX     z   CREATE UNIQUE INDEX index_mutes_on_account_id_and_target_account_id ON mutes USING btree (account_id, target_account_id);
 C   DROP INDEX public.index_mutes_on_account_id_and_target_account_id;
       public         nolan    false    235    235            �
           1259    219270 (   index_notifications_on_account_id_and_id    INDEX     j   CREATE INDEX index_notifications_on_account_id_and_id ON notifications USING btree (account_id, id DESC);
 <   DROP INDEX public.index_notifications_on_account_id_and_id;
       public         nolan    false    237    237            �
           1259    219271 4   index_notifications_on_activity_id_and_activity_type    INDEX     }   CREATE INDEX index_notifications_on_activity_id_and_activity_type ON notifications USING btree (activity_id, activity_type);
 H   DROP INDEX public.index_notifications_on_activity_id_and_activity_type;
       public         nolan    false    237    237            �
           1259    219272 "   index_oauth_access_grants_on_token    INDEX     c   CREATE UNIQUE INDEX index_oauth_access_grants_on_token ON oauth_access_grants USING btree (token);
 6   DROP INDEX public.index_oauth_access_grants_on_token;
       public         nolan    false    239            �
           1259    219273 *   index_oauth_access_tokens_on_refresh_token    INDEX     s   CREATE UNIQUE INDEX index_oauth_access_tokens_on_refresh_token ON oauth_access_tokens USING btree (refresh_token);
 >   DROP INDEX public.index_oauth_access_tokens_on_refresh_token;
       public         nolan    false    241            �
           1259    219274 .   index_oauth_access_tokens_on_resource_owner_id    INDEX     t   CREATE INDEX index_oauth_access_tokens_on_resource_owner_id ON oauth_access_tokens USING btree (resource_owner_id);
 B   DROP INDEX public.index_oauth_access_tokens_on_resource_owner_id;
       public         nolan    false    241            �
           1259    219275 "   index_oauth_access_tokens_on_token    INDEX     c   CREATE UNIQUE INDEX index_oauth_access_tokens_on_token ON oauth_access_tokens USING btree (token);
 6   DROP INDEX public.index_oauth_access_tokens_on_token;
       public         nolan    false    241            �
           1259    219276 3   index_oauth_applications_on_owner_id_and_owner_type    INDEX     {   CREATE INDEX index_oauth_applications_on_owner_id_and_owner_type ON oauth_applications USING btree (owner_id, owner_type);
 G   DROP INDEX public.index_oauth_applications_on_owner_id_and_owner_type;
       public         nolan    false    243    243            �
           1259    219277    index_oauth_applications_on_uid    INDEX     ]   CREATE UNIQUE INDEX index_oauth_applications_on_uid ON oauth_applications USING btree (uid);
 3   DROP INDEX public.index_oauth_applications_on_uid;
       public         nolan    false    243            �
           1259    219278    index_preview_cards_on_url    INDEX     S   CREATE UNIQUE INDEX index_preview_cards_on_url ON preview_cards USING btree (url);
 .   DROP INDEX public.index_preview_cards_on_url;
       public         nolan    false    245            �
           1259    219279 =   index_preview_cards_statuses_on_status_id_and_preview_card_id    INDEX     �   CREATE INDEX index_preview_cards_statuses_on_status_id_and_preview_card_id ON preview_cards_statuses USING btree (status_id, preview_card_id);
 Q   DROP INDEX public.index_preview_cards_statuses_on_status_id_and_preview_card_id;
       public         nolan    false    247    247            �
           1259    219280    index_reports_on_account_id    INDEX     N   CREATE INDEX index_reports_on_account_id ON reports USING btree (account_id);
 /   DROP INDEX public.index_reports_on_account_id;
       public         nolan    false    248            �
           1259    219281 "   index_reports_on_target_account_id    INDEX     \   CREATE INDEX index_reports_on_target_account_id ON reports USING btree (target_account_id);
 6   DROP INDEX public.index_reports_on_target_account_id;
       public         nolan    false    248            �
           1259    219282 '   index_session_activations_on_session_id    INDEX     m   CREATE UNIQUE INDEX index_session_activations_on_session_id ON session_activations USING btree (session_id);
 ;   DROP INDEX public.index_session_activations_on_session_id;
       public         nolan    false    251            �
           1259    219283 $   index_session_activations_on_user_id    INDEX     `   CREATE INDEX index_session_activations_on_user_id ON session_activations USING btree (user_id);
 8   DROP INDEX public.index_session_activations_on_user_id;
       public         nolan    false    251            �
           1259    219284 1   index_settings_on_thing_type_and_thing_id_and_var    INDEX     {   CREATE UNIQUE INDEX index_settings_on_thing_type_and_thing_id_and_var ON settings USING btree (thing_type, thing_id, var);
 E   DROP INDEX public.index_settings_on_thing_type_and_thing_id_and_var;
       public         nolan    false    253    253    253            �
           1259    219285    index_site_uploads_on_var    INDEX     Q   CREATE UNIQUE INDEX index_site_uploads_on_var ON site_uploads USING btree (var);
 -   DROP INDEX public.index_site_uploads_on_var;
       public         nolan    false    255            �
           1259    219286 -   index_status_pins_on_account_id_and_status_id    INDEX     v   CREATE UNIQUE INDEX index_status_pins_on_account_id_and_status_id ON status_pins USING btree (account_id, status_id);
 A   DROP INDEX public.index_status_pins_on_account_id_and_status_id;
       public         nolan    false    257    257            �
           1259    219287    index_statuses_20180106    INDEX     l   CREATE INDEX index_statuses_20180106 ON statuses USING btree (account_id, id DESC, visibility, updated_at);
 +   DROP INDEX public.index_statuses_20180106;
       public         nolan    false    259    259    259    259            �
           1259    219288 !   index_statuses_on_conversation_id    INDEX     Z   CREATE INDEX index_statuses_on_conversation_id ON statuses USING btree (conversation_id);
 5   DROP INDEX public.index_statuses_on_conversation_id;
       public         nolan    false    259            �
           1259    219289     index_statuses_on_in_reply_to_id    INDEX     X   CREATE INDEX index_statuses_on_in_reply_to_id ON statuses USING btree (in_reply_to_id);
 4   DROP INDEX public.index_statuses_on_in_reply_to_id;
       public         nolan    false    259            �
           1259    219290 -   index_statuses_on_reblog_of_id_and_account_id    INDEX     o   CREATE INDEX index_statuses_on_reblog_of_id_and_account_id ON statuses USING btree (reblog_of_id, account_id);
 A   DROP INDEX public.index_statuses_on_reblog_of_id_and_account_id;
       public         nolan    false    259    259            �
           1259    219291    index_statuses_on_uri    INDEX     I   CREATE UNIQUE INDEX index_statuses_on_uri ON statuses USING btree (uri);
 )   DROP INDEX public.index_statuses_on_uri;
       public         nolan    false    259            �
           1259    219292     index_statuses_tags_on_status_id    INDEX     X   CREATE INDEX index_statuses_tags_on_status_id ON statuses_tags USING btree (status_id);
 4   DROP INDEX public.index_statuses_tags_on_status_id;
       public         nolan    false    261            �
           1259    219293 +   index_statuses_tags_on_tag_id_and_status_id    INDEX     r   CREATE UNIQUE INDEX index_statuses_tags_on_tag_id_and_status_id ON statuses_tags USING btree (tag_id, status_id);
 ?   DROP INDEX public.index_statuses_tags_on_tag_id_and_status_id;
       public         nolan    false    261    261            �
           1259    219294 ;   index_stream_entries_on_account_id_and_activity_type_and_id    INDEX     �   CREATE INDEX index_stream_entries_on_account_id_and_activity_type_and_id ON stream_entries USING btree (account_id, activity_type, id);
 O   DROP INDEX public.index_stream_entries_on_account_id_and_activity_type_and_id;
       public         nolan    false    262    262    262            �
           1259    219295 5   index_stream_entries_on_activity_id_and_activity_type    INDEX        CREATE INDEX index_stream_entries_on_activity_id_and_activity_type ON stream_entries USING btree (activity_id, activity_type);
 I   DROP INDEX public.index_stream_entries_on_activity_id_and_activity_type;
       public         nolan    false    262    262            �
           1259    219296 2   index_subscriptions_on_account_id_and_callback_url    INDEX     �   CREATE UNIQUE INDEX index_subscriptions_on_account_id_and_callback_url ON subscriptions USING btree (account_id, callback_url);
 F   DROP INDEX public.index_subscriptions_on_account_id_and_callback_url;
       public         nolan    false    264    264            �
           1259    219297    index_tags_on_name    INDEX     C   CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);
 &   DROP INDEX public.index_tags_on_name;
       public         nolan    false    266            �
           1259    219298    index_users_on_account_id    INDEX     J   CREATE INDEX index_users_on_account_id ON users USING btree (account_id);
 -   DROP INDEX public.index_users_on_account_id;
       public         nolan    false    268            �
           1259    219299 !   index_users_on_confirmation_token    INDEX     a   CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);
 5   DROP INDEX public.index_users_on_confirmation_token;
       public         nolan    false    268            �
           1259    219300    index_users_on_email    INDEX     G   CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);
 (   DROP INDEX public.index_users_on_email;
       public         nolan    false    268            �
           1259    219301 !   index_users_on_filtered_languages    INDEX     X   CREATE INDEX index_users_on_filtered_languages ON users USING gin (filtered_languages);
 5   DROP INDEX public.index_users_on_filtered_languages;
       public         nolan    false    268            �
           1259    219302 #   index_users_on_reset_password_token    INDEX     e   CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);
 7   DROP INDEX public.index_users_on_reset_password_token;
       public         nolan    false    268            �
           1259    219303    index_web_settings_on_user_id    INDEX     Y   CREATE UNIQUE INDEX index_web_settings_on_user_id ON web_settings USING btree (user_id);
 1   DROP INDEX public.index_web_settings_on_user_id;
       public         nolan    false    272            z
           1259    219304    search_index    INDEX     C  CREATE INDEX search_index ON accounts USING gin ((((setweight(to_tsvector('simple'::regconfig, (display_name)::text), 'A'::"char") || setweight(to_tsvector('simple'::regconfig, (username)::text), 'B'::"char")) || setweight(to_tsvector('simple'::regconfig, (COALESCE(domain, ''::character varying))::text), 'C'::"char"))));
     DROP INDEX public.search_index;
       public         nolan    false    200    200    200    200            3           2606    219305    web_settings fk_11910667b2    FK CONSTRAINT     }   ALTER TABLE ONLY web_settings
    ADD CONSTRAINT fk_11910667b2 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.web_settings DROP CONSTRAINT fk_11910667b2;
       public       nolan    false    2810    272    268                        2606    219310 #   account_domain_blocks fk_206c6029bd    FK CONSTRAINT     �   ALTER TABLE ONLY account_domain_blocks
    ADD CONSTRAINT fk_206c6029bd FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.account_domain_blocks DROP CONSTRAINT fk_206c6029bd;
       public       nolan    false    2677    200    196                       2606    219315     conversation_mutes fk_225b4212bb    FK CONSTRAINT     �   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT fk_225b4212bb FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT fk_225b4212bb;
       public       nolan    false    207    200    2677            -           2606    219320    statuses_tags fk_3081861e21    FK CONSTRAINT     |   ALTER TABLE ONLY statuses_tags
    ADD CONSTRAINT fk_3081861e21 FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.statuses_tags DROP CONSTRAINT fk_3081861e21;
       public       nolan    false    261    266    2803                       2606    219325    follows fk_32ed1b5560    FK CONSTRAINT     ~   ALTER TABLE ONLY follows
    ADD CONSTRAINT fk_32ed1b5560 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.follows DROP CONSTRAINT fk_32ed1b5560;
       public       nolan    false    221    200    2677                       2606    219330 !   oauth_access_grants fk_34d54b0a33    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT fk_34d54b0a33 FOREIGN KEY (application_id) REFERENCES oauth_applications(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT fk_34d54b0a33;
       public       nolan    false    239    243    2760                       2606    219335    blocks fk_4269e03e65    FK CONSTRAINT     }   ALTER TABLE ONLY blocks
    ADD CONSTRAINT fk_4269e03e65 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.blocks DROP CONSTRAINT fk_4269e03e65;
       public       nolan    false    200    205    2677            "           2606    219340    reports fk_4b81f7522c    FK CONSTRAINT     ~   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_4b81f7522c FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_4b81f7522c;
       public       nolan    false    248    2677    200            1           2606    219345    users fk_50500f500d    FK CONSTRAINT     |   ALTER TABLE ONLY users
    ADD CONSTRAINT fk_50500f500d FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_50500f500d;
       public       nolan    false    268    2677    200            /           2606    219350    stream_entries fk_5659b17554    FK CONSTRAINT     �   ALTER TABLE ONLY stream_entries
    ADD CONSTRAINT fk_5659b17554 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.stream_entries DROP CONSTRAINT fk_5659b17554;
       public       nolan    false    2677    200    262            	           2606    219355    favourites fk_5eb6c2b873    FK CONSTRAINT     �   ALTER TABLE ONLY favourites
    ADD CONSTRAINT fk_5eb6c2b873 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.favourites DROP CONSTRAINT fk_5eb6c2b873;
       public       nolan    false    2677    217    200                       2606    219360 !   oauth_access_grants fk_63b044929b    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT fk_63b044929b FOREIGN KEY (resource_owner_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT fk_63b044929b;
       public       nolan    false    268    239    2810                       2606    219365    imports fk_6db1b6e408    FK CONSTRAINT     ~   ALTER TABLE ONLY imports
    ADD CONSTRAINT fk_6db1b6e408 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.imports DROP CONSTRAINT fk_6db1b6e408;
       public       nolan    false    223    200    2677                       2606    219370    follows fk_745ca29eac    FK CONSTRAINT     �   ALTER TABLE ONLY follows
    ADD CONSTRAINT fk_745ca29eac FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.follows DROP CONSTRAINT fk_745ca29eac;
       public       nolan    false    200    221    2677                       2606    219375    follow_requests fk_76d644b0e7    FK CONSTRAINT     �   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT fk_76d644b0e7 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT fk_76d644b0e7;
       public       nolan    false    219    200    2677                       2606    219380    follow_requests fk_9291ec025d    FK CONSTRAINT     �   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT fk_9291ec025d FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT fk_9291ec025d;
       public       nolan    false    219    200    2677                       2606    219385    blocks fk_9571bfabc1    FK CONSTRAINT     �   ALTER TABLE ONLY blocks
    ADD CONSTRAINT fk_9571bfabc1 FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.blocks DROP CONSTRAINT fk_9571bfabc1;
       public       nolan    false    200    205    2677            %           2606    219390 !   session_activations fk_957e5bda89    FK CONSTRAINT     �   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT fk_957e5bda89 FOREIGN KEY (access_token_id) REFERENCES oauth_access_tokens(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT fk_957e5bda89;
       public       nolan    false    251    241    2756                       2606    219395    media_attachments fk_96dd81e81b    FK CONSTRAINT     �   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT fk_96dd81e81b FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 I   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT fk_96dd81e81b;
       public       nolan    false    231    2677    200                       2606    219400    mentions fk_970d43f9d1    FK CONSTRAINT        ALTER TABLE ONLY mentions
    ADD CONSTRAINT fk_970d43f9d1 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.mentions DROP CONSTRAINT fk_970d43f9d1;
       public       nolan    false    200    233    2677            0           2606    219405    subscriptions fk_9847d1cbb5    FK CONSTRAINT     �   ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT fk_9847d1cbb5 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT fk_9847d1cbb5;
       public       nolan    false    2677    200    264            )           2606    219410    statuses fk_9bda1543f7    FK CONSTRAINT        ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_9bda1543f7 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_9bda1543f7;
       public       nolan    false    259    2677    200            !           2606    219415     oauth_applications fk_b0988c7c0a    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT fk_b0988c7c0a FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.oauth_applications DROP CONSTRAINT fk_b0988c7c0a;
       public       nolan    false    268    243    2810            
           2606    219420    favourites fk_b0e856845e    FK CONSTRAINT     �   ALTER TABLE ONLY favourites
    ADD CONSTRAINT fk_b0e856845e FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.favourites DROP CONSTRAINT fk_b0e856845e;
       public       nolan    false    2790    217    259                       2606    219425    mutes fk_b8d8daf315    FK CONSTRAINT     |   ALTER TABLE ONLY mutes
    ADD CONSTRAINT fk_b8d8daf315 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.mutes DROP CONSTRAINT fk_b8d8daf315;
       public       nolan    false    200    235    2677            #           2606    219430    reports fk_bca45b75fd    FK CONSTRAINT     �   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_bca45b75fd FOREIGN KEY (action_taken_by_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_bca45b75fd;
       public       nolan    false    200    248    2677                       2606    219435    notifications fk_c141c8ee55    FK CONSTRAINT     �   ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_c141c8ee55 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.notifications DROP CONSTRAINT fk_c141c8ee55;
       public       nolan    false    2677    200    237            *           2606    219440    statuses fk_c7fa917661    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_c7fa917661 FOREIGN KEY (in_reply_to_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_c7fa917661;
       public       nolan    false    200    259    2677            '           2606    219445    status_pins fk_d4cb435b62    FK CONSTRAINT     �   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT fk_d4cb435b62 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT fk_d4cb435b62;
       public       nolan    false    257    2677    200            &           2606    219450 !   session_activations fk_e5fda67334    FK CONSTRAINT     �   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT fk_e5fda67334 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT fk_e5fda67334;
       public       nolan    false    268    2810    251                       2606    219455 !   oauth_access_tokens fk_e84df68546    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT fk_e84df68546 FOREIGN KEY (resource_owner_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT fk_e84df68546;
       public       nolan    false    268    241    2810            $           2606    219460    reports fk_eb37af34f0    FK CONSTRAINT     �   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_eb37af34f0 FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_eb37af34f0;
       public       nolan    false    248    2677    200                       2606    219465    mutes fk_eecff219ea    FK CONSTRAINT     �   ALTER TABLE ONLY mutes
    ADD CONSTRAINT fk_eecff219ea FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.mutes DROP CONSTRAINT fk_eecff219ea;
       public       nolan    false    200    235    2677                        2606    219470 !   oauth_access_tokens fk_f5fc4c1ee3    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT fk_f5fc4c1ee3 FOREIGN KEY (application_id) REFERENCES oauth_applications(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT fk_f5fc4c1ee3;
       public       nolan    false    241    2760    243                       2606    219475    notifications fk_fbd6b0bf9e    FK CONSTRAINT     �   ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_fbd6b0bf9e FOREIGN KEY (from_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.notifications DROP CONSTRAINT fk_fbd6b0bf9e;
       public       nolan    false    200    2677    237                       2606    219480    accounts fk_rails_2320833084    FK CONSTRAINT     �   ALTER TABLE ONLY accounts
    ADD CONSTRAINT fk_rails_2320833084 FOREIGN KEY (moved_to_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 F   ALTER TABLE ONLY public.accounts DROP CONSTRAINT fk_rails_2320833084;
       public       nolan    false    2677    200    200            +           2606    219485    statuses fk_rails_256483a9ab    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_rails_256483a9ab FOREIGN KEY (reblog_of_id) REFERENCES statuses(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_rails_256483a9ab;
       public       nolan    false    259    259    2790                       2606    219490    lists fk_rails_3853b78dac    FK CONSTRAINT     �   ALTER TABLE ONLY lists
    ADD CONSTRAINT fk_rails_3853b78dac FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.lists DROP CONSTRAINT fk_rails_3853b78dac;
       public       nolan    false    200    2677    229                       2606    219495 %   media_attachments fk_rails_3ec0cfdd70    FK CONSTRAINT     �   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT fk_rails_3ec0cfdd70 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE SET NULL;
 O   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT fk_rails_3ec0cfdd70;
       public       nolan    false    259    2790    231                       2606    219500 ,   account_moderation_notes fk_rails_3f8b75089b    FK CONSTRAINT     �   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT fk_rails_3f8b75089b FOREIGN KEY (account_id) REFERENCES accounts(id);
 V   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT fk_rails_3f8b75089b;
       public       nolan    false    200    2677    198                       2606    219505 !   list_accounts fk_rails_40f9cc29f1    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_40f9cc29f1 FOREIGN KEY (follow_id) REFERENCES follows(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_40f9cc29f1;
       public       nolan    false    227    221    2716                       2606    219510    mentions fk_rails_59edbe2887    FK CONSTRAINT     �   ALTER TABLE ONLY mentions
    ADD CONSTRAINT fk_rails_59edbe2887 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.mentions DROP CONSTRAINT fk_rails_59edbe2887;
       public       nolan    false    2790    259    233                       2606    219515 &   conversation_mutes fk_rails_5ab139311f    FK CONSTRAINT     �   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT fk_rails_5ab139311f FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT fk_rails_5ab139311f;
       public       nolan    false    2696    209    207            (           2606    219520    status_pins fk_rails_65c05552f1    FK CONSTRAINT     �   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT fk_rails_65c05552f1 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT fk_rails_65c05552f1;
       public       nolan    false    257    259    2790                       2606    219525 !   list_accounts fk_rails_85fee9d6ab    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_85fee9d6ab FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_85fee9d6ab;
       public       nolan    false    2677    227    200            2           2606    219530    users fk_rails_8fb2a43e88    FK CONSTRAINT     �   ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_8fb2a43e88 FOREIGN KEY (invite_id) REFERENCES invites(id) ON DELETE SET NULL;
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_rails_8fb2a43e88;
       public       nolan    false    268    2723    225            ,           2606    219535    statuses fk_rails_94a6f70399    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_rails_94a6f70399 FOREIGN KEY (in_reply_to_id) REFERENCES statuses(id) ON DELETE SET NULL;
 F   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_rails_94a6f70399;
       public       nolan    false    259    259    2790                       2606    219540 %   admin_action_logs fk_rails_a7667297fa    FK CONSTRAINT     �   ALTER TABLE ONLY admin_action_logs
    ADD CONSTRAINT fk_rails_a7667297fa FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.admin_action_logs DROP CONSTRAINT fk_rails_a7667297fa;
       public       nolan    false    2677    200    202                       2606    219545 ,   account_moderation_notes fk_rails_dd62ed5ac3    FK CONSTRAINT     �   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT fk_rails_dd62ed5ac3 FOREIGN KEY (target_account_id) REFERENCES accounts(id);
 V   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT fk_rails_dd62ed5ac3;
       public       nolan    false    200    198    2677            .           2606    219550 !   statuses_tags fk_rails_df0fe11427    FK CONSTRAINT     �   ALTER TABLE ONLY statuses_tags
    ADD CONSTRAINT fk_rails_df0fe11427 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.statuses_tags DROP CONSTRAINT fk_rails_df0fe11427;
       public       nolan    false    2790    259    261                       2606    219555 !   list_accounts fk_rails_e54e356c88    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_e54e356c88 FOREIGN KEY (list_id) REFERENCES lists(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_e54e356c88;
       public       nolan    false    2731    229    227                       2606    219560    invites fk_rails_ff69dbb2ac    FK CONSTRAINT     ~   ALTER TABLE ONLY invites
    ADD CONSTRAINT fk_rails_ff69dbb2ac FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.invites DROP CONSTRAINT fk_rails_ff69dbb2ac;
       public       nolan    false    225    2810    268            �      x������ � �      �      x������ � �      �      x���׎���h��O����9��9G��aŜ����̏c�m0��(5�X�k������>��_��/������l�p��ˑ=���P����g��2߿e��U��y��ۡzy�/���j֡j�߂�'��	b���R��oϮ���'j�t��|�[�0L��a� ��Sn?ؠ>G��"���9�v�zvD�}������}x��G!�;°��x�"�^�6���Q�u��>�����-�oՏ%��C������#�e^����ӂI��b4}�w{ǞfH���Ϯ�]|�j��E�I0o��n:�\1ǶE8K���j��iPLTR'ؔɳ��M oM̍F���[)�؛#�w��4���d��i���O=z������"�gG�b�w��T�%af~r������Gm�q�H� �KD�`A��qmԷӳ;L^Yd�v ��Mu���EBk��!��ġփ��s˼|*��-B0mR�[���P1��͢W�����T����o��߱Ծ臕�¡B��f�h&�oB�-\sa5�t3�s�G�8f$v���W�Ft��������-i��M��J�j����I���j,�HL6��L�Z7}΂�B�Z=��ӵ��+Є�ʚ6�b�"*�`iKx��4�s�Z�r�5N+��aؠ� I���ñ��H�S^M��b��N��>��| Z3#ĐTi?(������D
qM.A\)����5Z6$C��"=��QF)�'�o&;FA�$ec���QV#�;z��B��c�@��&9L�{��;<?;�� �o~���E�O�:�7+�?��PY��{�O�K�y�}����N�n�t&���0�<r���(�d���3h�v�`ӹh" @�¹����U�k6ӝ�+φ�k�Az||N����K���N(�+�W�i"g����*W����;81>�%@o�l��r��]X�n�1��1C�H�	~���*z�	59߼|�h�]����T����	�d�;�qA=[2� �x����[���g�qp��ħ��E� �z�b7��Oo���2o���	V;�F�� 2�,������1�.�&���d�`��"���Uc���r����r��`��unt�W�#K��8W�&�
n��`��X��B�wJHm����ً�ſo��֫�L�t[���m����V�J"(H�w��q�2�Hs֣h<#f��đ[�8 ��y �1����YT��a'�?lB�Ӿr��s> �=Q�i�d���Ű҂���M�����E\�d�lF1�� �^����f�]lQ� s��9Rn�+��m��h2W�=�Z��ϳ�6����5�,��k�o	��m0�z,�R�6��H%\���E�?���?�׳��_ߡ׳��_ߡ׳��_ߡ׳��_ߡ׳��_ߡ�u�˯��ѿ��_�!�� �g�"�a�o0�+E�N|�t��|������^����ϓ�z�'�qY��k�`�E{� �1����� ��EW��#���t���*lϱc�J��\�C��?�T���t�")�TI��4Q�f{��V���V��}̰�S=P�2��Õ�ih��M�����c�<w��{`�w�
�D���H ��i/2A���=]�ȏL���XѺ*os~�) �-4U�`��q�;h��-� jԙ)˩��^1BWj��| `��L>���|wA0rD��X��8x�a�	�� "�4����V�,T��ّ!P�S	�� b~n���>ŉ���0~�k��هrA�d���س{u��V9�$�g�%�MS۹���ú����\4.�k���v�0q�[\�0�!�+����hk~\k�1�_��z8����tY��<`�E	M&���iB�ɒ�S9�,��>����Rljdъ�=,�DE͐!���ʺE9�W.dI-#�n2"G]�58�&3�ܳ�n�Y�T���VLݭ�4"��"�y����0}l��zq����W��7Ⱦ���}����F��)81�M�~���^�f̄<ĪT2� � �5]������m`|�\�6��Lb"'�E�>�7����6�N����]#y�4��ր$S7L6� o!c���IK��h5z�k�꽨�w��Y�0��u�럝מ�B���K�[�T�`h���[-P݉��"�e�^����h%���}��ggaؕR7?"�M:���2�P��zYw��HH"������v�&)���zph�/�srO>8���X�Y�8��G���VܾLeЌ��$b@�~lʧWN��:Ѽ�'�f�vꯠt�[ ��V��᣾0Z�������DȻ�96�x9C�6/��'{͢ �)�'4)?�Q��~,Vt�E/'a����a��}(n�����}%[�&�j6"AN�
��z�d�ˀN�-,��R��iXN(�,����;,�xH����5b�aI��6�O�����.�K�>y�4��g>��p�	o;Aȯ�(���pVE$�3����%��E��1�F��
��R!�컓�
eQ�%N�c��)��/+�JKoV�`����6�r�#E�D�s�!>	�;�t�ώڲ1V��u��&�Mś�_�	�$���z`w��f>�P%�k���W�J����S*d�1�:"k2��x7T�A����ȅ���' )� %�^���G�*0K��蓶�����,�m��{Q�S�ɗE}���*�b-tQ���>��`��+�}�`��+�}�`��}�����}Ű���/��]�ܿ�>�+Ja	�����ϯ�����Ͽ�@�_hZ�p���h���>J��fX۪a�/�nt�Dt�����s�z���0�=b,�9���D��ݑ/������!U��g�.���|��[��6��u�[�#BE�++����dz��0S�`6>Lj҄M���	���`�e0��P?R�E&�V�����G���ĝ)|@[S+���N���M!]�Bu~Ϻ�X�kf�~��|*�9��n/�FUK �d0�;K]N�0�S��*�����X�5ub.�������=%�c��k�KM�EHC�o��^��y�Zr�erC��%�GĠ���(�^� Kb����T��Rj�Ԁ��3�n�W쩾��C��E�������!ZX������#���#]E���(�m�����a�Me~�e��� �����u*�@;��m7���,oR	�h�2|O��G4�Ђ�$Su%W�\�Ts�#x��=F�*p!���r&$!u��I�0�}���,+B�n'}~#LY��jH��M�!�7�t4'2�+>ٽ��i��@���*��5�U�h�,�vd�٩w����'L��<>�p����l��@�#��n3L��\�(��щs�֯˪�;r�K��c������R��r��W����?����N��������L���Y�$�X���t��fo�����CTj3 ���)D�GR�����5������܌à���?c�%�$�	�O%� �H0�!a���x	\��xd>�HZW<�PhE@�n�����63!Q�*a�=o��}%M�8(��l���!Ȭޯ�9�K/�-"�֒o�ސK��R5z}��gk~:�S��p�;��l�g�]�k$Փs��C@NHc��X���������������Jǅ_�Ri�ltQ]�AA8�j�.�ݲ[	T4��^����ʰnan�=W|��,	?��W[q0���43ҫ��)8uu��3�ʋ��	���Ց.�Y��Z�b�&�\vT}���E�=l�=.u]�^��ٔ���8˔���N'���`��zUcE{0�[Ѱ~���h�.P�4��5A �g�e�,���<_'���k7�r�/lY�!���^���hPQ�ܰ�Y��k���J��d��w�^����]�Ӈ�!���Ybuo������c�z����dT5�n'�����;XDn��k�V҃Xi����ע��g���Z��k+Q��QR��/���L0T�5���d��͚� �������/��]�þC�����a�!�C_0�;{v_1�;�*�ρ~�ί�����]#(�[���G��? �
  �y>��nU_vm�����~������~��4��x�{�u���4n>����s�G���?�|u����Z����da�$�����ט�1��T�!�*Ǔz��<W��O!���Bɣ{v�� �u�K
��M���&�X�XG�Z y�����v+�S�n;wk��C��)5 ��%s��Ͳ�<��X��Ի���e�4v'��|�<�!r�!��^ӫ�c�b8�Дϣ�r�h���u6Ӷmw��ZhA P��Xv��L�w���̍����^��d���$[ނV�Tfvɱ(~@TIt�!@s΋�ő$Hd������<�>;b���]$���s' ""^�+ޣH����j�ٜ����Y^��~Dl��(�UgM0vm{�o-�U�L���^0�r���T��^�{�;�����M&3N�7�-���Nx߰O%<XK��)�����yuP<�[�~��;�'����
Du�d���x���̃,���$�Z�<��J2@/���Ҵ���S�����C��%MK�ha6��T�l$Z~�����99~�"��q(Ws��p�Ϯ�Vl�x�δ��%\~륥���U+eB�J�#��d·���tV	�q�ܕ�������_I��ӕ�?��zG�H�~f���U?1�*�]ߛ�d�k����4.!2����Ϋ���[��;���zW3�.�+�V��	 ���Cs`��Z����'Vg@d\I̟���
�}�M�Ie{��Ě���"I^�w`�V�8��*U��>��u�|Lq���nn��T켮�Tڎ�.�(p��྇�m�a�k ��y��W�;9��I[�׉oS�ޏ85�]�k5?��ޙ��[��m���vB+��n�E�I<;Ai���B#��c@�ʅʓ�4,\i�ޯ�����V�s�q#��N���#	$�A��i�H�-'��Խ�?
�������N�!o�a7~��Q����KL�\���u��m�R�
o����Q�D�t.��,$b�MU�T@c���R�#�7��vWu�(x0�O0lA��QK���X�p�LEj �Ӱy	⩁]�`z����j�qr@�9��Zv��yH�3��5��9$<����%w��Z�A�R��[h��T�6e�l�%|,M��cGt�!��;|�����1��ku�(nF�O!DE�1["6>�+�l-=>��������YR.K��E2?<����g;�����W=fB�y5Ă�������Ԏ�n�w�A@�i{@pd^27��0���(�L� ���PM������<�[�!�8�Ӱvㄧ�z�tj���W����/��]�������}�`��+�}�`��`�wve�_T+�D�!�Aԯ�`8�U����gm���(���>c�G�d�z���W��[�UUz*�pW���J{d�E:~���4��f�ې!w���0����,�V��)-َ��g�> ��
aY1��}:��izңQ�q�s؍8ng���S`��IQm�}�>$bp5�x��x�A����k���W�AG��]u��xE�'/�M:)GД�juI���މ��T��U.Us؀������b���3D�?Z{,B\�3���;�c�����1�YB	=:K1�+����^v��ՓO�jf.��]�%�n ��t�v[I�o�0�mH��s��ŭ�ħ���WU�����)lE-�c#"����<�3�@6j�6xL�ؼ{_�S�����f_�&*.G{	
Jl^jr����M)��v@��9{ȼ���Q:��{qY$�1z��;�w��v�gwډ�PH�{�7FY�8�H�U��=)���?���8O��Z�ڌ�m��!ѧ��.���H�9y`���T-L�JX���;h9�y�8�� ����V����^̲�}�F�q�Q���1B^�R3��b����VΈ����h��xJ0ږ��BiE�"��A�)e��+���ݫ���]<~�o��qk��ݽJ�8�{��hiN���i�Fܕ�Jb��8�H��p���Z�#rK<��;Wx���|�{}�+T�h�\e+F�����c[��fs��c��`*5����.	8�j!����!|�{�:M���l��?T���C⚟c<]yg�3ۀ{��] A`ۡ�
�P�`�A0����r{P�7�%Z���/櫐�Bs;;Y�u� � cu.�x�i��B����/=���p�8�����.̥�3��C�˵+P{��\�}���IU�1c�pf9�ߨ���Hp���W!_��IP���M��ē(�V�J������a������I0&	X�/�Nz�(&8`>���'~���~>�b��js$����_�"ǟ��YcZ��»�C-H�r�(8,]O�$D�a~�vw'y���(cہ񗵘����U��:�&�m$ve���pt�xolь��>ʸi�<�w+��+K�v�W1t�������I�a{�Ok�ԕ'�Ǒ�?��hMΏ$�?>w�ϩ�:�v����z$����0��)Hm�-��&�@�2�U�VS�����2�v�t*!���v�D��~މ��b�B�pZL�F�(vw��M?�Te��r��ҥ�#�Y��]9Ukf��|UDD�������#z]���C�����9��C�g���C�˜���w�u�����~~C���RC�_!����T���{���o��������Hܔk      �   �  x�ݔ�J�@����Xo������;�@E�@�a�[�ݐl}z'-���*�v��?3߆Mؤ�T���f�mn���}?5�������Ε�R��-�����l�k#	���EeϺV�ɛ-QК�u���)�2�ޢb�n��ս��cT$���V��r'�E7�S[,T��u������Iy�������BWJr��L�|�H�eQ�\PJ��(�����׽	Y�y������rz\�V�<�0�5�D�ю�+��aH͏656��q�������=��ޜ�S�ux��co�רʹ�Z]��N�X3�7� J!>���~<�O�O�^�㉢��1��D'HF�p��ߠsib*D���\�5��)��	:���6G�D͉�N��N�@:��[�Z8�p"������8W,�H��4�<�!{�M      �   >   x�K�+�,���M�+�LI-K��/ ��-t�u���L�L����MM-q�p��qqq �      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x�}�Y
�0E��Ut�o�d����Ji��Ɩ� ���=<�k��vy��e5��xm�kB��
�{A����8���3l�9C�u2�"��s�HygQ#�8 (r��E���g(K�wx���C��G0>�*N�0��f��^F١QR��]�      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   \   x�}˱�0�:�����q<c��i("R�;)�%*�����=�0�m*Rn�+1o1���y//��K:o�Hr� ��l�W#���-�      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   j   x�}̱�0Dњ����%R� �"#p���>���=�C �}]�W����y���atFbE*���^�W�/��4�G+�4m��&cCM���LrE��S�6o7m      �      x������ � �      �   @  x�u�Kj%1E�U�x�C���Ed�Ȗ�@ 4d�����=Wx��4��X ܣ[�(�6%x:��9=5�*�C�#�8>��O�7�7��%|�=�@�������������{��g;��kN ��L�h�� C!��!m"��%tR[�Η�%��:�-O:{Z�]�-�@_QR�"��ո��+���'AGXS;@{	���骬�����;'�S����bs��##���읅e�N��F�G���򴝜�N����9����{xL�k�����EK5�Rp�5S��g8��y�څ��vf�[����<�q�      �   �   x�}�Mj�0@�s�\`�d�G�!f��ld[j�B�\���o��0|XT�D��6����Q�$�;#�̵�a�̬���N��h�����8��6M*�����I|dMs�N��t�$�B4�j�}|���ޮ϶���jq���=�s���i���~��7���eh�7����3<�-�mY�^�A�      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x�U�[��0D��bF<m����:�p\N��n�t\@ALt��s������墩�N����|q�M����
'�[>?)����=�+��	�7r�?7�C
�]�T��E:��Oմ�,�O���\�s8<cS]*��eC3��P�{S<�E����#�e�� �l.'�SUd`̰A��!N,5Ym"��sX%t�)Nl�É�ųSX`���v��7���#..G��͒�ŕ�O���qӼ��͋�u�G�մ�|jmCa�C����߃�o�zJ�ZQ>/B	��~��EǓ�F����\���َ}Rh�n0#A�i9��+���з������#��;G���-������0��F����`�u#�(�#)'#Go�4a���A�>��oF�����A�cs�E���h��,읺�V�$�=�Ԍ�I� ���y�BnGS�"�/cd�-gSzn5RfoB�]3�� $�[�3\o��D>l��c�Ş�[�^�ױ=��� <��X��B]�'%�g�����G��83�������c�+qh�W/����ȵ'h���S����C�Z|�[�����P�2X@iĩ��b(8ǲh�^���{��q��-��#�"�'c��u�{ђD����nG����T9��`��A�@���l���xF�|���������{��LJ��l*�^׍�{�Ut�-�O�bHw�e�ڔ�;z�W}��0�Y���nw�Ze��/���8��ګ�v������*K��      �   �  x����j1��)|�B�lY�'�RH�m)$�@��2d�	���>}���6Х��:���C�$R���<���EF��Xj���N�5��Sb�Ӂd�|��9uހ>٤<=햗�3}񴫳n��J�h��Lo��>X��5?,]�Z�>��u\�u�P���BE���ʪ�H,PF+8�"9Q�i ��q�H���[�8�C���������\��p9�:��8�'��l>����P�����vy�SC8����*�i;�z���6e3:U��j(9fW�O�%#!y���HO`��p(:�k�f$%��@�e"YD"�.��A�1�����PtFj�fl����k�X�\\�#�3���ң�/��������n�j���&.      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x���[o�@�k�{�[�9�Z��'�b�4��O "P�����mi�R� ���|�@�iN�k�q�U���Ɩ3��P�  (� ���F��T*9��	� ?&�Yw�-�ٛ/��E��kk�ʠ:GF�#r�nf��>Tƥ��������4�#{��_���I��Fq$��_�w�17�AÞ�v�����Q5S@���@F�mO�������_�$��Rl�Y��HCP��2v��r� UH�Ňt�z���A�6��
� *Lqy0&�䔗���xmf���o��"ː��] �Τ?¤Xy%�v��c�6��}���n,ļ�Q3S1��X0 �ud�"cŏ��&q���_P�S!$N���^�:�Bi��Ò��Ѩ�Zg��pE����Ҟ�F�Q(O��(��}v�8�4~��	;	�����D·F{����Q2S9B \tr�!$���Sd�Xw���4"UF$�'A�%i�)�L�T�뫦�:�`m��n�Iݍj�+������]�O�)�T�M{�v_|n�,���3i��ܓ�\0�2EÌ���b�@B��,'�:Qed�UG
�5(U!(��Ir���L�i�W'[��e�@|���r��I#�U���ج[U���7���R���:oœ�b�k+~��ٕ$�k��^�t���zV�a�/'AREK�����Y�)��������      �      x������ � �      �     x��MO�0@��@93Ȏ��xoj�=�V�[ۃ�!j6^�M)B��:P>*�������9�yQ��U����9V��0�^u���Or��\�UgyU����,_�O���˧w�������t:�_SSȱd��$��iS��M����x��D)w]��c%�3�C����V�O�����u�<���i�j5����vFO�a=��m���܍�i@_����:X~Y���q�I��Ip�`L�Q�k}�Q���jz�B����<|ĉ&2i&p��$���0�UH���-O�Nˣ�`���,ct�YA�d�5�&Z���z��@(fW�\���}�� �\I��weߎ�M��L^�mZD�R٬�X�M���^��p^b�58S�GM��ICr��$��|�_�&�H��P3�o b �,@c�FJ>�/e�;���{�4S�ʾe��MƂs�B�Ni�AK�%s��%ʲ�k�Ű�(�+� B�()!}��٢,-\C5��hA�����Nq�veiWڹT��JJ��s%=��?��~U*�#     