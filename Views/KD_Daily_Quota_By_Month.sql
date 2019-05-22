Create Or Replace View Kd_Daily_Quota_By_Month As
    Select
        A.Repnumber As Salesman_Code,
        A.Region,
        B.Month,
        Case
            When B.Month In(1,2,3)
            Then 'QTR1'
            When B.Month In(4,5,6)
            Then 'QTR2'
            When B.Month In(7,8,9)
            Then 'QTR3'
            When B.Month In(10,11,12)
            Then 'QTR4'
        End As Qtr,
        Case
            When B.Month = 1
            Then(A.Jan / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 2
            Then(A.Feb / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 3
            Then(A.Mar / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 4
            Then(A.Apr / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 5
            Then(A.May / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 6
            Then(A.June / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 7
            Then(A.July / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 8
            Then(A.Aug / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 9
            Then(A.Sept / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 10
            Then(A.Oct / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 11
            Then(A.Nov / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 12
            Then(A.Dec / B.Total_Sales_Days)* B.Elapsed_Work_Days
        End As Daily_Quota,
        Case
            When B.Month = 1
            Then(A.M1_Impl / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 2
            Then(A.M2_IMPl / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 3
            Then(A.M3_IMPl / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 4
            Then(A.M4_IMPl / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 5
            Then(A.M5_IMPl / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 6
            Then(A.M6_IMPl / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 7
            Then(A.M7_IMPl / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 8
            Then(A.M8_IMPl / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 9
            Then(A.M9_IMPl / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 10
            Then(A.M10_IMPl / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 11
            Then(A.M11_IMPl / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 12
            Then(A.M12_IMPl / B.Total_Sales_Days)* B.Elapsed_Work_Days
        End As Daily_Quota_ImpL,
        Case
            When B.Month = 1
            Then(A.M1_BIO / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 2
            Then(A.M2_BIO / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 3
            Then(A.M3_BIO / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 4
            Then(A.M4_BIO / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 5
            Then(A.M5_BIO / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 6
            Then(A.M6_BIO / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 7
            Then(A.M7_BIO / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 8
            Then(A.M8_BIO / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 9
            Then(A.M9_BIO / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 10
            Then(A.M10_BIO / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 11
            Then(A.M11_BIO / B.Total_Sales_Days)* B.Elapsed_Work_Days
            When B.Month = 12
            Then(A.M12_BIO / B.Total_Sales_Days)* B.Elapsed_Work_Days
        End As Daily_Quota_Bio
    From
        Srrepquota            A,
        Kd_Monthly_Calendar   B
    Order By
        A.Repnumber,
        B.Month