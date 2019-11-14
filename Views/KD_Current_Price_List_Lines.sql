CREATE OR REPLACE VIEW kd_current_price_list_lines AS
WITH 
    valid_lines AS
        (
            SELECT
                            splpsub.price_list_no,
                            splpsub.catalog_no,
                            MAX(splpsub.valid_from_date) AS valid_from_date
            FROM
                            sales_price_list_part splpsub
            GROUP BY
                            splpsub.price_list_no,
                            splpsub.catalog_no
        )
SELECT
                splp.*
FROM
                sales_price_list_part splp,
                valid_lines vl
WHERE
                splp.price_list_no = vl.price_list_no
                    AND splp.catalog_no = vl.catalog_no
                    AND splp.valid_from_date = vl.valid_from_date