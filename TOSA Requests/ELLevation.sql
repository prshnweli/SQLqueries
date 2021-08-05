SELECT
STU.ID AS 'Student ID',
STU.LN + ', ' + STU.FN AS 'Name',
STU.GR AS 'Grade',
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
STU.LF AS 'LangFluency',
[F&P Spring 20] =  ISNULL ((SELECT TOP (1) PL AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (PT = 0) AND (TA = '2T1920') ORDER BY TD DESC ),''),
MathScore_Spring20_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
MathPercentile_Spring20_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
ELAScore_Spring20_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
ELAPercentile_Spring20_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),'')
FROM STU
WHERE STU.LF != 'E'
and stu.tg = ''
and stu.sc in (2,6,8,9,10,11,12,15,20,21,30,31,32)
AND STU.GR > 0
ORDER BY GR, SC, LN, FN


SELECT
STU.ID AS 'District Local ID',
STU.CID AS 'State Testing ID',
CAST(TST.TD AS DATE) AS 'Date Given',
STU.GR AS 'Student Grade Level',
STU.GR AS 'Test Grade Level',
TST.PL AS 'Domain Score or Level'
FROM STU
JOIN TST ON STU.ID = TST.PID
WHERE STU.TG = ''
AND STU.DEL = 0
AND STU.LF != 'E'
AND STU.SC IN (2,6,8,9,10,11,12,15)
AND TST.ID = 'F&P'
AND TST.TA = 'BL2021'
