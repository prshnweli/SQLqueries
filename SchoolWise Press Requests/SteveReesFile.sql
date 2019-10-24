USE Aeries

SELECT
StudentID = stu.id,
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
LastSchool = ( select LOC.NM from LOC where stu.LS = LOC.CD),
Grade = stu.gr,
Teacher = (select TE from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 ),
SocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2019' and fre.eed = '6/30/2020' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end,
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
DistrictEntry = CONVERT(DATE, STU.DD),
CAASPP_ELAScore2019 =  ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 1) ORDER BY TD DESC ),''),
CAASPP_ELAPCL2019 =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 1) ORDER BY TD DESC ),''),
CAASPP_MathScore2019 =  ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 2) ORDER BY TD DESC ),''),
CAASPP_MathPCL2019 =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 2) ORDER BY TD DESC ),''),
CAASPP_ELAScore2018 =  ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG18') AND (PT = 1) ORDER BY TD DESC ),''),
CAASPP_ELAPCL2018 =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG18') AND (PT = 1) ORDER BY TD DESC ),''),
CAASPP_MathScore2018 =  ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG18') AND (PT = 2) ORDER BY TD DESC ),''),
CAASPP_MathPCL2018 =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG18') AND (PT = 2) ORDER BY TD DESC ),''),
CAASPP_ELAScore2017 =  ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG17') AND (PT = 1) ORDER BY TD DESC ),''),
CAASPP_ELAPCL2017 =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG17') AND (PT = 1) ORDER BY TD DESC ),''),
CAASPP_MathScore2017 =  ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG17') AND (PT = 2) ORDER BY TD DESC ),''),
CAASPP_MathPCL2017 =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG17') AND (PT = 2) ORDER BY TD DESC ),''),
MAP_LexileScore_Fall18 = ISNULL ((SELECT TOP (1) OT AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1809','1810','1811')) ORDER BY TD DESC ),''),
MAP_ELAScore_Fall18 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1809','1810','1811')) ORDER BY TD DESC ),''),
MAP_ELAPercentile_Fall18 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1809','1810','1811')) ORDER BY TD DESC ),''),
MAP_MathScore_Fall18 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1809','1810','1811')) ORDER BY TD DESC ),''),
MAP_MathPercentile_Fall18 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1809','1810','1811')) ORDER BY TD DESC ),''),
MAP_LexileScore_Spring18 = ISNULL ((SELECT TOP (1) OT AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1803','1804','1805','1806')) ORDER BY TD DESC ),''),
MAP_ELAScore_Spring18 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1803','1804','1805','1806')) ORDER BY TD DESC ),''),
MAP_ELAPercentile_Spring18 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1803','1804','1805','1806')) ORDER BY TD DESC ),''),
MAP_MathScore_Spring18 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1803','1804','1805','1806')) ORDER BY TD DESC ),''),
MAP_MathPercentile_Spring18 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1803','1804','1805','1806')) ORDER BY TD DESC ),''),
MAP_LexileScore_Fall17 = ISNULL ((SELECT TOP (1) OT AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1709','1710','1711')) ORDER BY TD DESC ),''),
MAP_ELAScore_Fall17 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1709','1710','1711')) ORDER BY TD DESC ),''),
MAP_ELAPercentile_Fall17 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1709','1710','1711')) ORDER BY TD DESC ),''),
MAP_MathScore_Fall17 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1709','1710','1711')) ORDER BY TD DESC ),''),
MAP_MathPercentile_Fall17 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1709','1710','1711')) ORDER BY TD DESC ),''),
SAT_READ_WRITE = ISNULL ((SELECT TOP (1) SC5 AS score FROM CTS WHERE (DEL = 0) AND (PID = stu.ID) AND (NM = 'SAT I') ORDER BY DT DESC ),''),
SAT_MATH = ISNULL ((SELECT TOP (1) SC6 AS score FROM CTS WHERE (DEL = 0) AND (PID = stu.ID) AND (NM = 'SAT I') ORDER BY DT DESC ),''),
SAT_TOTAL = ISNULL ((SELECT TOP (1) TTL AS score FROM CTS WHERE (DEL = 0) AND (PID = stu.ID) AND (NM = 'SAT I') ORDER BY DT DESC ),''),
PSAT89_READ_WRITE = ISNULL ((SELECT TOP (1) SC5 AS score FROM CTS WHERE (DEL = 0) AND (PID = stu.ID) AND (NM = 'PSAT89') ORDER BY DT DESC ),''),
PSAT89_MATH = ISNULL ((SELECT TOP (1) SC6 AS score FROM CTS WHERE (DEL = 0) AND (PID = stu.ID) AND (NM = 'PSAT89') ORDER BY DT DESC ),''),
PSAT89_TOTAL = ISNULL ((SELECT TOP (1) TTL AS score FROM CTS WHERE (DEL = 0) AND (PID = stu.ID) AND (NM = 'PSAT89') ORDER BY DT DESC ),''),
[F&P] =  ISNULL ((SELECT TOP (1) PL AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (PT = 0) ORDER BY TD DESC ),'')
FROM STU
where stu.del = 0
and stu.tg = ''
and stu.sc in (2,6,8,9,10,11,12,15,20,21,30,31,32,40,60,70)
order by school,grade,teacher
