SELECT
STU.ID AS 'ID',
[Tag] = CASE STU.TG
	WHEN 'I' THEN 'Inactive'
	WHEN 'N' THEN 'No Show'
	ELSE ''
END,
STU.SX AS 'Gender',
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
STU.SC,
STU.HSG AS 'Comp Status',
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
(SELECT TOP(1) ENR.ER FROM ENR WHERE ENR.ID = STU.ID AND ENR.YR = '2018' ORDER BY LD DESC) AS 'Exit Reason Code',
[Exit Reason] = CASE (SELECT TOP(1) ENR.ER FROM ENR WHERE ENR.ID = STU.ID AND ENR.YR = '2018' ORDER BY LD DESC)
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
[Race] = (CASE
	WHEN STU.ETH = 'Y' AND STU.RC1 > 100 THEN 'Hispanic'
	WHEN STU.RC1 = 100 THEN 'American Indian or Alaskan Native'
	WHEN STU.RC1 > 200 AND STU.RC1 < 300 THEN 'Asian'
	WHEN STU.RC1 > 300 AND STU.RC1 < 401 THEN 'Pacific Islander'
	WHEN STU.RC1 = 600 THEN 'Black or African American'
	WHEN STU.RC1 = 700 THEN 'White'
	ELSE 'Unknown'
END),
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
STU.U4 AS 'Migrant',
'Total GPA' = STU.TP,
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
AND STU.SC IN (30, 31, 32)
AND STU.GR = 12
ORDER BY STU.SC, STU.LN, STU.FN
