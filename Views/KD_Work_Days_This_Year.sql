Create Or Replace View KD_Work_Days_This_Year As
Select
  Extract(Year From Sysdate) As Year,
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
          A.Day >= To_Date('01/01/' || Extract(Year From Sysdate),'MM/DD/YYYY') And 
          A.Day <= Trunc(Sysdate) And
          Calendar_Api.Get_Week_Day(A.Day) Not In ('Saturday','Sunday') And
          A.Holiday Is Null
        Then
          1
        Else
          0
      End) - 1 As Elapsed_Work_Days
From
  Kd_Year_Calendar A