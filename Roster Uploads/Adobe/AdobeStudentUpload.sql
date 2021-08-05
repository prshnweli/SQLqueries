SELECT
'Federated ID' AS 'Identity Type',
STU.SEM AS Username,
'students.mhusd.org' AS Domain,
STU.SEM AS Email,
STU.FN AS 'First Name',
STU.LN AS 'Last Name',
'US' AS 'Country Code',
'Default Adobe Spark for K-12 - 2 GB configuration' AS 'Product Configurations',
/*
[User Groups] =
(CASE STU.SC
WHEN 2 THEN 'El Toro Students'
WHEN 6 THEN 'Los Paseos Students'
WHEN 8 THEN 'Nordstrom Students'
WHEN 9 THEN 'Paradise Students'
WHEN 10 THEN 'SMG Students'
WHEN 11 THEN 'P.A Walsh Students'
WHEN 12 THEN 'Barrett Students'
WHEN 15 THEN 'JAMM Students'
WHEN 20 THEN 'Britton Students'
WHEN 21 THEN 'Murphy Students'
WHEN 30 THEN 'Central Students'
WHEN 31 THEN 'Live Oak Students'
WHEN 32 THEN 'Sobrato Students'
END)
*/
'' AS 'Admin Roles'
FROM STU
WHERE STU.SC IN (2,6,8,9,10,11,12,15,20,21,30,31,32)
AND STU.DEL = 0
AND STU.TG = ''
--AND STU.SEM != ''
ORDER BY STU.SC
