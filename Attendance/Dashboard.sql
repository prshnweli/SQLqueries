-- delete from [dbo].[YTD]

drop table if exists #MonthlyAttendance;
create table #MonthlyAttendance (
	SchoolNumber int,
	SchoolName nvarchar(128),
	Grade int,
	GradeRange nvarchar(64),
	TeacherNumber int,
	TeacherName nvarchar(64),
	MonthNumber int,
	Programs nvarchar(256),
	ProgramCodes nvarchar(64),
	DaysTaught dec(38,16),
	EnrollmentCarriedForward dec(38,16),
	Gains dec(38,16),
	TotalEnrollment dec(38,16),
	Losses dec(38,16),
	EndingEnrollment dec(38,16),
	DaysNotEnrolled dec(38,16),
	DaysNonApportAttend dec(38,16),
	ActualDays dec(38,16),
	MaxDaysPossible dec(38,16),
	TotalApportAttend dec(38,16),
	TotalADA dec(38,16),
);


insert into #MonthlyAttendance
select

  /* you are most likely to use these for grouping */
  ytd.sc as [SchoolNumber],
  loc.nm as [SchoolName],
  ytd.gr as [Grade],

  /* grade ranges
    double hyphen '--' is used to avoid ambiguity with other data types, like
    excels string->date auto converter.
  */
  case
    when ytd.gr = -2            then cast('PS'    as nvarchar(5))
    when ytd.gr in (-1,0,1,2,3) then cast('TK--3' as nvarchar(5))
    when ytd.gr in (4,5,6)      then cast('4--6'  as nvarchar(5))
    when ytd.gr in (7,8)        then cast('7--8'  as nvarchar(5))
    when ytd.gr in (9,10,11,12) then cast('9--12' as nvarchar(5))
  end as GradeRange,

  ytd.tn as [TeacherNumber],
  tch.te as [TeacherName],
  ytd.mo as [MonthNumber],

  /* programs */
  rtrim(ltrim(concat(
    pr1.de,
    iif(pr2.de is not null, concat(', ', pr2.de),''),
    iif(pr3.de is not null, concat(', ', pr3.de),''),
    iif(pr4.de is not null, concat(', ', pr4.de),''),
    iif(pr5.de is not null, concat(', ', pr5.de),''),
    iif(pr6.de is not null, concat(', ', pr6.de),''),
    iif(pr7.de is not null, concat(', ', pr7.de),'')
  )))                                                 as [Programs],     -- Program descriptions concatenated
  cast(ytd.pr as nvarchar(7))                         as [ProgramCodes], -- original program code concatenation

  /* the individual program code. uncomment if you need them.*/
  --right(left(ytd.pr,1),1)     as [ProgramCode1],
  --right(left(ytd.pr,2),1)     as [ProgramCode2],
  --right(left(ytd.pr,3),1)     as [ProgramCode3],
  --right(left(ytd.pr,4),1)     as [ProgramCode4],
  --right(left(ytd.pr,5),1)     as [ProgramCode5],
  --right(left(ytd.pr,6),1)     as [ProgramCode6],
  --right(left(ytd.pr,7),1)     as [ProgramCode7],

  /* lettered column produced in aeries pdf
    - PDF Column Names are used as a point of reference.
    - some name were modified to remove weird character.
  */
  ytd.da                                as [DaysTaught],               -- MONTHLY ATTENDANCE SUMMARY PDF COL A
  ytd.cf                                as [EnrollmentCarriedForward], -- MONTHLY ATTENDANCE SUMMARY PDF COL B
  ytd.gn                                as [Gains],                    -- MONTHLY ATTENDANCE SUMMARY PDF COL C
  (ytd.cf + ytd.gn)                     as [TotalEnrollment],          -- MONTHLY ATTENDANCE SUMMARY PDF COL D
  ytd.lo                                as [Losses],                   -- MONTHLY ATTENDANCE SUMMARY PDF COL E
  ((ytd.cf + ytd.gn) - ytd.lo)          as [EndingEnrollment],         -- MONTHLY ATTENDANCE SUMMARY PDF COL F
  ytd.ne                                as [DaysNotEnrolled],          -- MONTHLY ATTENDANCE SUMMARY PDF COL G
  ytd.na                                as [DaysNonApportAttend],      -- MONTHLY ATTENDANCE SUMMARY PDF COL H
  ytd.da * (ytd.cf + ytd.gn)            as [ActualDays],               -- MONTHLY ATTENDANCE SUMMARY PDF COL I
  (ytd.da * (ytd.cf + ytd.gn))

 /* total Enrollment  for the month in days */
  - ytd.ne                              as [MaxDaysPossible],          -- MONTHLY ATTENDANCE SUMMARY TOTALS PDF COL K
  (ytd.da * (ytd.cf + ytd.gn))
  - ytd.ne - ytd.na                     as [TotalApportAttend],        -- MONTHLY ATTENDANCE SUMMARY PDF COL J

  case
    when ((ytd.da * (ytd.cf + ytd.gn))
           - ytd.ne - ytd.na) = 0
      then 0
    else ((ytd.da * (ytd.cf + ytd.gn))
        - ytd.ne - ytd.na) / ytd.da
    end                                 as [TotalADA]                  -- MONTHLY ATTENDANCE SUMMARY PDF COL K


