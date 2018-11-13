Create Or Replace Function KD_Get_SalesQuarter_Day (V_Date In Date)
    Return Number Is
    V_Sales_Day Number;
Begin
    Case When Extract(Year From V_Date) = Extract(Year From Sysdate) 
         Then Select Max(Rownum) Into V_Sales_Day From KD_Sales_Days_Cy Where To_Char(Day,'Q') = To_Char(Sysdate,'Q') And Day <= V_Date;
              Return V_Sales_Day;
         When Extract(Year From V_Date) = Extract(Year From Sysdate)-1
         Then Select Max(Rownum) Into V_Sales_Day From KD_Sales_Days_Py Where To_Char(Day,'Q') = To_Char(Sysdate,'Q') And Day <= V_Date;
              Return V_Sales_Day;
         Else V_Sales_Day := Null;
              Return V_Sales_Day;
    End Case;
End;