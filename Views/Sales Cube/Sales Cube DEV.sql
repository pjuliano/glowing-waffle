DROP materialized view KD_SALES_CUBE_DEV;
CREATE MATERIALIZED VIEW KD_SALES_CUBE_DEV AS
    SELECT      invitem.company || invhead.series_id || invhead.invoice_no || TO_CHAR(invitem.item_id) || TO_CHAR(invhead.invoice_date,'MMDDYYYY') AS recid,
                'IFS' AS source,
                invitem.company,
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
                    WHEN coalesce(inventpart.part_product_code, salchar.charge_group) = 'FREIGHT'
                    THEN 'FREIGHT'
                    ELSE 'OTHER'
                END AS product_set,
                custordcustadd.region_code,
                custord.salesman_code,
                personout.name AS salesman_name,
                custorder.salesman_code AS order_salesman_code,
                comrec.commission_receiver,
                personin.name AS commission_receiver_name,
                custinfo.association_no,
                invhead.identity AS customer_id,
                custinfo.name AS customer_name,
                custinfoadd.address_id AS invoice_address_id,
                custinfoadd.country AS invoice_country,
                custinfoadddel.address_id AS delivery_address_id,
                custinfoadddel.country AS delivery_country,
                invitem.c1 AS order_id,
                invhead.n2 AS rma_id,
                invhead.n3 AS rma_line,
                custorder.market_code,
                invhead.pay_term_id,
                invhead.currency AS order_currency,
                TO_CHAR(invhead.d1, 'YYYY') AS order_entry_year,
                TO_CHAR(invhead.d1, 'Q') AS order_entry_quarter,
                TO_CHAR(invhead.d1, 'MM') AS order_entry_month,
                trunc(invhead.d1) AS order_entry_date,
                TO_CHAR(invhead.invoice_date, 'YYYY') AS invoice_year,
                TO_CHAR(invhead.invoice_date, 'Q') AS invoice_quarter,
                TO_CHAR(invhead.invoice_date, 'MM') AS invoice_month,
                trunc(invhead.invoice_date) AS invoice_date,
                invhead.series_id || invhead.invoice_no AS invoice_id,
                TO_CHAR(invitem.item_id) AS item_id,
                /*Make product family and whatnot show as Freight, and PR15 as RESTOCK.*/
                coalesce(inventpart.part_product_code, salchar.charge_group, 'OTHER') AS part_product_code,
                coalesce(inventpart.part_product_family, salchar.charge_group, 'OTHER') AS part_product_family,
                coalesce(inventpart.second_commodity, salchar.charge_group, 'OTHER') AS second_commodity,
                coalesce(invitem.c5,invitem.c2) AS catalog_no,
                coalesce(invitem.c6,invitem.c3) AS catalog_desc,
                CASE
                    WHEN invhead.series_id = 'CR'
                       AND invhead.n2 IS NULL --Credit without RMA number and no product physically returned.
                    THEN 0
                    WHEN invhead.series_id = 'CR'
                       AND invhead.n2 IS NOT NULL --Credit with RMA number.
                    THEN invitem.n2 * - 1 --Invert the quantity.
                    ELSE invitem.n2
                END AS invoiced_qty,
                nvl(salespart.list_price, salchar.charge_amount) AS current_list_price,
                invitem.net_curr_amount / nullif(CASE
                                                     WHEN invhead.series_id = 'CR'
                                                      AND invhead.n2 IS NULL --Credit without RMA number and no product physically returned.
                                                     THEN 0
                                                     WHEN invhead.series_id = 'CR'
                                                      AND invhead.n2 IS NOT NULL --Credit with RMA number.
                                                     THEN invitem.n2 * - 1 --Invert the quantity.
                                                     ELSE invitem.n2
                                                 END, 0) AS unit_price,
                invitem.net_curr_amount total_price,
                COALESCE(invhead.n1,invhead.curr_rate) AS currency_rate,
                (
                invitem.net_curr_amount / nullif(CASE
                                                     WHEN invhead.series_id = 'CR'
                                                      AND invhead.n2 IS NULL --Credit without RMA number and no product physically returned.
                                                     THEN 0
                                                     WHEN invhead.series_id = 'CR'
                                                      AND invhead.n2 IS NOT NULL --Credit with RMA number.
                                                     THEN invitem.n2 * - 1 --Invert the quantity.
                                                     ELSE invitem.n2
                                                 END, 0)) * COALESCE(invhead.n1,invhead.curr_rate) AS unit_price_usd,
                invitem.net_curr_amount * COALESCE(invhead.n1,invhead.curr_rate) as total_price_usd

         FROM   invoice_tab invhead
    LEFT JOIN   invoice_item_tab invitem
           ON   invhead.invoice_id = invitem.invoice_id
          AND   invhead.company = invitem.company
    LEFT JOIN   sales_part_tab salespart
           ON   invitem.c5 = salespart.catalog_no
          AND   DECODE(invitem.company, '241', '240', invitem.company) = salespart.contract
    LEFT JOIN   inventory_part_tab inventpart
           ON   invitem.c5 = inventpart.part_no
          AND   DECODE(invitem.company, '241', '240', invitem.company) = inventpart.contract
    LEFT JOIN   customer_info_tab custinfo
           ON   invhead.identity = custinfo.customer_id
    LEFT JOIN   customer_info_address_tab custinfoadd --For invoice address info
           ON   invhead.identity = custinfoadd.customer_id
          AND   invhead.invoice_address_id = custinfoadd.address_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtype --For invoice address info
           ON   invhead.identity = custinfoaddtype.customer_id
          AND   custinfoadd.address_id = custinfoaddtype.address_id
          AND   custinfoaddtype.address_type_code = 'INVOICE'
    LEFT JOIN   customer_info_address_tab custinfoadddel --For delivery address info
           ON   invhead.identity = custinfoadddel.customer_id
          AND   invhead.delivery_address_id = custinfoadddel.address_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtypedel --For delivery address info
           ON   invhead.identity = custinfoaddtypedel.customer_id
          AND   custinfoadddel.address_id = custinfoaddtypedel.address_id
          AND   custinfoaddtypedel.address_type_code = 'DELIVERY'
    LEFT JOIN   cust_ord_customer_address_tab custordcustadd
           ON   invhead.identity = custordcustadd.customer_no
          AND   custinfoadd.address_id = custordcustadd.addr_no
    LEFT JOIN   cust_ord_customer_tab custord
           ON   invhead.identity = custord.customer_no
    LEFT JOIN   customer_order_tab custorder
           ON   invitem.c1 = custorder.order_no
          AND   invitem.company = custorder.contract
    LEFT JOIN   cust_def_com_receiver_tab comrec
           ON   invhead.identity = comrec.customer_no
    LEFT JOIN   commission_receiver_tab comrecdef
           ON   comrec.commission_receiver = comrecdef.commission_receiver
    LEFT JOIN   person_info_tab personout --For Outside Rep names
           ON   custord.salesman_code = personout.person_id
    LEFT JOIN   person_info_tab personin --For Inside Rep names
           ON   comrecdef.salesman_code = personin.person_id
    LEFT JOIN   customer_order_address_tab custordadd
           ON   invitem.c1 = custordadd.order_no
    LEFT JOIN   sales_charge_type_tab salchar
           ON   invitem.c5 = salchar.charge_type
          AND   DECODE(invitem.company, '241', '240', invitem.company) = salchar.company
    LEFT JOIN   inventory_product_family prodfam 
           ON   inventpart.part_product_family = prodfam.part_product_family
    LEFT JOIN   inventory_product_family_cft prodfamcft
           ON   prodfam.objkey = prodfamcft.rowkey

         WHERE  invhead.series_id != 'CI'
           AND  invhead.party_type = 'CUSTOMER'
           AND  invhead.rowstate != 'Preliminary'
           AND  invhead.rowstate != 'Cancelled'
