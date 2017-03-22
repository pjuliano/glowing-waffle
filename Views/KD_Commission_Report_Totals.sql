Create or Replace View KD_Commission_Report_Totals As
Select
  A.Salesman_Code,
  A.Salesman_Name,
  A.Region,
  Sum(Case
        When
          Extract(Month From A.Invoicedate) = Extract(Month From Sysdate)
        Then
          A.Implant_Commission + A.Bio_Commission + A.Gross_Margin_Commission
        Else
          0
      End) As This_Month_Commission,
  Sum(Case
        When
          Extract(Month From A.Invoicedate) In ('1','2','3') And
          Extract(Month From Sysdate) In ('1','2','3')
        Then
          A.Implant_Commission + A.Bio_Commission + A.Gross_Margin_Commission
        When
          Extract(Month From A.Invoicedate) In ('4','5','6') And
          Extract(Month From Sysdate) In ('4','5','6')
        Then
          A.Implant_Commission + A.Bio_Commission + A.Gross_Margin_Commission
        When
          Extract(Month From A.Invoicedate) In ('7','8','9') And
          Extract(Month From Sysdate) In ('7','8','9')
        Then
          A.Implant_Commission + A.Bio_Commission + A.Gross_Margin_Commission
        When
          Extract(Month From A.Invoicedate) In ('10','11','12') And
          Extract(Month From Sysdate) In ('10','11','12')
        Then
          A.Implant_Commission + A.Bio_Commission + A.Gross_Margin_Commission
        Else
          0
      End) As This_Qtr_Commission,
  Sum(A.Implant_Commission + A.Bio_Commission + A.Gross_Margin_Commission) This_Year_Commission
From
  Kd_Commission_Report_Test A
Group By
  A.Salesman_Code,
  A.Salesman_Name,
  A.Region