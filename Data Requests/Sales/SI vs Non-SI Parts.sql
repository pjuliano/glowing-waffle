Select
  *
From
  (
  Select
    A.Association_No,
    Case When A.Part_Product_Family In ('CALFO','CALMA','CAPSE','CYTOP','EXHEX','EXORL','OCT','PRSFT','TEFGE','TRINX','ZMAX') Then 'SI'
         Else 'NOT SI'
    End As Company,
    A.AllAmounts
  From
    KD_Sales_Data_Request A
  Where
    A.Association_No Like 'N1%' And
    Extract(Year From A.Invoicedate) = 2017 And
    A.Charge_Type = 'Parts'
  )
Pivot
  (
  Sum(AllAmounts) For Company In ('SI' As "SI",'NOT SI' As "NOT SI"))