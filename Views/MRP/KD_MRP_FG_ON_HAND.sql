Create Or Replace View KD_MRP_FG_ON_HAND As
Select
    A.Fg_Part_No,
    NVL(Sum((B.Qty_OnHand - B.Qty_Reserved) * Nvl(A.Fg_Multiplier,1)),0) On_Hand_FG
From
    KD_MRP_Part_Relationships A 
    Left Join Inventory_Part_In_Stock B On 
        A.FG_Part_No = B.Part_No
        AND B.Availability_Control_ID Is Null
Group By
    A.FG_Part_No