SELECT
StudentName = STU.LN + ', ' + STU.FN + ' ' + LEFT(STU.MN, 1),
StudentID = stu.id,
Grade = stu.gr,
SSID = STU.CID,
Birthday = STU.BD,
Gender = STU.SX,
[Race] = (CASE
	WHEN STU.ETH = 'Y' AND STU.RC1 > 100 THEN 'Hispanic'
	WHEN STU.RC1 = 100 THEN 'American Indian or Alaskan Native'
	WHEN STU.RC1 > 200 AND STU.RC1 < 300 THEN 'Asian'
	WHEN STU.RC1 > 300 AND STU.RC1 < 401 THEN 'Pacific Islander'
	WHEN STU.RC1 = 600 THEN 'Black or African American'
	WHEN STU.RC1 = 700 THEN 'White'
	ELSE 'Unknown'
END),
ReportingLang = STU.HL,
CorrLang = STU.CL,
SPED = stu.U2,
'504s' = CASE WHEN STU.ID IN (SELECT FOF.ID FROM FOF WHERE FOF.ID = STU.ID AND FOF.SD IS NOT NULL AND FOF.ED IS NULL) THEN 'Yes' ELSE 'No' END,
GATE = CASE WHEN STU.ID IN (SELECT GTE.ID FROM GTE WHERE GTE.ID = STU.ID AND GTE.ID IS NOT NULL AND GTE.EED IS NULL) THEN 'Yes' ELSE 'No' END,
SocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2019' and fre.eed = '6/30/2020' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end,
[ParentEdLvl] = CASE STU.PED
	WHEN 10 THEN 'Grad School/post grad trng'
	WHEN 11 THEN 'College Graduate'
	WHEN 12 THEN 'Some College'
	WHEN 13 THEN 'High School Graduate'
	WHEN 14 THEN 'Not HS Graduate'
	WHEN 15 THEN 'Declined to State/Unkown'
END,
Retained = CASE WHEN (SELECT CD FROM RET WHERE (RET.PID = STU.ID) AND (RET.CD = 'R')) = 'R' THEN 'Y' ELSE '' END,
DistrictEntry = CONVERT(DATE, STU.DD),
USSchoolEntry = CONVERT(DATE, (SELECT LAC.USE FROM LAC WHERE LAC.ID = STU.ID AND STU.TG = '' AND STU.DEL = 0)),
CAASPP_ELAScore2019 =  ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 1) ORDER BY TD DESC ),''),
CAASPP_ELAPCL2019 =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 1) ORDER BY TD DESC ),''),
CAASPP_MathScore2019 =  ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 2) ORDER BY TD DESC ),''),
CAASPP_MathPCL2019 =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 2) ORDER BY TD DESC ),'')
FROM STU
where stu.del = 0
and stu.tg = ''
and stu.sc in (32)
