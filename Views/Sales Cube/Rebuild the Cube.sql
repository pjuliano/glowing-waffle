DROP MATERIALIZED VIEW kd_sales_cube;
    
CREATE MATERIALIZED VIEW "IFSAPP"."KD_SALES_CUBE" 
    (
        "RECID", 
        "SOURCE", 
        "COMPANY", 
        "SALES_MARKET", 
        "SEGMENT", 
        "CORPORATE_FORM", 
        "PRODUCT_BRAND",
        "PRODUCT_TYPE", 
        "PRODUCT_SET",
        "CONNECTION",
        "INVOICE_REGION_CODE", 
        "INVOICE_SALESMAN_CODE", 
        "INVOICE_SALESMAN_NAME",
        "DELIVERY_REGION_CODE",
        "DELIVERY_SALESMAN_CODE",
        "DELIVERY_SALESMAN_NAME",
        "DELIVERY_COMMISSION_REC", 
        "DELIVERY_COMMISSION_REC_NAME", 
        "INVOICE_ASSOCIATION_NO", 
        "INVOICE_CUSTOMER_ID", 
        "INVOICE_CUSTOMER_NAME", 
        "INVOICE_ADDRESS_ID", 
        "INVOICE_STREET_1", 
        "INVOICE_STREET_2", 
        "INVOICE_CITY",
        "INVOICE_STATE", 
        "INVOICE_ZIP",
        "INVOICE_COUNTRY",
        "DELIVERY_ASSOCIATION_NO",
        "DELIVERY_CUSTOMER_ID",
        "DELIVERY_CUSTOMER_NAME",
        "DELIVERY_ADDRESS_ID", 
        "DELIVERY_STREET_1",
        "DELIVERY_STREET_2",
        "DELIVERY_CITY",
        "DELIVERY_STATE",
        "DELIVERY_ZIP",
        "DELIVERY_COUNTRY",
        "ORDER_ID", 
        "RMA_ID", 
        "RMA_LINE", 
        "MARKET_CODE", 
        "PAY_TERM_ID", 
        "ORDER_CURRENCY", 
        "ORDER_ENTRY_YEAR", 
        "ORDER_ENTRY_QUARTER", 
        "ORDER_ENTRY_MONTH", 
        "ORDER_ENTRY_DATE", 
        "INVOICE_YEAR", 
        "INVOICE_QUARTER", 
        "INVOICE_MONTH", 
        "INVOICE_DATE", 
        "INVOICE_ID", 
        "ITEM_ID", 
        "PART_PRODUCT_CODE", 
        "PART_PRODUCT_FAMILY", 
        "SECOND_COMMODITY", 
        "CATALOG_NO", 
        "CATALOG_DESC", 
        "INVOICED_QTY", 
        "CURRENT_LIST_PRICE", 
        "UNIT_PRICE", 
        "TOTAL_PRICE", 
        "CURRENCY_RATE",
        "UNIT_PRICE_USD", 
        "TOTAL_PRICE_USD"
        ) 
    ORGANIZATION HEAP 
    PCTFREE 10 
    PCTUSED 40 
    INITRANS 1 
    MAXTRANS 255 
    NOCOMPRESS 
    LOGGING STORAGE
        (
            INITIAL 65536 
            NEXT 1048576 
            MINEXTENTS 1 
            MAXEXTENTS 2147483645 
            PCTINCREASE 0 
            FREELISTS 1 
            FREELIST GROUPS 1 
            BUFFER_POOL DEFAULT 
            FLASH_CACHE DEFAULT 
            CELL_FLASH_CACHE DEFAULT
        ) 
    TABLESPACE "IFSAPP_DATA" 
    BUILD IMMEDIATE USING INDEX 
    REFRESH COMPLETE ON DEMAND 
    USING DEFAULT LOCAL ROLLBACK SEGMENT 
    USING ENFORCED CONSTRAINTS DISABLE QUERY REWRITE AS
    
    SELECT      invitem.company || invhead.series_id || invhead.invoice_no || TO_CHAR(invitem.item_id) || TO_CHAR(invhead.invoice_date,'MMDDYYYY') AS recid,
                'IFS' AS source,
                invitem.company,
                CASE 
                    WHEN custinfo.corporate_form IN 
                        (
                            'DOMDIR',
                            'DOMDIS',
                            'CAN'
                        )
                    THEN 'NORAM'
                    ELSE 'ROW'
                END AS sales_market,
                CASE
                    WHEN custinfo.corporate_form IN 
                        (
                            'ASIA',
                            'CAN',
                            'DOMDIS',
                            'EUR',
                            'LA',
                            'SPA'
                        )
                    THEN 'DISTRIBUTION'
                    WHEN custinfo.corporate_form IN 
                        (
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
                CASE
                    WHEN coalesce(inventpart.part_product_family, salchar.charge_group, 'OTHER') IN 
                        (
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
                            'EDU',
                            'DYNAC',
                            'RESTOCK',
                            'COMPT',
                            'MAGMA',
                            'ED'
                        )
                    THEN 'KEYSTONE'
                    WHEN coalesce(inventpart.part_product_family, salchar.charge_group, 'OTHER') IN 
                        (
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
                    WHEN coalesce(inventpart.part_product_code, salchar.charge_group) = 'FREIGHT'
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
                            'PCOMM',
                            'ODYSS'
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
                            'OTMED',
                            'PRSFT'
                        )
                    THEN 'NON-TILOBE'
                    WHEN inventpart.part_product_family IN 
                        (
                            'TRINX',
                            'EXHEX',
                            'ZMAX',
                            'OCT',
                            'EXORL'
                        )
                    THEN 'SI STYLE'
                    WHEN coalesce(inventpart.part_product_family, salchar.charge_group) IN 
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
                            'RESTOCK',
                            'IDENT',
                            'MAGMA'
                        )
                    THEN 'N/A'
                    ELSE 'UNCLASSIFIED'
                END AS connection,
                custordcustadd.region_code AS invoice_region_code,
                custord.salesman_code AS invoice_salesman_code,
                personout.name AS invoice_salesman_name,
                custordcustadddel.region_code AS delivery_region_code,
                custordcustdel.salesman_code AS delivery_salesman_code,
                persondel.name AS delivery_salesman_name,
                comrec.commission_receiver AS delivery_commission_rec,
                personin.name AS delivery_commission_rec_name,
                custinfo.association_no AS invoice_association_no,
                invhead.identity AS invoice_customer_id,
                custinfo.name AS invoice_customer_name,
                custinfoadd.address_id AS invoice_address_id,
                custinfoadd.address1 AS invoice_street_1,
                custinfoadd.address2 AS invoice_street_2,
                custinfoadd.city AS invoice_city,
                custinfoadd.state AS invoice_state,
                custinfoadd.zip_code AS invoice_zip,
                custinfoadd.country AS invoice_country,
                custinfodel.association_no AS delivery_association_no,
                COALESCE(invhead.delivery_identity,invhead.identity) AS delivery_customer_id,
                custinfodel.name AS delivery_customer_name,
                custinfoadddel.address_id AS delivery_address_id,
                custinfoadddel.address1 AS delivery_street_1,
                custinfoadddel.address2 AS delivery_street_2,
                custinfoadddel.city AS delivery_city,
                custinfoadddel.state AS delivery_state,
                custinfoadddel.zip_code AS delivery_zip,
                custinfoadddel.country AS delivery_country,
                invitem.c1 AS order_id,
                invhead.n2 AS rma_id,
                CASE
                    WHEN invitem.n2 IS NOT NULL
                    THEN invitem.item_id
                    ELSE NULL 
                END AS rma_line,
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
                invitem.net_curr_amount AS total_price,
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
    LEFT JOIN   cust_ord_customer_tab custordcustdel --For delivery customer salesman code
           ON   COALESCE(invhead.delivery_identity,invhead.identity) = custordcustdel.customer_no
    LEFT JOIN   customer_info_tab custinfodel --For delivery customer info
           ON   COALESCE(invhead.delivery_identity,invhead.identity) = custinfodel.customer_id
    LEFT JOIN   customer_info_address_tab custinfoadd --For invoice address info
           ON   invhead.identity = custinfoadd.customer_id
          AND   invhead.invoice_address_id = custinfoadd.address_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtype --For invoice address info
           ON   invhead.identity = custinfoaddtype.customer_id
          AND   custinfoadd.address_id = custinfoaddtype.address_id
          AND   custinfoaddtype.address_type_code = 'INVOICE'
    LEFT JOIN   customer_info_address_tab custinfoadddel --For delivery address info
           ON   COALESCE(invhead.delivery_identity,invhead.identity) = custinfoadddel.customer_id
          AND   invhead.delivery_address_id = custinfoadddel.address_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtypedel --For delivery address info
           ON   COALESCE(invhead.delivery_identity,invhead.identity) = custinfoaddtypedel.customer_id
          AND   custinfoadddel.address_id = custinfoaddtypedel.address_id
          AND   custinfoaddtypedel.address_type_code = 'DELIVERY'
    LEFT JOIN   cust_ord_customer_address_tab custordcustadd
           ON   invhead.identity = custordcustadd.customer_no
          AND   custinfoadd.address_id = custordcustadd.addr_no
    LEFT JOIN   cust_ord_customer_address_tab custordcustadddel
          ON    COALESCE(invhead.delivery_identity,invhead.identity) = custordcustadddel.customer_no
         AND    custinfoadddel.address_id = custordcustadddel.addr_no
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
    LEFT JOIN   person_info_tab persondel --For Delivery Rep names
           ON   custordcustdel.salesman_code = persondel.person_id
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
           AND  (
                    custinfo.corporate_form != 'KEY'
                        OR custinfo.corporate_Form IS NULL
                )
           AND  invhead.series_id || invhead.invoice_no NOT IN --Removes 2018 invoices per Frank Landino, 10-2019.
                (
                    'CR1001800123',
                    'CD1001814996',
                    'CR1001802096',
                    'CD1001851789'
                ) 
                
