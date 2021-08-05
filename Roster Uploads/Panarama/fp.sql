SELECT
STU.GR,
TST.PL,
STU.ID AS 'Student_ID',
CAST(TST.TD AS DATE) AS 'Recorded_At',
CASE TST.PL
  WHEN 0.3 THEN 'A'
  WHEN 0.6 THEN 'B'
  WHEN 0.9 THEN 'C'
  WHEN 1.2 THEN 'D'
  WHEN 1.4 THEN 'E'
  WHEN 1.5 THEN 'F'
  WHEN 1.6 THEN 'G'
  WHEN 1.8 THEN 'H'
  WHEN 1.9 THEN 'I'
  WHEN 2.3 THEN 'J'
  WHEN 2.6 THEN 'K'
  WHEN 2.9 THEN 'L'
  WHEN 3.3 THEN 'M'
  WHEN 3.6 THEN 'N'
  WHEN 3.9 THEN 'O'
  WHEN 4.3 THEN 'P'
  WHEN 4.6 THEN 'Q'
  WHEN 4.9 THEN 'R'
  WHEN 5.3 THEN 'S'
  WHEN 5.6 THEN 'T'
  WHEN 5.9 THEN 'U'
  WHEN 6.3 THEN 'V'
  WHEN 6.6 THEN 'W'
  WHEN 6.9 THEN 'X'
  WHEN 7.3 THEN 'Y'
  WHEN 7.6 THEN 'Z'
  ELSE 'No Score'
END AS [Scaled_Score],
CASE
  -- FALL
  WHEN TST.PL < STU.GR THEN 'Below Grade Level'
  WHEN STU.GR = 1 AND TST.PL = 1.2 THEN 'On Grade Level'
  WHEN STU.GR = 1 AND TST.PL > 1.2 THEN 'Above Grade Level'
  WHEN TST.PL = STU.GR + 0.3 THEN 'On Grade Level'
  WHEN TST.PL > STU.GR + 0.3 THEN 'Above Grade Level'
  -- SPRING
  -- WHEN STU.GR = 1 AND TST.PL < 1.5 THEN 'Below Grade Level'
  -- WHEN STU.GR = 1 AND TST.PL = 1.5 THEN 'On Grade Level'
  -- WHEN STU.GR = 1 AND TST.PL > 1.5 THEN 'Above Grade Level'
  -- WHEN TST.PL < STU.GR + 0.6 THEN 'Below Grade Level'
  -- WHEN TST.PL = STU.GR + 0.6 THEN 'On Grade Level'
  -- WHEN TST.PL > STU.GR + 0.6 THEN 'Above Grade Level'
END AS [Assessed_Level],
'Subject_Area' = 'ELA',
'Assessment_Name' = 'F&P',
'School_ID' = STU.SC
FROM STU
JOIN TST ON (TST.PID = STU.ID)
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.SC IN (2,6,8,9,10,11,12,15)
AND TST.ID = 'F&P'
AND TST.TA = '2T2021'
