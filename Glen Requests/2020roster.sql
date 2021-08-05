SELECT
STU.ID AS 'ID',
STU.LN + ', ' + STU.FN AS 'Name',
STU.GR AS 'Grade',
(SELECT TOP(1) TE FROM DST19000MorganHill.dbo.TCH AS TC19 WHERE ST19.CU = TC19.TN AND ST19.SC = TC19.SC AND TC19.DEL = 0) AS 'Previous Teacher',
Teacher = (select TE from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 ),
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
[LangFluency] = CASE STU.LF
  WHEN 'E' THEN 'English Only'
  WHEN 'L' THEN 'English Learner'
  WHEN 'R' THEN 'Redesignated'
  WHEN 'C' THEN 'Cum'
  WHEN 'I' THEN 'Initially Fluent'
  WHEN 'T' THEN 'TBD'
  WHEN 'N' THEN 'Needs Testing'
END,
STU.U2 AS 'SPED',
STU.U4 AS 'Migrant',
STU.U9 AS 'Internet',
STU.U10 AS 'Smart Phone',
[F&P] =  ISNULL ((SELECT TOP (1) PL AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (PT = 0) AND(TA = '2T1920') ORDER BY TD DESC ),''),
MathScore_Fall19_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
MathPercentile_Fall19_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
MathScore_Spring20_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
MathPercentile_Spring20_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
ELAScore_Fall19_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
ELAPercentile_Fall19_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
ELAScore_Spring20_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
ELAPercentile_Spring20_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),'')
FROM STU
JOIN DST19000MorganHill.dbo.STU as ST19 on (STU.ID = ST19.ID AND ST19.DEL = 0 AND ST19.TG = '')
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC IN (2,6,8,9,10,11,12,15)
AND STU.GR > 0
AND STU.GR < 6
GROUP BY STU.ID, STU.LN, STU.FN, STU.GR, STU.LF, STU.U2, STU.U4, STU.U9, STU.U10, STU.CU, STU.SC, ST19.CU, ST19.SC
ORDER BY STU.SC, STU.GR, STU.LN, STU.FN
