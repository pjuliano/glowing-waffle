DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUBgAAIAAM5FJABA'; --p1
   c_ VARCHAR2(32000) := '20140602075751'; --p2
   d_ VARCHAR2(32000) := 'DO'; --p3
BEGIN
    FOR lists IN
        (
            SELECT
                            *
            FROM 
                            customer_pricelist_ent
            WHERE
                            price_list_no LIKE 'CAN-%'
        )
    LOOP
        a_ := NULL;
        b_ := lists.objid;
        c_ := lists.objversion;
        d_ := 'DO';
        IFSAPP.CUSTOMER_PRICELIST_API.REMOVE__( a_ , b_ , c_ , d_ );
    END LOOP;
END;