/* YTD
  - select minimum columns needed.
  - adjust/scrub data types.
*/
from (
  select
    sc, --school
    gr, --grade
    tn, --teacher number
    mo, --month
    cast(ltrim(rtrim(pr)) as nchar(7)) as pr,    --programs
    cast(da as decimal(38,19)) as da, --days
    cast(cf as decimal(38,19)) as cf, --carried
    cast(gn as decimal(38,19)) as gn, --gains
    cast(lo as decimal(38,19)) as lo, --losses
    cast(ne as decimal(38,19)) as ne, --not/enr
    cast(na as decimal(38,19)) as na  --nonAppor
  from ytd
  where
    del = 0
) as ytd

/* teacher info */
left join (
  select *
  from tch
  where
    del = 0
) as tch
  on tch.sc = ytd.sc
  and tch.tn = ytd.tn

/* school info */
left join (
  select
    cd,
    ltrim(rtrim(nm)) as nm --nm will be the school name string.
  from loc
  where del = 0
) as loc
  on loc.cd = ytd.sc



/* programs
  this process of breaking up the program codes is repetative
  and compute intensive If anyone has a better idea please let
  me know.
*/
left  join (
    select
      ltrim(rtrim(cd)) as cd,
      max(ltrim(rtrim(de))) as de
    from cod
    where
        tc = 'stu'
        and fc in ('sp','ap1','ap2')
        and del = 0
    group by cd
) as pr1
  on pr1.cd = right(left(ytd.pr,1),1)

left  join (
    select
      ltrim(rtrim(cd)) as cd,
      max(ltrim(rtrim(de))) as de
    from cod
    where
        tc = 'stu'
        and fc in ('sp','ap1','ap2')
        and del = 0
    group by cd
) as pr2
  on pr2.cd = nullif(right(left(ytd.pr,2),1),'')


left  join (
    select
      ltrim(rtrim(cd)) as cd,
      max(ltrim(rtrim(de))) as de
    from cod
    where
        tc = 'stu'
        and fc in ('sp','ap1','ap2')
        and del = 0
    group by cd
) as pr3
  on pr3.cd = nullif(right(left(ytd.pr,3),1),'')


left  join (
    select
      ltrim(rtrim(cd)) as cd,
      max(ltrim(rtrim(de))) as de
    from cod
    where
        tc = 'stu'
        and fc in ('sp','ap1','ap2')
        and del = 0
    group by cd
) as pr4
  on pr4.cd = nullif(right(left(ytd.pr,4),1),'')


left  join (
    select
      ltrim(rtrim(cd)) as cd,
      max(ltrim(rtrim(de))) as de
    from cod
    where
        tc = 'stu'
        and fc in ('sp','ap1','ap2')
        and del = 0
    group by cd
) as pr5
  on pr5.cd = nullif(right(left(ytd.pr,5),1),'')


left  join (
    select
      ltrim(rtrim(cd)) as cd,
      max(ltrim(rtrim(de))) as de
    from cod
    where
        tc = 'stu'
        and fc in ('sp','ap1','ap2')
        and del = 0
    group by cd
) as pr6
  on pr6.cd = nullif(right(left(ytd.pr,6),1),'')

left  join (
    select
      ltrim(rtrim(cd)) as cd,
      max(ltrim(rtrim(de))) as de
    from cod
    where
        tc = 'stu'
        and fc in ('sp','ap1','ap2')
        and del = 0
    group by cd
) as pr7
  on pr7.cd = nullif(right(left(ytd.pr,7),1),'');

-- ```````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````

select
	2020 as SchoolYear,
	SchoolName,
	max(MonthNumber) as MonthNumber,
	sum(DaysTaught) as DaysTaught,
	sum(MaxDaysPossible) as DaysEnrolled,
	sum(TotalApportAttend ) as DaysAttended

from (
	select
		SchoolNumber,
		SchoolName,
		max(DaysTaught) as DaysTaught,
		sum(MaxDaysPossible) as MaxDaysPossible,
		sum(TotalApportAttend ) as [TotalApportAttend],
		MonthNumber,
		2020 as SchoolYear

	from #MonthlyAttendance

	where
		Grade > -2
		and SchoolNumber != 30
		and Programs not like '%No ADA%'
		and Programs not like '%PreSchool%'
		and (
			Programs    like '%Home-Hospital%'
			or Programs like '%Regular Program%'
			or Programs like '%SDC%'
			or Programs like '%Independent Study%'
			or Programs like '%Transitional Kinder%'
			or Programs like '%Out of County%' --?
		)
		and MonthNumber in (5)
	group by MonthNumber,SchoolNumber,SchoolName
) as x
group by SchoolNumber,SchoolName
order by SchoolNumber

-- Calculate Central by running Monthly Attendance Summary/Continuation report and adding up collumn H/3 for DaysEnrolled and K/3 for DaysAttended
