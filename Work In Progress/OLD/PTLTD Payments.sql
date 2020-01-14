SELECT
                pmt.accountnum,
                pmt.currencycode,
                pmt.transdate,
                pmt.voucher,
                pmt.invoice,
                pmt.txt,
                pmt.paymmode,
                pmt.paymreference,
                pmt.recid,
                pmt.amountcur AS amount_local,
                CASE
                    WHEN pmt.currencycode = 'ILS' THEN pmt.amountcur * pmt.rate_ils_to_usd
                    WHEN pmt.currencycode = 'USD' THEN pmt.amountcur
                    ELSE (pmt.amountcur * pmt.rate_local_to_ils) * pmt.rate_ils_to_usd
                END AS amount_usd
FROM
                kd_ptltd_payments pmt