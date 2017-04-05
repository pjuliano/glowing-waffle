Create Or Replace View KD_Svq_This_Quarter As
Select
  A.Salesman_Code,
  Sum(A.Allamounts) As This_Quarter,
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
  Kd_Sales_Data_Request A Left Join Srrepquota B
    On A.Salesman_Code = B.Repnumber
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
((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or
  A.Order_No Is Null) And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null)
Group By
  A.Salesman_Code,
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