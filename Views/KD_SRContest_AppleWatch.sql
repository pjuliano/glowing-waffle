Create or Replace View KD_SRCONTEST_APPLEWTCH As
Select
  A.Salesman_Code,
  Person_Info_Api.Get_Name(A.Salesman_Code) As Name,
  A.Customer_No,
  A.Customer_Name,
  Sum(Case When A.Catalog_No = '15728K'
           Then 1
           Else 0
           End) As "PRMA+ Kit Sales",
  Sum(Case When A.Part_Product_Family = 'PRMA+' And 
                A.Part_Product_Code = 'IMPL'
           Then A.Allamounts
           Else 0
           End) As "PRMA+ Implant Sales",
  Sum(Case When Upper(A.Catalog_Desc) Like '%MAX%' And
                A.Part_Product_Code = 'IMPL'
           Then A.Allamounts
           Else 0
           End) As Max_Sales,
  Sum(Case When A.Part_Product_Family = 'GNSIS' And
                A.Part_Product_Code = 'IMPL'
           Then A.Allamounts
           Else 0
           End) As Genesis_Sales
From
  Kd_Sales_Data_Request A
Where 
  A.InvoiceDate Between To_Date('05/01/2018','MM/DD/YYYY') And To_Date('12/31/2018','MM/DD/YYYY') And
  A.Corporate_Form = 'DOMDIR'
Group By
  A.Salesman_Code,
  Person_Info_Api.Get_Name(A.Salesman_Code),
  A.Customer_No,
  A.Customer_Name
Having
  Sum(Case When A.Catalog_No = '15728K'
           Then 1
           Else 0
           End) > 0