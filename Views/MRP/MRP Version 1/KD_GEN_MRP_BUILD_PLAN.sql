--------------------------------------------------------
--  DDL for Procedure KD_GEN_MRP_BUILD_PLAN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFSAPP"."KD_GEN_MRP_BUILD_PLAN" Is
SQL_Query Clob;
Begin
    SQL_Query :=
        'Create Table KD_MRP_Build_Plan As
            Select
                RM_Part_No,
                Inventory_Part_Api.Get_Description(''100'',RM_Part_No) As RM_Part_Desc,
                Case When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Sysdate) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Sysdate)
                     Then Avg_Monthly_Sales_FG1S + Avg_Monthly_Sales_FG1S
                     When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Sysdate) And
                          Required_Date_FG2S Not Between Trunc(Sysdate,''Month'') And Last_Day(Sysdate)
                     Then Avg_Monthly_Sales_FG1S
                     When Required_Date_FG1S Not Between Trunc(Sysdate,''Month'') And Last_Day(Sysdate) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Sysdate)
                     Then Avg_Monthly_Sales_FG2S
                End As "' || To_Char(Sysdate,'MM-YYYY') || '",
                Case When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,1)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,1))
                     Then Avg_Monthly_Sales_FG1S  + Avg_Monthly_Sales_FG2S
                     When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,1)) And
                          Required_Date_FG2S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,1))
                     Then Avg_Monthly_Sales_FG1S
                     When Required_Date_FG1S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,1)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,1))
                     Then Avg_Monthly_Sales_FG2S
                End As "' || To_Char(Add_Months(Sysdate,1),'MM-YYYY') || '",
                Case When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,2)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,2))
                     Then Avg_Monthly_Sales_FG1S  + Avg_Monthly_Sales_FG2S
                     When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,2)) And
                          Required_Date_FG2S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,2))
                     Then Avg_Monthly_Sales_FG1S
                     When Required_Date_FG1S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,2)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,2))
                     Then Avg_Monthly_Sales_FG2S
                End As "' || To_Char(Add_Months(Sysdate,2),'MM-YYYY') || '",
                Case When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,3)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,3))
                     Then Avg_Monthly_Sales_FG1S  + Avg_Monthly_Sales_FG2S
                     When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,3)) And
                          Required_Date_FG2S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,3))
                     Then Avg_Monthly_Sales_FG1S
                     When Required_Date_FG1S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,3)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,3))
                     Then Avg_Monthly_Sales_FG2S
                End As "' || To_Char(Add_Months(Sysdate,3),'MM-YYYY') || '",
                Case When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,4)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,4))
                     Then Avg_Monthly_Sales_FG1S  + Avg_Monthly_Sales_FG2S
                     When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,4)) And
                          Required_Date_FG2S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,4))
                     Then Avg_Monthly_Sales_FG1S
                     When Required_Date_FG1S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,4)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,4))
                     Then Avg_Monthly_Sales_FG2S
                End As "' || To_Char(Add_Months(Sysdate,4),'MM-YYYY') || '",
                Case When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,5)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,5))
                     Then Avg_Monthly_Sales_FG1S  + Avg_Monthly_Sales_FG2S
                     When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,5)) And
                          Required_Date_FG2S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,5))
                     Then Avg_Monthly_Sales_FG1S
                     When Required_Date_FG1S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,5)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,5))
                     Then Avg_Monthly_Sales_FG2S
                End As "' || To_Char(Add_Months(Sysdate,5),'MM-YYYY') || '",
                Case When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,6)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,6))
                     Then Avg_Monthly_Sales_FG1S  + Avg_Monthly_Sales_FG2S
                     When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,6)) And
                          Required_Date_FG2S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,6))
                     Then Avg_Monthly_Sales_FG1S
                     When Required_Date_FG1S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,6)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,6))
                     Then Avg_Monthly_Sales_FG2S
                End As "' || To_Char(Add_Months(Sysdate,6),'MM-YYYY') || '",
                Case When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,7)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,7))
                     Then Avg_Monthly_Sales_FG1S  + Avg_Monthly_Sales_FG2S
                     When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,7)) And
                          Required_Date_FG2S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,7))
                     Then Avg_Monthly_Sales_FG1S
                     When Required_Date_FG1S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,7)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,7))
                     Then Avg_Monthly_Sales_FG2S
                End As "' || To_Char(Add_Months(Sysdate,7),'MM-YYYY') || '",
                Case When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,8)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,8))
                     Then Avg_Monthly_Sales_FG1S  + Avg_Monthly_Sales_FG2S
                     When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,8)) And
                          Required_Date_FG2S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,8))
                     Then Avg_Monthly_Sales_FG1S
                     When Required_Date_FG1S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,8)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,8))
                     Then Avg_Monthly_Sales_FG2S
                End As "' || To_Char(Add_Months(Sysdate,8),'MM-YYYY') || '",
                Case When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,9)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,9))
                     Then Avg_Monthly_Sales_FG1S  + Avg_Monthly_Sales_FG2S
                     When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,9)) And
                          Required_Date_FG2S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,9))
                     Then Avg_Monthly_Sales_FG1S
                     When Required_Date_FG1S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,9)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,9))
                     Then Avg_Monthly_Sales_FG2S
                End As "' || To_Char(Add_Months(Sysdate,9),'MM-YYYY') || '",
                Case When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,10)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,10))
                     Then Avg_Monthly_Sales_FG1S  + Avg_Monthly_Sales_FG2S
                     When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,10)) And
                          Required_Date_FG2S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,10))
                     Then Avg_Monthly_Sales_FG1S
                     When Required_Date_FG1S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,10)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,10))
                     Then Avg_Monthly_Sales_FG2S
                End As "' || To_Char(Add_Months(Sysdate,10),'MM-YYYY') || '",
                Case When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,11)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,11))
                     Then Avg_Monthly_Sales_FG1S  + Avg_Monthly_Sales_FG2S
                     When Required_Date_FG1S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,11)) And
                          Required_Date_FG2S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,11))
                     Then Avg_Monthly_Sales_FG1S
                     When Required_Date_FG1S Not Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,11)) And
                          Required_Date_FG2S Between Trunc(Sysdate,''Month'') And Last_Day(Add_Months(Sysdate,11))
                     Then Avg_Monthly_Sales_FG2S
                End As "' || To_Char(Add_Months(Sysdate,11),'MM-YYYY') || '",
                FG_Part_No_FG1,
                Replace(Inventory_Part_Api.Get_Description(''100'',FG_Part_No_FG1),'','','''') As FG1_Part_Desc,
                Avg_Monthly_Sales_FG1S,
                Months_On_Hand_FG1S,
                Required_Date_FG1S,
                Avg_Monthly_Forecast_FG1F,
                Months_On_Hand_FG1F,
                Required_Date_FG1F,
                FG_Part_No_FG2,
                Inventory_Part_Api.Get_Description(''100'',FG_Part_No_FG2) As FG2_Part_Desc,
                Avg_Monthly_Sales_Fg2s,
                Months_On_Hand_FG2S,
                Required_Date_FG2S,
                Avg_Monthly_Forecast_FG2F,
                Months_On_Hand_FG2F,
                Required_Date_FG2F
            From
                KD_MRP';
    --DBMS_OUTPUT.put_line(Sql_Query);
    Execute Immediate 'Drop Table KD_MRP_Build_Plan';
    Execute Immediate Sql_Query;
End;

/
