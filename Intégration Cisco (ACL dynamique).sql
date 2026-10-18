/* =====================================================
    INTÉGRATION FIREWALL CISCO (SSH + ACL)
===================================================== */

CREATE OR REPLACE FUNCTION block_ip_cisco(ip TEXT)
RETURNS VOID AS $$
DECLARE
    cmd TEXT;
BEGIN

    IF ip IS NULL THEN
        RETURN;
    END IF;

    cmd := format(
$$ssh admin@192.168.1.1 "
configure terminal
ip access-list extended BLOCKLIST
deny ip host %s any
end
write memory
"$$, ip);

    EXECUTE 'COPY (SELECT 1) TO PROGRAM ' || quote_literal(cmd);

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
