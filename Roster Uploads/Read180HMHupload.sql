USE Aeries

SELECT
STU.LN AS "Last_Name",
STU.FN AS "First_Name",
STU.ID AS "SIS_ID",
STU.GR AS "Grade",
STU.ID AS "User_Name",
'Britton_Middle_School' AS 'School_Name',
[Class_Name] = CAST(STU.GR AS VARCHAR) + 'th Grade'
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC = 20
