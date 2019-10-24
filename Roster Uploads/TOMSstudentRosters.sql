SELECT 
'43695836047922' AS "CODE",
Teacher = (select (EM) from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 ),
Teacher = (select (TLN + '.' + TF) from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 ),
STU.CID,
'ADD' AS "ACTION"
FROM STU
WHERE STU.SC = 11
AND STU.GR > 2
AND STU.DEL = 0
AND STU.TG = ''