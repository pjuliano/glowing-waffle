Create Or Replace View KD_Weekday_Avg_Vs_Target_Cy As
Select
  A.Salesman_Code,
  Round(B.Year/C.Total_Sales_Days,2) As Daily_Target,
  Round(A.Monday,2) As Monday,
  Round(A.Tuesday,2) As Tuesday,
  Round(A.Wednesday,2) As Wednesday,
  Round(A.Thursday,2) As Thursday,
  Round(A.Friday,2) As Friday
From
  Kd_Weekday_Avg_Cy A,
  Srrepquota B,
  Kd_Work_Days_This_Year C
Where
  A.Salesman_Code = B.Repnumber