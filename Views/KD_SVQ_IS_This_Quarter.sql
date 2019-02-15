Create Or Replace View KD_Svq_IS_This_Quarter As
Select
  A.Commission_Receiver as Salesman_Code,
  Sum(A.Allamounts) As This_Quarter,
  Sum(Case
        When
          A.Part_Product_Code Not In ('LIT','REGEN')
        Then
          A.Allamounts
        Else
          0
      End) As This_Quarter_Implants,
  Sum(Case
        When
          A.Part_Product_Code = 'REGEN'
        Then
          A.Allamounts
        Else
          0
      End) As This_Quarter_Bio,
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      B.QTR1
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      B.QTR2
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      B.QTR3
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      B.QTR4 
  End As Qtr_Quota,
  B.Region
From
  Kd_Sales_Data_Request A Left Join Srrepquotainside B
    On A.Commission_Receiver = B.Region
Where
  A.InvoiceQtr = Case
                   When
                     Extract(Month From Sysdate) In (1,2,3)
                   Then
                     'QTR1'
                   When
                     Extract(Month From Sysdate) In (4,5,6)
                   Then
                     'QTR2'
                   When
                     Extract(Month From Sysdate) In (7,8,9)
                   Then
                     'QTR3'
                   When
                     Extract(Month From Sysdate) In (10,11,12)
                   Then
                     'QTR4' 
                 End And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  A.Catalog_No != '3DBC-22001091' And
((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or
  A.Order_No Is Null) And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
    A.Order_No != 'C512921' --Kevin Stack's order/return that spanned years.
Group By
  A.Commission_Receiver,
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      B.QTR1
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      B.QTR2
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      B.QTR3
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      B.Qtr4 
  End,
  B.Region;