DROP MATERIALIZED VIEW kd_test_mv;
CREATE MATERIALIZED VIEW kd_test_mv 
REFRESH ON COMMIT 
FAST AS 
SELECT
                invhead.identity,
                --PKs
                invhead.company AS pk1,
                invhead.invoice_id AS pk2,
                invitem.company AS pk3,
                invitem.invoice_id AS pk4,
                invitem.item_id AS pk5,
                salespart.contract AS pk6,
                salespart.catalog_no AS pk7,
                --ROWIDs
                invhead.rowid AS r1,
                invitem.rowid AS r2,
                salespart.rowid AS r3

FROM
                invoice_tab invhead,
                invoice_item_tab invitem,
                sales_part_tab salespart
WHERE
                invhead.invoice_id = invitem.invoice_id
                    AND invhead.company = invitem.company
                    AND ((
                        invitem.c5 = salespart.catalog_no
                            AND DECODE(invitem.company,'241','240',invitem.company) = salespart.contract
                        ) OR 
                        
                        ;
