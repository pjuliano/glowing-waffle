Select
  Decode(A.Company,'241','240',A.Company) As Site,
  A.Series_Id || A.Invoice_No As Invoice_Id,
  A.Item_Id,
  A.Invoice_Date As Invoicedate,
  Case When A.Series_Id = 'CR' And A.Rma_No Is Null
       Then 0
       When A.Series_Id = 'CR' And A.Rma_No Is Not Null
       Then A.Invoiced_Qty * -1
       Else A.Invoiced_Qty
  End As Invoiced_Qty,
  A.Sale_Unit_Price,
  A.Discount,
  A.Net_Curr_Amount,
  A.Gross_Curr_Amount,
  A.Description As Catalog_Desc,
  A.Name As Customer_Name,
  A.Order_No,
  A.Identity As Customer_No,
  Cust_Ord_Customer_Api.Get_Cust_Grp(A.Identity) As Cust_Grp,
  A.Catalog_No,
  Customer_Order_Api.Get_Authorize_Code(A.Order_No) As Authorize_Code,
  Cust_Ord_Customer_Api.Get_Salesman_Code(A.Identity) As Salesman_Code,
  B.Commission_Receiver,
  Cust_Ord_Customer_Address_Api.Get_District_Code(A.Identity,Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Pay')) As District_Code,
  Cust_Ord_Customer_Address_Api.Get_Region_Code(A.Identity,Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Pay')) As Region_Code,
  Invoice_Api.Get_Creation_Date(A.Company,A.Identity,A.Party_Type, A.Invoice_ID) As CreateDate,
  Inventory_Part_Api.Get_Part_Product_Code(Decode(A.Contract,'241','240',A.Contract),A.Catalog_No) As Part_Product_Code,
  Inventory_Part_Api.Get_Part_Product_Family(Decode(A.Contract,'241','240',A.Contract),A.Catalog_No) As Part_Product_Family,
  Inventory_Part_Api.Get_Second_Commodity(Decode(A.Contract,'241','240',A.Contract),A.Catalog_No) As Second_Commodity,
  To_Char(A.Invoice_Date,'Month') As Invoice_Month,
  'QTR' || To_Char(A.Invoice_Date,'Q') As Invoiceqtr,
  'QTR' || To_Char(A.Invoice_Date,'Q') || '/' || To_Char(A.Invoice_Date,'YYYY') As Invoiceqtryr,
  To_Char(A.Invoice_Date,'MM/YYYY') As Invoicemthyr,
  Identity_Invoice_Info_Api.Get_Group_Id(Company,A.Identity,A.PArty_TYpe) As Group_ID,
  Sales_Part_Api.Get_Sales_Price_Group_Id(A.Contract,A.Catalog_No) As Type_Designation,
  Decode(Customer_Order_Api.Get_Customer_No_Pay(A.Order_No),Null,A.Identity) As Customer_No_Pay,
  C.Corporate_Form,
  Decode(Customer_Order_Api.Get_Currency_Code(A.Order_No),'SEK',(A.Net_Curr_Amount * 1.4),'DKK',(A.Net_Curr_Amount * 0.13),A.Net_Curr_Amount) As Fixedamounts,
  Case When Customer_Order_Api.Get_Currency_Code(A.Order_No) = 'CAD' And A.Invoice_Date >= To_Date('03/01/2013','MM/DD/YYYY')
       Then A.Net_Curr_Amount
       When Customer_Order_Api.Get_Currency_Code(A.Order_No) != 'USD'
       Then A.Net_Curr_Amount * D.Currency_Rate
       Else A.Net_Curr_Amount
  End As Allamounts,
  Case When Customer_Order_Api.Get_Currency_Code(A.Order_No) In ('SEK','DKK')
       Then A.Net_Curr_Amount / E.Currency_Rate
       Else A.Net_Curr_Amount
  End As Localamount,
  A.Net_Curr_Amount As TrueLocalAmt,
  A.Vat_Dom_Amount,
  A.Vat_Code,
  Case When A.Catalog_No = F.Part_No 
       Then F.Inventory_Value
       Else G.Inventory_Value * 1.4
  End As Cost, 
  --Charge Type, 
  'IFS' As Source,
  Customer_Order_Api.Get_Market_Code(A.Order_No) As Market_Code,
  Customer_Info_Api.Get_Association_No(A.Identity) As Association_No,
  A.Vat_Curr_Amount,
  Payment_Term_Api.Get_Description(A.Company,Customer_Order_Api.Get_Pay_Term_Id(A.Order_No)) As Pay_Term_Desc,
  Person_Info_Api.get_Name(Customer_Order_Api.Get_Authorize_Code(A.Order_No)) as KD_Reference,
  --cust reference, deliv date, ship via, deliv id, identity, deliv add id, inv add id,
  Customer_Order_Api.Get_Currency_Code(A.Order_No) As Currency,
  A.Rma_No
  --Inv add, deliv add
From
  Customer_Order_Inv_Join A Left Join Cust_Def_Com_Receiver B
    On A.Identity = B.Customer_No
                            Left Join Customer_Info C
    On A.Identity = C.Customer_Id
                            Left Join Kd_Currency_Rate_4 D
    On Customer_Order_Api.Get_Currency_Code(A.Order_No) = D.Currency_Code And
       To_Char(A.Invoice_Date,'MM/YYYY') = D.Valid_From
                            Left Join Kd_Currency_Rate_1 E
    On Customer_Order_Api.Get_Currency_Code(A.Order_No) = E.Currency_Code And
       To_Char(A.Invoice_Date,'MM/YYYY') = E.Valid_From
                            Left Join Kd_Cost_100 F
    On A.Catalog_No = F.Part_No 
                            Left Join Kd_Cost_210 G
    On A.Catalog_No = G.Part_No
Where
  A.Client_State = 'PaidPosted' And
  A.Order_No Not Like 'R%' And
  A.Invoice_Date = Trunc(Sysdate-1)