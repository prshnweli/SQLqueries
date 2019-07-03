SELECT
STU.ID,
STU.FN,
STU.LN,
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
STU.GR,
SocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2017' and fre.eed = '6/30/2018' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end,
ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) ORDER BY TD DESC ),'') AS 'MAP_ELAScore',
ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) ORDER BY TD DESC ),'') AS 'MAP_ELAPercentile',
ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) ORDER BY TD DESC ),'') AS 'MAP_MathScore',
ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) ORDER BY TD DESC ),'') AS 'MAP_MathPercentile',
ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'DYS') AND (PT = 0) ORDER BY TD DESC ),'') AS 'Dyslexia',
CAASPP_ELAScore =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG18') AND (PT = 1) ORDER BY TD DESC ),''),
CAASPP_MathScore =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG18') AND (PT = 2) ORDER BY TD DESC ),''),
ISNULL ((SELECT TOP (1) CAST(PL AS FLOAT) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (TA = 'BL1819') AND (PT = 0) ORDER BY TD DESC ),'') AS '[F&P]',
Suspended = ISNULL ((SELECT TOP (1) SU AS score FROM AHS WHERE (YR >= '2010-2011') AND (YR <= '2018-2019') AND (AHS.ID = stu.ID) ORDER BY SU DESC ),''),
STU.U2 AS 'SPED',
STU.LF AS 'LangFluency',
AHS.YR,
(CAST(AHS.PR AS FLOAT)/NULLIF(AHS.EN,0)) AS 'Attendance'
FROM STU AS STU
JOIN AHS AS AHS
  ON (STU.ID = AHS.ID)


where stu.del = 0
and stu.sc in (2,6,8,9,10,11,12,15)
and stu.gr in (0,1,2,3,4,5,6,7,8)
AND YR = '2018-2019'
order by SC,GR,LN,FN;

 
