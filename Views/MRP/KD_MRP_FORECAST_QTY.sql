Create Or Replace View KD_MRP_FG_FORECAST_QTY As 
Select
    A.FG_Part_No,
    A.FG_Part_Index,
    NVL(Sum(B.Forecast_Lev0 + Forecast_Lev1),0) As Units_Forecast,
    Count(B.Forecast_Lev0) as Forecast_Count
From
    KD_MRP_Part_Relationships A Left Join Level_1_Forecast B
        On A.FG_Part_No = B.Part_No And 
           B.Contract = '100' And
           (   B.Forecast_Lev0 != 0 Or B.Forecast_Lev1 != 0    )
Group By
    A.FG_Part_No,
    A.FG_Part_Index