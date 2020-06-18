SELECT
STU.FN AS 'First Name',
STU.LN AS 'Last Name',
STU.GR AS 'Grade',
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
STU.AD AS 'Address',
STU.CY AS 'City',
STU.ST AS 'State',
STU.ZC AS 'Zip Code',
MathScore_Spring20_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
MathPercentile_Spring20_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
MathScore2019_CAASPP =  ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 2) ORDER BY TD DESC ),''),
MathPCL2019_CAASPP =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 2) ORDER BY TD DESC ),'')
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC IN (2,6,8,9,10,11,12,15)
AND STU.GR IN (3,4,5)
