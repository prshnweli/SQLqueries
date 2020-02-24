SELECT
StudentID = stu.id,
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
Grade = stu.gr,
SocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2019' and fre.eed = '6/30/2020' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end,
Ethnicity = STU.ETH,
[Race] = (CASE
	WHEN STU.ETH = 'Y' AND STU.RC1 > 100 THEN 'Hispanic'
	WHEN STU.RC1 = 100 THEN 'American Indian or Alaskan Native'
	WHEN STU.RC1 > 200 AND STU.RC1 < 300 THEN 'Asian'
	WHEN STU.RC1 > 300 AND STU.RC1 < 401 THEN 'Pacific Islander'
	WHEN STU.RC1 = 600 THEN 'Black or African American'
	WHEN STU.RC1 = 700 THEN 'White'
	ELSE 'Unknown'
END),
[Race 2] = (CASE
	WHEN STU.ETH = 'Y' AND STU.RC2 > 100 THEN 'Hispanic'
	WHEN STU.RC2 = 100 THEN 'American Indian or Alaskan Native'
	WHEN STU.RC2 > 200 AND STU.RC1 < 300 THEN 'Asian'
	WHEN STU.RC2 > 300 AND STU.RC1 < 401 THEN 'Pacific Islander'
	WHEN STU.RC2 = 600 THEN 'Black or African American'
	WHEN STU.RC2 = 700 THEN 'White'
	ELSE ''
END),
[LangFluency] = CASE STU.LF
  WHEN 'E' THEN 'English Only'
  WHEN 'L' THEN 'English Learner'
  WHEN 'R' THEN 'Redesignated'
  WHEN 'C' THEN 'Cum'
  WHEN 'I' THEN 'Initially Fluent'
  WHEN 'T' THEN 'TBD'
  WHEN 'N' THEN 'Needs Testing'
END,
"Long Term EL" = CASE WHEN (SELECT YP FROM LAC WHERE (STU.ID = LAC.ID)) > 3 THEN 'Y' ELSE '' END,
SPED = stu.U2,
Migrant = stu.U4,
[ParentEdLvl] = CASE STU.PED
	WHEN 10 THEN 'Grad School/post grad trng'
	WHEN 11 THEN 'College Graduate'
	WHEN 12 THEN 'Some College'
	WHEN 13 THEN 'High School Graduate'
	WHEN 14 THEN 'Not HS Graduate'
	WHEN 15 THEN 'Declined to State/Unkown'
END,
DistrictEntry = CONVERT(DATE, STU.DD)
FROM STU
where stu.del = 0
and stu.tg = ''
and stu.sc in (2,6,8,9,10,11,12,15,20,21,30,31,32)
