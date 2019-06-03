SELECT          cm.kd_cust_id AS identity,
                mci.invoice_no,
                customer_info_api.get_name(cm.kd_cust_id) as name,
                -1 * ar.balance as balance
FROM            kd_pt_arbalances ar
                LEFT JOIN kd_pt_cust_map cm
                    ON  ar.accountnum = cm.pt_cust_id
                LEFT JOIN man_cust_invoice mci
                    ON  ar.invoice = mci.invoice_no
WHERE           customer_info_api.get_name(cm.kd_cust_id) IS NOT NULL AND
                ar.invoice IS NOT NULL