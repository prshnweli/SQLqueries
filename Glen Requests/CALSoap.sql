SELECT
STU.SC AS "School Code",
School = (select LOC.NM from LOC where stu.SC = LOC.CD),
STU.CID AS "State ID",
STU.ID AS "ID",
STU.FN AS "First Name",
STU.LN AS "Last Name",
LEFT(STU.MN,1) AS "Middle Initial",
CAST(STU.BD AS DATE) AS "Birthday",
STU.SX AS "Gender",
STU.AD AS "Address",
STU.CY AS "City",
STU.ST AS "State",
STU.ZC AS "Zip Code",
STU.RAD AS "Residence Address",
STU.RCY AS "Residence City",
STU.RST AS "Residence State",
STU.RZC AS "Residence Zip Code",
STU.TL AS "Phone Number",
STU.ETH AS "Ethnicity Code",
[Ethnicity] = (CASE
	WHEN STU.ETH = 'Y' THEN 'Hispanic or Latino'
	WHEN STU.ETH = 'N' THEN 'Not Hispanic or Latino'
	WHEN STU.ETH = 'Z' THEN 'Decline to State'
END),
STU.RC1 AS "Race Code",
[Race] = (CASE
	WHEN STU.RC1 = 100 THEN 'American Indian or Alaskan Native'
	WHEN STU.RC1 = 201 THEN 'Chinese'
  WHEN STU.RC1 = 202 THEN 'Japanese'
  WHEN STU.RC1 = 203 THEN 'Korean'
  WHEN STU.RC1 = 204 THEN 'Vietnamese'
  WHEN STU.RC1 = 205 THEN 'Asian Indian'
  WHEN STU.RC1 = 206 THEN 'Laotian'
  WHEN STU.RC1 = 207 THEN 'Cambodian'
  WHEN STU.RC1 = 208 THEN 'Hmong'
  WHEN STU.RC1 = 299 THEN 'Other Asian'
  WHEN STU.RC1 = 301 THEN 'Hawaiian'
  WHEN STU.RC1 = 302 THEN 'Guamanian'
  WHEN STU.RC1 = 303 THEN 'Samoan'
  WHEN STU.RC1 = 304 THEN 'Tahitian'
  WHEN STU.RC1 = 399 THEN 'Other Pacific Islander'
  WHEN STU.RC1 = 400 THEN 'Filipino'
	WHEN STU.RC1 = 600 THEN 'Black or African American'
	WHEN STU.RC1 = 700 THEN 'White'
	WHEN STU.RC1 = 999 THEN 'Decline to State'
END),
STU.GR AS "Grade",
[LANGUAGE] =
(CASE stu.hl
  WHEN '00' THEN 'English'
  WHEN '01' THEN 'Spanish'
  WHEN '02' THEN 'Vietnamese'
  WHEN '03' THEN 'Cantonese'
  WHEN '04' THEN 'Korean'
  WHEN '05' THEN 'Filipino (Tagalog)'
  WHEN '06' THEN 'Portuguese'
  WHEN '07' THEN 'Mandarin (Putonghua)'
  WHEN '08' THEN 'Japanese'
  WHEN '09' THEN 'Khmer (Cambodian)'
  WHEN '10' THEN 'Lao'
  WHEN '11' THEN 'Arabic'
  WHEN '15' THEN 'Dutch'
  WHEN '16' THEN 'Farsi (Persian)'
  WHEN '17' THEN 'French'
  WHEN '18' THEN 'German'
  WHEN '19' THEN 'Greek'
  WHEN '21' THEN 'Hebrew'
  WHEN '22' THEN 'Hindi'
  WHEN '23' THEN 'Hmong'
  WHEN '24' THEN 'Hungarian'
  WHEN '25' THEN 'Ilocano'
  WHEN '26' THEN 'Indonesian'
  WHEN '28' THEN 'Punjabi'
  WHEN '29' THEN 'Russian'
  WHEN '32' THEN 'Thai'
  WHEN '33' THEN 'Turkish'
  WHEN '34' THEN 'Tongan'
  WHEN '35' THEN 'Urdu'
  WHEN '37' THEN 'Sign Language'
  WHEN '40' THEN 'Pashto'
  WHEN '41' THEN 'Polish'
  WHEN '42' THEN 'Assyrian'
  WHEN '43' THEN 'Gujarati'
  WHEN '45' THEN 'Rumanian'
  WHEN '46' THEN 'Taiwanese'
  WHEN '56' THEN 'Albanian'
  WHEN '57' THEN 'Tigrinya'
  WHEN '60' THEN 'Somali'
  WHEN '62' THEN 'Telugu'
  WHEN '63' THEN 'Tamil'
  WHEN '64' THEN 'Marathi'
  WHEN '65' THEN 'Kannada'
  WHEN '70' THEN 'Swedish'
  WHEN '99' THEN 'Other non-English'
END),
STU.PED AS "Parent Education Level Code",
[Parent Education Level] = CASE STU.PED
	WHEN 10 THEN 'Grad School/post grad trng'
	WHEN 11 THEN 'College Graduate'
	WHEN 12 THEN 'Some College'
	WHEN 13 THEN 'High School Graduate'
	WHEN 14 THEN 'Not HS Graduate'
	WHEN 15 THEN 'Declined to State/Unkown'
END,
(SELECT TOP(1) CD FROM FRE WHERE STU.ID = FRE.ID AND fre.esd > '7/1/2020' and fre.eed = '6/30/2021') AS "Assignment",
(SELECT TOP(1) CAST(ESD AS DATE) FROM FRE WHERE STU.ID = FRE.ID AND fre.esd > '7/1/2020' and fre.eed = '6/30/2021') AS "Elg Start Dt",
(SELECT TOP(1) CAST(EED AS DATE) FROM FRE WHERE STU.ID = FRE.ID AND fre.esd > '7/1/2020' and fre.eed = '6/30/2021') AS "Elg End Dt"
FROM STU
WHERE STU.DEL = 0
AND STU.TG = ''
