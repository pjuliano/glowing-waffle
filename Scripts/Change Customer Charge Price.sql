DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUBAAARAACJY8AA+'; --p1
   c_ VARCHAR2(32000) := '20191008152552'; --p2
   d_ VARCHAR2(32000) := 'CHARGE_AMOUNT'||chr(31)||'25'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    FOR cust IN
        (
            SELECT
                            *
            FROM
                            customer_charge_ent
            WHERE
                            identity_invoice_info_api.get_def_currency('100',customer_id,'Customer') = 'CAD'
                                AND charge_type = 'FIP'
        )
    LOOP
        a_ := NULL;
        b_ := cust.objid;
        c_ := cust.objversion;
        d_ := 'CHARGE_AMOUNT'||chr(31)||'22.68'||chr(30);  --FIP 33.36, FIE 26.69, Dom2Contig 22.68
        e_ := 'DO';
        IFSAPP.CUSTOMER_CHARGE_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
    END LOOP;
END;
