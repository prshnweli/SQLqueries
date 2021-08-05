SELECT
STU.ID AS 'ID',
STU.LN + ', ' + STU.FN AS 'Name',
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
STU.GR AS "Grade",
[ParentEdLvl] = CASE STU.PED
	WHEN 10 THEN 'Grad School/post grad trng'
	WHEN 11 THEN 'College Graduate'
	WHEN 12 THEN 'Some College'
	WHEN 13 THEN 'High School Graduate'
	WHEN 14 THEN 'Not HS Graduate'
	WHEN 15 THEN 'Declined to State/Unkown'
END,
(select de from cod where tc = 'stu' and fc = 'eth' and cod.cd = stu.ETH)  AS 'Ethnicity',
Race = (select rtrim(DE) from COD where COD.CD = stu.ec and cod.del = 0 and cod.tc = 'stu' and cod.fc = 'ec'),
LowSocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2020' and fre.eed = '6/30/2021' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end,
(select de from cod where tc = 'stu' and fc = 'lf' and cod.cd = stu.lf) as [LangFluency],
STU.U2 AS 'SPED',
'504s' = CASE WHEN STU.ID IN (SELECT FOF.ID FROM FOF WHERE FOF.ID = STU.ID AND FOF.SD IS NOT NULL AND FOF.ED IS NULL) THEN 'Y' ELSE '' END,
STU.U4 AS 'Migrant',
MathScore_Fall1819_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1809','1810','1808')) ORDER BY TD DESC ),''),
MathPercentile_Fall1819_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1809','1810','1808')) ORDER BY TD DESC ),''),
MathScore_Spring1819_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1811','1812','1901','1902','1903')) ORDER BY TD DESC ),''),
MathPercentile_Spring1819_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1811','1812','1901','1902','1903')) ORDER BY TD DESC ),''),
ELAScore_Fall1819_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1809','1810','1808')) ORDER BY TD DESC ),''),
ELAPercentile_Fall1819_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1809','1810','1808')) ORDER BY TD DESC ),''),
ELAScore_Spring1819_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1811','1812','1901','1902','1903')) ORDER BY TD DESC ),''),
ELAPercentile_Spring1819_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1811','1812','1901','1902','1903')) ORDER BY TD DESC ),''),
MathScore_Fall1920_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
MathPercentile_Fall1920_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
MathScore_Spring1920_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
MathPercentile_Spring1920_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
ELAScore_Fall1920_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
ELAPercentile_Fall1920_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
ELAScore_Spring1920_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
ELAPercentile_Spring1920_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
ELASCR2019_CAASPP =  ISNULL ((SELECT TOP (1) cast( SS as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 1) ORDER BY TD DESC ),''),
ELAPCL2019_CAASPP =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 1) ORDER BY TD DESC ),''),
MathSCR2019_CAASPP =  ISNULL ((SELECT TOP (1) cast( SS as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 2) ORDER BY TD DESC ),''),
MathPCL2019_CAASPP =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 2) ORDER BY TD DESC ),''),
MathScore_Fall2021_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('2009','2010','2008')) ORDER BY TD DESC ),''),
MathPercentile_Fall2021_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('2009','2010','2008')) ORDER BY TD DESC ),''),
ELAScore_Fall2021_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('2009','2010','2008')) ORDER BY TD DESC ),''),
ELAPercentile_Fall2021_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('2009','2010','2008')) ORDER BY TD DESC ),''),
[F&P BL 20] =  ISNULL ((SELECT TOP (1) PL AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (PT = 0) AND (TA = 'BL2021') ORDER BY TD DESC ),''),
[F&P BL 19] =  ISNULL ((SELECT TOP (1) PL AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (PT = 0) AND (TA = 'BL1920') ORDER BY TD DESC ),''),
[F&P BL 18] =  ISNULL ((SELECT TOP (1) PL AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (PT = 0) AND (TA = 'BL1819') ORDER BY TD DESC ),''),
Present1920 = (SELECT TOP(1) AHS.PR FROM AHS WHERE AHS.ID = STU.ID AND AHS.YR = '2019-2020'),
Excused1920 = (SELECT TOP(1) AHS.AE FROM AHS WHERE AHS.ID = STU.ID AND AHS.YR = '2019-2020'),
Unexcused1920 = (SELECT TOP(1) AHS.AU FROM AHS WHERE AHS.ID = STU.ID AND AHS.YR = '2019-2020'),
[Uses Hotspot] = CASE WHEN (SELECT SUP.DV1 FROM SUP WHERE STU.SC = SUP.SC AND STU.SN = SUP.SN) != '' THEN 'Yes' ELSE '' END
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC IN (2,6,8,9,10,11,12,15,20,21,30,31,32)
AND STU.GR > 1
ORDER BY STU.SC, STU.GR
