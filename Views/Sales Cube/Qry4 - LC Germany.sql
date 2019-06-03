       SELECT   sord.recid,
                'EURTBL' AS source,
                '220' AS company,
                'ROW' AS sales_market,
                CASE WHEN sord.customerid IN ('DE55046','DE43125','DE29029','DE47206') THEN 'DISTRIBUTION' 
                     ELSE 'DIRECT' 
                END AS segment,
                CASE WHEN sord.customerid IN ('DE55046','DE43125','DE29029','DE47206') THEN 'EUR'
                     WHEN sord.salesrepid IN ('220-510','220-520') THEN 'BENELUX'
                     ELSE 'GER'
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
                    WHEN coalesce(inventpart.part_product_code,substr(upper(sord.productline),1,5)) = 'FREIGHT'
                    THEN 'FREIGHT'
                    ELSE 'OTHER'
                END AS product_set,
                CASE WHEN sord.customerid IN ('DE55046','DE43125','DE29029','DE47206') THEN 'EURO'
                     WHEN sord.salesrepid IN ('220-510','220-520') THEN 'BENELUX'
                     ELSE 'GER'
                END AS region_code,    
                sord.salesrepid AS salesman_code,
                personout.name AS salesman_name,
                sord.salesrepid AS order_salesman_code,
                comrec.commission_receiver AS commission_receiver,
                personin.name AS commission_receiver_name,
                custinfo.association_no,
                sord.customerid AS customer_id,
                nvl(custinfo.name,sord.customername) AS customer_name,
                custinfoaddinv.address_id AS invoice_address_id,
                custinfoaddinv.country AS invoice_country,
                custinfoadd.address_id AS delivery_address_id,
                custinfoadd.country AS delivery_country,
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
                sord.unitprice AS unit_price,
                sord.amount AS total_price,
                currate.currency_rate,
                sord.unitprice * currate.currency_rate as unit_price_usd,
                sord.amount * currate.currency_rate as total_price_usd

         FROM   srordersger sord 
    LEFT JOIN   customer_info_tab custinfo
           ON   sord.customerid = custinfo.customer_id
    LEFT JOIN   customer_info_address_tab custinfoadd
           ON   sord.customerid = custinfoadd.customer_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtype
           ON   sord.customerid = custinfoaddtype.customer_id
          AND   custinfoadd.address_id = custinfoaddtype.address_id
          AND   custinfoaddtype.address_type_code = 'DELIVERY'
    LEFT JOIN   customer_info_address_tab custinfoaddinv
           ON   sord.customerid = custinfoaddinv.customer_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtypeinv
           ON   sord.customerid = custinfoaddtypeinv.customer_id AND
                custinfoaddinv.address_id = custinfoaddtypeinv.address_id AND
                custinfoaddtypeinv.address_type_code = 'INVOICE'
    LEFT JOIN   cust_ord_customer_address_tab custordcustadd
           ON   sord.customerid = custordcustadd.customer_no 
          AND   custinfoadd.address_id = custordcustadd.addr_no
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
    LEFT JOIN   inventory_product_family prodfam 
           ON   inventpart.part_product_family = prodfam.part_product_family
    LEFT JOIN   inventory_product_family_cft prodfamcft
           ON   prodfam.objkey = prodfamcft.rowkey

        WHERE   sord.year >= 2008
          AND   custinfoaddtype.def_address = 'TRUE'
          AND   custinfoaddtypeinv.def_address = 'TRUE'