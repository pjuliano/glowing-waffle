DECLARE
   a_ VARCHAR2(32000);
   b_ VARCHAR2(32000);   
   c_ VARCHAR2(32000);
   d_ VARCHAR2(32000);
BEGIN
    FOR cur IN 
        (
            SELECT
                            *
            FROM
                            cust_def_com_receiver
        )
    LOOP
        a_ := NULL;
        b_ := cur.objid;
        c_ := cur.objversion;
        d_ := 'DO';
        ifsapp.cust_def_com_receiver_api.remove__( a_ , b_ , c_ , d_ );
    END LOOP;
END;