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
                    A.Availability_Control_ID Not In ('PHASEOUT','EXPIRY') And
                    Part_No In ('ABAMC1',
                                'ABAMC17D-3',
                                'ABAMC3',
                                'ABAMC30D-4',
                                'ABAMCZ1',
                                'ABAMCZ2',
                                'ABAMCZ3',
                                'ABAMCZ5',
                                'ABBBMC1',
                                'ABBBMC17D-3',
                                'ABBBMC3',
                                'ABBBMC30D-4',
                                'ABBBMCZ1',
                                'ABBBMCZ3',
                                'ABNMC3',
                                'ABNMC5',
                                'AMC1',
                                'AMC17D-3',
                                'AMC2',
                                'AMC3',
                                'AMC30D-4',
                                'AMC4',
                                'AMC5',
                                'AMCZ1',
                                'AMCZ2',
                                'AMCZ4',
                                'AMCZ5',
                                'AO2',
                                'BA 10',
                                'BA 11.5',
                                'BA 13',
                                'BA 8.5',
                                'BAS1',
                                'BAS1L',
                                'BAS1P',
                                'BAS2',
                                'BAS3',
                                'BAT 11.5',
                                'BAT 12D-10',
                                'BAT 12D-11.5',
                                'BAT 12D-13',
                                'BAT 12D-15',
                                'BAT 12D-18',
                                'BAT 18',
                                'BAT 24D-10',
                                'BAT 24D-11.5',
                                'BAT 24D-13',
                                'BAT 24D-15',
                                'BBBS 10',
                                'BBBS 11.5',
                                'BBBT 10',
                                'BBBT 11.5',
                                'BBBT 12D-10',
                                'BBBT 12D-11.5',
                                'BBBT 12D-13',
                                'BBBT 12D-15',
                                'BBBT 13',
                                'BBBT 15',
                                'BBBT 24D-10',
                                'BBBT 24D-13',
                                'BBBT 24D-15',
                                'BBBT 6',
                                'BBBT 8.5',
                                'BSH3',
                                'CB75',
                                'CBAU',
                                'CBAU-W',
                                'CBBB75',
                                'CBBBU-W',
                                'CBNU',
                                'CBU-W',
                                'CMAX9',
                                'D-20T-M15',
                                'D-20T-M20',
                                'D-29T-M15',
                                'D-30T-M15',
                                'D-30T-M20',
                                'D-33T-M15',
                                'D-40T-M15',
                                'D-40TP-10',
                                'D-40TP-11.5',
                                'D-40TP-13',
                                'D-40TP-15',
                                'D-40TP-18',
                                'D-40TP-6',
                                'D-40TP-8.5',
                                'D-43T-M15',
                                'D-50T-M13',
                                'D-50TP-10',
                                'D-50TP-11.5',
                                'D-50TP-13',
                                'D-50TP-15',
                                'D-50TP-18',
                                'D-50TP-6',
                                'D-50TP-8.5',
                                'D-53T-M13',
                                'D-60TP-10',
                                'D-60TP-11.5',
                                'D-60TP-13',
                                'D-60TP-15',
                                'D-60TP-18',
                                'D-60TP-6',
                                'D-60TP-8.5',
                                'DBA2',
                                'DBA5',
                                'DBAS12',
                                'DBAS24',
                                'DBBB2',
                                'DBBB5',
                                'DBS12',
                                'DBS24',
                                'D-CB-F',
                                'DN2',
                                'D-TAP-IBS',
                                'D-ZYG-29',
                                'D-ZYG-29S',
                                'D-ZYG-35',
                                'D-ZYG-35S',
                                'D-ZYG-CS',
                                'D-ZYG-CS-S',
                                'EPC-EX-50-1KT',
                                'EPC-EX-50-2KT',
                                'GC-EX-40',
                                'GC-EX-50',
                                'GC-EX-60',
                                'GC-NX-34',
                                'GC-NX-40',
                                'GC-NX-50',
                                'GC-NX-60',
                                'GC-NX-70',
                                'GMC1',
                                'GMCW1',
                                'GSIT2',
                                'GSQ2',
                                'GSQZ2',
                                'GSU3',
                                'GSUZ3',
                                'GSUZ9',
                                'I-AD',
                                'I-BAM-62',
                                'I-BAM-77',
                                'I-BD-M',
                                'I-BM-57',
                                'IBN 10',
                                'IBN 11.5',
                                'IBN 13',
                                'IBN 15',
                                'IBN 18',
                                'IBN 8.5',
                                'IBS 10',
                                'IBS 11.5',
                                'IBS 15',
                                'IBS 8.5',
                                'IBT 13',
                                'IBT 18',
                                'IBT 8.5',
                                'I-CON-X',
                                'I-CS-HD',
                                'I-DI12D-4T-13',
                                'I-DI12D-4T-15',
                                'I-DI12D-5T-13',
                                'I-DI12D-5T-15',
                                'I-DI12D-6T-10',
                                'I-DI12D-6T-13',
                                'I-DI12D-6T-15',
                                'I-DI-24D',
                                'I-EXHEX-TRAY',
                                'I-FME-XL',
                                'I-FME-XS',
                                'I-HAD',
                                'I-HBDM',
                                'I-HD-L',
                                'I-HD-LH',
                                'I-HD-M',
                                'I-HD-S',
                                'I-HHD-09',
                                'I-HHD-22S',
                                'I-HQD-L',
                                'I-HQD-M',
                                'I-HQD-S',
                                'I-QDI-S',
                                'I-SP-X',
                                'I-WI-09',
                                'I-WI-A',
                                'I-WI-BM',
                                'I-WI-QM',
                                'I-WI-QS',
                                'I-ZYG-1',
                                'I-ZYG-DG-1',
                                'I-ZYG-INS-1',
                                'LMAX8',
                                'LMAX9',
                                'LOC-8681',
                                'LOC-8682',
                                'LOC-8683',
                                'LOC-8684',
                                'LOC-8685',
                                'LOC-8695',
                                'LOC-8696',
                                'LOC-8820',
                                'LOC-8821',
                                'LOC-8822',
                                'LOC-8823',
                                'LOC-8824',
                                'LSDBAN4',
                                'LSDBN4',
                                'LSN12',
                                'LT7/10',
                                'LT7/20',
                                'MAX-7-11',
                                'MAX-7-7',
                                'MAX-7-9',
                                'MAX-8-11',
                                'MAX-8-7',
                                'MAX-9-11',
                                'MAX-9-7',
                                'MAX-9-9',
                                'MIA-1',
                                'MIA-2',
                                'PC2',
                                'P-CAP-55',
                                'SB16',
                                'SB16PH',
                                'SB17P',
                                'SB-17-TT',
                                'SBA1',
                                'SBA16',
                                'SBA16PH',
                                'SBA17P',
                                'SBA-17-TT',
                                'SBBB16',
                                'SBBB16PH',
                                'SBBB17P',
                                'SBBB-17-TT',
                                'SB-DBN-1',
                                'SBN1',
                                'SBN5',
                                'SC4',
                                'SC7',
                                'SCAU5',
                                'SCNU2',
                                'SCU2',
                                'SCU6',
                                'SMAX9H',
                                'SMAX9NH',
                                'TB2',
                                'TB9MAX-4',
                                'TB9MAX-7',
                                'TBA2',
                                'TBA3',
                                'TBA4',
                                'TBA6',
                                'TBBB2',
                                'TBBB4',
                                'TCBA1H',
                                'TCBA1NH',
                                'TCBBB1NH',
                                'TCBN1H',
                                'TCBN1NH',
                                'TSH2',
                                'TSH3',
                                'TSHZ2',
                                'TSHZ3',
                                'TSU2',
                                'TSU3',
                                'TSU9',
                                'TSUZ9',
                                'WBA2',
                                'WBA3',
                                'WBA4',
                                'WBA6',
                                'WBBB2',
                                'WBBB3',
                                'WBBB4',
                                'WBBB6',
                                'WBN2',
                                'WBN4',
                                'WP-GC-S3',
                                'ZYG-55-35N',
                                'ZYG-55-37.5N',
                                'ZYG-55-47.5N',
                                'ZYG-55-50N',
                                'ZYG-55-55N',
                                'ZYG-55-60N',
                                'ZYG-TR-55-35',
                                'ZYG-TR-55-45',
                                'ZYG-TR-55-52.5',
                                'SIM-12-07EX',
                                'SIM-12-11-EX',
                                'SIM-11-20EX',
                                'SIM-11-20EXCX',
                                'SIM-11-20EXMX',
                                'SIM-12-06EX',
                                'SIM-12-07ZY'))
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
