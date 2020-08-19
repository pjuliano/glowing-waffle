Create Or Replace View KD_MRP_FG_SALES_QTY As 
Select
    A.FG_Part_No,
    A.FG_Part_Index,
    NVL(Sum(B.Invoiced_Qty * Nvl(A.Fg_Multiplier,1)) + NVL(pack.units_sold_12m,0),0)  As Units_Sold_12M
From
    KD_MRP_Part_Relationships A 
    Left Join KD_Sales_Data_Request B
        On A.FG_Part_No = B.Catalog_No And
           B.InvoiceDate >= Add_Months(Trunc(sysdate,'MM'),-12) And 
           B.InvoiceDate <= Last_Day(Add_Months(Sysdate,-1)) And
           B.Invoiced_Qty > 0
    Left Join 
        (
            SELECT
                            pack.fg_part_no,
                            nvl(SUM(invoiced_qty * pack.qty_per_pack),0) AS units_sold_12m
            FROM
                            kd_mrp_pack pack
                            LEFT JOIN kd_sales_data_request sdr
                                ON pack.pack_part_no = sdr.catalog_no
                                    AND sdr.invoicedate >= add_months(trunc(sysdate,'MM'),-12)
                                    AND sdr.invoicedate <= last_day(add_months(sysdate,-1))
                                    AND sdr.invoiced_qty > 0
            GROUP BY
                            pack.fg_part_no
        ) Pack
        On A.FG_Part_No = Pack.fg_part_no
Group By
    A.FG_Part_No,
    A.FG_Part_Index,
    pack.units_sold_12m