note
	description:  "[
		An exact point of time as on a gregorian callendar. 
		Has a `Year', `Month', and `Day' (i.e. a date).
		]"
	names: "date, time"
	date: "1 Jan 99"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	YMD_TIME

inherit

	ABSTRACT_TIME
		rename
			as_integer as as_days,
			from_integer as from_days
		redefine
			default_create,
			is_less,
			is_valid,
			duration_anchor,
			interval_anchor
		end

create
	default_create,
	set_now,
	set_now_utc,
	set,
	from_days,
	from_string

feature {NONE} -- Initialization

	default_create
			-- Create an instance based on todays date.
		do
			set_now
		end

feature -- Access

	year: INTEGER
			-- Year part of the date.

	month: INTEGER
			-- Month part of the date.

	day: INTEGER
			-- Day part of the date.
		do
			Result := internal_day
			if Result > last_day_of_month then
				Result := last_day_of_month
			end
		end

	week_number: INTEGER
			-- Week of the year containing this date.
		local
			d: YMD_TIME
			first_d: INTEGER	-- Jan 1st is on what day?
		do
			create d
			d.set (year, 1, 1)
			first_d := d.weekday
			Result := (((julian + first_d - 1 - 1) // 7) + 1)
		ensure
			result_large_enough: Result >= 1
			result_small_enough: Result <= 54	-- 53 ? 54 if leapyear falls just right.
		end

	last_day_of_month: INTEGER
			-- Date of last day for current month
		do
			inspect
				month
			when 2 then
				if is_leapyear then
					Result := 29
				else
					Result := 28
				end
			when 4, 6, 9, 11 then
				Result := 30
			else
				Result := 31
			end
		ensure
			day_in_range:	Result >= 28 and Result <= 31
			good_not_leap:	Result = 28 implies (month = 2 and not is_leapyear)
			good_in_leap:	Result = 29 implies (month = 2 and is_leapyear)
			good_30s:	Result = 30 implies (month = 4 or month = 6 or month = 9 or month = 11)
			good_31s:	Result = 31 implies (month=1 or month=3 or month=5 or month=7 or month=8 or month=10 or month=12)
		end

	days_remaining_this_month: INTEGER
			-- Number of days from current until end of month.
			-- Used in some calculations.
		do
			Result := last_day_of_month - day
		ensure
			valid_result: Result >= 0 and Result < last_day_of_month
		end

	julian: INTEGER
			-- Day of the year between 1 and 366
		local
			n,i : INTEGER
		do
			from
				i := 1
			until
				i >= month
			loop
				inspect  i
				when 2 then
					if is_leapyear then
						n := n + 29
					else
						n := n + 28
					end
				when 4,6,9,11 then
					n := n + 30
				else
					n := n + 31
				end
				i := i + 1
			end
  			result := n + day
		ensure
			valid_leapyear_result: is_leapyear implies (1 <= Result and Result <= 366)
			valid_result: not is_leapyear implies (1 <= Result and Result <= 365)
		end


	weekday: INTEGER
			-- 1 for Sunday, 2 for Monday, etc
			-- Only works as far back as ~2 Mar 0001. ???
		local
			x : INTEGER
		do
			x := internal\\7 + 1 + 1
			if x > 7 then  -- it can only be 8
				x := 1
			end
  			result := x
		ensure
			valid_weekday: 1 <= Result and Result <= 7
		end

	as_string: STRING
			-- The date represented as a string with no spaces.
			-- 18 Jan 2005 would be "20050118".
		do
			create Result.make (10)
			if is_bc then
				Result.append ("BC")
			end
			if not (year.abs >= 1000) then
				Result.append ("0")
			end
			if not (year.abs >= 100) then
				Result.append ("0")
			end
			if not (year.abs >= 10) then
				Result.append ("0")
			end
			Result.append (year.abs.out)
			if not (month >= 10) then
				Result.append ("0")
			end
			Result.append (month.out)
			if not (day >= 10) then
				Result.append ("0")
			end
			Result.append (day.out)
		end

	as_days: INTEGER
			-- The number of days from midnight (00:00:00)
			-- on 1 Jan 1970 to the beginning Current's `day'.
		local
			t: YMD_TIME
		do
			create t
			t.set (1970, 1, 1)
			Result := days_between (t)
		end

feature -- Element Change

	from_days (a_days: INTEGER)
			-- Change Current to the time represented by `a_days'.
			-- `A_days' is assumed to be the number of days since 1 Jan 1970.
			-- `A_days' must represent a date that is not BC
		do
			set (1970, 1, 1)
			add_days (a_days)
		end

	from_string (a_string: STRING)
			-- Change Current to the time represented by `a_string'.
			-- It must be in the format as provided by `as_string'.
		local
			d, m, y: INTEGER
		do
			y := a_string.substring (1, 4).to_integer
			m := a_string.substring (5, 6).to_integer
			d := a_string.substring (7, 8).to_integer
			set (y, m, d)
		end

	set_now
			-- Set the current object to today's date.
			-- This was copied from ISE's DATE class with the one minor change.
		do
			C_date.update
			set (C_date.year_now, C_date.month_now, C_date.day_now)
		end

	set_now_utc
			-- Set the current object to today's date in utc format.
			-- This was copied from ISE's DATE class with the one minor change.
		do
			C_date.update
			set (C_date.year_now, C_date.month_now, C_date.day_now)
		end

	set_now_utc_fine
			-- Set the current object to today's date in utc format.
			-- This was copied from ISE's TIME class with minor changes.
		do
			C_date.update
			set (C_date.year_now, C_date.month_now, C_date.day_now)
		end

	set (a_year, a_month, a_day: INTEGER)
		-- Give date new year, month, and day.
		-- If day > num days in month then day will return last day in the month.
		require
			realistic_year: a_year /= 0
			realistic_month: a_month >= 1 and a_month <= 12
			realistic_day: a_day >= 1 and a_day <= 31
		do
			year := a_year
			month := a_month
			internal_day := a_day
		ensure
			year_assigned: year = a_year
			month_assigned: month = a_month
			day_assigned: day = a_day
		end

	set_year (a_year: INTEGER)
			-- Change the year.
		require
			realistic_year: a_year /= 0
		do
			year := a_year
		ensure
			year_assigned: year = a_year
		end

	set_month (a_month: INTEGER)
			-- Change the month.
		require
			realistic_month: a_month >= 1 and a_month <= 12
		do
			month := a_month
		ensure
			month_assigned: month = a_month
		end

	set_day (a_day: INTEGER)
			-- Change the day.
			-- If a_day > number of days in the month then
			-- 'day' will be the last day of month.
		require
			realistic_day: a_day >= 1 and a_day <= 31
		do
			internal_day := a_day
		ensure
			day_assigned: day = a_day
		end

	truncate_to_years
			-- Set the day to first day of month 1.
			-- Use when all but the `year' is to be ignored.
		do
			set_day (1)
			set_month (1)
		ensure
			year_unchanged: year = old year
			month_one: month = 1
			day_one: day = 1
		end

	truncate_to_months
			-- Set day to first day of current month.
			-- Use when the `day' portion of date is to be ignored.
		do
			set_day (1)
		ensure
			year_unchanged: year = old year
			month_unchanged: month = old month
			day_one: day = 1
		end

feature -- Status report

	is_leapyear: BOOLEAN
			-- Is this a leapyear?
		do
			if is_bc then
				Result := (year + 1) \\ 4 = 0 and not ((year + 1) \\ 400 = 0)
			else
				Result := year \\ 4 = 0 and (not (year \\ 100 = 0) or else year \\ 400 = 0)
			end
		end

	is_bc: BOOLEAN
			-- Does the date represent a date B.C. (ie year < 1)
		do
			Result := year <= -1
		ensure
			definition: Result implies year <= -1
		end

	is_representable_as_integer: BOOLEAN
			-- Can Current be represented as an integer?
		do
			Result := not is_bc and then
				(Current >= Minimum_representable_date and Current <= Maximum_representable_date)
		end

feature -- Querry

	days_between (other: like Current): INTEGER
			-- Days between this date and 'other'.
			-- Only works back to ~2 Mar 0001.
		require
			other_exists : other /= Void
		do
			Result := (other.internal - internal).abs
		ensure
			definition: Result = (other.internal - internal).abs
		end

	time_between (other: like Current): like Duration_anchor
			-- The difference between two dates as a duration
		local
			larger, smaller: like Current
			y, m, d: INTEGER
		do
			larger := max (other)
			smaller := min (other)
			y := larger.year - smaller.year
			m := larger.month - smaller.month
			d := larger.day - smaller.day
			if d < 0 then
				d := d + smaller.last_day_of_month
				m := m - 1
			end
			if m < 0 then
				m := m + 12
				y := y - 1
			end
			create Result
			Result.set (y, m, d)
			if Current < other then
				Result.negate
			end
		end

	is_valid_integer_representation (a_integer: INTEGER): BOOLEAN
			-- Is `a_integer' in range to be converted to a time?
			-- Dependent on the `internal' representation of dates.
		do
				-- These values were found by trial and error.  This will give a
				-- date from 1 Jan 0001 to 18 Oct 1,469,902, which, I believe, is
				-- far enough into the future.
			Result := a_integer >= 1721426 and a_integer <= 538592032
		ensure then
			definition: Result implies (a_integer >= 1721426) and then
										(a_integer <= 538592032)	-- dependent on `internal'
		end

	is_valid_string_representation (a_string: STRING): BOOLEAN
			-- Is `a_string' in a format that can be used to initialize Current?
		local
			bcs: detachable STRING
			ys, ms, ds: STRING
			y, m, d: INTEGER
			pad: INTEGER	-- add 2 if is "BC"
		do
			if a_string /= Void and then (a_string.count = 8 or a_string.count = 10) then
				if a_string.count = 10 then
					pad := 2
					bcs := a_string.substring (1, 2)
				end
				ys := a_string.substring (1 + pad, 4 + pad)
				ms := a_string.substring (5 + pad, 6 + pad)
				ds := a_string.substring (7 + pad, 8 + pad)
				if ys.is_integer and then ms.is_integer and then ds.is_integer then
					y := ys.to_integer
					m := ms.to_integer
					d := ds.to_integer
					if (y /= 0) and then (m >= 0 and m < 12)and then (d >= 0 and d <= 31) then
						Result := True
						if bcs /= Void and then not equal (bcs, "BC") then
							Result := False
						end
					end
				end
			end
		end

feature -- Basic operations

	add_years (a_num: INTEGER)
			-- Add 'a_num' number of years to the date.  Works for negative numbers also.
		local
			y: INTEGER
		do
			y := year
			year := year + a_num
			if year = 0 then	-- Must preserve invarient: year can not be 0.
				if y < 0 then	-- year was less than 0 and increased to 0.
					year := 1
				else			-- year was greater than 0 and decreased to 0.
					year := -1
				end
			end
		ensure
			valid_date: is_valid
		end

	add_months (a_num: INTEGER)
			-- Add 'a_num' number of months to the date.  Works for negative numbers also.
		local
			m: INTEGER	-- store month prior making month valid to call 'add_years'.
		do
			month := month + a_num
			m := month
			month := month \\ 12		-- preserve invarient
			if month < 1 then
				month := month + 12		-- preserve invarient
				add_years (-1)
			end
			add_years (m // 12)	-- add a year for every multiple of 12.
		ensure
			valid_date: is_valid
		end

	add_days (a_num: INTEGER)
			-- Add 'a_num' number of days to the date.  Works for negative numbers also.
		local
			i: INTEGER
		do
			if a_num > 0 then
				from i := a_num
				until i <= days_remaining_this_month
				loop
					i := i - (days_remaining_this_month + 1)
					set_day (1)
					add_months (1)
				end
				set_day (day + i)
			elseif a_num < 0 then
				from
					i := a_num.abs
				until
					i < day
				loop
					i := (day - i).abs
					add_months (-1)
					set_day (last_day_of_month)
				end
				set_day (day - i)
			else
				-- do nothing if a_num = 0
			end
		ensure
			valid_date: is_valid
		end

	add_duration (a_duration: like Duration_anchor)
			-- Add a length of time (in years, months, and days) to the date.
		do
			add_days (a_duration.days)
			add_months (a_duration.months)
			add_years (a_duration.years)
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Does this date come before 'other'?
		require else
			other_not_void: other /= Void
		do
			Result := year < other.year or else
				(year = other.year) and (month < other.month) or else
				(year = other.year) and (month = other.month) and (day < other.day)
		ensure then
--			definition: year < other.year or else
--				(year = other.year) and (month < other.month) or else
--				(year = other.year) and (month = other.month) and (day < other.day)
		end

feature {YMD_TIME} -- Implementation

	frozen internal: INTEGER
			-- Internal representation of YMD_TIME
			-- Used internally by some features.
			-- Does not work for BC dates; only works back to 1 January 0001,
			-- at which time the result is 1,721,426.
			-- Will work up to a date of 18 Oct 1,469,902 (found by trial).
		require
			not_bc: not is_bc
		local
			c, ya : INTEGER;
			d,m,y : INTEGER;
		do
			d := day;
			m := month;
			y := year;
			if m > 2 then
				m := m - 3;
			else
				m := m + 9;
				y := y - 1;
			end
			c := y // 100;
			ya := y - 100 * c;
			result := (146097 * c) // 4 + (1461 * ya) // 4 + (153 * m + 2) // 5 + d + 1721119;
		ensure
			result_large_enough: Result >= 1721426
			result_small_enough: Result <= 538592032
		end

	frozen from_internal (num: INTEGER)
			-- Create a YMD_TIME from an internal representation.
    	local
			y,m,d,j : INTEGER
		do
			j := num;
			j := j - 1721119
			y := (4 * j - 1) // 146097;  j := 4 * j - 1 - 146097 * y;
			d := j // 4;
			j := (4 * d + 3) // 1461;   d := 4 * d + 3 - 1461 * j;
			d := (d + 4) // 4;
			m := (5 * d - 3) // 153;   d := 5 * d - 3 - 153 * m;
			d := (d + 5) // 5;
			y := 100 * y + j;
			if m < 10 then
				m := m + 3;
			else
				m := m - 9;
				y := y + 1;
			end;
			internal_day := d;
			month := m;
			year := y;
		end

feature {NONE} -- Implementation

	internal_day: INTEGER
			-- Used to save last day of month if day is greater than 28, 30, or 31.
			-- Actual day is calculated from this value.

	is_valid: BOOLEAN
			-- Is the date logical?
		do
			Result := is_valid_year and is_valid_month and is_valid_day
		end

	is_valid_year: BOOLEAN
			-- Is the year logical?
			-- Only invalid year is year "0".
		do
			Result := year /= 0
		ensure
			definition: year /= 0
		end

	is_valid_month: BOOLEAN
			-- Is the month logical?
		do
			Result := 1 <= month and month <= 12
		ensure
			definition: 1 <= month and month <= 12
		end

	is_valid_day: BOOLEAN
			-- Is the day logical based on month and year?
		do
			Result := 	day >= 1 and then
					( (day <= 28) or else
					((month=4 or month=6 or month=9 or month=11) and then day <= 30) or else
					((month=1 or month=3 or month=5 or month=7 or month=8 or month=10 or month=12) and then day <= 31) or else
					(month=2 and is_leapyear and day <= 29) )
		end

feature {NONE} -- Implementation

	Minimum_representable_date: like Current
			-- The earliest date that can be represented as an integer.
			-- This value is dependent on the implementation of `internal' and
			-- was found by trial and error to be 1 Jan 0001.
		do
			create Result
			Result.set_year (1)
			Result.set_month (1)
			Result.set_day (1)
		end

	Maximum_representable_date: like Current
			-- The latest date that can be represented as an integer.
			-- This value is dependent on the implementation of `internal' and
			-- was found by trial and error to be 18 Oct 1,469,902.
		do
			create Result
			Result.set_year (1_469_902)
			Result.set_month (10)
			Result.set_day (18)
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	duration_anchor: YMD_DURATION
			-- Anchor for features using durations.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	interval_anchor: YMD_INTERVAL
			-- Anchor for features using intervals.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

invariant

	is_valid: is_valid

end	-- class YMD_TIME


