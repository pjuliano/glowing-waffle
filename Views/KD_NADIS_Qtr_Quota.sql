Create Or Replace View KD_NADIS_QTR_Quota As 
SELECT
    A.F1 Region,
    Sum(
    CASE
        WHEN EXTRACT(MONTH FROM SYSDATE) In (1,2,3) THEN A.Q1
        WHEN EXTRACT(MONTH FROM SYSDATE) In (4,5,6) THEN A.Q2
        WHEN EXTRACT(MONTH FROM SYSDATE) In (7,8,9) THEN A.Q3
        WHEN EXTRACT(MONTH FROM SYSDATE) In (10,11,12) THEN A.Q4
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
            WHEN EXTRACT(MONTH FROM SYSDATE) = 6 THEN A.Apr + A.May + ((A.Jun / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 7 THEN (A.Jul / B.Total_Sales_Days) * B.Elapsed_Work_Days
            WHEN EXTRACT(MONTH FROM SYSDATE) = 8 THEN A.Jul + ((A.Aug / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 9 THEN A.Jul + A.Aug + ((A.Sep / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 10 THEN (A.Oct / B.Total_Sales_Days) * B.Elapsed_Work_Days
            WHEN EXTRACT(MONTH FROM SYSDATE) = 11 THEN A.Oct + ((A.Nov / B.Total_Sales_Days) * B.Elapsed_Work_Days)
            WHEN EXTRACT(MONTH FROM SYSDATE) = 12 THEN A.Oct + A.Nov + ((A.Dec / B.Total_Sales_Days) * Elapsed_Work_Days)
        END,2)) As QTD_Quota
FROM
    Srfcstnew A,
    KD_Work_Days_This_Month B
Where
    Extract(Month From Sysdate) = B.Month And
    A.F1 In ('CAN','DOMDIS','Freight')
Group By
    A.F1