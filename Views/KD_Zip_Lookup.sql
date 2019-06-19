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
  Kd_Zip_Data_Us B 
  left Join Kd_Inside_Rep_Assignments C ON
    B.Rep_id = C.Rep_id
  LEFT JOIN Srrepquota D ON
    B.Rep_ID = D.Repnumber