SELECT
STU.ID AS 'Student Id',
STU.GR AS 'Grade',
LowSocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2019' and fre.eed = '6/30/2020' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end,
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
CASE WHEN STU.U1 = 'Y' AND (SELECT TOP(1) FOF.ED FROM FOF WHERE STU.ID = FOF.ID) IS NULL THEN 'Y' ELSE '' END AS '504',
[ParentEdLvl] = CASE STU.PED
	WHEN 10 THEN 'Grad School/post grad trng'
	WHEN 11 THEN 'College Graduate'
	WHEN 12 THEN 'Some College'
	WHEN 13 THEN 'High School Graduate'
	WHEN 14 THEN 'Not HS Graduate'
	WHEN 15 THEN 'Declined to State/Unkown'
END,
School = (SELECT LOC.NM FROM LOC WHERE STU.SC = LOC.CD),
(SELECT TOP(1) ENR.ED FROM ENR WHERE STU.SC = ENR.SC AND STU.SN = ENR.SN AND ENR.ED > '2010/08/15' ORDER BY ENR.ED ASC) AS 'School Entry Date',
CASE WHEN STU.GR > 5 THEN
  CASE STU.LS
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
  ELSE ''
END END
  AS 'Previous School',
-- AS 'Elementary School Entry Date',
Dyslexia = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'DYS') AND (PT = 0) ORDER BY TD DESC ),''),
'Dyslexia Date' = ISNULL ((SELECT TOP (1) TD AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'DYS') AND (PT = 0) ORDER BY TD DESC ),''),
ISNULL ((SELECT TOP (1) SS FROM (select top(2) SS,td from TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'DYS') AND (PT = 0) ORDER BY TD desc ) as score  ORDER BY TD asc ),'') AS 'Prior Dyslexia Screen Score',
ISNULL ((SELECT TOP (1) TD FROM (select top(2) SS,td from TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'DYS') AND (PT = 0) ORDER BY TD desc ) as score  ORDER BY TD asc ),'')  AS 'Prior Score Date',
ELAScore2019_CAASPP =  ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 1) ORDER BY TD DESC ),''),
ReadingScore_Fall19_MAP = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1908','1909','1910','1911')) ORDER BY TD DESC ),''),
ISNULL ((SELECT TOP (1) ROUND(SCR, 1) AS score FROM dbo.GBS WHERE (GBS.DEL = 0) AND (GBS.SN = stu.SN) AND (GBS.SC = STU.SC) AND (GBS.AN = 900) AND (GBS.DC IS NOT NULL) ORDER BY DC DESC ),'') as [F&P Fall19],
Overall_Perf_ELPAC =  NULLIF(ISNULL ((SELECT TOP (1) cast( PL AS INT) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 0) ORDER BY TD DESC ),''), 0)
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.GR > -1
AND STU.GR < 9
AND STU.SC IN (2,6,8,9,10,11,12,15,20,21)
ORDER BY STU.SC, STU.GR
