Create Or Replace View KD_MRP_RM_Ratio_Forecast AS
With Forecast_Qtys As 
    (
        Select
            A.RM_Part_No,
            Sum(Case When A.FG_Part_Index = 1 Then B.Forecast_Lev0 + Forecast_Lev1 End) As Forecast_Qty_FG1,
            Sum(Case When A.FG_Part_Index = 2 Then B.Forecast_Lev0 + Forecast_Lev1 End) As Forecast_Qty_FG2,
            Sum(Case When A.FG_Part_Index = 1 Then 1 Else 0 End) As Forecast_Count
        From 
            KD_MRP_Part_Relationships A,
            Level_1_Forecast B
        Where
            A.FG_Part_No = B.Part_No And 
            B.Contract = '100' And
            (   B.Forecast_Lev0 != 0 Or B.Forecast_Lev1 != 0    )
        Group By
            A.RM_Part_No
    )
Select 
    A.RM_Part_No, 
    A.FG_Part_No,
    Round(Case When A.FG_Part_Index = 1 Then (B.Forecast_Qty_Fg1/(Nullif((B.Forecast_Qty_FG1 + B.Forecast_Qty_FG2),0)))
               When A.FG_Part_Index = 2 Then (B.Forecast_Qty_FG2/(Nullif((B.Forecast_Qty_FG1 + B.Forecast_Qty_FG2),0))) 
          End,3) As RM_Ratio,
    B.Forecast_Count
From
    Kd_Mrp_Part_Relationships A Left Join Forecast_Qtys B On 
        A.RM_Part_No = B.RM_Part_No