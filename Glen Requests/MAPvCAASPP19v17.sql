USE Aeries

SELECT
StudentID = stu.id,
FirstName = stu.fn,
LastName = stu.ln,
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
School19 = (CASE (SELECT TOP (1) ENR.SC FROM ENR WHERE STU.ID = ENR.ID AND ENR.YR = 2018)
WHEN 2 THEN 'El Toro'
WHEN 6 THEN 'Los Paseos'
WHEN 8 THEN 'Nordstrom'
WHEN 9 THEN 'Paradise'
WHEN 10 THEN 'SMG'
WHEN 11 THEN 'Walsh'
WHEN 12 THEN 'Barrett'
WHEN 15 THEN 'JAMM'
WHEN 20 THEN 'Britton'
WHEN 21 THEN 'Murphy'
WHEN 30 THEN 'Central'
WHEN 31 THEN 'Live Oak'
WHEN 32 THEN 'Sobrato'
END),
School17 = (CASE(SELECT TOP (1) ENR.SC FROM ENR WHERE STU.ID = ENR.ID AND ENR.YR = 2016)
WHEN 2 THEN 'El Toro'
WHEN 6 THEN 'Los Paseos'
WHEN 8 THEN 'Nordstrom'
WHEN 9 THEN 'Paradise'
WHEN 10 THEN 'SMG'
WHEN 11 THEN 'Walsh'
WHEN 12 THEN 'Barrett'
WHEN 15 THEN 'JAMM'
WHEN 20 THEN 'Britton'
WHEN 21 THEN 'Murphy'
WHEN 30 THEN 'Central'
WHEN 31 THEN 'Live Oak'
WHEN 32 THEN 'Sobrato'
END),
DistrictEntry = CONVERT(DATE, STU.DD),
Grade = stu.gr,
SocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2019' and fre.eed = '6/30/2020' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end,
Race = (select rtrim(DE) from COD where COD.CD = stu.ec and cod.del = 0 and cod.tc = 'stu' and cod.fc = 'ec'),
Ethnicity = STU.ETH,
LangFluency = stu.lf,
SPED = stu.U2,
Migrant = stu.U4,
[ParentEdLvl] = CASE STU.PED
	WHEN 10 THEN 'Grad School/post grad trng'
	WHEN 11 THEN 'College Graduate'
	WHEN 12 THEN 'Some College'
	WHEN 13 THEN 'High School Graduate'
	WHEN 14 THEN 'Not HS Graduate'
	WHEN 15 THEN 'Declined to State/Unkown'
END,
ELAScore2019_CAASPP =  ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 1) ORDER BY TD DESC ),''),
ELAPCL2019_CAASPP =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 1) ORDER BY TD DESC ),''),
MathScore2019_CAASPP =  ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 2) ORDER BY TD DESC ),''),
MathPCL2019_CAASPP =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 2) ORDER BY TD DESC ),''),
ELAScore2017_CAASPP =  ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG17') AND (PT = 1) ORDER BY TD DESC ),''),
ELAPCL2017_CAASPP =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG17') AND (PT = 1) ORDER BY TD DESC ),''),
MathScore2017_CAASPP =  ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG17') AND (PT = 2) ORDER BY TD DESC ),''),
MathPCL2017_CAASPP =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG17') AND (PT = 2) ORDER BY TD DESC ),''),
ELAScore_Spring19_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1811','1812','1901','1902','1903')) ORDER BY TD DESC ),''),
ELAPercentile_Spring19_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1811','1812','1901','1902','1903')) ORDER BY TD DESC ),''),
MathScore_Spring19_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1811','1812','1901','1902','1903')) ORDER BY TD DESC ),''),
MathPercentile_Spring19_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1811','1812','1901','1902','1903')) ORDER BY TD DESC ),''),
ELAScore_Spring17_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1611','1612','1701','1702','1703')) ORDER BY TD DESC ),''),
ELAPercentile_Spring17_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1611','1612','1701','1702','1703')) ORDER BY TD DESC ),''),
MathScore_Spring17_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1611','1612','1701','1702','1703')) ORDER BY TD DESC ),''),
MathPercentile_Spring17_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1611','1612','1701','1702','1703')) ORDER BY TD DESC ),'')
FROM STU
where stu.del = 0
and stu.tg = ''
and stu.sc in (2,6,8,9,10,11,12,15,20,21,30,31,32,40,60,70)
and stu.gr > 3
order by grade, school
