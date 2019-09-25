WITH LATEST_PRICES AS
	(
		SELECT
						pdt.ITEMRELATION,
						pdt.ACCOUNTRELATION,
						pdt.INVENTDIMID,
						pdt.DATAAREAID,
						MAX(pdt.FROMDATE) AS fromdate
		FROM
						Paltop_ax09_Live_db.dbo.PRICEDISCTABLE pdt,
						Paltop_ax09_Live_db.dbo.PRICEDISCGROUP pdg
		WHERE
						pdt.DATAAREAID = 'virt'
							AND pdg.DATAAREAID = pdg.DATAAREAID
							AND pdg.GROUPID = pdt.ACCOUNTRELATION
							AND pdg.NAME NOT LIKE '%not active%'
--BEGIN TEST BLOCK-----------------------------------------------------
							--AND accountrelation IN
							--	(
							--		'israel',
							--		'Ardikian'
							--	)
--END TEST BLOCK-------------------------------------------------------
		GROUP BY
						pdt.ITEMRELATION,
						pdt.ACCOUNTRELATION,
						pdt.INVENTDIMID,
						pdt.DATAAREAID
	)

SELECT
				lp.ITEMRELATION,
				pdt.ACCOUNTRELATION,
				pdt.CURRENCY,
				pdt.AMOUNT,
				id.INVENTSIZEID,
				pdt.QUANTITYAMOUNT,
				pdt.PERCENT1
FROM
				Paltop_ax09_Live_db.dbo.PRICEDISCTABLE pdt,
				LATEST_PRICES lp,
				Paltop_ax09_Live_db.dbo.INVENTDIM id
WHERE
				pdt.itemrelation = lp.ITEMRELATION
					AND pdt.FROMDATE = lp.fromdate
					AND pdt.ACCOUNTRELATION = lp.ACCOUNTRELATION
					AND pdt.INVENTDIMID = lp.INVENTDIMID
					AND pdt.DATAAREAID = lp.DATAAREAID
					AND pdt.INVENTDIMID = id.INVENTDIMID
					AND pdt.DATAAREAID = id.DATAAREAID
--BEGIN TEST BLOCK-----------------------------------------------------
					--AND pdt.ITEMRELATION = '41-70059'
					--AND pdt.ACCOUNTRELATION = 'Ardikian'

--GROUP BY
--				lp.ITEMRELATION,
--				pdt.ACCOUNTRELATION,
--				pdt.CURRENCY,
--				pdt.AMOUNT,
--				id.INVENTSIZEID,
--				pdt.QUANTITYAMOUNT
--HAVING
--				Count(1) > 2
--END TEST BLOCK-------------------------------------------------------