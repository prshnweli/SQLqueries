USE Aeries2018

SELECT
ID = STU.ID,
Name = STU.LN + ', ' + STU.FN,
Teacher = (select TE from TCH where STU.CU = TCH.TN and STU.sc = TCH.sc and TCH.del = 0 and TCH.tn != 0),
Grade = STU.GR,
MathSCR2019_CAASPP =  ISNULL ((SELECT TOP (1) cast( ts.SS as int) AS score FROM Aeries.dbo.TST AS ts WHERE (ts.DEL = 0) AND (PID = stu.ID) AND (ts.ID = 'SBAC') AND (ts.TA = 'SPRG19') AND (ts.PT = 2) ORDER BY ts.TD DESC ),''),
MathSCR2019_CAASPP =  ISNULL ((SELECT TOP (1) cast( ts.PL as int) AS score FROM Aeries.dbo.TST AS ts WHERE (ts.DEL = 0) AND (PID = stu.ID) AND (ts.ID = 'SBAC') AND (ts.TA = 'SPRG19') AND (ts.PT = 2) ORDER BY ts.TD DESC ),''),
MAP_MathScore_Fall18 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1808','1809','1810','1811')) ORDER BY TD DESC ),''),
MAP_MathPercentile_Fall18 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1808','1809','1810','1811')) ORDER BY TD DESC ),''),
MAP_MathScore_Spring19 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1812','1901','1902','1903','1904')) ORDER BY TD DESC ),''),
MAP_MathPercentile_Spring19 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1812','1901','1902','1903','1904')) ORDER BY TD DESC ),'')
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC IN (2)
AND STU.GR IN (3,4,5)
ORDER BY STU.SC, STU.GR, STU.LN, STU.FN
