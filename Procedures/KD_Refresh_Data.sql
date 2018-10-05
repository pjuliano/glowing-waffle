create or replace Procedure Kd_Refresh_Data (V_Corporate_Form In Varchar2,V_Year In Number) Is
Begin
    Execute Immediate 'Delete From KD_Sales_Data_Request Where Extract(Year From InvoiceDate) = ' || V_Year || ' And Corporate_Form = ' || CHR(39) || V_Corporate_Form || CHR(39);
    Dbms_Output.Put_Line(To_Char(sql%rowcount) || ' records deleted.');
    Commit;
    Execute Immediate 'Insert Into KD_Sales_Data_Request Select * From KD_Sales_Data Where Extract(Year From InvoiceDate) = ' || V_Year || ' And Corporate_Form = ' || CHR(39) || V_Corporate_Form || CHR(39);
    Dbms_Output.Put_Line(To_Char(sql%rowcount) || ' records inserted.');
    Commit;
End;