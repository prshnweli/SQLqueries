SELECT
STU.ID,
STU.LN + ', ' + STU.FN AS 'Name',
(select TE from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 ) AS Teacher,
STU.GR AS 'Grade',
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
ROUND(GBS.SCR,1) AS 'Score'
FROM STU
JOIN GBS
	ON(GBS.SC = STU.SC) AND (GBS.SN = STU.SN)
WHERE GBS.AN in (900)
AND STU.DEL = 0
AND STU.TG = ''
-- AND GBS.DC IS NOT NULL
AND STU.SC = 15
AND GBS.DC IS NOT NULL
ORDER BY GR, Teacher, STU.LN, STU.FN
