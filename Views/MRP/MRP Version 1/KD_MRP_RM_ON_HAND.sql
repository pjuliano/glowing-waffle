--------------------------------------------------------
--  DDL for View KD_MRP_RM_ON_HAND
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "IFSAPP"."KD_MRP_RM_ON_HAND" ("RM_PART_NO", "ON_HAND_RM") AS 
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
    Decode(Sum(B.Qty_OnHand - B.Qty_Reserved),Null,0,Sum(B.Qty_OnHand - B.Qty_Reserved)) On_Hand_RM
From
    RM_Parts A Left Join Inventory_Part_In_Stock B
        On A.RM_Part_No = B.Part_No
Group By
    A.RM_Part_No
;
