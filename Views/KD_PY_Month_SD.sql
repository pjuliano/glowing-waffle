Create Or Replace View KD_PY_Month_SD As
With MaxDay As (
Select
    Max(A.Day) as MaxDay
From
    KD_Sales_Days_Py A
Where
    Extract(Month From A.Day) = Extract(Month From Sysdate) And
    Rownum <= Kd_Get_Salesmonth_Day(Trunc(Sysdate)))
Select
  A.Salesman_Code,
  Sum(A.Allamounts) As PY_This_Month_SD,
  Sum(Case
        When
          A.Part_Product_Code Not In ('LIT','REGEN')
        Then
          A.Allamounts
        Else
          0
      End) As PY_This_Month_Implants_SD,
  Sum(Case
        When
          A.Part_Product_Code = 'REGEN'
        Then
          A.Allamounts
        Else
          0
      End) As PY_This_Month_Bio_SD,
  B.Region
From
  Kd_Sales_Data_Request A Left Join Srrepquota B
    On A.Salesman_Code = B.Repnumber,
  MaxDay C
Where
  A.InvoiceDate <= C.MaxDay And
  Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)-1 And
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
