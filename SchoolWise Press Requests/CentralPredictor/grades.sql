SELECT
StudentID = (SELECT STU.ID FROM STU WHERE STU.SC = GRD.SC AND STU.SN = GRD.SN),
School = ( select LOC.NM from LOC where GRD.SC = LOC.CD),
(SELECT STU.GR FROM STU WHERE STU.SC = GRD.SC AND STU.SN = GRD.SN) AS 'Grade',
CRS.CO AS 'Course Title',
CRS.NA AS 'Honors/N',
CRS.DC AS 'Department Code',
GRD.M4 AS '1st Semester Grade',
GRD.M8 AS '2nd Semester Grade'
FROM GRD
JOIN CRS ON
  (GRD.CN = CRS.CN)
WHERE GRD.DEL = 0
AND GRD.M4 IN ('D','D+','D-','F')
OR GRD.M8 IN ('D','D+','D-','F')
