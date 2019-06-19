CREATE OR REPLACE VIEW KD_SALES_CUBE_TEST_QRY5 AS
       SELECT   sord.recid,
                'EURTBL' AS source,
                '230' AS company,
                'ROW' AS sales_market,
                'DIRECT' AS segment,
                'SWE' AS corporate_form,
                CASE
                    WHEN inventpart.part_product_family IN (
                        'GNSIS',
                        'PRIMA',
                        'PRMA+',
                        'TLMAX',
                        'PCOMM',
                        'IHMAX',
                        'RENOV',
                        'RESTO',
                        'STAGE',
                        'SUST',
                        'XP1',
                        'TRINX',
                        'EXHEX',
                        'OCT',
                        'ZMAX',
                        'OTMED',
                        'COMM',
                        'BVINE',
                        'CONNX',
                        'CYTOP',
                        'DYNAB',
                        'DYNAG',
                        'DYNAM',
                        'MTF',
                        'SYNTH',
                        'EG',
                        'OTHER',
                        'MOTOR',
                        'FREIGHT',
                        'OCOS',
                        'EDU'
                    )
                    THEN 'KEYSTONE'
                    WHEN inventpart.part_product_family IN (
                        'ACTVE',
                        'ADVN+',
                        'ADVNC',
                        'CONCL',
                        'DIVA',
                        'DYMIC',
                        'PAI',
                        'PTCOM',
                        'PALTOP BIO',
                        'PAI',
                        'PAITC',
                        'PCA'
                    )
                    THEN 'PALTOP'
                    ELSE 'UNCLASSIFIED'
                END AS product_brand,
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
                CASE
                    WHEN inventpart.part_product_family IN 
                        (
                            'GNSIS',
                            'PRIMA',
                            'PRMA+',
                            'TLMAX',
                            'PCOMM'
                        )
                    THEN 'TILOBE'
                    WHEN inventpart.part_product_family IN 
                        (
                            'IHMAX',
                            'ADVN+',
                            'ADVNC',
                            'DIVA',
                            'DYMIC',
                            'PAI',
                            'PAITC'
                        )
                    THEN 'INTERNAL HEX'
                    WHEN inventpart.part_product_family IN 
                        (
                            'COMM',
                            'PTCOM'
                        )
                    THEN 'COMMON'
                    WHEN inventpart.part_product_family = 'PCA'
                    THEN 'CONICAL'
                    WHEN inventpart.part_product_family IN 
                        (
                            'RENOV',
                            'RESTO',
                            'STAGE',
                            'SUST',
                            'XP1',
                            'OTMED'
                        )
                    THEN 'NON-TILOBE'
                    WHEN inventpart.part_product_family IN 
                        (
                            'TRINX',
                            'EXHEX',
                            'ZMAX',
                            'OCT'
                        )
                    THEN 'SI STYLE'
                    WHEN inventpart.part_product_family IN 
                        (
                            'BVINE',
                            'CONNX',
                            'CYTOP',
                            'CALFO',
                            'CALMA',
                            'CAPSE',
                            'DYNAB',
                            'DYNAG',
                            'DYNAC',
                            'MDB',
                            'TEFGE',
                            'DYNAM',
                            'MTF',
                            'SYNTH',
                            'PALTOP BIO',
                            'EG',
                            'OTHER',
                            'MOTOR',
                            'FREIGHT',
                            'EDU',
                            'PROMO',
                            'RESTOCK'
                        )
                    THEN 'N/A'
                    ELSE 'UNCLASSIFIED'
                END AS connection,
                'SWE' AS invoice_region_code,
                sord.salesrepid AS invoice_salesman_code,
                personout.name AS invoice_salesman_name,
                'SWE' AS delivery_region_code,
                sord.salesrepid AS delivery_salesman_code,
                personout.name AS delivery_salesman_name,
                comrec.commission_receiver AS delivery_commission_rec,
                personin.name AS delivery_commission_rec_name,
                custinfo.association_no AS invoice_association_no,
                sord.customerid AS invoice_customer_id,
                nvl(custinfo.name,sord.customername) AS invoice_customer_name,
                custinfoaddinv.address_id AS invoice_address_id,
                custinfoaddinv.address1 AS invoice_street_1,
                custinfoaddinv.address2 AS invoice_street_2,
                custinfoaddinv.city AS invoice_city,
                custinfoaddinv.state AS invoice_state,
                custinfoaddinv.zip_code AS invoice_zip,
                custinfoaddinv.country AS invoice_country,
                custinfo.association_no AS delivery_association_no,
                sord.customerid AS delivery_customer_id,
                nvl(custinfo.name,sord.customername) AS delivery_customer_name,
                custinfoadd.address_id AS delivery_address_id,
                custinfoadd.address1 AS delivery_street_1,
                custinfoadd.address2 AS delivery_street_2,
                custinfoadd.city AS delivery_city,
                custinfoadd.state AS delivery_state,
                custinfoadd.zip_code AS delivery_zip,
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