SELECT
STU.ID AS 'ID',
STU.LN + ', ' + STU.FN AS 'Name',
STU.GR AS 'Grade',
GRD.PD AS 'Period',
CRS.CO AS 'Course',
Teacher = (select TE from TCH where GRD.TN = TCH.TN and GRD.SC = TCH.SC and tch.del = 0 ),
GRD.M1 AS 'Progress Grade',
STU.ETH AS 'Latinx',
STU.U2 AS 'SPED',
'504s' = CASE WHEN STU.ID IN (SELECT FOF.ID FROM FOF WHERE FOF.ID = STU.ID AND FOF.SD IS NOT NULL AND FOF.ED IS NULL) THEN 'Y' ELSE '' END,
LowSocioEcoStatus =  case when stu.id in (select fre.id from fre where fre.id = stu.id and fre.cd in ( 'f', 'r' ) and  (fre.esd > '7/1/2020' and fre.eed = '6/30/2021' ) and fre.del = 0 and ( stu.ped = 14 or fre.cd is not null )) then 'Y' else 'N' end
FROM STU
JOIN GRD ON GRD.SN = STU.SN AND GRD.SC = STU.SC
JOIN CRS ON GRD.CN = CRS.CN
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC = 32
ORDER BY STU.GR, STU.LN, STU.FN, GRD.PD
