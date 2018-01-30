Create or Replace View KD_UDIs As 
Select
  --Build UDI Code
  '+' || --Data identifier
  'D768' || --MFG Code
  Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),1,18) || --First 18 characters of part number stripped of non-alphanumeric characters
  '0' || --Unit of measure
  '/' || --Data delimiter
  Decode(Expiration_Date,Null,'$$7','$$3') || --Date/lot reference identifier
  To_Char(Expiration_Date,'YYMMDD') || --Expiration in YYMMDD
  Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,18) || --First 18 characters of lot/batch number stripped of non-alphanumeric characters
  (Select Character From KD_UDI_Chars Where Value = --Find check character
  Mod(
      (Select Value From Kd_Udi_Chars Where Character = '+') + --Data Identifier
      (Select Value From Kd_Udi_Chars Where Character = Substr('D768',1,1)) + --MFG Code
      (Select Value From Kd_Udi_Chars Where Character = Substr('D768',2,1)) + --MFG Code
      (Select Value From Kd_Udi_Chars Where Character = Substr('D768',3,1)) + --MFG Code
      (Select Value From Kd_Udi_Chars Where Character = Substr('D768',4,1)) + --MFG Code
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Part_No,'[^a-zA-Z0-9]+',''),1,1)),0) + --Part Number characters 1-18 values
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
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr('0',1,1)),0) + --UoM
      (Select Value From Kd_Udi_Chars Where Character = Substr('/',1,1)) + --Data Delimiter 
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Decode(Expiration_Date,Null,'$$7','$$3'),1,1)),0) + --Date/Lot reference identifier (0 if Expiration Date is Null, indicating a non-sterile part)
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Decode(Expiration_Date,Null,'$$7','$$3'),2,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Decode(Expiration_Date,Null,'$$7','$$3'),3,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(To_Char(Expiration_Date,'YYMMDD'),1,1)),0) + --Expiration Date in YYMMDD
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(To_Char(Expiration_Date,'YYMMDD'),2,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(To_Char(Expiration_Date,'YYMMDD'),3,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(To_Char(Expiration_Date,'YYMMDD'),4,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(To_Char(Expiration_Date,'YYMMDD'),5,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(To_Char(Expiration_Date,'YYMMDD'),6,1)),0) +
      Nvl((Select Value From Kd_Udi_Chars Where Character = Substr(Regexp_Replace(Lot_Batch_No,'[^a-zA-Z0-9]+',''),1,1)),0) + --Lot Number characters 1-18 values
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
  Inventory_transaction_Hist
Where
  Transaction_Code = 'OESHIP' And
  Lot_Batch_No != '*'
Group By
  Part_No,
  Expiration_Date,
  Lot_Batch_No