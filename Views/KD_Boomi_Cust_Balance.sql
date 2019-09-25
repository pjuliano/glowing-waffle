CREATE OR REPLACE VIEW KD_BOOMI_CUST_BALANCE AS
SELECT          ipicq.identity,
                ci.name,
                DECODE(coce.salesman_code,'501','999','800','999',coce.salesman_code) AS salesman_code,
                ipicq.balance,
                coce.currency_code
FROM            identity_pay_info_cu_qry ipicq,
                cust_ord_customer_ent coce,
                customer_info ci
WHERE           ipicq.identity = coce.customer_id
                AND coce.customer_id = ci.customer_id
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