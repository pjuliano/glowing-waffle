SELECT          customer_info_api.get_name(cm.kd_cust_id) AS customer_name,
                cm.kd_cust_id AS identity,
                ar.invoice as invoice_id,
                TO_CHAR(ar.transdate,'MM/DD/YYYY') AS invoice_date,
                TO_CHAR(ar.transdate + 1,'MM/DD/YYYY') AS deliv_date,
                TO_CHAR(ar.transdate + 
                        CASE 
                            WHEN ar.duedate - ar.transdate In (30,60,0)
                            THEN ar.duedate - ar.transdate
                            ELSE 30
                        END,'MM/DD/YYYY')  AS due_Date,
                TO_CHAR(
                CASE 
                    WHEN ar.duedate - ar.transdate In (30,60,0)
                    THEN ar.duedate - ar.transdate
                    ELSE 30
                END) AS calculated_terms
FROM            kd_pt_arbalances ar
                LEFT JOIN kd_pt_cust_map cm
                    ON  ar.accountnum = cm.pt_cust_id
WHERE           customer_info_api.get_name(cm.kd_cust_id) IS NOT NULL AND
                ar.invoice IS NOT NULL
