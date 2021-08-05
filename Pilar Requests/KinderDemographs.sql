SELECT
STU.ID AS 'StudentID',
(SELECT MIN(ENR.GR) FROM ENR WHERE ENR.ID = STU.ID AND ENR.SC IN (2,6,8,9,10,11,12,15,20,21,30,31,32)) AS 'Grade Level Entry to MH',
STU.LN + ', ' + STU.FN AS 'Name',
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
STU.SX AS 'Gender',
STU.GR AS 'Grade',
Race = (select rtrim(DE) from COD where COD.CD = stu.ec and cod.del = 0 and cod.tc = 'stu' and cod.fc = 'ec'),
[Ethnicity] = (CASE
	WHEN STU.ETH = 'Y' THEN 'Hispanic or Latino'
	WHEN STU.ETH = 'N' THEN 'Not Hispanic or Latino'
	WHEN STU.ETH = 'Z' THEN 'Decline to State'
END),
(select de from cod where tc = 'stu' and fc = 'lf' and cod.cd = stu.lf) as [LangFluency],
STU.U2 AS 'SPED',
STU.U4 AS 'Migrant',
Foster20_21 = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 190) AND (PGM.EED IS NULL) AND (PGM.DEL = 0)) = '190' THEN 'Y' ELSE '' END,
Foster19_20 = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 190) AND (PGM.EED < '06/30/2020') AND (PGM.EED > '06/01/2019') AND (PGM.DEL = 0)) = '190' THEN 'Y' ELSE '' END,
Homeless20_21 = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 191) AND (PGM.EED IS NULL) AND (PGM.DEL = 0)) = '191' THEN 'Y' ELSE '' END,
Homeless19_20 = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 191) AND (PGM.EED < '06/30/2020') AND (PGM.EED > '06/01/2019') AND (PGM.DEL = 0)) = '191' THEN 'Y' ELSE '' END,
LowSocioEcoStatus20_21 =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2020' and fre.eed = '6/30/2021' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else '' end,
LowSocioEcoStatus19_20 =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2019' and fre.eed = '6/30/2020' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else '' end,
[ChronicAbs20_21] = CASE WHEN
CAST(
	((SELECT CAST(SUM(AHS.PR) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2020-2021'))/((SELECT CAST(SUM(AHS.EN) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2020-2021' AND AHS.EN != 0))
AS DECIMAL(10,2)) < .9 THEN 'Y'
ELSE '' END,
[ChronicAbs19_20] = CASE WHEN
CAST(
	((SELECT CAST(SUM(AHS.PR) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2019-2020'))/((SELECT CAST(SUM(AHS.EN) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2019-2020' AND AHS.EN != 0))
AS DECIMAL(10,2)) < .9 THEN 'Y'
ELSE '' END,
Suspended19_20 = CASE WHEN (ISNULL ((SELECT TOP (1) SU AS score FROM AHS WHERE (YR = '2019-2020') AND (AHS.ID = stu.ID) ORDER BY SU DESC ),'')) > 0 THEN 'Y' ELSE '' END,
Suspended20_21 = CASE WHEN (ISNULL ((SELECT TOP (1) SU AS score FROM AHS WHERE (YR = '2020-2021') AND (AHS.ID = stu.ID) ORDER BY SU DESC ),'')) > 0 THEN 'Y' ELSE '' END,
Expelled19_20 = CASE WHEN (SELECT TOP (1) EXD FROM EXP WHERE (STU.ID = EXP.PID) ORDER BY EXD DESC) > '06/30/2019' THEN 'Y' ELSE '' END,
Expelled20_21 = ''
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC IN (2,6,8,9,10,11,12,15,20,21,30,31,32)
