Create Or Replace View KD_MRP_FG_SALES_QTY As 
Select
    A.FG_Part_No,
    A.FG_Part_Index,
    NVL(Sum(B.Invoiced_Qty * Nvl(A.Fg_Multiplier,1)),0) As Units_Sold_12M
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