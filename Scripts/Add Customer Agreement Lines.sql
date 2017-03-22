Declare
   A_ Varchar2(32000) := Null; --p0
   B_ Varchar2(32000) := Null; --p1
   C_ Varchar2(32000) := Null; --p2
   D_ Varchar2(32000) := 'AGREEMENT_ID'||Chr(31)||'B2966M'||Chr(30)||'CATALOG_NO'||Chr(31)||'15613K'||Chr(30)||'BASE_PRICE_SITE'||Chr(31)||'100'||Chr(30)||'BASE_PRICE'||Chr(31)||'335'||Chr(30)||'MIN_QUANTITY'||Chr(31)||'0'||Chr(30)||'VALID_FROM_DATE'||Chr(31)||'2017-03-06-00.00.00'||Chr(30)||'PERCENTAGE_OFFSET'||Chr(31)||'0'||Chr(30)||'AMOUNT_OFFSET'||Chr(31)||'0'||Chr(30)||'DEAL_PRICE'||Chr(31)||'100'||Chr(30)||'NET_PRICE_DB'||Chr(31)||'FALSE'||Chr(30)||'PROVISIONAL_PRICE_DB'||Chr(31)||'FALSE'||Chr(30)||'LAST_UPDATED'||Chr(31)||'2017-03-06-00.00.00'||Chr(30)||'PRICE_BREAK_TEMPLATE_ID'||Chr(31)||''||Chr(30); --p3
   E_ Varchar2(32000) := 'DO'; --p4
Begin
  For Cur In (Select A.*, Sales_Part_Api.Get_List_Price(A.Site,A.Part) As Base_Price, (To_Char(Sysdate,'YYYY-MM-DD') || '-00:00:00') As Valid_From_Date From Kd_Customer_Agreement_Upload A Where (Status != 'FAILED' OR Status IS Null))
  Loop
    Update Kd_Customer_Agreement_Upload A Set A.Status = 'FAILED' Where A.Part = Cur.Part;
    Commit;
    A_ := Null;
    B_ := Null;
    C_ := Null;
    D_ := 'AGREEMENT_ID'||Chr(31)||Cur.Agreement||Chr(30)||'CATALOG_NO'||Chr(31)||Cur.Part||Chr(30)||'BASE_PRICE_SITE'||Chr(31)||Cur.Site||Chr(30)||'BASE_PRICE'||Chr(31)||Cur.Base_Price||Chr(30)||'MIN_QUANTITY'||Chr(31)||'0'||Chr(30)||'VALID_FROM_DATE'||Chr(31)||Cur.Valid_From_Date||Chr(30)||'PERCENTAGE_OFFSET'||Chr(31)||'0'||Chr(30)||'AMOUNT_OFFSET'||Chr(31)||'0'||Chr(30)||'DEAL_PRICE'||Chr(31)||Cur.Price||Chr(30)||'NET_PRICE_DB'||Chr(31)||'FALSE'||Chr(30)||'PROVISIONAL_PRICE_DB'||Chr(31)||'FALSE'||Chr(30)||'LAST_UPDATED'||Chr(31)||Cur.Valid_From_Date||Chr(30)||'PRICE_BREAK_TEMPLATE_ID'||Chr(31)||''||Chr(30);
    E_ := 'DO';
    Ifsapp.Agreement_Sales_Part_Deal_Api.New__( A_ , B_ , C_ , D_ , E_ );
    Update Kd_Customer_Agreement_Upload A Set A.Status = 'SUCCESS';
    Commit;
  End Loop;
End;