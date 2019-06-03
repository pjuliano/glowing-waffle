DECLARE
    a_ VARCHAR2(32000) := NULL; --p0
    b_ VARCHAR2(32000) := 'AAAUOhAARAAC4SAAAC'; --p1
    c_ VARCHAR2(32000) := '3'; --p2
    d_ VARCHAR2(32000) := 'PAY_TERM_BASE_DATE'||chr(31)||'2019-04-01-00.00.00'||chr(30)||'DUE_DATE'||chr(31)||'2019-05-01-00.00.00'||chr(30)||'CURR_RATE'||chr(31)||'1'||chr(30)||'LANGUAGE_CODE'||chr(31)||'English'||chr(30)||'VOUCHER_TEXT'||chr(31)||'Dr. Vitaliy Valyuk'||chr(30)||'USER_GROUP'||chr(31)||'AC'||chr(30)||'UPDATE_CUST_PAY_PLAN'||chr(31)||'FALSE'||chr(30); --p3
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
                            mci.objversion,
                            mci.objid
            FROM            kd_pt_arbalances ar
                            LEFT JOIN kd_pt_cust_map cm
                                ON  ar.accountnum = cm.pt_cust_id
                            LEFT JOIN man_cust_invoice mci
                                ON  ar.invoice = mci.invoice_no
            WHERE           customer_info_api.get_name(cm.kd_cust_id) IS NOT NULL AND
                            ar.invoice IS NOT NULL 
        )
    LOOP
        a_ :=   NULL;
        b_ :=   ar.objid;
        c_ :=   ar.objversion;
        d_ := 'PAY_TERM_BASE_DATE'||chr(31)||ar.invoice_Date||chr(30)||'DUE_DATE'||chr(31)||ar.due_date||chr(30)||'CURR_RATE'||chr(31)||'1'||chr(30)||'LANGUAGE_CODE'||chr(31)||'English'||chr(30)||'VOUCHER_TEXT'||chr(31)||ar.customer_name||chr(30)||'USER_GROUP'||chr(31)||'AC'||chr(30)||'UPDATE_CUST_PAY_PLAN'||chr(31)||'FALSE'||chr(30); --p3
        e_ :=   'DO';
        IFSAPP.MAN_CUST_INVOICE_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
    END LOOP;
END;
