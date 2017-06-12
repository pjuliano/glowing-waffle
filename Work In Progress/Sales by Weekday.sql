Select
  Person_Info_Api.Get_Name(A.Salesman_Code) As Rep,
  A.Region_Code,
  A.Invoicedate,
  Calendar_Api.Get_Week_Day(A.Invoicedate) As Day,
  Sum(A.AllAmounts) As Total
From
  Kd_Sales_Data_Request A
Where
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  A.Invoicedate >= To_Date('01/01/2017','MM/DD/YYYY')
Group By
  Person_Info_Api.Get_Name(A.Salesman_Code),
  A.Region_Code,
  A.Invoicedate,
  Calendar_Api.Get_Week_Day(A.InvoiceDate)
Order By
  A.Invoicedate,
  A.Region_Code,
  Person_Info_Api.Get_Name(A.Salesman_Code)