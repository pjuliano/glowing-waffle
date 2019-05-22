   SELECT   invhead.recid,
            'PTUSA' AS source,
            '100' AS company,
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
            custordcustadd.region_code,
            custord.salesman_code,
            personout.name AS salesman_name,
            '' AS order_salesman_code,
            comrec.commission_receiver,
            personin.name AS commission_receiver_name,
            custinfo.association_no,
            custmap.kd_cust_id AS customer_id,
            custinfo.name AS customer_name,
            'P' || substr(invhead.invoiceno,3,7) AS order_id,
            '' AS rma_id,
            '' AS rma_line,
            '' AS market_code,
            '' AS pay_term_id,
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
                ELSE NVL(salespart.catalog_desc, invhead.item)
            END AS catalog_desc,
            invhead.qty AS invoiced_qty,
            salespart.list_price AS current_list_price,
            invhead.amt/nullif(invhead.qty,0) AS unit_price,
            invhead.amt AS total_price,
            1 AS currency_rate,
            0 AS tax_amount,
            '' AS tax_code
            
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