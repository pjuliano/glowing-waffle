Select
  A.Customer_Id,
  A.Name,
  Sum(B.Allamounts) As Last_90_Sales,
  C.Balance As Current_Balance,
  Customer_Credit_Info_Api.Get_Credit_Limit(100,A.Customer_Id) As Credit_Limit,
  Identity_Invoice_Info_Api.Get_Pay_Term_Id(100,A.Customer_ID,'Customer') As Pay_Term_ID
From
  Customer_Info A Left Join Kd_Sales_Data_Request B
    On A.Customer_Id = B.Customer_No And 
       B.Charge_Type = 'Parts' And
       B.Invoicedate >= Trunc(Sysdate) - 90
                  Left Join Identity_Pay_Info_Cu_Qry C
    On A.Customer_Id = C.Identity
Where
  A.Corporate_Form = 'DOMDIR'
Group By  
  A.Customer_Id,
  A.Name,
  C.Balance,
  Customer_Credit_Info_Api.Get_Credit_Limit(100,A.Customer_Id),
  Identity_Invoice_Info_Api.Get_Pay_Term_Id(100,A.Customer_ID,'Customer')