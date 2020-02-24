SELECT
STU.ID,
STU.LN + ', ' + STU.FN,
STU.GR,
STU.ETH,
STU.U2 AS 'SPED',
STU.U4 AS 'Migrant',
STU.LF AS 'Language Fluency',
SocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2019' and fre.eed = '6/30/2020' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end,
Foster = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 190) AND (PGM.PED IS NULL)) = '190' THEN 'Y' ELSE '' END,
Homeless = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 191) AND (PGM.PED IS NULL)) = '191' THEN 'Y' ELSE '' END,
CRS.CN,
CRS.CO AS 'Title',
CRS.DE AS 'Long Title',
CRS.CD AS 'Course Description'
FROM CRS
JOIN SEC ON (CRS.CN = SEC.CN)
JOIN STU ON (SEC.SC = STU.SC) AND (SEC.SN = STU.SN)
WHERE CRS.DE LIKE '%CTE%'
AND CRS.TG = ''
ORDER BY STU.ID
