SELECT
[School ID] = CASE STU.SC
WHEN 2 THEN '43695836109375'
WHEN 6 THEN '43695836095392'
WHEN 8 THEN '43695836047914'
WHEN 9 THEN '43695836098271'
WHEN 10 THEN '43695836047948'
WHEN 11 THEN '43695836047922'
WHEN 12 THEN '43695836118376'
WHEN 15 THEN '43695836098263'
WHEN 20 THEN '43695836095384'
WHEN 21 THEN '43695836100325'
WHEN 30 THEN '43695834334488'
WHEN 31 THEN '43695834333951'
WHEN 32 THEN '43695830102368'
END,
STU.SEM AS 'Email',
(select TLN from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 ) AS 'Roster Name',
STU.CID AS 'School ID',
'ADD' AS 'Action'
FROM STU
WHERE STU.TG = ''
AND STU.DEL = 0
AND STU.SC = 9
