--https://dev.datazone.org/DashboardDev/dashboard/4972?filtersetId=59e23713-9267-4bd7-aa4c-e6b7d070eec2

SELECT
CRS.CN AS 'Course Number',
CRS.CO AS 'Course Name',
CRS.DC AS 'Department Code',
CRS.NA AS 'Honors?',
SUM(MST.TS) AS 'Total Students Enrolled'
FROM CRS
JOIN MST ON CRS.CN = MST.CN
WHERE MST.SC IN (31,32)
AND CRS.DEL = 0
AND CRS.TG = ''
AND CRS.CL = 30
GROUP BY CRS.CN, CRS.CO, CRS.DC, CRS.NA