UNION ALL

       SELECT   invitem.company || invhead.series_id || invhead.invoice_no || TO_CHAR(invitem.item_id) || TO_CHAR(invhead.invoice_date,'MMDDYYYY') AS recid,
                'IFS' AS source,
                invitem.company,
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
                    WHEN coalesce(inventpart.part_product_code, salchar.charge_group) = 'FREIGHT'
                    THEN 'FREIGHT'
                    ELSE 'OTHER'
                END AS product_set,
                custordcustadd.region_code,
                custord.salesman_code,
                personout.name AS salesman_name,
                custorder.salesman_code AS order_salesman_code,
                comrec.commission_receiver,
                personin.name AS commission_receiver_name,
                custinfo.association_no,
                invhead.identity AS customer_id,
                custinfo.name AS customer_name,
                custinfoadd.address_id as invoice_address_id,
                custinfoadd.country as invoice_country,
                custinfoadddel.address_id as delivery_address_id,
                custinfoadddel.country as delivery_country,
                DECODE(invitem.c1, NULL, client_sys.get_item_value('ORDER_NO', iimast.head_data), invitem.c1) AS order_id,
                invhead.n2 AS rma_id,
                invhead.n3 AS rma_line,
                custorder.market_code,
                invhead.pay_term_id,
                invhead.currency AS order_currency,
                TO_CHAR(invhead.d1, 'YYYY') AS order_entry_year,
                TO_CHAR(invhead.d1, 'Q') AS order_entry_quarter,
                TO_CHAR(invhead.d1, 'MM') AS order_entry_month,
                trunc(invhead.d1) AS order_entry_date,
                TO_CHAR(invhead.invoice_date, 'YYYY') AS invoice_year,
                TO_CHAR(invhead.invoice_date, 'Q') AS invoice_quarter,
                TO_CHAR(invhead.invoice_date, 'MM') AS invoice_month,
                trunc(invhead.invoice_date) AS invoice_date,
                invhead.series_id || invhead.invoice_no AS invoice_id,
                TO_CHAR(invitem.item_id) AS item_id,
                /*Make product family and whatnot show as Freight, and PR15 as RESTOCK.*/
                coalesce(inventpart.part_product_code, salchar.charge_group, 'OTHER') AS part_product_code,
                coalesce(inventpart.part_product_family, salchar.charge_group, 'OTHER') AS part_product_family,
                coalesce(inventpart.second_commodity, salchar.charge_group, 'OTHER') AS second_commodity,
                coalesce(invitem.c5, iidetail.object) AS catalog_no,
                DECODE(invitem.c6, NULL, iidetail.description, invitem.c6) AS catalog_desc,
                CASE
                    WHEN invhead.series_id = 'CR'
                       AND invhead.n2 IS NULL --Credit without RMA number and no product physically returned.
                    THEN 0
                    WHEN invhead.series_id = 'CR'
                       AND invhead.n2 IS NOT NULL --Credit with RMA number.
                    THEN invitem.n2 * - 1 --Invert the quantity.
                    ELSE invitem.n2
                END AS invoiced_qty,
                nvl(salespart.list_price, salchar.charge_amount) AS current_list_price,
                invitem.net_curr_amount / nullif(CASE
                                                     WHEN invhead.series_id = 'CR'
                                                      AND invhead.n2 IS NULL --Credit without RMA number and no product physically returned.
                                                     THEN 0
                                                     WHEN invhead.series_id = 'CR'
                                                      AND invhead.n2 IS NOT NULL --Credit with RMA number.
                                                     THEN invitem.n2 * - 1 --Invert the quantity.
                                                     ELSE invitem.n2
                                                 END, 0) AS unit_price,
                invitem.net_curr_amount total_price,
                NVL(invhead.n1, iimast.rate_used) AS currency_rate,
                (
                invitem.net_curr_amount / nullif(CASE
                                                     WHEN invhead.series_id = 'CR'
                                                      AND invhead.n2 IS NULL --Credit without RMA number and no product physically returned.
                                                     THEN 0
                                                     WHEN invhead.series_id = 'CR'
                                                      AND invhead.n2 IS NOT NULL --Credit with RMA number.
                                                     THEN invitem.n2 * - 1 --Invert the quantity.
                                                     ELSE invitem.n2
                                                 END, 0)) * NVL(invhead.n1, iimast.rate_used) AS unit_price_usd,
                invitem.net_curr_amount * NVL(invhead.n1,iimast.rate_used) as total_price_usd

        FROM    invoice_tab invhead
    LEFT JOIN   invoice_item_tab invitem
           ON   invhead.invoice_id = invitem.invoice_id
          AND   invhead.company = invitem.company
    LEFT JOIN   instant_invoice_master_rpt iimast
           ON   invhead.series_id || invhead.invoice_no = iimast.invoice_no
    LEFT JOIN   instant_invoice_detail_rpt iidetail
           ON   iimast.result_key = iidetail.result_key
          AND   iidetail.row_type = 1
    LEFT JOIN   sales_part_tab salespart
           ON   DECODE(invitem.c5, NULL, iidetail.object, invitem.c5) = salespart.catalog_no
          AND   DECODE(invitem.company, '241', '240', invitem.company) = salespart.contract
    LEFT JOIN   inventory_part_tab inventpart
           ON   DECODE(invitem.c5, NULL, iidetail.object, invitem.c5) = inventpart.part_no
          AND   DECODE(invitem.company, '241', '240', invitem.company) = inventpart.contract
    LEFT JOIN   customer_info_tab custinfo
           ON   invhead.identity = custinfo.customer_id
    LEFT JOIN   customer_info_address_tab custinfoadd
           ON   invhead.identity = custinfoadd.customer_id
          AND   invhead.invoice_address_id = custinfoadd.address_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtype
           ON   invhead.identity = custinfoaddtype.customer_id
          AND   custinfoadd.address_id = custinfoaddtype.address_id
          AND   custinfoaddtype.address_type_code = 'INVOICE'
    LEFT JOIN   customer_info_address_tab custinfoadddel --For delivery address info
           ON   invhead.identity = custinfoadddel.customer_id
          AND   invhead.delivery_address_id = custinfoadddel.address_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtypedel --For delivery address info
           ON   invhead.identity = custinfoaddtypedel.customer_id
          AND   custinfoadddel.address_id = custinfoaddtypedel.address_id
          AND   custinfoaddtypedel.address_type_code = 'DELIVERY'          
    LEFT JOIN   cust_ord_customer_address_tab custordcustadd
           ON   invhead.identity = custordcustadd.customer_no
          AND   custinfoadd.address_id = custordcustadd.addr_no
    LEFT JOIN   cust_ord_customer_tab custord
           ON   invhead.identity = custord.customer_no
    LEFT JOIN   customer_order_tab custorder
           ON   invitem.c1 = custorder.order_no
          AND   invitem.company = custorder.contract
    LEFT JOIN   cust_def_com_receiver_tab comrec
           ON   invhead.identity = comrec.customer_no
    LEFT JOIN   commission_receiver_tab comrecdef
           ON   comrec.commission_receiver = comrecdef.commission_receiver
    LEFT JOIN   person_info_tab personout --For Outside Rep names
           ON   custord.salesman_code = personout.person_id
    LEFT JOIN   person_info_tab personin --For Inside Rep names
           ON   comrecdef.salesman_code = personin.person_id
    LEFT JOIN   customer_order_address_tab custordadd
           ON   invitem.c1 = custordadd.order_no
    LEFT JOIN   sales_charge_type_tab salchar
           ON   invitem.c5 = salchar.charge_type
          AND   DECODE(invitem.c5, NULL, iidetail.object, invitem.c5) = salchar.company
    LEFT JOIN   inventory_product_family prodfam 
           ON   inventpart.part_product_family = prodfam.part_product_family
    LEFT JOIN   inventory_product_family_cft prodfamcft
           ON   prodfam.objkey = prodfamcft.rowkey

        WHERE   invhead.series_id = 'CI'
          AND   invhead.party_type = 'CUSTOMER'
          AND   invhead.rowstate != 'Preliminary'
          AND   invhead.rowstate != 'Cancelled'
          AND   invhead.series_id || invhead.invoice_no IN 
                (
                'CI99106731',
                'CI99104708',
                'CI99107429',
                'CI99099245',
                'CI99105630A',
                'CI99103094',
                'CI99091427A',
                'CI541784B',
                'CI999901456',
                'CI999901697',
                'CI999913881',
                'CI99100341A',
                'CI99096834A',
                'CI99076516',
                'CI99104656',
                'CI99100924',
                'CI99098866',
                'CI999912837A',
                'CI99093418A',
                'CI99106176',
                'CI99106235',
                'CI99016153',
                'CICD99101896',
                'CI99100544',
                'CI2951A',
                'CI999908479A',
                'CI99086484',
                'CI99086930',
                'CI99105850',
                'CI99061875',
                'CI99093370A'
                )
          AND trunc(invhead.invoice_date) >= TO_DATE('01/01/2010', 'MM/DD/YYYY')
          AND invitem.item_id != '100002'

