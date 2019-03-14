Create Or Replace View KD_NADIS_Year_Quota As 
SELECT
    A.F1 Region,
    Sum(A.Total) AS Year_Total_Quota,
    Sum(
    ROUND(
        CASE
            WHEN EXTRACT(MONTH FROM SYSDATE) = 1 THEN (A.Jan / B.Total_Sales_Days) * B.Elapsed_Work_Days
            WHEN EXTRACT(MONTH FROM SYSDATE) = 2 THEN A.Jan + ((A.Feb / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 3 THEN A.Jan + A.Feb + ((A.Mar / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 4 THEN A.Q1 + (A.Apr / B.Total_Sales_Days) * B.Elapsed_Work_Days
            WHEN EXTRACT(MONTH FROM SYSDATE) = 5 THEN A.Q1 + A.Apr + ((A.May / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 6 THEN A.Q1 + A.Apr + A.May + ((A.Jun / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 7 THEN A.Q1 + A.Q2 + (A.Jul / B.Total_Sales_Days) * B.Elapsed_Work_Days
            WHEN EXTRACT(MONTH FROM SYSDATE) = 8 THEN A.Q1 + A.Q2 + A.Jul + ((A.Aug / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 9 THEN A.Q1 + A.Q2 + A.Jul + A.Aug + ((A.Sep / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 10 THEN A.Q1 + A.Q2 + A.Q3 + (A.Oct / B.Total_Sales_Days) * B.Elapsed_Work_Days
            WHEN EXTRACT(MONTH FROM SYSDATE) = 11 THEN A.Q1 + A.Q2 + A.Q3 + A.Oct + ((A.Nov / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 12 THEN A.Q1 + A.Q2 + A.Q3 + A.Oct + A.Nov + ((A.Dec / B.Total_Sales_Days) * Elapsed_Work_Days)
        END,2)) As YTD_Quota
FROM
    Srfcstnew A,
    KD_Work_Days_This_Month B
Where
    B.Month = Extract(Month From Sysdate) And
    A.F1 In ('CAN','DOMDIS','Freight')
Group By
    A.F1