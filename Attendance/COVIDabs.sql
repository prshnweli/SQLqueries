SELECT
STU.ID,
STU.LN + ', ' + STU.FN AS 'Name',
STU.GR,
Teacher = (select TE from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 ),
stu.u2 as 'SPED',
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
CAST(ATT.DT AS DATE),
[Day] = CASE DATEPART(weekday, ATT.DT)
WHEN 2 THEN 'Monday'
WHEN 3 THEN 'Tuesday'
WHEN 4 THEN 'Wednesday'
WHEN 5 THEN 'Thursday'
WHEN 6 THEN 'Friday'
END,
ATT.A1 AS 'Period 1',
ATT.A2 AS 'Period 2',
ATT.A3 AS 'Period 3',
ATT.A4 AS 'Period 4',
ATT.A5 AS 'Period 5',
ATT.A6 AS 'Period 6',
ATT.AL AS 'All Day'
FROM ATT
JOIN STU ON STU.SN = ATT.SN AND STU.SC = ATT.SC
WHERE STU.DEL = 0
AND STU.TG = ''
-- AND ATT.AL IN ('3','4','5','6','8','A','D','E','F','H','I','K','M','N','O','Q','S','U','V','X','Z')
-- AND ATT.AL IN ('3','6','8','A','B','E','O','Q','S','U') -- Unexcused
-- AND ATT.AL IN ('4','5','D','F','H','I','K','M','N','V','X','Z') -- Excused
AND ATT.DT > '2020-04-23'
AND ATT.DT < '2020-04-28'
AND STU.SN NOT IN (24764,24767,24757,24759,24760,24766,24761,24754,24762,24763)
GROUP BY ATT.DT, STU.ID, STU.FN, STU.LN, STU.GR, STU.U2, ATT.A1, ATT.A2, ATT.A3, ATT.A4, ATT.A5, ATT.A6, ATT.AL, stu.sc, stu.gr, stu.cu
ORDER BY STU.SC, STU.GR, stu.cu, STU.LN, STU.FN, ATT.DT
