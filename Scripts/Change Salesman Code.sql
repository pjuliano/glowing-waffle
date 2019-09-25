DECLARE
    a_ VARCHAR2(32000);
    b_ VARCHAR2(32000);
    c_ VARCHAR2(32000);
    d_ VARCHAR2(32000);
    e_ VARCHAR2(32000);
BEGIN
    FOR cur IN 
        (
            SELECT
                            su.cust_id,
                            su.new_salesman,
                            coce.objid,
                            coce.objversion
            FROM
                            cust_ord_customer_ent coce
                            JOIN kd_salesman_updates_ext su
                                ON coce.customer_id = su.cust_id
            WHERE
                            coce.salesman_code != su.new_salesman
        )
    LOOP
        a_ := NULL;
        b_ := cur.objid;
        c_ := cur.objversion;
        d_ := 'SALESMAN_CODE'||chr(31)||cur.new_salesman||chr(30);
        e_ := 'DO';
        Cust_Ord_Customer_Api.Modify__( a_ , b_ , c_ , d_ , e_ );
        COMMIT;
    END LOOP;
END;