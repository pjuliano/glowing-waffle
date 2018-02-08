Create Or Replace View KD_Svq_IS_This_Month As
Select
  A.Commission_Receiver As Salesman_Code,
  Sum(A.Allamounts) As This_Month,
  Sum(Case
        When
          A.Part_Product_Family In ('COMM','GNSIS','PRIMA','RENOV','RESTO','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED','PRMA+','TLMAX','PCOMM')
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
  Kd_Sales_Data_Request A Left Join Srrepquotainside B
    On A.Commission_Receiver = B.Region
Where
  Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  ((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or
  A.Order_No Is Null) And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null)
Group By
  A.Commission_Receiver,
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