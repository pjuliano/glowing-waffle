Create Or Replace Function Kd_Amount_Due(Cust_Id In Varchar2)
    Return Number Is Amt_Due Number;
    Cursor C1 Is Select Amount_Due From Identity_Pay_Info_CU_Qry Where Identity = Cust_ID;
Begin
    Open C1;
    Fetch C1 Into Amt_Due;
    Return Amt_Due;
End;