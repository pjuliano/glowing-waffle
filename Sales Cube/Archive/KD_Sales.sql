Create Or Replace View KD_Sales As

Select
    'IFS' As Source,
    InvItem.Company,
    Case When CustInfo.Corporate_Form In ('ASIA','CAN','DOMDIS','EUR','LA','SPA') Then 'DISTRIBUTION'
         When CustInfo.Corporate_Form In ('DOMDIR','FRA','GER','BENELUX','ITL','SWE') Then 'DIRECT'
         Else 'OTHER'
    End As Segment,    
    CustInfo.Corporate_Form,
    CustOrdCustAdd.Region_Code,
    CustOrd.Salesman_Code,
    PersonOut.Name As Salesman_Name,
    CustOrder.Salesman_Code As Order_Salesman_Code,
    ComRec.Commission_Receiver,
    PersonIn.Name As Commission_Receiver_Name,
    CustInfo.Association_No,
    InvHead.Identity As Customer_ID,
    CustInfo.Name As Customer_Name,
     /* Decode statements to IIMast or IIDetail account for IIs having their data stored outside InvHead or InvItem. */
    Decode(InvItem.C1,Null,client_sys.get_item_value('ORDER_NO',IIMast.head_data),InvItem.C1) As Order_ID,
    InvHead.N2 As RMA_ID,
    InvHead.N3 As RMA_Line,
    CustOrder.Market_Code,
    InvHead.Pay_Term_ID,
    InvHead.Currency As Order_Currency,
    To_Char(InvHead.D1,'YYYY') As Order_Entry_Year,
    To_Char(InvHead.D1,'Q') As Order_Entry_Quarter,
    To_Char(InvHead.D1,'MM') As Order_Entry_Month,
    Trunc(InvHead.D1) as Order_Entry_Date,
    To_Char(InvHead.Invoice_Date,'YYYY') As Invoice_Year,
    To_Char(InvHead.Invoice_Date,'Q') As Invoice_Quarter,
    To_Char(InvHead.Invoice_Date,'MM') As Invoice_Month,
    Trunc(InvHead.Invoice_Date) As Invoice_Date,
    InvHead.Series_ID || InvHead.Invoice_No As Invoice_ID,
    To_Char(InvItem.Item_ID) As Item_ID,
    Nvl(Decode(SalChar.Charge_Group,'FREIGHT',SalChar.Charge_Group,InventPart.Part_Product_Code),'OTHER') As Part_Product_Code,
    Nvl(Decode(SalChar.Charge_Group,'FREIGHT',SalChar.Charge_Group,InventPart.Part_Product_Family),'OTHER') As Part_Product_Family,
    Nvl(Decode(SalChar.Charge_Group,'FREIGHT',SalChar.Charge_Group,InventPart.Second_Commodity),'OTHER') As Second_Commodity,
    Decode(InvItem.C5,Null,IIDetail.Object,InvItem.C5) As Catalog_No,
    Decode(InvItem.C6,Null,IIDetail.Description,InvItem.C6) As Catalog_Desc,
    Case When InvHead.Series_ID = 'CR' And 
              InvHead.N2 Is Null --Credit without RMA number and no product physically returned.
         Then 0
         When InvHead.Series_ID = 'CR' And 
              InvHead.N2 Is Not Null --Credit with RMA number.
         Then InvItem.N2 * -1 --Invert the quantity.
         Else InvItem.N2
    End As Invoiced_Qty,
    Decode(SalChar.Charge_Group,'FREIGHT',SalChar.Charge_Amount,SalesPart.List_Price) As Current_List_Price,
    InvItem.Net_Curr_Amount / Nullif(InvItem.N2,0) As Unit_Price,
    InvItem.Net_Curr_Amount Total_Price,
    Decode(InvHead.N1,Null,IIMast.Rate_Used,InvHead.N1) As Currency_Rate,
    InvItem.Vat_Dom_Amount As Tax_Amount,
    InvItem.Vat_Code As Tax_Code
    
From
    Invoice_Tab InvHead Left Join Invoice_Item_Tab InvItem
        On InvHead.Invoice_Id = InvItem.Invoice_ID And
           Invhead.Company = InvItem.Company
                        Left Join Instant_Invoice_Master_Rpt IIMast
        On InvHead.Series_ID || InvHead.Invoice_No = IIMast.Invoice_No
                        Left Join Instant_Invoice_Detail_Rpt IIDetail
        On IIMast.Result_Key = IIDetail.Result_Key And
           IIDetail.Row_Type = 1
                        Left Join Sales_Part_Tab SalesPart
        On Decode(InvItem.C5,Null,IIDetail.Object,InvItem.C5) = SalesPart.Catalog_No And
           Decode(InvItem.Company,'241','240',InvItem.Company) = SalesPart.Contract
                        Left Join Inventory_Part_Tab InventPart
        On Decode(InvItem.C5,Null,IIDetail.Object,InvItem.C5) = InventPart.Part_No And
           Decode(InvItem.Company,'241','240',InvItem.Company) = InventPart.Contract
                        Left Join Customer_Info_Tab CustInfo
        On InvHead.Identity  = CustInfo.Customer_ID
                        Left Join Customer_Info_Address_Tab CustInfoAdd
        On InvHead.Identity  = CustInfoAdd.Customer_ID And
                           InvHead.Invoice_Address_Id = CustInfoAdd.Address_Id
                        Left Join Customer_Info_Address_Type_Tab CustInfoAddType
        On InvHead.Identity = CustInfoAddType.Customer_ID And
           CustInfoAdd.Address_ID = CustInfoAddType.Address_ID And
           CustInfoAddType.Address_Type_Code = 'INVOICE'
                        Left Join Cust_Ord_Customer_Address_Tab CustOrdCustAdd
        On InvHead.Identity  = CustOrdCustAdd.Customer_No And
           CustInfoAdd.Address_Id = CustOrdCustAdd.Addr_No
                        Left Join Cust_Ord_Customer_Tab CustOrd
        On InvHead.Identity  = CustOrd.Customer_No
                        Left Join Customer_Order_Tab CustOrder
        On InvItem.C1 = CustOrder.Order_No And
           InvItem.Company = CustOrder.Contract
                        Left Join Cust_Def_Com_Receiver_Tab ComRec
        On InvHead.Identity  = ComRec.Customer_No
                        Left Join Commission_Receiver_Tab ComRecDef
        On ComRec.Commission_Receiver = ComRecDef.Commission_Receiver
                        Left Join Person_Info_Tab PersonOut --For Outside Rep names
        On CustOrd.Salesman_Code = PersonOut.Person_ID
                        Left Join Person_Info_Tab PersonIn --For Inside Rep names
        On ComRecDef.Salesman_Code = PersonIn.Person_ID
                        Left Join Customer_Order_Address_Tab CustOrdAdd
        On InvItem.C1 = CustOrdAdd.Order_No
                        Left Join Sales_Charge_Type_Tab SalChar
        On InvItem.C5 = SalChar.Charge_Type

Where
    InvHead.Series_ID != 'CI' And
    InvHead.Party_Type = 'CUSTOMER' And
    InvHead.RowState != 'Preliminary' And
    InvHead.RowState != 'Cancelled'