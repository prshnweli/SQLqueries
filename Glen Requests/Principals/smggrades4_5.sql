SELECT
ID = STU.ID,
Name = STU.LN + ', ' + STU.FN,
Grade = STU.GR,
Standard = SBH.SD,
Standard_desc = STN.TI,
Mark1 = SBH.M1,
Mark2 = SBH.M2,
'All As' = SUM(CASE WHEN SBH.M1 LIKE 'A%' THEN 1 ELSE 0 END),
'As and Bs' = SUM(CASE WHEN SBH.M1 LIKE 'A%' THEN 1 WHEN SBH.M1 LIKE 'B%' THEN 1 ELSE 0 END)
FROM STU
JOIN SBH ON
  SBH.PID = STU.ID
JOIN STN ON
  STN.SD = SBH.SD
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.GR = 5
AND STU.SC = 10
AND SBH.YR = '2019'
AND SBH.SD IN ('CEL.5.R', 'CEL.5.W', 'CME.5', 'MH.CEH.ENGSP.A', 'MH.SCI.ENGSP.A', 'MH.SCI', 'MH.CEH.TK5')
GROUP BY STU.ID, STU.LN, STU.FN, STU.GR, SBH.SD, STN.TI, SBH.M1, SBH.M2
