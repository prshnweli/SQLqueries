SELECT
STU.ID AS 'ID',
STU.LN + ', ' + STU.FN AS 'Name',
STU.GR AS 'Grade',
-- teacher,
SUM(ATT.AL WHERE DATEPART(weekday, ATT.DT) = 2) AS 'Monday',
SUM(ATT.AL WHERE DATEPART(weekday, ATT.DT) = 2) AS 'Tuesday',
SUM(ATT.AL WHERE DATEPART(weekday, ATT.DT) = 2) AS 'Wednesday',
SUM(ATT.AL WHERE DATEPART(weekday, ATT.DT) = 2) AS 'Thursday',
SUM(ATT.AL WHERE DATEPART(weekday, ATT.DT) = 2) AS 'Friday',
SUM(ATT.AL) AS 'Grand Total'
FROM ATT
JOIN STU ON STU.SN = ATT.SN AND STU.SC = ATT.SC
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC = 10
AND ATT.AL IN ('3','4','5','6','8','A','D','E','F','H','I','K','M','N','O','Q','S','U','V','X','Z')
GROUP BY STU.ID, STU.FN, STU.LN, STU.GR
ORDER BY STU.LN, STU.FN, ATT.DT
