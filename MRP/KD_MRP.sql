Create Or Replace View KD_MRP As
With FG1S As 
        (Select * From KD_MRP_MOH_Sales Where FG_Part_Index = 1),
     FG2S As
        (Select * From KD_MRP_MOH_Sales Where FG_Part_Index = 2),
     FG3S As
        (Select * From KD_MRP_MOH_Sales Where FG_Part_Index = 3),
     FG4S As
        (Select * From KD_MRP_MOH_Sales Where FG_Part_Index = 4),        
     FG1F As
        (Select * From KD_MRP_MOH_Forecast Where FG_Part_Index = 1),
     FG2F As
        (Select * From KD_MRP_MOH_Forecast Where FG_Part_Index = 2),
     FG3F As
        (Select * From KD_MRP_MOH_Forecast Where FG_Part_Index = 3),
     FG4F As
        (Select * From KD_MRP_MOH_Forecast Where FG_Part_Index = 4)

Select
    FG1S.RM_Part_No,
    FG1S.ON_Hand_RM,
    FG1S.Open_PO_RM,
    FG1S.RM_Ratio as RM_Ratio_FG1S,
    FG1S.RMFG_Split_Total as RMFG_Split_Total_FG1S,
    FG1S.Proc_Part_No_1,
    FG1S.On_Hand_Proc1,
    FG1S.Open_PO_Proc1,
    FG1S.Open_SO_Proc1,
    FG1S.Proc1_Total,
    FG1S.Proc_Part_No_2,
    FG1S.On_Hand_Proc2,
    FG1S.Open_PO_Proc2,
    FG1S.Open_SO_Proc2,
    FG1S.Proc2_Total,
    FG1S.FG_Part_No As FG_Part_No_FG1,
    FG1S.On_Hand_FG As On_Hand_FG1S,
    FG1S.Open_SO_FG As Open_SO_FG1S,
    FG1S.FG_Total as FG_Total_FG1S,
    FG1S.Total_Inventory As Total_Inventory_FG1S,
    FG1S.Active_Months As Active_Months_FG1S,
    FG1S.Units_Sold_12M As Units_Sold_12M_FG1S,
    Ceil(FG1S.Avg_Monthly_Sales) As Avg_Monthly_Sales_FG1S,
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
    Ceil(FG2S.Avg_Monthly_Sales) As Avg_Monthly_Sales_FG2S,
    FG2S.Months_On_Hand As Months_On_Hand_FG2S,
    Add_Months(Sysdate,FG2S.Months_On_Hand - 3) As Required_Date_FG2S,
    FG3S.FG_Part_No As FG_Part_No_FG3,
    FG3S.RM_Ratio As RM_Ratio_FG3S,
    FG3S.RMFG_Split_Total As RMFG_Split_Total_FG3S,
    FG3S.On_Hand_FG As On_Hand_FG3S,
    FG3S.Open_SO_FG As Open_SO_FG3S,
    FG3S.FG_Total As FG_Total_FG3S,
    FG3S.Total_Inventory As Total_Inventory_FG3S,
    FG3S.Active_Months As Active_Months_FG3S,
    FG3S.Units_Sold_12M As Units_Sold_12M_FG3S,
    Ceil(FG3S.Avg_Monthly_Sales) As Avg_Monthly_Sales_FG3S,
    FG3S.Months_On_Hand As Months_On_Hand_FG3S,
    Add_Months(Sysdate,FG3S.Months_On_Hand - 3) As Required_Date_FG3S,
    FG4S.FG_Part_No As FG_Part_No_FG4,
    FG4S.RM_Ratio As RM_Ratio_FG4S,
    FG4S.RMFG_Split_Total As RMFG_Split_Total_FG4S,
    FG4S.On_Hand_FG As On_Hand_FG4S,
    FG4S.Open_SO_FG As Open_SO_FG4S,
    FG4S.FG_Total As FG_Total_FG4S,
    FG4S.Total_Inventory As Total_Inventory_FG4S,
    FG4S.Active_Months As Active_Months_FG4S,
    FG4S.Units_Sold_12M As Units_Sold_12M_FG4S,
    Ceil(FG4S.Avg_Monthly_Sales) As Avg_Monthly_Sales_FG4S,
    FG4S.Months_On_Hand As Months_On_Hand_FG4S,
    Add_Months(Sysdate,FG4S.Months_On_Hand - 3) As Required_Date_FG4S,
    FG1F.Forecast_Count as Forecast_Count_FG1F,
    FG1F.Units_Forecast As Units_Forecast_FG1F,
    FG1F.Avg_Monthly_Forecast As Avg_Monthly_Forecast_FG1F,
    Add_Months(Sysdate,FG1F.Months_On_Hand - 3) As Required_Date_FG1F,
    FG1F.Months_On_Hand as Months_On_Hand_FG1F,
    FG2F.Forecast_Count As Forecast_Count_FG2F,
    FG2F.Units_Forecast As Units_Forecast_FG2F,
    FG2F.Avg_Monthly_Forecast as Avg_Monthly_Forecast_FG2F,
    FG2F.Months_On_Hand As Months_On_Hand_FG2F,
    Add_Months(Sysdate,FG2F.Months_On_Hand - 3) As Required_Date_FG2F,
    FG3F.Forecast_Count As Forecast_Count_FG3F,
    FG3F.Units_Forecast As Units_Forecast_FG3F,
    FG3F.Avg_Monthly_Forecast as Avg_Monthly_Forecast_FG3F,
    FG3F.Months_On_Hand As Months_On_Hand_FG3F,
    Add_Months(Sysdate,FG3F.Months_On_Hand - 3) As Required_Date_FG3F,
    FG4F.Forecast_Count As Forecast_Count_FG4F,
    FG4F.Units_Forecast As Units_Forecast_FG4F,
    FG4F.Avg_Monthly_Forecast as Avg_Monthly_Forecast_FG4F,
    FG4F.Months_On_Hand As Months_On_Hand_FG4F,
    Add_Months(Sysdate,FG4F.Months_On_Hand - 3) As Required_Date_FG4F
From
    FG1S Left Join FG2S 
        On FG1S.RM_Part_No = FG2S.RM_Part_No
         Left Join FG3S
        On FG1S.RM_Part_No = FG3S.RM_Part_No
         Left Join FG4S
        On FG1S.RM_Part_No = FG4S.RM_Part_No
         Left Join FG1F
        On FG1S.RM_Part_No = FG1F.RM_Part_No
         Left Join FG2F
        On FG1S.RM_Part_No = FG2F.RM_Part_No
         Left Join FG3F
        On FG1S.RM_Part_No = FG3F.RM_Part_No
         Left Join FG4F
        On FG1S.RM_Part_No = FG4F.RM_Part_No