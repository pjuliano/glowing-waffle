--Create Or Replace View KD_Sales As 
   SELECT   'IFS' AS source,
            invitem.company,
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
            custordcustadd.region_code,
            custord.salesman_code,
            personout.name AS salesman_name,
            custorder.salesman_code AS order_salesman_code,
            comrec.commission_receiver,
            personin.name AS commission_receiver_name,
            custinfo.association_no,
            invhead.identity AS customer_id,
            custinfo.name AS customer_name,
                  /* Decode statements to IIMast or IIDetail account for IIs having their data stored outside InvHead or InvItem. */
            --DECODE(invitem.c1, NULL, client_sys.get_item_value('ORDER_NO', iimast.head_data), invitem.c1) AS order_id,
            invitem.c1 as order_id,
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
            coalesce(invitem.c6,invitem.c3) as catalog_desc,
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
            invitem.net_curr_amount / nullif(invitem.n2, 0) AS unit_price,
            invitem.net_curr_amount total_price,
            invhead.n1 AS currency_rate,
            invitem.vat_dom_amount AS tax_amount,
            invitem.vat_code AS tax_code,
            invitem.company || invhead.series_id || invhead.invoice_no || TO_CHAR(invitem.item_id) || TO_CHAR(invhead.invoice_date,'MMDDYYYY') AS recid
            
     FROM   invoice_tab invhead
LEFT JOIN   invoice_item_tab invitem
       ON   invhead.invoice_id = invitem.invoice_id
      AND   invhead.company = invitem.company
--LEFT JOIN   instant_invoice_master_rpt iimast
--       ON   invhead.series_id || invhead.invoice_no = iimast.invoice_no
--LEFT JOIN   instant_invoice_detail_rpt iidetail
--       ON   iimast.result_key = iidetail.result_key
--      AND   iidetail.row_type = 1
--      AND   invitem.item_id = iidetail.row_no + 1
LEFT JOIN   sales_part_tab salespart
       ON   invitem.c5 = salespart.catalog_no --DECODE(invitem.c5, NULL, iidetail.object, invitem.c5) = salespart.catalog_no
      AND   DECODE(invitem.company, '241', '240', invitem.company) = salespart.contract
LEFT JOIN   inventory_part_tab inventpart
       ON   invitem.c5 = inventpart.part_no --DECODE(invitem.c5, NULL, iidetail.object, invitem.c5) = inventpart.part_no
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
      --AND   invhead.company = DECODE(iimast.comp_country,'UNITED STATES','100','ITALY','210','GERMANY','220','DEUTSCHLAND','220','FRANCE','240','SWEDEN','230',NULL)
     
     WHERE  invhead.series_id != 'CI'
       AND  invhead.party_type = 'CUSTOMER'
       AND  invhead.rowstate != 'Preliminary'
       AND  invhead.rowstate != 'Cancelled'