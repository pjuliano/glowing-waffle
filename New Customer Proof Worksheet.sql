--Find the account.
Select * From Customer_Info A Where A.Name Like '%Weaks%';
--Check last year's sales in Implant product families is <= 1000.
Select 
  Sum(A.Allamounts) 
From 
  Kd_Sales_Data_Test A 
Where 
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) -1 And 
  A.Part_Product_Family In ('COMM','GNSIS','PRIMA','RENOV','RESTO','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED') And
  A.Customer_No = 'A13430';
--Check to see if they ordered implants last year even though that's not part of the contest rules.
Select 
  Sum(A.Allamounts) 
From 
  Kd_Sales_Data_Test A 
Where 
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) -1 And 
  A.Part_Product_Family In ('COMM','GNSIS','PRIMA','RENOV','RESTO','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED') And
  A.PArt_Product_Code = 'IMPL' And
  A.Customer_No = 'A13430';
--Check that sum of this year's sales is >= 5000.
Select
  Sum(A.Allamounts)
From
  Kd_Sales_Data_Test A
Where
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  A.Charge_Type = 'Parts' And
  A.Customer_No = '2944';
--Check that sum of Implant Bodies sales is <= 3750.
Select
  Sum(A.Allamounts)
From
  Kd_Sales_Data_Test A
Where
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  A.Part_Product_Code = 'IMPL' And
  A.Customer_No = '23214';
--Bask in the glory that your code is superior and always right. 