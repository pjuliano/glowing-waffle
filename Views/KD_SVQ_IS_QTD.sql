Create Or Replace View KD_Svq_IS_QTD As
Select
  A.Salesman_Code,
  A.This_Quarter,
  A.This_Quarter_Implants,
  A.This_Quarter_Bio,
  A.Qtr_Quota,
  Round((A.This_Quarter  /Sum(B.Daily_Quota)) * 100,2) As Qtd_Quota_Pct,
  Round((A.This_Quarter / A.Qtr_Quota) * 100,2) As Quarter_Quota_Pct,
  A.Qtr_Quota - A.This_Quarter As Quarter_Remaining
From
  Kd_Svq_IS_This_Quarter A,
  Kd_Daily_Quota_By_Month_IS B
Where
  A.Salesman_Code = B.Region And
  B.Qtr = Case
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
              Extract(Month From Sysdate) IN (10,11,12)
            Then
              'QTR4'
          End
Group By
  A.Salesman_Code,
  A.Region,
  A.This_Quarter,
  A.This_Quarter_Implants,
  A.This_Quarter_Bio,
  A.Qtr_Quota,
  Round((A.This_Quarter / A.Qtr_Quota) * 100,2),
  A.Qtr_Quota - A.This_Quarter;