UNION ALL

       SELECT   sord.recid,
                'EURTBL' AS source,
                '240' AS company,
                'ROW' AS sales_market,
                'DIRECT' AS segment,
                'FRA' AS corporate_form,
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
                'FRA' AS region_code,
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
                round(sord.amount/nullif(sord.quantity,0),2) AS unit_price,
                sord.amount AS total_price,
                currate.currency_rate,
                round((sord.amount/nullif(sord.quantity,0)) * currate.currency_rate,2)  AS unit_price_usd,
                sord.amount * currate.currency_rate as total_price_usd

         FROM   srordersfra sord 
    LEFT JOIN   customer_info_tab custinfo
           ON   sord.customerid = custinfo.customer_id
    LEFT JOIN   customer_info_address_tab custinfoadd
           ON   sord.customerid = custinfoadd.customer_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtype
           ON   sord.customerid = custinfoaddtype.customer_id AND
                custinfoadd.address_id = custinfoaddtype.address_id AND
                custinfoaddtype.address_type_code = 'DELIVERY'
    LEFT JOIN   customer_info_address_tab custinfoaddinv
           ON   sord.customerid = custinfoaddinv.customer_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtypeinv
           ON   sord.customerid = custinfoaddtypeinv.customer_id AND
                custinfoaddinv.address_id = custinfoaddtypeinv.address_id AND
                custinfoaddtypeinv.address_type_code = 'INVOICE'
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
    LEFT JOIN   inventory_product_family prodfam 
           ON   inventpart.part_product_family = prodfam.part_product_family
    LEFT JOIN   inventory_product_family_cft prodfamcft
           ON   prodfam.objkey = prodfamcft.rowkey

        WHERE   sord.year >= 2008 
          AND   custinfoaddtype.def_address = 'TRUE'
          AND   custinfoaddtypeinv.def_address = 'TRUE'
          
