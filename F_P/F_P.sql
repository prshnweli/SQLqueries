SELECT
GBK.GN,
GBK.DEL,
TCH.TE AS Teacher,
School = ( select LOC.NM from LOC where GBK.SC = LOC.CD),
FP.AD AS 'Gradebook',
gbk.lo, gbk.hi,
Complete = (CASE FP.GC WHEN 0 THEN 'No' ELSE 'Yes' END)
FROM (SELECT * FROM GBA where gba.an = 902) AS FP
JOIN GBK ON (GBK.GN = FP.GN)
JOIN TCH ON (GBK.TN = TCH.TN) AND (GBK.SC = TCH.SC)
JOIN MST ON (mst.sc = tch.sc) and (mst.tn = tch.tn)
WHERE MST.TS > 0
AND TCH.DEL = 0
AND TCH.TG = ''
and gbk.lo < 6
AND GBK.HI > -1
AND GBK.DEL = 0
ORDER BY School, Complete, GBK.LO, GBK.HI, TCH.TE desc
