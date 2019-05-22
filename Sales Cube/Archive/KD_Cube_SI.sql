   SELECT   'SIDATA' AS source,
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
            personout.name as salesman_name,
            '' AS order_salesman_code,
            comrec.commission_receiver,
            personin.name AS commission_receiver_name,
            custinfo.association_no,
            invhead.key_code AS customer_id,
            custinfo.name AS customer_name,
            invhead.sales_order AS order_id,
            NULL AS rma_no,
            NULL AS rma_line,
            '' AS market_code,
            '' AS pay_term_id,
            invhead.currencycode as order_currency,
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
            inventpart.part_product_code,
            inventpart.part_product_family,
            inventpart.second_commodity,
            invhead.product_code as catalog_no,
            inventpart.description,
            invhead.qty,
            salespart.list_price as current_list_price,
            (invhead.extensioncurrdisk * NVL(currate.currency_rate,1)) / NVL(invhead.qty,0) as unit_price,
            invhead.extensioncurrdisk as total_price,
            currate.currency_rate,
            0 AS tax_amount,
            '' AS tax_code
            
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