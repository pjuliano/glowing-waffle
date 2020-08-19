CREATE OR REPLACE VIEW kd_ecom_geocodes AS
SELECT DISTINCT
                sc.order_id,
                sc.invoice_customer_id,
                sc.invoice_customer_name,
                sc.delivery_address_id,
                sc.delivery_state AS state,
                sc.invoice_id,
                sc.invoice_date,
                cia.jurisdiction_code AS geocode,
                CASE 
                    WHEN sc.invoice_id LIKE 'CR%'
                    THEN coc.charge_amount * -1
                    ELSE coc.charge_amount
                END AS charge_amount
FROM
                ifsapp.kd_sales_cube sc
      LEFT JOIN ifsapp.customer_info_address cia
             ON sc.invoice_customer_id = cia.customer_id
            AND sc.delivery_address_id = cia.address_id
      LEFT JOIN ifsapp.customer_order_charge coc
             ON sc.order_id = coc.order_no
            AND coc.charge_type = 'ECTAX'
WHERE
                sc.order_id LIKE 'M%'
            AND sc.invoice_date > ADD_MONTHS(LAST_DAY(SYSDATE),-2)
            AND sc.invoice_date < LAST_DAY(ADD_MONTHS(SYSDATE,-1))
ORDER BY
                sc.invoice_date ASC,
                sc.order_id DESC