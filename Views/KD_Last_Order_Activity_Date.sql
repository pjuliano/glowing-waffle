Create Or Replace View KD_Last_Order_Activity_Date As
Select
  A.Order_No,
  Max(A.Invoicedate) As Last_Activity_Date
From
  Kd_Sales_Data_Request A
Where
  A.Site = '100'
Group By
  A.Order_No