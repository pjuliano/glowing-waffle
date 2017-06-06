Create Or Replace View KD_Prior_Order_Activity_Date As
Select
  A.Order_No,
  Max(A.Invoicedate) As Prior_Activity_Date
From
  Kd_Sales_Data_Request A
Where
  A.Site = '100' And
  A.InvoiceDate != Trunc(Sysdate)
Group By
  A.Order_No