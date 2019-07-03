SELECT
STU.ID,
STU.FN,
STU.LN,
School = ( select LOC.NM from dbo.LOC where stu.SC = LOC.CD),
STU.GR,
STU.U4 AS 'Migrant',
ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) ORDER BY TD DESC ),'') AS 'MAP_ELAScore',
ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) ORDER BY TD DESC ),'') AS 'MAP_MathScore',
ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (PT = 1) ORDER BY TD DESC ),'') AS 'CAASPP_ELAScore',
ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (PT = 2) ORDER BY TD DESC ),'') AS 'CAASPP_MathScore',
ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 1) ORDER BY TD DESC ),'') AS 'Oral_ELPAC',
ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 1) ORDER BY TD DESC ),'') AS 'Oral_Perf_ELPAC',
ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 2) ORDER BY TD DESC ),'') AS 'Written_ELPAC',
ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 2) ORDER BY TD DESC ),'') AS 'Written_Perf_ELPAC',
ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 3) ORDER BY TD DESC ),'') AS 'Listening_ELPAC',
ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 3) ORDER BY TD DESC ),'') AS 'Listening_Perf_ELPAC',
ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 4) ORDER BY TD DESC ),'') AS 'Speaking_ELPAC',
ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 4) ORDER BY TD DESC ),'') AS 'Speaking_Perf_ELPAC',
ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 5) ORDER BY TD DESC ),'') AS 'Reading_ELPAC',
ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 5) ORDER BY TD DESC ),'') AS 'Reading_Perf_ELPAC',
ISNULL ((SELECT TOP (1) SS AS score FROM dbo.TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 6) ORDER BY TD DESC ),'') AS 'Writing_ELPAC',
ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 6) ORDER BY TD DESC ),'') AS 'Writing_Perf_ELPAC'
FROM Aeries2018.dbo.STU AS STU
where stu.del = 0
and stu.u4 = 'Y'
and stu.tg = ''
and stu.sc in (2,6,8,9,10,11,12,15,20,21,30,31,32,40,60,70)
and stu.gr in (0,1,2,3,4,5,6,7,8,9,10,11,12)
order by SC,GR,LN,FN;
