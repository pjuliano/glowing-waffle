Create Or Replace View Kd_Us_Sales_Detail As
Select
  A.Customer_No As Cust#,
  A.Customer_Name,
  A.Invoicedate,
  A.Invoice_Id As Invoice#,
  A.Item_Id As Line,
  Extract(Month From A.Invoicedate) As Mth,
  Extract(Year From A.Invoicedate) As Year,
  A.Invoiceqtr,
  A.Salesman_Code As Rep#,
  Person_Info_Api.Get_Name(A.Salesman_Code) As Rep_Name,
  A.Commission_Receiver As Commrec,
  A.Region_Code As Region,
  A.Delivstate As Delstate,
  A.Delivcountry As Delcntry,
  A.Delivzip As Delzip,
  A.Catalog_No As Catalog#,
  A.Catalog_Desc As Description,
  A.Part_Product_Family As Prodfam,
  A.Part_Product_Code As Prodcd,
  A.Second_Commodity As Seccomd,
  A.Invoiced_Qty As Qty,
  A.Sale_Unit_Price As Listprice,
  A.Allamounts As Salespricefc,
  C.Inventoryvalueus * A.Invoiced_Qty As Costvalue,
  A.Truelocalamt As Localprice,
  A.Association_No As Assocno,
  A.District_Code As Area,
  A.Cust_Grp As Spec,
  A.Market_Code,
  A.Site,
  A.Corporate_Form,
  Case When A.Corporate_Form = 'DOMDIR'
       Then 'NADIRECT'
       When A.Corporate_Form In ('GER','BENELUX','FRA','ITL','SWE')
       Then 'EUROPE'
       When A.Corporate_Form In ('ASIA','LA','EUR','SPA','CAN','DOMDIS')
       Then 'GLOBLDIST'
       Else Null
  End As "SEGMENT",
  A.Rma_No As Rma#,
  A.Order_No As Order#,
  D.Order_Id As Order_Type,
  A.Source,
  A.Type_Designation,
  Case When A.Part_Product_Family In ('DYNAC','DYNAG','DYNAB','DYNAM','CONNX','CYTOP','BVINE','SYNTH','MTF')
       Then 'BIOMATERIALS'
       When A.Part_Product_Family In ('COMM','GNSIS','PRIMA','RENOV','RESTO','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED')
       Then 'IMPLANTS'
       When A.Part_Product_Family In ('EG','CUSAB','OTHER','EDU','MOTOR','ODYSS','LEGACY','DEVELOP')
       Then 'OTHER'
  End As Product_Type,
  A.Customer_Name As Assocname,
  E.List_Price As Current_List,
  E.Catalog_Group As Sales_Group,
  B.Total_Tax 
From
  Kd_Sales_Data_Request A Left Join KD_Total_Invoice_Taxes B
    On A.Invoice_Id = B.Invoice_Id And
       A.Item_Id = B.Item_ID
                          Left Join Kd_Cost_Values C
    On A.Catalog_No = C.Part_No
                          Left Join Customer_Order D
    On A.Order_No = D.Order_No And
       A.Customer_No = D.Customer_No
                          Left Join Sales_Part E
    On A.Site = E.Contract And
       A.Catalog_No = E.Catalog_No