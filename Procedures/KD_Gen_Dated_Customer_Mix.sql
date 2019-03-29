Create Or Replace Procedure 
KD_Gen_Dated_Customer_Mix (Date_v IN varchar2) Is
    SQL_Query_Lost Clob;
    SQL_Query_Down Clob;
    SQL_Query_Recovered Clob;
    SQL_Query_New Clob;
    SQL_Query_Current Clob;
    SQL_Query_NewKits Clob;
    SQL_Query_NewBio Clob;
    Date_v_Date Varchar(4000);
    Table_Does_Not_Exist Exception;
    Pragma Exception_Init(table_does_not_exist, -00942);
Begin
    Execute Immediate 'Truncate Table KD_Lost_Dated';
    Execute Immediate 'Truncate Table KD_Down_Dated';
    Execute Immediate 'Truncate Table KD_Recovered_Dated';
    Execute Immediate 'Truncate Table KD_New_Dated';
    Execute Immediate 'Truncate Table KD_Current_Dated';
    Execute Immediate 'Truncate Table KD_Customer_Mix_Dated';
    Execute Immediate 'Truncate Table KD_New_Kit_Cust_CY_Dated';
    Execute Immediate 'Truncate Table KD_New_Bio_Cust_CY_Dated';
    Date_v_Date := 'To_Date(''' || Date_v || ''',''MM/DD/YYYY'')';
    Sql_Query_Lost :=   'Insert Into KD_Lost_Dated
                            Select 
                                ''LOST'' As Status,
                                SD.Customer_No,
                                SUM(Case When SD.InvoiceDate >= ' || Date_v_Date || '-90 Then SD.AllAmounts Else 0 End) As Rolling_90D,
                                SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || ')-90,-12) And Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End) As Rolling_90DLY,
                                SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-6) Then SD.AllAmounts Else 0 End) As Rolling_6M,
                                SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || '),-18) And Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End) As Rolling_6MLY,
                                (Round(SUM(Case When SD.InvoiceDate >= Trunc(' || Date_v_Date || ')-90 Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || ')-90,-12) And Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4))*100 As "CY/LY_90D",
                                SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) As Rolling_18M,
                                SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(' || Date_v_Date || '),-18),-12) AND Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End) as Rolling_18MLY,
                                (Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(' || Date_v_Date || '),-18),-12) AND Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4))*100 As "CY/LY_18M",
                                Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(Year From ' || Date_v_Date || ') Then SD.AllAmounts Else 0 End) As CY,
                                Sum(Case When Extract(Year From Sd.InvoiceDate) = Extract(Year From ' || Date_v_Date || ')-1 Then SD.AllAmounts Else 0 End) As PY,
                                Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(Year From ' || Date_v_Date || ')-2 Then Sd.AllAmounts Else 0 End) As PY2,
                                Sum(Case When Extract(Year From sD.InvoiceDate) = Extract(Year From ' || Date_v_Date || ')-3 then SD.AllAmounts Else 0 End) As PY3,
                                Sum(Case When Extract(Year From Sd.InvoiceDate) = Extract(Year From ' || Date_v_Date || ')-4 Then SD.AllAmounts Else 0 End) As PY4
                            From
                                KD_Sales_Data_Request SD
                            Where
                                Extract(Year From SD.InvoiceDate) >= Extract(Year From ' || Date_v_Date || ')-4 AND
                                SD.InvoiceDate <= ' || Date_v_Date || ' And
                                SD.Charge_Type = ''Parts'' And
                                SD.Corporate_Form = ''DOMDIR'' And
                                SD.Catalog_No != ''3DBC-22001091'' And
                                ((SD.Order_No Not Like ''W%'' And
                                SD.Order_No Not Like ''X%'') Or
                                SD.Order_No Is Null) And
                                (SD.Market_Code != ''PREPOST'' Or SD.Market_Code Is Null) And
                                SD.Invoice_ID != ''CR1001802096'' AND
                                SD.Order_No != ''C512921''
                            Group By
                                SD.Customer_No
                            Having
                                SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-6) Then SD.AllAmounts Else 0 End) <= 0 AND
                                SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) > 1500';
    SQL_Query_Down :=   'Insert Into KD_Down_Dated
                            SELECT
                                Case When Round(SUM(Case When SD.InvoiceDate >= Trunc(' || Date_v_Date || ')-90 Then SD.AllAmounts Else 0 End) /  Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || ')-90,-12) And Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4) <= .90 AND
                                          Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(' || Date_v_Date || '),-18),-12) AND Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4) <= .90 AND
                                          SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || ')-90,-12) And Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End) - SUM(Case When SD.InvoiceDate >= Trunc(' || Date_v_Date || ')-90 Then SD.AllAmounts Else 0 End) > 1500 AND
                                          SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(' || Date_v_Date || '),-18),-12) AND Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End) - SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) > 1500
                                     Then ''DOWN''
                                     When Round(SUM(Case When SD.InvoiceDate >= Trunc(' || Date_v_Date || ')-90 Then SD.AllAmounts Else 0 End) /  Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || ')-90,-12) And Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4) Between .90 And 1.1 and
                                          Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(' || Date_v_Date || '),-18),-12) AND Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4) Between .90 and 1.1
                                     Then ''FLAT''
                                     When Round(SUM(Case When SD.InvoiceDate >= Trunc(' || Date_v_Date || ')-90 Then SD.AllAmounts Else 0 End) /  Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || ')-90,-12) And Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4)  > 1.1 and
                                          Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(' || Date_v_Date || '),-18),-12) AND Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4) > 1.1
                                     Then ''UP''
                                End As Status,
                                SD.Customer_No,
                                SUM(Case When SD.InvoiceDate >= Trunc(' || Date_v_Date || ')-90 Then SD.AllAmounts Else 0 End) As Rolling_90D,
                                SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || ')-90,-12) And Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End) As Rolling_90DLY,
                                SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-6) Then SD.AllAmounts Else 0 End) As Rolling_6M,
                                SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(' || Date_v_Date || '),-6),-12) And Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End) As Rolling_6MLY,
                                (Round(SUM(Case When SD.InvoiceDate >= Trunc(' || Date_v_Date || ')-90 Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || ')-90,-12) And Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4)) * 100 As "CY/LY_90D",
                                SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) As Rolling_18M,
                                SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(' || Date_v_Date || '),-18),-12) AND Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End) as Rolling_18MLY,
                                (Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(' || Date_v_Date || '),-18),-12) AND Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4)) * 100 As "CY/LY_18M",
                                Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(Year From ' || Date_v_Date || ') Then SD.AllAmounts Else 0 End) As CY,
                                Sum(Case When Extract(Year From Sd.InvoiceDate) = Extract(Year From ' || Date_v_Date || ')-1 Then SD.AllAmounts Else 0 End) As PY,
                                Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(YEar From ' || Date_v_Date || ')-2 Then Sd.AllAmounts Else 0 End) As PY2,
                                Sum(Case When Extract(YEar From sD.InvoiceDate) = Extract(Year From ' || Date_v_Date || ')-3 then SD.AllAmounts Else 0 End) As PY3,
                                Sum(Case When Extract(Year From Sd.InvoiceDate) = Extract(Year From ' || Date_v_Date || ')-4 Then SD.AllAmounts Else 0 End) As PY4,
                                SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || ')-90,-12) And Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End) - SUM(Case When SD.InvoiceDate >= Trunc(' || Date_v_Date || ')-90 Then SD.AllAmounts Else 0 End) As "90-90",
                                SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(' || Date_v_Date || '),-18),-12) AND Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End) - SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) As "18-18"
                            FROM
                                KD_Sales_Data_Request SD
                            WHERE
                                SD.Customer_No Not In (Select Customer_No From KD_Lost_Dated) And
                                SD.InvoiceDate <= ' || Date_v_Date || ' And
                                Extract(Year From SD.InvoiceDate) >= Extract(Year From ' || Date_v_Date || ')-4 AND
                                SD.Charge_Type = ''Parts'' And
                                SD.Corporate_Form = ''DOMDIR'' And
                                SD.Catalog_No != ''3DBC-22001091'' And
                                ((SD.Order_No Not Like ''W%'' And
                                SD.Order_No Not Like ''X%'') Or
                                SD.Order_No Is Null) And
                                (SD.Market_Code != ''PREPOST'' Or SD.Market_Code Is Null) And
                                SD.Invoice_ID != ''CR1001802096'' AND
                                SD.Order_No != ''C512921'' 
                            GROUP BY
                                SD.Customer_No
                            HAVING
                                SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-6) Then SD.AllAmounts Else 0 End) > 0 AND
                                SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) <> 0 And
                                    Case When Round(SUM(Case When SD.InvoiceDate >= Trunc(' || Date_v_Date || ')-90 Then SD.AllAmounts Else 0 End) /  Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || ')-90,-12) And Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4) <= .90 AND
                                          Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(' || Date_v_Date || '),-18),-12) AND Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4) <= .90 AND
                                          SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || ')-90,-12) And Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End) - SUM(Case When SD.InvoiceDate >= Trunc(' || Date_v_Date || ')-90 Then SD.AllAmounts Else 0 End) > 1500 AND
                                          SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(' || Date_v_Date || '),-18),-12) AND Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End) - SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) > 1500
                                     Then ''DOWN''
                                     When Round(SUM(Case When SD.InvoiceDate >= Trunc(' || Date_v_Date || ')-90 Then SD.AllAmounts Else 0 End) /  Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || ')-90,-12) And Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4) Between .90 And 1.1 and
                                          Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(' || Date_v_Date || '),-18),-12) AND Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4) Between .90 and 1.1
                                     Then ''FLAT''
                                     When Round(SUM(Case When SD.InvoiceDate >= Trunc(' || Date_v_Date || ')-90 Then SD.AllAmounts Else 0 End) /  Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || ')-90,-12) And Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4)  > 1.1 and
                                          Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(' || Date_v_Date || '),-18),-12) AND Add_Months(Trunc(' || Date_v_Date || '),-12) Then SD.AllAmounts Else 0 End),0),4) > 1.1
                                     Then ''UP''
                                End = ''DOWN''';
    Sql_Query_Recovered := 'Insert Into KD_Recovered_Dated
                                Select
                                    SD.Customer_No,
                                    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-6) Then SD.AllAmounts Else 0 End) As Rolling_6M,
                                    SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || '),-18) And Add_Months(Trunc(' || Date_v_Date || '),-6) Then SD.AllAmounts Else 0 End) As Rolling_Between_18_And_6MLY,
                                    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) As Rolling_18M
                                From
                                    KD_Sales_Data_Request SD 
                                Where
                                    SD.Customer_No Not In (Select Customer_No From KD_Down_Dated) And
                                    SD.Customer_No Not In (Select Customer_No From KD_Lost_Dated) And
                                    Extract(Year From SD.InvoiceDate) >= Extract(Year From ' || Date_v_Date || ')-4 AND
                                    SD.InvoiceDate <= ' || Date_v_Date || ' And
                                    SD.Charge_Type = ''Parts'' And
                                    SD.Corporate_Form = ''DOMDIR'' And
                                    SD.Catalog_No != ''3DBC-22001091'' And
                                    ((SD.Order_No Not Like ''W%'' And
                                    SD.Order_No Not Like ''X%'') Or
                                    SD.Order_No Is Null) And
                                    (SD.Market_Code != ''PREPOST'' Or SD.Market_Code Is Null) And
                                    SD.Invoice_ID != ''CR1001802096'' AND
                                    SD.Order_No != ''C512921''
                                Group By
                                    SD.Customer_No
                                Having
                                    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-6) Then SD.AllAmounts Else 0 End) > 1500 And
                                    SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(' || Date_v_Date || '),-18) And Add_Months(Trunc(' || Date_v_Date || '),-6) Then SD.AllAmounts Else 0 End) <= 0 And
                                    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-18) Then SD.AllAmounts Else 0 End) > 1500';
    Sql_Query_New := 'Insert Into KD_New_Dated
                        Select
                            SD.Customer_No,
                            Sum(SD.AllAmounts) As Rolling_6M
                        From
                            KD_Sales_Data_Request SD, KD_First_Order_Date FOD
                        Where
                            SD.Customer_No Not In (Select Customer_No From KD_Down_Dated) And
                            SD.Customer_No Not In (Select Customer_No From KD_Lost_Dated) And
                            SD.Customer_No Not In (Select Customer_No From KD_Recovered_Dated) And
                            SD.Customer_No = FOD.Customer_No And
                            FOD.First_Order_Date >= Add_Months(Trunc(' || Date_v_Date || '),-6) And
                            FOD.First_Order_Date <= ' || Date_v_Date || ' And
                            SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-6) And
                            SD.InvoiceDate <= ' || Date_v_Date || ' And
                            SD.Charge_Type = ''Parts'' And
                            SD.Corporate_Form = ''DOMDIR'' And
                            SD.Catalog_No != ''3DBC-22001091'' And
                            ((SD.Order_No Not Like ''W%'' And
                            SD.Order_No Not Like ''X%'') Or
                            SD.Order_No Is Null) And
                            (SD.Market_Code != ''PREPOST'' Or SD.Market_Code Is Null) And
                            SD.Invoice_ID != ''CR1001802096'' AND
                            SD.Order_No != ''C512921'' 
                            And Sd.Source != ''PTUSAXLSX''
                        Group By
                            SD.Customer_No';
    Sql_Query_Current := 'Insert Into KD_Current_Dated
                                Select
                                    SD.Customer_No,
                                    Sum(SD.AllAmounts) as Rolling_6M
                                From 
                                    KD_Sales_Data_Request SD 
                                Where
                                    SD.Customer_No Not In (Select Customer_No From KD_Down_Dated) And
                                    SD.Customer_No Not In (Select Customer_No From KD_Lost_Dated) And
                                    SD.Customer_No Not In (Select Customer_No From KD_Recovered_Dated) And
                                    SD.Customer_No Not In (Select Customer_No From KD_New_Dated) And
                                    SD.InvoiceDate >= Add_Months(Trunc(' || Date_v_Date || '),-6) AND
                                    SD.InvoiceDate <= ' || Date_v_Date || ' And
                                    SD.Charge_Type = ''Parts'' And
                                    SD.Corporate_Form = ''DOMDIR'' And
                                    SD.Catalog_No != ''3DBC-22001091'' And
                                    ((SD.Order_No Not Like ''W%'' And
                                    SD.Order_No Not Like ''X%'') Or
                                    SD.Order_No Is Null) And
                                    (SD.Market_Code != ''PREPOST'' Or SD.Market_Code Is Null) And
                                    SD.Invoice_ID != ''CR1001802096'' AND
                                    SD.Order_No != ''C512921''
                                Group By
                                    SD.Customer_No';
    Sql_Query_Newkits := 'Insert Into KD_New_Kit_Cust_CY_Dated
                                With Kits As (
                                Select
                                    A.Customer_No,
                                    A.Part_Product_Family,
                                    Sum(Case When Extract(Year From A.InvoiceDate) < Extract(Year From ' || Date_v_Date || ') Then A.Invoiced_Qty Else 0 End) As OldKits,
                                    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From ' || Date_v_Date || ') Then A.Invoiced_Qty Else 0 End) As NewKits
                                From
                                    KD_Sales_Data_Request A,
                                    KD_Kit_Parts B
                                Where
                                    A.InvoiceDate <= ' || Date_v_Date || ' And
                                    A.Catalog_No = B.Catalog_No And
                                    A.Charge_Type = ''Parts'' And
                                    A.Corporate_Form = ''DOMDIR'' And
                                    A.Catalog_No != ''3DBC-22001091'' And
                                    ((A.Order_No Not Like ''W%'' And
                                    A.Order_No Not Like ''X%'') Or
                                    A.Order_No Is Null) And
                                    (A.Market_Code != ''PREPOST'' Or A.Market_Code Is Null) And
                                    A.Invoice_ID != ''CR1001802096'' AND 
                                    A.Order_No != ''C512921''
                                Group By
                                    A.Customer_No,
                                    A.Part_Product_Family
                                Having
                                    Sum(Case When Extract(Year From A.InvoiceDate) < Extract(Year From ' || Date_v_Date || ') Then A.Invoiced_Qty Else 0 End) <= 0 And
                                    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From ' || Date_v_Date || ') Then A.Invoiced_Qty Else 0 End) > 0 )
                                
                                Select
                                    A.Customer_No,
                                    B.Part_Product_Family,
                                    Sum(A.AllAmounts) as Family_Total
                                From
                                 Kits B Left Join   KD_Sales_Data_Request A 
                                     On A.Customer_No = B.Customer_No And
                                    A.Part_Product_Family = B.Part_Product_Family
                                Where
                                    A.InvoiceDate <= ' || Date_v_Date || ' And
                                    A.Charge_Type = ''Parts'' And
                                    A.Corporate_Form = ''DOMDIR'' And
                                    A.Catalog_No != ''3DBC-22001091'' And
                                    ((A.Order_No Not Like ''W%'' And
                                    A.Order_No Not Like ''X%'') Or
                                    A.Order_No Is Null) And
                                    (A.Market_Code != ''PREPOST'' Or A.Market_Code Is Null) And
                                    A.Invoice_ID != ''CR1001802096'' AND
                                    A.Order_No != ''C512921'' 
                                Group By
                                    A.Customer_No,
                                    B.Part_Product_Family';
    Sql_Query_Newbio := 'Insert Into KD_New_Bio_Cust_Cy_Dated
                            Select
                                Customer_No,
                                Sum(Case When Extract(Year from InvoiceDate) < Extract(Year From ' || Date_v_Date || ') And
                                              Part_Product_Code = ''REGEN'' Then AllAmounts
                                         Else 0 End) As PYs_Regen,
                                Sum(Case When Extract(Year from InvoiceDate) = Extract(Year From ' || Date_v_Date || ') And
                                              Part_Product_Code = ''REGEN'' Then AllAmounts
                                         Else 0 End) As CY_Regen
                            From
                                KD_Sales_Data_Request A
                            Where
                                A.InvoiceDate <= ' || Date_v_Date || ' And
                                A.Charge_Type = ''Parts'' And
                                A.Corporate_Form = ''DOMDIR'' And
                                A.Catalog_No != ''3DBC-22001091'' And
                                ((A.Order_No Not Like ''W%'' And
                                A.Order_No Not Like ''X%'') Or
                                A.Order_No Is Null) And
                                (A.Market_Code != ''PREPOST'' Or A.Market_Code Is Null) And
                                A.Invoice_ID != ''CR1001802096'' AND
                                A.Order_No != ''C512921''
                            Group By
                                Customer_No
                            Having
                                Sum(Case When Extract(Year from InvoiceDate) < Extract(Year From ' || Date_v_Date || ') And
                                          Part_Product_Code = ''REGEN'' Then AllAmounts
                                         Else 0 End) <= 0 And
                                Sum(Case When Extract(Year from InvoiceDate) = Extract(Year From ' || Date_v_Date || ') And
                                          Part_Product_Code = ''REGEN'' Then AllAmounts
                                     Else 0 End) > 500';
    Execute Immediate Sql_Query_Lost;
    Execute Immediate Sql_Query_Down;
    Execute Immediate Sql_Query_Recovered;
    Execute Immediate Sql_Query_New;
    Execute Immediate Sql_Query_Current;
    Execute Immediate Sql_Query_Newkits;
    Execute Immediate Sql_Query_NewBio;
    Execute Immediate 'Insert Into KD_Customer_Mix_Dated
                           Select ''Lost'' As Status, Count(Customer_No) As Customers, Sum(Rolling_6M) as Rolling_6M From KD_Lost_Dated Group By ''Lost''
                           Union All
                           Select ''Down'', Count(Customer_No), Sum(Rolling_6M) From KD_Down_Dated Group by ''Down''
                           Union All
                           Select ''Recovered'', Count(Customer_No) As Customers, Sum(Rolling_6M) From KD_Recovered_Dated Group By ''Recovered''
                           Union All
                           Select ''New'', Count(Customer_No), Sum(Rolling_6M) From KD_New_Dated Group by ''New''
                           Union All
                           Select ''Current'', Count(Customer_No), Sum(Rolling_6M) From KD_Current_Dated Group By ''Current''';
Exception
    When Table_Does_Not_Exist Then DBMS_Output.Put_Line('Table does not exist'); 
End;