CREATE OR REPLACE VIEW kd_ecom_customers AS
SELECT
                ci.customer_id,
                ci.objid,
                ci.cf$_shopify_id AS shopify_id,
                ci.name AS customer_name,
                cia.address1 AS deliv_address1,
                cia.address2 AS deliv_address2,
                cia.city AS deliv_city,
                cia.state AS deliv_state,
                cia.zip_code AS deliv_zip_code,
                cia.country AS deliv_country,
                cdti.liability_type,
                cm_phone.value AS phone,
                cm_email.value AS email
FROM
                customer_info_cfv ci
                LEFT JOIN customer_info_address cia
                    ON ci.customer_id = cia.customer_id
                JOIN customer_info_address_type ciat_del
                    ON cia.customer_id = ciat_del.customer_id
                        AND cia.address_id = ciat_del.address_id
                        AND ciat_del.address_type_code_db = 'DELIVERY'
                        AND ciat_del.def_address = 'TRUE'
                LEFT JOIN comm_method cm_phone
                    ON ci.customer_id = cm_phone.customer_id
                        AND cm_phone.method_id_db = 'PHONE'
                        AND cm_phone.method_default = 'TRUE'
                LEFT JOIN comm_method cm_email
                    ON ci.customer_id = cm_email.customer_id
                        AND cm_email.method_id_db = 'E_MAIL'
                        AND cm_email.method_default = 'TRUE'
                LEFT JOIN customer_delivery_tax_info cdti
                    ON ci.customer_id = cdti.customer_id
                        AND cia.address_id = cdti.address_id
WHERE
                ci.cf$_ecom_cust_db = 'TRUE'