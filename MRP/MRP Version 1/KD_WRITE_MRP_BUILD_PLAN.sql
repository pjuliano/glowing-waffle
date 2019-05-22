--------------------------------------------------------
--  DDL for Procedure KD_WRITE_MRP_BUILD_PLAN
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "IFSAPP"."KD_WRITE_MRP_BUILD_PLAN" Is
    File_Handle Utl_File.File_Type;
    Header_v Clob;
Begin
    File_Handle := Utl_File.Fopen('MRP','buildplan_' || To_Char(Sysdate,'MM.DD.YYYY.HH24.MI.SS') || '.csv','w',32767);
    Header_v := 'RM_Part_No,RM_Part_Desc,' || To_Char(Sysdate,'MM-YYYY') || ',' 
                                           || To_Char(Add_Months(Sysdate,1),'MM-YYYY') || ',' 
                                           || To_Char(Add_Months(Sysdate,2),'MM-YYYY') || ',' 
                                           || To_Char(Add_Months(Sysdate,3),'MM-YYYY') || ',' 
                                           || To_Char(Add_Months(Sysdate,4),'MM-YYYY') || ',' 
                                           || To_Char(Add_Months(Sysdate,5),'MM-YYYY') || ','
                                           || To_Char(Add_Months(Sysdate,6),'MM-YYYY') || ','
                                           || To_Char(Add_Months(Sysdate,7),'MM-YYYY') || ','
                                           || To_Char(Add_Months(Sysdate,8),'MM-YYYY') || ','
                                           || To_Char(Add_Months(Sysdate,9),'MM-YYYY') || ','
                                           || To_Char(Add_Months(Sysdate,10),'MM-YYYY') || ','
                                           || To_Char(Add_Months(Sysdate,11),'MM-YYYY') || ',FG_Part_No_FG1,FG1_Part_Desc,FG1_Part_Product_Code,FG1_Part_Product_Family,Avg_Monthly_Sales_FG1S,Months_On_Hand_FG1S,Required_Date_FG1S,Avg_Monthly_Forecast_FG1F,Months_On_Hand_FG1F,Required_Date_FG1F,FG_Part_No_FG2,FG2_Part_Desc,FG2_Part_Product_Code,FG2_Part_Product_Family,Avg_Monthly_Sales_FG2S,Months_On_Hand_FG2S,Required_Date_FG2S,Avg_Monthly_Forecast_FG2F,Months_On_Hand_FG2F,Required_Date_FG2F';
    Utl_File.Put_Line(File_Handle,Header_v);
    For MRP In (      
                    Select
                        RM_Part_No,
                        Inventory_Part_Api.Get_Description('100',RM_Part_No) As RM_Part_Desc,
                        Case When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Sysdate) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Sysdate) Or Required_Date_FG2S Is Null)
                             Then Nvl(Avg_Monthly_Sales_FG1S,0) + Nvl(Avg_Monthly_Sales_FG2S,0)
                             When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Sysdate) And
                                  (Required_Date_FG2S Not Between Trunc(Sysdate,'Month') And Last_Day(Sysdate) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG1S
                             When Required_Date_FG1S Not Between Trunc(Sysdate,'Month') And Last_Day(Sysdate) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Sysdate) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG2S
                        End As M0,
                        Case When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,1)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,1)) Or Required_Date_FG2S Is Null)
                             Then Nvl(Avg_Monthly_Sales_FG1S,0)  + Nvl(Avg_Monthly_Sales_FG2S,0)
                             When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,1)) And
                                  (Required_Date_FG2S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,1)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG1S
                             When Required_Date_FG1S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,1)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,1)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG2S
                        End As M1,
                        Case When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,2)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,2))Or Required_Date_FG2S Is Null)
                             Then Nvl(Avg_Monthly_Sales_FG1S,0)  + Nvl(Avg_Monthly_Sales_FG2S,0)
                             When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,2)) And
                                  (Required_Date_FG2S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,2)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG1S
                             When Required_Date_FG1S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,2)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,2)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG2S
                        End As M2,
                        Case When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,3)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,3))Or Required_Date_FG2S Is Null)
                             Then Nvl(Avg_Monthly_Sales_FG1S,0)  + Nvl(Avg_Monthly_Sales_FG2S,0)
                             When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,3)) And
                                  (Required_Date_FG2S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,3))Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG1S
                             When Required_Date_FG1S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,3)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,3)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG2S
                        End As M3,
                        Case When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,4)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,4)) Or Required_Date_FG2S Is Null)
                             Then Nvl(Avg_Monthly_Sales_FG1S,0)  + Nvl(Avg_Monthly_Sales_FG2S,0)
                             When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,4)) And
                                  (Required_Date_FG2S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,4)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG1S
                             When Required_Date_FG1S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,4)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,4)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG2S
                        End As M4,
                        Case When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,5)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,5)) Or Required_Date_FG2S Is Null)
                             Then Nvl(Avg_Monthly_Sales_FG1S,0)  + Nvl(Avg_Monthly_Sales_FG2S,0)
                             When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,5)) And
                                  (Required_Date_FG2S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,5)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG1S
                             When Required_Date_FG1S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,5)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,5)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG2S
                        End As M5,
                        Case When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,6)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,6)) Or Required_Date_FG2S Is Null)
                             Then Nvl(Avg_Monthly_Sales_FG1S,0)  + Nvl(Avg_Monthly_Sales_FG2S,0)
                             When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,6)) And
                                  (Required_Date_FG2S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,6)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG1S
                             When Required_Date_FG1S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,6)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,6)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG2S
                        End As M6,
                        Case When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,7)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,7)) Or Required_Date_FG2S Is Null)
                             Then Nvl(Avg_Monthly_Sales_FG1S,0)  + Nvl(Avg_Monthly_Sales_FG2S,0)
                             When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,7)) And
                                  (Required_Date_FG2S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,7)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG1S
                             When Required_Date_FG1S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,7)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,7)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG2S
                        End As M7,
                        Case When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,8)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,8)) Or Required_Date_FG2S Is Null)
                             Then Nvl(Avg_Monthly_Sales_FG1S,0)  + Nvl(Avg_Monthly_Sales_FG2S,0)
                             When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,8)) And
                                  (Required_Date_FG2S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,8)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG1S
                             When Required_Date_FG1S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,8)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,8)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG2S
                        End As M8,
                        Case When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,9)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,9)) Or Required_Date_FG2S Is Null)
                             Then Nvl(Avg_Monthly_Sales_FG1S,0)  + Nvl(Avg_Monthly_Sales_FG2S,0)
                             When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,9)) And
                                  (Required_Date_FG2S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,9)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG1S
                             When Required_Date_FG1S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,9)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,9)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG2S
                        End As M9,
                        Case When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,10)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,10)) Or Required_Date_FG2S Is Null)
                             Then Nvl(Avg_Monthly_Sales_FG1S,0)  + Nvl(Avg_Monthly_Sales_FG2S,0)
                             When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,10)) And
                                  (Required_Date_FG2S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,10)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG1S
                             When Required_Date_FG1S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,10)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,10)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG2S
                        End As M10,
                        Case When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,11)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,11)) Or Required_Date_FG2S Is Null)
                             Then Nvl(Avg_Monthly_Sales_FG1S,0)  + Nvl(Avg_Monthly_Sales_FG2S,0)
                             When Required_Date_FG1S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,11)) And
                                  (Required_Date_FG2S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,11)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG1S
                             When Required_Date_FG1S Not Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,11)) And
                                  (Required_Date_FG2S Between Trunc(Sysdate,'Month') And Last_Day(Add_Months(Sysdate,11)) Or Required_Date_FG2S Is Null)
                             Then Avg_Monthly_Sales_FG2S
                        End As M11,
                        FG_Part_No_FG1,
                        Inventory_Part_Api.Get_Description('100',FG_Part_No_FG1) As FG1_Part_Desc,
                        Inventory_Part_Api.Get_Part_Product_Code('100',FG_Part_No_FG1) As FG1_Part_Product_Code,
                        Inventory_Part_Api.Get_Part_Product_Family('100',FG_Part_No_FG1) As FG1_Part_Product_Family,
                        Avg_Monthly_Sales_FG1S,
                        Months_On_Hand_FG1S,
                        Required_Date_FG1S,
                        Avg_Monthly_Forecast_FG1F,
                        Months_On_Hand_FG1F,
                        Required_Date_FG1F,
                        FG_Part_No_FG2,
                        Inventory_Part_Api.Get_Description('100',FG_Part_No_FG2) As FG2_Part_Desc,
                        Inventory_Part_Api.Get_Part_Product_Code('100',FG_Part_No_FG2) As FG2_Part_Product_Code,
                        Inventory_Part_Api.Get_Part_Product_Family('100',FG_Part_No_FG2) As FG2_Part_Product_Family,
                        Avg_Monthly_Sales_Fg2s,
                        Months_On_Hand_FG2S,
                        Required_Date_FG2S,
                        Avg_Monthly_Forecast_FG2F,
                        Months_On_Hand_FG2F,
                        Required_Date_FG2F
                    From
                        KD_MRP  )
    Loop
        Utl_File.Put_Line(File_Handle,MRP.RM_Part_No || ',' || '"' ||  MRP.RM_Part_Desc || '"' || ',' || MRP.M0 || ',' 
                                                     || MRP.M1 || ',' || MRP.M2 || ',' || MRP.M3 || ',' 
                                                     || MRP.M4 || ',' || MRP.M5 || ',' || MRP.M6 || ',' 
                                                     || MRP.M7 || ',' || MRP.M8 || ',' || MRP.M9 || ',' 
                                                     || MRP.M10 || ',' || MRP.M11 || ',' || MRP.FG_Part_No_FG1 || ',' 
                                                     || '"' || MRP.FG1_Part_Desc || '"' || ',' || MRP.FG1_Part_Product_Code || ',' || MRP.FG1_Part_Product_Family || ',' || MRP.Avg_Monthly_Sales_FG1s || ',' 
                                                     || MRP.Months_On_Hand_FG1S || ',' || MRP.Required_Date_FG1S || ',' 
                                                     || MRP.Avg_Monthly_Forecast_FG1F || ',' || MRP.Months_On_Hand_FG1F 
                                                     || ',' || MRP.Required_Date_FG1F || ',' || MRP.FG_Part_No_FG2 || ',' 
                                                     || '"' || MRP.FG2_Part_Desc || '"' || ',' || MRP.FG2_Part_Product_Code  || ',' || MRP.FG2_Part_Product_Family || ',' || MRP.Avg_Monthly_Sales_FG2s || ',' 
                                                     || MRP.Months_On_Hand_FG2S || ',' || MRP.Required_Date_FG2S || ',' 
                                                     || MRP.Avg_Monthly_Forecast_FG2F || ',' || MRP.Months_On_Hand_FG2F 
                                                     || ',' || MRP.Required_Date_FG2F);
    End Loop;
    Utl_File.Fclose(File_Handle);
End;

/
