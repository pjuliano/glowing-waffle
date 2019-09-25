DECLARE
    a_ VARCHAR2(32000);
    b_ VARCHAR2(32000);
    c_ VARCHAR2(32000);
    d_ VARCHAR2(32000);
    e_ VARCHAR2(32000);
    wlc VARCHAR2(4000);
    part_no VARCHAR2(4000);
    part_desc VARCHAR2(4000);
    list_price VARCHAR2(4000);
    product_family VARCHAR2(4000);
    product_code VARCHAR2(4000);
    header VARCHAR2(4000);
    file_handle utl_file.file_type;
    
    CURSOR wrong_list_count IS
        SELECT
                        COUNT(lpu.part_no)
        FROM
                        kd_list_price_update_ext lpu
                        JOIN sales_part sp ON
                            lpu.part_no = sp.catalog_no
                                AND '100' = sp.company 
                                AND lpu.list_price != sp.list_price;
    CURSOR wrong_list IS
        SELECT
                        lpu.part_no,
                        lpu.part_desc,
                        lpu.list_price,
                        lpu.product_family,
                        lpu.product_code
        FROM
                        kd_list_price_update_ext lpu
                        JOIN sales_part sp ON
                            lpu.part_no = sp.catalog_no
                                AND '100' = sp.company 
                                AND lpu.list_price != sp.list_price;
BEGIN
    FOR salesparts IN 
        (
            SELECT
                            lpu.part_no,
                            lpu.list_price,
                            sp.objid,
                            sp.objversion
            FROM
                            kd_list_price_update_ext lpu
                            JOIN sales_part sp ON
                                lpu.part_no = sp.catalog_no
                                    AND '100' = sp.company 
        )
    LOOP
        a_ := '';
        b_ := salesparts.objid;
        c_ := salesparts.objversion;
        d_ := 'LIST_PRICE'||chr(31)||salesparts.list_price||chr(30);
        e_ := 'DO';
        ifsapp.sales_part_api.modify__( a_ , b_ , c_ , d_ , e_ );
    END LOOP;
    COMMIT;
    OPEN wrong_list_count;
    FETCH wrong_list_count INTO wlc;
    IF
        wlc = 0 
    THEN
        CLOSE wrong_list_count;
    ELSE 
        file_handle := utl_file.fopen('BI', TO_CHAR(SYSDATE,'YYYY.MM.DD.HH24.mm') || ' List Price Update Errors.csv','w',32767);
        FOR header IN
            (
                SELECT 
                                LISTAGG(column_name,',') WITHIN GROUP (ORDER BY column_id) AS header_line 
                FROM 
                                all_tab_columns 
                WHERE 
                                table_name = UPPER('kd_list_price_update_ext')
            )
        LOOP
            utl_file.put_line
                (
                    file_handle,
                    header.header_line
                );
        END LOOP;
        FOR rec IN wrong_list 
            LOOP
                utl_file.put_line
                    (
                        file_handle,
                        '"' || rec.part_no || '",' || 
                        '"' || rec.part_desc || '",' ||
                        '"' || rec.list_price || '",' ||
                        '"' || rec.product_family || '",' ||
                        '"' || rec.product_code || '",'
                    );
            END LOOP;
        utl_file.fclose(file_handle);
    END IF;
END;
