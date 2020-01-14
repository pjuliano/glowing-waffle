CREATE OR REPLACE VIEW kd_boomi_backorder AS 
SELECT
                cust.salesman,
                bo.customer_no,
                bo.name,
                bo.order_no,
                bo.line_no,
                bo.rel_no,
                bo.order_status,
                bo.order_id,
                bo.catalog_no,
                bo.catalog_desc,
                bo.revised_qty_due AS qty_ordered,
                bo.qty_shipped,
                bo.qty_backord,
                bo.qty_assigned,
                bo.available,
                bo.discount_price * bo.qty_backord AS backorder_amt
FROM
                ifsinfo.kd_backorder bo
                JOIN ifsinfo.customers cust
                    ON bo.customer_id = cust.customer_no
                        AND bo.contract = '100'
WHERE
                bo.order_status != 'Planned'
                    AND kd_get_corporate_form(bo.customer_no) = 'DOMDIR'
                    AND 
                        (
                            (
                                bo.order_ID = 'CO'
                                    AND bo.qty_assigned - bo.qty_backord != 0
                            )
                        OR
                            (
                                bo.order_id != 'CO'
                                    AND bo.available - bo.qty_backord > 0
                            )
                        )        