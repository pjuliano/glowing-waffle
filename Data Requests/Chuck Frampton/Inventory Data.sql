WITH available_qty AS
(
SELECT 
    contract,
    part_no,
    SUM(qty_onhand - qty_reserved) AS available_qty
FROM 
    inventory_part_in_stock
GROUP BY
    contract,
    part_no
),
sales AS
(
    SELECT
        catalog_no,
        SUM(invoiced_qty) qty
    FROM
        kd_sales_data_request a
    WHERE
        invoicedate >= add_months(SYSDATE,-12)
    GROUP BY
        catalog_no
)
SELECT 
    a.contract, 
    a.part_no, 
    a.description, 
    a.part_product_family,
    inventory_product_family_api.get_description(a.part_product_family) AS family_description,
    a.part_product_code,
    inventory_product_code_api.get_description(a.part_product_code) AS code_description,
    a.accounting_group,
    accounting_group_api.get_description(a.accounting_group) AS accounting_group_description,
    a.expected_leadtime,
    inventory_part_planning_api.get_safety_stock(a.contract, a.part_no) AS safety_stock,
    b.available_qty,
    c.qty AS sales_qty_12m,
    d.inventory_value,
    b.available_qty * d.inventory_value as available_inventory_value
FROM 
    inventory_part a LEFT JOIN available_qty b ON
        a.contract = b.contract AND
        a.part_no = b.part_no
                     LEFT JOIN sales c ON 
        a.part_no = c.catalog_no
                     LEFT JOIN inventory_part_unit_cost_sum d ON
        a.contract = d.contract AND
        a.part_no = d.part_no
WHERE
     a.contract = '100' AND
     a.part_status != 'O'