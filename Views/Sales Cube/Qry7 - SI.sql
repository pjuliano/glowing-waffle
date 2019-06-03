       SELECT   invhead.recid,
                'SIDATA' AS source,
                '100' AS company,
                CASE 
                    WHEN custinfo.corporate_form IN ('DOMDIR','DOMDIS','CAN')
                    THEN 'NORAM'
                    ELSE 'ROW'
                END AS sales_market,
                CASE
                    WHEN custinfo.corporate_form IN (
                        'ASIA',
                        'CAN',
                        'DOMDIS',
                        'EUR',
                        'LA',
                        'SPA'
                    )
                    THEN 'DISTRIBUTION'
                    WHEN custinfo.corporate_form IN (
                        'DOMDIR',
                        'FRA',
                        'GER',
                        'BENELUX',
                        'ITL',
                        'SWE'
                    )
                    THEN 'DIRECT'
                    ELSE 'OTHER'
                END AS segment,
                custinfo.corporate_form,
                NVL(prodfamcft.cf$_kdprodfamtype,'SUND') AS product_type,
                CASE
                    WHEN inventpart.part_product_code = 'REGEN'
                    THEN 'REGEN'
                    WHEN inventpart.part_product_code = 'IMPL'
                    THEN 'FIXTURES'
                    WHEN inventpart.part_product_code IN ('PROST','PROS','SURG','KITPR')
                    THEN 'PROSTHETICS'
                    WHEN inventpart.part_product_code IN ('INSTR','KITPI')
                    THEN 'INSTRUMENTS'
                    WHEN inventpart.part_product_code = 'KITSI' AND
                         inventpart.second_commodity = 'INKIT'
                    THEN 'KITS'
                    WHEN inventpart.part_product_code = 'FREIGHT'
                    THEN 'FREIGHT'
                    ELSE 'OTHER'
                END AS product_set,
                custordcustadd.region_code,
                custord.salesman_code,
                personout.name AS salesman_name,
                NULL AS order_salesman_code,
                comrec.commission_receiver,
                personin.name AS commission_receiver_name,
                custinfo.association_no,
                invhead.key_code AS customer_id,
                custinfo.name AS customer_name,
                custinfoadd.address_id AS invoice_address_id,
                custinfoadd.country AS invoice_country,
                custinfoadddel.address_id AS delivery_address_id,
                custinfoadddel.country AS delivery_country,
                invhead.sales_order AS order_id,
                NULL AS rma_id,
                NULL AS rma_line,
                NULL AS market_code,
                NULL AS pay_term_id,
                invhead.currencycode AS order_currency,
                TO_CHAR(invhead.order_date, 'YYYY') AS order_entry_year,
                TO_CHAR(invhead.order_date, 'Q') AS order_entry_quarter,
                TO_CHAR(invhead.order_date, 'MM') AS order_entry_month,
                trunc(invhead.order_date) AS order_entry_date,
                TO_CHAR(invhead.invoice_date, 'YYYY') AS invoice_year,
                TO_CHAR(invhead.invoice_date, 'Q') AS invoice_quarter,
                TO_CHAR(invhead.invoice_date, 'MM') AS invoice_month,
                trunc(invhead.invoice_date) AS invoice_date,
                invhead.invoice AS invoice_id,
                TO_CHAR(invhead.linenumber) AS item_id,
                NVL(inventpart.part_product_code,'OTHER') AS part_product_code,
                NVL(inventpart.part_product_family,'OTHER') AS part_product_family,
                NVL(inventpart.second_commodity,'OTHER') AS second_commodity,
                invhead.product_code AS catalog_no,
                inventpart.description,
                invhead.qty,
                salespart.list_price AS current_list_price,
                invhead.extensioncurrdisk / nullif(invhead.qty,0) AS unit_price,
                invhead.extensioncurrdisk AS total_price,
                currate.currency_rate,
                (invhead.extensioncurrdisk / nullif(invhead.qty,0)) * currate.currency_rate AS unit_price_usd,
                invhead.extensioncurrdisk * currate.currency_rate as total_price_usd

         FROM   srinvoicessi invhead 
    LEFT JOIN   customer_info_tab custinfo
           ON   invhead.key_code = custinfo.customer_id
    LEFT JOIN   customer_info_tab custinfo
           ON   invhead.key_code = custinfo.customer_id
    LEFT JOIN   cust_ord_customer_tab custord
           ON   invhead.key_code = custord.customer_no
    LEFT JOIN   customer_info_address_tab custinfoadd
           ON   invhead.key_code = custinfoadd.customer_id
          AND   '99' = custinfoadd.address_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtype
           ON   invhead.key_code = custinfoaddtype.customer_id
          AND   custinfoadd.address_id = custinfoaddtype.address_id
          AND   custinfoaddtype.address_type_code = 'INVOICE'
    LEFT JOIN   customer_info_address_tab custinfoadddel --For delivery address info
           ON   invhead.key_code = custinfoadddel.customer_id
          AND   '99' = custinfoadddel.address_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtypedel --For delivery address info
           ON   invhead.key_code = custinfoaddtypedel.customer_id
          AND   custinfoadddel.address_id = custinfoaddtypedel.address_id
          AND   custinfoaddtypedel.address_type_code = 'DELIVERY'
    LEFT JOIN   cust_ord_customer_address_tab custordcustadd
           ON   invhead.key_code = custordcustadd.customer_no
          AND   custinfoadd.address_id = custordcustadd.addr_no
    LEFT JOIN   person_info_tab personout --For Outside Rep names
           ON   custord.salesman_code = personout.person_id
    LEFT JOIN   cust_def_com_receiver_tab comrec
           ON   invhead.key_code = comrec.customer_no
    LEFT JOIN   commission_receiver_tab comrecdef
           ON   comrec.commission_receiver = comrecdef.commission_receiver
    LEFT JOIN   person_info_tab personin --For Inside Rep names
           ON   comrecdef.salesman_code = personin.person_id   
    LEFT JOIN   inventory_part_tab inventpart 
           ON   invhead.product_code = inventpart.part_no
          AND   inventpart.contract = '100'
    LEFT JOIN   sales_part_tab salespart
           ON   invhead.product_code = salespart.catalog_no
          AND   salespart.contract = '100'
    LEFT JOIN   currency_rate_tab currate
           ON   currate.currency_type = '4'
          AND   currate.company = '99' 
          AND   TO_CHAR(invhead.invoice_date,'MM/YYYY') = TO_CHAR(currate.valid_from,'MM/YYYY')
          AND   invhead.currencycode = currate.currency_code
    LEFT JOIN   inventory_product_family prodfam 
           ON   inventpart.part_product_family = prodfam.part_product_family
    LEFT JOIN   inventory_product_family_cft prodfamcft
           ON   prodfam.objkey = prodfamcft.rowkey