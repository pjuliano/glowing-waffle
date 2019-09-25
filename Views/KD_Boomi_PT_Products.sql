CREATE OR REPLACE VIEW KD_BOOMI_PT_PRODUCTS AS
WITH MAXPRICE AS 
    (
        SELECT
                        itemrelation,
                        MAX(amount) list
        FROM
                        kd_ptltd_price_lists
        GROUP BY 
                        itemrelation
    )
SELECT
                itemid,
                itemname,
                itemgroupid,
                psgfamilyofitem,
                name,
                CASE
                    WHEN UPPER(itemname) LIKE 'OBSOLETE%'
                    THEN 'false'
                    ELSE 'true'
                END AS is_active,
                CASE
                    WHEN UPPER(name) = 'PAI IMPLANTS'
                    THEN 'PAI'
                    WHEN UPPER(name) = 'ADVANCED PLUS IMPLANTS'
                    THEN 'ADVN+'
                    WHEN UPPER(name) = 'ADVANCED IMPLANTS'
                    THEN 'ADVNC'
                    WHEN UPPER(name) = 'CONICAL CONNECTION IMPLANTS'
                    THEN 'PCA'
                    WHEN UPPER(name) = 'DYNAMIC IMPLANTS'
                    THEN 'DYMIC'
                    WHEN UPPER(name) IN ('PEEK ABUTMENTS',
                                                                   'COBALT CHROME ABUTMENTS',
                                                                   'TITANIUM ABUTMENTS',
                                                                   'MULTI UNIT ABUTMENTS',
                                                                   'IMPRESSION COPING',
                                                                   'HEALING CAPS',
                                                                   'SCREWS',
                                                                   'TOOLS',
                                                                   'CASTABLE ABUTMENTS',
                                                                   'KITS',
                                                                   'CONICAL HEALING CAPS',
                                                                   'CONICAL TITANIUM ABUTMENTS')
                    THEN 'PTCOM'
                    WHEN UPPER(name) = 'DIGITAL'
                    THEN 'DIGITAL'
                    WHEN UPPER(name) = 'PACKAGING MATERIALS'
                    THEN 'FREIGHT'
                    WHEN UPPER(name) = 'DIVA IMPLANTS'
                    THEN 'DIVA'
                    ELSE 'OTHER'
                END as product_family,
                NVL(list,0) AS list
FROM
                kd_ptltd_parts 
                LEFT JOIN maxprice ON
                    itemid = itemrelation
UNION ALL

SELECT
                '97-90002',
                'Customer Charge',
                NULL,
                NULL,
                NULL,
                'true',
                'FREIGHT',
                0
FROM
                DUAL
                
UNION ALL

SELECT
                '97-90100',
                'Customer Charge',
                NULL,
                NULL,
                NULL,
                'true',
                NULL,
                0
FROM
                DUAL