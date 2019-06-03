       SELECT   invhead.recid,
                'PTUSA' AS source,
                CASE
                    WHEN invhead.customerno IN (
                        'Cust1002260',
                        'Cust1002461'
                    )
                    THEN '300'
                    ELSE '100'
                END AS company,
                CASE
                    WHEN invhead.customerno IN (
                        'Cust1002260',
                        'Cust1002461'
                    )
                THEN 'DISTROW'
                ELSE 'NORAM' 
                END AS sales_market,
                CASE
                    WHEN invhead.customerno IN (
                        'Cust1002260',
                        'Cust1002461'
                    )
                    THEN 'DISTRIBUTION'
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
                CASE
                    WHEN invhead.customerno IN (
                        'Cust1002260',
                        'Cust1002461'
                    )
                THEN 'PTLTD'
                ELSE custinfo.corporate_form 
                END AS corporate_form,
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
                    WHEN invhead.itemno = '97-00001'
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
                NVL(custmap.kd_cust_id,invhead.customerno) AS customer_id,
                NVL(custinfo.name,invhead.customer) AS customer_name,
                custinfoadd.address_id,
                invhead.salesid AS order_id,
                NULL AS rma_id,
                NULL AS rma_line,
                NULL AS market_code,
                NULL AS pay_term_id,
                'USD' AS order_currency,
                TO_CHAR(TO_DATE(invhead.invoicedate,'MM/DD/YYYY'),'YYYY') AS order_entry_year,
                TO_CHAR(TO_DATE(invhead.invoicedate,'MM/DD/YYYY'),'Q') AS order_entry_quarter,
                TO_CHAR(TO_DATE(invhead.invoicedate,'MM/DD/YYYY'),'MM') AS order_entry_month,
                TO_DATE(invhead.invoicedate,'MM/DD/YYYY') AS order_entry_date,
                TO_CHAR(TO_DATE(invhead.invoicedate,'MM/DD/YYYY'),'YYYY') AS invoice_year,
                TO_CHAR(TO_DATE(invhead.invoicedate,'MM/DD/YYYY'),'Q') AS invoice_quarter,
                TO_CHAR(TO_DATE(invhead.invoicedate,'MM/DD/YYYY'),'MM') AS invoice_month,
                TO_DATE(invhead.invoicedate,'MM/DD/YYYY') AS invoice_date,
                invhead.invoiceno AS invoice_id,
                TO_CHAR(invhead.line_item_no) AS item_id,
                nvl(DECODE(invhead.itemno, '97-00001', 'FREIGHT', inventpart.part_product_code),'OTHER') AS part_product_code,
                nvl(DECODE(invhead.itemno, '97-00001', 'FREIGHT', inventpart.part_product_family),'OTHER') AS part_product_family,
                nvl(DECODE(invhead.itemno, '97-00001', 'FREIGHT', inventpart.second_commodity),'OTHER') AS second_commodity,
                invhead.itemno AS catalog_no,
                CASE
                    WHEN invhead.itemno = '97-00001'
                    THEN 'PTUSA FREIGHT'
                    WHEN invhead.itemno = '97-90100' 
                    THEN 'PTUSA Misc. Charge'
                    WHEN invhead.itemno = '97-90000'
                    THEN 'PTUSA Courses'
                    ELSE invhead.item
                END AS catalog_desc,
                invhead.qty AS invoiced_qty,
                salespart.list_price AS current_list_price,
                invhead.amt/nullif(invhead.qty,0) AS unit_price,
                invhead.amt AS total_price,
                1 AS currency_rate,
                invhead.amt/nullif(invhead.qty,0) AS unit_price_usd,
                invhead.amt * 1 AS total_price_usd

         FROM   kd_pt_raw_data invhead
    LEFT JOIN   kd_pt_cust_map custmap
           ON   invhead.customerno = custmap.pt_cust_id
    LEFT JOIN   customer_info_tab custinfo
           ON   custmap.kd_cust_id = custinfo.customer_id
    LEFT JOIN   customer_info_address_tab custinfoadd
           ON   custmap.kd_cust_id = custinfoadd.customer_id
          AND   '99' = custinfoadd.address_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtype
           ON   custmap.kd_cust_id = custinfoaddtype.customer_id
          AND   custinfoadd.address_id = custinfoaddtype.address_id
          AND   custinfoaddtype.address_type_code = 'INVOICE'
    LEFT JOIN   customer_info_address_tab custinfoadddel --For delivery address info
           ON   custmap.kd_cust_id = custinfoadddel.customer_id
          AND   '99' = custinfoadddel.address_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtypedel --For delivery address info
           ON   custmap.kd_cust_id = custinfoaddtypedel.customer_id
          AND   custinfoadddel.address_id = custinfoaddtypedel.address_id
          AND   custinfoaddtypedel.address_type_code = 'DELIVERY'
    LEFT JOIN   cust_ord_customer_address_tab custordcustadd
           ON   custmap.kd_cust_id = custordcustadd.customer_no
          AND   custinfoadd.address_id = custordcustadd.addr_no
    LEFT JOIN   cust_ord_customer_tab custord
           ON   custmap.kd_cust_id = custord.customer_no
    LEFT JOIN   cust_def_com_receiver_tab comrec
           ON   custmap.kd_cust_id = comrec.customer_no
    LEFT JOIN   commission_receiver_tab comrecdef
           ON   comrec.commission_receiver = comrecdef.commission_receiver
    LEFT JOIN   person_info_tab personout --For Outside Rep names
           ON   custord.salesman_code = personout.person_id
    LEFT JOIN   person_info_tab personin --For Inside Rep names
           ON   comrecdef.salesman_code = personin.person_id
    LEFT JOIN   sales_part_tab salespart
           ON   invhead.itemno = salespart.catalog_no
          AND   '100' = salespart.contract
    LEFT JOIN   inventory_part_tab inventpart
           ON   invhead.itemno = inventpart.part_no
          AND   '100' = inventpart.contract
    LEFT JOIN   inventory_product_family prodfam 
           ON   inventpart.part_product_family = prodfam.part_product_family
    LEFT JOIN   inventory_product_family_cft prodfamcft
           ON   prodfam.objkey = prodfamcft.rowkey