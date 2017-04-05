Create Or Replace Procedure KD_TAB_DIFF Is
Begin
    Execute Immediate 'Truncate Table Kd_Unmatched_Records_Temp';
    Commit;
    Execute Immediate 'Insert Into Kd_Unmatched_Records_Temp (Select * From KD_Sales_Data Minus Select * From KD_Sales_Data_Nightly)';
    Commit;
    Execute Immediate 'Delete From Kd_Sales_Data_Nightly A Where A.Invoice_Id || ''-'' || A.Item_Id In (Select B.Invoice_Id || ''-'' || B.Item_Id From Kd_Unmatched_Records_Temp B)';
    Commit;
    Execute Immediate 'Insert Into Kd_Sales_Data_Nightly Select * From Kd_Unmatched_Records_Temp';
    Commit;
End KD_TAB_DIFF;
