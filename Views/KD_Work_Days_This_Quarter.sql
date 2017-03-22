Create Or Replace View KD_Work_Days_This_Quarter As
Select
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      1
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      2
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      3
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      4 
  End As QTR,
  Count(Extract(Month From A.Day)) Total_Days,
  Sum(Case
        When
          A.Weekday In ('Saturday','Sunday')
        Then
          0
        Else
          1
      End) As Weekdays,
  Sum(Case
        When
          A.Holiday Is Not Null
        Then
          1
        Else
          0
      End) As Holidays,
   Sum(Case
        When
          A.Weekday In ('Saturday','Sunday')
        Then
          0
        Else
          1
      End) -
  Sum(Case
        When
          A.Holiday Is Not Null
        Then
          1
        Else
          0
      End) As Total_Sales_Days,
  Sum(Case
        When
          A.Day Between To_Date('01/' ||   Case
                                              When
                                                Extract(Month From Sysdate) In (1,2,3)
                                              Then
                                                1
                                              When
                                                Extract(Month From Sysdate) In (4,5,6)
                                              Then
                                                2
                                              When
                                                Extract(Month From Sysdate) In (7,8,9)
                                              Then
                                                3
                                              When
                                                Extract(Month From Sysdate) In (10,11,12)
                                              Then
                                                4 
                                            End || '/' || Extract(Year From Sysdate),'MM/DD/YYYY') And Trunc(Sysdate) And
          Calendar_Api.Get_Week_Day(A.Day) Not In ('Saturday','Sunday') And
          A.Holiday Is Null
        Then
          1
        Else
          0
      End) - 1 As Elapsed_Work_Days
From
  Kd_Year_Calendar A
Where
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      1
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      2
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      3
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      4 
  End = 
  Case
    When
      Extract(Month From A.Day) In (1,2,3)
    Then
      1
    When
      Extract(Month From A.Day) In (4,5,6)
    Then
      2
    When
      Extract(Month From A.Day) In (7,8,9)
    Then
      3
    When
      Extract(Month From A.Day) In (10,11,12)
    Then
      4 
  End