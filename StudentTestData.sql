/*
id	pt	nm
CAA	0	CA Alternate Assessments
CAA	1	English Lang Arts
CAA	2	Mathematics
CAPA	0	CA Alt Perf Assessment
CAPA	1	English Lang Arts
CAPA	2	Mathematics
CAPA	3	Science
CAPA	4	History
CELDT	0	Overall
CELDT	2	Reading
CELDT	3	Writing
CELDT	4	Listening
CELDT	5	Speaking
CMA	0	CA Modified Assessment
CMA	1	CMA English Lang Arts
CMA	2	CMA Mathematics
CMA	3	CMA Science
DYS	0	Dyslexia Rubric Total
F&P	0	Independent Level
HMH	0	HMH
HMH	1	Reading Inv
HMH	2	Math Inv
LAS	0	AvgScore
LAS	1	Speaking
LAS	2	Listening
LAS	3	Reading
LAS	4	Writing
LAS	5	TotalScore
MAP	0	Measure of Academic Perf
MAP	1	Reading
MAP	2	Primary Reading 1
MAP	3	Primary Reading 2
MAP	20	Mathematics
MAP	21	Primary Math 1
MAP	22	Primary Math 2
MAP	30	Language Usage
MAP	40	General Science
MAP	41	Biology
MAP	42	Chemistry
MAP	43	Concepts and Processes
MAP	50	Social Studies
MAP	100	Undetermined Part
SBAC	0	Smarter Balanced
SBAC	1	English Lang Arts /Liter
SBAC	2	Mathematics


*/

SELECT 	StudentID = stu.id
       ,StudentName =  stu.LN + ', ' + stu.FN
	   ,School = ( select LOC.NM from LOC where stu.SC = LOC.CD)
	   ,Grade = stu.gr
	   ,Teacher = (select TE from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 )
	   ,SocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2017' and fre.eed = '6/30/2018' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end
	   ,LangFluency = stu.lf
	   ,SPED = stu.U2
	   ,Migrant = stu.U4
	   ,MAP_ELAScore = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) ORDER BY TD DESC ),'')
	   ,MAP_ELAPriorScore = ISNULL ((SELECT TOP (1) SS FROM (select top(2) ss,td from TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) ORDER BY TD desc ) as score  ORDER BY TD asc ),'')    
	   ,MAP_ELAPercentile = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) ORDER BY TD DESC ),'')
	   ,MAP_ELAPriorPercentile = ISNULL ((SELECT TOP (1) PC FROM (select top(2) PC,td from TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) ORDER BY TD desc ) as score  ORDER BY TD asc ),'')        
	   ,MAP_LexileScore = ISNULL ((SELECT TOP (1) OT AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) ORDER BY TD DESC ),'')
	   ,MAP_LexilePriorScore = ISNULL ((SELECT TOP (1) OT FROM (select top(2) ot,td from TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 1) ORDER BY TD desc ) as score  ORDER BY TD asc ),'') 
	   ,MAP_MathScore = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) ORDER BY TD DESC ),'')
	   ,MAP_MathPriorScore = ISNULL ((SELECT TOP (1) SS FROM (select top(2) ss,td from TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) ORDER BY TD desc ) as score  ORDER BY TD asc ),'')
	   ,MAP_MathPercentile = ISNULL ((SELECT TOP (1) PC AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) ORDER BY TD DESC ),'')
	   ,MAP_MathPriorPercentile = ISNULL ((SELECT TOP (1) PC FROM (select top(2) PC,td from TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) ORDER BY TD desc ) as score  ORDER BY TD asc ),'')
       ,CAASPP_ELAScore =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (PT = 1) ORDER BY TD DESC ),'')
	   ,CAASPP_ELAPriorScore = ISNULL ((SELECT TOP (1) SS FROM (select top(2) ss,td from TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (PT = 1) ORDER BY TD desc ) as score  ORDER BY TD asc ),'')
	   ,CAASPP_ELAProfLvl =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (PT = 1) ORDER BY TD DESC ),'')
	   ,CAASPP_MathScore =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (PT = 2) ORDER BY TD DESC ),'')
	   ,CAASPP_MathProfLvl =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'SBAC') AND (PT = 2) ORDER BY TD DESC ),'')
	   ,MAP_MathScore = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'MAP') AND (PT = 20) ORDER BY TD DESC ),'')
	   ,[F&P] =  ISNULL ((SELECT TOP (1) PL AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (PT = 0) ORDER BY TD DESC ),'')
	   ,HMH_Reading =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'HMH') AND (PT = 1) ORDER BY TD DESC ),'')
	   ,HMH_Math =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'HMH') AND (PT = 2) ORDER BY TD DESC ),'')
	   ,Dyslexia = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'DYS') AND (PT = 0) ORDER BY TD DESC ),'')
	   ,CAPA_ELA = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CAPA') AND (PT = 1) ORDER BY TD DESC ),'')
	   ,CAPA_Math = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CAPA') AND (PT = 2) ORDER BY TD DESC ),'')
	   ,CAPA_Science = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CAPA') AND (PT = 3) ORDER BY TD DESC ),'')
	   ,CAPA_History = ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CAPA') AND (PT = 4) ORDER BY TD DESC ),'')
	   ,CAA_ELA =ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CAA') AND (PT = 1) ORDER BY TD DESC ),'')
	   ,CAA_Math =ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CAA') AND (PT = 2) ORDER BY TD DESC ),'')
	   ,CMA_ELA =ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CMA') AND (PT = 1) ORDER BY TD DESC ),'')
	   ,CMA_Math =ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CMA') AND (PT = 2) ORDER BY TD DESC ),'')
	   ,CELDT_Overall =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 0) ORDER BY TD DESC ),'')
	   ,CELDT_OverallPerfLvl =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 0) ORDER BY TD DESC ),'')
	   ,CELDT_Reading =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 2) ORDER BY TD DESC ),'')
	   ,CELDT_ReadingPerfLvl =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 2) ORDER BY TD DESC ),'')
	   ,CELDT_Writing =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 3) ORDER BY TD DESC ),'')
	   ,CELDT_WritingPerfLvl =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 3) ORDER BY TD DESC ),'')
	   ,CELDT_Listening =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 4) ORDER BY TD DESC ),'')
	   ,CELDT_ListeningPerfLvl =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 4) ORDER BY TD DESC ),'')
	   ,CELDT_Speaking =  ISNULL ((SELECT TOP (1) SS AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 5) ORDER BY TD DESC ),'')
	   ,CELDT_SpeakingPerfLvl =  ISNULL ((SELECT TOP (1) cast( PL as int) AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'CELDT') AND (PT = 5) ORDER BY TD DESC ),'')

FROM STU
where stu.del = 0
and stu.tg = ''
and stu.sc in (2,6,8,9,10,11,12,15,20,21,30,31,32,40,60,70)
order by school,grade,teacher,StudentName
