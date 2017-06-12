Create Or Replace View KD_Weekday_Avg_CY As 
Select
  *
From 
  (
  Select
    Salesman_Code,
    Calendar_Api.Get_Week_Day(Invoicedate) As Weekday,
    Total
  From
    (
    Select
      A.Salesman_Code,
      A.Invoicedate,
      Sum(A.AllAmounts) As Total
    From
      Kd_Sales_Data_Request A
    Where
      A.Charge_Type = 'Parts' And
      A.Corporate_Form = 'DOMDIR' And
      Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
    Group By
      A.Salesman_Code,
      A.Invoicedate
    )
  )
Pivot
  (
  Avg(Total) For Weekday In ('Monday' As Monday,'Tuesday' As Tuesday,'Wednesday' As Wednesday,'Thursday' As Thursday,'Friday' As Friday)
  )