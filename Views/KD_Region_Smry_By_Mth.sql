Create Or Replace View KD_Region_Smry_By_Mth As
Select
  Extract(Year From A.InvoiceDate) As Year,
  Extract(Month From A.Invoicedate) As Month,
  Round(Sum(Case When A.Region_Code = 'USNC' And
                      A.Corporate_Form = 'DOMDIR' And
                      A.Catalog_No != '3DBC-22001091' And
                      ((A.Order_No Not Like 'W%' And
                      A.Order_No Not Like 'X%') Or
                      A.Order_No Is Null) And
                      (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
                      A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
                      A.Order_No != 'C512921' --Kevin Stack's order/return that spanned years.
                 Then A.Allamounts 
                 Else 0
            End)/1000) As USNC,
  Round(Sum(Case When A.Region_Code = 'USEC' And
                      A.Corporate_Form = 'DOMDIR' And
                      A.Catalog_No != '3DBC-22001091' And
                      ((A.Order_No Not Like 'W%' And
                      A.Order_No Not Like 'X%') Or
                      A.Order_No Is Null) And
                      (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
                      A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
                      A.Order_No != 'C512921' --Kevin Stack's order/return that spanned years.
                 Then A.Allamounts
                 Else 0
            End)/1000) As USEC,
  Round(Sum(Case When A.Region_Code = 'USSC' And
                      A.Corporate_Form = 'DOMDIR' And
                      A.Catalog_No != '3DBC-22001091' And
                      ((A.Order_No Not Like 'W%' And
                      A.Order_No Not Like 'X%') Or
                      A.Order_No Is Null) And
                      (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
                      A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
                      A.Order_No != 'C512921' --Kevin Stack's order/return that spanned years.
                 Then A.Allamounts
                 Else 0
            End)/1000) As USSC,
  Round(Sum(Case When A.Region_Code = 'USWC' And
                      A.Corporate_Form = 'DOMDIR' And
                      A.Catalog_No != '3DBC-22001091' And
                      ((A.Order_No Not Like 'W%' And
                      A.Order_No Not Like 'X%') Or
                      A.Order_No Is Null) And
                      (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
                      A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
                      A.Order_No != 'C512921' --Kevin Stack's order/return that spanned years.
                 Then A.Allamounts
                 Else 0
            End)/1000) As USWC,
  Round(Sum(Case When A.Region_Code = 'UNASSIGNED' And
                      A.Corporate_Form = 'DOMDIR' And
                      A.Catalog_No != '3DBC-22001091' And
                      ((A.Order_No Not Like 'W%' And
                      A.Order_No Not Like 'X%') Or
                      A.Order_No Is Null) And
                      (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
                      A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
                      A.Order_No != 'C512921' --Kevin Stack's order/return that spanned years.
                 Then A.Allamounts
                 Else 0
            End)/1000) As Unassigned_Na,
  Round(Sum(Case When A.Region_Code In ('SECA','USEC','USCE','USWC','UNASSIGNED') And
                      A.Corporate_Form = 'DOMDIR' And
                      A.Catalog_No != '3DBC-22001091' And
                      ((A.Order_No Not Like 'W%' And
                      A.Order_No Not Like 'X%') Or
                      A.Order_No Is Null) And
                      (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
                      A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
                      A.Order_No != 'C512921' --Kevin Stack's order/return that spanned years.
                 Then A.Allamounts
                 Else 0
            End)/1000) As Total_Na,
--  Round(Sum(Case When A.Region_Code = 'ASIA'
--                 Then A.Allamounts
--                 Else 0
--            End)/1000) As Asia,
  Round(Sum(Case When A.Region_Code = 'CANA'
                 Then A.Allamounts
                 Else 0
            End)/1000) As Cana,
--  Round(Sum(Case When A.Region_Code = 'EURO'
--                 Then A.Allamounts
--                 Else 0
--            End)/1000) As Euro,
--  Round(Sum(Case When A.Region_Code = 'LATI'
--                 Then A.Allamounts
--                 Else 0
--            End)/1000) As Lati,
  Round(Sum(Case When A.Region_Code = 'USDI'
                 Then A.Allamounts
                 Else 0
            End)/1000) As USDI,
  Round(Sum(Case When A.Region_Code = 'UNASSIGNED' And
                      A.Corporate_Form Not In ('DOMDIR','KEY')
                 Then A.Allamounts
                 Else 0
            End)/1000) As Unassigned_Dist,
  Round(Sum(Case When A.Region_Code In ('CANA','USDI','UNASSIGNED') And
                      A.Corporate_Form Not In ('DOMDIR','KEY')
                 Then A.Allamounts
                 Else 0
            End)/1000) As Total_Dist,  
  Round(Sum(Case When A.Region_Code In ('SECA','USEC','USCE','USWC','UNASSIGNED') And
                      A.Corporate_Form = 'DOMDIR' And
                      A.Catalog_No != '3DBC-22001091' And
                      ((A.Order_No Not Like 'W%' And
                      A.Order_No Not Like 'X%') Or
                      A.Order_No Is Null) And
                      (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
                      A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
                      A.Order_No != 'C512921' --Kevin Stack's order/return that spanned years.
                 Then A.Allamounts
                 Else 0
            End)/1000) + 
  Round(Sum(Case When A.Region_Code In ('UNASSIGNED','CANA','USDI') And
                      A.Corporate_Form Not In  ('KEY','DOMDIR')
                 Then A.Allamounts
                 Else 0
            End)/1000) As Grand_Total
From
  Kd_Sales_Data_Request A
Where
  (Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)-1 Or
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)) And
  A.Charge_Type = 'Parts' And
  A.Corporate_Form != 'KEY'
Group By
  Extract(Year From A.InvoiceDate),
  Extract(Month From A.Invoicedate)
Order By
  Extract(Year from A.InvoiceDate),
  Extract(Month From A.InvoiceDate)