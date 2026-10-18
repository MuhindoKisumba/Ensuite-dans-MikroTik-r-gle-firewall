/* =====================================================
    INTÉGRATION FIREWALL MIKROTIK
===================================================== */

CREATE OR REPLACE FUNCTION block_ip_mikrotik(ip TEXT)
RETURNS VOID AS $$
DECLARE
    cmd TEXT;
BEGIN

    IF ip IS NULL THEN
        RETURN;
    END IF;

    cmd := format(
$$ssh admin@192.168.88.1 "/ip firewall address-list add list=BLACKLIST address=%s comment=AutoBlocked"$$,
        ip);

    EXECUTE 'COPY (SELECT 1) TO PROGRAM ' || quote_literal(cmd);

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
