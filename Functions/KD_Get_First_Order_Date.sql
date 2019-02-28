create or replace Function Kd_Get_First_Order_Date (V_Customer_Id In Varchar2)
    Return Varchar2 Is
    V_First_Order_Date Date;
Begin
    Select First_Order_Date Into V_First_Order_Date From KD_First_Order_Date Where V_Customer_Id = Customer_No;
    Return V_First_Order_Date;
End;