Create Or Replace View KD_Region_Smry_By_Day As 
Select
  A.Invoicedate,
  Round(Sum(Case When A.Region_Code = 'SECA'
                 Then A.Allamounts 
                 Else 0
            End)/1000) As Seca,
  Round(Sum(Case When A.Region_Code = 'USEC'
                 Then A.Allamounts
                 Else 0
            End)/1000) As Usec,
  Round(Sum(Case When A.Region_Code = 'USCE'
                 Then A.Allamounts
                 Else 0
            End)/1000) As Usce,
  Round(Sum(Case When A.Region_Code = 'USWC'
                 Then A.Allamounts
                 Else 0
            End)/1000) As Uswc,
  Round(Sum(Case When A.Region_Code = 'UNASSIGNED' And
                      A.Corporate_Form = 'DOMDIR'
                 Then A.Allamounts
                 Else 0
            End)/1000) As Unassigned_Na,
  Round(Sum(Case When A.Region_Code In ('SECA','USEC','USCE','USWC','UNASSIGNED')
                 Then A.Allamounts
                 Else 0
            End)/1000) As Total_Na,
  Round(Sum(Case When A.Region_Code = 'ASIA'
                 Then A.Allamounts
                 Else 0
            End)/1000) As Asia,
  Round(Sum(Case When A.Region_Code = 'CANA'
                 Then A.Allamounts
                 Else 0
            End)/1000) As Cana,
  Round(Sum(Case When A.Region_Code = 'EURO'
                 Then A.Allamounts
                 Else 0
            End)/1000) As Euro,
  Round(Sum(Case When A.Region_Code = 'LATI'
                 Then A.Allamounts
                 Else 0
            End)/1000) As Lati,
  Round(Sum(Case When A.Region_Code = 'USDI'
                 Then A.Allamounts
                 Else 0
            End)/1000) As Usdi,
  Round(Sum(Case When A.Region_Code = 'UNASSIGNED' And
                      A.Corporate_Form Not In ('DOMDIR','KEY')
                 Then A.Allamounts
                 Else 0
            End)/1000) As Unassigned_Dist,
  Round(Sum(Case When A.Region_Code In ('ASIA','CANA','EURO','LATI','USDI','UNASSIGNED') And
                      A.Corporate_Form Not In ('DOMDIR','KEY')
                 Then A.Allamounts
                 Else 0
            End)/1000) As Total_Dist, 
  Round(Sum(Case When A.Region_Code In ('SECA','USEC','USCE','USWC','UNASSIGNED','ASIA','CANA','EURO','LATI','USDI') And
                      A.Corporate_Form != 'KEY'
                 Then A.Allamounts
                 Else 0
            End)/1000) As Grand_Total
From
  Kd_Sales_Data_Request A
Where
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
  A.Charge_Type = 'Parts' And
  A.Corporate_Form != 'KEY'
Group By
  A.InvoiceDate
Order By
  A.InvoiceDate