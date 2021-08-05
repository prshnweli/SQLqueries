SELECT
STU.ID AS 'StudentID',
STU.SX AS 'Gender',
STU.GR AS 'Grade',
STU.CHT AS 'Cohort',
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
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
GoldenStateSeal = CASE WHEN (SELECT TOP(1) CD FROM ACT WHERE (STU.ID = ACT.PID) AND (ACT.CD = 'GSS')) = 'GSS' THEN 'Y' ELSE '' END,
StateSealBiliteracy = CASE WHEN (SELECT TOP(1) CD FROM ACT WHERE (STU.ID = ACT.PID) AND (ACT.CD = 'SSB')) = 'SSB' THEN 'Y' ELSE '' END,
'Total_GPA' = STU.TP,
UCcredits = (SELECT UN FROM CER WHERE (STU.ID = CER.ID) AND (CER.SA = 'TOTAL')),
CSUcredits = (SELECT CN FROM CER WHERE (STU.ID = CER.ID) AND (CER.SA = 'TOTAL'))
FROM STU
WHERE STU.DEL = 0
--AND STU.TG = ''
AND STU.SC IN (30,31,32,60)
AND STU.GR = 12
--AND STU.CHT = '2020-2021'
--stu.cht cohort

-- CPW Career Pathway table CPW.CM = 1 (Completer = True)
-- LIST STU CPW STU.SC STU.ID STU.NM STU.GR CPW.CD CPW.CM IF CPW.CM = 1

-- ACT has State Seal of Biliteracy and Golden State Seal (ACT.CD)
