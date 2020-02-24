SELECT
StudentID = STU.ID,
StudentLastName = STU.LN,
StudentFirstName = STU.FN,
STU.GR AS 'Grade',
SocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2019' and fre.eed = '6/30/2020' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end,
[Race] = (CASE
	WHEN STU.ETH = 'Y' AND STU.RC1 > 100 THEN 'Hispanic'
	WHEN STU.RC1 = 100 THEN 'American Indian or Alaskan Native'
	WHEN STU.RC1 > 200 AND STU.RC1 < 300 THEN 'Asian'
	WHEN STU.RC1 > 300 AND STU.RC1 < 401 THEN 'Pacific Islander'
	WHEN STU.RC1 = 600 THEN 'Black or African American'
	WHEN STU.RC1 = 700 THEN 'White'
	ELSE 'Unknown'
END),
Ethnicity = STU.ETH,
[LangFluency] = CASE STU.LF
  WHEN 'E' THEN 'English Only'
  WHEN 'L' THEN 'English Learner'
  WHEN 'R' THEN 'Redesignated'
  WHEN 'C' THEN 'Cum'
  WHEN 'I' THEN 'Initially Fluent'
  WHEN 'T' THEN 'TBD'
  WHEN 'N' THEN 'Needs Testing'
END,
SPED = stu.U2,
MAP_ELAScore_Fall19 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
MAP_ELAPercentile_Fall19 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1909','1910','1908')) ORDER BY TD DESC ),''),
MAP_ELAScore_Spring_WINT19 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1812','1901','1902','1903','1904','1905','1906')) ORDER BY TD DESC ),''),
MAP_ELAPercentile_Spring_WINT19 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1812','1901','1902','1903','1904','1905','1906')) ORDER BY TD DESC ),''),
MAP_ELAScore_Fall18 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1809','1810','1811')) ORDER BY TD DESC ),''),
MAP_ELAPercentile_Fall18 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1809','1810','1811')) ORDER BY TD DESC ),''),
MAP_ELAScore_Spring_WINT18 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1712','1801','1802','1803','1804','1805','1806')) ORDER BY TD DESC ),''),
MAP_ELAPercentile_Spring_WINT18 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1712','1801','1802','1803','1804','1805','1806')) ORDER BY TD DESC ),''),
MAP_ELAScore_Fall17 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1709','1710','1711')) ORDER BY TD DESC ),''),
MAP_ELAPercentile_Fall17 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1709','1710','1711')) ORDER BY TD DESC ),''),
MAP_ELAScore_Spring_WINT17 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1612','1701','1702','1703','1704','1705','1706')) ORDER BY TD DESC ),''),
MAP_ELAPercentile_Spring_WINT17 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1612','1701','1702','1703','1704','1705','1706')) ORDER BY TD DESC ),''),
MAP_ELAScore_Fall16 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('WNTR16','1609','1610','1611')) ORDER BY TD DESC ),''),
MAP_ELAPercentile_Fall16 = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('WNTR16','1609','1610','1611')) ORDER BY TD DESC ),'')
FROM STU
where stu.del = 0
and stu.tg = ''
and stu.sc = 31
ORDER BY STU.GR, STU.LN, STU.FN
