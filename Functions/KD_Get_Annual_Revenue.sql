Create Or Replace Function Kd_Get_Annual_Revenue (V_Customer_Id In Varchar2,V_Year In Number)
    Return Number Is
    V_Revenue Number;
Begin
    Select
        Sum(A.AllAmounts) Into V_Revenue
    From
        Kd_Sales_Data_Request A
    Where
        A.Customer_No = V_Customer_ID And
        A.Charge_Type = 'Parts' And
        A.Catalog_No != '3DBC-22001091' And
      ((A.Order_No Not Like 'W%' And
        A.Order_No Not Like 'X%') Or
        A.Order_No Is Null) And
       (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
        Extract(Year From Invoicedate) = V_Year;
    Return V_Revenue;
End;