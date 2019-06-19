Create Or Replace View KD_MRP_RM_ON_HAND As
With RM_Parts As 
    (
    Select
        A.RM_part_No
    From
        KD_MRP_Part_Relationships A
    Group By
        A.RM_Part_No
    )
Select
    A.RM_Part_No,
    NVL(Sum(B.Qty_OnHand - B.Qty_Reserved),0) On_Hand_RM
From
    RM_Parts A Left Join Inventory_Part_In_Stock B
        On A.RM_Part_No = B.Part_No
Group By
    A.RM_Part_No