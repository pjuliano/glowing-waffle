Create or Replace View KD_Rel_Not_Res As
With Order_Hist As (
                    Select
                      A.Order_No,
                      A.Message_Text,
                      Max(A.History_No) As History_No
                    From 
                      Customer_Order_History A,
                      Customer_Order B
                    Where
                      A.Order_No = B.Order_No And
                      B.State = 'Released'
                    Group By
                      A.Order_No,
                      A.Message_Text),
     Order_Line As (
                    Select 
                      A.Order_No,
                      Sum(A.Desired_Qty) Desired_Qty,
                      Sum(A.Qty_Short) Short_Qty
                    From 
                      Customer_Order_Line A,
                      Customer_Order B
                    Where
                      A.Order_No = B.Order_No And
                      B.State = 'Released'
                    Group By
                      A.Order_No
                    Having
                      Sum(A.Desired_Qty) > Sum(A.Qty_Short))
Select
  C.Date_Entered,
  C.Customer_No,
  C.Order_No,
  'Reserve customer order lines' As Action
From
  Order_Hist A,
  Order_Line B,
  Customer_Order C
Where
  A.Order_No = B.Order_No And
  A.Order_No = C.Order_No And
  A.Message_Text = 'Credit blocked order released.';