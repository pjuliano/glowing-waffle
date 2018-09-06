Create Or Replace Function Kd_Udi_Gen (V_Part_No In Varchar2, 
                                       V_Production_Line In Varchar2, 
                                       V_Exp_Date In Date,
                                       V_Lot_Batch_No In Varchar2) 
    Return Varchar2 Is
    V_Exp_Date_Plus Date;
Begin
    V_Exp_Date_Plus := To_Date(Case 
                            When Extract(Month From V_Exp_Date) In (1,3,5,7,8,10,12) Then
                            To_Char(V_Exp_Date,'yy') + 5 || To_Char(V_Exp_Date,'mm') || '31'
                            When Extract(Month From V_Exp_Date) In (4,6,9,11) Then
                            To_Char(V_Exp_Date,'yy') + 5 || To_Char(V_Exp_Date,'mm') || '30'
                            When Extract(Month From V_Exp_Date) = 2 And Mod(Extract(Year From V_Exp_Date)+5,4) = 0 And Mod(Extract(Year From V_Exp_Date)+5,100) != 0 Then
                            To_Char(V_Exp_Date,'yy') + 5 || To_Char(V_Exp_Date,'mm') || '29'
                            When Extract(Month From V_Exp_Date) = 2 And Mod(Extract(Year From V_Exp_Date)+5,4) = 0 And Mod(Extract(Year From V_Exp_Date)+5,100) = 0 And Mod(Extract(Year From V_Exp_Date)+5,400) = 0 Then
                            To_Char(V_Exp_Date,'yy') + 5 || To_Char(V_Exp_Date,'mm') || '29'
                            When Extract(Month From V_Exp_Date) = 2 And Mod(Extract(Year From V_Exp_Date)+5,4) = 0 And Mod(Extract(Year From V_Exp_Date)+5,100) = 0 And Mod(Extract(Year From V_Exp_Date)+5,400) != 0 Then
                            To_Char(V_Exp_Date,'yy') + 5 || To_Char(V_Exp_Date,'mm') || '28'
                            When Extract(Month From V_Exp_Date) = 2 And Mod(Extract(Year From V_Exp_Date)+5,4) != 0 Then
                            To_Char(V_Exp_Date,'yy') + 5 || To_Char(V_Exp_Date,'mm') || '28'
                          End,'YYMMDD');
    Return
    Case 
        When V_Exp_Date Is Null 
        Then 'SO Must Be Closed.'
        When V_Exp_Date < To_Date('09/01/2018','MM/DD/YYYY')
        Then 'Before Inception Date.'
        When V_Production_Line Not Like 'Sterile%' And V_Production_Line Not Like 'Non%' Then 'Check Production Line.'
        Else
    Case 
        When V_Production_Line Like 'Sterile%' Then
        '+D768' || --Data Identifier and MFG Code
        Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18) || --First 18 characters of part number stripped of non-alphanumeric characters
        '0/$$3' || --UoM, Data Delimeter, and Date Reference Identifier
        To_Char(V_Exp_Date_Plus,'YYMMDD') || --Expiration Date in YYMMDD format
        Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18) || --First 18 characters of lot/batch stripped of non-alphanumeric characters
        Kd_Udi_Check_Char(Mod(Kd_Udi_Char_Value('+D768',1) +
                              Kd_Udi_Char_Value('+D768',2) +
                              Kd_Udi_Char_Value('+D768',3) +
                              Kd_Udi_Char_Value('+D768',4) +
                              Kd_Udi_Char_Value('+D768',5) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),1) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),2) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),3) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),4) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),5) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),6) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),7) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),8) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),9) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),10) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),11) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),12) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),13) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),14) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),15) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),16) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),17) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),18) +
                              Kd_Udi_Char_Value('0/$$3',1) +
                              Kd_Udi_Char_Value('0/$$3',2) +
                              Kd_Udi_Char_Value('0/$$3',3) +
                              Kd_Udi_Char_Value('0/$$3',4) +
                              Kd_Udi_Char_Value('0/$$3',5) +
                              Kd_Udi_Char_Value(To_Char(V_Exp_Date_Plus,'YYMMDD'),1) +
                              Kd_Udi_Char_Value(To_Char(V_Exp_Date_Plus,'YYMMDD'),2) +
                              Kd_Udi_Char_Value(To_Char(V_Exp_Date_Plus,'YYMMDD'),3) +
                              Kd_Udi_Char_Value(To_Char(V_Exp_Date_Plus,'YYMMDD'),4) +
                              Kd_Udi_Char_Value(To_Char(V_Exp_Date_Plus,'YYMMDD'),5) +
                              Kd_Udi_Char_Value(To_Char(V_Exp_Date_Plus,'YYMMDD'),6) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),1) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),2) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),3) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),4) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),5) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),6) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),7) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),8) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),9) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),10) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),11) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),12) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),13) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),14) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),15) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),16) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),17) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),18),43))
        When V_Production_Line Like 'Non%' Then
        '+D768' || --Data Identifier and MFG Code
        Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18) || --First 18 characters of part number stripped of non-alphanumeric characters
        '0/$$7' || --UoM, Data Delimeter, and Date Reference Identifier
        Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18) || --First 18 characters of lot/batch stripped of non-alphanumeric characters
        Kd_Udi_Check_Char(Mod(Kd_Udi_Char_Value('+D768',1) +
                              Kd_Udi_Char_Value('+D768',2) +
                              Kd_Udi_Char_Value('+D768',3) +
                              Kd_Udi_Char_Value('+D768',4) + 
                              Kd_Udi_Char_Value('+D768',5) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),1) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),2) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),3) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),4) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),5) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),6) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),7) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),8) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),9) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),10) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),11) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),12) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),13) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),14) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),15) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),16) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),17) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Part_No,'[^a-zA-Z0-9]+',''),1,18),18) +
                              Kd_Udi_Char_Value('0/$$7',1) +
                              Kd_Udi_Char_Value('0/$$7',2) +
                              Kd_Udi_Char_Value('0/$$7',3) +
                              Kd_Udi_Char_Value('0/$$7',4) +
                              Kd_Udi_Char_Value('0/$$7',5) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),1) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),2) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),3) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),4) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),5) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),6) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),7) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),8) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),9) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),10) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),11) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),12) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),13) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),14) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),15) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),16) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),17) +
                              Kd_Udi_Char_Value(Substr(Regexp_Replace(V_Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18),18),43))
        
    End
    End;
End KD_UDI_Gen;