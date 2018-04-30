Create Or Replace View KD_Zip_Lookup As
Select
  B.*,
  D.Region,
  C.Is_Rep_Id,
  C.IS_Rep_Name,
  A.LOCNAMECITY AS CITY,
  A.LOCNAMESTATE AS STATE,
  A.LOCNAMECOUNTY AS COUNTY,
  A.LOCZIPCODESTART AS ZIP_START,
  A.LOCZIPCODEEND AS ZIP_END
From
  Geocodeci A,
  Kd_Zip_Data_Us B,
  Kd_Inside_Rep_Assignments C,
  Srrepquota D
Where
  B.Rep_Id = C.Rep_Id And
  B.Rep_Id = D.Repnumber;