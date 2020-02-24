SELECT
CAST(STU.ID AS VARCHAR) + '_MHUSD' AS 'USERNAMES',
'Student' AS 'Account',
'No' AS 'Shared',
FORMAT(STU.BD, 'Mddyy') AS 'PASSWORDS',
STU.SEM AS 'Email',
STU.FN AS 'First Name',
STU.LN AS 'Last Name',
(SELECT LOC.NM FROM LOC WHERE STU.SC = LOC.CD) AS 'Location',
[GROUP] = (CASE
	WHEN STU.GR < 6 THEN 'Elementary'
	WHEN STU.GR > 5 AND STU.GR < 9 THEN 'Middle'
	WHEN STU.GR > 8 THEN 'High'
END)
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC IN (2,6,8,9,10,11,12,15,20,21,30,31,32)
AND STU.DD > '2019-11-27'
ORDER BY STU.SC, STU.GR, STU.LN, STU.FN
