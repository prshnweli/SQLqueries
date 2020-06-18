SELECT
STU.FN AS 'First Name',
STU.LN AS 'Last Name',
STU.ID AS 'Username',
STU.ID AS 'Password',
STU.GR AS 'Grade',
'Jackson_English' AS 'Class',
'Live Oak High School' AS 'School'
FROM STU
JOIN SEC ON (SEC.SC = STU.SC) AND (SEC.SN = STU.SN)
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC = 31
AND SEC.SE = 263
