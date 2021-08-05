SELECT
CNF.PID AS 'StudentID',
CAST(CNF.DT AS DATE) AS 'Date',
CNF.CD AS 'Code',
CNF.CU AS 'Counselor',
CNF.GR AS 'Grade',
CNF.ST AS 'Status',
CNF.CL AS 'Location',
CNF.D2 AS 'FollowUp',
CNF.D3 AS 'LastCont',
CNF.TTI AS 'TotalTime'
FROM CNF
WHERE CNF.DT > '2020/08/01'
