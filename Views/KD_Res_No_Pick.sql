Create Or Replace View KD_Res_No_Pick As
Select
  A.Date_Entered,
  A.Customer_No,
  A.Order_No,
  'Print picklist for customer order.' As Action
From
  Customer_Order A
Where
  A.State = 'Reserved' And 
  A.BackOrder_Option_DB != 'NO PARTIAL DELIVERIES ALLOWED' And (
  Select
    Count(Z.Order_No)
  From
    Customer_Order Z,
    Customer_Order_History Y
  Where
    Z.Order_No = Y.Order_No And
    Z.Order_No = A.Order_No And
    Y.Message_Text Like 'Picklist%created') = 0;