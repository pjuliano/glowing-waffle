CREATE OR REPLACE VIEW kd_sales_cube_test_qry1 AS
SELECT
                invitem.company || invhead.series_id || invhead.invoice_no || to_char(invitem.item_id) || to_char(invhead.invoice_date,'MMDDYYYY') AS recid,
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
                            'RESTOCK'
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
                coalesce(invhead.delivery_identity,invhead.identity) AS delivery_customer_id,
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
                    WHEN invitem.c1 IS NOT NULL
                    THEN invitem.item_id
                    ELSE NULL 
                END AS rma_line,
                custorder.market_code,
                invhead.pay_term_id,
                invhead.currency AS order_currency,
                to_char(invhead.d1, 'YYYY') AS order_entry_year,
                to_char(invhead.d1, 'Q') AS order_entry_quarter,
                to_char(invhead.d1, 'MM') AS order_entry_month,
                trunc(invhead.d1) AS order_entry_date,
                to_char(invhead.invoice_date, 'YYYY') AS invoice_year,
                to_char(invhead.invoice_date, 'Q') AS invoice_quarter,
                to_char(invhead.invoice_date, 'MM') AS invoice_month,
                trunc(invhead.invoice_date) AS invoice_date,
                invhead.series_id || invhead.invoice_no AS invoice_id,
                to_char(invitem.item_id) AS item_id,
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
                invitem.net_curr_amount / nullif
                    (
                        CASE
                            WHEN invhead.series_id = 'CR'
                                AND invhead.n2 IS NULL --Credit without RMA number and no product physically returned.
                            THEN 0
                            WHEN invhead.series_id = 'CR'
                                AND invhead.n2 IS NOT NULL --Credit with RMA number.
                            THEN invitem.n2 * - 1 --Invert the quantity.
                            ELSE invitem.n2
                        END, 
                        0
                    ) AS unit_price,
                invitem.net_curr_amount AS total_price,
                coalesce(invhead.n1,invhead.curr_rate) AS currency_rate,
                (
                    invitem.net_curr_amount / nullif
                        (
                            CASE
                                WHEN invhead.series_id = 'CR'
                                    AND invhead.n2 IS NULL --Credit without RMA number and no product physically returned.
                                THEN 0
                                WHEN invhead.series_id = 'CR'
                                    AND invhead.n2 IS NOT NULL --Credit with RMA number.
                                THEN invitem.n2 * - 1 --Invert the quantity.
                                ELSE invitem.n2
                            END, 
                            0
                        )
                ) * coalesce(invhead.n1,invhead.curr_rate) AS unit_price_usd,
                invitem.net_curr_amount * coalesce(invhead.n1,invhead.curr_rate) AS total_price_usd

FROM   
                invoice_tab invhead
                LEFT JOIN invoice_item_tab invitem
                    ON invhead.invoice_id = invitem.invoice_id
                        AND invhead.company = invitem.company
                LEFT JOIN sales_part_tab salespart
                    ON invitem.c5 = salespart.catalog_no
                        AND decode(invitem.company, '241', '240', invitem.company) = salespart.contract
                LEFT JOIN inventory_part_tab inventpart
                    ON invitem.c5 = inventpart.part_no
                        AND decode(invitem.company, '241', '240', invitem.company) = inventpart.contract
                LEFT JOIN customer_info_tab custinfo
                    ON invhead.identity = custinfo.customer_id
                LEFT JOIN cust_ord_customer_tab custordcustdel --For delivery customer salesman code
                    ON coalesce(invhead.delivery_identity,invhead.identity) = custordcustdel.customer_no
                LEFT JOIN customer_info_tab custinfodel --For delivery customer info
                    ON coalesce(invhead.delivery_identity,invhead.identity) = custinfodel.customer_id
                LEFT JOIN customer_info_address_tab custinfoadd --For invoice address info
                    ON invhead.identity = custinfoadd.customer_id
                        AND invhead.invoice_address_id = custinfoadd.address_id
                LEFT JOIN customer_info_address_type_tab custinfoaddtype --For invoice address info
                    ON invhead.identity = custinfoaddtype.customer_id
                        AND custinfoadd.address_id = custinfoaddtype.address_id
                        AND custinfoaddtype.address_type_code = 'INVOICE'
                LEFT JOIN customer_info_address_tab custinfoadddel --For delivery address info
                    ON coalesce(invhead.delivery_identity,invhead.identity) = custinfoadddel.customer_id
                        AND invhead.delivery_address_id = custinfoadddel.address_id
                LEFT JOIN customer_info_address_type_tab custinfoaddtypedel --For delivery address info
                    ON coalesce(invhead.delivery_identity,invhead.identity) = custinfoaddtypedel.customer_id
                        AND custinfoadddel.address_id = custinfoaddtypedel.address_id
                        AND custinfoaddtypedel.address_type_code = 'DELIVERY'
                LEFT JOIN cust_ord_customer_address_tab custordcustadd
                    ON invhead.identity = custordcustadd.customer_no
                        AND custinfoadd.address_id = custordcustadd.addr_no
                LEFT JOIN cust_ord_customer_address_tab custordcustadddel
                    ON  coalesce(invhead.delivery_identity,invhead.identity) = custordcustadddel.customer_no
                        AND  custinfoadddel.address_id = custordcustadddel.addr_no
                LEFT JOIN cust_ord_customer_tab custord
                    ON invhead.identity = custord.customer_no
                LEFT JOIN customer_order_tab custorder
                    ON invitem.c1 = custorder.order_no
                        AND invitem.company = custorder.contract
                LEFT JOIN cust_def_com_receiver_tab comrec
                    ON invhead.identity = comrec.customer_no
                LEFT JOIN commission_receiver_tab comrecdef
                    ON comrec.commission_receiver = comrecdef.commission_receiver
                LEFT JOIN person_info_tab personout --For Outside Rep names
                    ON custord.salesman_code = personout.person_id
                LEFT JOIN person_info_tab personin --For Inside Rep names
                    ON comrecdef.salesman_code = personin.person_id
                LEFT JOIN person_info_tab persondel --For Delivery Rep names
                    ON custordcustdel.salesman_code = persondel.person_id
                LEFT JOIN customer_order_address_tab custordadd
                    ON invitem.c1 = custordadd.order_no
                LEFT JOIN sales_charge_type_tab salchar
                    ON invitem.c5 = salchar.charge_type
                        AND decode(invitem.company, '241', '240', invitem.company) = salchar.company
                LEFT JOIN inventory_product_family prodfam 
                    ON inventpart.part_product_family = prodfam.part_product_family
                LEFT JOIN inventory_product_family_cft prodfamcft
                    ON prodfam.objkey = prodfamcft.rowkey
                    
WHERE           
                invhead.series_id != 'CI'
                    AND invhead.party_type = 'CUSTOMER'
                    AND invhead.rowstate != 'Preliminary'
                    AND invhead.rowstate != 'Cancelled'
                    AND 
                        (
                            custinfo.corporate_form != 'KEY'
                                OR custinfo.corporate_form IS NULL
                        )
                    --Exclude errored invoices in 2018 data.
                     AND  invhead.series_id || invhead.invoice_no NOT IN 
                        (
                            'CR1001800123',
                            'CD1001814996',
                            'CR1001802096',
                            'CD1001851789'
                        )