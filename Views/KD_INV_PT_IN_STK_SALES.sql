Create Or Replace View KD_INV_PT_IN_STK_SALES As
With Sales As   (
                Select
                    Catalog_No,
                    Part_Product_Family,
                    Part_Product_Code,
                    Sum(Case When A.InvoiceDate >= Trunc(Sysdate)-30 Then A.Invoiced_Qty Else 0 End) As Last30Days,
                    Round(Sum(A.Invoiced_Qty)/6) As Avg6Months
                From
                    IFSAPP.KD_Sales_Data_Request A
                Where
                    A.InvoiceDate >= Add_Months(Sysdate,-6)
                Group By
                    Catalog_No,
                    Part_Product_Family,
                    Part_Product_Code
                )   
Select
    Decode(Ifsapp.Inventory_Part_Api.Get_Part_Cost_Group_ID(Contract,Part_No),'PALTP','PALTOP','KEYSTONE') As Division,
    Contract,
    Ifsapp.Inventory_Part_Api.Get_Part_Product_Family(Contract,Part_No) As Part_Product_Family,
    Ifsapp.Inventory_Part_Api.Get_Part_Product_Code(Contract,Part_No) As Part_Product_Code,
    Part_No,
    Ifsapp.Inventory_Part_Api.Get_Description (Contract,Part_No) Part_Description,
    Configuration_Id,
    --Location_No,
    --Lot_Batch_No,
    --Serial_No,
    --Ifsapp.Condition_Code_Manager_Api.Get_Condition_Code (Part_No,Serial_No,Lot_Batch_No) Condition_Code,
    --Ifsapp.Condition_Code_Api.Get_Description (Ifsapp.Condition_Code_Manager_Api.Get_Condition_Code (Part_No,Serial_No,Lot_Batch_No)) Condition_Code_Description,
    Eng_Chg_Level,
    --Waiv_Dev_Rej_No,
    --Activity_Seq,
    --Warehouse,
    --Bay_No,
    --Row_No,
    --Tier_No,
    --Bin_No,
    --Rotable_Part_Pool_Id,
    Sum(Qty_Onhand) As Total_Qty_OnHand,
    --Ifsapp.Inventory_Part_Api.Get_User_Default_Converted_Qty (Contract,Part_No,Qty_Onhand,'REMOVE') Unified_On_Hand_Qty,
    Sum(Qty_Reserved) As Total_Qty_Reserved,
    --Ifsapp.Inventory_Part_Api.Get_User_Default_Converted_Qty (Contract,Part_No,Qty_Reserved,'REMOVE') In_Transit,
    Sum(Qty_In_Transit) As Total_Qty_In_Transit,
    --Ifsapp.Inventory_Part_Api.Get_User_Default_Converted_Qty (Contract,Part_No,Qty_In_Transit,'REMOVE') Unified_Qty_In_Transit,
    Sum(Qty_Onhand - Qty_Reserved) As Total_Available_Qty,
    Ifsapp.Inventory_Part_Api.Get_Unit_Meas (Contract,Part_No) Uom,
    --Ifsapp.Inventory_Part_Api.Get_User_Default_Unit_Meas (Part_No) Unified_Uom,
    --Last_Activity_Date,
    --Last_Count_Date,
    --Location_Type,
    --Receipt_Date,
    --Availability_Control_Id,
    --Ifsapp.Part_Availability_Control_Api.Get_Description (Availability_Control_Id) Availability_Control_Id_Desc,
    --Avg_Unit_Transit_Cost,
    --Count_Variance,
    --Expiration_Date,
    --Ifsapp.Inventory_Part_In_Stock_Api.Get_Company_Owned_Unit_Cost (Contract,Part_No,Configuration_Id,Location_No,Lot_Batch_No,Serial_No,Eng_Chg_Level,Waiv_Dev_Rej_No,Activity_Seq) Unit_Cost,
    --(Ifsapp.Inventory_Part_In_Stock_Api.Get_Company_Owned_Unit_Cost (Contract,Part_No,Configuration_Id,Location_No,Lot_Batch_No,Serial_No,Eng_Chg_Level,Waiv_Dev_Rej_No,Activity_Seq)) * Qty_Onhand Total_Inventory_Value,
    --Ifsapp.Company_Finance_Api.Get_Currency_Code (Ifsapp.Site_Api.Get_Company (Contract)) Base_Currency,
    --Part_Ownership,
    Nvl(Sales.last30days,0) SalesLast30Days,
    Nvl(Sales.avg6months,0) SalesAvgLast6Months
From
    Ifsapp.Inventory_Part_In_Stock Left Join Sales
        On Part_No = Catalog_No
Where
    Ifsapp.Inventory_Part_In_Stock.Contract = '100' And
    Ifsapp.Inventory_Part_In_Stock.Warehouse != 'CONS' 
Group By 
    Decode(Ifsapp.Inventory_Part_Api.Get_Part_Cost_Group_ID(Contract,Part_No),'PALTP','PALTOP','KEYSTONE'),
    Contract, 
    IFSAPP.Inventory_Part_Api.Get_Part_Product_Family(Contract,Part_No),
    Ifsapp.Inventory_Part_Api.Get_Part_Product_Code(Contract,Part_No),
    Part_No, 
    Ifsapp.Inventory_Part_Api.Get_Description (Contract,Part_No), 
    Configuration_Id, 
    Eng_Chg_Level,
    Ifsapp.Inventory_Part_Api.Get_Unit_Meas (Contract,Part_No), 
    Nvl(Sales.last30days,0), 
    Nvl(Sales.avg6months,0)