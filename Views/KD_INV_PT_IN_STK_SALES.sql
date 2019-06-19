Create Or Replace View KD_INV_PT_IN_STK_SALES As
With Sales As   
    (
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
    Decode(ip.part_cost_group_id,'PALTP','PALTOP','KEYSTONE') As Division,
    ip.Contract,
    ip.part_product_family As Part_Product_Family,
    ip.part_product_code As Part_Product_Code,
    ip.Part_No,
    ip.description Part_Description,
    ipis.Configuration_Id,
    ipis.Eng_Chg_Level,
    Sum(ipis.Qty_Onhand) As Total_Qty_OnHand,
    Sum(ipis.Qty_Reserved) As Total_Qty_Reserved,
    Sum(ipis.Qty_In_Transit) As Total_Qty_In_Transit,
    Sum(ipis.Qty_Onhand - Qty_Reserved) As Total_Available_Qty,
    ip.unit_meas AS Uom,
    Nvl(Sales.last30days,0) SalesLast30Days,
    Nvl(Sales.avg6months,0) SalesAvgLast6Months
From
    Inventory_Part ip
        LEFT JOIN Ifsapp.Inventory_Part_In_Stock ipis ON
            ip.contract = ipis.contract
            AND ip.part_no = ipis.part_no
        LEFT JOIN Sales ON
            ip.Part_No = sales.Catalog_No
Where
    ipis.Contract = '100' And
    ipis.Warehouse != 'CONS' 
Group By 
    Decode(ip.part_cost_group_id,'PALTP','PALTOP','KEYSTONE'),
    ip.Contract, 
    ip.part_product_family,
    ip.part_product_code,
    ip.Part_No, 
    ip.description, 
    ipis.Configuration_Id, 
    ipis.Eng_Chg_Level,
    ip.unit_meas, 
    Nvl(Sales.last30days,0), 
    Nvl(Sales.avg6months,0)
HAVING
    Nvl(Sales.last30days,0) + Nvl(Sales.avg6months,0) + NVL(SUM(ipis.qty_onhand),0) != 0 