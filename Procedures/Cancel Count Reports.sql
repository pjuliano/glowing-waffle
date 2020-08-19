DECLARE
    a_ VARCHAR2(32000) := '6599'; --p0
BEGIN
    FOR counts IN (SELECT inv_list_no FROM cancel_counting_report_lov WHERE userid = 'IFSAPP')
    LOOP
        a_ := counts.inv_list_no;
        IFSAPP.Counting_Report_API.Cancel_Counting_Report( a_ );
        COMMIT;
    END LOOP;
END;