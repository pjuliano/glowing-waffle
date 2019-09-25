SELECT
				inv.ITEMID,
				inv.ITEMNAME,
				inv.ITEMGROUPID,
				iig.PSGFAMILYOFITEM,
				iig.NAME
FROM
				Paltop_ax09_Live_db.dbo.INVENTTABLE inv
					LEFT JOIN Paltop_ax09_Live_db.dbo.INVENTITEMGROUP iig ON
						inv.ITEMGROUPID = iig.ITEMGROUPID
							AND inv.DATAAREAID = iig.DATAAREAID
WHERE
				inv.ITEMTYPE = 1
					AND inv.DATAAREAID = 'virt'