USE Aeries

SELECT
STU.CID,
' ' AS TEST,
' ' AS ALTERNATE,
'Y' AS SCIENCE
FROM STU
WHERE STU.SC IN (30,31,32)
AND STU.GR = 11
AND stu.del = 0
and stu.tg = ''
