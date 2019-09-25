Create Or Replace View KD_MRP_RM_AVAIL_FORECAST As
Select
    A.RM_Part_No,
    A.FG_Part_No,
    A.RM_Ratio,
    B.Open_PO_RM / NVL(RM_Divisor,1) AS Open_PO_RM,
    B.On_Hand_RM / NVL(RM_Divisor,1) AS On_Hand_RM,
    Round(((B.Open_PO_RM + B.On_Hand_RM)/NVL(RM_Divisor,1)) * A.RM_Ratio) As RMFG_Split_Total
From
    KD_MRP_RM_Ratio_Forecast A,
    KD_MRP_RM_Qtys B
Where
    A.RM_Part_No = B.Rm_Part_No