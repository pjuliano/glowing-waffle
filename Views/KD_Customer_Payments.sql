Create or Replace View KD_Customer_Payments As
Select
  *
From 
( Select
    Identity,
    Name,
    Extract(Month From Payment_Date) As Month,
    Inv_Amount
  From
    Pay_Doc_Followup_Qry
  Where
  ((Extract(Year From Payment_Date) = Extract(Year From Sysdate)) Or
   (Extract(Month From Payment_Date) > Extract(Month From Sysdate) And 
    Extract(Year From Payment_Date) = Extract(Year From Sysdate) - 1)) And
    Objstate != 'Cancelled')
Pivot
( Sum(Inv_Amount) For Month In (1 As Jan,2 As Feb,3 As Mar,4 As Apr,5 As May,6 As Jun,7 As Jul,8 As Aug,9 As Sep,10 As Oct,11 As Nov,12 As Dec));