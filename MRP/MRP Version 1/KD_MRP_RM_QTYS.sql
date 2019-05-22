--------------------------------------------------------
--  DDL for View KD_MRP_RM_QTYS
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "IFSAPP"."KD_MRP_RM_QTYS" ("RM_PART_NO", "OPEN_PO_RM", "ON_HAND_RM") AS 
  With RM_Parts As 
    (
    Select 
        A.RM_Part_No
    From 
        KD_MRP_Part_Relationships A
    Group By
        A.RM_Part_No
    )

Select
    A.RM_Part_No,
    Decode(B.Open_PO_RM,Null,0,B.Open_PO_RM) As Open_PO_RM,
    Decode(C.On_Hand_Rm,Null,0,C.On_Hand_RM) As On_Hand_RM
From
    RM_Parts A Left Join KD_MRP_RM_OPEN_PO B
        On A.RM_Part_No = B.RM_Part_No
               Left Join KD_MRP_RM_ON_HAND C
        On A.RM_Part_No = C.RM_Part_No
;
