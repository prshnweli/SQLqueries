USE Aeries2018

SELECT 
STU.ID,
STU.FN, 
STU.LN, 
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
STU.GR, 
MAP_ELAScore = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) ORDER BY TD DESC ),''),
MAP_MathScore = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) ORDER BY TD DESC ),''),
CAASPP_ELAScore =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG18') AND (PT = 1) ORDER BY TD DESC ),''),
CAASPP_MathScore =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (TA = 'SPRG18') AND (PT = 2) ORDER BY TD DESC ),''),
Oral_ELPAC =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 1) ORDER BY TD DESC ),''),
Oral_Perf =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 1) ORDER BY TD DESC ),''),
Written_ELPAC =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 2) ORDER BY TD DESC ),''),
Written_Perf =  ISNULL ((SELECT TOP (1) cast(PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 2) ORDER BY TD DESC ),''),
Listening_Perf =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 3) ORDER BY TD DESC ),''),
Speaking_Perf =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 4) ORDER BY TD DESC ),''),
Reading_Perf =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 5) ORDER BY TD DESC ),''),
Writing_Perf =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'ELPAC') AND (PT = 6) ORDER BY TD DESC ),'')
FROM STU
WHERE STU.U4 = 'Y'
and stu.tg = ''
and stu.sc in (2,6,8,9,10,11,12,15,20,21,30,31,32,40,60,70)
ORDER BY GR, SC, LN, FN