Create Or Replace View KD_MRP_PROC2_ON_HAND As
With Proc_Parts As 
    (
    Select
        A.Proc_Part_No_2
    From
        KD_MRP_Part_Relationships A
    Group By
        A.Proc_Part_No_2
    )
Select
    A.PROC_Part_No_2,
    Decode(Sum(B.Qty_OnHand - B.Qty_Reserved),Null,0,Sum(B.Qty_OnHand - B.Qty_Reserved)) On_Hand_PROC
From
    Proc_Parts A Left Join Inventory_Part_In_Stock B
        On A.PROC_Part_No_2 = B.Part_No
Group By
    A.PROC_Part_No_2