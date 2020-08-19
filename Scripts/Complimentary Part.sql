DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := NULL; --p1
   c_ VARCHAR2(32000) := NULL; --p2
   d_ VARCHAR2(32000) := 'CONTRACT'||chr(31)||'100'||chr(30)||'PARENT_PART_NO'||chr(31)||'15414K'||chr(30)||'SUGGESTED_PART_NO'||chr(31)||'4409-0234'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    FOR parts IN 
        (
            SELECT
                            catalog_no
            FROM
                            sales_part
            WHERE
                            contract = '100'
                                AND catalog_no IN 
                                    (
                                        '15864K',
                                        '15865K',
                                        '15866K',
                                        '15867K',
                                        '15868K',
                                        '15869K',
                                        '15870K',
                                        '15871K',
                                        '15872K'
                                    )
        )
    LOOP
        a_ := NULL;
        b_ := NULL;
        c_ := NULL;
        d_ := 'CONTRACT'||chr(31)||'100'||chr(30)||'PARENT_PART_NO'||chr(31)||parts.catalog_no||chr(30)||'SUGGESTED_PART_NO'||chr(31)||'IFU-001'||chr(30);
        e_ := 'DO';
        IFSAPP.SUGGESTED_SALES_PART_API.NEW__( a_ , b_ , c_ , d_ , e_ );
    END LOOP;
END;
