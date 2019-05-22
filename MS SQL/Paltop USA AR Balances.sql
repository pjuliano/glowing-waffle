SELECT			ct.accountnum,
				ct.transdate,
				ct.invoice,
				ct.amountcur,
				ct.settleamountcur,
				ct.amountcur - ct.settleamountcur AS balance,
				ct.currencycode,
				ct.duedate,
				ct.voucher
FROM			Paltop_ax09_Live_db.dbo.CustTrans CT
				LEFT JOIN Paltop_ax09_Live_db.dbo.CUSTINVOICEJOUR CIJ
					ON	ct.invoice = cij.invoiceid
WHERE			ct.dataareaid = 'usa' AND 
				ct.amountcur - ct.settleamountcur != 0
ORDER BY		ct.transdate DESC