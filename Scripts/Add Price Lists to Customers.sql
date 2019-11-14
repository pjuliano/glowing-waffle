DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := NULL; --p1
   c_ VARCHAR2(32000) := NULL; --p2
   d_ VARCHAR2(32000) := 'SALES_PRICE_GROUP_ID'||chr(31)||'PROS'||chr(30)||'CURRENCY_CODE'||chr(31)||'USD'||chr(30)||'PRICE_LIST_NO'||chr(31)||'CLRCHCPROS'||chr(30)||'CUSTOMER_ID'||chr(31)||'A26898'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN

  FOR cur IN 
    (
                
                
SELECT
            iii.identity,
            pl.price_list_no,
            pl.sales_price_group_id
            
FROM
            identity_invoice_info iii,
            (
                SELECT
                                *
                FROM
                                sales_price_list
                WHERE
                                price_list_no LIKE 'CAD%'
            ) pl
            
WHERE
            iii.def_currency = 'CAD'
                AND iii.identity IN  
                    (
                        SELECT
                                        customer_id
                        FROM
                                        customer_pricelist_ent
                        WHERE
                                        identity_invoice_info_api.get_def_currency('100',customer_id,'CUSTOMER') = 'CAD'
                        GROUP BY
                                        customer_id
                        HAVING
                                        count(price_list_no) != 16
                    )
                AND NOT EXISTS 
                    (
                        SELECT
                                        cpe.price_list_no
                        FROM
                                        customer_pricelist_ent cpe
                        WHERE
                                        iii.identity = cpe.customer_id
                                            AND cpe.sales_price_group_id = pl.sales_price_group_id
                                            AND cpe.price_list_no != pl.price_list_no
                    )
    )
  LOOP
    a_ := NULL;
    b_ := NULL;
    c_ := NULL;
    d_ := 'SALES_PRICE_GROUP_ID'||chr(31)||cur.sales_price_group_id||chr(30)||'CURRENCY_CODE'||chr(31)||'CAD'||chr(30)||'PRICE_LIST_NO'||chr(31)||cur.price_list_no||chr(30)||'CUSTOMER_ID'||chr(31)||cur.identity||chr(30);
    e_:= 'DO';
    ifsapp.customer_pricelist_api.new__( a_ , b_ , c_ , d_ , e_ );
  END LOOP;
END;
