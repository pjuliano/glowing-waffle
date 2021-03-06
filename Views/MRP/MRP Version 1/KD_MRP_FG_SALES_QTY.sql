--------------------------------------------------------
--  DDL for View KD_MRP_FG_SALES_QTY
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "IFSAPP"."KD_MRP_FG_SALES_QTY" ("FG_PART_NO", "FG_PART_INDEX", "UNITS_SOLD_12M") AS 
  Select
    A.FG_Part_No,
    A.FG_Part_Index,
    Decode(Sum(B.Invoiced_Qty),Null,0,Sum(B.Invoiced_Qty)) As Units_Sold_12M
From
    KD_MRP_Part_Relationships A Left Join KD_Sales_Data_Request B
        On A.FG_Part_No = B.Catalog_No And
           --B.InvoiceDate >= Add_Months(Sysdate,-12)
           B.InvoiceDate >= Add_Months(Trunc(sysdate,'MM'),-12) And 
           B.InvoiceDate <= Last_Day(Add_Months(Sysdate,-1)) And
           B.Invoiced_Qty > 0
Group By
    A.FG_Part_No,
    A.FG_Part_Index
;
