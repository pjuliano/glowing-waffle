Select
  A.Part_Product_Family,
  A.Part_Product_Code,
  Sum(A.Invoiced_Qty) Total_Qty,
  Sum(A.Allamounts) Total_Sales,
  Round(Sum(A.Allamounts)/Decode(Sum(A.Invoiced_Qty),0,Null,Sum(A.Invoiced_Qty)),2) As Asp,
  Round(Sum(A.Cost),2) As Total_Cost,
  Round((Sum(A.AllAmounts)-Sum(A.Cost))/Decode(Sum(A.AllAmounts),0,Null,Sum(A.AllAmounts)),4)*100 As Margin
From
  Ifsapp.Kd_Sales_Data_Request A
Where
  A.Customer_No = '&CustomerNo' And
  A.Charge_Type = 'Parts' And
  A.InvoiceDate Between To_Date('&StartDate','MM/DD/YYYY') And To_Date('&EndDate','MM/DD/YYYY')
Group By
  A.Part_Product_Family,
  A.Part_Product_Code
Order By
  A.Part_Product_Family,
  A.Part_Product_Code