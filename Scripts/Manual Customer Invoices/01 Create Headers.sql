DECLARE
    a_ VARCHAR2(32000) := NULL; --p0
    b_ VARCHAR2(32000) := NULL; --p1
    c_ VARCHAR2(32000) := NULL; --p2
    d_ VARCHAR2(32000) := 'PARTY_TYPE'||chr(31)||'Customer'||chr(30)||'COMPANY'||chr(31)||'100'||chr(30)||'IDENTITY'||chr(31)||'40009'||chr(30)||'SERIES_ID'||chr(31)||'CI'||chr(30)||'INVOICE_NO'||chr(31)||'I_123456789.1'||chr(30)||'CURRENCY'||chr(31)||'USD'||chr(30)||'INVOICE_TYPE'||chr(31)||'CUSTINV'||chr(30)||'INVOICE_DATE'||chr(31)||'2019-04-01-00.00.00'||chr(30)||'DELIVERY_DATE'||chr(31)||'2019-05-21-00.00.00'||chr(30)||'PAY_TERM_BASE_DATE'||chr(31)||'2019-04-01-00.00.00'||chr(30)||'PAY_TERM_ID'||chr(31)||'30'||chr(30)||'DUE_DATE'||chr(31)||'2019-05-01-00.00.00'||chr(30)||'DELIVERY_ADDRESS_ID'||chr(31)||'99'||chr(30)||'CURR_RATE'||chr(31)||'1'||chr(30)||'TAX_CURR_RATE'||chr(31)||'1'||chr(30)||'AFF_LINE_POST'||chr(31)||'FALSE'||chr(30)||'WAY_PAY_ID'||chr(31)||''||chr(30)||'PAYMENT_ADDRESS_ID'||chr(31)||''||chr(30)||'PAYER_IDENTITY'||chr(31)||'40009'||chr(30)||'NCF_REFERENCE'||chr(31)||'Migration'||chr(30)||'LANGUAGE_CODE'||chr(31)||'English'||chr(30)||'ADV_INV'||chr(31)||'FALSE'||chr(30)||'POSTED'||chr(31)||'TRUE'||chr(30)||'CASH'||chr(31)||'FALSE'||chr(30)||'DIV_FACTOR'||chr(31)||'1'||chr(30)||'VOU_DATE'||chr(31)||'2019-05-21-00.00.00'||chr(30)||'FINALLY_POSTED'||chr(31)||'FALSE'||chr(30)||'VOUCHER_TEXT'||chr(31)||'Dr. Vitaliy Valyuk'||chr(30)||'USER_GROUP'||chr(31)||'AC'||chr(30)||'UPDATE_CUST_PAY_PLAN'||chr(31)||'FALSE'||chr(30); --p3
    e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    FOR ar IN 
        (
            SELECT          ar.accountnum,
                            customer_info_api.get_name(cm.kd_cust_id) AS customer_name,
                            cm.kd_cust_id AS identity,
                            ar.invoice as invoice_id,
                            TO_CHAR(ar.transdate,'YYYY-MM-DD-HH24.MI.SS') AS invoice_date,
                            TO_CHAR(ar.duedate,'YYYY-MM-DD-HH24.MI.SS') AS due_date,
                             CASE 
                                WHEN ar.duedate - ar.transdate In (30,60,0)
                                THEN ar.duedate - ar.transdate
                                ELSE 30
                            END  AS calculated_terms,
                            ar.stage
            FROM            kd_pt_arbalances ar
                            LEFT JOIN kd_pt_cust_map cm
                                ON  ar.accountnum = cm.pt_cust_id
            WHERE           customer_info_api.get_name(cm.kd_cust_id) IS NOT NULL AND
                            ar.invoice IS NOT NULL AND
                            ar.stage = 0
        )
    LOOP
        a_ :=   NULL;
        b_ :=   NULL;
        c_ :=   NULL;
        d_ :=   'PARTY_TYPE'||chr(31)||'Customer'||chr(30)||
                'COMPANY'||chr(31)||'100'||chr(30)||
                'IDENTITY'||chr(31)||ar.identity||chr(30)|| -- CUSTOMER ID
                'SERIES_ID'||chr(31)||'CI'||chr(30)||
                'INVOICE_NO'||chr(31)||ar.invoice_id||chr(30)|| --INVOICE ID
                'CURRENCY'||chr(31)||'USD'||chr(30)||
                'INVOICE_TYPE'||chr(31)||'CUSTINV'||chr(30)||
                'INVOICE_DATE'||chr(31)||ar.invoice_date||chr(30)|| --INVOICE DATE
                'DELIVERY_DATE'||chr(31)||ar.invoice_date||chr(30)|| --INVOICE DATE
                'PAY_TERM_BASE_DATE'||chr(31)||ar.invoice_date||chr(30)|| --INVOICE DATE
                'PAY_TERM_ID'||chr(31)||ar.calculated_terms||chr(30)|| --PAYMENT TERMS
                'DUE_DATE'||chr(31)||ar.due_date||chr(30)|| --Must be added in an UPDATE
                'DELIVERY_ADDRESS_ID'||chr(31)||'99'||chr(30)||
                'CURR_RATE'||chr(31)||'1'||chr(30)||
                'TAX_CURR_RATE'||chr(31)||'1'||chr(30)||
                'AFF_LINE_POST'||chr(31)||'FALSE'||chr(30)||
                'WAY_PAY_ID'||chr(31)||''||chr(30)||
                'PAYMENT_ADDRESS_ID'||chr(31)||''||chr(30)||
                'PAYER_IDENTITY'||chr(31)||ar.identity||chr(30)|| --CUSTOMER ID
                'NCF_REFERENCE'||chr(31)||'Migration Test'||chr(30)||
                'LANGUAGE_CODE'||chr(31)||'English'||chr(30)||
                'ADV_INV'||chr(31)||'FALSE'||chr(30)||
                'POSTED'||chr(31)||'TRUE'||chr(30)||
                'CASH'||chr(31)||'FALSE'||chr(30)||
                'DIV_FACTOR'||chr(31)||'1'||chr(30)||
                'VOU_DATE'||chr(31)||'2019-05-21-00.00.00'||chr(30)||
                'FINALLY_POSTED'||chr(31)||'FALSE'||chr(30)||
                'VOUCHER_TEXT'||chr(31)||ar.customer_name||chr(30)|| --CUSTOMER NAME
                'USER_GROUP'||chr(31)||'AC'||chr(30)||
                'UPDATE_CUST_PAY_PLAN'||chr(31)||'FALSE'||chr(30); --p3
        e_ :=   'DO';
        --dbms_output.put_line(d_);
        IFSAPP.MAN_CUST_INVOICE_API.NEW__( a_ , b_ , c_ , d_ , e_ );
        EXECUTE IMMEDIATE 'UPDATE kd_pt_arbalances SET stage = 1 WHERE invoice = ''' || ar.invoice_id || '''';
    END LOOP;
END;