WITH invoices AS 
(
    SELECT
        UPPER(b.dataareaid) company,
        UPPER(a.dlvcountryregionid) territory,
        UPPER(e.custgroup) salesmngr,
        a.deliveryname AS customer,
        a.invoiceaccount customerno,
        b.invoicedate,
        a.invoiceid AS invoiceno,
        d.psgfamilyofitem family,
        d.name AS groupid,
        replace(replace(b.name, CHAR(13), ''), CHAR(10), '') item,
        b.itemid itemno,
        a.currencycode local_curr,
        b.lineamount AS amt_local,
        a.exchrate / 100 AS rate_ils,
        b.lineamountmst AS amt_ils,
        1 / ( (
        SELECT
            top 1 exchrate 
        FROM
            paltop_ax09_live_db.dbo.exchrates c 
        WHERE
            c.currencycode = 'USD' 
            AND c.dataareaid = 'LTD' 
            AND CAST(fromdate AS DATE) <= CAST( b.invoicedate AS DATE)
        ORDER BY
            c.fromdate DESC) / 100 ) rate_usd,
            (
                SELECT
                    top 1 CAST(fromdate AS DATE) 
                FROM
                    paltop_ax09_live_db.dbo.exchrates c 
                WHERE
                    c.currencycode = 'USD' 
                    AND c.dataareaid = 'LTD' 
                    AND CAST(fromdate AS DATE) <= CAST(b.invoicedate AS DATE )
                ORDER BY
                    c.fromdate DESC
            ) AS rate_date,
            b.lineamount AS amt,
            b.qty,
            CONVERT(INT, b.linenum) AS line_item_no,
            (
                SELECT
                    top 1 price 
                FROM
                    paltop_ax09_live_db.dbo.inventtablemodule 
                WHERE
                    moduletype = 2 
                ORDER BY
                    modifieddatetime DESC
            ) AS list_price,
            c.itemgroupid,
            b.recid,
            a.salesid,
            d.name AS invent_item_group_name,
            a.payment,
            d.psgfamilyofitem,
            b.SALESGROUP,
			a.DELIVERYSTREET,
			a.DELIVERYCITY,
			a.DLVSTATE,
			a.DLVZIPCODE,
			a.DLVCOUNTRYREGIONID,
			a.INVOICESTREET,
			a.INVOICECITY,
			a.INVSTATE,
			a.INVZIPCODE,
			a.INVCOUNTRYREGIONID
        FROM
            paltop_ax09_live_db.dbo.custinvoicejour a 
            LEFT JOIN
                paltop_ax09_live_db.dbo.custinvoicetrans b 
                ON a.invoiceid = b.invoiceid 
                AND a.dataareaid = b.dataareaid 
            LEFT JOIN
                paltop_ax09_live_db.dbo.inventtable c 
                ON b.itemid = c.itemid 
                AND c.dataareaid = 'virt' 
            LEFT JOIN
                paltop_ax09_live_db.dbo.inventitemgroup d 
                ON c.itemgroupid = d.itemgroupid 
                AND d.dataareaid = 'virt' 
            LEFT JOIN 
				Paltop_ax09_Live_db.dbo.CUSTTABLE e
				ON a.INVOICEACCOUNT = e.ACCOUNTNUM 
				AND e.DATAAREAID = 'ltd'
        WHERE
            a.dataareaid = 'LTD' 
            AND a.invoicedate >= CONVERT(DATE, '01-01-2019', 105) 
            AND e.custgroup != '90' 
)
SELECT
    company,
    territory,
    salesmngr,
    customer,
    customerno,
    invoicedate,
    invoiceno,
    family,
    item,
    itemno,
    local_curr,
    SUM(amt_local) amt_local,
    rate_ils,
    SUM(amt_ils) AS amt_ils,
    rate_usd,
    rate_date,
    round(SUM(rate_usd * amt_ils), 2) amt_usd,
    SUM(qty) qty,
    line_item_no,
    list_price,
    itemgroupid,
    recid,
    salesid,
    invent_item_group_name,
    payment,
    psgfamilyofitem,
    salesgroup,
	DELIVERYSTREET,
	DELIVERYCITY,
	DLVSTATE,
	DLVZIPCODE,
	DLVCOUNTRYREGIONID,
	INVOICESTREET,
	INVOICECITY,
	INVSTATE,
	INVZIPCODE,
	INVCOUNTRYREGIONID
FROM
    invoices 
GROUP BY
    company,
    territory,
    salesmngr,
    customer,
    customerno,
    invoicedate,
    invoiceno,
    family,
    groupid,
    item,
    itemno,
    local_curr,
    rate_ils,
    rate_usd,
    rate_date,
    line_item_no,
    list_price,
    itemgroupid,
    recid,
    salesid,
    invent_item_group_name,
    payment,
    psgfamilyofitem,
    salesgroup,
	DELIVERYSTREET,
	DELIVERYCITY,
	DLVSTATE,
	DLVZIPCODE,
	DLVCOUNTRYREGIONID,
	INVOICESTREET,
	INVOICECITY,
	INVSTATE,
	INVZIPCODE,
	INVCOUNTRYREGIONID
HAVING
    NOT ( round(SUM(rate_usd * amt_ils), 2) = 0 
    AND SUM(qty) = 0 )