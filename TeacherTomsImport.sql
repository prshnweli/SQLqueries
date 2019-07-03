USE Aeries2018

SELECT 
TCH.TF, 
TCH.TLN, 
'43695830102368' AS CDS,
TCH.EM,
'4082016200' AS PHONE,
'Test Administrator' AS Roles
FROM TCH
WHERE TCH.SC = 32
AND TCH.TN IN (78,5,62,67,21,43,18,190,265,41,44,38,195,83,15,36,26,27,34,33,16,81,29,17,75,189,55,77,269,31,11,45,2632,46,39,20,2,40,86)
AND TCH.DEL = 0
AND TCH.TG = ''
ORDER BY TLN