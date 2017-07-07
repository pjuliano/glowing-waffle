Create Or Replace View Coordinator_Planner_Releaser As
Select
  A.Order_No,
  A.Invoice_Id,
  A.Invoicedate,
  Extract(Year From A.Invoicedate) As Year,
  A.Invoiceqtr As Quarter,
  Extract(Month From A.Invoicedate) As Month,
  Case When A.Part_Product_Code In ('PROS','ORCAN','TLNG','IMPL','KITSI','KITPR','KTIPI','INSTR','PROST')
       Then 'IMPL'
       When A.Part_Product_Code In ('REGEN','RSMPL') 
       Then 'REGEN'
       Else 'OTHER'
  End As Product_Type,
  A.Region_Code,
  Person_Info_Api.Get_Name(A.Salesman_Code) As Rep_Name,
  A.Authorize_Code As Coordinator,
  Max(Person_Info_Api.Get_Name((Select Userid From Customer_Order_History Z Where A.Order_No = Z.Order_No And Z.State = 'Planned' And Z.Message_Text = 'Planned'))) As Planner,
  Max(Person_Info_Api.Get_Name((Select Y.Userid From Customer_Order_History Y Where Y.State = 'Released' And Y.Message_Text = 'Released' And Y.Order_No = A.Order_No And (Select Max(X.Objversion) From Customer_Order_History X Where X.State = 'Released' And X.Message_Text = 'Released' And X.Order_No = A.Order_No) = Y.Objversion))) As Releaser,
  Sum(A.Allamounts) As AllAmounts
From
  Kd_Sales_Data A
Where
  A.Charge_Type = 'Parts' And
  A.Corporate_Form In ('CAN','DOMDIR') And A.InvoiceMthyr = '06/2017'
Group By
  A.Order_No,
  A.Invoice_Id,
  A.Invoicedate,
  Extract(Year From A.Invoicedate),
  A.Invoiceqtr,
  Extract(Month From A.Invoicedate),
  Case When A.Part_Product_Code In ('PROS','ORCAN','TLNG','IMPL','KITSI','KITPR','KTIPI','INSTR','PROST')
       Then 'IMPL'
       When A.Part_Product_Code In ('REGEN','RSMPL') 
       Then 'REGEN'
       Else 'OTHER'
  End,
  A.Region_Code,
  Person_Info_Api.Get_Name(A.Salesman_Code),
  A.Authorize_Code