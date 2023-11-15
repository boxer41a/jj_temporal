note
	description:  "[
		An exact point of time of a particular day.  A Year, Month, Day, 
		Hour, Minute, Second - time	(ie. a date and time).
		]"
	names: "date, time, date_and_time"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	YMDHMS_TIME

inherit

	YMD_TIME
		rename
			set as set_ymd_time,
			as_days as as_seconds,
			from_days as from_seconds
		redefine
			default_create,
			set_now,
			set_now_utc,
			set_now_utc_fine,
			is_less,
			is_valid,
			add_duration,
			time_between,
--			normalize,
			truncate_to_years,
			truncate_to_months,
			as_string,
			as_seconds,
			from_seconds,
			from_string,
			is_valid_string_representation,
			is_valid_integer_representation,
			is_representable_as_integer,
			duration_anchor,
			interval_anchor
		end

	HMS_TIME
		rename
			set as set_hms_time
		redefine
			default_create,
			set_now,
			set_now_utc,
			set_now_fine,
			set_now_utc_fine,
			is_less,
			is_valid,
			add_duration,
			time_between,
			seconds_between,
			add_hours,
--			normalize,
			truncate_to_hours,
			truncate_to_minutes,
			as_string,
			as_seconds,
			from_seconds,
			from_string,
			is_valid_string_representation,
			is_valid_integer_representation,
			is_representable_as_integer,
			Duration_anchor,
			Interval_anchor
		select
			from_seconds
		end

create
	default_create,
	set_now,
	set_now_utc,
	set_now_fine,
	set_now_utc_fine,
	from_seconds,
	from_string

feature {NONE} -- Initialization

	default_create
			-- Create an instance with todays date at midnight.
		do
			Precursor {HMS_TIME}
			Precursor {YMD_TIME}
		end

feature -- Access

	as_string: STRING
			-- String representation of Current in a compact form.
		do
			Result := Precursor {YMD_TIME}
			Result.append ("T")
			Result.append (Precursor {HMS_TIME})
		end

	as_seconds: INTEGER
			-- The number of seconds from midnight (00:00:00)
			-- on 1 Jan 1970 to the Current time.
		local
			days: INTEGER
		do
			days := Precursor {YMD_TIME}
			Result := days * 24 * 60 * 60 + Precursor {HMS_TIME}
		end

feature -- Element Change

	from_string (a_string: STRING)
			-- Change Current to the time represented by `a_string'.
			-- It must be in the format as provided by `as_string'.
		local
			pos: INTEGER
		do
			pos := a_string.index_of ('T', 1)
			Precursor {YMD_TIME} (a_string.substring (1, pos - 1))
			Precursor {HMS_TIME} (a_string.substring (pos + 1, a_string.count))
		end

	from_seconds (a_seconds: INTEGER)
			-- Change Current to the time represented by `a_seconds'.
			-- `A_seconds' is assumed to be the number of seconds since 1 Jan 1970.
			-- It must represent a date that is not BC.
		do
			set (1970, 1, 1, 0, 0, 0)
			add_seconds (a_seconds)
		end

	set_now
			-- Initialize the instance from the system clock unsing the
			-- current time zone.
		do
			Precursor {HMS_TIME}
			Precursor {YMD_TIME}
		end

	set_now_utc
			-- Initialize the instance from the system clock unsing GMT.
		do
			Precursor {HMS_TIME}
			Precursor {YMD_TIME}
		end

	set_now_fine
			-- Initialize the instance from the system clock using the current
			-- time zone and including milliseconds.
		do
			set_now
			Precursor {HMS_TIME}
		end

	set_now_utc_fine
			-- Initialize the instance from the system clock using the GMT and
			-- including milliseconds.
		do
			set_now_utc
			Precursor {HMS_TIME}
		end

	set (a_year, a_month, a_day, a_hour, a_minute, a_second: INTEGER)
			-- Change the 'year', ..., 'second'.
		require
			year_valid: a_year /= 0;
			month_valid: 1 <= a_month and a_month <= 12;
			day_valid: 1 <= a_day and a_day <= 31;
			hour_valid: 0 <= a_hour and a_hour <= 23;
			minute_valid: 0 <= a_minute and a_minute <= 59;
			second_valid: 0 <= a_second and a_second <= 59
		do
			set_ymd_time (a_year, a_month, a_day);
			set_hms_time (a_hour, a_minute, a_second);
		end

	truncate_to_years
			-- Set to midnight on the first day of month 1.
			-- Use when all but the `year' is to be ignored.
		do
			Precursor {YMD_TIME}
			set_hms_time (0, 0, 0)
		ensure then
			year_unchanged: year = old year
			month_one: month = 1
			day_one: day = 1
			hour_zero: hour = 0
			minute_zero: minute = 0
			second_zero: second = 0
		end

	truncate_to_months
			-- Set to midnight on the first day of the current month.
			-- Use when all but the `year' and `month' is to be ignored.
		do
			Precursor {YMD_TIME}
			set_hms_time (0, 0, 0)
		ensure then
			year_unchanged: year = old year
			month_unchaged: month = old month
			day_one: day = 1
			hour_zero: hour = 0
			minute_zero: minute = 0
			second_zero: second = 0
		end

	truncate_to_days
			-- Set to midnight on the current day.
			-- Use when the time portion of the date is to be ignored.
		do
			set_hms_time (0, 0, 0)
		ensure then
			year_unchanged: year = old year
			month_unchaged: month = old month
			day_unchaged: day = old day
			hour_zero: hour = 0
			minute_zero: minute = 0
			second_zero: second = 0
		end

	truncate_to_hours
			-- Set the `hour', `second', and `millisecond' to zero.
			-- Used when these portions of the time are to be ignored.
		do
			set (year, month, day, hour, 0, 0)
		end

	truncate_to_minutes
		do
			set (year, month, day, hour, minute, 0)
		end

