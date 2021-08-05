SELECT
STU.FN AS 'First Name',
STU.LN AS 'Last Name',
STU.ID AS 'Student ID',
STU.GR AS 'Grade',
'' AS 'Email Address',
STU.ID AS 'Username',
STU.ID AS 'Password'
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC = 15
