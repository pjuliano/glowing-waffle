--------------------------------------------------------
--  DDL for View KD_MRP_FG_ON_HAND
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "IFSAPP"."KD_MRP_FG_ON_HAND" ("FG_PART_NO", "ON_HAND_FG") AS 
  Select
    A.Fg_Part_No,
    Decode(Sum(B.Qty_OnHand - B.Qty_Reserved),Null,0,Sum(B.Qty_OnHand - B.Qty_Reserved)) On_Hand_FG
From
    KD_MRP_Part_Relationships A Left Join Inventory_Part_In_Stock B
        On A.FG_Part_No = B.Part_No
Group By
    A.FG_Part_No
;
