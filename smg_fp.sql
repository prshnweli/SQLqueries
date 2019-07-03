USE Aeries2018

SELECT
StudentID = stu.id,
StudentName =  stu.LN + ', ' + stu.FN,
Grade = stu.gr,
Teacher = (select TE from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 ),
ISNULL ((SELECT TOP (1) CAST(PL AS FLOAT) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (TA = 'BL1819') AND (PT = 0) ORDER BY TD DESC ),'') AS '[F&P]',
ISNULL ((SELECT TOP (1) CAST(PL AS FLOAT) AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (TA != 'BL1819') AND (PT = 0) ORDER BY TD DESC ),'') AS '[F&P2]'
FROM dbo.STU
where stu.del = 0
and stu.tg = ''
and stu.sc = 10
order by grade,teacher,StudentName
