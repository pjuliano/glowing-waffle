SELECT
                bal.accountnum,
                cust.name,
                cust.currency,
                SUM
                    (
                        CASE
                            WHEN bal.currencycode = cust.currency
                            THEN bal.balance
                            WHEN bal.currencycode = 'ILS'
                                AND cust.currency = 'USD'
                            THEN bal.balance * COALESCE(rawd.rate_usd, bal.rate_ils_to_usd)
                            WHEN bal.currencycode = 'USD'
                                AND cust.currency = 'ILS'
                            THEN bal.balance / COALESCE(rawd.rate_usd, bal.rate_ils_to_usd)
                        END
                    ) AS balance_local,
                SUM
                    (
                        CASE
                            WHEN bal.balance = 0 
                            THEN 0
                            WHEN bal.currencycode = 'USD'
                            THEN bal.balance
                            WHEN bal.currencycode = 'ILS'
                            THEN bal.balance * COALESCE(rawd.rate_usd, bal.rate_ils_to_usd)
                            ELSE bal.balance * COALESCE(rawd.rate_ils, bal.rate_local_to_ils) * COALESCE(rawd.rate_usd, bal.rate_ils_to_usd)
                        END 
                    ) AS balance_usd
FROM
                kd_ptltd_cust_balance bal
                LEFT JOIN 
                (
                    SELECT
                                    rawd.invoiceno,
                                    SUM(rawd.amt_local),
                                    MAX(rawd.rate_ils) AS rate_ils,
                                    MAX(rawd.rate_usd) AS rate_usd
                    FROM
                                    kd_ptltd_raw_data rawd
                    GROUP BY
                                    rawd.invoiceno
                ) rawd
                    ON bal.invoiceno = rawd.invoiceno
                LEFT JOIN kd_ptltd_cust cust
                    ON bal.accountnum = cust.accountnum
WHERE
                bal.balance IS NOT NULL
                    AND bal.invoiceno IS NOT NULL
GROUP BY
                bal.accountnum,
                cust.name,
                cust.currency;