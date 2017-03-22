Create Or Replace Procedure 
Update_Zip_Us(P_ID    In Kd_Zip_Data_Us.Rep_Id%Type,
              P_Name  In Kd_Zip_Data_Us.Rep_Name%Type,
              P_Email In Kd_Zip_Data_Us.Rep_Email%Type,
              P_Phone In Kd_Zip_Data_Us.Rep_Phone%Type)
Is
Begin
  Update Kd_Zip_Data_Us A Set Rep_Name = P_Name, A.Rep_Email = P_Email, A.Rep_Phone = P_Phone Where A.Rep_Id = P_Id;
  Commit;
End;