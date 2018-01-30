Select
  A.Customer_No,
  A.CustomeR_Name,
  Sum(Case When A.Catalog_No = '15728K'
           Then A.Invoiced_Qty
           Else 0
      End) As Kit_Qty,
  Sum(Case When A.Part_Product_Code = 'IMPL'
           Then A.Invoiced_Qty
           Else 0
      End) As Impl_Qty,
  Sum(Case When A.Part_Product_Code != 'IMPL' And
                A.Catalog_No != '15728K'
           Then A.Invoiced_Qty
           Else 0
      End) As Other_Qty,
  A.Delivadd1,
  A.Delivadd2,
  A.Delivcity,
  A.Delivstate,
  A.Delivzip
From
  IFSAPP.Kd_Sales_Data_Request A
Where
  A.Part_Product_Family = 'PRMA+' And
  A.Corporate_Form != 'KEY' And
  A.Catalog_No Not In ('MK40325','100045-EN01')
Group By
  Customer_No,
  Customer_Name,
  A.Delivadd1,
  A.Delivadd2,
  A.Delivcity,
  A.Delivstate,
  A.DelivZip