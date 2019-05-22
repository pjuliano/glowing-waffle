Create or Replace View KD_Sales As
Select
    --Invoices from Keystone
    'IFS' As Source,
    InvItem.Company As Company,
    Case When CustInfo.Corporate_Form In ('ASIA','CAN','DOMDIS','EUR','LA','SPA') Then 'DISTRIBUTION'
         When CustInfo.Corporate_Form In ('DOMDIR','FRA','GER','BENELUX','ITL','SWE') Then 'DIRECT'
         Else 'OTHER'
    End As Segment,
    CustInfo.Corporate_Form,
    CustOrdAdd.Region_Code,
    CustOrd.Salesman_Code As Current_Salesman_Code,
    Person.Name As Current_Salesman_Name,
    CustOrder.Salesman_Code As Order_Salesman_Code,
    ComRec.Commission_Receiver,
    PersonComRec.Name As Inside_Salesman_Name,
    CustInfo.Association_No,
    CustInfo.Customer_ID,
    CustInfo.Name As Customer_Name,
    CustOrder.Order_No,
    '' AS RMA_No,
    CustOrder.Market_Code,
    CustOrder.Pay_Term_ID As Payment_Terms,
    CustOrder.Currency_Code,
    Extract(Year From CustOrder.Date_Entered) As Order_Entry_Year,
    To_Char(CustOrder.Date_Entered,'Q') As Order_Entry_Qtr,
    To_Char(CustOrder.Date_Entered,'MM') As Order_Entry_Month,
    CustOrder.Date_Entered As Order_Entry_Date,
    Extract(Year From Inv.Invoice_Date) As Invoice_Year,
    To_Char(Inv.Invoice_Date,'Q') As Invoice_Qtr,
    To_Char(Inv.Invoice_Date,'MM') As Invoice_Month,
    Inv.Invoice_Date,
    Inv.Series_Id || Inv.Invoice_No As Invoice_No,
    InvItem.C2 As Line_No,
    --Substr (InvItem.C3,1,4) As Release_No,
    InvPart.Part_Product_Code,
    InvPart.Part_Product_Family,
    InvPart.Second_Commodity,
    InvItem.C5 As Catalog_No,
    InvItem.C6 As Description,
    InvItem.N2 As Invoiced_Qty,
    SalesPart.List_Price As Current_List_Price,
    InvItem.N4 As Unit_Price,
    (SalesPart.List_Price - InvItem.N4) As Unit_Discount,
    (SalesPart.List_Price * InvItem.N2) - (InvItem.N2 * InvItem.N4) As Total_Discount,
    (InvItem.N2 * InvItem.N4) As Total_Price,
    InvItem.Vat_Dom_Amount As Tax_Amount,
    InvItem.Vat_Code As Tax_Code
From
    Customer_Info_Tab CustInfo Left Join Customer_Info_Address_Tab CustAddDeliv
        On CustInfo.Customer_ID = CustAddDeliv.Customer_ID
                               Left Join Customer_Info_Address_Type_Tab CustAddTypeDeliv
        On CustAddDeliv.Customer_ID = CustAddTypeDeliv.Customer_ID And
           CustAddDeliv.Address_ID = CustAddTypeDeliv.Address_ID And
           CustAddTypeDeliv.Address_Type_Code = 'DELIVERY'
                               Left Join Cust_Ord_Customer_Address_Tab CustOrdAdd
        On CustInfo.Customer_Id = CustOrdAdd.Customer_No And
           CustAddDeliv.Address_ID = CustOrdAdd.Addr_No
                               Left Join Cust_Ord_Customer_Tab CustOrd
        On CustInfo.Customer_ID = CustOrd.Customer_No
                               Left Join Person_Info_Tab Person
        On CustOrd.Salesman_Code = Person.Person_ID
                               Left Join Cust_Def_Com_Receiver_Tab ComRec
        On CustInfo.Customer_ID = ComRec.Customer_No
                               Left Join Commission_Receiver_Tab ComRecDef
        On ComRec.Commission_Receiver = ComRecDef.Commission_Receiver
                               Left Join Person_Info_Tab PersonComRec
        On ComRecDef.Salesman_Code = PersonComRec.Person_ID
                               Left Join Customer_Order_Tab CustOrder
        On CustInfo.Customer_Id = CustOrder.Customer_No,

    Invoice_Tab Inv Left Join Invoice_Item_Tab InvItem
        On Inv.Company = InvItem.Company And
           Inv.Invoice_ID = InvItem.Invoice_ID
                    Left Join Inventory_Part_Tab InvPart
        On Inv.Company = InvPart.Contract And
           InvItem.C5 = InvPart.Part_No
                    Left Join Sales_Part_Tab SalesPart 
        On Inv.Company = SalesPart.Contract And
           InvItem.C5 = SalesPart.Catalog_No

Where
    CustAddTypeDeliv.Def_Address = 'TRUE' And
    CustOrder.Order_No = InvItem.C1 And
    InvItem.Party_Type = 'CUSTOMER' And
    InvItem.Creator = 'CUSTOMER_ORDER_INV_ITEM_API'

    --And CustOrder.Order_No = 'C525174'
    And CustOrder.Order_No = 'C525241'
