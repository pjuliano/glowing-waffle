CREATE OR REPLACE VIEW kd_boomi_cust_balance AS
WITH
    last_pmnt AS
        (
            SELECT
                            identity AS customer_id,
                            MAX(voucher_date) AS last_payment_date
            FROM
                            ledger_transaction_cu_qry
            WHERE
                            series_id = 'CUPAY'
            GROUP BY
                            identity
        )

SELECT          
                ipicq.identity,
                ci.name,
                decode(coce.salesman_code,'501','999','800','999',coce.salesman_code) AS salesman_code,
                ipicq.balance,
                coce.currency_code,
                cic.credit_limit,
                cic.credit_block,
                TO_CHAR(TRUNC(lp.last_payment_date),'MM/DD/YYYY') AS last_payment_date
FROM            
                identity_pay_info_cu_qry ipicq,
                cust_ord_customer_ent coce,
                customer_info ci
                LEFT JOIN last_pmnt lp
                    ON ci.customer_id = lp.customer_id,
                customer_credit_info_cust cic
WHERE           
                ipicq.identity = coce.customer_id
                    AND coce.customer_id = ci.customer_id
                    AND coce.customer_id = cic.identity
                    AND cic.company = 100
                    AND ci.corporate_form NOT IN 
                        (
                            'FRA',
                            'ITL',
                            'SWE',
                            'IT',
                            'BENELUX',
                            'GER',
                            'KEY'
                        )
                    AND coce.salesman_code NOT IN 
                        (
                            '908',
                            '504',
                            '317',
                            '210-001',
                            '210-098',
                            '220-160',
                            '220-140',
                            '220-600',
                            '220-100',
                            '*'
                        )
                    AND ipicq.identity != 'CATEMP'
                    AND ipicq.company = '100'