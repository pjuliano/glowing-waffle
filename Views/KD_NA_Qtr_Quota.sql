Create Or Replace View KD_NA_Qtr_Quota As 
SELECT
    A.Region,
    Sum(
    CASE
        WHEN EXTRACT(MONTH FROM SYSDATE) In (1,2,3) THEN A.Qtr1
        WHEN EXTRACT(MONTH FROM SYSDATE) In (4,5,6) THEN A.Qtr2
        WHEN EXTRACT(MONTH FROM SYSDATE) In (7,8,9) THEN A.Qtr3
        WHEN EXTRACT(MONTH FROM SYSDATE) In (10,11,12) THEN A.Qtr4
        ELSE 0
    END) AS Qtr_Total_Quota,
    Sum(
    ROUND(
        CASE
            WHEN EXTRACT(MONTH FROM SYSDATE) = 1 THEN (A.Jan / B.Total_Sales_Days) * B.Elapsed_Work_Days
            WHEN EXTRACT(MONTH FROM SYSDATE) = 2 THEN A.Jan + ((A.Feb / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 3 THEN A.Jan + A.Feb + ((A.Mar / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 4 THEN (A.Apr / B.Total_Sales_Days) * B.Elapsed_Work_Days
            WHEN EXTRACT(MONTH FROM SYSDATE) = 5 THEN A.Apr + ((A.May / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 6 THEN A.Apr + A.May + ((A.June / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 7 THEN (A.July / B.Total_Sales_Days) * B.Elapsed_Work_Days
            WHEN EXTRACT(MONTH FROM SYSDATE) = 8 THEN A.July + ((A.Aug / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 9 THEN A.July + A.Aug + ((A.Sept / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 10 THEN (A.Oct / B.Total_Sales_Days) * B.Elapsed_Work_Days
            WHEN EXTRACT(MONTH FROM SYSDATE) = 11 THEN A.Oct + ((A.Nov / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 12 THEN A.Oct + A.Nov + ((A.Dec / B.Total_Sales_Days) * Elapsed_Work_Days)
        END,2)) As QTD_Quota
FROM
    Srrepquota A,
    KD_Work_Days_This_Month B
Where
    B.Month = Extract(Month From Sysdate)
Group By
    A.Region