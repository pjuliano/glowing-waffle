--------------------------------------------------------
--  DDL for View KD_MRP_RM_RATIO_SALES
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "IFSAPP"."KD_MRP_RM_RATIO_SALES" ("RM_PART_NO", "FG_PART_NO", "RM_RATIO") AS 
  With Sales_Qtys As 
    (
    Select
        A.RM_part_No,
        Sum(Case When A.FG_Part_Index = 1 Then B.Invoiced_Qty Else 0 End) As Sales_Qty_FG1,
        Sum(Case When A.FG_Part_Index = 2 Then B.Invoiced_Qty Else 0 End) As Sales_Qty_FG2
    From
        KD_MRP_Part_Relationships A,
        KD_Sales_Data_Request B
    Where
        A.FG_Part_No = B.Catalog_No And 
        B.InvoiceDate >= Add_Months(Trunc(sysdate,'MM'),-12) And 
        B.InvoiceDate <= Last_Day(Add_Months(Sysdate,-1)) And
        B.Invoiced_Qty > 0
    Group By
        A.RM_Part_No
    )
Select 
    A.RM_Part_No, 
    A.FG_Part_No,
    Round(Case When A.FG_Part_Index = 1 Then (B.Sales_Qty_Fg1/(Nullif((B.Sales_Qty_FG1 + B.Sales_Qty_FG2),0)))
               When A.FG_Part_Index = 2 Then (B.Sales_Qty_FG2/(Nullif((B.Sales_Qty_FG1 + B.Sales_Qty_FG2),0))) 
          End,3) As RM_Ratio
From
    Kd_Mrp_Part_Relationships A Left Join Sales_Qtys B On 
        A.RM_Part_No = B.RM_Part_No
;
