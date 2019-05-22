Create Or Replace View KD_SVQ_IS_This_Year As
Select
  A.Commission_Receiver As Salesman_Code,
  Sum(Case When Extract(Month From InvoiceDate) >= 7 Then A.AllAmounts Else 0 End) As This_Year_Second_Half,
  Sum(A.Allamounts) As This_Year,
  B.Year As Year_Quota,
  B.Region
From
  Kd_Sales_Data_Request A Left Join SrrepquotaInside B
    On A.Commission_Receiver = B.Region
Where
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  A.Catalog_No != '3DBC-22001091' And
((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or
  A.Order_No Is Null) And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
    (A.Order_No != 'C512921' Or A.Order_No Is Null) --Kevin Stack's order/return that spanned years.
Group By
  A.Commission_Receiver,
  B.Year,
  B.Region;