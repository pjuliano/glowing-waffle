Select
  A.Catalog_No,
  A.Catalog_Desc,
  Sales_Part_Api.Get_List_Price('100',A.Catalog_No) As List_Price,
  Round(Sum(A.Allamounts)/Sum(A.Invoiced_Qty),2) As Asp,
  Round((Round(Sum(A.Allamounts)/Sum(A.Invoiced_Qty),2))/Sales_Part_Api.Get_List_Price('100',A.Catalog_No),4) * 100 As ASP_PCT_LIST
From
  KD_Sales_Data_Request A
Where
  A.Catalog_No In ('10.210.1050',
                   '10.405.1520',
                   '10.220.1030',
                   '10.210.1060',
                   '10.210.1070',
                   '10.220.1040',
                   'TXT1224',
                   'BAT 12D-15',
                   '401194',
                   '10.401.1520') And
  Invoicedate >= Trunc(Sysdate-365)
Group By
  A.Catalog_No,
  A.Catalog_Desc,
  Sales_Part_Api.Get_List_Price('100',A.Catalog_No)