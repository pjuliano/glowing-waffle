create or replace view kd_sales_data AS
  SELECT
        decode(a.company,'241','240',a.company) AS site,
        b.series_id || b.invoice_no AS invoice_id,
        to_char(a.item_id) AS item_id,
        trunc(b.d2) AS invoicedate,
        CASE
                WHEN b.series_id = 'CR' AND
                     b.n2 IS NULL THEN 0
                WHEN b.series_id = 'CR' AND
                     b.n2 IS NOT NULL THEN a.n2 *-1
                ELSE a.n2
            END
        AS invoiced_qty,
        a.n4 AS sale_unit_price,
        a.n5 AS discount,
        a.net_curr_amount,
        a.net_curr_amount + a.vat_curr_amount AS gross_curr_amount,
        c.catalog_desc,
        customer_info_api.get_name(b.identity) AS customer_name,
        a.c1 AS order_no,
        a.c13 AS customer_no,
        d.cust_grp,
        a.c5 AS catalog_no,
        substr(b.c1,1,35) AS authorize_code,
        d.salesman_code,
        e.commission_receiver,
        f.district_code,
        f.region_code,
        trunc(b.creation_date) AS createdate,
        decode(a.c5,g.part_no,g.part_product_code,'OTHER') AS part_product_code,
        decode(a.c5,g.part_no,g.part_product_family,'OTHER') AS part_product_family,
        decode(a.c5,g.part_no,g.second_commodity,'OTHER') AS second_commodity,
        CASE
                WHEN to_char(b.d2,'MM') = '01' THEN 'January'
                WHEN to_char(b.d2,'MM') = '02' THEN 'February'
                WHEN to_char(b.d2,'MM') = '03' THEN 'March'
                WHEN to_char(b.d2,'MM') = '04' THEN 'April'
                WHEN to_char(b.d2,'MM') = '05' THEN 'May'
                WHEN to_char(b.d2,'MM') = '06' THEN 'June'
                WHEN to_char(b.d2,'MM') = '07' THEN 'July'
                WHEN to_char(b.d2,'MM') = '08' THEN 'August'
                WHEN to_char(b.d2,'MM') = '09' THEN 'September'
                WHEN to_char(b.d2,'MM') = '10' THEN 'October'
                WHEN to_char(b.d2,'MM') = '11' THEN 'November'
                WHEN to_char(b.d2,'MM') = '12' THEN 'December'
            END
        AS invoicemonth,
        CASE
                WHEN to_char(b.d2,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN to_char(b.d2,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN to_char(b.d2,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN to_char(b.d2,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS invoiceqtr,
        CASE
                WHEN to_char(b.d2,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM b.d2)
                WHEN to_char(b.d2,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM b.d2)
                WHEN to_char(b.d2,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM b.d2)
                WHEN to_char(b.d2,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM b.d2)
            END
        AS invoiceqtryr,
        to_char(b.d2,'MM/YYYY') AS invoicemthyr,
        q.group_id AS group_id,
        decode(a.c5,g.part_no,g.type_designation,'Non-Target') AS type_designation,
        a.identity AS customer_no_pay,
        h.corporate_form,
        decode(b.currency,'SEK', (a.net_curr_amount * 0.13),'EUR', (a.net_curr_amount * 1.4),'DKK', (a.net_curr_amount * 0.13),a.net_curr_amount) AS fixedamounts,
        CASE
                WHEN b.currency = 'CAD' AND
                     trunc(b.d2) >= TO_DATE('03/01/2013','MM/DD/YYYY') AND
                     trunc(b.d2) <= TO_DATE('12/16/2019','MM/DD/YYYY') 
                THEN a.net_curr_amount
                WHEN b.currency = 'CAD' AND
                     trunc(b.d2) > TO_DATE('12/16/2019','MM/DD/YYYY')
                THEN a.net_curr_amount * coalesce(b.n1,b.curr_rate)
                WHEN b.currency != 'USD' 
                THEN a.net_curr_amount * i.currency_rate
                ELSE a.net_curr_amount
            END
        AS allamounts,
        CASE
                WHEN b.currency IN (
                    'SEK',
                    'DKK'
                ) THEN a.net_curr_amount / j.currency_rate
                ELSE a.net_curr_amount
            END
        AS localamount,
        a.net_curr_amount AS truelocalamt,
        a.vat_dom_amount,
        a.vat_code,
        CASE
                WHEN a.c5 = k.part_no THEN k.inventory_value
                ELSE l.inventory_value * 1.4
            END
        AS cost,
        'Parts' AS charge_type,
        'IFS' AS source,
        m.market_code,
        h.association_no,
        b.vat_curr_amount,
        payment_term_api.get_description(b.company,b.pay_term_id) AS pay_term_description,
        substr(b.c1,1,35) AS kdreference,
        substr(b.c2,1,30) AS customerref,
        to_char(b.d3,'MM/DD/YYYY') AS deliverydate,
        substr(b.c3,1,35) AS ship_via,
        b.delivery_identity,
        b.identity,
        b.delivery_address_id,
        b.invoice_address_id,
        b.currency,
        b.n2 AS rma_no,
        n.address1 AS invoiceadd1,
        n.address2 AS invoiceadd2,
        n.city AS invoicecity,
        n.state AS invoicestate,
        n.zip_code AS invoicezip,
        iso_country_api.decode(n.country) AS invoicecountry,
        n.county AS invoicecounty,
        o.address1 AS delivadd1,
        o.address2 AS delivadd2,
        o.city AS delivcity,
        o.state AS delivstate,
        o.zip_code AS delivzip,
        iso_country_api.decode(o.country) AS delivcountry,
        o.county AS delivcounty
    FROM
        invoice_item_tab a
        LEFT JOIN sales_part_tab c ON a.c5 = c.catalog_no AND
                                      decode(a.company,'241','240',a.company) = c.contract
        LEFT JOIN cust_def_com_receiver_tab e ON a.c13 = e.customer_no
        LEFT JOIN inventory_part_tab g ON a.c5 = g.part_no AND
                                          decode(a.company,'241','240',a.company) = g.contract
        LEFT JOIN kd_cost_100 k ON a.c5 = k.part_no
        LEFT JOIN kd_cost_210 l ON a.c5 = l.part_no
        LEFT JOIN customer_order_tab m ON a.c1 = m.order_no
        LEFT JOIN identity_invoice_info_tab q ON a.company = q.company AND
                                                 a.identity = q.identity AND
                                                 a.party_type = q.party_type,invoice_tab b
        LEFT JOIN kd_currency_rate_4 i ON b.currency = i.currency_code AND
                                          to_char(b.d2,'MM/YYYY') = i.valid_from
        LEFT JOIN customer_info_address_tab n ON b.identity = n.customer_id AND
                                                 b.invoice_address_id = n.address_id
        LEFT JOIN customer_info_address_tab o ON b.identity = o.customer_id AND
                                                 b.delivery_address_id = o.address_id
        LEFT JOIN kd_currency_rate_1 j ON b.currency = j.currency_code AND
                                          to_char(b.d2,'MM/YYYY') = j.valid_from,
        cust_ord_customer_tab d,
        cust_ord_customer_address_tab f,
        customer_info_tab h
    WHERE
        a.invoice_id = b.invoice_id AND
        a.c11 IS NULL AND
        a.c13 = d.customer_no AND
        b.delivery_identity = d.customer_no AND
        a.c13 = f.customer_no AND
        a.c13 = h.customer_id AND
        h.customer_id = d.customer_no AND
        h.customer_id = f.customer_no AND
        b.delivery_identity = h.customer_id AND
        b.rowstate != 'Preliminary' AND
        f.addr_no = '99' AND
        trunc(b.d2) >= TO_DATE('01/01/2008','MM/DD/YYYY')
    UNION ALL
    SELECT
        '220' AS site,
        a.invoiceno AS invoice_id,
        to_char(a.itemid) AS item_id,
        trunc(a.salesdate) AS invoicedate,
        a.quantity AS invoiced_qty,
        a.unitprice AS sales_unit_price,
        a.discount,
        0 AS net_curr_amount,
        0 AS gross_curr_amount,
        a.partdescription AS catalog_desc,
        a.customername AS customer_name,
        a.ordernumber AS order_no,
        a.customerid AS customer_no,
        ' ' AS cust_grp,
        a.salespartno AS catalog_no,
        ' ' AS authorize_code,
        b.salesman_code,
        ' ' AS commission_receiver,
        ' ' AS district_code,
        decode(a.salesrepid,'220-510','BENELUX','220-520','BENELUX','GER') AS region_code,
        a.salesdate AS createdate,
        upper(a.productcode) AS part_product_code,
        upper(a.productline) AS part_product_family,
        ' ' AS second_commodity,
        CASE
                WHEN to_char(a.salesdate,'MM') = '01' THEN 'January'
                WHEN to_char(a.salesdate,'MM') = '02' THEN 'February'
                WHEN to_char(a.salesdate,'MM') = '03' THEN 'March'
                WHEN to_char(a.salesdate,'MM') = '04' THEN 'April'
                WHEN to_char(a.salesdate,'MM') = '05' THEN 'May'
                WHEN to_char(a.salesdate,'MM') = '06' THEN 'June'
                WHEN to_char(a.salesdate,'MM') = '07' THEN 'July'
                WHEN to_char(a.salesdate,'MM') = '08' THEN 'August'
                WHEN to_char(a.salesdate,'MM') = '09' THEN 'September'
                WHEN to_char(a.salesdate,'MM') = '10' THEN 'October'
                WHEN to_char(a.salesdate,'MM') = '11' THEN 'November'
                WHEN to_char(a.salesdate,'MM') = '12' THEN 'December'
            END
        AS invoicemonth,
        CASE
                WHEN to_char(a.salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN to_char(a.salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN to_char(a.salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN to_char(a.salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS invoiceqtr,
        CASE
                WHEN to_char(a.salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
            END
        AS invoiceqtryr,
        to_char(a.salesdate,'MM/YYYY') AS invoicemthyr,
        ' ' AS group_id,
        'Sub-Part' AS type_designation,
        ' ' AS customer_no_pay,
        decode(a.salesrepid,'220-510','BENELUX','220-520','BENELUX','GER') AS corporate_form,
        a.amount * 1.4 AS fixedamounts,
        a.amount * i.currency_rate AS allamounts,
        a.amount AS localamount,
        a.amount AS truelocalamt,
        0 AS vat_dom_amount,
        ' ' AS vat_code,
        decode(a.salespartno,c.part_no,c.inventory_value,d.part_no,d.inventory_value * 1.4) AS cost,
        'Parts' AS charge_type,
        'GER' AS source,
        'Market' AS market_code,
        ' ' AS association_no,
        0 AS vat_curr_amount,
        ' ' AS pay_term_description,
        ' ' AS kdreference,
        ' ' AS customerref,
        ' ' AS deliverydate,
        ' ' AS ship_via,
        ' ' AS delivery_identity,
        ' ' AS identity,
        ' ' AS delivery_address_id,
        ' ' AS invoice_address_id,
        'EUR' AS currency,
        0 AS rma_no,
        ' ' AS invoiceadd1,
        ' ' AS invoiceadd2,
        ' ' AS invoicecity,
        ' ' AS invoicestate,
        ' ' AS invoicezip,
        ' ' AS invoicecountry,
        ' ' AS invoicecounty,
        ' ' AS delivadd1,
        ' ' AS delivadd2,
        ' ' AS delivcity,
        ' ' AS delivstate,
        ' ' AS delivzip,
        ' ' AS delivcountry,
        ' ' AS delivcounty
    FROM
        srordersger a
        LEFT JOIN cust_ord_customer_tab b ON a.customerid = b.customer_no
        LEFT JOIN kd_currency_rate_4 i ON to_char(a.salesdate,'MM/YYYY') = i.valid_from
        LEFT JOIN inventory_part_unit_cost_sum c ON a.salespartno = c.part_no AND
                                                    c.contract = '100'
        LEFT JOIN inventory_part_unit_cost_sum d ON a.salespartno = d.part_no AND
                                                    d.contract = '210'
    WHERE
        a.salesrepid IN (
            '220-100',
            '220-110',
            '220-120',
            '220-140',
            '220-145',
            '220-150',
            '220-160',
            '220-170',
            '220-180',
            '220-190',
            '220-200',
            '220-210',
            '220-220',
            '220-230',
            '220-540',
            '220-550',
            '220-510',
            '220-520',
            '220-600',
            '220-610',
            '220-650',
            '220-950',
            '220-998'
        ) AND
        a.customerid NOT IN (
            'DE43125',
            'DE160010',
            'DE47206',
            'DE35092',
            'DE35084',
            'DE29029',
            'DE55046'
        ) AND
        a.salesdate >= TO_DATE('01/01/2008','MM/DD/YYYY') AND
        i.currency_code = 'EUR'
    UNION ALL
    SELECT
        '240' AS site,
        a.invoiceno AS invoice_id,
        to_char(a.itemid) AS item_id,
        trunc(a.salesdate) AS invoicedate,
        a.quantity AS invoiced_qty,
        0 AS sales_unit_price,
        a.discount,
        0 AS net_curr_amount,
        0 AS gross_curr_amount,
        a.partdescription AS catalog_desc,
        a.customername AS customer_name,
        a.ordernumber AS order_no,
        a.customerid AS customer_no,
        ' ' AS cust_grp,
        a.salespartno AS catalog_no,
        ' ' AS authorize_code,
        b.salesman_code,
        ' ' AS commission_receiver,
        ' ' AS district_code,
        'FRA' AS region_code,
        a.salesdate AS createdate,
        upper(a.productcode) AS part_product_code,
        upper(a.productline) AS part_product_family,
        ' ' AS second_commodity,
        CASE
                WHEN to_char(a.salesdate,'MM') = '01' THEN 'January'
                WHEN to_char(a.salesdate,'MM') = '02' THEN 'February'
                WHEN to_char(a.salesdate,'MM') = '03' THEN 'March'
                WHEN to_char(a.salesdate,'MM') = '04' THEN 'April'
                WHEN to_char(a.salesdate,'MM') = '05' THEN 'May'
                WHEN to_char(a.salesdate,'MM') = '06' THEN 'June'
                WHEN to_char(a.salesdate,'MM') = '07' THEN 'July'
                WHEN to_char(a.salesdate,'MM') = '08' THEN 'August'
                WHEN to_char(a.salesdate,'MM') = '09' THEN 'September'
                WHEN to_char(a.salesdate,'MM') = '10' THEN 'October'
                WHEN to_char(a.salesdate,'MM') = '11' THEN 'November'
                WHEN to_char(a.salesdate,'MM') = '12' THEN 'December'
            END
        AS invoicemonth,
        CASE
                WHEN to_char(a.salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN to_char(a.salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN to_char(a.salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN to_char(a.salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS invoiceqtr,
        CASE
                WHEN to_char(a.salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
            END
        AS invoiceqtryr,
        to_char(a.salesdate,'MM/YYYY') AS invoicemthyr,
        ' ' AS group_id,
        'Sub-Part' AS type_designation,
        ' ' AS customer_no_pay,
        'FRA' AS corporate_form,
        a.amount * 1.4 AS fixedamounts,
        a.amount * i.currency_rate AS allamounts,
        a.amount AS localamount,
        a.amount AS truelocalamt,
        0 AS vat_dom_amount,
        ' ' AS vat_code,
        decode(a.salespartno,c.part_no,c.inventory_value,d.part_no,d.inventory_value * 1.4) AS cost,
        'Parts' AS charge_type,
        'FRA' AS source,
        'Market' AS market_code,
        ' ' AS association_no,
        0 AS vat_curr_amount,
        ' ' AS pay_term_description,
        ' ' AS kdreference,
        ' ' AS customerref,
        ' ' AS deliverydate,
        ' ' AS ship_via,
        ' ' AS delivery_identity,
        ' ' AS identity,
        ' ' AS delivery_address_id,
        ' ' AS invoice_address_id,
        'EUR' AS currency,
        0 AS rma_no,
        ' ' AS invoiceadd1,
        ' ' AS invoiceadd2,
        ' ' AS invoicecity,
        ' ' AS invoicestate,
        ' ' AS invoicezip,
        ' ' AS invoicecountry,
        ' ' AS invoicecounty,
        ' ' AS delivadd1,
        ' ' AS delivadd2,
        ' ' AS delivcity,
        ' ' AS delivstate,
        ' ' AS delivzip,
        ' ' AS delivcountry,
        ' ' AS delivcounty
    FROM
        srordersfra a
        LEFT JOIN cust_ord_customer_tab b ON a.customerid = b.customer_no
        LEFT JOIN kd_currency_rate_4 i ON to_char(a.salesdate,'MM/YYYY') = i.valid_from
        LEFT JOIN inventory_part_unit_cost_sum c ON a.salespartno = c.part_no AND
                                                    c.contract = '100'
        LEFT JOIN inventory_part_unit_cost_sum d ON a.salespartno = d.part_no AND
                                                    d.contract = '210'
    WHERE
        a.customerid != 'FR0672' AND
        a.salesdate >= TO_DATE('01/01/2008','MM/DD/YYYY') AND
        i.currency_code = 'EUR'
    UNION ALL
    SELECT
        '210' AS site,
        a.invoiceno AS invoice_id,
        to_char(a.itemid) AS item_id,
        trunc(a.salesdate) AS invoicedate,
        a.quantity AS invoiced_qty,
        0 AS sales_unit_price,
        a.discount,
        0 AS net_curr_amount,
        0 AS gross_curr_amount,
        a.partdescription AS catalog_desc,
        a.customername AS customer_name,
        a.ordernumber AS order_no,
        a.customerid AS customer_no,
        ' ' AS cust_grp,
        a.salespartno AS catalog_no,
        ' ' AS authorize_code,
        b.salesman_code,
        ' ' AS commission_receiver,
        ' ' AS district_code,
        'ITL' AS region_code,
        a.salesdate AS createdate,
        upper(a.productcode) AS part_product_code,
        decode(a.productline,'Calfor','CALFO','Calmat','CALMA','Dynablast','DYNAB','Dynagraft','DYNAG','DynaMatrix','DYNAM','Renova','RENOV'
,'Restore','RESTO','Stage1','STAGE','Tefgen','TEFGE','Connexus','CONNX','Genesis','GNSIS',upper(a.productline) ) AS part_product_family
,
        ' ' AS second_commodity,
        CASE
                WHEN to_char(a.salesdate,'MM') = '01' THEN 'January'
                WHEN to_char(a.salesdate,'MM') = '02' THEN 'February'
                WHEN to_char(a.salesdate,'MM') = '03' THEN 'March'
                WHEN to_char(a.salesdate,'MM') = '04' THEN 'April'
                WHEN to_char(a.salesdate,'MM') = '05' THEN 'May'
                WHEN to_char(a.salesdate,'MM') = '06' THEN 'June'
                WHEN to_char(a.salesdate,'MM') = '07' THEN 'July'
                WHEN to_char(a.salesdate,'MM') = '08' THEN 'August'
                WHEN to_char(a.salesdate,'MM') = '09' THEN 'September'
                WHEN to_char(a.salesdate,'MM') = '10' THEN 'October'
                WHEN to_char(a.salesdate,'MM') = '11' THEN 'November'
                WHEN to_char(a.salesdate,'MM') = '12' THEN 'December'
            END
        AS invoicemonth,
        CASE
                WHEN to_char(a.salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN to_char(a.salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN to_char(a.salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN to_char(a.salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS invoiceqtr,
        CASE
                WHEN to_char(a.salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
            END
        AS invoiceqtryr,
        to_char(a.salesdate,'MM/YYYY') AS invoicemthyr,
        ' ' AS group_id,
        'Sub-Part' AS type_designation,
        ' ' AS customer_no_pay,
        'ITL' AS corporate_form,
        a.amount * 1.4 AS fixedamounts,
        a.amount * i.currency_rate AS allamounts,
        a.amount AS localamount,
        a.amount AS truelocalamt,
        0 AS vat_dom_amount,
        ' ' AS vat_code,
        decode(a.salespartno,c.part_no,c.inventory_value,d.part_no,d.inventory_value * 1.4) AS cost,
        'Parts' AS charge_type,
        'ITL' AS source,
        'Market' AS market_code,
        ' ' AS association_no,
        0 AS vat_curr_amount,
        ' ' AS pay_term_description,
        ' ' AS kdreference,
        ' ' AS customerref,
        ' ' AS deliverydate,
        ' ' AS ship_via,
        ' ' AS delivery_identity,
        ' ' AS identity,
        ' ' AS delivery_address_id,
        ' ' AS invoice_address_id,
        'EUR' AS currency,
        0 AS rma_no,
        ' ' AS invoiceadd1,
        ' ' AS invoiceadd2,
        ' ' AS invoicecity,
        ' ' AS invoicestate,
        ' ' AS invoicezip,
        ' ' AS invoicecountry,
        ' ' AS invoicecounty,
        ' ' AS delivadd1,
        ' ' AS delivadd2,
        ' ' AS delivcity,
        ' ' AS delivstate,
        ' ' AS delivzip,
        ' ' AS delivcountry,
        ' ' AS delivcounty
    FROM
        srordersitl a
        LEFT JOIN cust_ord_customer_tab b ON a.customerid = b.customer_no
        LEFT JOIN kd_currency_rate_4 i ON to_char(a.salesdate,'MM/YYYY') = i.valid_from
        LEFT JOIN inventory_part_unit_cost_sum c ON a.salespartno = c.part_no AND
                                                    c.contract = '100'
        LEFT JOIN inventory_part_unit_cost_sum d ON a.salespartno = d.part_no AND
                                                    d.contract = '210'
    WHERE
        a.customerid NOT IN (
            'IT002945',
            'IT000387',
            'IT000807',
            'IT001014',
            'IT000916',
            'IT000921',
            'IT000465',
            'IT003382',
            'IT003484',
            'IT003575',
            'IT003656',
            'IT003666',
            'IT003693',
            'IT003940',
            'IT002654',
            'IT002541',
            'IT002014',
            ' '
        ) AND
        a.salesdate >= TO_DATE('01/01/2008','MM/DD/YYYY') AND
        a.salesrepid IN (
            '210-001',
            '210-002',
            '210-003',
            '210-004',
            '210-005',
            '210-006',
            '210-007',
            '210-008',
            '210-009',
            '210-011',
            '210-013',
            '210-014',
            '210-016',
            '210-017',
            '210-018',
            '210-022',
            '210-025',
            '210-027',
            '210-028',
            '210-030',
            '210-031',
            '210-032',
            '210-033',
            '210-034',
            '210-035',
            '210-036',
            '210-037',
            '210-098'
        ) AND
        i.currency_code = 'EUR'
    UNION ALL
    SELECT
        '230' AS site,
        a.invoiceno AS invoice_id,
        to_char(a.itemid) AS item_id,
        trunc(a.salesdate) AS invoicedate,
        a.quantity AS invoiced_qty,
        0 AS sales_unit_price,
        a.discount,
        0 AS net_curr_amount,
        0 AS gross_curr_amount,
        a.partdescription AS catalog_desc,
        a.customername AS customer_name,
        a.ordernumber AS order_no,
        a.customerid AS customer_no,
        ' ' AS cust_grp,
        a.salespartno AS catalog_no,
        ' ' AS authorize_code,
        b.salesman_code,
        ' ' AS commission_receiver,
        ' ' AS district_code,
        'SWE' AS region_code,
        a.salesdate AS createdate,
        upper(a.productcode) AS part_product_code,
        upper(a.productline) AS part_product_family,
        ' ' AS second_commodity,
        CASE
                WHEN to_char(a.salesdate,'MM') = '01' THEN 'January'
                WHEN to_char(a.salesdate,'MM') = '02' THEN 'February'
                WHEN to_char(a.salesdate,'MM') = '03' THEN 'March'
                WHEN to_char(a.salesdate,'MM') = '04' THEN 'April'
                WHEN to_char(a.salesdate,'MM') = '05' THEN 'May'
                WHEN to_char(a.salesdate,'MM') = '06' THEN 'June'
                WHEN to_char(a.salesdate,'MM') = '07' THEN 'July'
                WHEN to_char(a.salesdate,'MM') = '08' THEN 'August'
                WHEN to_char(a.salesdate,'MM') = '09' THEN 'September'
                WHEN to_char(a.salesdate,'MM') = '10' THEN 'October'
                WHEN to_char(a.salesdate,'MM') = '11' THEN 'November'
                WHEN to_char(a.salesdate,'MM') = '12' THEN 'December'
            END
        AS invoicemonth,
        CASE
                WHEN to_char(a.salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN to_char(a.salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN to_char(a.salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN to_char(a.salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS invoiceqtr,
        CASE
                WHEN to_char(a.salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
            END
        AS invoiceqtryr,
        to_char(a.salesdate,'MM/YYYY') AS invoicemthyr,
        ' ' AS group_id,
        'Sub-Part' AS type_designation,
        ' ' AS customer_no_pay,
        'SWE' AS corporate_form,
        a.amount *.13 AS fixedamounts,
        a.amount * i.currency_rate AS allamounts,
        a.amount * j.currency_rate AS localamount,
        a.amount AS truelocalamt,
        0 AS vat_dom_amount,
        ' ' AS vat_code,
        decode(a.salespartno,c.part_no,c.inventory_value,d.part_no,d.inventory_value * 1.4) AS cost,
        'Parts' AS charge_type,
        'ITL' AS source,
        'Market' AS market_code,
        ' ' AS association_no,
        0 AS vat_curr_amount,
        ' ' AS pay_term_description,
        ' ' AS kdreference,
        ' ' AS customerref,
        ' ' AS deliverydate,
        ' ' AS ship_via,
        ' ' AS delivery_identity,
        ' ' AS identity,
        ' ' AS delivery_address_id,
        ' ' AS invoice_address_id,
        'SEK' AS currency,
        0 AS rma_no,
        ' ' AS invoiceadd1,
        ' ' AS invoiceadd2,
        ' ' AS invoicecity,
        ' ' AS invoicestate,
        ' ' AS invoicezip,
        ' ' AS invoicecountry,
        ' ' AS invoicecounty,
        ' ' AS delivadd1,
        ' ' AS delivadd2,
        ' ' AS delivcity,
        ' ' AS delivstate,
        ' ' AS delivzip,
        ' ' AS delivcountry,
        ' ' AS delivcounty
    FROM
        srordersswe a
        LEFT JOIN cust_ord_customer_tab b ON a.customerid = b.customer_no
        LEFT JOIN kd_currency_rate_4 i ON to_char(a.salesdate,'MM/YYYY') = i.valid_from
        LEFT JOIN kd_currency_rate_4 j ON to_char(a.salesdate,'MM/YYYY') = j.valid_from
        LEFT JOIN inventory_part_unit_cost_sum c ON a.salespartno = c.part_no AND
                                                    c.contract = '100'
        LEFT JOIN inventory_part_unit_cost_sum d ON a.salespartno = d.part_no AND
                                                    d.contract = '210'
    WHERE
        a.customerid NOT IN (
            'SE1477',
            'SE1421',
            'SE1424',
            'SE1420',
            'SE1419'
        ) AND
        a.salesdate >= TO_DATE('01/01/2008','MM/DD/YYYY') AND
        i.currency_code = 'SEK' AND
        j.currency_code = 'EUR'
    UNION ALL
    SELECT
        '220' AS site,
        a.invoiceno AS invoice_id,
        to_char(a.itemid) AS item_id,
        trunc(a.salesdate) AS invoicedate,
        a.quantity AS invoiced_qty,
        0 AS sales_unit_price,
        a.discount,
        0 AS net_curr_amount,
        0 AS gross_curr_amount,
        a.partdescription AS catalog_desc,
        a.customername AS customer_name,
        a.ordernumber AS order_no,
        a.customerid AS customer_no,
        'DIST' AS cust_grp,
        a.salespartno AS catalog_no,
        ' ' AS authorize_code,
        b.salesman_code,
        ' ' AS commission_receiver,
        ' ' AS district_code,
        'EURO' AS region_code,
        a.salesdate AS createdate,
        upper(a.productcode) AS part_product_code,
        decode(a.productline,'Calfor','CALFO','Calmat','CALMA','Dynablast','DYNAB','Dynagraft','DYNAG','DynaMatrix','DYNAM','Renova','RENOV'
,'Restore','RESTO','Stage1','STAGE','Tefgen','TEFGE','Connexus','CONNX',upper(a.productline) ) AS part_product_family,
        ' ' AS second_commodity,
        CASE
                WHEN to_char(a.salesdate,'MM') = '01' THEN 'January'
                WHEN to_char(a.salesdate,'MM') = '02' THEN 'February'
                WHEN to_char(a.salesdate,'MM') = '03' THEN 'March'
                WHEN to_char(a.salesdate,'MM') = '04' THEN 'April'
                WHEN to_char(a.salesdate,'MM') = '05' THEN 'May'
                WHEN to_char(a.salesdate,'MM') = '06' THEN 'June'
                WHEN to_char(a.salesdate,'MM') = '07' THEN 'July'
                WHEN to_char(a.salesdate,'MM') = '08' THEN 'August'
                WHEN to_char(a.salesdate,'MM') = '09' THEN 'September'
                WHEN to_char(a.salesdate,'MM') = '10' THEN 'October'
                WHEN to_char(a.salesdate,'MM') = '11' THEN 'November'
                WHEN to_char(a.salesdate,'MM') = '12' THEN 'December'
            END
        AS invoicemonth,
        CASE
                WHEN to_char(a.salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN to_char(a.salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN to_char(a.salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN to_char(a.salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS invoiceqtr,
        CASE
                WHEN to_char(a.salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
            END
        AS invoiceqtryr,
        to_char(a.salesdate,'MM/YYYY') AS invoicemthyr,
        ' ' AS group_id,
        'Sub-Part' AS type_designation,
        ' ' AS customer_no_pay,
        'EUR' AS corporate_form,
        a.amount * 1.4 AS fixedamounts,
        a.amount * i.currency_rate AS allamounts,
        a.amount AS localamount,
        a.amount AS truelocalamt,
        0 AS vat_dom_amount,
        ' ' AS vat_code,
        decode(a.salespartno,c.part_no,c.inventory_value,d.part_no,d.inventory_value * 1.4) AS cost,
        'Parts' AS charge_type,
        'GER' AS source,
        'Market' AS market_code,
        ' ' AS association_no,
        0 AS vat_curr_amount,
        ' ' AS pay_term_description,
        ' ' AS kdreference,
        ' ' AS customerref,
        ' ' AS deliverydate,
        ' ' AS ship_via,
        ' ' AS delivery_identity,
        ' ' AS identity,
        ' ' AS delivery_address_id,
        ' ' AS invoice_address_id,
        'EUR' AS currency,
        0 AS rma_no,
        ' ' AS invoiceadd1,
        ' ' AS invoiceadd2,
        ' ' AS invoicecity,
        ' ' AS invoicestate,
        ' ' AS invoicezip,
        ' ' AS invoicecountry,
        ' ' AS invoicecounty,
        ' ' AS delivadd1,
        ' ' AS delivadd2,
        ' ' AS delivcity,
        ' ' AS delivstate,
        ' ' AS delivzip,
        ' ' AS delivcountry,
        ' ' AS delivcounty
    FROM
        srordersger a
        LEFT JOIN cust_ord_customer_tab b ON a.customerid = b.customer_no
        LEFT JOIN kd_currency_rate_4 i ON to_char(a.salesdate,'MM/YYYY') = i.valid_from
        LEFT JOIN inventory_part_unit_cost_sum c ON a.salespartno = c.part_no AND
                                                    c.contract = '100'
        LEFT JOIN inventory_part_unit_cost_sum d ON a.salespartno = d.part_no AND
                                                    d.contract = '210'
    WHERE
        a.customerid IN (
            'DE55046',
            'DE43125',
            'DE29029',
            'DE47206'
        ) AND
        a.salesdate >= TO_DATE('01/01/2008','MM/DD/YYYY') AND
        i.currency_code = 'EUR'
    UNION ALL
    SELECT
        '210' AS site,
        a.invoiceno AS invoice_id,
        to_char(a.itemid) AS item_id,
        trunc(a.salesdate) AS invoicedate,
        a.quantity AS invoiced_qty,
        0 AS sales_unit_price,
        a.discount,
        0 AS net_curr_amount,
        0 AS gross_curr_amount,
        a.partdescription AS catalog_desc,
        a.customername AS customer_name,
        a.ordernumber AS order_no,
        a.customerid AS customer_no,
        'DIST' AS cust_grp,
        a.salespartno AS catalog_no,
        ' ' AS authorize_code,
        b.salesman_code,
        ' ' AS commission_receiver,
        ' ' AS district_code,
        'EURO' AS region_code,
        a.salesdate AS createdate,
        upper(a.productcode) AS part_product_code,
        decode(a.productline,'Calfor','CALFO','Calmat','CALMA','Dynablast','DYNAB','Dynagraft','DYNAG','DynaMatrix','DYNAM','Renova','RENOV'
,'Restore','RESTO','Stage1','STAGE','Tefgen','TEFGE','Connexus','CONNX',upper(a.productline) ) AS part_product_family,
        ' ' AS second_commodity,
        CASE
                WHEN to_char(a.salesdate,'MM') = '01' THEN 'January'
                WHEN to_char(a.salesdate,'MM') = '02' THEN 'February'
                WHEN to_char(a.salesdate,'MM') = '03' THEN 'March'
                WHEN to_char(a.salesdate,'MM') = '04' THEN 'April'
                WHEN to_char(a.salesdate,'MM') = '05' THEN 'May'
                WHEN to_char(a.salesdate,'MM') = '06' THEN 'June'
                WHEN to_char(a.salesdate,'MM') = '07' THEN 'July'
                WHEN to_char(a.salesdate,'MM') = '08' THEN 'August'
                WHEN to_char(a.salesdate,'MM') = '09' THEN 'September'
                WHEN to_char(a.salesdate,'MM') = '10' THEN 'October'
                WHEN to_char(a.salesdate,'MM') = '11' THEN 'November'
                WHEN to_char(a.salesdate,'MM') = '12' THEN 'December'
            END
        AS invoicemonth,
        CASE
                WHEN to_char(a.salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN to_char(a.salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN to_char(a.salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN to_char(a.salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS invoiceqtr,
        CASE
                WHEN to_char(a.salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
            END
        AS invoiceqtryr,
        to_char(a.salesdate,'MM/YYYY') AS invoicemthyr,
        ' ' AS group_id,
        'Sub-Part' AS type_designation,
        ' ' AS customer_no_pay,
        'EUR' AS corporate_form,
        a.amount * 1.4 AS fixedamounts,
        a.amount * i.currency_rate AS allamounts,
        a.amount AS localamount,
        a.amount AS truelocalamt,
        0 AS vat_dom_amount,
        ' ' AS vat_code,
        decode(a.salespartno,c.part_no,c.inventory_value,d.part_no,d.inventory_value * 1.4) AS cost,
        'Parts' AS charge_type,
        'ITL' AS source,
        'Market' AS market_code,
        ' ' AS association_no,
        0 AS vat_curr_amount,
        ' ' AS pay_term_description,
        ' ' AS kdreference,
        ' ' AS customerref,
        ' ' AS deliverydate,
        ' ' AS ship_via,
        ' ' AS delivery_identity,
        ' ' AS identity,
        ' ' AS delivery_address_id,
        ' ' AS invoice_address_id,
        'EUR' AS currency,
        0 AS rma_no,
        ' ' AS invoiceadd1,
        ' ' AS invoiceadd2,
        ' ' AS invoicecity,
        ' ' AS invoicestate,
        ' ' AS invoicezip,
        ' ' AS invoicecountry,
        ' ' AS invoicecounty,
        ' ' AS delivadd1,
        ' ' AS delivadd2,
        ' ' AS delivcity,
        ' ' AS delivstate,
        ' ' AS delivzip,
        ' ' AS delivcountry,
        ' ' AS delivcounty
    FROM
        srordersitl a
        LEFT JOIN cust_ord_customer_tab b ON a.customerid = b.customer_no
        LEFT JOIN kd_currency_rate_4 i ON to_char(a.salesdate,'MM/YYYY') = i.valid_from
        LEFT JOIN inventory_part_unit_cost_sum c ON a.salespartno = c.part_no AND
                                                    c.contract = '100'
        LEFT JOIN inventory_part_unit_cost_sum d ON a.salespartno = d.part_no AND
                                                    d.contract = '210'
    WHERE
        a.customerid IN (
            'IT002945',
            'IT000387',
            'IT000807',
            'IT001014',
            'IT000916',
            'IT000921',
            'IT000465',
            'IT003382',
            'IT003484',
            'IT003575',
            'IT003656',
            'IT003666',
            'IT003693',
            'IT003940'
        ) AND
        a.salesdate >= TO_DATE('01/01/2010','MM/DD/YYYY') AND
        i.currency_code = 'EUR'
    UNION ALL
    SELECT
        '100' AS site,
        a.invoice_no AS invoice_id,
        '1' AS item_id,
        trunc(a.invoice_date) AS invoicedate,
        0 AS invoiced_qty,
        0 AS sale_unit_price,
        0 AS discount,
        a.net_curr_amount AS net_curr_amount,
        a.net_curr_amount + a.vat_curr_amount AS gross_curr_amount,
        'Other' AS catalog_desc,
        b.name AS customer_name,
        a.creators_reference AS order_no,
        a.identity AS customer_no,
        c.cust_grp AS cust_grp,
        'Other' AS catalog_no,
        'Other' AS authorize_code,
        c.salesman_code AS salesman_code,
        e.commission_receiver AS commission_receiver,
        d.district_code AS district_code,
        d.region_code AS region_code,
        trunc(a.invoice_date) AS createdate,
        'OTHER' AS part_product_code,
        'OTHER' AS part_product_family,
        'OTHER' AS second_commodity,
        CASE
                WHEN to_char(a.invoice_date,'MM') = '01' THEN 'January'
                WHEN to_char(a.invoice_date,'MM') = '02' THEN 'February'
                WHEN to_char(a.invoice_date,'MM') = '03' THEN 'March'
                WHEN to_char(a.invoice_date,'MM') = '04' THEN 'April'
                WHEN to_char(a.invoice_date,'MM') = '05' THEN 'May'
                WHEN to_char(a.invoice_date,'MM') = '06' THEN 'June'
                WHEN to_char(a.invoice_date,'MM') = '07' THEN 'July'
                WHEN to_char(a.invoice_date,'MM') = '08' THEN 'August'
                WHEN to_char(a.invoice_date,'MM') = '09' THEN 'September'
                WHEN to_char(a.invoice_date,'MM') = '10' THEN 'October'
                WHEN to_char(a.invoice_date,'MM') = '11' THEN 'November'
                WHEN to_char(a.invoice_date,'MM') = '12' THEN 'December'
            END
        AS invoicemonth,
        CASE
                WHEN to_char(a.invoice_date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN to_char(a.invoice_date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN to_char(a.invoice_date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN to_char(a.invoice_date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS invoiceqtr,
        CASE
                WHEN to_char(a.invoice_date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM a.invoice_date)
                WHEN to_char(a.invoice_date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM a.invoice_date)
                WHEN to_char(a.invoice_date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM a.invoice_date)
                WHEN to_char(a.invoice_date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM a.invoice_date)
            END
        AS invoiceqtryr,
        to_char(a.invoice_date,'MM/YYYY') AS invoicemthyr,
        f.group_id AS group_id,
        decode(a.invoice_no,'99086930','Non-Target','Target') AS type_designation,
        c.customer_no_pay,
        b.corporate_form,
        decode(a.currency,'SEK', (a.net_curr_amount *.13),'EUR', (a.net_curr_amount * 1.4),a.net_curr_amount) AS fixed_amounts,
        CASE
                WHEN a.currency = 'CAD' AND
                     trunc(a.invoice_date) >= TO_DATE('03/01/2013','MM/DD/YYYY') AND
                     trunc(a.invoice_date) <= TO_DATE('12/16/2019','MM/DD/YYYY')
                THEN a.net_curr_amount
                WHEN a.currency = 'CAD' AND
                     trunc(a.invoice_date) > TO_DATE('12/16/2019','MM/DD/YYYY')
                THEN a.net_curr_amount * coalesce(a.n1,a.curr_rate)
                WHEN a.currency != 'USD' THEN a.net_curr_amount * i.currency_rate
                ELSE a.net_curr_amount
            END
        AS allamounts,
        CASE
                WHEN a.currency IN (
                    'SEK',
                    'DKK'
                ) THEN a.net_curr_amount / j.currency_rate
                ELSE a.net_curr_amount
            END
        AS localamount,
        a.net_curr_amount AS truelocalamt,
        0 AS vat_dom_amount,
        ' ' AS vat_code,
        0 AS cost,
        'Parts' AS charge_type,
        'IFS' AS source,
        'Market' AS market_code,
        b.association_no,
        0 AS vat_curr_amount,
        ' ' AS pay_term_description,
        ' ' AS kdreference,
        ' ' AS customerref,
        ' ' AS deliverydate,
        ' ' AS ship_via,
        a.identity AS delivery_identity,
        a.identity AS identity,
        '99' AS delivery_address_id,
        '99' AS invoice_address_id,
        a.currency AS currency,
        0 AS rma_no,
        ' ' AS invoiceadd1,
        ' ' AS invoiceadd2,
        ' ' AS invoicecity,
        ' ' AS invoicestate,
        ' ' AS invoicezip,
        ' ' AS invoicecountry,
        ' ' AS invoicecounty,
        ' ' AS delivadd1,
        ' ' AS delivadd2,
        ' ' AS delivcity,
        ' ' AS delivstate,
        ' ' AS delivzip,
        ' ' AS delivcountry,
        ' ' AS delivcounty
    FROM
        invoice_tab a
        LEFT JOIN kd_currency_rate_4 i ON a.currency = i.currency_code AND
                                          to_char(a.invoice_date,'MM/YYYY') = i.valid_from
        LEFT JOIN kd_currency_rate_1 j ON a.currency = j.currency_code AND
                                          to_char(a.invoice_date,'MM/YYYY') = j.valid_from,
        customer_info_tab b,
        cust_ord_customer_tab c,cust_ord_customer_address_tab d
        LEFT JOIN cust_def_com_receiver_tab e ON d.customer_no = e.customer_no,
        identity_invoice_info_tab f
    WHERE
        a.identity = b.customer_id AND
        a.identity = c.customer_no AND
        b.customer_id = c.customer_no AND
        a.identity = d.customer_no AND
        b.customer_id = d.customer_no AND
        c.customer_no = d.customer_no AND
        f.identity = a.identity AND
        f.company = '100' AND
        trunc(a.invoice_date) >= TO_DATE('01/01/2010','MM/DD/YYYY') AND
        d.addr_no = '99' AND
        a.series_id IN (
            'CI',
            'II'
        ) AND
        invoice_api.finite_state_decode__(a.rowstate) != 'Cancelled' AND
        a.invoice_no IN (
            'CD99004117-R',
            'CR015275',
            'CR537182',
            'CR538349',
            'CR540408',
            'CR541376',
            'CR541587',
            'CR542690',
            'CR543188',
            'CR543189',
            'CR543190',
            'CR543191',
            'CR543192',
            'CR999901352',
            '9900034',
            '9900035',
            'CD99004403',
            'CD99010910',
            'CD99022855',
            'CD99040559',
            '9900022',
            '9900024',
            '9900037',
            '9900038',
            '9900039',
            '99030194',
            '99031158',
            '99043480',
            '999902606',
            '99031806',
            '99033594',
            'CR531714',
            'CR537323',
            'CR541793',
            'CR541889',
            'CR542334',
            'CR9900021',
            'CR9900023',
            'CR9900030',
            'CR99031806',
            'CR99033594',
            '99051483',
            '99051563',
            '99052156',
            '99052601',
            '99053060',
            '999905308',
            'CR1885',
            'CR316948',
            'CR3691',
            'CR531714B',
            'CR540861',
            '999906495',
            '99055039',
            '9900005',
            '9900044',
            '99062938',
            '1775DISCADJ',
            '99030980CR',
            '99051493CR',
            '99064380CR',
            '99064336',
            'RMA6269',
            '2479_0809CR',
            '99069660A',
            '99070809PD',
            '99075281',
            '20646CR',
            'DYNATRIX',
            '9900048',
            '9900049',
            '9900050',
            '99064576',
            '99990771',
            '990543459',
            '999910219',
            '5418000CR',
            '9900052',
            '2479_1109CR',
            '99085958A',
            '9900054',
            '99077823',
            '99077930',
            '99090097',
            '999909696',
            '2479_1209CR',
            '99091427A',
            '99093418A',
            '9900057',
            '9900058',
            '9900059',
            '99096834A',
            '99076516',
            '99098866',
            '99099245',
            '99093370A',
            '999908479A',
            '99100341A',
            '99101896',
            '99061875',
            '99086484',
            '99100924',
            '99104656',
            '99104708',
            '99105067',
            '99106176',
            '99106235',
            '99106731',
            '99107429',
            '999901456',
            '999901697',
            '999911641',
            '99105630A',
            '99086930',
            '99016153',
            'CD99101896',
            'CD99100138',
            '99103094',
            '99100544',
            '9900025',
            '9900027',
            '9900028',
            '9900029',
            '9900030',
            '9900031',
            '9900032',
            '9900033',
            '9900036',
            'CR99033594',
            'CR999904187',
            'CD99031806',
            '99044415A',
            '99044415R',
            '99047478A',
            '999906450',
            '9900043',
            '99052747',
            '99052967',
            '999905426',
            '999906428DR',
            '999906626A',
            '999909760',
            '99080758',
            '99070809PD',
            '9900042',
            '541784B',
            '9900064',
            '9900065',
            '9900067',
            '99105850',
            '999912837A',
            '2951A',
            '9900068',
            '9900069',
            '999913881'
        )
    UNION ALL
    SELECT
        decode(c.association_no,'DE','220','SE','230','FR','240','IT','210','EU','100','100') AS site,
        a.series_id || a.invoice_no AS invoice_id,
        to_char(b.item_id) AS item_id,
        trunc(a.d2) AS invoicedate,
        CASE
                WHEN a.series_id = 'CR' AND
                     b.n2 IS NULL THEN 0
                WHEN a.series_id = 'CR' AND
                     b.n2 IS NOT NULL THEN b.n2 *-1
                ELSE b.n2
            END
        AS invoiced_qty,
        b.n4 AS sale_unit_price,
        b.n5 AS discount,
        a.net_curr_amount,
        b.net_curr_amount + b.vat_curr_amount AS gross_curr_amount,
        b.c6 AS catalog_desc,
        c.name AS customer_name,
        b.c1 AS order_no,
        a.delivery_identity AS customer_no,
        d.cust_grp,
        b.c5 AS catalog_no,
        ' ' AS authorize_code,
        d.salesman_code,
        ' ' AS commission_receiver,
        e.district_code,
        e.region_code,
        trunc(a.invoice_date) AS createdate,
        ' ' AS part_product_code,
        ' ' AS part_product_family,
        ' ' AS second_commodity,
        CASE
                WHEN to_char(a.d2,'MM') = '01' THEN 'January'
                WHEN to_char(a.d2,'MM') = '02' THEN 'February'
                WHEN to_char(a.d2,'MM') = '03' THEN 'March'
                WHEN to_char(a.d2,'MM') = '04' THEN 'April'
                WHEN to_char(a.d2,'MM') = '05' THEN 'May'
                WHEN to_char(a.d2,'MM') = '06' THEN 'June'
                WHEN to_char(a.d2,'MM') = '07' THEN 'July'
                WHEN to_char(a.d2,'MM') = '08' THEN 'August'
                WHEN to_char(a.d2,'MM') = '09' THEN 'September'
                WHEN to_char(a.d2,'MM') = '10' THEN 'October'
                WHEN to_char(a.d2,'MM') = '11' THEN 'November'
                WHEN to_char(a.d2,'MM') = '12' THEN 'December'
            END
        AS invoicemonth,
        CASE
                WHEN to_char(a.d2,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN to_char(a.d2,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN to_char(a.d2,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN to_char(a.d2,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS invoiceqtr,
        CASE
                WHEN to_char(a.d2,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM a.d2)
                WHEN to_char(a.d2,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM a.d2)
                WHEN to_char(a.d2,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM a.d2)
                WHEN to_char(a.d2,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM a.d2)
            END
        AS invoiceqtryr,
        to_char(a.d2,'MM/YYYY') AS invoicemthyr,
        f.group_id,
        'Freight' AS type_designation,
        b.identity AS customer_no_pay,
        'Freight' AS corporate_form,
        decode(a.currency,'SEK', (b.net_curr_amount * 0.13),'EUR', (b.net_curr_amount * 0.13),b.net_curr_amount) AS fixedamounts,
        CASE
                WHEN a.currency = 'CAD' AND
                     trunc(a.d2) >= TO_DATE('03/01/2013','MM/DD/YYYY') AND
                     trunc(a.d2) <= TO_DATE('12/16/2019','MM/DD/YYYY')
                THEN b.net_curr_amount      
                WHEN a.currency = 'CAD' AND
                     trunc(a.d2) > TO_DATE('12/16/2019','MM/DD/YYYY')
                THEN b.net_curr_amount * coalesce(a.n1,a.curr_rate)
                WHEN a.currency != 'USD' THEN b.net_curr_amount * i.currency_rate
                ELSE b.net_curr_amount
            END
        AS allamounts,
        CASE
                WHEN a.currency IN (
                    'SEK',
                    'DKK'
                ) THEN b.net_curr_amount / j.currency_rate
                ELSE b.net_curr_amount
            END
        AS localamount,
        b.net_curr_amount AS truelocalamt,
        0 AS vat_dom_amount,
        ' ' AS vat_code,
        0 AS cost,
        'Freight' AS charge_type,
        'IFS' AS source,
        'Market' AS market_code,
        c.association_no,
        0 AS vat_curr_amount,
        ' ' AS pay_term_description,
        ' ' AS kdreference,
        ' ' AS customerref,
        ' ' AS deliverydate,
        ' ' AS ship_via,
        a.delivery_identity,
        a.identity,
        a.delivery_address_id,
        a.invoice_address_id,
        a.currency,
        a.n2 AS rma_no,
        n.address1 AS invoiceadd1,
        n.address2 AS invoiceadd2,
        n.city AS invoicecity,
        n.state AS invoicestate,
        n.zip_code AS invoicezip,
        iso_country_api.decode(n.country) AS invoicecountry,
        n.county AS invoicecounty,
        o.address1 AS delivadd1,
        o.address2 AS delivadd2,
        o.city AS delivcity,
        o.state AS delivstate,
        o.zip_code AS delivzip,
        iso_country_api.decode(o.country) AS delivcountry,
        o.county AS delivcounty
    FROM
        invoice_tab a
        LEFT JOIN kd_currency_rate_4 i ON a.currency = i.currency_code AND
                                          to_char(a.d2,'MM/YYYY') = i.valid_from
        LEFT JOIN kd_currency_rate_1 j ON a.currency = j.currency_code AND
                                          to_char(a.d2,'MM/YYYY') = j.valid_from
        LEFT JOIN customer_info_address_tab n ON a.identity = n.customer_id AND
                                                 a.invoice_address_id = n.address_id
        LEFT JOIN customer_info_address_tab o ON a.identity = o.customer_id AND
                                                 a.delivery_address_id = o.address_id,invoice_item_tab b
        LEFT JOIN identity_invoice_info_tab f ON b.company = f.company AND
                                                 b.identity = f.identity AND
                                                 b.party_type = f.party_type,
        customer_info_tab c,
        cust_ord_customer_tab d,
        cust_ord_customer_address_tab e
    WHERE
        a.invoice_id = b.invoice_id AND
        a.delivery_identity = c.customer_id AND
        a.delivery_identity = d.customer_no AND
        c.customer_id = d.customer_no AND
        a.delivery_identity = e.customer_no AND
        c.customer_id = e.customer_no AND
        d.customer_no = e.customer_no AND
        trunc(a.invoice_date) >= TO_DATE('01/01/2008','MM/DD/YYYY') AND
        b.c5 != 'WAIVESHIPPING' AND
        e.addr_no = '99' AND
        b.c11 IN (
            'FREIGHT',
            'RESTOCK',
            'DOMFLATRATE'
        ) AND
        c.corporate_form != 'KEY'
    UNION ALL
    SELECT
        '100' AS site,
        '0' AS invoice_id,
        '1' AS item_id,
        TO_DATE('01/01/9999','MM/DD/YYYY') AS invoicedate,
        0 AS invoiced_qty,
        0 AS sale_unit_price,
        0 AS discount,
        0 AS net_curr_amount,
        0 AS gross_curr_amount,
        'Other' AS catalog_desc,
        ' ' AS customer_name,
        ' ' AS order_no,
        '0' AS customer_no,
        '0' AS cust_grp,
        'Other' AS catalog_no,
        'Other' AS authorize_code,
        ' ' AS salesman_code,
        ' ' AS commission_receiver,
        ' ' AS district_code,
        ' ' AS region_code,
        TO_DATE('01/01/9999','MM/DD/YYYY') AS createdate,
        'OTHER' AS part_product_code,
        'OTHER' AS part_product_family,
        'OTHER' AS second_commodity,
        ' ' AS invoicemonth,
        ' ' AS invoiceqtr,
        ' ' AS invoiceqtryr,
        ' ' AS invoicemthyr,
        ' ' AS group_id,
        ' ' AS type_designation,
        '0' AS custome_no_pay,
        'DOMDIRLE' AS corporate_form,
        0 AS fixedamounts,
        0 AS allamounts,
        0 AS localamount,
        0 AS truelocalamt,
        0 AS vat_dom_amount,
        ' ' AS vat_code,
        0 AS cost,
        'Parts' AS charge_type,
        'IFS' AS source,
        'Market' AS market_code,
        ' ' AS association_no,
        0 AS vat_curr_amount,
        ' ' AS pay_term_description,
        ' ' AS kdreference,
        ' ' AS customerref,
        ' ' AS deliverydate,
        ' ' AS ship_via,
        ' ' AS delivery_identity,
        ' ' AS identity,
        ' ' AS delivery_address_id,
        ' ' AS invoice_address_id,
        ' ' AS currency,
        0 AS rma_no,
        ' ' AS invoiceadd1,
        ' ' AS invoiceadd2,
        ' ' AS invoicecity,
        ' ' AS invoicestate,
        ' ' AS invoicezip,
        ' ' AS invoicecountry,
        ' ' AS invoicecounty,
        ' ' AS delivadd1,
        ' ' AS delivadd2,
        ' ' AS delivcity,
        ' ' AS delivstate,
        ' ' AS delivzip,
        ' ' AS delivcountry,
        ' ' AS delivcounty
    FROM
        dual
    UNION ALL
  --Dummy Record for Target Products
    SELECT
        '100' AS site,
        '0' AS invoice_id,
        '1' AS item_id,
        TO_DATE('01/01/9999','MM/DD/YYYY') AS invoicedate,
        0 AS invoiced_qty,
        0 AS sale_unit_price,
        0 AS discount,
        0 AS net_curr_amount,
        0 AS gross_curr_amount,
        'Other' AS catalog_desc,
        ' ' AS customer_name,
        ' ' AS order_no,
        '0' AS customer_no,
        '0' AS cust_grp,
        'Other' AS catalog_no,
        'Other' AS authorize_code,
        ' ' AS salesman_code,
        ' ' AS commission_receiver,
        ' ' AS district_code,
        ' ' AS region_code,
        TO_DATE('01/01/9999','MM/DD/YYYY') AS createdate,
        'OTHER' AS part_product_code,
        'OTHER' AS part_product_family,
        'OTHER' AS second_commodity,
        ' ' AS invoicemonth,
        ' ' AS invoiceqtr,
        ' ' AS invoiceqtryr,
        ' ' AS invoicemthyr,
        ' ' AS group_id,
        ' ' AS type_designation,
        '0' AS customer_no_pay,
        'DOMDIRPR' AS corporate_form,
        0 AS fixedamounts,
        0 AS allamounts,
        0 AS localamount,
        0 AS truelocalamt,
        0 AS vat_dom_amount,
        ' ' AS vat_code,
        0 AS cost,
        'Parts' AS charge_type,
        'IFS' AS source,
        'Market' AS market_code,
        ' ' AS association_no,
        0 AS vat_curr_amount,
        ' ' AS pay_term_description,
        ' ' AS kdreference,
        ' ' AS customerref,
        ' ' AS deliverydate,
        ' ' AS ship_via,
        ' ' AS delivery_identity,
        ' ' AS identity,
        ' ' AS delivery_address_id,
        ' ' AS invoice_address_id,
        ' ' AS currency,
        0 AS rma_no,
        ' ' AS invoiceadd1,
        ' ' AS invoiceadd2,
        ' ' AS invoicecity,
        ' ' AS invoicestate,
        ' ' AS invoicezip,
        ' ' AS invoicecountry,
        ' ' AS invoicecounty,
        ' ' AS delivadd1,
        ' ' AS delivadd2,
        ' ' AS delivcity,
        ' ' AS delivstate,
        ' ' AS delivzip,
        ' ' AS delivcountry,
        ' ' AS delivcounty
    FROM
        dual
    UNION ALL
    SELECT
        decode(a.company,'241','240',a.company) AS site,
        b.series_id || b.invoice_no AS invoice_id,
        to_char(a.item_id) AS item_id,
        trunc(b.d2) AS invoice_date,
        CASE
                WHEN b.series_id = 'CR' AND
                     a.n2 IS NULL THEN 0
                WHEN b.series_id = 'CR' AND
                     a.n2 IS NOT NULL THEN a.n2 *-1
                ELSE a.n2
            END
        AS invoiced_qty,
        a.n4 AS sale_unit_price,
        a.n5 AS discount,
        a.net_curr_amount,
        a.net_curr_amount + a.vat_curr_amount AS gross_curr_amount,
        c.catalog_desc,
        customer_info_api.get_name(b.identity) AS customer_name,
        a.c1 AS order_no,
        a.c13 AS customer_no,
        d.cust_grp,
        a.c5,
        substr(b.c1,1,35) AS authorize_code,
        d.salesman_code,
        e.commission_receiver,
        f.district_code,
        f.region_code,
        trunc(b.creation_date) AS createdate,
        decode(a.c5,g.part_no,g.part_product_code,'OTHER') AS part_product_code,
        decode(a.c5,g.part_no,g.part_product_family,'OTHER') AS part_product_family,
        decode(a.c5,g.part_no,g.second_commodity,'OTHER') AS second_commodity,
        CASE
                WHEN to_char(b.d2,'MM') = '01' THEN 'January'
                WHEN to_char(b.d2,'MM') = '02' THEN 'February'
                WHEN to_char(b.d2,'MM') = '03' THEN 'March'
                WHEN to_char(b.d2,'MM') = '04' THEN 'April'
                WHEN to_char(b.d2,'MM') = '05' THEN 'May'
                WHEN to_char(b.d2,'MM') = '06' THEN 'June'
                WHEN to_char(b.d2,'MM') = '07' THEN 'July'
                WHEN to_char(b.d2,'MM') = '08' THEN 'August'
                WHEN to_char(b.d2,'MM') = '09' THEN 'September'
                WHEN to_char(b.d2,'MM') = '10' THEN 'October'
                WHEN to_char(b.d2,'MM') = '11' THEN 'November'
                WHEN to_char(b.d2,'MM') = '12' THEN 'December'
            END
        AS invoicemonth,
        CASE
                WHEN to_char(b.d2,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN to_char(b.d2,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN to_char(b.d2,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN to_char(b.d2,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS invoiceqtr,
        CASE
                WHEN to_char(b.d2,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM b.d2)
                WHEN to_char(b.d2,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM b.d2)
                WHEN to_char(b.d2,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM b.d2)
                WHEN to_char(b.d2,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM b.d2)
            END
        AS invoiceqtryr,
        to_char(b.d2,'MM/YYYY') AS invoicemthyr,
        k.group_id AS group_id,
        decode(a.c5,g.part_no,g.type_designation,'Non-Target') AS type_designation,
        a.identity AS customer_no_pay,
        decode(a.c1,'C99916','DOMDIR','ASIA') AS corporate_form,
        a.net_curr_amount AS fixedamounts,
        a.net_curr_amount AS allamounts,
        a.net_curr_amount AS localamount,
        a.net_curr_amount AS truelocalamt,
        a.vat_dom_amount,
        a.vat_code,
        CASE
                WHEN a.c5 = k.part_no THEN k.inventory_value
                ELSE l.inventory_value * 1.4
            END
        AS cost,
        'Parts' AS charge_type,
        'IFS' AS source,
        m.market_code,
        h.association_no,
        b.vat_curr_amount,
        payment_term_api.get_description(b.company,b.pay_term_id) AS pay_term_description,
        substr(b.c1,1,35) AS kdreference,
        substr(b.c2,1,30) AS customerref,
        to_char(b.d3,'MM/DD/YYYY') AS deliverydate,
        substr(b.c3,1,35) AS ship_via,
        b.delivery_identity,
        b.identity,
        b.delivery_address_id,
        b.invoice_address_id,
        b.currency,
        b.n2 AS rma_no,
        n.address1 AS invoiceadd1,
        n.address2 AS invoiceadd2,
        n.city AS invoicecity,
        n.state AS invoicestate,
        n.zip_code AS invoicezip,
        iso_country_api.decode(n.country) AS invoicecountry,
        n.county AS invoicecounty,
        o.address1 AS delivadd1,
        o.address2 AS delivadd2,
        o.city AS delivcity,
        o.state AS delivstate,
        o.zip_code AS delivzip,
        iso_country_api.decode(o.country) AS delivcountry,
        o.county AS delivcounty
    FROM
        invoice_item_tab a
        LEFT JOIN sales_part_tab c ON a.c5 = c.catalog_no AND
                                      decode(a.company,'241','240',a.company) = c.contract
        LEFT JOIN cust_def_com_receiver_tab e ON a.c13 = e.customer_no
        LEFT JOIN inventory_part_tab g ON a.c5 = g.part_no AND
                                          decode(a.company,'241','240',a.company) = g.contract
        LEFT JOIN kd_cost_100 k ON a.c5 = k.part_no
        LEFT JOIN kd_cost_210 l ON a.c5 = l.part_no
        LEFT JOIN customer_order_tab m ON a.c1 = m.order_no
        LEFT JOIN identity_invoice_info_tab k ON a.company = k.company AND
                                                 a.identity = k.identity AND
                                                 a.party_type = k.party_type,invoice_tab b
        LEFT JOIN customer_info_address_tab n ON b.identity = n.customer_id AND
                                                 b.invoice_address_id = n.address_id
        LEFT JOIN customer_info_address_tab o ON b.identity = o.customer_id AND
                                                 b.delivery_address_id = o.address_id,
        cust_ord_customer_tab d,
        cust_ord_customer_address_tab f,
        customer_info_tab h
    WHERE
        a.invoice_id = b.invoice_id AND
        a.c11 IS NULL AND
        a.c13 = d.customer_no AND
        b.delivery_identity = d.customer_no AND
        a.c13 = f.customer_no AND
        a.c13 = h.customer_id AND
        h.customer_id = d.customer_no AND
        h.customer_id = f.customer_no AND
        b.delivery_identity = h.customer_id AND
        b.rowstate != 'Preliminary' AND
        f.addr_no = '99' AND
        a.c1 IN (
            'C99894',
            'C99904',
            'C99913',
            'C99917',
            'C99919',
            'K1348',
            'K1351',
            'C99916'
        ) AND
        trunc(b.d2) >= TO_DATE('01/01/2010','MM/DD/YYYY')
    UNION ALL
    SELECT
        '240' AS site,
        a.invoiceno AS invoice_id,
        to_char(a.itemid) AS item_id,
        trunc(a.salesdate) AS invoicedate,
        a.quantity AS invoiced_qty,
        0 AS sales_unit_price,
        a.discount,
        0 AS net_curr_amount,
        0 AS gross_curr_amount,
        a.partdescription AS catalog_desc,
        a.customername AS customer_name,
        a.ordernumber AS order_no,
        a.customerid AS customer_no,
        ' ' AS cust_grp,
        a.salespartno AS catalog_no,
        ' ' AS authorize_code,
        'CAD' AS salesman_code,
        ' ' AS commission_receiver,
        ' ' AS district_code,
        'FRA' AS region_code,
        a.salesdate AS createdate,
        'EGSW' AS part_product_code,
        'EG' AS part_product_family,
        ' ' AS second_commodity,
        CASE
                WHEN to_char(a.salesdate,'MM') = '01' THEN 'January'
                WHEN to_char(a.salesdate,'MM') = '02' THEN 'February'
                WHEN to_char(a.salesdate,'MM') = '03' THEN 'March'
                WHEN to_char(a.salesdate,'MM') = '04' THEN 'April'
                WHEN to_char(a.salesdate,'MM') = '05' THEN 'May'
                WHEN to_char(a.salesdate,'MM') = '06' THEN 'June'
                WHEN to_char(a.salesdate,'MM') = '07' THEN 'July'
                WHEN to_char(a.salesdate,'MM') = '08' THEN 'August'
                WHEN to_char(a.salesdate,'MM') = '09' THEN 'September'
                WHEN to_char(a.salesdate,'MM') = '10' THEN 'October'
                WHEN to_char(a.salesdate,'MM') = '11' THEN 'November'
                WHEN to_char(a.salesdate,'MM') = '12' THEN 'December'
            END
        AS invoicemonth,
        CASE
                WHEN to_char(a.salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN to_char(a.salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN to_char(a.salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN to_char(a.salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS invoiceqtr,
        CASE
                WHEN to_char(a.salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
                WHEN to_char(a.salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM a.salesdate)
            END
        AS invoiceqtryr,
        to_char(a.salesdate,'MM/YYYY') AS invoicemthyr,
        ' ' AS group_id,
        'Sub-Part' AS type_designation,
        ' ' AS customer_no_pay,
        'FRA' AS corporate_form,
        a.amount AS fixedamounts,
        a.amount AS allamounts,
        a.amount AS localamount,
        a.amount AS truelocalamt,
        0 AS vat_dom_amount,
        ' ' AS vat_code,
        0 AS cost,
        'Parts' AS charge_type,
        'FRA' AS source,
        'Market' AS market_code,
        ' ' AS association_no,
        0 AS vat_curr_amount,
        ' ' AS pay_term_description,
        ' ' AS kdreference,
        ' ' AS customerref,
        ' ' AS deliverydate,
        ' ' AS ship_via,
        ' ' AS delivery_identity,
        ' ' AS identity,
        ' ' AS delivery_address_id,
        ' ' AS invoice_address_id,
        'EUR' AS currency,
        0 AS rma_no,
        ' ' AS invoiceadd1,
        ' ' AS invoiceadd2,
        ' ' AS invoicecity,
        ' ' AS invoicestate,
        ' ' AS invoicezip,
        ' ' AS invoicecountry,
        ' ' AS invoicecounty,
        ' ' AS delivadd1,
        ' ' AS delivadd2,
        ' ' AS delivcity,
        ' ' AS delivstate,
        ' ' AS delivzip,
        ' ' AS delivcountry,
        ' ' AS delivcounty
    FROM
        srcadsalesorder a
    WHERE
        a.salesdate >= TO_DATE('01/01/2010','MM/DD/YYYY')
    UNION ALL
    SELECT DISTINCT
        decode(c.association_no,'DE','220','SE','230','FR','240','IT','210','EU','100','100') AS site,
        r.invoice_no AS invoice_id,
        to_char(r.row_no) AS item_id,
        trunc(r.invoice_date) AS invoicedate,
        r.quantity AS invoiced_qty,
        r.price AS sale_unit_price,
        0 AS discount,
        r.net_curr_amount,
        0 gross_curr_amount,
        r.description AS catalog_desc,
        c.name AS customer_name,
        r.order_no,
        r.customer_no,
        d.cust_grp,
        r.object AS catalog_no,
        ' ' AS authorize_code,
        d.salesman_code,
        f.commission_receiver AS commission_receiver,
        e.district_code,
        e.region_code,
        trunc(r.order_date) AS create_date,
        decode(r.object,b.part_no,upper(b.part_product_code),'OTHER') AS part_product_code,
        decode(r.object,b.part_no,upper(b.part_product_family),'OTHER') AS part_product_family,
        decode(r.object,b.part_no,upper(b.second_commodity),'OTHER') AS second_commodity,
        CASE
                WHEN to_char(r.invoice_date,'MM') = '01' THEN 'January'
                WHEN to_char(r.invoice_date,'MM') = '02' THEN 'February'
                WHEN to_char(r.invoice_date,'MM') = '03' THEN 'March'
                WHEN to_char(r.invoice_date,'MM') = '04' THEN 'April'
                WHEN to_char(r.invoice_date,'MM') = '05' THEN 'May'
                WHEN to_char(r.invoice_date,'MM') = '06' THEN 'June'
                WHEN to_char(r.invoice_date,'MM') = '07' THEN 'July'
                WHEN to_char(r.invoice_date,'MM') = '08' THEN 'August'
                WHEN to_char(r.invoice_date,'MM') = '09' THEN 'September'
                WHEN to_char(r.invoice_date,'MM') = '10' THEN 'October'
                WHEN to_char(r.invoice_date,'MM') = '11' THEN 'November'
                WHEN to_char(r.invoice_date,'MM') = '12' THEN 'December'
            END
        AS invoicemonth,
        CASE
                WHEN to_char(r.invoice_date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN to_char(r.invoice_date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN to_char(r.invoice_date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN to_char(r.invoice_date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS invoiceqtr,
        CASE
                WHEN to_char(r.invoice_date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM r.invoice_date)
                WHEN to_char(r.invoice_date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM r.invoice_date)
                WHEN to_char(r.invoice_date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM r.invoice_date)
                WHEN to_char(r.invoice_date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM r.invoice_date)
            END
        AS invoiceqtryr,
        to_char(r.invoice_date,'MM/YYYY') AS invoicemthyr,
        k.group_id AS group_id,
        decode(b.type_designation,NULL,'Target',b.type_designation) AS type_designation,
        d.customer_no_pay,
        c.corporate_form,
        decode(r.currency_code,'SEK', (r.net_curr_amount * 0.13),'EUR', (r.net_curr_amount * 1.4),'DKK', (r.net_curr_amount * 0.13),r.net_curr_amount
) AS fixedamounts,
        CASE
                WHEN r.currency_code = 'CAD' AND
                     trunc(r.invoice_date) >= TO_DATE('03/01/2013','MM/DD/YYYY') AND
                     trunc(r.invoice_date) <= TO_DATE('12/16/2019','MM/DD/YYYY')
                THEN r.net_curr_amount
                WHEN r.currency_code = 'CAD' AND
                     trunc(r.invoice_date) > TO_DATE('12/16/2019','MM/DD/YYYY')
                THEN r.net_curr_amount * r.rate_used
                WHEN r.currency_code != 'USD' THEN r.net_curr_amount * i.currency_rate
                ELSE r.net_curr_amount
            END
        AS allamounts,
        CASE
                WHEN r.currency_code IN (
                    'SEK',
                    'DKK'
                ) THEN r.net_curr_amount / j.currency_rate
                ELSE r.net_curr_amount
            END
        AS localamount,
        r.net_curr_amount AS truelocalamt,
        0 AS vat_dom_amount,
        ' ' AS vat_code,
        CASE
                WHEN r.object = k.part_no THEN k.inventory_value
                ELSE l.inventory_value * 1.4
            END
        AS cost,
        'Parts' AS charge_type,
        'IFS' AS source,
        'Market' AS market_code,
        ' ' AS association_no,
        0 AS vat_curr_amount,
        ' ' AS pay_term_description,
        ' ' AS kdreference,
        ' ' AS customerref,
        ' ' AS deliverydate,
        ' ' AS ship_via,
        r.customer_no AS delivery_identity,
        r.customer_no AS identity,
        '99' AS delivery_address_id,
        '99' AS invoice_address_id,
        r.currency_code,
        0 AS rma_no,
        ' ' AS invoiceadd1,
        ' ' AS invoiceoadd2,
        ' ' AS invoicecity,
        ' ' AS invoicestate,
        ' ' AS invoicezip,
        ' ' AS invoicecountry,
        ' ' AS invoicecounty,
        ' ' AS delivadd1,
        ' ' AS delivadd2,
        ' ' AS delivcity,
        ' ' AS delivstate,
        ' ' AS delivzip,
        ' ' AS delivcountry,
        ' ' AS delivcounty
    FROM
        instant_invoice_rep r
        LEFT JOIN inventory_part_tab b ON r.object = b.part_no AND
                                          b.contract = '100'
        LEFT JOIN kd_currency_rate_4 i ON to_char(r.invoice_date,'MM/YYYY') = i.valid_from AND
                                          r.currency_code = i.currency_code
        LEFT JOIN kd_currency_rate_1 j ON to_char(r.invoice_date,'MM/YYYY') = j.valid_from AND
                                          r.currency_code = j.currency_code
        LEFT JOIN identity_invoice_info_tab k ON r.customer_no = k.identity AND
                                                 r.company = '100'
        LEFT JOIN inventory_part_unit_cost_sum k ON r.object = k.part_no AND
                                                    k.contract = '100'
        LEFT JOIN inventory_part_unit_cost_sum l ON r.object = k.part_no AND
                                                    k.contract = '210',
        customer_info_tab c,
        cust_ord_customer_tab d,cust_ord_customer_address_tab e
        LEFT JOIN cust_def_com_receiver_tab f ON e.customer_no = f.customer_no
    WHERE
        r.customer_no = c.customer_id AND
        r.customer_no = d.customer_no AND
        c.customer_id = d.customer_no AND
        r.customer_no = e.customer_no AND
        c.customer_id = e.customer_no AND
        d.customer_no = e.customer_no AND
        r.invoice_date >= TO_DATE('08/03/2010','MM/DD/YYYY') AND
        e.addr_no = '99' AND
        r.row_type = '1' AND
        r.object != 'FREIGHT' AND
        r.invoice_no NOT LIKE 'EI%' AND
        c.corporate_form != 'KEY'
    UNION ALL
    SELECT DISTINCT
        decode(c.association_no,'DE','220','SE','230','FR','240','IT','210','EU','100','100') AS site,
        r.invoice_no AS invoice_id,
        to_char(r.row_no) AS item_id,
        trunc(r.invoice_date) AS invoicedate,
        r.quantity AS invoiced_qty,
        r.price AS sale_unit_price,
        0 AS discount,
        r.net_curr_amount,
        0 gross_curr_amount,
        r.description AS catalog_desc,
        c.name AS customer_name,
        r.order_no,
        r.customer_no,
        d.cust_grp,
        r.object AS catalog_no,
        ' ' AS authorize_code,
        d.salesman_code,
        ' ' AS commission_receiver,
        e.district_code,
        e.region_code,
        trunc(r.order_date) AS create_date,
        'Freight' AS part_product_code,
        'Freight' AS part_product_family,
        'Freight' AS second_commodity,
        CASE
                WHEN to_char(r.invoice_date,'MM') = '01' THEN 'January'
                WHEN to_char(r.invoice_date,'MM') = '02' THEN 'February'
                WHEN to_char(r.invoice_date,'MM') = '03' THEN 'March'
                WHEN to_char(r.invoice_date,'MM') = '04' THEN 'April'
                WHEN to_char(r.invoice_date,'MM') = '05' THEN 'May'
                WHEN to_char(r.invoice_date,'MM') = '06' THEN 'June'
                WHEN to_char(r.invoice_date,'MM') = '07' THEN 'July'
                WHEN to_char(r.invoice_date,'MM') = '08' THEN 'August'
                WHEN to_char(r.invoice_date,'MM') = '09' THEN 'September'
                WHEN to_char(r.invoice_date,'MM') = '10' THEN 'October'
                WHEN to_char(r.invoice_date,'MM') = '11' THEN 'November'
                WHEN to_char(r.invoice_date,'MM') = '12' THEN 'December'
            END
        AS invoicemonth,
        CASE
                WHEN to_char(r.invoice_date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN to_char(r.invoice_date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN to_char(r.invoice_date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN to_char(r.invoice_date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS invoiceqtr,
        CASE
                WHEN to_char(r.invoice_date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM r.invoice_date)
                WHEN to_char(r.invoice_date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM r.invoice_date)
                WHEN to_char(r.invoice_date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM r.invoice_date)
                WHEN to_char(r.invoice_date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM r.invoice_date)
            END
        AS invoiceqtryr,
        to_char(r.invoice_date,'MM/YYYY') AS invoicemthyr,
        k.group_id AS group_id,
        'Freight' AS type_designation,
        d.customer_no_pay,
        'Freight' AS corporate_form,
        decode(r.currency_code,'SEK', (r.net_curr_amount * 0.13),'EUR', (r.net_curr_amount * 1.4),'DKK', (r.net_curr_amount * 0.13),r.net_curr_amount
) AS fixedamounts,
        CASE
                WHEN r.currency_code = 'CAD' AND
                     trunc(r.invoice_date) >= TO_DATE('03/01/2013','MM/DD/YYYY') AND
                     trunc(r.invoice_date) <= TO_DATE('12/16/2019','MM/DD/YYYY')
                THEN r.net_curr_amount
                WHEN r.currency_code = 'CAD' AND
                     trunc(r.invoice_date) > TO_DATE('12/16/2019','MM/DD/YYYY')
                THEN r.net_curr_amount * r.rate_used
                WHEN r.currency_code != 'USD' THEN r.net_curr_amount * i.currency_rate
                ELSE r.net_curr_amount
            END
        AS allamounts,
        CASE
                WHEN r.currency_code IN (
                    'SEK',
                    'DKK'
                ) THEN r.net_curr_amount / j.currency_rate
                ELSE r.net_curr_amount
            END
        AS localamount,
        r.net_curr_amount AS truelocalamt,
        0 AS vat_dom_amount,
        ' ' AS vat_code,
        0 AS cost,
        'Freight' AS charge_type,
        'IFS' AS source,
        'Market' AS market_code,
        ' ' AS association_no,
        0 AS vat_curr_amount,
        ' ' AS pay_term_description,
        ' ' AS kdreference,
        ' ' AS customerref,
        ' ' AS deliverydate,
        ' ' AS ship_via,
        r.customer_no AS delivery_identity,
        r.customer_no AS identity,
        '99' AS delivery_address_id,
        '99' AS invoice_address_id,
        r.currency_code,
        0 AS rma_no,
        ' ' AS invoiceadd1,
        ' ' AS invoiceoadd2,
        ' ' AS invoicecity,
        ' ' AS invoicestate,
        ' ' AS invoicezip,
        ' ' AS invoicecountry,
        ' ' AS invoicecounty,
        ' ' AS delivadd1,
        ' ' AS delivadd2,
        ' ' AS delivcity,
        ' ' AS delivstate,
        ' ' AS delivzip,
        ' ' AS delivcountry,
        ' ' AS delivcounty
    FROM
        instant_invoice_rep r
        LEFT JOIN inventory_part_tab b ON r.object = b.part_no AND
                                          b.contract = '100'
        LEFT JOIN kd_currency_rate_4 i ON to_char(r.invoice_date,'MM/YYYY') = i.valid_from AND
                                          r.currency_code = i.currency_code
        LEFT JOIN kd_currency_rate_1 j ON to_char(r.invoice_date,'MM/YYYY') = j.valid_from AND
                                          r.currency_code = j.currency_code
        LEFT JOIN identity_invoice_info_tab k ON r.customer_no = k.identity AND
                                                 r.company = '100'
        LEFT JOIN inventory_part_unit_cost_sum k ON r.object = k.part_no AND
                                                    k.contract = '100'
        LEFT JOIN inventory_part_unit_cost_sum l ON r.object = k.part_no AND
                                                    k.contract = '210',
        customer_info_tab c,
        cust_ord_customer_tab d,cust_ord_customer_address_tab e
        LEFT JOIN cust_def_com_receiver_tab f ON e.customer_no = f.customer_no
    WHERE
        r.customer_no = c.customer_id AND
        r.customer_no = d.customer_no AND
        c.customer_id = d.customer_no AND
        r.customer_no = e.customer_no AND
        c.customer_id = e.customer_no AND
        d.customer_no = e.customer_no AND
        r.invoice_date >= TO_DATE('07/01/2010','MM/DD/YYYY') AND
        e.addr_no = '99' AND
        r.row_type = '1' AND
        r.object = 'FREIGHT' AND
        r.invoice_no NOT LIKE 'EI%' AND
        c.corporate_form != 'KEY'
    UNION ALL
    SELECT
        '100' AS site,
        a.invoice AS invoice_id,
        to_char(a.linenumber) AS item_id,
        trunc(a.invoice_date) invoicedate,
        a.qty AS invoiced_qty,
        a.price AS sales_unit_price,
        a.discount,
        0 AS net_curr_amount,
        0 AS gross_curr_amount,
        ip.description AS catalog_desc,
        c.name AS customer_name,
        a.sales_order AS order_no,
        a.key_code AS customer_no,
        d.cust_grp,
        a.product_code AS catalog_no,
        a.rowkey AS authorize_code,
        d.salesman_code,
        ' ' AS commission_receiver,
        e.district_code,
        e.region_code,
        trunc(a.order_date) AS create_date,
        decode(a.product_code,ip.part_no,ip.part_product_code,'OTHER') AS part_product_code,
        decode(a.product_code,ip.part_no,ip.part_product_family,'OTHER') AS part_product_family,
        decode(a.product_code,ip.part_no,ip.second_commodity,'OTHER') AS second_commodity,
        CASE
                WHEN to_char(a.invoice_date,'MM') = '01' THEN 'January'
                WHEN to_char(a.invoice_date,'MM') = '02' THEN 'February'
                WHEN to_char(a.invoice_date,'MM') = '03' THEN 'March'
                WHEN to_char(a.invoice_date,'MM') = '04' THEN 'April'
                WHEN to_char(a.invoice_date,'MM') = '05' THEN 'May'
                WHEN to_char(a.invoice_date,'MM') = '06' THEN 'June'
                WHEN to_char(a.invoice_date,'MM') = '07' THEN 'July'
                WHEN to_char(a.invoice_date,'MM') = '08' THEN 'August'
                WHEN to_char(a.invoice_date,'MM') = '09' THEN 'September'
                WHEN to_char(a.invoice_date,'MM') = '10' THEN 'October'
                WHEN to_char(a.invoice_date,'MM') = '11' THEN 'November'
                WHEN to_char(a.invoice_date,'MM') = '12' THEN 'December'
            END
        AS invoicemonth,
        CASE
                WHEN to_char(a.invoice_date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN to_char(a.invoice_date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN to_char(a.invoice_date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN to_char(a.invoice_date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS invoiceqtr,
        CASE
                WHEN to_char(a.invoice_date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM a.invoice_date)
                WHEN to_char(a.invoice_date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM a.invoice_date)
                WHEN to_char(a.invoice_date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM a.invoice_date)
                WHEN to_char(a.invoice_date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM a.invoice_date)
            END
        AS invoiceqtryr,
        to_char(a.invoice_date,'MM/YYYY') AS invoicemthyr,
        ' ' AS group_id,
        decode(a.product_code,ip.part_no,ip.type_designation,'Non-Target') AS type_designation,
        a.key_code AS customer_no_pay,
        c.corporate_form,
        a.extensioncurrdisk AS fixedamounts,
        CASE
                WHEN a.currencycode = 'CAD' AND
                     trunc(a.invoice_date) >= TO_DATE('03/01/2013','MM/DD/YYYY') THEN a.extensioncurrdisk
                WHEN a.currencycode != 'USD' THEN a.extensioncurrdisk * g.currency_rate
                ELSE a.extensioncurrdisk
            END
        AS allamounts,
        a.extensioncurrdisk AS localamount,
        a.extensioncurrdisk AS truelocalamt,
        0 AS vat_dom_amount,
        ' ' AS vat_code,
        cs.inventory_value AS cost,
        'Parts' AS charge_type,
        'SI' AS source,
        'Market' AS market_code,
        c.association_no,
        0 AS vat_curr_amount,
        ' ' AS pay_term_description,
        ' ' AS kdreference,
        ' ' AS customer_ref,
        to_char(a.invoice_date,'MM/DD/YYYY') AS deliverydate,
        ' ' AS ship_via,
        a.key_code AS delivery_identity,
        a.key_code AS identity,
        '99' AS delivery_address_id,
        '99' AS invoice_address_id,
        a.currencycode AS currency,
        0 AS rma_no,
        cis.address1 AS invoiceadd1,
        cis.address2 AS invoiceadd2,
        cis.city AS invoicecity,
        cis.state AS invoicestate,
        cis.zip_code AS invoicezip,
        iso_country_api.decode(cis.country) AS invoicecountry,
        cis.county AS invoicecounty,
        cis.address1 AS delivadd1,
        cis.address2 AS delivadd2,
        cis.city AS delivcity,
        cis.state AS delivstate,
        cis.zip_code AS delivzip,
        iso_country_api.decode(cis.country) AS delivcountry,
        cis.county AS delivcounty
    FROM
        srinvoicessi a
        LEFT JOIN inventory_part_tab ip ON a.product_code = ip.part_no AND
                                           ip.contract = '100'
        LEFT JOIN inventory_part_unit_cost_sum cs ON a.product_code = cs.part_no AND
                                                     cs.contract = '100'
        LEFT JOIN customer_info_address_tab cis ON a.key_code = cis.customer_id AND
                                                   cis.address_id = '99'
        LEFT JOIN identity_invoice_info_tab f ON a.key_code = f.identity AND
                                                 f.company = '100'
        LEFT JOIN kd_currency_rate_4 g ON a.currencycode = g.currency_code AND
                                          to_char(a.invoice_date,'MM/YYYY') = g.valid_from,
        customer_info_tab c,
        cust_ord_customer_tab d,
        cust_ord_customer_address_tab e
    WHERE
        a.key_code = c.customer_id AND
        a.key_code = d.customer_no AND
        a.key_code = e.customer_no AND
        c.customer_id = d.customer_no AND
        c.customer_id = e.customer_no AND
        d.customer_no = e.customer_no AND
        trunc(a.invoice_date) >= TO_DATE('01/01/2010','MM/DD/YYYY') AND
        e.addr_no = '99'
UNION ALL
    SELECT "SITE","INVOICE_ID","ITEM_ID","INVOICEDATE","INVOICED_QTY","SALE_UNIT_PRICE","DISCOUNT","NET_CURR_AMOUNT","GROSS_CURR_AMOUNT","CATALOG_DESC","CUSTOMER_NAME","ORDER_NO","CUSTOMER_NO","CUST_GRP","CATALOG_NO","AUTHORIZE_CODE","SALESMAN_CODE","COMMISSION_RECEIVER","DISTRICT_CODE","REGION_CODE","CREATEDATE","PART_PRODUCT_CODE","PART_PRODUCT_FAMILY","SECOND_COMMODITY","INVOICEMONTH","INVOICEQTR","INVOICEQTRYR","INVOICEMTHYR","GROUPID","TYPE_DESIGNATION","CUSTOMER_NO_PAY","CORPORATE_FORM","FIXEDAMOUNTS","ALLAMOUNTS","LOCALAMOUNT","TRUELOCALAMT","VAT_DOM_AMOUNT","VAT_CODE","COST","CHARGE_TYPE","SOURCE","MARKET_CODE","ASSOCIATION_NO","VAT_CURR_AMOUNT","PAY_TERM_DESCRIPTION","KD_REFERENCE","CUSTOMERREF","DELIVERY_DATE","SHIP_VIA","DELIVERY_IDENTITY","IDENTITY","DELIVERY_ADDRESS_ID","INVOICE_ADDRESS_ID","CURRENCY","RMA_NO","INVOICEADD1","INVOICEADD2","INVOICECITY","INVOICESTATE","INVOICEZIP","INVOICECOUTRY","INVOICECOUNTY","DELIVADD1","DELIVADD2","DELIVCITY","DELIVSTATE","DELIVZIP","DELIVCOUTRY","DELIVCOUNTY" FROM kd_pt_sales_data;
