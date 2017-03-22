Select
  A.Rep_Id,
  A.Rep_Name,
  A."JAN-BIO" + A."JAN-IMPL" As Jan,
  A."FEB-BIO" + A."FEB-IMPL" As Feb,
  A."MAR-BIO" + A."MAR-IMPL" As Mar,
  A."APR-BIO" + A."APR-IMPL" As Apr,
  A."MAY-BIO" + A."MAY-IMPL" As May,
  A."JUNE-BIO" + A."JUNE-IMPL" As Jun,
  A."JULY-BIO" + A."JULY-IMPL" As Jul,
  A."AUG-BIO" + A."AUG-IMPL" As Aug,
  A."SEPT-BIO" + A."SEPT-IMPL" As Sep,
  A."OCT-BIO" + A."OCT-IMPL" As Oct,
  A."NOV-BIO" + A."NOV-IMPL" As Nov,
  A."DEC-BIO" + A."DEC-IMPL" As Dec,
  A."JAN-BIO" + A."JAN-IMPL" + A."FEB-BIO" + A."FEB-IMPL" + A."MAR-BIO" + A."MAR-IMPL" As Q1,
  A."APR-BIO" + A."APR-IMPL" + A."MAY-BIO" + A."MAY-IMPL" + A."JUNE-BIO" + A."JUNE-IMPL" As Q2,
  A."JULY-BIO" + A."JULY-IMPL" + A."AUG-BIO" + A."AUG-IMPL" + A."SEPT-BIO" + A."SEPT-IMPL" As Q3,
  A."OCT-BIO" + A."OCT-IMPL" + A."NOV-BIO" + A."NOV-IMPL" + A."DEC-BIO" + A."DEC-IMPL" As Q4,
  B.Region,
  B.Regionmgr,
  A."JAN-BIO" + A."JAN-IMPL" + A."FEB-BIO" + A."FEB-IMPL" + A."MAR-BIO" + A."MAR-IMPL" + A."APR-BIO" + A."APR-IMPL" + A."MAY-BIO" + A."MAY-IMPL" + A."JUNE-BIO" + A."JUNE-IMPL" + A."JULY-BIO" + A."JULY-IMPL" + A."AUG-BIO" + A."AUG-IMPL" + A."SEPT-BIO" + A."SEPT-IMPL" + A."OCT-BIO" + A."OCT-IMPL" + A."NOV-BIO" + A."NOV-IMPL" + A."DEC-BIO" + A."DEC-IMPL" As Year
From
  Kd_Quota_By_Group A Left Join Srrepquota B
    On A.Rep_Id = B.Repnumber;
    
Select
  A.Rep_Id,
  A.Rep_Name,
  A."JAN-BIO" + A."JAN-IMPL" As Jan,
  A."FEB-BIO" + A."FEB-IMPL" As Feb,
  A."MAR-BIO" + A."MAR-IMPL" As Mar,
  A."APR-BIO" + A."APR-IMPL" As Apr,
  A."MAY-BIO" + A."MAY-IMPL" As May,
  A."JUNE-BIO" + A."JUNE-IMPL" As Jun,
  A."JULY-BIO" + A."JULY-IMPL" As Jul,
  A."AUG-BIO" + A."AUG-IMPL" As Aug,
  A."SEPT-BIO" + A."SEPT-IMPL" As Sep,
  A."OCT-BIO" + A."OCT-IMPL" As Oct,
  A."NOV-BIO" + A."NOV-IMPL" As Nov,
  A."DEC-BIO" + A."DEC-IMPL" As Dec,
  A."JAN-BIO" + A."JAN-IMPL" + A."FEB-BIO" + A."FEB-IMPL" + A."MAR-BIO" + A."MAR-IMPL" As Q1,
  A."APR-BIO" + A."APR-IMPL" + A."MAY-BIO" + A."MAY-IMPL" + A."JUNE-BIO" + A."JUNE-IMPL" As Q2,
  A."JULY-BIO" + A."JULY-IMPL" + A."AUG-BIO" + A."AUG-IMPL" + A."SEPT-BIO" + A."SEPT-IMPL" As Q3,
  A."OCT-BIO" + A."OCT-IMPL" + A."NOV-BIO" + A."NOV-IMPL" + A."DEC-BIO" + A."DEC-IMPL" As Q4,
  A."JAN-BIO" + A."JAN-IMPL" + A."FEB-BIO" + A."FEB-IMPL" + A."MAR-BIO" + A."MAR-IMPL" + A."APR-BIO" + A."APR-IMPL" + A."MAY-BIO" + A."MAY-IMPL" + A."JUNE-BIO" + A."JUNE-IMPL" + A."JULY-BIO" + A."JULY-IMPL" + A."AUG-BIO" + A."AUG-IMPL" + A."SEPT-BIO" + A."SEPT-IMPL" + A."OCT-BIO" + A."OCT-IMPL" + A."NOV-BIO" + A."NOV-IMPL" + A."DEC-BIO" + A."DEC-IMPL" As Year
From
  Kd_Quota_By_Group_Inside A;