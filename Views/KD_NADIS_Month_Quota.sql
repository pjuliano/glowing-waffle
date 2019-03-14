Create Or Replace View KD_NADIS_Month_Quota As
Select 
    A.F1 Region,
    Sum(
    CASE
        WHEN EXTRACT(MONTH FROM SYSDATE) = 1 THEN A.Jan
        WHEN EXTRACT(MONTH FROM SYSDATE) = 2 THEN A.Feb
        WHEN EXTRACT(MONTH FROM SYSDATE) = 3 THEN A.Mar
        WHEN EXTRACT(MONTH FROM SYSDATE) = 4 THEN A.Apr
        WHEN EXTRACT(MONTH FROM SYSDATE) = 5 THEN A.May
        WHEN EXTRACT(MONTH FROM SYSDATE) = 6 THEN A.Jun
        WHEN EXTRACT(MONTH FROM SYSDATE) = 7 THEN A.Jul
        WHEN EXTRACT(MONTH FROM SYSDATE) = 8 THEN A.Aug
        WHEN EXTRACT(MONTH FROM SYSDATE) = 9 THEN A.Sep
        WHEN EXTRACT(MONTH FROM SYSDATE) = 10 THEN A.Oct
        WHEN EXTRACT(MONTH FROM SYSDATE) = 11 THEN A.Nov
        WHEN EXTRACT(MONTH FROM SYSDATE) = 12 THEN A.Dec
        ELSE 0
    END) AS Month_Total_Quota,
    Sum(
    ROUND(
        CASE
            WHEN EXTRACT(MONTH FROM SYSDATE) = 1 THEN A.Jan
            WHEN EXTRACT(MONTH FROM SYSDATE) = 2 THEN A.Feb
            WHEN EXTRACT(MONTH FROM SYSDATE) = 3 THEN A.Mar
            WHEN EXTRACT(MONTH FROM SYSDATE) = 4 THEN A.Apr
            WHEN EXTRACT(MONTH FROM SYSDATE) = 5 THEN A.May
            WHEN EXTRACT(MONTH FROM SYSDATE) = 6 THEN A.Jun
            WHEN EXTRACT(MONTH FROM SYSDATE) = 7 THEN A.Jul
            WHEN EXTRACT(MONTH FROM SYSDATE) = 8 THEN A.Aug
            WHEN EXTRACT(MONTH FROM SYSDATE) = 9 THEN A.Sep
            WHEN EXTRACT(MONTH FROM SYSDATE) = 10 THEN A.Oct
            WHEN EXTRACT(MONTH FROM SYSDATE) = 11 THEN A.Nov
            WHEN EXTRACT(MONTH FROM SYSDATE) = 12 THEN A.Dec 
        END / 
        B.Total_Sales_Days * B.Elapsed_Work_Days,2)) As MTD_Quota
From 
    Srfcstnew A,
    KD_Work_Days_This_Month B
Where
    Extract(Month From Sysdate) = B.Month And
    A.F1 In ('CAN','DOMDIS','Freight')
Group By
    A.F1