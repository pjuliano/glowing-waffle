SELECT
         invoicedate,
         TO_CHAR (invoicedate,'DAY') AS DAY,
         COUNT (order_no) AS orders,
         ROUND (AVG (allamounts),2) avg_order_amt,
         SUM (allamounts) AS total
FROM
         kd_sales_data_request
WHERE
         extract (YEAR FROM invoicedate) = 2020
         AND charge_type IN ('Parts',
                             'Financing')
         AND corporate_form = 'DOMDIR'
         AND catalog_no != '3DBC-22001091'
         AND
         (
                  (
                           order_no NOT LIKE 'W%'
                           AND order_no NOT LIKE 'X%'
                  )
                  OR order_no IS NULL
         )
         AND
         (
                  market_code != 'PREPOST'
                  OR market_code IS NULL
         )
         AND invoice_id != 'CR1001802096'
         AND
         (
                  order_no != 'C512921'
                  OR order_no IS NULL
         )
GROUP BY
         invoicedate
ORDER BY
         invoicedate DESC