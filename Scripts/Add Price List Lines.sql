DECLARE
   a_   VARCHAR2(32000) := NULL;     -- __lsResult
   b_   VARCHAR2(32000) := NULL;     -- __sObjid
   c_   VARCHAR2(32000) := NULL;     -- __lsObjversion
   d_   VARCHAR2(32000) := NULL;
   e_   VARCHAR2(32000) := 'DO';     -- __sAction
BEGIN
    
    FOR cur in 
        (
            SELECT
                            catalog_no,
                            '100' AS site,
                            sales_part_api.get_list_price('100',catalog_no) AS base_price,
                            '0' AS minimum_qty,
                            (to_char(sysdate,'YYYY-MM-DD') || '-00:00:00') AS valid_from_date,
                            '0' AS percentage_offset,
                            '0' AS amount_offset,
                            new_price AS sales_price,
                            '2' AS rounding,
                            price_list_no
            FROM
                            kd_pl_import_ext
            WHERE
                            new_price IS NOT NULL
        )
    LOOP
        d_ := 'CATALOG_NO' || chr(31) || cur.catalog_no || chr(30) || 'BASE_PRICE_SITE' || chr(31) || cur.site || chr(30) || 'BASE_PRICE' || chr(31) || cur.base_price || chr(30) || 'MIN_QUANTITY' || chr(31) || cur.minimum_qty || chr(30) || 'VALID_FROM_DATE' || chr(31) || cur.valid_from_date || chr(30) || 'PERCENTAGE_OFFSET' || chr(31) || '0' || chr(30) || 'AMOUNT_OFFSET' || chr(31) || cur.amount_offset || chr(30) || 'SALES_PRICE' || chr(31) || cur.sales_price || chr(30) || 'ROUNDING' || chr(31) || cur.rounding || chr(30) || 'BASE_PRICE' || chr(31) || cur.base_price || chr(30) || 'PRICE_LIST_NO' || chr(31) || cur.price_list_no || chr(30) || '';
        ifsapp.sales_price_list_part_api.new__( a_, b_, c_, d_, e_ );
    END LOOP;
END;