Create Or Replace Procedure Kd_Update_Stale_Records_By_Day(P_DaysBack In Number,P_Table In Varchar2) Is
Begin
Execute Immediate 'Truncate Table KD_Stale_Sales_Data_Records';
Dbms_Output.Put_Line('Table truncated.');
Execute Immediate 'Insert Into Kd_Stale_Sales_Data_Records
  (Select * From Kd_Sales_Data_Test A Where A.InvoiceDate >= Trunc(Sysdate) - ' || P_DaysBack || ' Minus 
   Select * From ' || P_Table || ' A Where A.InvoiceDate >= Trunc(Sysdate) - ' || P_DaysBack || ')';
Dbms_Output.Put_Line(To_Char(Sql%Rowcount) || ' stale records inserted to temporary table.');
Execute Immediate 'Delete From ' || P_Table || ' Where Invoice_Id || ''-'' || Item_Id In (Select Invoice_Id || ''-'' || Item_Id From Kd_Stale_Sales_Data_Records)';
Dbms_Output.Put_Line(To_Char(Sql%Rowcount) || ' stale records deleted from ' || P_Table || '.');
Execute Immediate 'Insert Into ' || P_Table || ' KD_Sales_Data_Request (Select * From KD_Stale_Sales_Data_Records)';
Dbms_Output.Put_Line(To_Char(Sql%Rowcount) || ' updated records inserted into ' || P_Table || '.');
End;