UNION ALL

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
                CASE
                    WHEN coalesce(inventpart.part_product_family, salchar.charge_group, 'OTHER') IN (
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
                        'EDU',
                        'DYNAC',
                        'RESTOCK',
                        'COMPT',
                        'MAGMA',
                        'ED'
                    )
                    THEN 'KEYSTONE'
                    WHEN coalesce(inventpart.part_product_family, salchar.charge_group, 'OTHER') IN (
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
                nvl(prodfamcft.cf$_kdprodfamtype,'SUND') AS product_type,
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
                CASE
                    WHEN inventpart.part_product_family IN 
                        (
                            'GNSIS',
                            'PRIMA',
                            'PRMA+',
                            'TLMAX',
                            'PCOMM',
                            'ODYSS'
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
                            'OTMED',
                            'PRSFT'
                        )
                    THEN 'NON-TILOBE'
                    WHEN inventpart.part_product_family IN 
                        (
                            'TRINX',
                            'EXHEX',
                            'ZMAX',
                            'OCT',
                            'EXORL'
                        )
                    THEN 'SI STYLE'
                    WHEN coalesce(inventpart.part_product_family, salchar.charge_group) IN 
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
                            'RESTOCK',
                            'IDENT',
                            'MAGMA'
                        )
                    THEN 'N/A'
                    ELSE 'UNCLASSIFIED'
                END AS connection,
                custordcustadd.region_code AS invoice_region_code,
                custord.salesman_code AS invoice_salesman_code,
                personout.name AS invoice_salesman_name,
                custordcustadddel.region_code AS delivery_region_code,
                custordcustdel.salesman_code AS delivery_salesman_code,
                persondel.name AS delivery_salesman_name,
                comrec.commission_receiver as delivery_commission_rec,
                personin.name AS delivery_commission_rec_name,
                custinfo.association_no AS invoice_association_no,
                invhead.identity AS invoice_customer_id,
                custinfo.name AS invoice_customer_name,
                custinfoadd.address_id AS invoice_address_id,
                custinfoadd.address1 AS invoice_street_1,
                custinfoadd.address2 AS invoice_street_2,
                custinfoadd.city AS invoice_city,
                custinfoadd.state AS invoice_state,
                custinfoadd.zip_code AS invoice_zip,
                custinfoadd.country AS invoice_country,
                custinfodel.association_no AS delivery_association_no,
                invhead.delivery_identity AS delivery_customer_id,
                custinfodel.name as delivery_customer_name,
                custinfoadddel.address_id AS delivery_address_id,
                custinfoadddel.address1 AS delivery_street_1,
                custinfoadddel.address2 AS delivery_street_2,
                custinfoadddel.city AS delivery_city,
                custinfoadddel.state AS delivery_state,
                custinfoadddel.zip_code AS delivery_zip,
                custinfoadddel.country AS delivery_country,
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
                nvl(invhead.n1, iimast.rate_used) AS currency_rate,
                (
                invitem.net_curr_amount / nullif(CASE
                                                     WHEN invhead.series_id = 'CR'
                                                      AND invhead.n2 IS NULL --Credit without RMA number and no product physically returned.
                                                     THEN 0
                                                     WHEN invhead.series_id = 'CR'
                                                      AND invhead.n2 IS NOT NULL --Credit with RMA number.
                                                     THEN invitem.n2 * - 1 --Invert the quantity.
                                                     ELSE invitem.n2
                                                 END, 0)) * nvl(invhead.n1, iimast.rate_used) AS unit_price_usd,
                invitem.net_curr_amount * nvl(invhead.n1,iimast.rate_used) AS total_price_usd

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
    LEFT JOIN   cust_ord_customer_tab custordcustdel --For delivery customer salesman code
           ON   invhead.delivery_identity = custordcustdel.customer_no
    LEFT JOIN   customer_info_tab custinfodel --For delivery customer info
           ON   invhead.delivery_identity = custinfodel.customer_id
    LEFT JOIN   customer_info_address_tab custinfoadd
           ON   invhead.identity = custinfoadd.customer_id
          AND   invhead.invoice_address_id = custinfoadd.address_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtype
           ON   invhead.identity = custinfoaddtype.customer_id
          AND   custinfoadd.address_id = custinfoaddtype.address_id
          AND   custinfoaddtype.address_type_code = 'INVOICE'
    LEFT JOIN   customer_info_address_tab custinfoadddel --For delivery address info
           ON   invhead.delivery_identity = custinfoadddel.customer_id
          AND   invhead.delivery_address_id = custinfoadddel.address_id
    LEFT JOIN   customer_info_address_type_tab custinfoaddtypedel --For delivery address info
           ON   invhead.delivery_identity = custinfoaddtypedel.customer_id
          AND   custinfoadddel.address_id = custinfoaddtypedel.address_id
          AND   custinfoaddtypedel.address_type_code = 'DELIVERY'          
    LEFT JOIN   cust_ord_customer_address_tab custordcustadd
           ON   invhead.identity = custordcustadd.customer_no
          AND   custinfoadd.address_id = custordcustadd.addr_no
    LEFT JOIN   cust_ord_customer_address_Tab custordcustadddel
           ON   invhead.delivery_identity = custordcustadddel.customer_no
          AND   custinfoadddel.address_id = custordcustadddel.addr_no
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
    LEFT JOIN   person_info_tab persondel --For Delivery Rep names
           ON   custordcustdel.salesman_code = persondel.person_id
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
          AND (
                custinfo.corporate_form != 'KEY'
                    OR custinfo.corporate_form IS NULL
              )
              