UNION ALL

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
          
UNION ALL

       SELECT   sord.recid,
                'EURTBL' AS source,
                '230' AS company,
                'ROW' AS sales_market,
                'DIRECT' AS segment,
                'SWE' AS corporate_form,
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
                    WHEN coalesce(inventpart.part_product_code,upper(sord.productline)) = 'FREIGHT'
                    THEN 'FREIGHT'
                    ELSE 'OTHER'
                END AS product_set,
                'SWE' AS region_code,
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
                'SEK' AS currency,
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
                nvl(inventpart.part_product_family,upper(sord.productline)) AS part_product_family,
                inventpart.second_commodity AS second_commodity,
                sord.salespartno AS catalog_no,
                nvl(salespart.catalog_desc,sord.partdescription) AS catalog_desc,
                sord.quantity AS invoiced_qty,
                salespart.list_price AS current_list_price,
                round(sord.amount/nullif(sord.quantity,0),2) AS unit_price,
                sord.amount AS total_price,
                currate.currency_rate,
                round((sord.amount/nullif(sord.quantity,0)) * currate.currency_rate,2) as unit_price_usd,
                sord.amount * currate.currency_rate as total_price_usd

         FROM   srordersswe sord 
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
          AND   currate.currency_code = 'SEK'
    LEFT JOIN   inventory_product_family prodfam 
           ON   inventpart.part_product_family = prodfam.part_product_family
    LEFT JOIN   inventory_product_family_cft prodfamcft
           ON   prodfam.objkey = prodfamcft.rowkey

        WHERE   sord.year >= 2008 
          AND   custinfoaddtype.def_address = 'TRUE'
          AND   custinfoaddtypeinv.def_address = 'TRUE'
          
