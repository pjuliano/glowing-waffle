Create Or Replace View Kd_Customer_Payments As
Select
  *
From
( Select
    Identity,
    Name,
    Extract(Month From Voucher_Date) As Month,
    Full_Curr_Amount As Inv_Amount
  From
    Check_Ledger_Item
  Where
    ((Extract(Year From Payment_Date) = Extract(Year From Sysdate)) Or
     (Extract(Month From Payment_Date) > Extract(Month From Sysdate) And 
      Extract(Year From Payment_Date) = Extract(Year From Sysdate)-1)) And
      Way_Id In ('CHK','CC','AMEX','VISA','MASTERCARD','SVBLB','BOMLB') And
      Ledger_Item_Series_Id = 'CUCHECK')
Pivot
( Sum(Inv_Amount) For Month In (1 As Jan,2 As Feb,3 As Mar,4 As Apr,5 As May,6 As Jun,7 As Jul,8 As Aug,9 As Sep,10 As Oct,11 As Nov,12 As Dec));