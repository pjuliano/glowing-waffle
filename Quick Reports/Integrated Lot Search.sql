Select A.Part_No,
       B.Description,
			 A.Lot_Batch_No,
			 B.Part_Product_Code,
			 B.Part_Product_Family,
			 C.Customer_No, 
       D.Name,                                             
			 A.Order_No || '-' || A.Release_No || '-' || A.Sequence_No As Order_No,
			 A.Quantity,
			 A.Date_Applied,
			 A.Expiration_Date
  From Ifsapp.Inventory_Transaction_Hist A,
	     Ifsapp.Inventory_Part B,
			 Ifsapp.Customer_Order C,
       Ifsapp.Customer_Info D
 Where A.Part_No = B.Part_No
   And A.Contract = B.Contract
	 And A.Order_No = C.Order_No
	 And A.Contract = C.Contract
   And C.Customer_No=D.Customer_Id
	 And A.Transaction_Code = 'OESHIP'
	 And Upper(A.Part_No) Like Upper('&Part_No')
	 And Upper(C.Customer_No) Like Upper('&Customer_No')
	 And A.Lot_Batch_No Like '&LotBatch_No'
	 And Upper(A.Order_No) Like Upper('&Order_No')
	 And A.Contract Like '&Site'
	 
   
Union All

Select A.Lineitemnumber,
       A.Item_Desc,
			 A.Lotnumber,
			 Null,
			 Null,
			 A.Customerid,
       Null,
			 A.Conumber || '-' || A.Invoicelinenumber As Order_No,
			 A.Shipquantity,
			 To_Date(A.Invoicedate,'MM/DD/YYYY'),
			 Null
  From Ifsinfo.Kd_Fourthshift A
 Where Upper(A.Lineitemnumber) Like Upper('&Part_No')
   And Upper(A.Conumber) Like Upper('&Order_No')
	 And Upper(A.Customerid) Like Upper('&Customer_No')
	 And Upper(A.Lotnumber) Like Upper('&LotBatch_No')
	 
Union All

Select A.Product_Code,
       A.Description,
			 A.Externallotnumber,
			 Null,
			 Null,
			 A.Key_Code,
       Null,
			 A.Sales_Order || '-' || A.Linenumber,
			 A.Qty,
			 A.Invoice_Date,
			 Null
  From Ifsinfo.Kd_Si_Shipment_Data A
 Where Upper(A.Product_Code) Like Upper('&Part_No')
   And Upper(A.Sales_Order) Like Upper('&Order_No')
	 And Upper(A.Key_Code) Like Upper('&Customer_No')
	 And Upper(A.Externallotnumber) Like Upper('&LotBatch_No')