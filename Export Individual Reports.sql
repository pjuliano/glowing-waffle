DECLARE
    query_ VARCHAR(32000);
BEGIN
    FOR reps IN 
        (
        SELECT
                    rep_code
        FROM
                    kd_svq2_rep_config
        )
    LOOP
        query_ := '
            SELECT
                        rc.region_code,
                        salesman_code,
                        rc.rep_name,
                        customer_id,
                        customer_name,
                        address1, 
                        address2,
                        city,
                        state,
                        zip_code,
                        phone,
                        fax,
                        email
                        
            FROM
                        kd_customers c
                        LEFT JOIN kd_svq2_rep_config rc
                            ON c.salesman_code = rc.rep_code
            WHERE
                        customer_id IN 
                            (
                            SELECT
                                        DISTINCT delivery_customer_id
                            FROM
                                        kd_sales_cube sc
                                        JOIN sales_part sp
                                            ON sc.company = sp.contract
                            WHERE
                                        sc.catalog_no = sp.catalog_no
                                           AND sp.sales_price_group_id = ''SIMPLNT''
                                           AND sc.sales_market = ''NORAM''
                                           AND sc.product_set = ''FIXTURES''
                            )
                    AND rc.rep_code = ''' || reps.rep_code || '''';
        --dbms_output.put_line(query_);
        as_xlsx.clear_workbook;
        as_xlsx.query2sheet(p_sql=>query_);
        as_xlsx.save(p_directory=>'BI',p_filename=>reps.rep_code || '.xlsx');
    END LOOP;
END;