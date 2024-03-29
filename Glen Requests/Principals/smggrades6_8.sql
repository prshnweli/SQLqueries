SELECT
ID = STU.ID,
Name = STU.LN + ', ' + STU.FN,
Grade = STU.GR,
Course = CRS.CO,
Mark1 = GRH.MK,
'All As' = SUM(CASE WHEN GRH.MK LIKE 'A%' THEN 1 ELSE 0 END),
'As and Bs' = SUM(CASE WHEN GRH.MK LIKE 'A%' THEN 1 WHEN GRH.MK LIKE 'B%' THEN 1 ELSE 0 END)
FROM STU
JOIN GRH ON
  STU.SN = GRH.SN AND STU.SC = GRH.SC
JOIN CRS ON
  CRS.CN = GRH.CN
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.GR > 5
AND STU.SC = 10
AND GRH.WM = 4
GROUP BY STU.ID, STU.LN, STU.FN, STU.GR, CRS.CO, GRH.MK, GRH.PD
ORDER BY STU.GR, STU.LN, STU.FN, GRH.PD
