-- https://dev.datazone.org/DashboardDev/dashboard/11855?filtersetId=59e23713-9267-4bd7-aa4c-e6b7d070eec2

SELECT
CRS.CN AS 'Course Number',
CRS.CO AS 'Course Name',
CRS.NA AS 'Honors?',
SUM(MST.TS) AS 'Total Students Enrolled'
FROM CRS
JOIN MST ON CRS.CN = MST.CN
WHERE CRS.DEL = 0
AND CRS.TG = ''
GROUP BY CRS.CN, CRS.CO, CRS.NA
