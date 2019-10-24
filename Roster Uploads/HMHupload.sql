USE Aeries

SELECT
Student_FirstName = (SELECT FN FROM STU WHERE SEC.SC = STU.SC AND SEC.SN = STU.SN),
Student_LastName = (SELECT LN FROM STU WHERE SEC.SC = STU.SC AND SEC.SN = STU.SN),
Teacher_FirstName = (select TF from TCH where MST.TN = TCH.TN and MST.SC = TCH.SC and TCH.DEL = 0 ),
Teacher_LastName = (select TLN from TCH where MST.TN = TCH.TN and MST.SC = TCH.SC and TCH.DEL = 0 ),
Class = (select TLN from TCH where MST.TN = TCH.TN and MST.SC = TCH.SC and TCH.DEL = 0 ) + '_' + CAST(MST.PD AS varchar) + '_'  + (SELECT CO FROM CRS WHERE MST.CN = CRS.CN),
Grade = (SELECT GR FROM STU WHERE SEC.SC = STU.SC AND SEC.SN = STU.SN)
FROM SEC
JOIN MST AS MST
  ON (SEC.SC = MST.SC AND SEC.SE = MST.SE)
WHERE SEC.DEL = 0
AND (SEC.SC = 20 AND MST.TN IN (22, 9, 24, 33, 143, 26, 6))
OR (SEC.SC = 21 AND MST.TN IN (15, 31, 26, 17, 77, 6, 11))
OR (SEC.SC = 10 AND MST.TN IN (16))
ORDER BY Teacher_LastName, MST.PD, Student_LastName, Student_FirstName;
