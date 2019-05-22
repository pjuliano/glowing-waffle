--------------------------------------------------------
--  DDL for View KD_MRP
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "IFSAPP"."KD_MRP" ("RM_PART_NO", "ON_HAND_RM", "OPEN_PO_RM", "RM_RATIO_FG1S", "RMFG_SPLIT_TOTAL_FG1S", "PROC_PART_NO", "ON_HAND_PROC", "OPEN_PO_PROC", "OPEN_SO_PROC", "PROC_TOTAL", "FG_PART_NO_FG1", "ON_HAND_FG1S", "OPEN_SO_FG1S", "FG_TOTAL_FG1S", "TOTAL_INVENTORY_FG1S", "ACTIVE_MONTHS_FG1S", "UNITS_SOLD_12M_FG1S", "AVG_MONTHLY_SALES_FG1S", "MONTHS_ON_HAND_FG1S", "REQUIRED_DATE_FG1S", "FG_PART_NO_FG2", "RM_RATIO_FG2S", "RMFG_SPLIT_TOTAL_FG2S", "ON_HAND_FG2S", "OPEN_SO_FG2S", "FG_TOTAL_FG2S", "TOTAL_INVENTORY_FG2S", "ACTIVE_MONTHS_FG2S", "UNITS_SOLD_12M_FG2S", "AVG_MONTHLY_SALES_FG2S", "MONTHS_ON_HAND_FG2S", "REQUIRED_DATE_FG2S", "FORECAST_COUNT_FG1F", "UNITS_FORECAST_FG1F", "AVG_MONTHLY_FORECAST_FG1F", "REQUIRED_DATE_FG1F", "MONTHS_ON_HAND_FG1F", "FORECAST_COUNT_FG2F", "UNITS_FORECAST_FG2F", "AVG_MONTHLY_FORECAST_FG2F", "MONTHS_ON_HAND_FG2F", "REQUIRED_DATE_FG2F") AS 
  With FG1S As 
        (Select * From KD_MRP_MOH_Sales Where FG_Part_Index = 1),
     FG2S As
        (Select * From KD_MRP_MOH_Sales Where FG_Part_Index = 2),
     FG1F As
        (Select * From KD_MRP_MOH_Forecast Where FG_Part_Index = 1),
     FG2F As
        (Select * From KD_MRP_MOH_Forecast Where FG_Part_Index = 2)

Select
    FG1S.RM_Part_No,
    FG1S.ON_Hand_RM,
    FG1S.Open_PO_RM,
    FG1S.RM_Ratio as RM_Ratio_FG1S,
    FG1S.RMFG_Split_Total as RMFG_Split_Total_FG1S,
    FG1S.Proc_Part_No,
    FG1S.On_Hand_Proc,
    FG1S.Open_PO_Proc,
    FG1S.Open_SO_Proc,
    FG1S.Proc_Total,
    FG1S.FG_Part_No As FG_Part_No_FG1,
    FG1S.On_Hand_FG As On_Hand_FG1S,
    FG1S.Open_SO_FG As Open_SO_FG1S,
    FG1S.FG_Total as FG_Total_FG1S,
    FG1S.Total_Inventory As Total_Inventory_FG1S,
    FG1S.Active_Months As Active_Months_FG1S,
    FG1S.Units_Sold_12M As Units_Sold_12M_FG1S,
    FG1S.Avg_Monthly_Sales As Avg_Monthly_Sales_FG1S,
    FG1S.Months_On_Hand As Months_On_Hand_FG1S,
    Add_Months(Sysdate,FG1S.Months_On_Hand - 3) As Required_Date_FG1S,
    FG2S.FG_Part_No As FG_Part_No_FG2,
    FG2S.RM_Ratio As RM_Ratio_FG2S,
    FG2S.RMFG_Split_Total As RMFG_Split_Total_FG2S,
    FG2S.On_Hand_FG As On_Hand_FG2S,
    FG2S.Open_SO_FG As Open_SO_FG2S,
    FG2S.FG_Total As FG_Total_FG2S,
    FG2S.Total_Inventory As Total_Inventory_FG2S,
    FG2S.Active_Months As Active_Months_FG2S,
    FG2S.Units_Sold_12M As Units_Sold_12M_FG2S,
    FG2S.Avg_Monthly_Sales As Avg_Monthly_Sales_FG2S,
    FG2S.Months_On_Hand As Months_On_Hand_FG2S,
    Add_Months(Sysdate,FG2S.Months_On_Hand - 3) As Required_Date_FG2S,
    FG1F.Forecast_Count as Forecast_Count_FG1F,
    FG1F.Units_Forecast As Units_Forecast_FG1F,
    FG1F.Avg_Monthly_Forecast As Avg_Monthly_Forecast_FG1F,
    Add_Months(Sysdate,FG1F.Months_On_Hand - 3) As Required_Date_FG1F,
    FG1F.Months_On_Hand as Months_On_Hand_FG1F,
    FG2F.Forecast_Count As Forecast_Count_FG2F,
    FG2F.Units_Forecast As Units_Forecast_FG2F,
    FG2F.Avg_Monthly_Forecast as Avg_Monthly_Forecast_FG2F,
    FG2F.Months_On_Hand As Months_On_Hand_FG2F,
    Add_Months(Sysdate,FG2F.Months_On_Hand - 3) As Required_Date_FG2F
From
    FG1S Left Join FG2S 
        On FG1S.RM_Part_No = FG2S.RM_Part_No
         Left Join FG1F
        On FG1S.RM_Part_No = FG1F.RM_Part_No
         Left Join FG2F
        On FG1S.RM_Part_No = FG2F.RM_Part_No
;
