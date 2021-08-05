SELECT
STU.ID AS 'StudentID',
STU.LN + ', ' + STU.FN AS 'Name',
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
STU.GR AS 'Grade',
Teacher = (select TE from TCH where STU.CU = TCH.TN and STU.sc = TCH.sc and TCH.del = 0 and TCH.tn != 0),
LowSocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2020' and fre.eed = '6/30/2021' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else '' end,
SPED = stu.U2,
STU.U4 AS 'Migrant',
[LangFluency] = CASE STU.LF
  WHEN 'E' THEN 'English Only'
  WHEN 'L' THEN 'English Learner'
  WHEN 'R' THEN 'Redesignated'
  WHEN 'C' THEN 'Cum'
  WHEN 'I' THEN 'Initially Fluent'
  WHEN 'T' THEN 'TBD'
  WHEN 'N' THEN 'Needs Testing'
END,
Foster = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 190) AND (PGM.PED IS NULL)) = '190' THEN 'Y' ELSE '' END,
Homeless = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 191) AND (PGM.PED IS NULL)) = '191' THEN 'Y' ELSE '' END,
[FP_Spring2021Score] = ISNULL ((SELECT TOP (1) ROUND(SCR, 1) AS score FROM dbo.GBS WHERE (STU.DEL = 0) AND (GBS.SN = stu.SN) AND (GBS.SC = STU.SC) AND (GBS.AN = 902) AND (GBS.DC IS NOT NULL) ORDER BY DC DESC ),''),
[FP_Fall2020Score] = ISNULL ((SELECT TOP (1) ROUND(SCR, 1) AS score FROM dbo.GBS WHERE (STU.DEL = 0) AND (GBS.SN = stu.SN) AND (GBS.SC = STU.SC) AND (GBS.AN = 900) AND (GBS.DC IS NOT NULL) ORDER BY DC DESC ),''),
[FP_Spring2020Score] = ISNULL ((SELECT TOP (1) CAST(PL AS FLOAT) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (TA = '2T1920') AND (PT = 0) ORDER BY TD DESC ),''),
[FP_Fall2019Score] = ISNULL ((SELECT TOP (1) CAST(PL AS FLOAT) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (TA = 'BL1920') AND (PT = 0) ORDER BY TD DESC ),''),
MathScore_Spring2021_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('2011','2012','2101','2102','2103')) ORDER BY TD DESC ),''),
MathPercentile_Spring2021_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('2011','2012','2101','2102','2103')) ORDER BY TD DESC ),''),
ELAScore_Spring2021_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('2011','2012','2101','2102','2103')) ORDER BY TD DESC ),''),
ELAPercentile_Spring2021_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('2011','2012','2101','2102','2103')) ORDER BY TD DESC ),''),
MathScore_Fall2021_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('2009','2010','2008')) ORDER BY TD DESC ),''),
MathPercentile_Fall2021_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('2009','2010','2008')) ORDER BY TD DESC ),''),
ELAScore_Fall2021_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('2009','2010','2008')) ORDER BY TD DESC ),''),
ELAPercentile_Fall2021_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('2009','2010','2008')) ORDER BY TD DESC ),''),
MathScore_Spring1920_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
MathPercentile_Spring1920_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
ELAScore_Spring1920_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
ELAPercentile_Spring1920_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
MathScore_Fall1920_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
MathPercentile_Fall1920_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
ELAScore_Fall1920_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
ELAPercentile_Fall1920_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
ELPAC =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 0) ORDER BY TD DESC ),''),
Oral_ELPAC =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 1) ORDER BY TD DESC ),''),
Written_ELPAC =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 2) ORDER BY TD DESC ),''),
Listening_ELPAC =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 3) ORDER BY TD DESC ),''),
Speaking_ELPAC =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 4) ORDER BY TD DESC ),''),
Reading_ELPAC =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 5) ORDER BY TD DESC ),''),
Writing_ELPAC =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 6) ORDER BY TD DESC ),'')
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.GR < 6
AND STU.GR > 0
AND STU.SC IN (2,6,8,9,10,11,12,15)
