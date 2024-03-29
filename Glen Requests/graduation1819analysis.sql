SELECT
STU.ID AS 'ID',
STU.LN + ', ' + STU.FN AS 'Name',
[Tag] = CASE STU.TG
	WHEN 'I' THEN 'Inactive'
	WHEN 'N' THEN 'No Show'
	ELSE ''
END,
STU.SX AS 'Gender',
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
STU.SC,
STU.HSG AS 'Comp Status',
STU.CHT AS 'Cohort',
[CompDesc] = CASE STU.HSG
	WHEN 100 THEN 'Graduated, standard HS diploma'
	WHEN 104 THEN 'Completed all local and state grad reqs, failed CAHSEE'
	WHEN 106 THEN 'Grad, CAHSEE mods & waiver'
	WHEN 108 THEN 'Grad, CAHSEE exempt'
	WHEN 120 THEN 'Special Education certificate of completion'
	WHEN 250 THEN 'Adult Ed High School Diploma'
	WHEN 320 THEN 'Completed GED (and no standard HS diploma)'
	WHEN 330 THEN 'Passed CHSPE (and no standard HS diploma)'
	WHEN 360 THEN 'Completed grade 12 w/o completing grad reqs, not grad'
	WHEN 480 THEN 'Promoted (matriculated)'
END,
CONVERT(DATE,STU.DG) AS 'Comp Date',
STU.GRT AS 'Graduation Track',
[Graduation Track] = CASE STU.GRT
	WHEN 'B' THEN 'Traditional Pathway'
	WHEN 'C' THEN 'AB 216/167'
	WHEN 'D' THEN 'Traditional Pathway (Spanish Requirement)'
END,
DistrictEntry = CONVERT(DATE, STU.DD),
CONVERT(DATE, STU.LD) AS 'Leave Date',
(SELECT TOP(1) ENR.ER FROM ENR WHERE ENR.ID = STU.ID AND ENR.YR = '2019' ORDER BY LD DESC) AS 'Exit Reason Code',
[Exit Reason] = CASE (SELECT TOP(1) ENR.ER FROM ENR WHERE ENR.ID = STU.ID AND ENR.YR = '2019' ORDER BY LD DESC)
	WHEN 125 THEN 'SpecEd Exit, (Prior Completer)'
	WHEN 130 THEN 'Deceased'
	WHEN 140 THEN 'Truant - Next school unknown'
	WHEN 160 THEN 'Moved - Verified in other CA Public Schl'
	WHEN 165 THEN 'Involuntary Transfer for Discipline'
	WHEN 167 THEN 'Alt Ed or Ind Stdy Transfer, Non-Discip'
	WHEN 180 THEN 'Moved - Verified in CA Private School'
	WHEN 200 THEN 'Moved - Verified in US Dist or School (Outside CA)'
	WHEN 230 THEN 'Completer Exit (Finished Highest Grade)'
	WHEN 240 THEN 'Moved - Foreign Country'
	WHEN 260 THEN 'Left - Verified in Adult Ed. Program'
	WHEN 270 THEN 'Left - Unverif in Adult Ed Prgm (or withdrew from)'
	WHEN 280 THEN 'Left - Verified in Post-Sec Inst.'
	WHEN 300 THEN 'Expelled (w/ no further academic program)'
	WHEN 310 THEN 'Hospitalized'
	WHEN 320 THEN 'GED or Adult Ed Diploma'
	WHEN 330 THEN 'Verif. CHSPE'
	WHEN 360 THEN 'High grade compl., Unverif continuation'
	WHEN 370 THEN 'Entered Inst./Mil. in Diploma pgm.'
	WHEN 380 THEN 'Entered Inst./Mil. not in Diploma pgm.'
	WHEN 400 THEN 'Other or Unknown'
	WHEN 410 THEN 'Left - Medical Reasons'
	WHEN 420 THEN 'No Show - Same School'
	WHEN 430 THEN 'No Show - From Matriculation'
	WHEN 440 THEN 'Program or Grade Change'
	WHEN 450 THEN 'Grade K-6 Withdrawal'
	WHEN 460 THEN 'Home School - non-affiliated'
	WHEN 470 THEN 'Pre-Enrolled, but never attended'
END,
[ParentEdLvl] = CASE STU.PED
	WHEN 10 THEN 'Grad School/post grad trng'
	WHEN 11 THEN 'College Graduate'
	WHEN 12 THEN 'Some College'
	WHEN 13 THEN 'High School Graduate'
	WHEN 14 THEN 'Not HS Graduate'
	WHEN 15 THEN 'Declined to State/Unkown'
END,
STU.ETH AS 'Ethnicity',
Race = (select rtrim(DE) from COD where COD.CD = stu.ec and cod.del = 0 and cod.tc = 'stu' and cod.fc = 'ec'),
LowSocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2020' and fre.eed = '6/30/2021' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end,
(select de from cod where tc = 'stu' and fc = 'lf' and cod.cd = stu.lf) as [LangFluency],
STU.U2 AS 'SPED',
STU.U4 AS 'Migrant',
Foster = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 190) AND (PGM.PED IS NULL)) = '190' THEN 'Y' ELSE '' END,
Homeless = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 191) AND (PGM.PED IS NULL)) = '191' THEN 'Y' ELSE '' END,
'Total GPA' = STU.TP,
UCcredits = (SELECT UN FROM CER WHERE (STU.ID = CER.ID) AND (CER.SA = 'TOTAL')),
CSUcredits = (SELECT CN FROM CER WHERE (STU.ID = CER.ID) AND (CER.SA = 'TOTAL')),
'Credits Complete 18_19' = (SELECT SUM(CC) FROM HIS WHERE STU.ID = HIS.PID AND HIS.YR = 18),
'Credits Complete 17_18' = (SELECT SUM(CC) FROM HIS WHERE STU.ID = HIS.PID AND HIS.YR = 17),
'Credits Complete 16_17' = (SELECT SUM(CC) FROM HIS WHERE STU.ID = HIS.PID AND HIS.YR = 16),
'Credits Complete 15_16' = (SELECT SUM(CC) FROM HIS WHERE STU.ID = HIS.PID AND HIS.YR = 15),
'CAASPP_ELAScore' =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (PT = 1) ORDER BY TD DESC ),''),
'CAASPP_ELAProfLvl' =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (PT = 1) ORDER BY TD DESC ),''),
'CAASPP_MathScore' =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (PT = 2) ORDER BY TD DESC ),''),
'CAASPP_MathProfLvl' =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (PT = 2) ORDER BY TD DESC ),''),
Attendance1819 = CAST(
	((SELECT CAST(SUM(AHS.PR) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2018-2019'))/((SELECT CAST(SUM(AHS.EN) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2018-2019'))
AS DECIMAL(10,2)),
Attendance1718 = CAST(
	((SELECT CAST(SUM(AHS.PR) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2017-2018'))/((SELECT CAST(SUM(AHS.EN) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2017-2018'))
AS DECIMAL(10,2)),
Attendance1617 = CAST(
	((SELECT CAST(SUM(AHS.PR) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2016-2017'))/((SELECT CAST(SUM(AHS.EN) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2016-2017'))
AS DECIMAL(10,2)),
Attendance1516 = CAST(
	((SELECT CAST(SUM(AHS.PR) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2015-2016'))/((SELECT CAST(SUM(AHS.EN) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = '2015-2016'))
AS DECIMAL(10,2))
FROM STU
WHERE STU.DEL = 0
--AND STU.TG = ''
AND STU.SC IN (30,60)
AND STU.GR = 12
--AND STU.HSG != ''
ORDER BY STU.SC, STU.LN, STU.FN
