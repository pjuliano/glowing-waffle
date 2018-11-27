Create Or Replace View KD_PY_Qtr_SD As
With MaxDay As (
    Select 
        Max(A.Day) As MaxDay
    From
        KD_Sales_Days_PY A
    Where
        To_Char(A.Day,'Q') = To_Char(Sysdate,'Q') And
        Rownum <= KD_Get_SalesQuarter_Day(Trunc(Sysdate)))
Select
  A.Salesman_Code,
  Sum(A.Allamounts) As PY_This_Quarter_SD,
  Sum(Case
        When
          A.Part_Product_Code Not In ('LIT','REGEN')
        Then
          A.Allamounts
        Else
          0
      End) As PY_This_Quarter_Implants_SD,
  Sum(Case
        When
          A.Part_Product_Code = 'REGEN'
        Then
          A.Allamounts
        Else
          0
      End) As PY_This_Quarter_Bio_SD,
  B.Region
From
  Kd_Sales_Data_Request A Left Join Srrepquota B
    On A.Salesman_Code = B.Repnumber,
  MaxDay C
Where
  A.InvoiceDate <= C.MaxDay And
  To_Char(A.InvoiceDate,'Q') = To_Char(Sysdate,'Q') And
  Extract(YEar From A.InvoiceDate) = Extract(Year From Sysdate)-1 And
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  A.Catalog_No != '3DBC-22001091' And
((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or
  A.Order_No Is Null) And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
  A.Invoice_ID != 'CR1001802096' --20180904 Invoice is stuck not posted and cannot be deleted.
Group By
  A.Salesman_Code,
  B.Region;