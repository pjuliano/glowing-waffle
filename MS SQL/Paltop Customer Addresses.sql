WITH INVDATES AS
	(
		SELECT			
                        ORDERACCOUNT,
                        min(INVOICEDATE) FIRSTORDER,
                        max(INVOICEDATE) LATESTORDER
		FROM			
		                Paltop_ax09_Live_db.dbo.CUSTINVOICEJOUR
		GROUP BY		
		                ORDERACCOUNT
	)

SELECT			cust.ACCOUNTNUM,
				cust.recid AS CUST_RECID,
				addr.RECID,
				addr.NAME,
				addr.STREET,
				addr.CITY,
				addr.STATE,
				addr.ZIPCODE,
				addr.COUNTY,
				addr.COUNTRYREGIONID,
				CASE
					WHEN addr.TYPE = 0 
					THEN 'N/A'
					WHEN addr.TYPE = 1
					THEN 'INVOICE'
					WHEN addr.TYPE = 2
					THEN 'DELIVERY'
					WHEN addr.TYPE = 3
					THEN 'ALT. DELIVERY'
					WHEN addr.TYPE = 4
					THEN 'SWIFT'
					WHEN addr.TYPE = 5
					THEN 'PAYMENT'
					WHEN addr.TYPE = 6
					THEN 'SERVICE'
					WHEN addr.TYPE = 7 
					THEN 'HOME'
					WHEN addr.TYPE = 8
					THEN 'OTHER'
					WHEN addr.TYPE = 9
					THEN 'BUSINESS'
					WHEN addr.TYPE = 10
					THEN 'REMIT TO'
					WHEN addr.TYPE = 11
					THEN '3RD PARTY'
					ELSE 'UNKNOWN'
				END AS TYPE,
				INVDATES.FIRSTORDER AS CUST_FIRSTORDER,
				INVDATES.LATESTORDER AS CUST_LATESTORDER
FROM			
				Paltop_ax09_Live_db.dbo.CUSTTABLE cust,
				Paltop_ax09_Live_db.dbo.DIRPARTYADDRESSRELATIONSHIP dpar,
				Paltop_ax09_Live_db.dbo.DIRPARTYADDRESSRELATIONSHI1066 dparm,
				Paltop_ax09_Live_db.dbo.ADDRESS addr,
				INVDATES
WHERE			
					cust.DATAAREAID = 'ltd'
					AND dpar.DATAAREAID = 'virt'
					AND cust.custgroup NOT IN ('90','Marketing','R&D')
					AND cust.PARTYID = dpar.PARTYID
					AND dparm.PARTYADDRESSRELATIONSHIPRECID = dpar.RECID
					AND dparm.REFCOMPANYID = cust.DATAAREAID
					AND addr.DATAAREAID = dparm.REFCOMPANYID
					AND addr.RECID = dparm.ADDRESSRECID
					AND cust.ACCOUNTNUM = INVDATES.ORDERACCOUNT
					and cust.recid = '5637145835'