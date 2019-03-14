Create Or Replace View KD_MRP_PROC_ON_HAND As
Select
    A.PROC_Part_No,
    Decode(Sum(B.Qty_OnHand - B.Qty_Reserved),Null,0,Sum(B.Qty_OnHand - B.Qty_Reserved)) On_Hand_PROC
From
    KD_MRP_Part_Relationships A Left Join Inventory_Part_In_Stock B
        On A.PROC_Part_No = B.Part_No
Group By
    A.PROC_Part_No