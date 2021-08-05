SELECT
STU.ID AS 'StudentID',
STU.FN AS 'FirstName',
STU.LN AS 'LastName',
STU.GR AS 'Grade',
STU.SX AS 'Gender',
(select de from cod where tc = 'stu' and fc = 'eth' and cod.cd = stu.ETH)  AS 'Ethnicity',
Race = (select rtrim(DE) from COD where COD.CD = stu.ec and cod.del = 0 and cod.tc = 'stu' and cod.fc = 'ec'),
STU.U2 AS 'SPED',
[LangFluency] = CASE STU.LF
  WHEN 'E' THEN 'English Only'
  WHEN 'L' THEN 'English Learner'
  WHEN 'R' THEN 'Redesignated'
  WHEN 'C' THEN 'Cum'
  WHEN 'I' THEN 'Initially Fluent'
  WHEN 'T' THEN 'TBD'
  WHEN 'N' THEN 'Needs Testing'
END,
LowSocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2020' and fre.eed = '6/30/2021' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else '' end,
ELAScore_Fall19_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
ELAPercentile_Fall19_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
ELAScore_Spring20_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
ELAPercentile_Spring20_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1911','1912','2001','2002','2003')) ORDER BY TD DESC ),''),
ELAScore_Fall20_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('2009','2010','2008')) ORDER BY TD DESC ),''),
ELAPercentile_Fall20_MAP = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('2009','2010','2008')) ORDER BY TD DESC ),'')
from STU
WHERE STU.TG = ''
AND STU.DEL = 0
AND STU.SC IN (2,6,8,9,10,11,12,15,20,21,30,31,32)
