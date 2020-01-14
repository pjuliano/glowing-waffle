CREATE OR REPLACE VIEW kd_smi_rep AS
SELECT 
                kdsmi.vendorno,
                inventory_part.part_no, 
                kdsmi.description, 
                kdsmi.usg AS mo_usage,
                ROUND(kdsmi.maxexposure,2) AS maxexposure,
                kdsmi.triggerpoint, 
                kdsmi.blanketpo,
                kdsmi.price,
                kdsmi.releaseqty, 
                NVL(ohq.onhand_qty,0) AS onhand_qty,
                CASE
                    WHEN NVL(ohq.onhand_qty,0) - kdsmi.triggerpoint < 0 
                    THEN kdsmi.releaseqty
                    ELSE 0
                END AS ship_qty_required,
                kdsmi.comments
FROM   
                ifsapp.kdsmi kdsmi 
                LEFT OUTER JOIN ifsapp.inventory_part inventory_part 
                    ON kdsmi.item=inventory_part.part_no 
                LEFT OUTER JOIN ifsapp.kdsuppliers kdsuppliers 
                    ON kdsmi.vendorno=kdsuppliers.vendorno
                LEFT OUTER JOIN 
                    (
                        SELECT
                                        smi.item,
                                        SUM
                                            (
                                                CASE
                                                    WHEN ipis.warehouse IN ('1','2','3','4','CA01','CA02')
                                                        AND ipis.availability_control_id IS NULL
                                                    THEN ipis.qty_onhand - ipis.qty_reserved
                                                    ELSE 0
                                                END
                                            ) AS onhand_qty
                        FROM
                                        ifsapp.inventory_part_in_stock ipis
                                        JOIN ifsapp.kdsmi smi
                                            ON ipis.contract = '100'
                                                AND ipis.part_no = smi.item
                        GROUP BY
                                        smi.item
                    ) ohq
                    ON kdsmi.item = ohq.item
WHERE  
                inventory_part.contract='100'
ORDER BY 
                inventory_part.part_no