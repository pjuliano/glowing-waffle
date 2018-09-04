Create Or Replace View KD_Svq_This_Month As
Select
  A.Salesman_Code,
  Sum(A.Allamounts) As This_Month,
  Sum(Case
        When
          A.Part_Product_Code Not In ('LIT','REGEN')
        Then
          A.Allamounts
        Else
          0
      End) As This_Month_Implants,
  Sum(Case
        When
          A.Part_Product_Code = 'REGEN'
        Then
          A.Allamounts
        Else
          0
      End) As This_Month_Bio,
  Sum(Case
        When
          A.Part_Product_Code != 'LIT' And 
          A.Order_No Not Like 'W%' And
          A.Order_No Not Like 'X%'
        Then
          Round((A.Allamounts - (A.Cost * A.Invoiced_Qty)),2)
      End) As This_Month_Gross_Margin,
  Case
    When
      Extract(Month From Sysdate) = 1
    Then
      B.Jan
    When
      Extract(Month From Sysdate) = 2
    Then
      B.Feb
    When
      Extract(Month From Sysdate) = 3
    Then
      B.Mar
    When
      Extract(Month From Sysdate) = 4
    Then
      B.Apr
    When
      Extract(Month From Sysdate) = 5
    Then
      B.May
    When
      Extract(Month From Sysdate) = 6
    Then
      B.June
    When
      Extract(Month From Sysdate) = 7
    Then
      B.July
    When
      Extract(Month From Sysdate) = 8
    Then
      B.Aug
    When
      Extract(Month From Sysdate) = 9
    Then
      B.Sept
    When
      Extract(Month From Sysdate) = 10
    Then
      B.Oct
    When
      Extract(Month From Sysdate) = 11
    Then
      B.Nov
    When
      Extract(Month From Sysdate) = 12
    Then
      B.Dec
    Else
      0
  End As Month_Quota,
  B.Region
From
  Kd_Sales_Data_Request A Left Join Srrepquota B
    On A.Salesman_Code = B.Repnumber
Where
  Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
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
  Case
    When
      Extract(Month From Sysdate) = 1
    Then
      B.Jan
    When
      Extract(Month From Sysdate) = 2
    Then
      B.Feb
    When
      Extract(Month From Sysdate) = 3
    Then
      B.Mar
    When
      Extract(Month From Sysdate) = 4
    Then
      B.Apr
    When
      Extract(Month From Sysdate) = 5
    Then
      B.May
    When
      Extract(Month From Sysdate) = 6
    Then
      B.June
    When
      Extract(Month From Sysdate) = 7
    Then
      B.July
    When
      Extract(Month From Sysdate) = 8
    Then
      B.Aug
    When
      Extract(Month From Sysdate) = 9
    Then
      B.Sept
    When
      Extract(Month From Sysdate) = 10
    Then
      B.Oct
    When
      Extract(Month From Sysdate) = 11
    Then
      B.Nov
    When
      Extract(Month From Sysdate) = 12
    Then
      B.Dec
    Else
      0
  End,
  B.Region;