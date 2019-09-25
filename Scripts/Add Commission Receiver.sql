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
                        srq.repnumber,
                        rep_name,
                        coce.customer_id,
                        ira.is_rep_id
        FROM
                        srrepquota srq
                        LEFT JOIN kd_inside_rep_assignments ira
                            ON srq.repnumber = ira.rep_id
                        JOIN cust_ord_customer_ent coce
                            ON srq.repnumber = coce.salesman_code
        WHERE
                        NOT EXISTS
                            (
                                SELECT
                                                cdcr.customer_no
                                FROM
                                                cust_def_com_receiver cdcr
                                WHERE
                                                cdcr.customer_no = coce.customer_id
                            ) 
                        AND repnumber != '999'
    )
    LOOP
        a_ := NULL;
        b_ := NULL;
        c_ := NULL;
        d_ := 'CUSTOMER_NO'||chr(31)||cur.customer_id||chr(30)||'COMMISSION_RECEIVER'||chr(31)||cur.is_rep_id||chr(30);
        e_ := 'DO';
        ifsapp.cust_def_com_receiver_api.new__( a_ , b_ , c_ , d_ , e_ );
    END LOOP;
END;
