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
                coce.customer_id,
                ira.is_rep_id
FROM
                kd_inside_rep_assignments ira
                LEFT JOIN cust_ord_customer_ent coce
                    ON ira.rep_id = coce.salesman_code
WHERE
                NOT EXISTS
                    (
                        SELECT
                                        customer_id
                        FROM
                                        cust_def_com_receiver cdcr
                        WHERE
                                        coce.customer_id = cdcr.customer_no
                                            AND ira.is_rep_id = cdcr.commission_receiver
                    )
    )
    LOOP
        a_ := NULL;
        b_ := NULL;
        c_ := NULL;
        d_ := 'CUSTOMER_NO'||chr(31)||cur.customer_id||chr(30)||'COMMISSION_RECEIVER'||chr(31)||cur.is_rep_id||chr(30);
        e_ := 'DO';
        ifsapp.cust_def_com_receiver_api.new__( a_ , b_ , c_ , d_ , e_ );
        COMMIT;
    END LOOP;
END;
