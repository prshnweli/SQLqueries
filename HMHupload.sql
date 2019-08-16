USE Aeries

SELECT
Student_FirstName = (SELECT FN FROM STU WHERE SEC.SC = STU.SC AND SEC.SN = STU.SN),
Student_LastName = (SELECT LN FROM STU WHERE SEC.SC = STU.SC AND SEC.SN = STU.SN),
Teacher_FirstName = (select TF from TCH where MST.TN = TCH.TN and MST.SC = TCH.SC and TCH.DEL = 0 ),
Teacher_LastName = (select TLN from TCH where MST.TN = TCH.TN and MST.SC = TCH.SC and TCH.DEL = 0 ),
Class = (select TLN from TCH where MST.TN = TCH.TN and MST.SC = TCH.SC and TCH.DEL = 0 ) + CAST(MST.PD AS varchar),
Grade = (SELECT GR FROM STU WHERE SEC.SC = STU.SC AND SEC.SN = STU.SN)
FROM SEC
JOIN MST AS MST
  ON (SEC.SC = MST.SC AND SEC.SE = MST.SE)
WHERE SEC.SE IN (571,1217,477,1169,366,535,461,212,341,211)
AND SEC.DEL = 0
AND SEC.SC = 31
ORDER BY Teacher_LastName, MST.PD, Student_LastName, Student_FirstName;
