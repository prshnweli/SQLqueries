--Master file:
--Note that students who have entered the district at a low grade like K but show a more recent entry date do not have continuous years in the district.
SELECT
STU.ID AS 'StudentID',
STU.LN + ', ' + STU.FN AS 'Name',
CONVERT(DATE, STU.BD) AS 'DOB',
DistrictEntry = CONVERT(DATE, STU.DD),
[US School Entry] = (SELECT CONVERT(DATE, USS) FROM LAC WHERE STU.ID = LAC.ID),
(SELECT MIN(ENR.GR) FROM ENR WHERE ENR.ID = STU.ID AND ENR.SC IN (2,6,8,9,10,11,12,15,20,21,30,31,32)) AS 'Grade Level Entry to MH',
STU.SX AS 'Gender',
ELASCR_CAA = ISNULL ((SELECT TOP (1) cast( SS as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CAA') AND (PT = 1) ORDER BY TD DESC ),''),
MathSCR_CAA = ISNULL ((SELECT TOP (1) cast( SS as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CAA') AND (PT = 2) ORDER BY TD DESC ),'')
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC IN (2,6,8,9,10,11,12,15,20,21,30,31,32)
AND STU.GR IN (3,4,5,6,7,8,9,10,11,12)
AND STU.DD < '09/01/18'

--Yearly look
DECLARE @SchoolYear VARCHAR(30), @StartDate VARCHAR(30), @EndDate VARCHAR(30), @Dys VARCHAR(30), @MAPsep VARCHAR(30), @MAPoct VARCHAR(30), @MAPaug VARCHAR(30), @MAPnov VARCHAR(30), @MAPdec VARCHAR(30), @MAPjan VARCHAR(30), @MAPfeb VARCHAR(30), @MAPmar VARCHAR(30), @SBAC VARCHAR(30);

SET @SchoolYear = '2020-2021'; -- for attendance calculations
SET @StartDate = '7/1/2020'; -- for free and reduced
SET @EndDate = '6/30/2021'; -- for free and reduced
SET @Dys = 'FALL20'; -- Dyslexia ID
SET @MAPsep ='2009'; --MAP TAs
SET @MAPoct = '2010';
SET @MAPaug = '2008';
SET @MAPnov ='2011';
SET @MAPdec = '2012';
SET @MAPjan = '2101';
SET @MAPfeb = '2102';
SET @MAPmar = '2103';
SET @SBAC = 'SPRG19';


SELECT
@SchoolYear AS 'Year',
STU.ID AS 'StudentID',
STU.GR AS 'Grade',
((SELECT CAST(SUM(AHS.PR) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = @SchoolYear))/((SELECT CAST(SUM(AHS.EN) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = @SchoolYear AND AHS.EN != 0)) AS 'OverallDaysAttended',
((SELECT CAST(SUM(AHS.AE) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = @SchoolYear))/((SELECT CAST(SUM(AHS.EN) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = @SchoolYear AND AHS.EN != 0)) AS 'ExcusedAbs',
((SELECT CAST(SUM(AHS.AU) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = @SchoolYear))/((SELECT CAST(SUM(AHS.EN) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = @SchoolYear AND AHS.EN != 0)) AS 'UnexcusedAbs',
[ChronicAbs] = CASE WHEN
CAST(
	((SELECT CAST(SUM(AHS.PR) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = @SchoolYear))/((SELECT CAST(SUM(AHS.EN) AS FLOAT) FROM AHS WHERE (AHS.ID = STU.ID) AND AHS.YR = @SchoolYear AND AHS.EN != 0))
AS DECIMAL(10,2)) < .9 THEN 'Y'
ELSE '' END,
SPED = STU.U2,
Disability = (SELECT DI FROM CSE WHERE CSE.ID = STU.ID AND CSE.DEL = 0),
Disability2 = (SELECT DI2 FROM CSE WHERE CSE.ID = STU.ID AND CSE.DEL = 0),
GATE = CASE WHEN (SELECT GTE.ESD FROM GTE WHERE GTE.ID = STU.ID) IS NOT NULL AND (SELECT GTE.EED FROM GTE WHERE GTE.ID = STU.ID) IS NULL THEN 'Y' ELSE 'N' END,
[LangFluency] = CASE STU.LF
  WHEN 'E' THEN 'English Only'
  WHEN 'L' THEN 'English Learner'
  WHEN 'R' THEN 'Redesignated'
  WHEN 'C' THEN 'Cum'
  WHEN 'I' THEN 'Initially Fluent'
  WHEN 'T' THEN 'TBD'
  WHEN 'N' THEN 'Needs Testing'
END,
[EL] = CASE STU.LF
  WHEN 'E' THEN 'N'
  WHEN 'T' THEN 'TBD'
  WHEN 'N' THEN 'Needs Testing'
  ELSE 'Y'
END,
[ELStartDate] = (SELECT CAST(LAC.SD AS DATE) FROM LAC WHERE STU.ID = LAC.ID) ,
"Long Term EL 6+" = CASE WHEN (SELECT YP FROM LAC WHERE (STU.ID = LAC.ID)) > 5 THEN 'Y' ELSE '' END,
[RedesignationDate] = (SELECT CAST(LAC.RD1 AS DATE) FROM LAC WHERE STU.ID = LAC.ID),
CASE (SELECT TOP(1) CD FROM FRE WHERE STU.ID = FRE.ID AND fre.esd > @StartDate and fre.eed = @EndDate)
  WHEN 'R' THEN 'R'
  WHEN 'F' THEN 'F'
  ELSE 'N'
END AS 'Free_Or_Reduced_Lunch',
[ParentEdLevel] = STU.PED,
[Ethnicity] = (CASE
	WHEN STU.ETH = 'Y' THEN 'Hispanic or Latino'
	WHEN STU.ETH = 'N' THEN 'Not Hispanic or Latino'
	WHEN STU.ETH = 'Z' THEN 'Decline to State'
END),
STU.RC1 AS 'Race Code 1',
STU.RC2 AS 'Race Code 2',
STU.RC3 AS 'Race Code 3',
STU.RC4 AS 'Race Code 4',
STU.RC5 AS 'Race Code 5',
STU.RAD AS 'Address',
STU.RCY AS 'City',
STU.RST AS 'State',
STU.RZC AS 'Zip Code',
Foster = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 190) AND (PGM.PED IS NULL)) = '190' THEN 'Y' ELSE '' END,
Homeless = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 191) AND (PGM.PED IS NULL)) = '191' THEN 'Y' ELSE '' END,
TeacherID = (select ID from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 ),
TeacherLastName = (select TLN from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 ),
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
DyslexiaScreen =  '',--ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'DYS') AND (TA = @Dys) ORDER BY TD DESC ),''),
[FP_FallScore] = ISNULL ((SELECT TOP (1) ROUND(SCR, 1) AS score FROM dbo.GBS WHERE (STU.DEL = 0) AND (GBS.SN = stu.SN) AND (GBS.SC = STU.SC) AND (GBS.AN = 900) AND (GBS.DC IS NOT NULL) ORDER BY DC DESC ),''),
[FP_FallDate] = ISNULL ((SELECT TOP (1) CAST(DC AS DATE) FROM dbo.GBS WHERE (STU.DEL = 0) AND (GBS.SN = stu.SN) AND (GBS.SC = STU.SC) AND (GBS.AN = 900) AND (GBS.DC IS NOT NULL) ORDER BY DC DESC ),''),
[FP_WintScore] = ISNULL ((SELECT TOP (1) ROUND(SCR, 1) AS score FROM dbo.GBS WHERE (STU.DEL = 0) AND (GBS.SN = stu.SN) AND (GBS.SC = STU.SC) AND (GBS.AN = 901) AND (GBS.DC IS NOT NULL) ORDER BY DC DESC ),''),
[FP_WintDate] = ISNULL ((SELECT TOP (1) CAST(DC AS DATE) FROM dbo.GBS WHERE (STU.DEL = 0) AND (GBS.SN = stu.SN) AND (GBS.SC = STU.SC) AND (GBS.AN = 901) AND (GBS.DC IS NOT NULL) ORDER BY DC DESC ),''),
[FP_SpringScore] = ISNULL ((SELECT TOP (1) ROUND(SCR, 1) AS score FROM dbo.GBS WHERE (STU.DEL = 0) AND (GBS.SN = stu.SN) AND (GBS.SC = STU.SC) AND (GBS.AN = 902) AND (GBS.DC IS NOT NULL) ORDER BY DC DESC ),''),
[FP_SpringDate] = ISNULL ((SELECT TOP (1) CAST(DC AS DATE) FROM dbo.GBS WHERE (STU.DEL = 0) AND (GBS.SN = stu.SN) AND (GBS.SC = STU.SC) AND (GBS.AN = 902) AND (GBS.DC IS NOT NULL) ORDER BY DC DESC ),''),
Reading_ENG_Fall_MAP_SS = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN (@MAPoct,@MAPsep,@MAPaug)) ORDER BY TD DESC ),''),
Reading_ENG_Fall_MAP_PC = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN (@MAPoct,@MAPsep,@MAPaug)) ORDER BY TD DESC ),''),
Reading_SPN_Fall_MAP_SS = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 4) AND (TA IN (@MAPoct,@MAPsep,@MAPaug)) ORDER BY TD DESC ),''),
Reading_SPN_Fall_MAP_PC = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 4) AND (TA IN (@MAPoct,@MAPsep,@MAPaug)) ORDER BY TD DESC ),''),
Reading_ENG_Wint_MAP_SS = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN (@MAPnov,@MAPdec,@MAPjan,@MAPfeb,@MAPmar)) ORDER BY TD DESC ),''),
Reading_ENG_Wint_MAP_PC = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN (@MAPnov,@MAPdec,@MAPjan,@MAPfeb,@MAPmar)) ORDER BY TD DESC ),''),
Reading_SPN_Wint_MAP_SS = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 4) AND (TA IN (@MAPnov,@MAPdec,@MAPjan,@MAPfeb,@MAPmar)) ORDER BY TD DESC ),''),
Reading_SPN_Wint_MAP_PC = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 4) AND (TA IN (@MAPnov,@MAPdec,@MAPjan,@MAPfeb,@MAPmar)) ORDER BY TD DESC ),''),
ELA_ENG_Fall_MAP = ISNULL ((SELECT TOP (1) OT AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN (@MAPoct,@MAPsep,@MAPaug)) ORDER BY TD DESC ),''),
ELA_ENG_Wint_MAP = ISNULL ((SELECT TOP (1) OT AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) AND (TA IN (@MAPnov,@MAPdec,@MAPjan,@MAPfeb,@MAPmar)) ORDER BY TD DESC ),''),
Math_ENG_Fall_MAP_SS = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN (@MAPoct,@MAPsep,@MAPaug)) ORDER BY TD DESC ),''),
Math_ENG_Fall_MAP_PC = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN (@MAPoct,@MAPsep,@MAPaug)) ORDER BY TD DESC ),''),
Math_SPN_Fall_MAP_SS = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 23) AND (TA IN (@MAPoct,@MAPsep,@MAPaug)) ORDER BY TD DESC ),''),
Math_SPN_Fall_MAP_PC = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 23) AND (TA IN (@MAPoct,@MAPsep,@MAPaug)) ORDER BY TD DESC ),''),
Math_ENG_Wint_MAP_SS = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN (@MAPnov,@MAPdec,@MAPjan,@MAPfeb,@MAPmar)) ORDER BY TD DESC ),''),
Math_ENG_Wint_MAP_PC = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) AND (TA IN (@MAPnov,@MAPdec,@MAPjan,@MAPfeb,@MAPmar)) ORDER BY TD DESC ),''),
Math_SPN_Wint_MAP_SS = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 23) AND (TA IN (@MAPnov,@MAPdec,@MAPjan,@MAPfeb,@MAPmar)) ORDER BY TD DESC ),''),
Math_SPN_Wint_MAP_PC = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 23) AND (TA IN (@MAPnov,@MAPdec,@MAPjan,@MAPfeb,@MAPmar)) ORDER BY TD DESC ),''),
ELASCR_CAASPP = '', -- ISNULL ((SELECT TOP (1) cast( SS as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = @SBAC) AND (PT = 1) ORDER BY TD DESC ),''),
MathSCR_CAASPP = '', -- ISNULL ((SELECT TOP (1) cast( SS as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = @SBAC) AND (PT = 2) ORDER BY TD DESC ),''),
PSAT89_READ_WRITE = ISNULL ((SELECT TOP (1) SC5 AS score FROM CTS WHERE (DEL = 0) AND (PID = stu.ID) AND (NM = 'PSAT89') ORDER BY DT DESC ),''),
PSAT89_MATH = ISNULL ((SELECT TOP (1) SC6 AS score FROM CTS WHERE (DEL = 0) AND (PID = stu.ID) AND (NM = 'PSAT89') ORDER BY DT DESC ),''),
PSAT89_TOTAL = ISNULL ((SELECT TOP (1) TTL AS score FROM CTS WHERE (DEL = 0) AND (PID = stu.ID) AND (NM = 'PSAT89') ORDER BY DT DESC ),''),
Overall_ELPAC =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 0) AND (TD > @StartDate) AND (TD < @EndDate) ORDER BY TD DESC ),''),
Oral_ELPAC =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 1) AND (TD > @StartDate) AND (TD < @EndDate) ORDER BY TD DESC ),''),
Written_ELPAC =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 2) AND (TD > @StartDate) AND (TD < @EndDate) ORDER BY TD DESC ),''),
Listening_ELPAC =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 3) AND (TD > @StartDate) AND (TD < @EndDate) ORDER BY TD DESC ),''),
Speaking_ELPAC =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 4) AND (TD > @StartDate) AND (TD < @EndDate) ORDER BY TD DESC ),''),
Reading_ELPAC =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 5) AND (TD > @StartDate) AND (TD < @EndDate) ORDER BY TD DESC ),''),
Writing_ELPAC =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 6) AND (TD > @StartDate) AND (TD < @EndDate) ORDER BY TD DESC ),''),
Overall_CELDT = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 0) AND (TD > @StartDate) AND (TD < @EndDate) ORDER BY TD DESC ),''),
Written_CELDT =  '', --ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 3) AND (TD > @StartDate) AND (TD < @EndDate) ORDER BY TD DESC ),''),
Listening_CELDT =  '', --ISNULL ((SELECT TOP (1) cast( OT as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 4) AND (TD > @StartDate) AND (TD < @EndDate) ORDER BY TD DESC ),''),
Speaking_CELDT =  '', --ISNULL ((SELECT TOP (1) cast( OT as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 5) AND (TD > @StartDate) AND (TD < @EndDate) ORDER BY TD DESC ),''),
Reading_CELDT =  '', --ISNULL ((SELECT TOP (1) cast( OT as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 2) AND (TD > @StartDate) AND (TD < @EndDate) ORDER BY TD DESC ),''),
Writing_CELDT =  '' --ISNULL ((SELECT TOP (1) cast( OT as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 3) AND (TD > @StartDate) AND (TD < @EndDate) ORDER BY TD DESC ),'')
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC IN (2,6,8,9,10,11,12,15,20,21,30,31,32)
AND STU.GR IN (3,4,5,6,7,8,9,10,11,12)
AND STU.DD < '09/01/18'
ORDER BY SC,GR,LN,FN
