Truncate Table Srrepquota;

Insert Into Srrepquota
Select
  A.Territory_Number,
  A.Rep_Name,
  Sum(A.Jan),
  Sum(A.Feb),
  Sum(A.Mar),
  Sum(A.Apr),
  Sum(A.May),
  Sum(A.Jun),
  Sum(A.Jul),
  Sum(A.Aug),
  Sum(A.Sep),
  Sum(A.Oct),
  Sum(A.Nov),
  Sum(A.Dec),
  Sum(A.Jan) + Sum(A.Feb) + Sum(A.Mar),
  Sum(A.Apr) + Sum(A.May) + Sum(A.Jun),
  Sum(A.Jul) + Sum(A.Aug) + Sum(A.Sep),
  Sum(A.Oct) + Sum(A.Nov) + Sum(A.Dec),
  A.Region,
  Case When A.Region = 'SECA' Then 'Cheryl Coss'
       When A.Region = 'USCE' Then 'Chris Johnson'
       When A.Region = 'USEC' Then 'Christian Villarroel'
       When A.Region = 'USWC' Then 'Dustin Fanucchi'
       Else 'UNASSIGNED'
  End As Rm,
  Sum(A.Jan) + Sum(A.Feb) + Sum(A.Mar) + Sum(A.Apr) + Sum(A.May) + Sum(A.Jun) + Sum(A.Jul) + Sum(A.Aug) + Sum(A.Sep) + Sum(A.Oct) + Sum(A.Nov) + Sum(A.Dec)
From
  Kd_Quotas_NADIRECT A
Group By
  A.Territory_Number,
  A.Rep_Name,
  A.Region,
  Case When A.Region = 'SECA' Then 'Cheryl Coss'
       When A.Region = 'USCE' Then 'Chris Johnson'
       When A.Region = 'USEC' Then 'Christian Villarroel'
       When A.Region = 'USWC' Then 'Dustin Fanucchi'
       Else 'UNASSIGNED'
  End 
Order By A.Territory_Number