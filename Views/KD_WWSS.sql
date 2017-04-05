Create Or Replace View KD_WWSS As
Select * From Kd_Wwss_Nadirect
Union All
Select * From Kd_Wwss_Globaldist
Union All
Select * from Kd_Wwss_Freight