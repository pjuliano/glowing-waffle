Create Or Replace View KD_Svq_QTD As
Select
  A.Salesman_Code,
  A.This_Quarter,
  A.This_Quarter_Implants,
  A.This_Quarter_Bio,
  A.Qtr_Quota,
  A.Qtr_Quota_Impl,
  A.Qtr_Quota_Bio,
  Round((A.This_Quarter / NullIF(Sum(B.Daily_Quota),0)) * 100,2) As Qtd_Quota_Pct,
  Round((A.This_Quarter_Implants / NullIF(Sum(B.Daily_Quota_Impl),0)) * 100,2) As QTD_Quota_Pct_IMPL,
  Round((A.This_Quarter_Bio / NullIF(Sum(B.Daily_Quota_Bio),0)) * 100,2) As QTD_Quota_Pct_Bio,
  Round((A.This_Quarter / NullIF(A.Qtr_Quota,0)) * 100,2) As Quarter_Quota_Pct,
  Round((A.This_Quarter_Implants / NullIF(A.Qtr_Quota_Impl,0)) * 100,2) As Quarter_Quota_Pct_Impl,
  Round((A.This_Quarter_Implants / NullIF(A.Qtr_Quota_Bio,0)) * 100,2) As Quarter_Quota_Pct_Bio,
  A.Qtr_Quota - nvl(A.This_Quarter,0) As Quarter_Remaining,
  A.Qtr_Quota_Impl - nvl(A.This_Quarter_Implants,0) As Quarter_Remaining_Impl,
  A.Qtr_Quota_Bio - nvl(A.This_Quarter_Bio,0) as Quarter_Remaining_Bio
From
  Kd_Svq_This_Quarter A,
  Kd_Daily_Quota_By_Month B
Where
  A.Salesman_Code = B.Salesman_Code And
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
  A.Qtr_Quota_Impl,
  A.Qtr_Quota_Bio,
  Round((A.This_Quarter / Nullif(A.Qtr_Quota,0)) * 100,2),
  A.Qtr_Quota - A.This_Quarter;