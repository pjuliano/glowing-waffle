--------------------------------------------------------
--  DDL for View KD_MRP_PROC_OPEN_PO
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "IFSAPP"."KD_MRP_PROC_OPEN_PO" ("PROC_PART_NO", "OPEN_PO_PROC") AS 
  Select
    A.Proc_Part_No,
    Decode(Sum(B.Due_At_Dock),Null,0,Sum(B.Due_At_Dock)) As Open_PO_Proc
From
    KD_MRP_Part_Relationships A Left Join Purchase_Order_Line_New B
        On A.Proc_Part_No = B.Part_No And
           B.Order_No Not Like 'S%'
Group By
    A.Proc_Part_No
;
