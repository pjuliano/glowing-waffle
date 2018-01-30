Select
  *
From
  (Select
     Extract(Year From A.Invoicedate) As Year,
     A.Part_Product_Family,
     Sum(A.Invoiced_Qty) As Units
   From
     Kd_Sales_Data_Request A
   Where
     A.Part_Product_Family In ('OCT','EXHEX','GNSIS','PRIMA','RENOV','RESTO','STAGE','TLMAX','ZMAX','TRINX') And
     A.Charge_Type = 'Parts' And
     A.Invoicedate Between To_Date('01/01/2012','MM/DD/YYYY') And To_Date('12/31/2017','MM/DD/YYYY')
   Group By
     Extract(Year From A.Invoicedate),
     A.Part_Product_Family)
Pivot
  (Sum(Units) For Part_Product_Family In ('OCT' "OCT",'EXHEX' "EXHEX",'GNSIS' "GNSIS",'PRIMA' "PRIMA",'RENOV' "RENOV", 'RESTO' "RESTO",'STAGE' "STAGE",'TLMAX' "TLMAX",'ZMAX' "ZMAX",'TRINX' "TRINX"))