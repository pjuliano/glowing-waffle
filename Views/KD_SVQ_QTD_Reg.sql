Create Or Replace View Kd_Svq_Qtd_Reg As
Select
  A.Region,
  A.This_Quarter,
  Round((A.This_Quarter / Sum(B.Daily_Quota)) * 100,2) As Qtd_Quota_Pct_Reg,
  Round((A.This_Quarter / A.Qtr_Quota) * 100,2) As Quarter_Quota_Pct_Reg,
  Round(A.PY_QTD_SD,2) As PY_QTD_SD_REG
From
  Kd_Svq_This_Quarter_Reg A,
  Kd_Daily_Quota_By_Month B
Where
  A.Region = B.Region And
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
  A.Region,
  A.This_Quarter,
  Round((A.This_Quarter / A.Qtr_Quota) * 100,2),
  Round(A.PY_QTD_SD,2);