Select 
  Person_Info_Api.Get_Name(A.Salesman_Code) As Rep,
  Sum(A.Allamounts) Sales_Amount,
  Sum(Sales_Part_Api.Get_List_Price(A.Site,A.Catalog_No) * A.Invoiced_Qty)  As List_Amount
From 
  KD_Sales_Data_Request A
Where
  A.Region_Code = 'USEC' And
  Extract(Year From A.Invoicedate) = '2017' And
  A.Charge_Type = 'Parts' And
  A.Part_Product_Code = 'REGEN' And
  A.Allamounts = 0
Group By
  Person_Info_Api.Get_Name(A.Salesman_Code);
  
Select 
  Person_Info_Api.Get_Name(A.Salesman_Code) As Rep,
  Sum(A.Allamounts) Sales_Amount,
  Sum(Sales_Part_Api.Get_List_Price(A.Site,A.Catalog_No) * A.Invoiced_Qty) As List_Amount
From 
  KD_Sales_Data_Request A
Where
  A.Region_Code = 'USEC' And
  Extract(Year From A.Invoicedate) = '2017' And
  A.Charge_Type = 'Parts' And
  A.Allamounts < Sales_Part_Api.Get_List_Price(A.Site,A.Catalog_No) And
  A.Part_Product_Code = 'REGEN' And
  A.AllAmounts != 0
Group By
  Person_Info_Api.Get_Name(A.Salesman_Code)