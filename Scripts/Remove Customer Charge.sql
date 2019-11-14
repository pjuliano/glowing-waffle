DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUBAAARAACJYeAAe'; --p1
   c_ VARCHAR2(32000) := '20191008150358'; --p2
   d_ VARCHAR2(32000) := 'DO'; --p3
BEGIN
    FOR cust IN 
        (
            SELECT
                            objid,
                            objversion
            FROM
                            customer_charge_ent
            WHERE
                            customer_ID IN 
                                (
                                    SELECT
                                                    customer_id
                                    FROM
                                                    IDENTITY_INVOICE_INFO
                                    WHERE
                                                    party_type = 'Customer'
                                                        AND def_currency = 'CAD'
                                )
                                AND charge_type = 'FIE' --FIE, DOM2CONTIG
        )
    LOOP
        a_ := NULL;
        b_ := cust.objid;
        c_ := cust.objversion;
        d_ := 'DO';
        IFSAPP.CUSTOMER_CHARGE_API.REMOVE__( a_ , b_ , c_ , d_ );
    END LOOP;
END;
