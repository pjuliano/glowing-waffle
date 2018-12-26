Select
    Person_Info_Api.Get_Name(Cust_Ord_Customer_Api.Get_Salesman_Code(CO.Customer_No)) As Salesman_Name,
    CO.Customer_No,
    CI.Name,
    CO.Order_No,
    CC.Charge_Type,
    SC.Charge_Type_Desc,
    Decode(SC.Charge_Amount,Null,0,SC.Charge_Amount) As List_Charge_Amt,
    CC.Charge_Amount As Actual_Charge_Amt,
    CC.Charge_Amount - Decode(SC.Charge_Amount,Null,0,SC.Charge_Amount) As Charge_Discount,
    CO.Ship_Via_Code,
    SV.Description,
    Case When CO.Ship_Via_Code In ('BW2','BW3','FX2','UP2') Then 17
         When CO.Ship_Via_Code = 'FAM' Then 19
         When CO.Ship_Via_Code = 'FX1' Then 69
         When CO.Ship_Via_Code = 'BWG' Then 11
         When CO.Ship_Via_Code In ('BWP','FXP') Then 27
         When CO.Ship_Via_Code = 'BWS' Then 21
         When CO.Ship_Via_Code = 'UPP' Then 21
         When CO.Ship_Via_Code = 'FIP' Then 25
         When CO.Ship_Via_Code = 'FIE' Then 20
         Else Null
    End As Ship_Code_Amt,
    CC.Charge_Amount -
    Case When CO.Ship_Via_Code In ('BW2','BW3','FX2','UP2') Then 17
         When CO.Ship_Via_Code = 'FAM' Then 19
         When CO.Ship_Via_Code = 'FX1' Then 69
         When CO.Ship_Via_Code = 'BWG' Then 11
         When CO.Ship_Via_Code In ('BWP','FXP') Then 27
         When CO.Ship_Via_Code = 'BWS' Then 21
         When CO.Ship_Via_Code = 'UPP' Then 21
         When CO.Ship_Via_Code = 'FIP' Then 25
         When CO.Ship_Via_Code = 'FIE' Then 20
         Else Null
    End As Actual_Shipping_Discount,
    Sum(FI.Line_Package_Charge) As Actual_Shipping_Cost,
    CY.CYSales
From
    Customer_Order CO Left Join Customer_Order_Charge CC
        On CO.Order_No = CC.Order_No
                      Left Join Customer_Info CI
        On CO.Customer_No = CI.Customer_ID
                      Left Join Sales_Charge_Type SC 
        On CC.Charge_Type = SC.Charge_Type
                      Left Join MPCCOM_Ship_Via SV
        On CO.Ship_Via_Code = SV.Ship_Via_Code
                      Left Join Ps_Freight_Info_Co FI
        On CO.Order_No = FI.Order_No
                      Left Join KD_CY_Sales CY
        On Co.Customer_No = CY.Customer_No
Where
    Extract(Year From CO.Date_Entered) = Extract(Year From Sysdate) And
    CO.State = 'Invoiced/Closed' And
    CI.Corporate_Form = 'DOMDIR' And
    CO.Order_No Not Like 'X%' And
    CO.Order_No Not Like 'W%'
Group By
    Person_Info_Api.Get_Name(Cust_Ord_Customer_Api.Get_Salesman_Code(CO.Customer_No)),
    CO.Customer_No,
    CI.Name,
    CO.Order_No,
    CC.Charge_Type,
    SC.Charge_Type_Desc,
    Decode(SC.Charge_Amount,Null,0,SC.Charge_Amount),
    CC.Charge_Amount,
    CC.Charge_Amount - Decode(SC.Charge_Amount,Null,0,SC.Charge_Amount),
    CO.Ship_Via_Code,
    SV.Description,
    Case When CO.Ship_Via_Code In ('BW2','BW3','FX2','UP2') Then 17
         When CO.Ship_Via_Code = 'FAM' Then 19
         When CO.Ship_Via_Code = 'FX1' Then 69
         When CO.Ship_Via_Code = 'BWG' Then 11
         When CO.Ship_Via_Code In ('BWP','FXP') Then 27
         When CO.Ship_Via_Code = 'BWS' Then 21
         When CO.Ship_Via_Code = 'UPP' Then 21
         When CO.Ship_Via_Code = 'FIP' Then 25
         When CO.Ship_Via_Code = 'FIE' Then 20
         Else Null
    End,
    CC.Charge_Amount -
    Case When CO.Ship_Via_Code In ('BW2','BW3','FX2','UP2') Then 17
         When CO.Ship_Via_Code = 'FAM' Then 19
         When CO.Ship_Via_Code = 'FX1' Then 69
         When CO.Ship_Via_Code = 'BWG' Then 11
         When CO.Ship_Via_Code In ('BWP','FXP') Then 27
         When CO.Ship_Via_Code = 'BWS' Then 21
         When CO.Ship_Via_Code = 'UPP' Then 21
         When CO.Ship_Via_Code = 'FIP' Then 25
         When CO.Ship_Via_Code = 'FIE' Then 20
         Else Null
    End,
    CY.CYSales