UNION ALL

    SELECT      sord.recid,
                'EURTBL' AS source,
                '240' AS company,
                'ROW' AS sales_market,
                'DIRECT' AS segment,
                'FRA' AS corporate_form,
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
                        'EDU',
                        'DYNAC',
                        'RESTOCK',
                        'COMPT',
                        'MAGMA',
                        'ED'
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
                    WHEN coalesce(inventpart.part_product_code,substr(upper(sord.productline),1,5)) = 'FREIGHT'
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
                            'PCOMM',
                            'ODYSS'
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
                            'OTMED',
                            'PRSFT'
                        )
                    THEN 'NON-TILOBE'
                    WHEN inventpart.part_product_family IN 
                        (
                            'TRINX',
                            'EXHEX',
                            'ZMAX',
                            'OCT',
                            'EXORL'
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
                            'RESTOCK',
                            'IDENT',
                            'MAGMA'
                        )
                    THEN 'N/A'
                    ELSE 'UNCLASSIFIED'
                END AS connection,
                'FRA' AS invoice_region_code,
                sord.salesrepid AS invoice_salesman_code,
                personout.name AS invoice_salesman_name,
                'FRA' As delivery_region_code,
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
                custinfoadd.city as delivery_city,
                custinfoadd.state AS delivery_state,
                custinfoadd.zip_code AS delivery_zip,
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
                NVL(inventpart.second_commodity,'OTHER') AS second_commodity,
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
          AND   (
                    custinfo.corporate_form != 'KEY'
                        OR custinfo.corporate_form IS NULL
                )
                
