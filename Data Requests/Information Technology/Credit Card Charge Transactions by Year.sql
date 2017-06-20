Select
  *
From (
  Select
    A.Card_Type,
    Extract(Year From A.Trans_Date) As Year,
    Count(1) As Transactions
  From
    Credit_Card_Transactions A
  Where
    A.Trans_Type = 'Charge' And
    Extract(Year From A.Trans_Date) >= Extract(Year From Sysdate)-1
  Group By
    A.Card_Type,
    Extract(Year From A.Trans_Date))
Pivot
  (Sum(Transactions) For Year In ('2016' As "2016",'2017' As "2017"))