--------------------------------------------------------
--  DDL for View KD_MRP_FG_AVAIL
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "IFSAPP"."KD_MRP_FG_AVAIL" ("FG_PART_NO", "FG_PART_INDEX", "ON_HAND_FG", "OPEN_SO_FG") AS 
  Select
    A.FG_Part_No,
    A.Fg_Part_Index,
    Decode(B.On_Hand_FG,Null,0,B.On_Hand_FG) As On_Hand_FG,
    Decode(C.Open_SO_FG,Null,0,C.Open_SO_FG) As Open_SO_FG
From
    KD_MRP_Part_Relationships A Left Join KD_MRP_FG_ON_HAND B
        On A.FG_Part_No = B.FG_Part_No
                                Left Join KD_MRP_FG_Open_SO C
        On A.FG_Part_No = C.FG_Part_No
;