UNION ALL

       SELECT   sord.recid,
                'EURTBL' AS source,
                '210' AS company,
                'ROW' AS sales_market,
                CASE WHEN sord.customerid IN ('IT002945','IT000387','IT000807','IT001014','IT000916','IT000921',
                                              'IT000465','IT003382','IT003484','IT003575','IT003656','IT003666',
                                              'IT003693','IT003940') THEN 'DISTRIBUTION'
                     ELSE 'DIRECT'
                END AS segment,
                CASE WHEN sord.customerid IN ('IT002945','IT000387','IT000807','IT001014','IT000916','IT000921',
                                              'IT000465','IT003382','IT003484','IT003575','IT003656','IT003666',
                                              'IT003693','IT003940') THEN 'EUR'
                     ELSE 'ITL'
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
                CASE WHEN sord.customerid IN ('IT002945','IT000387','IT000807','IT001014','IT000916','IT000921',
                                              'IT000465','IT003382','IT003484','IT003575','IT003656','IT003666',
                                              'IT003693','IT003940') THEN 'EURO'
                     ELSE 'ITL'
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
                round(sord.amount/nullif(sord.quantity,0),2) AS unit_price,
                sord.amount AS total_price,
                currate.currency_rate,
                round(sord.amount/nullif(sord.quantity,0),2) * currate.currency_rate AS unit_price_usd,                
                sord.amount * currate.currency_rate as total_price_usd

         FROM   srordersitl sord 
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
           ON   sord.customerid = custinfoaddtypeinv.customer_id
          AND   custinfoaddinv.address_id = custinfoaddtypeinv.address_id
          AND   custinfoaddtypeinv.address_type_code = 'INVOICE'
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
          
