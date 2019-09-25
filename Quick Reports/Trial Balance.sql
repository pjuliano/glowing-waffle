SELECT
                SUBSTR(text_normal,1,4) AS account,
                TRIM(SUBSTR(text_normal, 5, 50)) AS account_desc,
                TRIM(SUBSTR(text_normal, 55, 17)) AS year_opening_balance,
                TRIM(SUBSTR(text_normal, 72, 17)) AS period_opening_balance,
                TRIM(SUBSTR(text_normal, 89, 17)) AS period_debit,
                TRIM(SUBSTR(text_normal, 107, 17)) AS period_credit,
                TRIM(SUBSTR(text_normal, 123, 17)) AS period_net,
                TRIM(SUBSTR(text_normal, 140, 17)) AS period_ending_balance
FROM
                IFSAPP.finrep_rep
WHERE
                result_key = '&ResultKey'
                    AND text_normal IS NOT NULL
ORDER BY
                row_no ASC