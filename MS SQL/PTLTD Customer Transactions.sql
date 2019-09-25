SELECT
				ct.ACCOUNTNUM,
				(
					SELECT
						top 1 exchrate 
					FROM
						paltop_ax09_live_db.dbo.exchrates c 
					WHERE
						c.currencycode = ct.currencycode 
						AND c.dataareaid = 'LTD' 
						AND CAST(fromdate AS DATE) <= CAST(ct.transdate AS DATE)
					ORDER BY
						c.fromdate DESC
				) / 100 AS rate_local_to_ils,
				1/(
				(
					SELECT
						top 1 exchrate 
					FROM
						paltop_ax09_live_db.dbo.exchrates c 
					WHERE
						c.currencycode = 'USD'
						AND c.dataareaid = 'LTD' 
						AND CAST(fromdate AS DATE) <= CAST(ct.transdate AS DATE)
					ORDER BY
						c.fromdate DESC
				) / 100) AS rate_ils_to_usd,
				ct.TRANSDATE,
				ct.VOUCHER,
				ct.INVOICE,
				ct.TXT,
				ct.AMOUNTCUR,
				ct.CURRENCYCODE,
				ct.PAYMMODE,
				ct.PAYMREFERENCE,
				ct.RECID
FROM
				Paltop_ax09_Live_db.dbo.CustTrans ct
WHERE
				ct.DATAAREAID = 'LTD'