Select
  A.Catalog_No,
  A.Catalog_Desc,
  A.Part_Product_Family,
  A.Part_Product_Code,
  Sales_Part_Api.Get_List_Price('100',A.Catalog_No) As List_Price,
  Round(Nullif(Sum(A.Allamounts),0)/Sum(A.Invoiced_Qty),2) As Asp,
  Round((Round(Nullif(Sum(A.Allamounts),0)/Sum(A.Invoiced_Qty),2))/Sales_Part_Api.Get_List_Price('100',A.Catalog_No),4) * 100 As ASP_PCT_LIST
From
  KD_Sales_Data_Request A
Where
--  A.Catalog_No In ('10.210.1050',
--                   '10.405.1520',
--                   '10.220.1030',
--                   '10.210.1060',
--                   '10.210.1070',
--                   '10.220.1040',
--                   'TXT1224',
--                   'BAT 12D-15',
--                   '401194',
--                   '10.401.1520') And
  A.Invoicedate >= Trunc(Sysdate-365) And
  A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%' And
  A.Invoiced_Qty > 0 And 
  A.Corporate_Form = 'DOMDIR' And
  A.Part_Product_Family In ('GNSIS','PRIMA','PRMA+','PCOMM','TLMAX','COMM')
Group By
  A.Catalog_No,
  A.Catalog_Desc,
  A.Part_Product_Family,
  A.Part_Product_Code,
  Sales_Part_Api.Get_List_Price('100',A.Catalog_No)