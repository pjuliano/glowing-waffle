DECLARE
    a_ VARCHAR2(32000) := NULL; --p0
    b_ VARCHAR2(32000) := NULL; --p1
    c_ VARCHAR2(32000) := NULL; --p2
    d_ VARCHAR2(32000) := 'COMPANY'||chr(31)||'100'||chr(30)||'IDENTITY'||chr(31)||'40009'||chr(30)||'PARTY_TYPE'||chr(31)||'Customer'||chr(30)||'INVOICE_ID'||chr(31)||'900903'||chr(30)||'VAT_CODE'||chr(31)||''||chr(30)||'GROSS_AMOUNT'||chr(31)||'100'||chr(30)||'NET_CURR_AMOUNT'||chr(31)||'100'||chr(30)||'VAT_CURR_AMOUNT'||chr(31)||'0'||chr(30)||'VOUCHER_DATE'||chr(31)||'2019-05-21-00.00.00'||chr(30)||'TEXT'||chr(31)||'Dr. Vitaliy Valyuk'||chr(30)||'VAT_DOM_AMOUNT'||chr(31)||'0'||chr(30)||''||chr(31)||'1'||chr(30)||'CONSIDER_AMOUNT_METHOD'||chr(31)||'TRUE'||chr(30); --p3
    e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    FOR ar IN 
        (
            SELECT          ar.accountnum,
                            customer_info_api.get_name(cm.kd_cust_id) AS customer_name,
                            cm.kd_cust_id AS identity,
                            ar.invoice as invoice_id,
                            TO_CHAR(ar.transdate,'YYYY-MM-DD-HH24.MI.SS') AS invoice_date,
                            TO_CHAR(ar.transdate + 1,'YYYY-MM-DD-HH24.MI.SS') AS deliv_date,
                            TO_CHAR(ar.transdate + 
                                    CASE 
                                        WHEN ar.duedate - ar.transdate In (30,60,0)
                                        THEN ar.duedate - ar.transdate
                                        ELSE 30
                                    END,'YYYY-MM-DD-HH24.MI.SS')  AS due_Date,
                            CASE 
                                WHEN ar.duedate - ar.transdate In (30,60,0)
                                THEN ar.duedate - ar.transdate
                                ELSE 30
                            END AS calculated_terms,
                            ar.stage,
                            ar.balance,
                            mci.invoice_id as invoice_no
            FROM            kd_pt_arbalances ar
                            LEFT JOIN kd_pt_cust_map cm
                                ON  ar.accountnum = cm.pt_cust_id
                            LEFT JOIN man_cust_invoice mci
                                ON  ar.invoice = mci.invoice_no
            WHERE           ar.invoice IS NOT NULL 
        )
     LOOP
        a_ :=   NULL;
        b_ :=   NULL;
        c_ :=   NULL;
        e_ :=   'DO';
        d_ := 'COMPANY'||chr(31)||'100'||chr(30)||'IDENTITY'||chr(31)||ar.identity||chr(30)||'PARTY_TYPE'||chr(31)||'Customer'||chr(30)||'INVOICE_ID'||chr(31)||ar.invoice_no||chr(30)||'VAT_CODE'||chr(31)||''||chr(30)||'GROSS_AMOUNT'||chr(31)||ar.balance||chr(30)||'NET_CURR_AMOUNT'||chr(31)||ar.balance||chr(30)||'VAT_CURR_AMOUNT'||chr(31)||'0'||chr(30)||'VOUCHER_DATE'||chr(31)||'2019-05-22-00.00.00'||chr(30)||'TEXT'||chr(31)||ar.customer_name||chr(30)||'VAT_DOM_AMOUNT'||chr(31)||'0'||chr(30)||''||chr(31)||'1'||chr(30)||'CONSIDER_AMOUNT_METHOD'||chr(31)||'TRUE'||chr(30); --p3
        IFSAPP.MAN_CUST_INVOICE_ITEM_API.NEW__( a_ , b_ , c_ , d_ , e_ );
    END LOOP;
END;