feature -- Basic operations

	add_duration (a_duration: like duration_anchor)
			-- Add a length of time (in years, months, days,
			-- hours, minutes, and seconds) to the time.
		do
			Precursor {HMS_TIME} (a_duration)
			add_days (overflow)
			clear_overflow
			Precursor {YMD_TIME} (a_duration)
		ensure then
			no_overflowing_days: overflow = 0
		end

	add_hours (a_number: INTEGER)
			-- Add `a_number' of hours to the current time
		do
			Precursor {HMS_TIME} (a_number)
			add_days (overflow)
			clear_overflow
		end

feature -- Status report

	is_representable_as_integer: BOOLEAN
			-- Can Current be represented as an integer?
		do
			Result := Precursor {HMS_TIME} and then Precursor {YMD_TIME}
		end

feature -- Querry

	time_between (other: like Current): like duration_anchor
			-- The difference between two dates as a time span or duration.
		local
			larger, smaller: like Current
			y, mon, d, h, m, s: INTEGER
		do
			larger := max (other)
			smaller := min (other)
			y := larger.year - smaller.year
			mon := larger.month - smaller.month
			d := larger.day - smaller.day
			h := larger.hour - smaller.hour
			m := larger.minute - smaller.minute
			s := larger.second - smaller.second
			if s < 0 then
				s := s + 60
				m := m - 1
			end
			if m < 0 then
				m := m + 60
				h := h - 1
			end
			if h < 0 then
				h := h + 24
				d := d - 1
			end
			if d < 0 then
				d := d + smaller.last_day_of_month
				mon := mon - 1
			end
			if mon < 0 then
				mon := mon + 12
				y := y - 1
			end
			create Result
			Result.set (y, mon, d, h, m, s)
			if Current < other then
				Result.negate
			end
		end

	seconds_between (a_other: like Current): INTEGER
			-- The number of seconds between Current and `a_other'.
		do
			Result := days_between (a_other) * 24 * 60 * 60 + Precursor {HMS_TIME} (a_other)
		end

	is_valid_string_representation (a_string: STRING): BOOLEAN
			-- Is `a_string' in a format that can be used to initialize Current?
		local
			i: INTEGER
			ds, ts: STRING
		do
			if a_string /= Void then
				i := a_string.index_of ('T', 1)
				ds := a_string.substring (1, i - 1)
				ts := a_string.substring (i + 1, a_string.count)
				Result := Precursor {YMD_TIME} (ds) and then Precursor {HMS_TIME} (ts)
			end
		end

	is_valid_integer_representation (a_integer: INTEGER): BOOLEAN
			-- Is `a_integer' in range to be converted to a time?
		do
			Result := Precursor {HMS_TIME} (a_integer) and then
					 Precursor {YMD_TIME} (a_integer)
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Does this date_and_time come before 'other'
		do
			Result := year < other.year or else
					((year = other.year) and (month < other.month)) or else
					((year = other.year) and (month = other.month) and (day < other.day)) or else
					((year = other.year) and (month = other.month) and (day = other.day) and
						(hour < other.hour)) or else
					((year = other.year) and (month = other.month) and (day = other.day) and
						(hour = other.hour) and (minute < other.minute)) or else
					((year = other.year) and (month = other.month) and (day = other.day) and
						(hour = other.hour) and (minute = other.minute) and (second < other.second)) or else
					((year = other.year) and (month = other.month) and (day = other.day) and
						(hour = other.hour) and (minute = other.minute) and (second = other.second) and
						(millisecond < other.millisecond))

		end

feature {NONE} -- Implementation

	is_valid: BOOLEAN
			-- Is the date and time logical?
		do
			Result := Precursor {YMD_TIME} and Precursor {HMS_TIME}
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	duration_anchor: YMDHMS_DURATION
			-- Anchor for features using durations.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		once
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	interval_anchor: YMDHMS_INTERVAL
			-- Anchor for features using intervals.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		once
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

end
