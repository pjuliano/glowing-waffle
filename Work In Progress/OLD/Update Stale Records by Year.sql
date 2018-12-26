Create Or Replace Procedure KD_Update_Stale_Records(P_Year In Number,P_Table In VarChar2) Is
Begin
Execute Immediate 'Truncate Table KD_Stale_Sales_Data_Records';
DBMS_Output.Put_Line('Table truncated.');
Execute Immediate 'Insert Into Kd_Stale_Sales_Data_Records
  (Select * From Kd_Sales_Data_Test A Where Extract(Year From A.Invoicedate) = ' || P_Year || ' Minus 
   Select * From ' || P_Table || ' A Where Extract(Year From A.Invoicedate) = ' || P_Year || ')';
DBMS_Output.Put_Line(To_Char(sql%rowcount) || ' stale records inserted to temporary table.');
Execute Immediate 'Delete From ' || P_Table || ' Where Invoice_Id || ''-'' || Item_Id In (Select Invoice_Id || ''-'' || Item_Id From Kd_Stale_Sales_Data_Records)';
Dbms_Output.Put_Line(To_Char(Sql%Rowcount) || ' stale records deleted from ' || P_Table || '.');
Execute Immediate 'Insert Into ' || P_Table || ' KD_Sales_Data_Request (Select * From KD_Stale_Sales_Data_Records)';
DBMS_Output.Put_Line(To_Char(sql%rowcount) || ' updated records inserted into ' || P_Table || '.');
End;