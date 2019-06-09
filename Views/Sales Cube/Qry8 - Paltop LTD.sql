       SELECT   invhead.recid,
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
                invhead.invstreet AS invoice_street_1,
                NULL AS invoice_street_2,
                invhead.invcity AS invoice_city,
                invhead.invstate AS invoice_state,
                invhead.invzip AS invoice_zip,
                invhead.invcountry AS invoice_country,
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