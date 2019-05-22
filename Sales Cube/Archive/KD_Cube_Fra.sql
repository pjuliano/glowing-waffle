   SELECT   sord.recid,
            'EURTBL' AS source,
            '240' AS company,
            'DIRECT' AS segment,
            'FRA' AS corporate_form,
            'FRA' AS region_code,
            sord.salesrepid AS salesman_code,
            personout.name AS salesman_name,
            sord.salesrepid AS order_salesman_code,
            comrec.commission_receiver AS commission_receiver,
            personin.name AS commission_receiver_name,
            custinfo.association_no,
            sord.customerid AS customer_id,
            nvl(custinfo.name,sord.customername) AS customer_name,
            sord.ordernumber AS order_id,
            NULL AS rma_id,
            NULL AS rma_line,
            NULL AS market_code,
            NULL AS pay_term_id,
            'EUR' AS currency,
            TO_CHAR(sord.salesdate,'YYYY') AS order_entry_year,
            TO_CHAR(sord.salesdate,'Q') AS order_entry_quarter,
            TO_CHAR(sord.salesdate,'MM') AS order_entry_month,
            trunc(sord.salesdate) AS order_entry_date,
            TO_CHAR(sord.salesdate,'YYYY') AS invoice_entry_year,
            TO_CHAR(sord.salesdate,'Q') AS invoice_entry_quarter,
            TO_CHAR(sord.salesdate,'MM') AS invoice_entry_month,
            trunc(sord.salesdate) AS invoice_entry_date,
            sord.invoiceno AS invoice_id,
            TO_CHAR(sord.itemid) AS item_id,
            nvl(inventpart.part_product_code,upper(sord.productcode)) AS part_product_code,
            nvl(inventpart.part_product_family,substr(upper(sord.productline),1,5)) AS part_product_family,
            inventpart.second_commodity AS second_commodity,
            sord.salespartno AS catalog_no,
            nvl(salespart.catalog_desc,sord.partdescription) AS catalog_desc,
            sord.quantity AS invoiced_qty,
            salespart.list_price AS current_list_price,
            round(sord.amount/nullif(sord.quantity,0),2) AS unit_price,
            sord.amount AS total_price,
            currate.currency_rate,
            0 AS tax_amount,
            NULL AS tax_code
            
     FROM   srordersfra sord 
LEFT JOIN   customer_info_tab custinfo
       ON   sord.customerid = custinfo.customer_id
LEFT JOIN   customer_info_address_tab custinfoadd
       ON   sord.customerid = custinfoadd.customer_id
LEFT JOIN   customer_info_address_type_tab custinfoaddtype
       ON   sord.customerid = custinfoaddtype.customer_id AND
            custinfoadd.address_id = custinfoaddtype.address_id AND
            custinfoaddtype.address_type_code = 'DELIVERY'
LEFT JOIN   cust_ord_customer_address_tab custordcustadd
       ON   sord.customerid = custordcustadd.customer_no AND
            custinfoadd.address_id = custordcustadd.addr_no
LEFT JOIN   cust_ord_customer_tab custord
       ON   sord.customerid = custord.customer_no
LEFT JOIN   customer_order_tab custorder
       ON   sord.customerid = custorder.order_no
LEFT JOIN   cust_def_com_receiver_tab comrec
       ON   sord.customerid = comrec.customer_no
LEFT JOIN   commission_receiver_tab comrecdef
       ON   comrec.commission_receiver = comrecdef.commission_receiver
LEFT JOIN   person_info_tab personout --Outside Rep
       ON   sord.salesrepid = personout.person_id
LEFT JOIN   person_info_tab personin  --Inside Rep
       ON   comrecdef.salesman_code = personin.person_id
LEFT JOIN   sales_part_tab salespart
       ON   sord.salespartno = salespart.catalog_no 
      AND   salespart.contract = '210'
LEFT JOIN   inventory_part_tab inventpart
       ON   sord.salespartno = inventpart.part_no
      AND   inventpart.contract = '210'
LEFT JOIN   currency_rate_tab currate 
       ON   TO_CHAR(sord.salesdate,'MM/YYYY') = TO_CHAR(currate.valid_from,'MM/YYYY')
      AND   currate.currency_type = '4'
      AND   currate.company = '99'
      AND   currate.currency_code = 'EUR'
      
    WHERE   sord.year >= 2008 
      AND   custinfoaddtype.def_address = 'TRUE'