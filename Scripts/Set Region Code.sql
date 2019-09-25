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
                        coca.customer_id,
                        srq.region,
                        coca.objid,
                        coca.objversion
        FROM
                        srrepquota srq
                        JOIN cust_ord_customer_ent coce
                            ON srq.repnumber = coce.salesman_code
                        JOIN cust_ord_customer_address_ent coca
                            ON coce.customer_id = coca.customer_id
                                AND coca.region_code != srq.region
        WHERE
                        kd_get_corporate_form(coca.customer_id) = 'DOMDIR'
                            AND srq.region != 'UNASSIGNED'
    )
    LOOP
        a_:= '';
        b_:= cur.objid;
        c_:= cur.objversion;
        d_:= 'REGION_CODE'||CHR(31)||cur.region||chr(30);
        e_:= 'DO';
        ifsapp.cust_ord_customer_address_api.modify__( a_ , b_ , c_ , d_ , e_ );
        COMMIT;
    END LOOP;
END;
