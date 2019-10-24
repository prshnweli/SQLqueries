SELECT
'District Local ID' = STU.ID,
'State Testing ID' = STU.CID,
'Test Date' = CAST(TST.TD AS DATE),
'Student Grade Level' = STU.GR,
'Test Grade Level' = (TST.GR)/10,
'F&P Score' = TST.PL
-- 'F&P Percentile' = TST.PC
FROM STU
JOIN TST ON TST.PID = STU.ID
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.LF != 'E'
AND TST.ID = 'F&P'
AND TST.TA = 'BL1920'
ORDER BY STU.GR


SELECT
'District Local ID' = STU.ID,
'State Testing ID' = STU.CID,
'Test Date' = CAST(TST.TD AS DATE),
'Student Grade Level' = STU.GR,
'Test Grade Level' = (TST.GR)/10,
'F&P Score' = TST.PL
-- 'F&P Percentile' = TST.PC
FROM STU
JOIN CTS ON CTS.PID = STU.ID
WHERE STU.DEL = 0
AND STU.TG = ''
AND STU.LF != 'E'
AND TST.ID = 'F&P'
AND TST.TA = 'BL1920'
ORDER BY STU.GR
