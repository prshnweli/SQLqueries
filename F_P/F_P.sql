USE Aeries

SELECT
(select TE from TCH where GBK.TN = TCH.TN and GBK.SC = tch.sc and tch.del = 0 AND TCH.TG = '') AS Teacher,
School = ( select LOC.NM from LOC where GBK.SC = LOC.CD),
GBA.AD,
Complete = (CASE GBA.GC WHEN 0 THEN 'False' ELSE 'True' END),
GBA.GC,
GBK.HI,
GBK.LO
FROM GBK
JOIN GBA ON (GBK.GN = GBA.GN)
WHERE GBA.AN = 900
AND GBK.SC IN (2,6,8,9,10,11,12,15)
AND GBK.HI > -1
AND GBK.LO < 6
ORDER BY School, Complete
