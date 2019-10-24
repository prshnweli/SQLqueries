/*
Here is the query that I ran for unexcused absences to check the truancy percentages.
I put in  AND ATT.AL IN ('3','6','8','A','B','E','O','Q','S','U') -- Unexcused.
When I look at the numbers if I divide by students with 2
or more unexcused absences over the total, I get exactly 5.77% which is what DataZone says.
Is that how it's being calculated? Or I could be just querying this totally wrong.
Let me know what you think. Thank you!

https://dev.datazone.org/DashboardDev/dashboard/5035?filtersetId=54c4f63a-2cac-4732-93c5-a9036bea56e2
*/

SELECT
STU.ID,
STU.SC,
SUM(CASE WHEN ATT.AL IS NOT NULL THEN 1 ELSE 0 END) AS "Total"
FROM ATT
JOIN STU ON STU.SN = ATT.SN AND STU.SC = ATT.SC
WHERE STU.DEL = 0
AND STU.TG = ''
-- AND ATT.AL IN ('3','4','5','6','8','A','D','E','F','H','I','K','M','N','O','Q','S','U','V','X','Z')
AND ATT.AL IN ('3','6','8','A','B','E','O','Q','S','U') -- Unexcused
-- AND ATT.AL IN ('4','5','D','F','H','I','K','M','N','V','X','Z') -- Excused
GROUP BY STU.ID, STU.SC
ORDER BY Total DESC

SELECT COUNT (*) FROM STU WHERE STU.TG = '' AND STU.DEL = 0
