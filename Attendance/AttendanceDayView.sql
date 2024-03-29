USE Aeries

SELECT
CAST(ATT.DT AS DATE),
-- SUM(CASE WHEN ATT.AL IS NOT NULL THEN 1 ELSE 0 END)
-- SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 2 THEN 1 ELSE 0 END) AS ElToro,
-- SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 6 THEN 1 ELSE 0 END) AS LosPaseos,
-- SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 8 THEN 1 ELSE 0 END) AS Nordstrom,
-- SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 9 THEN 1 ELSE 0 END) AS Paradise,
-- SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 12 THEN 1 ELSE 0 END) AS Barrett,
-- SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 11 THEN 1 ELSE 0 END) AS Walsh,
-- SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 15 AND STU.GR < 6 THEN 1 ELSE 0 END) AS JAMM,
SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 10 AND STU.GR < 6 THEN 1 ELSE 0 END) AS SMG
-- SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 20 THEN 1 ELSE 0 END) AS Murphy,
-- SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 21 THEN 1 ELSE 0 END) AS Britton
-- SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 30 THEN 1 ELSE 0 END) AS Central
-- SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 31 THEN 1 ELSE 0 END) AS LiveOak,
-- SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 32 THEN 1 ELSE 0 END) AS Sobrato
FROM ATT
JOIN STU ON STU.SN = ATT.SN AND STU.SC = ATT.SC
WHERE STU.DEL = 0
AND STU.TG = ''
AND ATT.AL IN ('3','4','5','6','8','A','D','E','F','H','I','K','M','N','O','Q','S','U','V','X','Z')
-- AND ATT.AL IN ('3','6','8','A','B','E','O','Q','S','U') -- Unexcused
-- AND ATT.AL IN ('4','5','D','F','H','I','K','M','N','V','X','Z') -- Excused
AND ATT.DT > '2020-01-27'
AND ATT.DT < '2020-02-08'
GROUP BY DT
ORDER BY DT
