DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUMCAAIAAMj0dAAD'; --p1
   c_ VARCHAR2(32000) := '3'; --p2
   d_ VARCHAR2(32000) := 'DEFAULT_CURRENCY_RATE_TYPE'||chr(31)||'1'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    FOR cust IN 
        (
            SELECT
                            *
            FROM
                            IDENTITY_INVOICE_INFO
            WHERE
                            party_type = 'Customer'
                                AND def_currency = 'CAD'
                                AND default_currency_rate_type = '2'
        )
    LOOP
        a_ := NULL;
        b_ := cust.objid;
        c_ := cust.objversion;
        d_ := 'DEFAULT_CURRENCY_RATE_TYPE'||chr(31)||'1'||chr(30);
        e_ := 'DO';
        IFSAPP.IDENTITY_INVOICE_INFO_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
    END LOOP;
END;
