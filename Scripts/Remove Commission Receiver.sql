DECLARE
   a_ VARCHAR2(32000);
   b_ VARCHAR2(32000);   
   c_ VARCHAR2(32000);
   d_ VARCHAR2(32000);
BEGIN
    FOR cur IN 
        (
            SELECT
                            cdcr.customer_no,
                            cdcr.commission_receiver,
                            coce.salesman_code,
                            ira.is_rep_id,
                            cdcr.objid,
                            cdcr.objversion
            FROM
                            cust_def_com_receiver cdcr
                            LEFT JOIN cust_ord_customer_ent coce
                                ON cdcr.customer_no = coce.customer_id
                            LEFT JOIN kd_inside_rep_assignments ira
                                ON coce.salesman_code = ira.rep_id
            WHERE
                            cdcr.commission_receiver != ira.is_rep_id
        )
    LOOP
        a_ := NULL;
        b_ := cur.objid;
        c_ := cur.objversion;
        d_ := 'DO';
        ifsapp.cust_def_com_receiver_api.remove__( a_ , b_ , c_ , d_ );
    END LOOP;
END;