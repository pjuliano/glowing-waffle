--Find the account(s).
Select * From Customer_Info A Where A.Name Like '%Tweaks%';
--Check last year's sales in Implant product families is <= 1000.
Select
  Sum(A.Allamounts) 
From 
  Kd_Sales_Data_Test A 
Where 
  Extract(Year From A.Invoicedate) In (2015,2016) And
  A.Part_Product_Family In ('COMM','GNSIS','PRIMA','RENOV','RESTO','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED') And
  A.Part_Product_Code = 'IMPL' And
  A.Customer_No = '1020';
--Check that sum of this year's sales is >= 5000.
Select
  Sum(A.Allamounts)
From
  Kd_Sales_Data_Test A
Where
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  A.Charge_Type = 'Parts' And
  A.Part_Product_Family In ('COMM','GNSIS','PRIMA','RENOV','RESTO','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED') And
  A.Customer_No = '23214';
--Check that sum of Implant Bodies sales is <= 3750.
Select
  Catalog_Desc,
  Sum(A.Allamounts)
From
  Kd_Sales_Data_Test A
Where
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  A.Part_Product_Code = 'IMPL' And
  A.Customer_No = '1020'
Group By
  Catalog_Desc;
--Bask in the glory that your code is superior and always right. 