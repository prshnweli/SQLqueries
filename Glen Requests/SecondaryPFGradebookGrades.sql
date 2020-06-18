SELECT
ID = STU.ID,
Name = STU.LN + ', ' + STU.FN,
Grade = STU.GR,
Teacher = (select TE from TCH where GBK.TN = TCH.TN and GBK.sc = tch.sc and tch.del = 0 ),
Term = GBV.CD,
'Class Name' = GBK.NM,
Mark = GBV.MK,
Percnt = GBV.PC,
P_F = CASE WHEN GBV.PC >= 60 THEN 'P' ELSE 'F' END
FROM STU
JOIN GBV ON STU.SN = GBV.SN AND STU.SC = GBV.SC
JOIN GBK ON GBV.GN = GBK.GN
WHERE STU.DEL = 0
AND STU.TG = ''
AND GBV.CD = 'S'
AND STU.SC IN (31,32)
