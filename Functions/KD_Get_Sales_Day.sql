Create Or Replace Function KD_Get_Sales_Day (V_Date In Date)
    Return Number Is
    V_Sales_Day Number;
Begin
    Case When Extract(Year From V_Date) = Extract(Year From Sysdate) 
         Then Select Sales_Day Into V_Sales_Day From KD_Sales_Days_CY Where v_Date = Day;
              Return V_Sales_Day;
         When Extract(Year From V_Date) = Extract(YEar From Sysdate)-1
         Then Select Sales_Day Into V_Sales_Day From KD_Sales_Days_PY Where v_Date = Day;
              Return V_Sales_Day;
         Else V_Sales_Day := Null;
              Return V_Sales_Day;
    End Case;
End;