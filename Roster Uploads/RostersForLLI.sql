SELECT
"Student ID" = STU.ID,
Name =  STU.LN + ', ' + STU.FN,
Grade = STU.GR,
School = (SELECT LOC.NM FROM LOC WHERE STU.SC = LOC.CD),
Gender = STU.SX,
LangFluency = STU.LF,
"Long Term EL" = CASE WHEN (SELECT YP FROM LAC WHERE (STU.ID = LAC.ID)) > 3 THEN 'Y' ELSE '' END,
SocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2018' and fre.eed = '6/30/2019' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end,
SPED = STU.U2,
ISNULL ((SELECT TOP (1) CAST(PL AS FLOAT) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (TA = '2T1819') AND (PT = 0) ORDER BY TD DESC ),'') AS 'F&P Spring18_19',
ISNULL ((SELECT TOP (1) CAST(PL AS FLOAT) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (TA = 'BL1819') AND (PT = 0) ORDER BY TD DESC ),'') AS 'F&P Fall18_19',
MAP_ELAScore_Spring19 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1811','1812','1901','1902','1903')) ORDER BY TD DESC ),''),
MAP_ELAPercentile_Spring19 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1811','1812','1901','1902','1903')) ORDER BY TD DESC ),''),
MAP_MathScore_Spring19 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1811','1812','1901','1902','1903')) ORDER BY TD DESC ),''),
MAP_MathPercentile_Spring19 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1811','1812','1901','1902','1903')) ORDER BY TD DESC ),''),
ELPAC_Overall_Perf =  NULLIF(ISNULL ((SELECT TOP (1) cast( PL AS INT) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 0) ORDER BY TD DESC ),''), 0),
ELPAC_Oral_Perf =  NULLIF(ISNULL ((SELECT TOP (1) cast( PL AS INT) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 1) ORDER BY TD DESC ),''), 0),
ELPAC_Written_Perf =  NULLIF(ISNULL ((SELECT TOP (1) cast(PL AS INT) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 2) ORDER BY TD DESC ),''), 0),
ELPAC_Listening_Perf =  NULLIF(ISNULL ((SELECT TOP (1) cast( PL AS INT) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 3) ORDER BY TD DESC ),''), 0),
ELPAC_Speaking_Perf =  NULLIF(ISNULL ((SELECT TOP (1) cast( PL AS INT) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 4) ORDER BY TD DESC ),''), 0),
ELPAC_Reading_Perf =  NULLIF(ISNULL ((SELECT TOP (1) cast( PL AS INT) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 5) ORDER BY TD DESC ),''), 0),
ELPAC_Writing_Perf =  NULLIF(ISNULL ((SELECT TOP (1) cast( PL AS INT) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 6) ORDER BY TD DESC ),''), 0),
[Race] = (CASE
	WHEN STU.ETH = 'Y' AND STU.RC1 > 100 THEN 'Hispanic'
	WHEN STU.RC1 = 100 THEN 'American Indian or Alaskan Native'
	WHEN STU.RC1 > 200 AND STU.RC1 < 300 THEN 'Asian'
	WHEN STU.RC1 > 300 AND STU.RC1 < 401 THEN 'Pacific Islander'
	WHEN STU.RC1 = 600 THEN 'Black or African American'
	WHEN STU.RC1 = 700 THEN 'White'
	ELSE 'Unknown'
END),
[ParentEdLvl] = CASE STU.PED
	WHEN 10 THEN 'Grad School/post grad trng'
	WHEN 11 THEN 'College Graduate'
	WHEN 12 THEN 'Some College'
	WHEN 13 THEN 'High School Graduate'
	WHEN 14 THEN 'Not HS Graduate'
	WHEN 15 THEN 'Declined to State/Unkown'
END,
[ChronicAbs] = CASE WHEN
CAST(
	((SELECT CAST(SUM(AHS.PR) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2018-2019'))/((SELECT CAST(SUM(AHS.EN) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2018-2019'))
AS DECIMAL(10,2)) < .9 THEN 'Y'
ELSE '' END,
Truant = ISNULL ((SELECT SUM(AU) FROM AHS WHERE (YR = '2018-2019') AND (AHS.ID = stu.ID)),''),
Tardies = ISNULL((SELECT SUM(TD) FROM AHS WHERE (YR = '2018-2019') AND (AHS.ID = STU.ID)),''),
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
