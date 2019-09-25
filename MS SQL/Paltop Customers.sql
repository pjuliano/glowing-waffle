WITH invdates AS
	(
		SELECT			
                        orderaccount,
                        min(invoicedate) firstorder,
                        max(invoicedate) latestorder
		FROM			
		                Paltop_ax09_Live_db.dbo.CUSTINVOICEJOUR
		GROUP BY		
		                orderaccount
	)

SELECT			
                cust.recid,
				cust.accountnum,
				cust.name,
				cust.salesgroup,
				cust.currency,
				cust.vatregistrationnumber_il,
				cust.partyid,
				cust.dlvmode,
				cust.paymtermid,
				cust.creditmax,
				invdates.firstorder,
				invdates.latestorder,
				cust.pricegroup,
				cust.memo,
				cust.custgroup
FROM			
                Paltop_ax09_Live_db.DBO.CUSTTABLE cust
				LEFT JOIN invdates ON
					cust.accountnum = invdates.orderaccount
WHERE			
                cust.dataareaid = 'ltd'
                AND 
                    (
                        CAST(invdates.firstorder AS DATE) >= CAST('2001-01-01 00:00:00.0' AS DATE)
                        OR invdates.firstorder IS NULL
                    )
                AND cust.custgroup NOT IN ('90','Marketing','R&D')
ORDER BY
                cust.accountnum