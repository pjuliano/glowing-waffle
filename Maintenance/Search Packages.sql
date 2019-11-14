SELECT *
FROM all_source
WHERE owner = 'IFSAPP'
AND upper(text) LIKE '%get_warehouse_id%';