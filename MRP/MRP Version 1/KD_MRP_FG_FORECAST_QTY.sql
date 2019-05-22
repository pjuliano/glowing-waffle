--------------------------------------------------------
--  DDL for View KD_MRP_FG_FORECAST_QTY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "IFSAPP"."KD_MRP_FG_FORECAST_QTY" ("FG_PART_NO", "FG_PART_INDEX", "UNITS_FORECAST", "FORECAST_COUNT") AS 
  Select
    A.FG_Part_No,
    A.FG_Part_Index,
    Decode(Sum(B.Forecast_Lev0 + Forecast_Lev1),Null,0,Sum(B.Forecast_Lev0 + Forecast_Lev1)) As Units_Forecast,
    Count(B.Forecast_Lev0) as Forecast_Count
From
    KD_MRP_Part_Relationships A Left Join Level_1_Forecast B
        On A.FG_Part_No = B.Part_No And 
           B.Contract = '100' And
           (   B.Forecast_Lev0 != 0 Or B.Forecast_Lev1 != 0    )
Group By
    A.FG_Part_No,
    A.FG_Part_Index
;
