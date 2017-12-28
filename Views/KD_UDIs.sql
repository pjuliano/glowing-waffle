Create or Replace View KD_UDIs As 
Select
  --Build UDI Code
  '+' || --Data identifier
  'D768' || --MFG Code
  Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),1,18) || --First 18 characters of part number stripped of non-alphanumeric characters
  '0' || --Unit of measure
  '/' || --Data delimiter
  Decode(Expiration_Date,Null,'','$$3') || --Date/lot reference identifier
  To_Char(Expiration_Date,'YYMMDD') || --Expiration in YYMMDD
  Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18) || --First 18 characters of lot/batch number stripped of non-alphanumeric characters
  (Select Character From KD_UDI_Chars Where Value = 
  Mod(
      (Select Value From Kd_Udi_Chars Where Character = '+') + 
      (Select Value From Kd_Udi_Chars Where Character = Substr('D768',1,1)) + 
      (Select Value From Kd_Udi_Chars Where Character = Substr('D768',2,1)) +
      (Select Value From Kd_Udi_Chars Where Character = Substr('D768',3,1)) + 
      (Select Value From Kd_Udi_Chars Where Character = Substr('D768',4,1)) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),1,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),2,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),3,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),4,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),5,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),6,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),7,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),8,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),9,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),10,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),11,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),12,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),13,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),14,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),15,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),16,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),17,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),18,1)),0) + 
      (Select Value From Kd_Udi_Chars Where Character = Substr('0',1,1)) +
      (Select Value From Kd_Udi_Chars Where Character = Substr('/',1,1)) +
      (Select Value From Kd_Udi_Chars Where Character = Substr('$$3',1,1)) +
      (Select Value From Kd_Udi_Chars Where Character = Substr('$$3',2,1)) +
      (Select Value From Kd_Udi_Chars Where Character = Substr('$$3',3,1)) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(To_Char(Expiration_Date,'YYMMDD'),1,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(To_Char(Expiration_Date,'YYMMDD'),2,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(To_Char(Expiration_Date,'YYMMDD'),3,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(To_Char(Expiration_Date,'YYMMDD'),4,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(To_Char(Expiration_Date,'YYMMDD'),5,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(To_Char(Expiration_Date,'YYMMDD'),6,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),2,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),3,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),4,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),5,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),6,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),7,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),8,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),9,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),10,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),11,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),12,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),13,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),14,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),15,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),16,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),17,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),18,1)),0),43)) AS UDI,
  Part_No,
  Expiration_Date,
  Lot_Batch_No
From
  Inventory_Transaction_Hist
Where
  Transaction_Code = 'OESHIP' And Lot_Batch_No != '*' And
  Expiration_Date >= To_Date('01/01/2015','MM/DD/YYYY')