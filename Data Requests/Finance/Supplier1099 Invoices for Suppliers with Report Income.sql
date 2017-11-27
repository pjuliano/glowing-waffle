Select Income_Type_Per_Supplier_Api.Get_Default_Income_Type('100',A.Identity,A.Party_Type_Db) As Income_Type_Identity, 
       B.*
  From Identity_Invoice_Info A,
	     Incoming_Invoice2 B
 Where A.Party_Type_Db = 'SUPPLIER' 
   And A.Report_And_Withhold_Db = 'REPORT_INCOME'
	 And A.Identity = B.Identity
	 And Extract(Year From B.Invoice_Date) = 2017
	 And B.State = 'PaidPosted'