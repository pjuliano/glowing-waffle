Create Or Replace View KD_MRP_MOH_SALES As
Select
    A.Rm_Part_No,
    B.On_Hand_RM,
    B.Open_PO_RM,
    B.RM_Ratio,
    B.RMFg_Split_Total,
    A.Proc_Part_No,
    C.On_Hand_Proc,
    C.Open_Po_Proc,
    C.Open_So_Proc,
    C.On_Hand_Proc + C.Open_PO_Proc + C.Open_So_Proc as PROC_Total,
    D.Fg_Part_No,
    D.Fg_Part_Index,
    D.On_Hand_Fg,
    D.Open_So_Fg,
    D.On_Hand_FG + D.Open_SO_FG as FG_Total,
    B.RMFG_Split_Total + C.On_Hand_Proc + C.Open_PO_Proc + C.Open_SO_Proc + D.On_Hand_Fg + D.Open_So_FG As Total_Inventory,
    E.Active_Months,
    E.Units_Sold_12m,
    E.Avg_Monthly_Sales,
    Round((B.RMFG_Split_Total + C.On_Hand_Proc + C.Open_PO_Proc + C.Open_SO_Proc + D.On_Hand_Fg + D.Open_So_Fg)/E.Avg_Monthly_Sales,2) As Months_On_Hand
From
    KD_MRP_Part_Relationships A Left Join Kd_Mrp_Rm_Avail_Sales B
        On A.RM_Part_No = B.Rm_Part_No And
           A.FG_Part_No = B.FG_Part_No
                                Left Join KD_MRP_PRoc_Avail C
        On A.Proc_Part_No = C.Proc_Part_No
                                Left Join KD_MRP_FG_Avail D
        On A.FG_Part_No = D.FG_Part_No
                                Left Join KD_MRP_FG_Avg_Sales E
        On A.FG_Part_No = E.FG_Part_No
Order By
    A.Fg_Part_Index,
    A.FG_Part_No