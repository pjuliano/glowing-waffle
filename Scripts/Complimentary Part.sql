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
                            catalog_no IN 
                                (
                                    'PTM-KEYSTONE-FGS',
                                    '15413K',
                                    '15414K',
                                    '15415K',
                                    '15416K',
                                    '15417K',
                                    '15418K',
                                    '15419K',
                                    '15420K',
                                    '15421K',
                                    '15422K',
                                    '15423K',
                                    '15424K',
                                    '15425K',
                                    '15426K',
                                    '15427K',
                                    '15428K',
                                    '15429K',
                                    '15430K',
                                    '15431K',
                                    '15432K',
                                    '15433K',
                                    '15434K',
                                    '15435K',
                                    '15436K',
                                    '15437K',
                                    '15613K',
                                    '15614K',
                                    '15615K',
                                    '15616K',
                                    '15617K',
                                    '15618K',
                                    '15619K',
                                    '15620K',
                                    '15621K',
                                    '15622K',
                                    '15623K',
                                    '15624K',
                                    '15625K',
                                    '15626K',
                                    '15627K',
                                    '15628K',
                                    '15629K',
                                    '15630K',
                                    '15631K',
                                    '15632K',
                                    '15633K',
                                    '15634K',
                                    '15635K',
                                    '15636K',
                                    '15637K'
                                )
        )
    LOOP
        a_ := NULL;
        b_ := NULL;
        c_ := NULL;
        d_ := 'CONTRACT'||chr(31)||'100'||chr(30)||'PARENT_PART_NO'||chr(31)||parts.catalog_no||chr(30)||'SUGGESTED_PART_NO'||chr(31)||'4409-0234'||chr(30);
        e_ := NULL;
        IFSAPP.SUGGESTED_SALES_PART_API.NEW__( a_ , b_ , c_ , d_ , e_ );
    END LOOP;
END;
