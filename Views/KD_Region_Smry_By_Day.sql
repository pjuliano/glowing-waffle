Create Or Replace View KD_Region_Smry_By_Day As 
Select
  A.Invoicedate,
  Sum(Case When A.Region_Code = 'SECA'
           Then A.Allamounts 
           Else 0
      End) As Seca,
  Sum(Case When A.Region_Code = 'USEC'
           Then A.Allamounts
           Else 0
      End) As Usec,
  Sum(Case When A.Region_Code = 'USCE'
           Then A.Allamounts
           Else 0
      End) As Usce,
  Sum(Case When A.Region_Code = 'USWC'
           Then A.Allamounts
           Else 0
      End) As USWC,
  Sum(Case When A.Region_Code = 'UNASSIGNED'
           Then A.Allamounts
           Else 0
      End) As Unassigned,
  Sum(Case When A.Region_Code In ('SECA','USEC','USCE','USWC','UNASSIGNED')
           Then A.Allamounts
           Else 0
      End) As Total
From
  Kd_Sales_Data_Request A
Where
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
  A.Charge_Type = 'Parts'
Group By
  A.InvoiceDate
Order By
  A.InvoiceDate