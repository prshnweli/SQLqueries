SELECT
group_name = (select (TLN + '.' + TF) from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 ),
school_natural_id = '43695836047922',
school_year = '2020',
subject_code = 'ALL',
student_ssid = STU.CID,
group_user_login = (select (EM) from TCH where stu.CU = TCH.TN and stu.sc = tch.sc and tch.del = 0 )
FROM STU
WHERE STU.SC = 11
AND STU.GR > 2
AND STU.DEL = 0
AND STU.TG = ''
