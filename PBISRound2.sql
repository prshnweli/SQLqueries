SELECT
"Student ID" = STU.ID,
"First Name" = STU.FN,
"Last Name" = STU.LN,
Grade = STU.GR,
School = (SELECT LOC.NM FROM LOC WHERE STU.SC = LOC.CD),
Gender = STU.SX,
Foster = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 190) AND (PGM.PED IS NULL)) = '190' THEN 'Y' ELSE '' END,
Homeless = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 191) AND (PGM.PED IS NULL)) = '191' THEN 'Y' ELSE '' END,
LangFluency = STU.LF,
"Long Term EL" = CASE WHEN (SELECT YP FROM LAC WHERE (STU.ID = LAC.ID)) > 3 THEN 'Y' ELSE '' END,
SocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2018' and fre.eed = '6/30/2019' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end,
SPED = STU.U2,
MAP_ELA = NULLIF(ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) ORDER BY TD DESC ),''), 0),
MAP_ELA_Score = NULLIF(ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) ORDER BY TD DESC ),''), 0),
MAP_Math = NULLIF(ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) ORDER BY TD DESC ),''), 0),
MAP_Math_Score = NULLIF(ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) ORDER BY TD DESC ),''), 0),
"Days Suspended" = ISNULL ((SELECT TOP (1) SU AS score FROM AHS WHERE (YR >= '2010-2011') AND (YR <= '2018-2019') AND (AHS.ID = stu.ID) ORDER BY SU DESC ),''),
Expelled = CASE WHEN (SELECT TOP (1) EXD FROM EXP WHERE (STU.ID = EXP.PID) ORDER BY EXD DESC) != '' THEN 'Y' ELSE '' END,
[Race] = (CASE
	WHEN STU.ETH = 'Y' AND STU.RC1 > 100 THEN 'Hispanic'
	WHEN STU.RC1 = 100 THEN 'American Indian or Alaskan Native'
	WHEN STU.RC1 > 200 AND STU.RC1 < 300 THEN 'Asian'
	WHEN STU.RC1 > 300 AND STU.RC1 < 401 THEN 'Pacific Islander'
	WHEN STU.RC1 = 600 THEN 'Black or African American'
	WHEN STU.RC1 = 700 THEN 'White'
	ELSE 'Unknown'
END),
"5150 ideations" = CASE WHEN (SELECT TOP(1) CD FROM CNF WHERE (STU.ID = CNF.PID) AND (CNF.CD = 'AH')) = 'AH' THEN 'Y' ELSE '' END,
[ChronicAbs] = CASE WHEN
CAST(
	((SELECT CAST(SUM(AHS.PR) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2018-2019'))/((SELECT CAST(SUM(AHS.EN) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2018-2019'))
AS DECIMAL(10,2)) < .9 THEN 'Y'
ELSE '' END,
Truant = ISNULL ((SELECT SUM(AU) FROM AHS WHERE (YR = '2018-2019') AND (AHS.ID = stu.ID)),''),
Tardies = ISNULL((SELECT SUM(TD) FROM AHS WHERE (YR = '2018-2019') AND (AHS.ID = STU.ID)),''),
"Number of Credits" = STU.CC,
Oral_Perf =  NULLIF(ISNULL ((SELECT TOP (1) cast( PL AS INT) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 1) ORDER BY TD DESC ),''), 0),
Written_Perf =  NULLIF(ISNULL ((SELECT TOP (1) cast(PL AS INT) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 2) ORDER BY TD DESC ),''), 0),
Listening_Perf =  NULLIF(ISNULL ((SELECT TOP (1) cast( PL AS INT) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 3) ORDER BY TD DESC ),''), 0),
Speaking_Perf =  NULLIF(ISNULL ((SELECT TOP (1) cast( PL AS INT) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 4) ORDER BY TD DESC ),''), 0),
Reading_Perf =  NULLIF(ISNULL ((SELECT TOP (1) cast( PL AS INT) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 5) ORDER BY TD DESC ),''), 0),
Writing_Perf =  NULLIF(ISNULL ((SELECT TOP (1) cast( PL AS INT) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 6) ORDER BY TD DESC ),''), 0),
GPA = STU.TP,
Retained = CASE WHEN (SELECT CD FROM RET WHERE (RET.PID = STU.ID) AND (RET.CD = 'R')) = 'R' THEN 'Y' ELSE '' END
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC IN (2,6,8,9,10,11,12,15,20,21,30,31,32)
