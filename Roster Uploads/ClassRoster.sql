USE Aeries

SELECT
FirstName = (SELECT FN FROM STU WHERE SEC.SC = STU.SC AND SEC.SN = STU.SN),
LastName = (SELECT LN FROM STU WHERE SEC.SC = STU.SC AND SEC.SN = STU.SN),
Username = (SELECT SEM FROM STU WHERE SEC.SC = STU.SC AND SEC.SN = STU.SN),
Password = (SELECT ID FROM STU WHERE SEC.SC = STU.SC AND SEC.SN = STU.SN),
Class = (select TLN from TCH where MST.TN = TCH.TN and MST.SC = TCH.SC and TCH.DEL = 0 ) + CAST(MST.PD AS varchar),
ParentEmail = (SELECT PEM FROM STU WHERE SEC.SC = STU.SC AND SEC.SN = STU.SN),
'no' AS 'PERM',
Grade = (SELECT GR FROM STU WHERE SEC.SC = STU.SC AND SEC.SN = STU.SN)
FROM SEC
JOIN MST AS MST
  ON (SEC.SC = MST.SC AND SEC.SE = MST.SE)
WHERE SEC.SE IN (1144,48,47,570,210,632,49,52,546,547)
AND SEC.DEL = 0
AND SEC.SC = 31
ORDER BY Class