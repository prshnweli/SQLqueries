SELECT
STU.ID,
[name] = STU.LN + ', ' + STU.FN,
STU.GR,
CAST(ATT.DT AS DATE),
[Day] = CASE DATEPART(weekday, ATT.DT)
WHEN 2 THEN 'Monday'
WHEN 3 THEN 'Tuesday'
WHEN 4 THEN 'Wednesday'
WHEN 5 THEN 'Thursday'
WHEN 6 THEN 'Friday'
END,
ATT.AL

FROM ATT
JOIN STU ON STU.SN = ATT.SN AND STU.SC = ATT.SC
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC = 10
-- AND ATT.AL IN ('3','4','5','6','8','A','D','E','F','H','I','K','M','N','O','Q','S','U','V','X','Z')
-- AND ATT.AL IN ('3','6','8','A','B','E','O','Q','S','U') -- Unexcused
-- AND ATT.AL IN ('4','5','D','F','H','I','K','M','N','V','X','Z') -- Excused
-- GROUP BY ATT.DT, STU.ID, STU.FN, STU.LN
ORDER BY STU.LN, STU.FN, ATT.DT

SELECT
STU.ID,
STU.FN,
STU.LN,
CAST(ATT.DT AS DATE),
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
AND STU.SC = 30
GROUP BY ATT.DT, STU.ID, STU.FN, STU.LN, ATT.A1, ATT.A2, ATT.A3, ATT.A4, ATT.A5, ATT.A6, ATT.AL
ORDER BY STU.LN, STU.FN, ATT.DT



SELECT
CAST(ATT.DT AS DATE),
[Day] = CASE DATEPART(weekday, ATT.DT)
WHEN 2 THEN 'Monday'
WHEN 3 THEN 'Tuesday'
WHEN 4 THEN 'Wednesday'
WHEN 5 THEN 'Thursday'
WHEN 6 THEN 'Friday'
END,
SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 30 THEN 1 ELSE 0 END) AS Central
FROM ATT
JOIN STU ON STU.SN = ATT.SN AND STU.SC = ATT.SC
WHERE STU.DEL = 0
AND STU.TG = ''
AND ATT.AL IN ('3','4','5','6','8','A','D','E','F','H','I','K','M','N','O','Q','S','U','V','X','Z')
-- AND ATT.AL IN ('3','6','8','A','B','E','O','Q','S','U') -- Unexcused
-- AND ATT.AL IN ('4','5','D','F','H','I','K','M','N','V','X','Z') -- Excused
GROUP BY DT
ORDER BY DT
