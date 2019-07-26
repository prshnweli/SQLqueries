USE Aeries

SELECT
STU.CID AS "Student ID",
schoolID = stu.id,
StudentFN = stu.fn,
StudentLN = stu.ln,
stu.sc,
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
LastSchool = ( select LOC.NM from LOC where stu.LS = LOC.CD),
Grade = stu.gr,
SocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2018' and fre.eed = '6/30/2019' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end,
Ethnicity = STU.ETH,
LangFluency = stu.lf,
SPED = stu.U2,
Migrant = stu.U4,
[ParentEdLVL] = (CASE STU.PED
  WHEN 10 THEN 'Grad School/post grad trng '
  WHEN 11 THEN 'College Graduate'
  WHEN 12 THEN 'Some College'
  WHEN 13 THEN 'High School Graduate'
  WHEN 14 THEN 'Not HS Graduate'
  WHEN 15 THEN 'Declined to state/Unknown'
  END),
ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) ORDER BY TD DESC ),'') AS 'MAP_ELAScore',
ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) ORDER BY TD DESC ),'') AS 'MAP_ELAPercentile',
ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) ORDER BY TD DESC ),'') AS 'MAP_MathScore',
ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) ORDER BY TD DESC ),'') AS 'MAP_MathPercentile',
[F&P] =  ISNULL ((SELECT TOP (1) PL AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (PT = 0) ORDER BY TD DESC ),'')
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.GR = 6
AND STU.SC = 20
ORDER BY LN, FN