UNION ALL

    SELECT      sord.recid,
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
                        'EDU',
                        'DYNAC',
                        'RESTOCK',
                        'COMPT',
                        'MAGMA',
                        'ED'
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
                    WHEN coalesce(inventpart.part_product_code,substr(upper(sord.productline),1,5)) = 'FREIGHT'
                    THEN 'FREIGHT'
                    ELSE 'OTHER'
                END AS product_set,
                CASE
                    WHEN nvl(inventpart.part_product_family,substr(upper(sord.productline),1,5)) IN 
                        (
                            'GNSIS',
                            'PRIMA',
                            'PRMA+',
                            'TLMAX',
                            'PCOMM',
                            'ODYSS'
                        )
                    THEN 'TILOBE'
                    WHEN nvl(inventpart.part_product_family,substr(upper(sord.productline),1,5)) IN 
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
                    WHEN nvl(inventpart.part_product_family,substr(upper(sord.productline),1,5)) IN 
                        (
                            'COMM',
                            'PTCOM'
                        )
                    THEN 'COMMON'
                    WHEN nvl(inventpart.part_product_family,substr(upper(sord.productline),1,5)) = 'PCA'
                    THEN 'CONICAL'
                    WHEN nvl(inventpart.part_product_family,substr(upper(sord.productline),1,5)) IN 
                        (
                            'RENOV',
                            'RESTO',
                            'STAGE',
                            'SUST',
                            'XP1',
                            'OTMED',
                            'PRSFT'
                        )
                    THEN 'NON-TILOBE'
                    WHEN nvl(inventpart.part_product_family,substr(upper(sord.productline),1,5)) IN 
                        (
                            'TRINX',
                            'EXHEX',
                            'ZMAX',
                            'OCT',
                            'EXORL'
                        )
                    THEN 'SI STYLE'
                    WHEN nvl(inventpart.part_product_family,substr(upper(sord.productline),1,5)) IN 
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
                            'RESTOCK',
                            'IDENT',
                            'MAGMA'
                        )
                    THEN 'N/A'
                    ELSE 'UNCLASSIFIED'
                END AS connection,
                CASE WHEN sord.customerid IN ('DE55046','DE43125','DE29029','DE47206') THEN 'EURO'
                     WHEN sord.salesrepid IN ('220-510','220-520') THEN 'BENELUX'
                     ELSE 'GER'
                END AS invoice_region_code,    
                sord.salesrepid AS invoice_salesman_code,
                personout.name AS invoice_salesman_name,
                CASE WHEN sord.customerid IN ('DE55046','DE43125','DE29029','DE47206') THEN 'EURO'
                     WHEN sord.salesrepid IN ('220-510','220-520') THEN 'BENELUX'
                     ELSE 'GER'
                END AS delivery_region_code,
                sord.salesrepid AS delivery_salesman_code,
                personout.name as delivery_salesman_name,
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
                NVL(inventpart.second_commodity,'OTHER') AS second_commodity,
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
          AND   (
                    custinfo.corporate_form != 'KEY'
                        OR custinfo.corporate_form IS NULL
                )

