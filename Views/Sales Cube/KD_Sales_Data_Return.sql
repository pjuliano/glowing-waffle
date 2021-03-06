CREATE OR REPLACE VIEW kd_sales_data_cube AS

SELECT          sc.company                                  AS company,
                sc.invoice_id                               AS invoice_id,
                sc.item_id                                  AS item_id,
                sc.invoice_date                             AS invoicedate,
                sc.invoiced_qty                             AS invoiced_qty,
                sc.unit_price_usd                           AS sale_unit_price,
                invitem.n5                                  AS discount,
                sc.total_price                              AS net_curr_amount,
                sc.total_price + invitem.vat_curr_amount    AS gross_curr_amount,
                sc.catalog_desc                             AS catalog_desc,
                sc.delivery_customer_name                   AS customer_name,
                sc.order_id                                 AS order_no,
                sc.delivery_customer_id                     AS customer_no,
                custordcust.cust_grp                        AS cust_grp,
                sc.catalog_no                               AS catalog_no,
                SUBSTR(invhead.c1,1,35)                     AS authorize_code,
                sc.delivery_salesman_code                   AS salesman_code,
                sc.delivery_commission_rec                  AS commission_receiver,
                custordcustadd.district_code                AS district_code,
                sc.delivery_region_code                     AS region_code,
                invhead.creation_date                       AS create_date,
                sc.part_product_code                        AS part_product_code,
                sc.part_product_family                      AS part_product_family,
                sc.second_commodity                         AS second_commodity,
                TO_CHAR(sc.invoice_date,'Month')            AS invoicemonth,
                'QTR' || sc.invoice_quarter                 AS invoiceqtr,
                 sc.invoice_month 
                    || '/' || sc.invoice_year               AS invoicemthyr,
                iii.group_id                                AS group_id,
                DECODE(sc.catalog_no,
                    invpart.part_no,
                    invpart.type_designation,
                    'Non-Target')                           AS type_designation,
                    sc.invoice_customer_id                  AS customer_no_pay,
                sc.corporate_form                           AS corporate_form,
                DECODE(sc.order_currency,
                    'SEK',
                    (sc.total_price * 0.13),
                    'EUR',
                    (sc.total_price * 1.4),
                    'DKK',
                    (sc.total_price * 0.13),
                    sc.total_price)                         AS fixed_amounts,
                sc.total_price_usd                          AS allamounts,          --amount in USD
                sc.total_price                              AS localamount,         --amount in EUR
                NULL                                        AS truelocalamt,        --amount in local currency
                invitem.vat_dom_amount                      AS vat_dom_amount,
                invitem.vat_code                            AS vat_code,
                costs.inventory_value                       AS cost,
                DECODE(sc.part_product_family,
                    'FREIGHT',
                    'Freight',
                    'Parts')                                AS charge_type,
                sc.market_code                              AS market_code,
                sc.delivery_association_no                  AS association_no,
                invhead.vat_curr_amount                     AS vat_curr_amount,
                pmnt.description                            AS pay_term_description,
                SUBSTR(invhead.c1,1,35)                     AS kdreference,
                SUBSTR(invhead.c2,1,30)                     AS customerref,
                TO_CHAR(invhead.D3,'MM/DD/YYYY')            AS deliverydate,
                SUBSTR(invhead.c3,1,35)                     AS ship_via,
                invhead.delivery_identity                   AS delivery_identity,
                invhead.delivery_address_id                 AS delivery_address_id,
                sc.invoice_address_id                       AS invoice_address_id,
                sc.order_currency                           AS currency,
                sc.rma_id                                   AS rma_no,
                sc.invoice_street_1                         AS invoiceadd1,
                sc.invoice_street_2                         AS invoiceadd2,
                sc.invoice_city                             AS invoicecity,
                sc.invoice_state                            AS invoicestate,
                sc.invoice_zip                              AS invoicezip,
                sc.invoice_country                          AS invoicecountry,
                custinfoadd.county                          AS invoicecounty,
                sc.delivery_street_1                        AS delivadd1,
                sc.delivery_street_2                        AS delivadd2,
                sc.delivery_city                            AS delivcity,
                sc.delivery_state                           AS delivstate,
                sc.delivery_zip                             AS delivzip,
                sc.delivery_country                         AS delivcountry,
                custinfoadddel.county                       AS delivcounty
                              
FROM            kd_sales_cube sc
                LEFT JOIN invoice_tab invhead ON
                    SUBSTR(sc.invoice_id,3) = invhead.invoice_no
                    AND sc.company = invhead.company
                    AND SUBSTR(sc.invoice_id,1,2) = invhead.series_id
                LEFT JOIN invoice_item_tab invitem ON
                    invhead.invoice_id = invitem.item_id
                    AND invhead.company = invitem.company
                LEFT JOIN cust_ord_customer_tab custordcust ON 
                    sc.delivery_customer_id = custordcust.customer_no
                LEFT JOIN customer_info_tab custinfo ON 
                    invhead.identity = custinfo.customer_id
                LEFT JOIN customer_info_address_tab custinfoadd ON  
                    invhead.identity = custinfoadd.customer_id
                    AND invhead.invoice_address_id = custinfoadd.address_id
                LEFT JOIN customer_info_address_type_tab custinfoaddtype ON  
                    invhead.identity = custinfoaddtype.customer_id
                    AND custinfoadd.address_id = custinfoaddtype.address_id
                    AND custinfoaddtype.address_type_code = 'INVOICE'
                LEFT JOIN cust_ord_customer_address_tab custordcustadd ON 
                    invhead.identity = custordcustadd.customer_no
                    AND custinfoadd.address_id = custordcustadd.addr_no
                LEFT JOIN identity_invoice_info_tab iii ON  
                    sc.delivery_customer_id = iii.identity
                    AND sc.company = iii.company
                LEFT JOIN inventory_part_tab invpart ON  
                    sc.catalog_no = invpart.part_no
                    AND sc.company = invpart.contract
                LEFT JOIN payment_term_tab pmnt ON  
                    sc.pay_term_id = pmnt.pay_term_id
                    AND sc.company = pmnt.company
                LEFT JOIN customer_info_address_tab custinfoadddel ON  
                    invhead.identity = custinfoadddel.customer_id
                    AND invhead.delivery_address_id = custinfoadddel.address_id
                LEFT JOIN customer_info_address_type_tab custinfoaddtypedel ON  
                    invhead.identity = custinfoaddtypedel.customer_id
                    AND custinfoadddel.address_id = custinfoaddtypedel.address_id
                    AND custinfoaddtypedel.address_type_code = 'DELIVERY'
                LEFT JOIN kd_cost_100 costs ON
                    sc.catalog_no = costs.part_no

WHERE           sc.source != 'PTLTD'