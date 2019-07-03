SELECT
ID = STU.ID,
"First Name" = STU.FN,
"Last Name" = STU.LN,
Grade = STU.GR,
Foster = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 190)) = '190' THEN 'Y' ELSE '' END,
Homeless = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 191)) = '191' THEN 'Y' ELSE '' END,
LangFluency = STU.LF,
"Long Term EL" = CASE WHEN (SELECT YP FROM LAC WHERE (STU.ID = LAC.ID)) > 3 THEN 'Y' ELSE '' END,
SocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2018' and fre.eed = '6/30/2019' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end,
SPED = STU.U2,
MAP_LexileScore_Winter19 = ISNULL ((SELECT TOP (1) OT AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1812','1901','1902','1903')) ORDER BY TD DESC ),''),
MAP_ELAScore_Winter19 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN ('1812','1901','1902','1903')) ORDER BY TD DESC ),''),
MAP_MathScore_Winter19 = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN ('1812','1901','1902','1903')) ORDER BY TD DESC ),''),
"Days Suspended" = ISNULL ((SELECT TOP (1) SU AS score FROM AHS WHERE (YR >= '2010-2011') AND (YR <= '2018-2019') AND (AHS.ID = stu.ID) ORDER BY SU DESC ),'')

FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.ID = 61646
