SELECT
STU.ID,
STU.FN,
STU.LN,
STU.GR,
School = ( select LOC.NM from LOC where stu.SC = LOC.CD),
ISNULL((SELECT max(PWA.CDT) AS logi WHERE (PWA.TY = 'P')),NULL) AS "Last Accessed",
ISNULL((SELECT max(PWA.LC) AS logi WHERE (PWA.TY = 'P')),NULL) AS "Login Count",

FROM STU
JOIN PWS
	ON PWS.ID = STU.ID
JOIN PWA
	ON PWA.AID = PWS.AID
WHERE stu.sc in (2,6,8,9,10,11,12,15,20,21,30,31,32)
AND STU.DEL = 0
AND STU.TG = ''
AND PWA.TY = 'P'
GROUP BY STU.ID, STU.FN, STU.LN, STU.GR, STU.SC, PWA.TY
ORDER BY STU.SC, STU.GR, STU.LN, STU.FN


--Portal Account percentages with distinct login counts of Parent/Student
select stu.SC, loc.NM, count(*) as TotalStudents,
(select count(distinct s1.id) from stu as s1 left join pws on pws.id = s1.id left join pwa on pwa.aid = pws.aid where pwa.del = 0 and pws.del = 0 and s1.del = 0 and rtrim(s1.tg) = '' and s1.sc = stu.sc) as TotalWithAccounts,
cast(cast(round((cast((select count(distinct s1.id) from stu as s1 left join pws on pws.id = s1.id left join pwa on pwa.aid = pws.aid where pwa.del = 0 and pws.del = 0 and s1.del = 0 and rtrim(s1.tg) = '' and s1.sc = stu.sc) as decimal)/cast(count(*)as decimal) * 100),2) as decimal(10,2)) as varchar(10))+'%' as PercentwithAccounts,
cast(cast(round(abs((cast((select count(distinct s1.id) from stu as s1 left join pws on pws.id = s1.id left join pwa on pwa.aid = pws.aid where pwa.del = 0 and pws.del = 0 and s1.del = 0 and rtrim(s1.tg) = '' and s1.sc = stu.sc) as decimal)/cast(count(*)as decimal) * 100) - 100),2) as decimal(10,2)) as varchar(10))+'%' as PercentwithoutAccounts,
(select count(distinct s1.id) from stu as s1 left join pws on pws.id = s1.id left join pwa on pwa.aid = pws.aid where pwa.del = 0 and pwa.ty = 'P' and pws.del = 0 and s1.del = 0 and rtrim(s1.tg) = '' and s1.sc = stu.sc) as TotalWithParentAccounts,
cast(cast(round((cast((select count(distinct s1.id) from stu as s1 left join pws on pws.id = s1.id left join pwa on pwa.aid = pws.aid where pwa.del = 0 and pwa.ty = 'P' and pws.del = 0 and s1.del = 0 and rtrim(s1.tg) = '' and s1.sc = stu.sc) as decimal)/cast(count(*)as decimal) * 100),2) as decimal(10,2)) as varchar(10))+'%' as PercentwithParentAccounts,
cast(cast(round(abs((cast((select count(distinct s1.id) from stu as s1 left join pws on pws.id = s1.id left join pwa on pwa.aid = pws.aid where pwa.del = 0 and pwa.ty = 'P' and pws.del = 0 and s1.del = 0 and rtrim(s1.tg) = '' and s1.sc = stu.sc) as decimal)/cast(count(*)as decimal) * 100) - 100),2) as decimal(10,2)) as varchar(10))+'%' as PercentwithoutParentAccounts,
(select count(distinct s1.id) from stu as s1 left join pws on pws.id = s1.id left join pwa on pwa.aid = pws.aid where pwa.del = 0 and pwa.ty = 'S' and pws.del = 0 and s1.del = 0 and rtrim(s1.tg) = '' and s1.sc = stu.sc) as TotalWithStudentAccounts,
cast(cast(round((cast((select count(distinct s1.id) from stu as s1 left join pws on pws.id = s1.id left join pwa on pwa.aid = pws.aid where pwa.del = 0 and pwa.ty = 'S' and pws.del = 0 and s1.del = 0 and rtrim(s1.tg) = '' and s1.sc = stu.sc) as decimal)/cast(count(*)as decimal) * 100),2) as decimal(10,2)) as varchar(10))+'%' as PercentwithStudentAccounts,
cast(cast(round(abs((cast((select count(distinct s1.id) from stu as s1 left join pws on pws.id = s1.id left join pwa on pwa.aid = pws.aid where pwa.del = 0 and pwa.ty = 'S' and pws.del = 0 and s1.del = 0 and rtrim(s1.tg) = '' and s1.sc = stu.sc) as decimal)/cast(count(*)as decimal) * 100) - 100),2) as decimal(10,2)) as varchar(10))+'%' as PercentwithoutStudentAccounts,
(select count(id) from (select distinct ID from phl where pg like '%login%' and un in (select em from pwa where ty = 'P' and del = 0) and id in (select stu2.id from stu as stu2 where stu2.del = 0 and stu2.sc = stu.sc)) as Parents) as ParentsThatLoggedInThisYear,
(select count(id) from (select distinct ID from phl where pg like '%login%' and un in (select em from pwa where ty = 'P' and del = 0) and id in (select stu2.id from stu as stu2 where stu2.del = 0 and stu2.sc = stu.sc) and dts >= CURRENT_TIMESTAMP - 30 ) as Parents) as ParentsThatLoggedInLast30Days,
(select count(id) from (select distinct ID from phl where pg like '%login%' and un in (select em from pwa where ty = 'S' and del = 0) and id in (select stu2.id from stu as stu2 where stu2.del = 0 and stu2.sc = stu.sc)) as Students) as StudentsThatLoggedInThisYear,
(select count(id) from (select distinct ID from phl where pg like '%login%' and un in (select em from pwa where ty = 'S' and del = 0) and id in (select stu2.id from stu as stu2 where stu2.del = 0 and stu2.sc = stu.sc) and dts >= CURRENT_TIMESTAMP - 30 ) as Students) as StudentsThatLoggedInLast30Days
from stu left join loc on stu.sc = loc.cd
where rtrim(stu.tg) = '' and stu.del = 0
and stu.sc = 8
group by stu.sc, loc.nm
order by stu.sc
