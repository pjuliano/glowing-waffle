Create Or Replace Function KD_Get_SalesMonth_Day (V_Date In Date)
    Return Number Is
    V_Sales_Day Number;
Begin
    Case When Extract(Year From V_Date) = Extract(Year From Sysdate)
         Then Select Max(Rownum) Into V_Sales_Day From KD_Sales_Days_Cy Where Extract(Month From Day) = Extract(Month From V_Date) and Day <= Trunc(V_Date);
              Return V_Sales_Day;
         When Extract(Year From V_Date) = Extract(Year From Sysdate)-1
         Then Select Max(Rownum) Into V_Sales_Day From KD_Sales_Days_Py Where Extract(Month From Day) = Extract(Month From V_Date) and Day <= Trunc(V_Date);
              Return V_Sales_Day;
         Else V_Sales_Day := Null;
              Return V_Sales_Day;
    End Case;
End;