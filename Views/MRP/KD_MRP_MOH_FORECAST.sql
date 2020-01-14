Create Or Replace View KD_MRP_MOH_FORECAST As
Select
    A.Rm_Part_No,
    A.Production_Family,
    A.Cover_Screw_Part_No,
    B.On_Hand_RM,
    B.Open_PO_RM,
    B.RM_Ratio,
    B.RMFg_Split_Total,
    A.Proc_Part_No_1,
    C.On_Hand_Proc As On_Hand_Proc1,
    C.Open_Po_Proc As Open_PO_Proc1,
    C.Open_So_Proc As Open_SO_Proc1,
    C.On_Hand_Proc + C.Open_PO_Proc + C.Open_So_Proc as PROC1_Total,
    A.Proc_Part_No_2,
    CC.On_Hand_Proc As On_Hand_Proc2,
    CC.Open_PO_Proc As Open_PO_Proc2,
    CC.Open_SO_Proc As Open_SO_Proc2,
    CC.On_Hand_Proc + CC.Open_PO_Proc + CC.Open_So_Proc as PROC2_Total,
    D.Fg_Part_No,
    D.Fg_Part_Index,
    D.On_Hand_Fg,
    D.Open_So_Fg,
    D.Open_PO_fg,
    D.On_Hand_FG + D.Open_SO_FG + D.Open_PO_FG as FG_Total,
    B.RMFG_Split_Total + Nvl(C.On_Hand_Proc,0) + Nvl(C.Open_PO_Proc,0) + Nvl(C.Open_SO_Proc,0) + Nvl(CC.On_Hand_Proc,0) + Nvl(CC.Open_PO_Proc,0) + Nvl(CC.Open_SO_Proc,0) + Nvl(D.On_Hand_Fg,0) + Nvl(D.Open_So_FG,0) As Total_Inventory,
    E.Forecast_Count,
    E.Units_Forecast,
    E.Avg_Monthly_Forecast,
    Round((B.RMFG_Split_Total + Nvl(C.On_Hand_Proc,0) + Nvl(C.Open_PO_Proc,0) + Nvl(C.Open_SO_Proc,0) + Nvl(CC.On_Hand_Proc,0) + Nvl(CC.Open_PO_Proc,0) + Nvl(CC.Open_SO_Proc,0) + Nvl(D.On_Hand_Fg,0) + Nvl(D.Open_So_Fg,0))/Nullif(E.Avg_Monthly_Forecast,0),2) As Months_On_Hand
From
    KD_MRP_Part_Relationships A Left Join Kd_Mrp_Rm_Avail_Forecast B
        On A.RM_Part_No = B.Rm_Part_No And
           A.FG_Part_No = B.FG_Part_No
                                Left Join KD_MRP_Proc1_Avail C
        On A.Proc_Part_No_1 = C.Proc_Part_No_1
                                Left Join KD_MRP_PROC2_Avail CC
        On A.Proc_Part_No_2 = CC.Proc_Part_No_2
                                Left Join KD_MRP_FG_Avail D
        On A.FG_Part_No = D.FG_Part_No
            And A.Fg_Part_Index = D.Fg_Part_Index
                                Left Join KD_MRP_FG_Avg_Forecast E
        On A.FG_Part_No = E.FG_Part_No
            And A.Fg_Part_Index = e.Fg_Part_Index
Order By
    A.Fg_Part_Index,
    A.FG_Part_No