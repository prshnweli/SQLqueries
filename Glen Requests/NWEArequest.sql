SELECT
'CA' AS State,
'MHUSD' AS "District Name",
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
STU.ID AS "Local Student ID",
STU.CID AS "State Student ID",
STU.LN AS "Student Last Name",
STU.FN AS "Student First Name",
STU.MN AS "Student Middle Name",
CAST(STU.BD AS DATE) AS "Student Date of Birth",
STU.SX AS "Sex",
(select de from cod where tc = 'stu' and fc = 'eth' and cod.cd = stu.ETH)  AS 'Ethnicity',
Race = (select rtrim(DE) from COD where COD.CD = stu.ec and cod.del = 0 and cod.tc = 'stu' and cod.fc = 'ec'),
STU.GR AS "Student Grade @ Time of Test",
'Spring 2019' as 'Testing Term',
ELASCR2019_CAASPP =  ISNULL ((SELECT TOP (1) cast( SS as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 1) ORDER BY TD DESC ),''),
ELAPCL2019_CAASPP =  CASE
ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 1) ORDER BY TD DESC ),'')
 WHEN 1 THEN 'Standard Not Met'
 WHEN 2 THEN 'Standard Nearly Met'
 WHEN 3 THEN 'Standard Met'
 WHEN 4 THEN 'Standard Exceeded'
ELSE '' END,
MathSCR2019_CAASPP =  ISNULL ((SELECT TOP (1) cast( SS as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 2) ORDER BY TD DESC ),''),
MathPCL2019_CAASPP =  CASE
ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') AND (PT = 2) ORDER BY TD DESC ),'')
 WHEN 1 THEN 'Standard Not Met'
 WHEN 2 THEN 'Standard Nearly Met'
 WHEN 3 THEN 'Standard Met'
 WHEN 4 THEN 'Standard Exceeded'
ELSE '' END,
SciSCR2019_CAASPP =  ISNULL ((SELECT TOP (1) cast( SS as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CAST') AND (TA = 'SPRG19') AND (PT = 1) ORDER BY TD DESC ),''),
SciPCL2019_CAASPP =  CASE
ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CAST') AND (TA = 'SPRG19') AND (PT = 1) ORDER BY TD DESC ),'')
 WHEN 1 THEN 'Standard Not Met'
 WHEN 2 THEN 'Standard Nearly Met'
 WHEN 3 THEN 'Standard Met'
 WHEN 4 THEN 'Standard Exceeded'
ELSE '' END,
TestDate2019_CAASPP =  ISNULL ((SELECT TOP (1) cast( td as date) AS date FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG19') ORDER BY TD DESC ),''),
CASE WHEN STU.U2 = 'Y' THEN 'Yes' ELSE 'No' END AS 'SPED',
'504s' = CASE WHEN STU.ID IN (SELECT FOF.ID FROM FOF WHERE FOF.ID = STU.ID AND FOF.SD IS NOT NULL AND FOF.ED IS NULL) THEN 'Yes' ELSE 'No' END,
IEP = CASE WHEN STU.ID IN (SELECT cse.ID FROM cse WHERE cse.ID = STU.ID AND cse.ed IS NOT NULL AND cse.xd IS NULL and cse.di != '') THEN 'Yes' ELSE 'No' END,
ELL = CASE WHEN STU.LF = 'E' THEN 'No' ELSE 'Yes' END,
LowSocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2018' and fre.eed = '6/30/2019' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Yes' else 'No' END
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC IN (2,6,8,9,10,11,12,15,20,21,30,31,32)
AND STU.GR IN (3,4,5,6,7,8,11)
ORDER BY STU.SC, STU.GR, STU.LN, STU.FN
