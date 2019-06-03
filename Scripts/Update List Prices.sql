DECLARE
   a_ VARCHAR2(32000) := ''; --p0
   b_ VARCHAR2(32000) := 'AAAUe3AAIAAMroxAAD'; --p1
   c_ VARCHAR2(32000) := '20180102131728'; --p2
   d_ VARCHAR2(32000) := 'LIST_PRICE'||chr(31)||'7710'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    FOR salesparts IN 
        (
            SELECT          kdm.part_no,
                            kdm.list_price,
                            sp.objid,
                            sp.objversion
              FROM          sales_part sp,
                            kd_data_migration kdm
             WHERE          sp.contract = '100'
               AND          kdm.part_no = sp.catalog_no    
        )
    LOOP
        a_ := '';
        b_ := salesparts.objid;
        c_ := salesparts.objversion;
        d_ := 'LIST_PRICE'||chr(31)||salesparts.list_price||chr(30);
        e_ := 'DO';
        IFSAPP.SALES_PART_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
    END LOOP;
END;
