SELECT
STU.ID AS 'ID',
STU.LN + ', ' + STU.FN AS 'Name',
STU.GR AS 'Grade',
Teacher = (select TE from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 ),
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
SocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2020' and fre.eed = '6/30/2021' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end,
(select de from cod where tc = 'stu' and fc = 'lf' and cod.cd = stu.lf) as [LangFluency],
STU.U2 AS 'SPED',
'504s' = CASE WHEN STU.ID IN (SELECT FOF.ID FROM FOF WHERE FOF.ID = STU.ID AND FOF.SD IS NOT NULL AND FOF.ED IS NULL) THEN 'Y' ELSE '' END,
Race = (select rtrim(DE) from COD where COD.CD = stu.ec and cod.del = 0 and cod.tc = 'stu' and cod.fc = 'ec'),
[Hispanic/Latinx] = STU.ETH,
STU.U4 AS 'Migrant',
Homeless = CASE WHEN (SELECT TOP(1) CD FROM PGM WHERE (STU.ID = PGM.PID) AND (PGM.CD = 191) AND (PGM.PED IS NULL)) = '191' THEN 'Y' ELSE '' END,
[F&P Fall 2021] =  ISNULL ((SELECT TOP (1) PL AS score FROM TST WHERE (DEL = 0) AND (PID = stu.ID) AND (ID = 'F&P') AND (PT = 0) AND(TA = 'BL2021') ORDER BY TD DESC ),'')
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC = 9
AND STU.GR > -1
AND STU.GR < 2
ORDER BY STU.SC, STU.GR, STU.LN, STU.FN
