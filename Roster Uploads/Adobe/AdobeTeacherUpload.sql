USE Aeries2018

SELECT
'Federated ID' AS 'Identity Type',
TCH.EM AS Username,
'mhusd.org' AS Domain,
TCH.EM AS Email,
TCH.TF AS 'First Name',
TCH.TLN AS 'Last Name',
'US' AS 'Country Code',
'Default Adobe Spark for K-12 - 2 GB configuration' AS 'Product Configurations',
[User Groups] =
(CASE TCH.SC
WHEN 2 THEN 'El Toro Teachers'
WHEN 6 THEN 'Los Paseos Teachers'
WHEN 8 THEN 'Nordstrom Teachers'
WHEN 9 THEN 'Paradise Teachers'
WHEN 10 THEN 'SMG Teachers'
WHEN 11 THEN 'P.A Walsh Teachers'
WHEN 12 THEN 'Barrett Teachers'
WHEN 15 THEN 'JAMM Teachers'
WHEN 20 THEN 'Britton Teachers'
WHEN 21 THEN 'Murphy Teachers'
WHEN 30 THEN 'Central Teachers'
WHEN 31 THEN 'Live Oak Teachers'
WHEN 32 THEN 'Sobrato Teachers'
END)
FROM TCH
WHERE TCH.SC IN (2,6,8,9,10,11,12,15,20,21,30,31,32)
AND TCH.DEL = 0
AND TCH.TG = ''
AND TCH.EM != ''
ORDER BY TCH.SC
