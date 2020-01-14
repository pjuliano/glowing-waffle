SELECT 
                * 
FROM 
                kd_us_sales_detail sd
WHERE
                sd.site LIKE NVL('&Site','%')
                    AND sd.area LIKE NVL('&Area','%')
                    AND sd.segment LIKE NVL('&Segment','%')
                    AND sd.region LIKE NVL('&Region','%')
                    AND sd.product_type LIKE NVL('&ProductType','%')
                    AND sd.prodfam LIKE NVL('&ProductFamily','%')
                    AND sd.prodcd LIKE NVL('&ProductCode','%')
                    AND sd.invoicedate BETWEEN TO_DATE('&StartDate','MM/DD/YYYY') AND TO_DATE('&EndDate','MM/DD/YYYY')