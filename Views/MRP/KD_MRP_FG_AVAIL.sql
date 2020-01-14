Create Or Replace View KD_MRP_FG_AVAIL As
Select Distinct
    A.FG_Part_No,
    A.Fg_Part_Index,
    NVL(B.On_Hand_FG,0) As On_Hand_FG,
    NVL(C.Open_SO_FG,0) As Open_SO_FG,
    NVL(d.open_po_fg,0) AS open_po_fg
From
    KD_MRP_Part_Relationships A Left Join KD_MRP_FG_ON_HAND B
        On A.FG_Part_No = B.FG_Part_No
                                Left Join KD_MRP_FG_Open_SO C
        On A.FG_Part_No = C.FG_Part_No
                                LEFT JOIN kd_mrp_fg_open_po d
        ON a.fg_part_no = d.fg_part_no