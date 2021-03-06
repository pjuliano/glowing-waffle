CREATE OR REPLACE VIEW KD_SALES_CUBE_TEST_QRY2 AS
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
                        'RESTOCK'
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