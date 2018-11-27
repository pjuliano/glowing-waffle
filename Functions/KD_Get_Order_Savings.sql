Create Or Replace Function KD_Get_Order_Savings(Order_ID In Varchar2)
    Return Decimal Is Total_Savings Decimal;
    Cursor Sum_Savings Is Select 
                              Sum(CF$_Savings) 
                          From 
                              Customer_Order_Line_Cfv 
                          Where 
                              Order_No = Order_ID And 
                              State != 'CANCELLED'
                          Group by 
                              Order_No;
Begin
    Open Sum_Savings;
    Fetch Sum_Savings Into Total_Savings;
    Return Total_Savings;
End;