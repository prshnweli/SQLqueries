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
