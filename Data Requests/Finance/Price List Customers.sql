With PLCustomers As (
  Select 
    Customer_No
  From 
    Customer_Pricelist
  Group By
    Customer_No
  )

Select
  B.Customer_No,
  Customer_Info_Api.Get_Name(B.Customer_No) As Customer_Name,
  B.Association_No,
  Case When A.Customer_No Is not Null then 'PL Customer' Else Null End As "PL Customer",
  Sum(Case When Extract(Year From B.Invoicedate) = '2015' Then B.Allamounts Else 0 End) As "2015",
  Sum(Case When Extract(Year From B.Invoicedate) = '2016' Then B.Allamounts Else 0 End) As "2016", 
  Sum(Case When Extract(Year From B.Invoicedate) = '2017' Then B.Allamounts Else 0 End) As "2017",
  Sum(Case When Extract(Year From B.InvoiceDate) = '2018' Then B.AllAmounts Else 0 End) As "2018"
From
  Kd_Sales_Data_Request B Left Join Plcustomers A On A.Customer_No = B.Customer_No
Where
  B.Corporate_Form = 'DOMDIR'
Group By
  B.Customer_No,
  Customer_Info_Api.Get_Name(B.Customer_No),
  B.Association_No,
  Case When A.Customer_No Is Not Null Then 'PL Customer' Else Null End
Having
  Sum(Case When Extract(Year From B.Invoicedate) = '2015' Then B.Allamounts Else 0 End) + 
  Sum(Case When Extract(Year From B.Invoicedate) = '2016' Then B.Allamounts Else 0 End) + 
  Sum(Case When Extract(Year From B.Invoicedate) = '2017' Then B.Allamounts Else 0 End) + 
  Sum(Case When Extract(Year From B.InvoiceDate) = '2018' Then B.AllAmounts Else 0 End) != 0