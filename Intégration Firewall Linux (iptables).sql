/* =====================================================
    INTÉGRATION FIREWALL LINUX - IPTABLES
===================================================== */

-------------------------------------------------------
-- Fonction blocage IP niveau OS
-------------------------------------------------------

CREATE OR REPLACE FUNCTION block_ip_iptables(ip TEXT)
RETURNS VOID AS $$
DECLARE
    cmd TEXT;
BEGIN

    IF ip IS NULL THEN
        RETURN;
    END IF;

    cmd := format(
        'iptables -C INPUT -s %s -j DROP 2>/dev/null || iptables -A INPUT -s %s -j DROP',
        ip, ip
    );

    EXECUTE 'COPY (SELECT 1) TO PROGRAM ' || quote_literal(cmd);

END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-------------------------------------------------------
-- Exemple d'utilisation automatique
-------------------------------------------------------

-- Dans geo_security_check ou detect_and_block_user :
-- PERFORM block_ip_iptables(ip);
