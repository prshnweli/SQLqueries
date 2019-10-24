
SELECT
STU.ID,
STU.FN,
STU.LN,
GRD.M4,
GRD.M8,
Teacher = (select TE from aer.TCH where GRD.TN = TCH.TN and tch.sc = 31 and tch.del = 0 )

FROM DBWH.aer.GRD AS GRD
JOIN DBWH.aer.STU AS STU
  ON (STU.SN = GRD.SN)
  AND (STU.SC = GRD.SC)
WHERE GRD.SC = 31;
