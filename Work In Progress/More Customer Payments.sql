Select * From Check_Ledger_Item ;

Select
    Sum(Full_Curr_Amount) As Inv_Amount
  From
    Check_Ledger_Item
  Where
    ((Extract(Year From Payment_Date) = Extract(Year From Sysdate)) Or
     (Extract(Month From Payment_Date) > Extract(Month From Sysdate) And 
      Extract(Year From Payment_Date) = Extract(Year From Sysdate)-1)) And
      Way_Id In ('CHK','CC','AMEX','VISA','MASTERCARD','SVBLB','BOMLB','WIRE','CHLB','DISCOVER','DISCOV') And
      Objstate = 'Cashed' And
      Company = '100' And
      Party_Type = 'Customer'