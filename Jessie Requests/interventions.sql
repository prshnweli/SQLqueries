drop table if exists #homevisits

create table #homevisits (
Tablesource nvarchar(128),
Studentid int,
[Name] nvarchar(128),
School nvarchar(128),
Grade int,
Race nvarchar(128),
Ethnicity nvarchar(128),
[DateofVisit] date,
Code nvarchar(8),
Comments nvarchar(max)
)

insert into #homevisits
SELECT
'Interventions' AS [Tablesource],
STU.ID AS [Studentid],
STU.LN + ', ' + STU.FN AS [Name],
(select LOC.NM from LOC where stu.SC = LOC.CD) AS [School],
STU.GR AS [Grade],
'test' AS [Race],
'test' AS [Ethnicity],
CAST(inv.dt AS DATE) AS [DateofVisit],
INV.CD AS [Code],
INV.CO AS [Comments]
FROM INV
JOIN STU ON INV.PID = STU.ID
WHERE STU.DEL = 0
AND STU.TG = ''
AND INV.CD IN ('RH','SG')
AND INV.DEL = 0

insert into #homevisits
SELECT
'Counseling' AS [Tablesource],
STU.ID AS [Studentid],
STU.LN + ', ' + STU.FN AS [Name],
(select LOC.NM from LOC where stu.SC = LOC.CD) AS [School],
STU.GR AS [Grade],
'test' AS [Race],
'test' AS [Ethnicity],
CAST(cnf.dt AS DATE) AS [DateofVisit],
cnf.CD AS [Code],
cnf.CO AS [Comments]
FROM cnf
JOIN STU ON cnf.PID = STU.ID
WHERE STU.DEL = 0
AND STU.TG = ''
AND cnf.CD = 'HV'
AND cnf.DEL = 0


SELECT * FROM #homevisits WHERE DateofVisit > '01-01-2021' order by DateofVisit

DROP TABLE #homevisits

-- LIST CNF IF CNF.CD = 'C5' AND CNF.DT > '2020-11-01' AND CNF.CU = 'CARE'

SELECT
STU.FN,
STU.LN,
( select LOC.NM from LOC where stu.SC = LOC.CD),
STU.GR,
CNF.*
FROM CNF JOIN STU ON STU.ID = CNF.PID WHERE CNF.CD = 'HV' AND CNF.DT > '01-01-2021'

SELECT * FROM SCHK WHERE SCHK.CD IN ('C', 'O', 'R', 'S')


WITH
  interventions (
    TableSource,
    StudentID,
    Name,
    School,
    Grade,
    Race,
    Ethnicity,
    DateOfVisit,
    Code,
    Comments
  )
AS (
  SELECT
  'Interventions',
  STU.ID,
  STU.LN + ', ' + STU.FN,
  (select LOC.NM from LOC where stu.SC = LOC.CD),
  STU.GR,
  'test',
  'test',
  CAST(inv.dt AS DATE),
  INV.CD,
  INV.CO
  FROM INV
  JOIN STU ON INV.PID = STU.ID
  WHERE STU.DEL = 0
  AND STU.TG = ''
  AND INV.CD IN ('RH','SG')
  AND INV.DEL = 0
),
  counseling (
    TableSource,
    StudentID,
    Name,
    School,
    Grade,
    Race,
    Ethnicity,
    DateOfVisit,
    Code,
    Comments
  )
AS (
  SELECT
  'Counseling' AS [Tablesource],
  STU.ID AS [Studentid],
  STU.LN + ', ' + STU.FN AS [Name],
  (select LOC.NM from LOC where stu.SC = LOC.CD) AS [School],
  STU.GR AS [Grade],
  'test' AS [Race],
  'test' AS [Ethnicity],
  CAST(cnf.dt AS DATE) AS [DateofVisit],
  cnf.CD AS [Code],
  cnf.CO AS [Comments]
  FROM cnf
  JOIN STU ON cnf.PID = STU.ID
  WHERE STU.DEL = 0
  AND STU.TG = ''
  AND cnf.CD = 'HV'
  AND cnf.DEL = 0
)

SELECT * FROM interventions UNION SELECT * FROM homevisits
