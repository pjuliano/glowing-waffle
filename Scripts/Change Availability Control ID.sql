DECLARE
   a_ VARCHAR2(32000) := '100'; --p0
   b_ VARCHAR2(32000) := 'IBT 8.5'; --p1
   c_ VARCHAR2(32000) := '*'; --p2
   d_ VARCHAR2(32000) := 'CA245F'; --p3
   e_ VARCHAR2(32000) := '319J11D3'; --p4
   f_ VARCHAR2(32000) := '*'; --p5
   g_ VARCHAR2(32000) := '11'; --p6
   h_ VARCHAR2(32000) := '*'; --p7
   i_ FLOAT := 0; --p8
   j_ VARCHAR2(32000) := 'EXPIRY'; --p9
Begin
  For A In ( Select 
                    A.Contract, 
                    A.Part_No,
                    A.Configuration_Id,
                    A.Location_No,
                    A.Lot_Batch_No,
                    A.Serial_No,
                    A.Eng_Chg_Level,
                    A.Waiv_Dev_Rej_No,
                    A.Activity_Seq
                  From 
                    Inventory_Part_In_Stock A
                  Where 
                    A.Location_No != 'CONS' And
                    --A.Availability_Control_ID Not In ('PHASEOUT','EXPIRY') And
                    Part_No In ('IBN 15',
                                'IBN 18',
                                'IBS 10',
                                'IBS 8.5',
                                'IBT 10',
                                'IBT 11.5',
                                'IBT 12D-10',
                                'IBT 12D-13',
                                'IBT 12D-15',
                                'IBT 12D-8.5',
                                'IBT 13',
                                'IBT 15',
                                'IBT 8.5',
                                'CBNU',
                                'CBU',
                                'I-DI12D-4T-13',
                                'I-DI12D-4T-15',
                                'I-DI12D-5T-13',
                                'I-DI12D-5T-15',
                                'I-DI12D-6T-13',
                                'GC-NX-40',
                                'GC-NX-50',
                                'GC-NX-60',
                                'GC-NX-70',
                                'D-20T-M15',
                                'D-30T-M15',
                                'BAS1P',
                                'BAS2',
                                'BAS3',
                                'BAT 12D-13',
                                'BAT 12D-15',
                                'BAT 13',
                                'BAT 15',
                                'BAT 18',
                                'BAT 24D-10',
                                'BAT 24D-11.5',
                                'BAT 24D-13',
                                'BAT 24D-15',
                                'BBBT 24D-10',
                                'BBBT 24D-11.5',
                                'CB75',
                                'GC-EX-50',
                                'GC-EX-60',
                                'GC-NX-34',
                                'CBAU',
                                'CBBBU',
                                'ABAMC3',
                                'D-ZYG-29S',
                                'D-ZYG-35',
                                'D-ZYG-35S',
                                'D-ZYG-CS',
                                'D-ZYG-CS-S',
                                'ABBBMC1',
                                'ABBBMC3',
                                'ABNMC5',
                                'AMC2',
                                'AMCZ3',
                                'DBS12',
                                'D-50T-M13',
                                'TCBN1NH',
                                'SB5',
                                'LT7/10',
                                'SB-DBN-1',
                                'SCAU5',
                                'SCU2',
                                'SCU6',
                                'SMAX9H',
                                'MAX-7-9',
                                'TSU3',
                                'WB2',
                                'WB4',
                                'MIA-1',
                                'MIA-2',
                                'WBBB4',
                                'I-HD-S',
                                'WP-GC-S3',
                                'LS12',
                                'LSA12',
                                'LSN12',
                                'TSH3',
                                'TSHZ2',
                                'I-ZYG-DG-1',
                                'I-ZYG-INS-1',
                                'TB2',
                                'TB3',
                                'TB4',
                                'TBA2',
                                'LBBBS12',
                                'LMAX9',
                                'TBA4',
                                'TBBB2',
                                'TBN2',
                                'TBN6',
                                'GMCW1',
                                'GSQ3',
                                'GSQZ3',
                                'TCB1NH',
                                'TCBA1NH',
                                'AMC5',
                                'EPC-EX-50-1KT',
                                'EPC-EX-50-2KT',
                                'ZYG-55-35N',
                                'ZYG-55-37.5N',
                                'ZYG-55-52.5N',
                                'I-ZYG-1',
                                'AMC3',
                                'SBA1',
                                'I-EXHEX-TRAY',
                                'TB6',
                                'TBBB4',
                                'ZYG-55-45N',
                                'IBT 12D-11.5',
                                'D-30T-M20',
                                'BBBT 12D-13',
                                'ABAMC1',
                                'D-ZYG-29',
                                'AMC1',
                                'AMC4',
                                'I-DI12D-6T-10',
                                'I-DI12D-6T-15',
                                'SMAX9NH',
                                'SCNU2',
                                'BAT 11.5',
                                'TSHZ3'))
  Loop
    a_ := A.Contract; --p0
    B_ := A.Part_No; --p1
    C_ := A.Configuration_Id; --p2
    D_ := A.Location_No; --p3
    E_ := A.Lot_Batch_No; --p4
    F_ := A.Serial_No; --p5
    G_ := A.Eng_Chg_Level; --p6
    H_ := A.Waiv_Dev_Rej_No; --p7
    I_ := A.Activity_Seq; --p8
    J_ := 'PHASEOUT'; --p9
    Ifsapp.Inventory_Part_In_Stock_Api.Modify_Availability_Control_Id( A_ , B_ , C_ , D_ , E_ , F_ , G_ , H_ , I_ , J_ );
  End Loop;
END;
