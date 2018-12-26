Create or Replace View KD_Customer_Payments_Test As
Select
  *
From
  (Select 
    Identity, 
    Identity_Name As Name, 
    Identity_Pay_Info_Api.Get_Ar_Contact(Company, Identity, Party_Type) As AR_Contact,
    Extract(Month From Ledger_Date) As Month,
    Inv_Amount As Amount
  From 
    Ifsapp.Ledger_Item_Cu_Det_Qry 
  Where 
    Company = '100' And
    Ledger_Item_Series_Id = 'CUCHECK' And
    ((Extract(Year From Ledger_Date) = Extract(Year From Sysdate)) Or (Extract(Month From Ledger_Date) > Extract(Month From Sysdate) And Extract(Year From Ledger_Date) = Extract(Year From Sysdate)-1)))
Pivot
  (Sum(Amount) For Month In (1 As Jan,2 As Feb,3 As Mar,4 As Apr,5 As May,6 As Jun,7 As Jul,8 As Aug,9 As Sep,10 As Oct,11 As Nov,12 As Dec))