With Total2016sales As (
  Select 
    A.Customer_No,
    Sum(A.AllAmounts) As TotalCY
  From 
    Kd_Sales_Data_Request A
  Where 
    A.Charge_Type = 'Parts' And
    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
  Group By
    A.Customer_No)
  
Select 
  A.Customer_Id,
  Customer_Info_Api.Get_Name(A.Customer_Id),
  Customer_Info_Api.Get_Association_No(A.Customer_ID),
  A.Price_List_No,
  B.Total2016
From 
  Customer_Pricelist_Ent A Left Join Total2016sales B 
    On A.Customer_Id = B.Customer_No
Where
  Customer_Info_Api.Get_Association_No(A.Customer_ID) Not Like 'N%'