UNION ALL

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
           
UNION ALL

       SELECT   invhead.recid,
                'PTLTD' AS source,
                '300' AS company,
                'ROW' AS sales_market,
                CASE 
                    WHEN invhead.salesmngr IN ('DISTRIB','DIST IL')
                    THEN 'DISTRIBUTION'
                    WHEN invhead.salesmngr IN ('DIRECT','DIRECT IL')
                    THEN 'DIRECT'
                    ELSE invhead.salesmngr
                END AS segment,
                CASE
                    WHEN invhead.salesmngr = 'DISTRIB'
                    THEN 'DISTROW'
                    WHEN invhead.salesmngr = 'DIST IL'
                    THEN 'DISTIL'
                    WHEN invhead.salesmngr = 'DIRECT EX'
                    THEN 'PTDIR'
                    WHEN invhead.salesmngr = 'DIRECT IL'
                    THEN 'PTDIRIL'
                    ELSE 'OTHER'
                END AS corporate_form,
                NVL(prodfamcft.cf$_kdprodfamtype,'SUND') AS product_type,
                CASE
                    WHEN invhead.psgfamilyofitem = 3
                    THEN 'REGEN'
                    WHEN invhead.psgfamilyofitem = 0
                    THEN 'FIXTURES'
                    WHEN invhead.psgfamilyofitem = 1
                    THEN 'PROSTHETICS'
                    WHEN invhead.psgfamilyofitem = 2 AND
                         UPPER(invhead.invent_item_group_name) = 'KITS'
                    THEN 'KITS'
                    WHEN invhead.psgfamilyofitem = 2 AND
                         UPPER(invhead.invent_item_group_name) != 'KITS'
                    THEN 'INSTRUMENTS'
                    WHEN invhead.psgfamilyofitem = 5
                    THEN 'DIGITAL'
                    WHEN invhead.psgfamilyofitem = 2 AND
                         UPPER(invhead.invent_item_group_name) = 'DIGITAL'
                    THEN 'DIGITAL'
                    WHEN invhead.psgfamilyofitem = 4
                    THEN 'OTHER'
                    WHEN invhead.psgfamilyofitem = 6
                    THEN 'OEM'
                    WHEN UPPER(invhead.invent_item_group_name) = 'PACKAGING MATERIALS'
                    THEN 'FREIGHT'
                    WHEN invhead.itemno = '97-00001'
                    THEN 'FREIGHT'
                    ELSE 'OTHER'
                END AS product_set,
                invhead.territory AS region_code,
                'PTLTD' AS salesman_code,
                invhead.sales_group AS salesman_name,
                NULL AS order_salesman_code,
                NULL AS commission_receiver,
                NULL AS commission_receiver_name,
                NULL AS association_no,
                invhead.customerno AS customer_id,
                invhead.customer AS customer_name,
                NULL AS invoice_address_id,
                invhead.invcountry AS invoice_country,
                NULL AS delivery_address_id,
                invhead.delivcountry AS delivery_country,
                invhead.salesid AS order_id,
                NULL AS rma_id,
                NULL AS rma_line,
                NULL AS market_code,
                invhead.payment AS pay_term_id,
                'ILS' AS order_currency,
                TO_CHAR(invhead.invoicedate,'YYYY') AS order_entry_year,
                TO_CHAR(invhead.invoicedate,'Q') AS order_entry_quarter,
                TO_CHAR(invhead.invoicedate,'MM') AS order_entry_month,
                TO_DATE(trunc(invhead.invoicedate),'MM/DD/YYYY') AS order_entry_date,
                TO_CHAR(invhead.invoicedate,'YYYY') AS invoice_year,
                TO_CHAR(invhead.invoicedate,'Q') AS invoice_quarter,
                TO_CHAR(invhead.invoicedate,'MM') AS invoice_month,
                TO_DATE(trunc(invhead.invoicedate),'MM/DD/YYYY') AS invoice_date,
                invhead.invoiceno AS invoice_id,
                TO_CHAR(invhead.line_item_no) AS item_id,
                CASE
                    WHEN invhead.itemno = '97-00001'
                    THEN 'FREIGHT'
                    WHEN invhead.itemno = '97-90100'
                    THEN 'OTHER'
                    WHEN invhead.itemno = '97-90000'
                    THEN 'OTHER'
                    ELSE DECODE(invhead.psgfamilyofitem,0,'IMPL',1,'PROST',2,'INSTR',3,'REGEN',4,'OTHER',5,'DIGITAL',6,'OEM','OTHER')
                END as part_product_code,
                CASE
                    WHEN invhead.itemno = '97-00001'
                    THEN 'FREIGHT'
                    WHEN UPPER(invhead.invent_item_group_name) = 'PAI IMPLANTS'
                    THEN 'ACTVE'
                    WHEN UPPER(invhead.invent_item_group_name) = 'ADVANCED PLUS IMPLANTS'
                    THEN 'ADVN+'
                    WHEN UPPER(invhead.invent_item_group_name) = 'ADVANCED IMPLANTS'
                    THEN 'ADVNC'
                    WHEN UPPER(invhead.invent_item_group_name) IN ('CONICAL HEALING CAPS',
                                                                   'CONICAL TITANIUM ABUTMENTS',
                                                                   'CONICAL CONNECTION IMPLANTS')
                    THEN 'CONCL'
                    WHEN UPPER(invhead.invent_item_group_name) = 'DYNAMIC IMPLANTS'
                    THEN 'DYMIC'
                    WHEN UPPER(invhead.invent_item_group_name) IN ('PEEK ABUTMENTS',
                                                                   'COBALT CHROME ABUTMENTS',
                                                                   'TITANIUM ABUTMENTS',
                                                                   'MULTI UNIT ABUTMENTS',
                                                                   'IMPRESSION COPING',
                                                                   'HEALING CAPS',
                                                                   'SCREWS',
                                                                   'TOOLS',
                                                                   'CASTABLE ABUTMENTS',
                                                                   'KITS')
                    THEN 'PTCOM'
                    WHEN UPPER(invhead.invent_item_group_name) = 'DIGITAL'
                    THEN 'DIGITAL'
                    WHEN UPPER(invhead.invent_item_group_name) = 'PACKAGING MATERIALS'
                    THEN 'FREIGHT'
                    WHEN UPPER(invhead.invent_item_group_name) = 'DIVA IMPLANTS'
                    THEN 'DIVA'
                    ELSE 'OTHER'
                END AS part_product_family,
                CASE
                    WHEN invhead.itemno = '97-00001'
                    THEN 'FREIGHT'
                    WHEN UPPER(invhead.invent_item_group_name) IN ('PAI IMPLANTS',
                                                                   'ADVANCED PLUS IMPLANTS',
                                                                   'ADVANCED IMPLANTS',
                                                                   'DYNAMIC IMPLANTS',
                                                                   'CONICAL CONNECTION IMPLANTS',
                                                                   'DIVA IMPLANTS')
                    THEN 'IMPTP'
                    WHEN UPPER(invhead.invent_item_group_name) = 'IMPRESSION COPING'
                    THEN 'IPOST'
                    WHEN UPPER(invhead.invent_item_group_name) = 'SCREWS'
                    THEN 'PABSC'
                    WHEN UPPER(invhead.invent_item_group_name) IN ('TITANIUM ABUTMENTS',
                                                                   'COBALT CHROME ABUTMENTS',
                                                                   'MULTI UNIT ABUTMENTS',
                                                                   'CONICAL TITANIUM ABUTMENTS',
                                                                   'CASTABLE ABUTMENTS')
                    THEN 'PFNAB'
                    WHEN UPPER(invhead.invent_item_group_name) IN ('CONICAL HEALING CAPS',
                                                                   'HEALING CAPS')
                    THEN 'PHLAB'
                    WHEN UPPER(invhead.invent_item_group_name) = 'PEEK ABUTMENTS'
                    THEN 'PTPAB'
                    WHEN UPPER(invhead.invent_item_group_name) = 'TOOLS'
                    THEN 'TOOLS'
                    WHEN UPPER(invhead.invent_item_group_name) = 'KITS'
                    THEN 'INKITS'
                    WHEN UPPER(invhead.invent_item_group_name) = 'DIGITAL'
                    THEN 'DIGITAL'
                    WHEN UPPER(invhead.invent_item_group_name) = 'PACKAGING MATERIALS'
                    THEN 'FREIGHT'
                    ELSE 'OTHER'
                END AS second_commodity,
                invhead.itemno AS catalog_no,
                invhead.item AS catalog_desc,
                invhead.qty AS invoiced_qty,
                invhead.current_list_price,
                invhead.amt_ils / nullif(invhead.qty,0) AS unit_price,
                invhead.amt_ils AS total_price,
                invhead.rate_usd AS currency_rate,
                (invhead.amt_ils / nullif(invhead.qty,0)) * invhead.rate_usd as unit_price_usd,
                invhead.amt_ils * invhead.rate_usd AS total_price_usd

         FROM   kd_ptltd_raw_data invhead
    LEFT JOIN   inventory_part inventpart
           ON   upper(invhead.itemno) = upper(inventpart.part_no)
          AND   '100' = inventpart.contract
    LEFT JOIN   inventory_product_family prodfam 
           ON    CASE
                    WHEN invhead.itemno = '97-00001'
                    THEN 'FREIGHT'
                    WHEN UPPER(invhead.invent_item_group_name) = 'PAI IMPLANTS'
                    THEN 'ACTVE'
                    WHEN UPPER(invhead.invent_item_group_name) = 'ADVANCED PLUS IMPLANTS'
                    THEN 'ADVN+'
                    WHEN UPPER(invhead.invent_item_group_name) = 'ADVANCED IMPLANTS'
                    THEN 'ADVNC'
                    WHEN UPPER(invhead.invent_item_group_name) IN ('CONICAL HEALING CAPS',
                                                                   'CONICAL TITANIUM ABUTMENTS',
                                                                   'CONICAL CONNECTION IMPLANTS')
                    THEN 'CONCL'
                    WHEN UPPER(invhead.invent_item_group_name) = 'DYNAMIC IMPLANTS'
                    THEN 'DYMIC'
                    WHEN UPPER(invhead.invent_item_group_name) IN ('PEEK ABUTMENTS',
                                                                   'COBALT CHROME ABUTMENTS',
                                                                   'TITANIUM ABUTMENTS',
                                                                   'MULTI UNIT ABUTMENTS',
                                                                   'IMPRESSION COPING',
                                                                   'HEALING CAPS',
                                                                   'SCREWS',
                                                                   'TOOLS',
                                                                   'CASTABLE ABUTMENTS',
                                                                   'KITS')
                    THEN 'PTCOM'
                    WHEN UPPER(invhead.invent_item_group_name) = 'DIGITAL'
                    THEN 'DIGITAL'
                    WHEN UPPER(invhead.invent_item_group_name) = 'PACKAGING MATERIALS'
                    THEN 'FREIGHT'
                    WHEN UPPER(invhead.invent_item_group_name) = 'DIVA IMPLANTS'
                    THEN 'DIVA'
                    ELSE 'OTHER'
                END = prodfam.part_product_family
    LEFT JOIN   inventory_product_family_cft prodfamcft
           ON   prodfam.objkey = prodfamcft.rowkey
           
UNION ALL

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
                THEN 'ROW'
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
                custinfoadd.address_id AS invoice_address_id,
                custinfoadd.country AS invoice_country,
                custinfoadddel.address_id AS delivery_address_id,
                custinfoadddel.country AS delivery_country,
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