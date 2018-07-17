DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := NULL; --p1
   c_ VARCHAR2(32000) := NULL; --p2
   d_ VARCHAR2(32000) := 'CUSTOMER_ID'||chr(31)||'2409'||chr(30)||'CONTRACT'||chr(31)||'100'||chr(30)||'CHARGE_TYPE'||chr(31)||'WAIVESHIPPING'||chr(30)||'CHARGED_QTY'||chr(31)||'1'||chr(30)||'CHARGE_COST'||chr(31)||'0'||chr(30)||'CHARGE_COST_PERCENT'||chr(31)||''||chr(30)||'CHARGE_AMOUNT'||chr(31)||'0'||chr(30)||'CHARGE'||chr(31)||''||chr(30)||'PRINT_CHARGE_TYPE_DB'||chr(31)||'N'||chr(30)||'PRINT_COLLECT_CHARGE_DB'||chr(31)||'NO PRINT'||chr(30)||'INTRASTAT_EXEMPT_DB'||chr(31)||'FALSE'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
Begin
For Cur In (Select * From Customer_Info A Where A.customer_ID IN ('2884',
'A26747',
'A21159',
'D50060',
'A65297',
'A24322',
'10754',
'9565',
'10745',
'8535',
'8536',
'8537',
'8538',
'8539',
'8540',
'8541',
'8542',
'8543',
'8544',
'8545',
'8546',
'11059',
'11060',
'11972',
'10369',
'10654',
'14260',
'12111',
'12730',
'14807',
'14732',
'16284',
'16285',
'16287',
'16289',
'16290',
'16292',
'16293',
'16294',
'16295',
'16296',
'16297',
'16298',
'16299',
'16300',
'16301',
'16302',
'16250',
'16251',
'16252',
'16253',
'16254',
'16255',
'16256',
'16257',
'16258',
'16259',
'16260',
'16261',
'16263',
'16264',
'16791',
'15440',
'15179',
'16132',
'16303',
'16305',
'16307',
'16308',
'16310',
'16311',
'16318',
'16319',
'16320',
'16321',
'16322',
'16832',
'16798',
'16800',
'15109',
'15344',
'18048',
'18006',
'23677',
'19202',
'18613',
'24150',
'19523',
'24144',
'22225',
'24412',
'24063',
'24327',
'24399',
'25139',
'19733',
'24743',
'24903',
'24948',
'24983',
'18166',
'19396',
'19482',
'26695',
'28788',
'27581',
'27583',
'27585',
'29293',
'26725',
'26726',
'26728',
'26729',
'26730',
'26731',
'26732',
'26733',
'26734',
'26735',
'27754',
'26550',
'26634',
'28868',
'27125',
'29123',
'27561',
'27368',
'27599',
'27600',
'27601',
'27602',
'27603',
'26872',
'27967',
'28559',
'26479',
'30227',
'30228',
'30229',
'30230',
'30231',
'30232',
'30233',
'30234',
'30236',
'30243',
'30241',
'30252',
'30258',
'30259',
'30264',
'30265',
'30266',
'30268',
'30269',
'30244',
'30245',
'30247',
'30248',
'30249',
'30250',
'30251',
'30253',
'30255',
'30256',
'30257',
'30260',
'30261',
'30262',
'30263',
'30271',
'30272',
'30273',
'30275',
'30277',
'30278',
'30279',
'30280',
'30281',
'30282',
'30283',
'30284',
'30286',
'30287',
'30288',
'30289',
'30290',
'30291',
'30292',
'30305',
'30306',
'30307',
'30308',
'30309',
'30311',
'30312',
'30313',
'30314',
'30315',
'30316',
'30317',
'30319',
'30320',
'30363',
'30333',
'30334',
'30335',
'30343',
'30350',
'30351',
'30352',
'30353',
'30365',
'30235',
'30238',
'30239',
'30240',
'30242',
'30246',
'30267',
'30270',
'30274',
'30276',
'30285',
'30293',
'30294',
'30295',
'30297',
'30298',
'30299',
'30300',
'30301',
'30321',
'30322',
'30323',
'30324',
'30325',
'30326',
'30327',
'30328',
'30329',
'30330',
'30331',
'30354',
'31268'))
Loop
A_ := Null;
B_ := Null;
C_ := NULL;
D_ := 'CUSTOMER_ID'||Chr(31)|| Cur.Customer_Id ||Chr(30)||'CONTRACT'||Chr(31)||'100'||Chr(30)||'CHARGE_TYPE'||Chr(31)||'WAIVESHIPPING'||Chr(30)||'CHARGED_QTY'||Chr(31)||'1'||Chr(30)||'CHARGE_COST'||Chr(31)||'0'||Chr(30)||'CHARGE_COST_PERCENT'||Chr(31)||''||Chr(30)||'CHARGE_AMOUNT'||Chr(31)||'0'||Chr(30)||'CHARGE'||Chr(31)||''||Chr(30)||'PRINT_CHARGE_TYPE_DB'||Chr(31)||'N'||Chr(30)||'PRINT_COLLECT_CHARGE_DB'||Chr(31)||'NO PRINT'||Chr(30)||'INTRASTAT_EXEMPT_DB'||Chr(31)||'FALSE'||Chr(30); --p3
E_ := 'DO';    
Ifsapp.Customer_Charge_Api.New__( A_ , B_ , C_ , D_ , E_ );
End Loop;
End;
