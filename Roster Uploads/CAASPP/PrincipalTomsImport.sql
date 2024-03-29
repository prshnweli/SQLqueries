SELECT
TCH.TF,
TCH.TLN,
TCH.EM,
[Phone] = CASE TCH.SC
WHEN 2 THEN '4082016380'
WHEN 6 THEN '4082016420'
WHEN 8 THEN '4082016440'
WHEN 9 THEN '4082016460'
WHEN 10 THEN '4082016480'
WHEN 11 THEN '4082016500'
WHEN 12 THEN '4082016340'
WHEN 15 THEN '4082016400'
WHEN 20 THEN '4082016160'
WHEN 21 THEN '4082016260'
WHEN 30 THEN '4082016300'
WHEN 31 THEN '4082016100'
WHEN 32 THEN '4082016200'
END,
[Cell Phone Number] = '',
[CDS] = CASE TCH.SC
WHEN 2 THEN '43695836109375'
WHEN 6 THEN '43695836095392'
WHEN 8 THEN '43695836047914'
WHEN 9 THEN '43695836098271'
WHEN 10 THEN '43695836047948'
WHEN 11 THEN '43695836047922'
WHEN 12 THEN '43695836118376'
WHEN 15 THEN '43695836098263'
WHEN 20 THEN '43695836095384'
WHEN 21 THEN '43695836100325'
WHEN 30 THEN '43695834334488'
WHEN 31 THEN '43695834333951'
WHEN 32 THEN '43695830102368'
END,
[Role in Organization] = 'Site CAASPP Coordinator',
[Admin Year] = '2020-21',
[Action] = 'Add Role'
FROM TCH
WHERE TCH.ID IN(2048,1490,585,843972,2097,237,225,843498,843743,843501,396,1312,1301,1853,1573,1789,1,3130,26,843973,843738)
AND TCH.DEL = 0
AND TCH.TG = ''
ORDER BY SC, TLN