UNION ALL

    SELECT      sord.recid,
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
                        'EDU',
                        'DYNAC',
                        'RESTOCK',
                        'COMPT',
                        'MAGMA',
                        'ED'
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
                            'PCOMM',
                            'ODYSS'
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
                            'OTMED',
                            'PRSFT'
                        )
                    THEN 'NON-TILOBE'
                    WHEN inventpart.part_product_family IN 
                        (
                            'TRINX',
                            'EXHEX',
                            'ZMAX',
                            'OCT',
                            'EXORL'
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
                            'RESTOCK',
                            'IDENT',
                            'MAGMA'
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
                nvl(inventpart.second_commodity,'OTHER') AS second_commodity,
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
          AND   (
                    custinfo.corporate_form != 'KEY'
                        OR custinfo.corporate_form IS NULL
                )

UNION ALL

    SELECT      sord.recid,
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
                        'EDU',
                        'DYNAC',
                        'RESTOCK',
                        'COMPT',
                        'MAGMA',
                        'ED'
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
                    WHEN coalesce(inventpart.part_product_code,substr(upper(sord.productline),1,5)) = 'FREIGHT'
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
                            'PCOMM',
                            'ODYSS'
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
                            'OTMED',
                            'PRSFT'
                        )
                    THEN 'NON-TILOBE'
                    WHEN inventpart.part_product_family IN 
                        (
                            'TRINX',
                            'EXHEX',
                            'ZMAX',
                            'OCT',
                            'EXORL'
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
                            'RESTOCK',
                            'IDENT',
                            'MAGMA'
                        )
                    THEN 'N/A'
                    ELSE 'UNCLASSIFIED'
                END AS connection,
                CASE WHEN sord.customerid IN ('IT002945','IT000387','IT000807','IT001014','IT000916','IT000921',
                                              'IT000465','IT003382','IT003484','IT003575','IT003656','IT003666',
                                              'IT003693','IT003940') THEN 'EURO'
                     ELSE 'ITL'
                END AS invoice_region_code,
                sord.salesrepid AS invoice_salesman_code,
                personout.name AS invoice_salesman_name,
                CASE WHEN sord.customerid IN ('IT002945','IT000387','IT000807','IT001014','IT000916','IT000921',
                                              'IT000465','IT003382','IT003484','IT003575','IT003656','IT003666',
                                              'IT003693','IT003940') THEN 'EURO'
                     ELSE 'ITL'
                END AS delivery_region_code,
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
                NVL(inventpart.second_commodity, 'OTHER') AS second_commodity,
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
          AND   (
                    custinfo.corporate_form != 'KEY'
                        OR Custinfo.corporate_form IS NULL
                )

