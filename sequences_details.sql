CREATE FUNCTION sequences_details(OUT sequence_name text, OUT last_value bigint, OUT increment_by bigint, OUT max_value bigint, OUT min_value bigint, OUT cache_value bigint, OUT log_cnt bigint, OUT is_cycled boolean, OUT is_called boolean) RETURNS SETOF record
    AS $$
DECLARE
    ns TEXT;
    r TEXT;
BEGIN
    FOR ns, r IN
        SELECT pg_namespace.nspname, pg_class.relname FROM pg_class INNER JOIN pg_namespace ON pg_namespace.oid = pg_class.relnamespace WHERE pg_class.relkind = 'S'
    LOOP
        FOR sequence_name , last_value , increment_by , max_value , min_value , cache_value , log_cnt , is_cycled , is_called IN EXECUTE
            'SELECT sequence_name , last_value , increment_by , max_value , min_value , cache_value , log_cnt , is_cycled , is_called FROM ' || quote_ident(ns) || '.' || quote_ident(r)
        LOOP
            RETURN NEXT;
        END LOOP;
    END LOOP;
END;
$$
    LANGUAGE plpgsql;

