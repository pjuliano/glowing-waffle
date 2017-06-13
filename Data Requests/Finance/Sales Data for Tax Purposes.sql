Select 
  A.Customer_No,
  A.Customer_Name,
  A.Order_No,
  A.Invoice_Id,
  A.Invoicedate,
  A.Catalog_No,
  A.Catalog_Desc,
  A.Part_Product_Family,
  A.Part_Product_Code,
  Case When A.Part_Product_Family In ('DYNAC','DYNAG','DYNAB','DYNAM','CONNX','CYTOP','BVINE','SYNTH','MTF')
       Then 'BIOMATERIALS'
       When A.Part_Product_Family In ('COMM','GNSIS','PRIMA','RENOV','RESTO','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED')
       Then 'IMPLANTS'
       Else 'OTHER'
  End As Product_Type,
  Sales_Part_Api.Get_Catalog_Group(A.Site,A.Catalog_No) As Catalog_Group,
  A.Invoiced_Qty,
  A.Allamounts,
  A.Cost * A.Invoiced_Qty As Cost,
  A.Delivadd1,
  A.Delivadd2,
  A.Delivcity,
  A.Delivstate,
  A.Delivzip,
  A.Delivcounty
From 
  Kd_Sales_Data_Request A
Where
  A.Charge_Type = 'Parts' And
  A.Delivcountry = 'UNITED STATES' And
  A.Invoicedate Between To_Date('06/01/2016','MM/DD/YYYY') And To_Date('02/28/2017','MM/DD/YYYY')