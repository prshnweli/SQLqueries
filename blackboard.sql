USE Aeries

SELECT s.sc AS Institution,
s.id AS ReferenceCode,
s.[ln] AS LastName,
s.fn AS FirstName,
[LANGUAGE] =
(CASE s.cl
WHEN '00' THEN 'English'
WHEN '01' THEN 'Spanish'
WHEN '23' THEN 'Hmong'
WHEN '28' THEN 'Punjabi'
WHEN '11' THEN 'Arabic'
WHEN '12' THEN 'Armenian'
WHEN '03' THEN 'Cantonese'
WHEN '16' THEN 'Farsi'
WHEN '05' THEN 'Filipino'
WHEN '18' THEN 'German'
WHEN '08' THEN 'Japanese'
WHEN '07' THEN 'Mandarin'
WHEN '41' THEN 'Polish'
WHEN '45' THEN 'Rumanian'
WHEN '29' THEN 'Russian'
WHEN '34' THEN 'Tongan'
WHEN '35' THEN 'Urdu'
WHEN '02' THEN 'Vietnamese'
ELSE 'English'
END),
s.gr AS Grade,
s.tl AS HomePhone,
s.fw AS WorkPhone,
s.mw AS WorkPhoneAlt,
s.pem AS EmailAddress,
sp.em AS EmailAddressAlt,
SP.SMS AS SMSPHONE,
SP.SMS AS MOBILEPHONE,
CASE WHEN SP.EM != '' THEN 'X' ELSE '' END AS SPLITHOUSEHOLD,
CASE WHEN s.u2 = 'Y' THEN 'Special Ed' ELSE '' END AS RefreshGroup,
CASE WHEN s.u4 = 'Y' THEN 'Migrant' ELSE '' END  AS RefreshGroup
FROM dbo.stu s, dbo.sup sp
WHERE s.tg = ''
AND ( s.del IS NULL OR s.del = 0 )
AND s.sc IN ('2','6','8','9','10','11','12','15','20','21','30','31','32','50','51')
and sp.del = 0
and sp.sc = s.sc
and sp.sn = s.sn
