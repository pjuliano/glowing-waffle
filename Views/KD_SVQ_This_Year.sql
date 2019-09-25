Create Or Replace View KD_SVQ_This_Year As
Select
  b.repnumber AS salesman_code,
  Sum(Case When Extract(Month From InvoiceDate) >= 7 Then A.AllAmounts Else 0 End) As This_Year_Second_Half,
  Sum(A.Allamounts) As This_Year,
  Sum(Case When A.Part_Product_Code Not In ('REGEN','LIT') Then A.AllAmounts Else 0 End) As This_Year_Implants,
  Sum(Case When A.Part_Product_Code = 'REGEN' Then A.AllAmounts Else 0 End) As This_Year_Bio,
  B.Year As Year_Quota,
  B.year_Impl as Year_Quota_Impl,
  B.Year_Bio As Year_Quota_Bio,
  B.Region
From
  Srrepquota B Left Join Kd_Sales_Data_Request A
    On A.Salesman_Code = B.Repnumber And
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
  b.repnumber,
  B.Year,
  B.Year_Impl,
  B.Year_Bio,
  B.Region;