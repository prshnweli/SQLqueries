USE Aeries2018

SELECT 
STU.ID,
STU.FN,
STU.LN,
HIS.TE,
SUM(HIS.CC) AS 'Credits Completed'
FROM STU
JOIN HIS ON(STU.ID = HIS.PID)
WHERE HIS.YR = 18
AND STU.SC = 30
AND STU.DEL = 0
and stu.tg = ''
GROUP BY STU.ID, STU.FN, STU.LN, HIS.TE
ORDER BY STU.ID, HIS.TE
