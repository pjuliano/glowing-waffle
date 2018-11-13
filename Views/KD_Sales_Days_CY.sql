Create OR Replace View KD_Sales_Days_CY As
With Days_Of_Year As (
    Select
        To_Date('01/01/' || (Extract(Year From Sysdate)),'MM/DD/YYYY') + Rownum - 1 As Day,
        Calendar_Api.Get_Week_Day(To_Date('01/01/' || (Extract(Year From Sysdate)),'MM/DD/YYYY') + Rownum - 1) As Weekday
    From
        All_Objects
    Where
        Rownum <= To_Date('12/31/' || Extract(Year From Sysdate),'MM/DD/YYYY') - To_Date('01/01/' || Extract(Year From Sysdate),'MM/DD/YYYY') + 1)
Select
    A.Day,
    A.Weekday,
    --B.Day As Holiday,
    Rownum As Sales_Day
From
    Days_Of_Year A Left Join Kd_Sales_Holidays B On A.Day = Trunc(B.Day)
Where
    A.Weekday Not In ('Saturday','Sunday') And
    B.Day Is Null