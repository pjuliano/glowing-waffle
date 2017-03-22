Create Or Replace View KD_NEW_AND_CONVERTED_CUSTOMERS As
Select
  A.Salesman_Code,
  A.Salesman_Name,
  A.Customer_Id,
  A.Name,
  A.Creation_Date,
  A.Prior_Year_Sales,
  A.Current_Year_Sales,
  Null As P2y_Trilobe_Sales,
  Null As Cy_Tilobe_Sales,
  Null As CY_Tilobe_Impl_Sales,
  A.Qtr,
  'NEW' As Status
From
  Kd_New_Customers A

Union All

Select
  A.Salesman_Code,
  A.Salesman_Name,
  A.Customer_No,
  A.Customer_Name,
  Null,
  Null,
  Null,
  A.P2y_Trilobe_Sales,
  A.Cy_Tilobe_Sales,
  A.Cy_Tilobe_Impl_Sales,
  A.Qtr,
  'CONV' As Status
From
  KD_Tilobe_Conversions A