UNION ALL

    SELECT      invhead.recid,
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
                        'EDU',
                        'DYNAC',
                        'RESTOCK',
                        'COMPT',
                        'MAGMA',
                        'ED'
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
                    WHEN inventpart.part_product_code = 'FREIGHT'
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
                            'PCOMM',
                            'ODYSS'
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
                            'OTMED',
                            'PRSFT'
                        )
                    THEN 'NON-TILOBE'
                    WHEN inventpart.part_product_family IN 
                        (
                            'TRINX',
                            'EXHEX',
                            'ZMAX',
                            'OCT',
                            'EXORL'
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
                            'RESTOCK',
                            'IDENT',
                            'MAGMA'
                        )
                    THEN 'N/A'
                    ELSE 'UNCLASSIFIED'
                END AS connection,
                custordcustadd.region_code AS invoice_region_code,
                custord.salesman_code AS invoice_salesman_code,
                personout.name AS invoice_salesman_name,
                custordcustadd.region_code AS delivery_region_code,
                custord.salesman_code AS delivery_salesman_code,
                personout.name AS delivery_salesman_name,
                comrec.commission_receiver AS delivery_commission_rec,
                personin.name AS delivery_commission_rec_name,
                custinfo.association_no invoice_association_no,
                invhead.key_code AS invoice_customer_id,
                custinfo.name AS invoice_customer_name,
                custinfoadd.address_id AS invoice_address_id,
                custinfoadd.address1 AS invoice_street_1,
                custinfoadd.address2 AS invoice_street_2,
                custinfoadd.city AS invoice_city,
                custinfoadd.state AS invoice_state,
                custinfoadd.zip_code AS invoice_zip,
                custinfoadd.country AS invoice_country,
                custinfo.association_no AS delivery_association_no,
                invhead.key_code AS delivery_customer_id,
                custinfo.name AS delivery_customer_name,
                custinfoadddel.address_id AS delivery_address_id,
                custinfoadddel.address1 AS delivery_street_1,
                custinfoadddel.address2 AS delivery_street_2,
                custinfoadddel.city AS delivery_city,
                custinfoadddel.state AS delivery_state,
                custinfoadddel.zip_code AS delivery_zip,
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
        
        WHERE   (
                    custinfo.corporate_form != 'KEY'
                        OR custinfo.corporate_form IS NULL
                )
                
