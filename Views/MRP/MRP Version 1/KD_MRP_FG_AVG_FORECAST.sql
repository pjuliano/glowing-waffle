--------------------------------------------------------
--  DDL for View KD_MRP_FG_AVG_FORECAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "IFSAPP"."KD_MRP_FG_AVG_FORECAST" ("FG_PART_NO", "FG_PART_INDEX", "FORECAST_COUNT", "UNITS_FORECAST", "AVG_MONTHLY_FORECAST") AS 
  Select
    A.FG_Part_No,
    A.FG_Part_Index,
    B.Forecast_Count,
    B.Units_Forecast,
    Round(B.Units_Forecast / B.Forecast_Count) As Avg_Monthly_Forecast
From
    KD_MRP_Part_Relationships A Left Join KD_MRP_FG_FORECAST_Qty B
        On A.FG_Part_No = B.FG_Part_No
;
