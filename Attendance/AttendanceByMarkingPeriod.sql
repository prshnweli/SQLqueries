SELECT
STU.ID,
STU.LN + ', ' + STU.FN,
'Credits Completed Percentage' = ' ',
'Attendance Percentage' = ' ',
'Complete' = (SELECT SUM(CC) FROM HIS WHERE STU.ID = HIS.PID AND HIS.TE = 6 AND HIS.YR = 19 AND HIS.ST = 30),
'Attempted' = (SELECT SUM(CR) FROM HIS WHERE STU.ID = HIS.PID AND HIS.TE = 6 AND HIS.YR = 19 AND HIS.ST = 30),
P1 = SUM(CASE WHEN ATT.A1 IN ('3','4','5','6','8','A','D','E','F','H','I','K','M','N','O','Q','S','U','X','Z') THEN 1 ELSE 0 END),
P2 = SUM(CASE WHEN ATT.A2 IN ('3','4','5','6','8','A','D','E','F','H','I','K','M','N','O','Q','S','U','X','Z') THEN 1 ELSE 0 END),
P3 = SUM(CASE WHEN ATT.A3 IN ('3','4','5','6','8','A','D','E','F','H','I','K','M','N','O','Q','S','U','X','Z') THEN 1 ELSE 0 END),
P4 = SUM(CASE WHEN ATT.A4 IN ('3','4','5','6','8','A','D','E','F','H','I','K','M','N','O','Q','S','U','X','Z') THEN 1 ELSE 0 END),
P5 = SUM(CASE WHEN ATT.A5 IN ('3','4','5','6','8','A','D','E','F','H','I','K','M','N','O','Q','S','U','X','Z') THEN 1 ELSE 0 END),
P6 = SUM(CASE WHEN ATT.A6 IN ('3','4','5','6','8','A','D','E','F','H','I','K','M','N','O','Q','S','U','X','Z') THEN 1 ELSE 0 END),
total = COUNT(ATT.A1) + COUNT(ATT.A2) + COUNT(ATT.A3) + COUNT(ATT.A4) + COUNT(ATT.A5) + COUNT(ATT.A6)
FROM ATT
JOIN STU ON STU.SN = ATT.SN AND STU.SC = ATT.SC
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC = 30
AND STU.SN NOT IN (24764,24767,24757,24759,24760,24766,24761,24754,24762,24763)
AND ATT.DT > '1/06/2020'
AND ATT.DT < '2/14/2020'
-- AND ATT.AL IN ('3','6','8','A','B','E','O','Q','S','U') -- Unexcused
-- AND ATT.AL IN ('4','5','D','F','H','I','K','M','N','V','X','Z') -- Excused
GROUP BY STU.ID, STU.FN, STU.LN
ORDER BY STU.LN, STU.FN
