USE Aeries2018

SELECT
Student_FirstName = (SELECT FN FROM STU WHERE SEC.SC = STU.SC AND SEC.SN = STU.SN),
Student_LastName = (SELECT LN FROM STU WHERE SEC.SC = STU.SC AND SEC.SN = STU.SN),
Teacher_FirstName = (select TF from TCH where MST.TN = TCH.TN and MST.SC = TCH.SC and TCH.DEL = 0 ),
Teacher_LastName = (select TLN from TCH where MST.TN = TCH.TN and MST.SC = TCH.SC and TCH.DEL = 0 ),
ClassSection = SEC.SE,
Grade = (SELECT GR FROM STU WHERE SEC.SC = STU.SC AND SEC.SN = STU.SN),
ClassPeriod = MST.PD
FROM SEC
JOIN MST AS MST
  ON (SEC.SC = MST.SC AND SEC.SE = MST.SE)
WHERE SEC.SE IN (501, 603, 300, 201, 424, 505, 303, 205)
AND SEC.DEL = 0
AND SEC.SC = 21
ORDER BY Teacher_LastName, SEC.SE, Student_LastName, Student_FirstName;
