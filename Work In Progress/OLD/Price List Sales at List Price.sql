SELECT
    *
FROM ( WITH Plcs as ( SELECT
    A.Customer_Id,
    LISTAGG(B.Price_List_No,', ') WITHIN GROUP(
        ORDER BY
            A.Customer_Id,A.Name
    ) AS Price_Lists
FROM
    Customer_Info A,
    Customer_Pricelist_Ent B,
    Sales_Price_List C
WHERE
    A.Customer_Id = B.Customer_Id AND
    B.Price_List_No = C.Price_List_No AND
    C.Valid_To_Date >= Trunc(SYSDATE) AND
    Kd_Get_Corporate_Form(A.Customer_Id) = 'DOMDIR'
    
GROUP BY
    A.Customer_Id,
    A.Name) SELECT
    A.Customer_No,
    A.Customer_Name,
    SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) - 1 AND
            A.Charge_Type = 'Parts' And Sales_Part_Api.Get_List_Price('100',A.Catalog_No) != 9999 THEN A.Allamounts
            ELSE 0
        END
    ) Py_Sales_Total,
    SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) - 1 AND
            A.Charge_Type = 'Parts' AND Sales_Part_Api.Get_List_Price('100',A.Catalog_No) != 9999 And
            A.Allamounts = 0 THEN Sales_Part_Api.Get_List_Price(A.Site,A.Catalog_No) * A.Invoiced_Qty
            ELSE 0
        END
    ) AS Py_Free_Goods_At_List,
    SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) - 1 AND
            A.Charge_Type = 'Parts' And Sales_Part_Api.Get_List_Price('100',A.Catalog_No) != 9999 THEN A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site,A.Catalog_No)
            ELSE 0
        END
    ) AS Py_Sales_At_List,
    SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) - 1 AND Sales_Part_Api.Get_List_Price('100',A.Catalog_No) != 9999 And
            A.Charge_Type = 'Parts' THEN(A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site,A.Catalog_No) ) - A.Allamounts
            ELSE 0
        END
    ) AS Py_Total_Discount_Dollars,
    Round(SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) - 1 AND Sales_Part_Api.Get_List_Price('100',A.Catalog_No) != 9999 And
            A.Charge_Type = 'Parts' THEN(A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site,A.Catalog_No) ) - A.Allamounts
            ELSE 0
        END
    ) / Nullif(SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) - 1 AND Sales_Part_Api.Get_List_Price('100',A.Catalog_No) != 9999 And
            A.Charge_Type = 'Parts' THEN A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site,A.Catalog_No)
            ELSE 0
        END
    ),0),4) * 100 AS Py_Effective_Discount,
    Round( (SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) - 1 AND
            A.Charge_Type = 'Parts' THEN A.Allamounts
            ELSE 0
        END
    ) - SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) - 1 AND
            A.Charge_Type = 'Parts' THEN A.Cost * A.Invoiced_Qty
            ELSE 0
        END
    ) ) / Nullif(SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) - 1 AND
            A.Charge_Type = 'Parts' THEN A.Allamounts
            ELSE 0
        END
    ),0),4) * 100 AS Py_Margin,
    SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
            A.Charge_Type = 'Parts' THEN A.Allamounts
            ELSE 0
        END
    ) Cy_Sales_Total,
    SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
            A.Charge_Type = 'Parts' AND
            A.Allamounts = 0 THEN Sales_Part_Api.Get_List_Price(A.Site,A.Catalog_No) * A.Invoiced_Qty
            ELSE 0
        END
    ) AS Cy_Free_Goods_At_List,
    SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
            A.Charge_Type = 'Parts' THEN A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site,A.Catalog_No)
            ELSE 0
        END
    ) AS Cy_Sales_At_List,
    SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
            A.Charge_Type = 'Parts' THEN(A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site,A.Catalog_No) ) - A.Allamounts
            ELSE 0
        END
    ) AS Cy_Total_Discount_Dollars,
    Round(SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
            A.Charge_Type = 'Parts' THEN(A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site,A.Catalog_No) ) - A.Allamounts
            ELSE 0
        END
    ) / Nullif(SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
            A.Charge_Type = 'Parts' THEN A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site,A.Catalog_No)
            ELSE 0
        END
    ),0),4) * 100 AS Cy_Effective_Discount,
    Round( (SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
            A.Charge_Type = 'Parts' THEN A.Allamounts
            ELSE 0
        END
    ) - SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
            A.Charge_Type = 'Parts' THEN A.Cost * A.Invoiced_Qty
            ELSE 0
        END
    ) ) / Nullif(SUM(
        CASE
            WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
            A.Charge_Type = 'Parts' THEN A.Allamounts
            ELSE 0
        END
    ),0),4) * 100 AS Cy_Margin,
    B.Price_Lists from Kd_Sales_Data_Request A,    PLCS B Where    A.Customer_No = B.Customer_ID And    ((A.Order_No Not Like 'W%' And    A.Order_No Not Like 'X%') Or    A.Order_No Is Null) And    (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null)Group By    A.Customer_No,    A.Customer_Name,    B.Price_Lists Order By A.Customer_No ) Sub1 Order By 14 Asc