Create Or Replace View KD_Quarterly_Calendar As
Select
  Case When A.Month In (1,2,3)
       Then 'QTR1'
       When A.Month In (4,5,6)
       Then 'QTR2'
       When A.Month In (7,8,9)
       Then 'QTR3'
       When A.Month In (10,11,12)
       Then 'QTR4'
  End As Quarter,
  Sum(A.Total_Days) As Total_Days,
  Sum(A.Total_Weekdays) As Total_Weekdays,
  Sum(A.Total_Holidays) As Total_Holidays,
  Sum(A.Total_Sales_Days) As Total_Sales_Days,
  Sum(A.Elapsed_Work_Days) As Elapsed_Work_Days
From
  Kd_Monthly_Calendar A
Group By
  Case When A.Month In (1,2,3)
       Then 'QTR1'
       When A.Month In (4,5,6)
       Then 'QTR2'
       When A.Month In (7,8,9)
       Then 'QTR3'
       When A.Month In (10,11,12)
       Then 'QTR4'
  End