UNION ALL

    SELECT     invhead.recid,
                'PTLTD' AS source,
                '300' AS company,
                'ROW' AS sales_market,
                CASE 
                    WHEN invhead.salesmngr IN ('DISTRIB','DIST IL')
                    THEN 'DISTRIBUTION'
                    WHEN invhead.salesmngr IN ('DIRECT','DIRECT IL','DIRECT EX')
                    THEN 'DIRECT'
                    ELSE 'OTHER'
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
                'PALTOP' AS product_brand,
                CASE
                    WHEN prodfamcft.cf$_kdprodfamtype IS NOT NULL
                    THEN prodfamcft.cf$_kdprodfamtype
                    WHEN invhead.invent_item_group_name = 'DIGITAL'
                    THEN invhead.invent_item_group_name
                    ELSE 'SUND'
                END AS product_type,
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
                CASE
                    WHEN UPPER(invhead.invent_item_group_name) IN 
                        (
                            'PAI IMPLANTS',
                            'DYNAMIC IMPLANTS',
                            'DIVA IMPLANTS',
                            'DYNAMIC IMPLANTS',
                            'ADVANCED IMPLANTS',
                            'ADVANCED PLUS IMPLANTS'
                        )  
                    THEN 'INTERNAL HEX'
                    WHEN UPPER(invhead.invent_item_group_name) IN
                        (
                            'CONICAL CONNECTION IMPLANTS'
                        )
                    THEN 'CONICAL'
                    WHEN UPPER(invhead.invent_item_group_name) IN
                        (
                            'PEEK ABUTMENTS',
                            'COBALT CHROME ABUTMENTS',
                            'TITANIUM ABUTMENTS',
                            'MULTI UNIT ABUTMENTS',
                            'IMPRESSION COPING',
                            'HEALING CAPS',
                            'SCREWS',
                            'TOOLS',
                            'CASTABLE ABUTMENTS',
                            'KITS',
                            'CONICAL HEALING CAPS',
                            'CONICAL TITANIUM ABUTMENTS'
                        )
                    THEN 'COMMON'
                    WHEN UPPER(invhead.invent_item_group_name) IN
                        (
                            'DIGITAL',
                            'PACKAGING MATERIALS'
                        )
                        OR invhead.itemno = '97-00001'
                    THEN 'N/A'                    
                    ELSE 'UNCLASSIFIED'
                END AS connection,
                invhead.territory AS invoice_region_code,
                'PTLTD' AS invoice_salesman_code,
                invhead.sales_group AS invoice_salesman_name,
                invhead.territory AS delivery_region_code,
                'PTLTD' AS delivery_salesman_code,
                invhead.sales_group AS delivery_salesman_name,
                NULL AS delivery_commission_rec,
                NULL AS delivery_commission_rec_name,
                NULL AS invoice_association_no,
                invhead.customerno AS invoice_customer_id,
                invhead.customer AS invoice_customer_name,
                NULL AS invoice_address_id,
                invhead.invstreet AS invoice_street_1,
                NULL AS invoice_street_2,
                invhead.invcity AS invoice_city,
                invhead.invstate AS invoice_state,
                invhead.invzip AS invoice_zip,
                invhead.invcountry AS invoice_country,
                NULL AS delivery_association_no,
                invhead.customerno AS delivery_customer_id,
                invhead.customer as delivery_customer_name,
                NULL AS delivery_address_id,
                invhead.delivstreet AS delivery_street_1,
                NULL AS delivery_street_2,
                invhead.delivcity AS delivery_city,
                invhead.delivstate AS delivery_state,
                invhead.delivzip AS delivery_zip,
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
                    THEN 'PAI'
                    WHEN UPPER(invhead.invent_item_group_name) = 'ADVANCED PLUS IMPLANTS'
                    THEN 'ADVN+'
                    WHEN UPPER(invhead.invent_item_group_name) = 'ADVANCED IMPLANTS'
                    THEN 'ADVNC'
                    WHEN UPPER(invhead.invent_item_group_name) = 'CONICAL CONNECTION IMPLANTS'
                    THEN 'PCA'
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
                                                                   'KITS',
                                                                   'CONICAL HEALING CAPS',
                                                                   'CONICAL TITANIUM ABUTMENTS')
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
                    THEN 'PAI'
                    WHEN UPPER(invhead.invent_item_group_name) = 'ADVANCED PLUS IMPLANTS'
                    THEN 'ADVN+'
                    WHEN UPPER(invhead.invent_item_group_name) = 'ADVANCED IMPLANTS'
                    THEN 'ADVNC'
                    WHEN UPPER(invhead.invent_item_group_name) = 'CONICAL CONNECTION IMPLANTS'
                    THEN 'PCA'
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
                                                                   'KITS',
                                                                   'CONICAL HEALING CAPS',
                                                                   'CONICAL TITANIUM ABUTMENTS')
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
        WHERE   
                (
                    invhead.salesmngr NOT IN 
                        (
                            'DORIT AVIV',
                            'MARKETING',
                            'R' || CHR(38) || 'D'
                        ) OR
                    invhead.salesmngr IS NULL
                )
          AND   invhead.customerno NOT IN 
                    (
                        'Cust1002664',
                        'Cust1002656',
                        'Cust1002224'
                    )
                    
