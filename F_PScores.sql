USE Aeries2018

SELECT 
STU.ID, 
STU.FN, 
STU.LN,
STU.GR,
(select TE from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 ) AS Teacher, 
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
GBS.SCR,
GBS.DC
FROM STU
JOIN GBS 
	ON(GBS.SC = STU.SC) AND (GBS.SN = STU.SN)
WHERE GBS.AN in (900, 901)
AND GBS.DC IS NOT NULL
ORDER BY SCHOOL, GR