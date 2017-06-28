Create Or Replace View KD_Customer_Accounting_Hist As
Select
  A.Identity,
  Customer_Info_Api.Get_Name(A.Identity) As Name,
  A.Ledger_Date,
  A.Ledger_Item_Series_Id,
  A.Ledger_Item_ID,
  A.Inv_Amount,
  Ledger_Item_Util_Api.Get_Dom_Balance(A.Company,A.Identity,Customer_Info_Api.Get_Party_Type(A.Identity),To_Date(Extract(Month From A.Ledger_Date) || '/01/' || Extract(Year From A.Ledger_Date),'MM/DD/YYYY'),0) As Ledger_Month_Beginning_Balance,
  Ledger_ITem_Util_Api.Get_Dom_Balance(A.Company,A.Identity,Customer_Info_Api.Get_Party_Type(A.Identity),Trunc(Sysdate),0) As Current_Balance
From
  Ledger_Item_Cu_Det_Qry A
Where
  A.Ledger_Item_Series_Id In ('II','CD','CUCHKPOA','CR') And
  Customer_Info_Api.Get_Country(A.Identity) In ('UNITED STATES','CANADA')
Order By
  A.Identity,
  A.Ledger_Date Asc;