UNION ALL

    SELECT      invhead.recid,
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
                'PALTOP' AS product_brand,
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
                CASE
                    WHEN inventpart.part_product_family IN 
                        (
                            'GNSIS',
                            'PRIMA',
                            'PRMA+',
                            'TLMAX',
                            'PCOMM',
                            'ODYSS'
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
                            'OTMED',
                            'PRSFT'
                        )
                    THEN 'NON-TILOBE'
                    WHEN inventpart.part_product_family IN 
                        (
                            'TRINX',
                            'EXHEX',
                            'ZMAX',
                            'OCT',
                            'EXORL'
                        )
                    THEN 'SI STYLE'
                    WHEN inventpart.part_product_family IN 
                        (
                            'BVINE',
                            'CONNX',
                            'CYTOP',
                            'DYNAB',
                            'DYNAG',
                            'DYNAM',
                            'MTF',
                            'SYNTH',
                            'PALTOP BIO',
                            'EG',
                            'OTHER',
                            'MOTOR',
                            'FREIGHT',
                            'IDENT'
                        )
                        OR invhead.itemno = '97-00001'
                    THEN 'N/A'
                    ELSE 'UNCLASSIFIED'
                END AS connection,
                custordcustadd.region_code AS invoice_region_code,
                custord.salesman_code AS invoice_salesman_code,
                personout.name AS invoice_salesman_name,
                custordcustadd.region_code AS delivery_region_code,
                custord.salesman_code AS delivery_salesman_code,
                personout.name AS delivery_salesman_name,
                comrec.commission_receiver AS delivery_commission_rec,
                personin.name AS delivery_commission_rec_name,
                custinfo.association_no AS invoice_association_no,
                NVL(custmap.kd_cust_id,invhead.customerno) AS invoice_customer_id,
                NVL(custinfo.name,invhead.customer) AS invoice_customer_name,
                custinfoadd.address_id AS invoice_address_id,
                custinfoadd.address1 AS invoice_street_1,
                custinfoadd.address2 AS invoice_street_2,
                custinfoadd.city AS invoice_city,
                custinfoadd.state AS invoice_state,
                custinfoadd.zip_code AS invoice_zip,
                custinfoadd.country AS invoice_country,
                custinfo.association_no AS delivery_association_no,
                NVL(custmap.kd_cust_id,invhead.customerno) AS delivery_customer_id,
                NVL(custinfo.name,invhead.customer) AS delivery_customer_name,                
                custinfoadddel.address_id AS delivery_address_id,
                custinfoadddel.address1 AS delivery_street_1,
                custinfoadddel.address2 AS delivery_street_2,
                custinfoadddel.city AS delivery_city,
                custinfoadddel.state AS delivery_state,
                custinfoadddel.zip_code AS delivery_zip,
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
        
        WHERE   (custinfo.corporate_form != 'KEY' OR custinfo.corporate_form IS NULL)
          AND   invhead.customerno != 'Cust1002028'
;
    
CREATE UNIQUE INDEX "IFSAPP"."KD_SALES_CUBE_RECID" ON "IFSAPP"."KD_SALES_CUBE" ("RECID") 
    PCTFREE 10 
    INITRANS 2 
    MAXTRANS 167 
    COMPUTE STATISTICS 
    STORAGE
        (
            INITIAL 65536 
            NEXT 1048576 
            MINEXTENTS 1 
            MAXEXTENTS 2147483645
            PCTINCREASE 0 
            FREELISTS 1 
            FREELIST GROUPS 1
            BUFFER_POOL DEFAULT 
            FLASH_CACHE DEFAULT 
            CELL_FLASH_CACHE DEFAULT
        )
    TABLESPACE "IFSAPP_DATA" ;

--CREATE INDEX kd_sales_cube_yqm ON kd_sales_cube (invoice_year, invoice_month, invoice_quarter);
--CREATE INDEX kd_sales_cube_inv_year ON kd_sales_cube (invoice_year);
--CREATE INDEX kd_sales_cube_inv_quarter ON kd_sales_cube (invoice_quarter);
--CREATE INDEX kd_sales_cube_inv_mo ON kd_sales_cube (invoice_month);
--CREATE INDEX kd_sales_cube_family ON kd_sales_cube (part_product_family);
--CREATE INDEX kd_sales_cube_code ON kd_sales_cube (part_product_code);
--CREATE INDEX kd_sales_cube_sales_market ON kd_sales_cube (sales_market);
--CREATE INDEX kd_sales_cube_segment ON kd_sales_cube (segment);
--CREATE INDEX kd_sales_cube_corporate_form ON kd_sales_cube (corporate_form);
--CREATE INDEX kd_sales_cube_brand ON kd_sales_cube (product_brand);
--CREATE INDEX kd_sales_cube_type ON kd_sales_cube (product_type);
--CREATE INDEX kd_sales_cube_prod_set ON kd_sales_cube (product_set);
--CREATE INDEX kd_sales_cube_connection ON kd_sales_cube (connection);
--CREATE INDEX kd_sales_cube_inv_region ON kd_sales_cube (invoice_region_code);
--CREATE INDEX kd_sales_cube_inv_salesman ON kd_sales_cube (invoice_salesman_code);
--CREATE INDEX kd_sales_cube_inv_custid ON kd_sales_cube (invoice_customer_id);
--CREATE INDEX kd_sales_cube_order ON kd_sales_cube (order_id);
--CREATE INDEX kd_sales_cube_invoice ON kd_sales_cube (invoice_id);
--CREATE INDEX kd_sales_cube_secondcomm ON kd_sales_cube (second_commodity);
--CREATE INDEX kd_sales_cube_catalog_no ON kd_sales_cube (catalog_no);
