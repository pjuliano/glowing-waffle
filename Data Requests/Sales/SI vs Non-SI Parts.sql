Select 
  * 
From 
  (
Select
  *
From
  (
  Select
    A.Association_No,
    A.Part_Product_Family,
    A.AllAmounts
  From
    KD_Sales_Data_Request A
  Where
    A.Association_No Like 'N1%' And
    Extract(Year From A.Invoicedate) = 2017 And
    A.Charge_Type = 'Parts' And
    A.Part_Product_Family In ('COMM','GNSIS','PRIMA','RENOV','RESTO','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED','PRMA+','PCOMM','TLMAX')
  )
Pivot
  (
  Sum(AllAmounts) For Part_Product_Family In ('COMM','GNSIS','PRIMA','RENOV','RESTO','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED','PRMA+','PCOMM','TLMAX'))
 ) Sub1 Order By 1 Asc