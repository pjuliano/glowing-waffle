Create Or Replace Function Kd_Get_Corporate_Form (V_Customer_Id In Varchar2)
    Return Varchar2 Is
    V_Corp_Form Varchar2(200);
Begin
    Select Corporate_Form Into V_Corp_Form From Customer_Info Where V_Customer_Id = Customer_Id;
    Return V_Corp_Form;
End;