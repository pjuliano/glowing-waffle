CREATE OR REPLACE VIEW kd_mrp_fg_open_po AS
SELECT
                mpr.fg_part_no,
                mpr.fg_part_index,
                nvl(SUM(pol.due_at_dock),0) AS open_po_fg
FROM
                kd_mrp_part_relationships mpr
                LEFT JOIN purchase_order_line_new pol
                    ON mpr.fg_part_no = pol.part_no
                        AND pol.order_no NOT LIKE 'S%'
                        AND pol.contract = '100'
GROUP BY
                mpr.fg_part_no,
                mpr.fg_part_index