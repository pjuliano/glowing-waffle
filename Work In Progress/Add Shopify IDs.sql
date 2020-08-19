DECLARE
    i_ NUMBER := 1;
    a_ VARCHAR2(32000) := NULL;
    b_ VARCHAR2(32000) := NULL;
    c_ VARCHAR2(32000) := 'CF$_ECOM_PART_DB'||chr(31)||'TRUE'||chr(30);
    d_ VARCHAR2(32000) := '';
    e_ VARCHAR2(32000) := 'DO';
BEGIN
    FOR parts IN
        (
        SELECT
                        st.catalog_no,
                        st.variant_id,
                        st.inventory_id,
                        sp.objid
        FROM
                        kd_shopify_temp st
                        JOIN sales_part_cfv sp
                            ON sp.contract = '100'
                                AND st.catalog_no = sp.catalog_no
        WHERE
                        st.description NOT LIKE '%| K%'
        )
    LOOP
        b_ := parts.objid;
        c_ := 'CF$_ECOM_PART_DB'||chr(31)||'TRUE'||chr(30);
        IFSAPP.SALES_PART_CFP.Cf_Modify__(a_ , b_ , c_ , d_ , e_ );
        COMMIT;
        c_ := 'CF$_SHOPIFY_VAR_ID_K0'||chr(31)||parts.variant_id||chr(30);
        IFSAPP.SALES_PART_CFP.Cf_Modify__(a_ , b_ , c_ , d_ , e_ );
        COMMIT;
        c_ := 'CF$_SHOPIFY_INV_ID_K0'||chr(31)||parts.inventory_id||chr(30);
        IFSAPP.SALES_PART_CFP.Cf_Modify__(a_ , b_ , c_ , d_ , e_ );
        COMMIT;
    END LOOP;
    WHILE i_ <= 4
    LOOP
        FOR parts IN 
            (
            SELECT
                            st.catalog_no,
                            st.variant_id,
                            st.inventory_id,
                            sp.objid
            FROM
                            kd_shopify_temp st
                            JOIN sales_part_cfv sp
                                ON sp.contract = '100'
                                    AND st.catalog_no = sp.catalog_no
            WHERE
                            st.description LIKE '%| K' || i_
            )
        LOOP
            b_ := parts.objid;
            c_ := 'CF$_ECOM_PART_DB'||chr(31)||'TRUE'||chr(30);
            IFSAPP.SALES_PART_CFP.Cf_Modify__(a_ , b_ , c_ , d_ , e_ );
            COMMIT;
            c_ := 'CF$_SHOPIFY_VAR_ID_K' || i_ ||chr(31)||parts.variant_id||chr(30);
            IFSAPP.SALES_PART_CFP.Cf_Modify__(a_ , b_ , c_ , d_ , e_ );
            COMMIT;
--            c_ := 'CF$_SHOPIFY_INV_ID_K' || i_ || '''' ||chr(31)||parts.inventory_id||chr(30);
--            IFSAPP.SALES_PART_CFP.Cf_Modify__(a_ , b_ , c_ , d_ , e_ );
--            COMMIT;
        END LOOP;
        i_ := i_ + 1;
    END LOOP;
END;