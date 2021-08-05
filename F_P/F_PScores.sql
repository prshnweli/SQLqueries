--USE Aeries2018

SELECT
STU.ID,
STU.FN,
STU.LN,
STU.GR AS 'Grade',
(select TE from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 ) AS Teacher,
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
ROUND(GBS.SCR,2) AS 'Score'
FROM STU
JOIN GBS ON(GBS.SC = STU.SC) AND (GBS.SN = STU.SN)
WHERE GBS.AN in (900)
AND GBS.DC IS NOT NULL
AND STU.SC = 11
ORDER BY GR, Teacher, STU.LN, STU.FN

-- ISNULL ((SELECT TOP (1) ROUND(SCR, 1) AS score FROM dbo.GBS WHERE (STU.DEL = 0) AND (GBS.SN = stu.SN) AND (GBS.SC = STU.SC) AND (GBS.AN = 900) AND (GBS.DC IS NOT NULL) ORDER BY DC DESC ),'')
