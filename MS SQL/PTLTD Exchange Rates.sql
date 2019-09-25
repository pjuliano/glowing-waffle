SELECT
				exc.fromdate,
				exc.currencycode,
				exc.exchrate/100 AS rate_to_ils,
				exc.exchrate/100 *
				(
					SELECT TOP 1
									1/(exc2.exchrate/100)
					FROM
									Paltop_ax09_Live_db.dbo.exchrates exc2
					WHERE
									CAST(exc2.fromdate AS DATE) >= CAST(exc.fromdate AS DATE)
										AND exc2.dataareaid = 'ltd'
										AND exc2.currencycode = 'USD'
				) AS rate_to_usd,
                exc.recid
				
FROM
				Paltop_ax09_Live_db.dbo.exchrates exc
WHERE
				exc.dataareaid = 'ltd'
					AND exc.currencycode IN 
						(
							'EUR',
							'USD',
							'GBP'
						)
                    AND CAST(exc.fromdate AS DATE) >= CONVERT(DATE, '01-01-2018', 21)
ORDER BY
				exc.fromdate DESC