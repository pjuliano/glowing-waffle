SELECT
                sdr.region_code,
                sdr.salesman_code,
                person_info_api.get_name(sdr.salesman_code) AS salesman_name,
                sdr.invoicedate,
                sdr.invoice_id,
                sdr.customer_no,
                sdr.customer_name,
                sdr.catalog_no,
                sdr.catalog_desc,
                sdr.invoiced_qty,
                sdr.allamounts / NULLIF(sdr.invoiced_qty,0) AS unit_price,
                sales_part_api.get_list_price(sdr.site,sdr.catalog_no) AS list_price,
                sdr.allamounts AS total_price,
                pps.list_price AS cost,
                100 * ((sdr.allamounts - pps.list_price) / pps.list_price) AS margin
FROM
                kd_sales_data_request sdr
                    LEFT JOIN purchase_part_supplier pps ON
                        sdr.catalog_no = pps.part_no
                            AND sdr.site = pps.contract
WHERE
                EXTRACT(YEAR FROM INVOICEDATE) > 2017
                    AND 
                        (
                            catalog_no LIKE 'WH%'
                                OR catalog_no IN 
                                    (
                                        '04719400',
                                        '05513400',
                                        '06177800',
                                        '06202400',
                                        '06823400',
                                        '07173200',
                                        '30047000',
                                        '30078000'
                                    )
                        )            