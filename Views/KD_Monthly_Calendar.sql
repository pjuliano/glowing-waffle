Create or Replace View KD_Monthly_Calendar AS
With Months As (Select 1 As Month From Dual Union All
                Select 2 As Month From Dual Union All
                Select 3 As Month From Dual Union All
                Select 4 As Month From Dual Union All
                Select 5 As Month From Dual Union All
                Select 6 As Month From Dual Union All
                Select 7 As Month From Dual Union All
                Select 8 As Month From Dual Union All
                Select 9 As Month From Dual Union All
                Select 10 As Month From Dual Union All
                Select 11 As Month From Dual Union All
                Select 12 As Month From Dual)
Select
  A.Month,
  Count(A.Month) As Total_Days,
  Sum(Case
        When
          A.Month = Extract(Month From B.Day) And
          B.Weekday Not In ('Sunday','Saturday')
        Then
          1
      End) As Total_Weekdays,
  Sum(Case
        When
          A.Month = Extract(Month From B.Day) And
          B.Holiday Is Not Null
        Then
          1
        Else
          0
      End) As Total_Holidays,
  Sum(Case
        When
          A.Month = Extract(Month From B.Day) And
          B.Weekday Not In ('Sunday','Saturday') And
          B.Holiday Is Null
        Then
          1
      End) As Total_Sales_Days,
  Case
    When
      A.Month < Extract(Month From Sysdate)
    Then
      Sum(Case
            When
              A.Month = Extract(Month From B.Day) And
              B.Weekday Not In ('Sunday','Saturday') And
              B.Holiday Is Null
            Then
              1
          End)
    When
      A.Month = Extract(Month From Sysdate)
    Then
      Sum(Case
            When
              B.Day <= Trunc(Sysdate) And
              B.Weekday Not In ('Saturday','Sunday') And
              B.Holiday Is Null
            Then
              1
            Else
              0
          End)
    Else
      0
  End As Elapsed_Work_Days
From
  Months A,
  Kd_Year_Calendar B
Where
  A.Month = Extract(Month From B.Day)
Group By
  A.Month
Order By
  A.Month