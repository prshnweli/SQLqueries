SELECT
STUID = ADS.PID,
School = ( select LOC.NM from LOC where ADS.SCL = LOC.CD),
Grade = ADS.GR,
Date_dis = CAST(ADS.DT AS DATE),
ViolationCD = ADS.CD,
ViolationCD2 = ADS.CD2,
ViolationCD3 = ADS.CD3,
ViolationCD4 = ADS.CD4,
ViolationCD5 = ADS.CD5
FROM ADS
WHERE ADS.DT > '2020-08-15'
ORDER BY ADS.DT


SELECT
STUID = DIS.PID,
Date_DIS = CAST(DIS.DT AS DATE),
Code = DIS.CD,
School = ( select LOC.NM from LOC where DIS.SCL = LOC.CD),
Consequence = DIS.CN
FROM DIS
WHERE DIS.DT > '2020-08-15'
