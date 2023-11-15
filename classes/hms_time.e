note
	description:  "[
			An exact point of time as on a clock.  An
			Hour, Minute, Second time (ie. a time).
		]"
	names: "time"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	HMS_TIME

inherit

	ABSTRACT_TIME
		rename
			as_integer as as_seconds
		redefine
			default_create,
			is_valid,
			duration_anchor,
			interval_anchor
		end

create
	default_create,
	set_now,
	set_now_utc,
	set_now_fine,
	set_now_utc_fine,
	set,
	set_fine,
	from_seconds,
	from_string

feature {NONE} -- Initialization

	default_create
			-- Create an instance with time 00:00:00 (i.e. midnight).
		do
		end

feature -- Access

	hour: INTEGER
			-- Hour part of time.

	minute: INTEGER
			-- Minute part of time.

	second: INTEGER
			-- Second part of time.

	millisecond: INTEGER
			-- Millisecond part of the time.

	overflow: INTEGER
			-- Number of days after a normalize (49 hours gives 2 days overflow).

	as_string: STRING
			-- The time represented as a string with no seperator characters, such
			-- as ":", "-", or "/".  The time 23:59:59.999 becomes "235959.999"
		do
			create Result.make (10)
			if not (hour >= 10) then
				Result.append ("0")
			end
			Result.append (hour.out)
			if not (minute >= 10) then
				Result.append ("0")
			end
			Result.append (minute.out)
			if not (second >= 10) then
				Result.append ("0")
			end
			Result.append (second.out)
			Result.append (".")
			if not (millisecond >= 100) then
				Result.append ("0")
			end
			if not (millisecond >= 10) then
				Result.append ("0")
			end
			Result.append (millisecond.out)
		end

	as_seconds: INTEGER
			-- The number of seconds from midnight to the current time.
			-- `Millisecond' is rounded.
		do
			Result := hour * 60 * 60 + minute * 60 + second + (millisecond / 1000).rounded
		end

feature -- Element Change

	from_string (a_string: STRING)
			-- Change Current to the time represented by `a_string'.
			-- It must be in the format as provided by `as_string'.
		local
			h, m, s, mil: INTEGER
		do
			h := a_string.substring (1, 2).to_integer
			m := a_string.substring (3, 4).to_integer
			s := a_string.substring (5, 6).to_integer
			mil := a_string.substring (8, 10).to_integer
			set_fine (h, m, s, mil)
		end

	from_seconds (a_seconds: INTEGER)
			-- Initialize as `a_seconds' from midnight.
		do
			set (0, 0, 0)
			add_seconds (a_seconds)
		end

	set_now
			-- Set current time according to timezone, setting `millisecond' to zero.
			-- This was copied from ISE's TIME class with minor changes.
		do
			C_date.update
			set_fine (C_date.hour_now, C_date.minute_now, C_date.second_now, 0)
		end

	set_now_fine
			-- Set current time according to timezone, including milli-seconds.
		do
			C_date.update
			set_fine (C_date.hour_now, C_date.minute_now, C_date.second_now, C_date.millisecond_now)
		end

	set_now_utc
			-- Set the current object to today's date in utc format.
			-- The `millisecond' is set to zero.
			-- This was copied from ISE's TIME class with minor changes.
		do
			C_date.update
			set (C_date.hour_now, C_date.minute_now, C_date.second_now)
		end

	set_now_utc_fine
			-- Set the current object to today's date in utc format, including `millisecond'.
			-- This was copied from ISE's TIME class with minor changes.
		do
			C_date.update
			set_fine (C_date.hour_now, C_date.minute_now, C_date.second_now, C_date.millisecond_now)
		end

	set (h, m, s: INTEGER)
			-- Change the hour, minute, and second.
			-- Set `millisecond' to 0.
		require
			hour_valid: 0 <= h and h <= 23;
			minute_valid: 0 <= m and m <= 59;
			second_valid: 0 <= s and s <= 59
		do
			set_fine (h, m, s, 0)
		ensure
			hour_assigned: hour = h
			minute_assigned: minute = m
			second_assigned: second = s
			millisecond_assigned: millisecond = 0
		end

	set_fine (h, m, s, mil: INTEGER)
			-- Change the hour, minute, and second
		require
			hour_valid: 0 <= h and h <= 23
			minute_valid: 0 <= m and m <= 59
			second_valid: 0 <= s and s <= 59
			millisecond_valid: 0 <= mil and mil <= 999999
		do
			hour := h;
			minute := m;
			second := s;
			millisecond := mil
		ensure
			hour_assigned: hour = h
			minute_assigned: minute = m
			second_assigned: second = s
			millisecond_assigned: millisecond = mil
		end

	set_hour (a_hour: INTEGER)
			-- Change the `hour'.
		require
			hour_valid: 0 <= a_hour and a_hour <= 23;
		do
			hour := a_hour
		ensure
			hour_assigned: hour = a_hour
		end

	set_minute (a_minute: INTEGER)
			-- Change the `minute'.
		require
			minute_valid: 0 <= a_minute and a_minute <= 59;
		do
			minute := a_minute
		ensure
			minute_assigned: minute = a_minute
		end

	set_second (a_second: INTEGER)
			-- Change the second.
		require
			second_valid: 0 <= a_second and a_second <= 59
		do
			second := a_second
		ensure
			second_assigned: second = a_second
		end

	set_millisecond (a_millisecond: INTEGER)
			-- Change the `millisecond'
		require
			valid_millisecond: 0 <= a_millisecond and a_millisecond <= 999
		do
			millisecond := a_millisecond
		ensure
			millisecond_assigned: millisecond = a_millisecond
		end

	from_integer (a_integer: INTEGER)
			-- Change Current to the time represented by `a_integer'.
			-- `A_compact_time' must represent a date that is not BC.
		do
-- Fix me !!!			
		end

	clear_overflow
			-- Remove the `overflow' condition by seting overflow to 0.
			-- (Overflows occur when `add_duration' causes the time to be past 23:59:59.999)
		do
			overflow := 0
		end

	truncate_to_hours
			-- Reset "to the hour" (set minutes and seconds to 0).
		do
			set_fine (hour, 0, 0, 0)
		ensure
			hour_unchanged: hour = old hour
			minute_zero: minute = 0
			second_zero: second = 0
			millisecond_zero: millisecond = 0
		end

	truncate_to_minutes
			-- Reset "to the minute" (i.e. set seconds to 0.)
		do
			set_fine (hour, minute, 0, 0)
		ensure
			hour_unchanged: hour = old hour
			minute_unchanged: minute = old minute
			second_zero: second = 0
			millisecond_zero: millisecond = 0
		end

	truncate_to_seconds
			-- Set the `millisecond' to zero.
			-- Use when `millisecond' portion is to be ignored.
		do
			set_millisecond (0)
		ensure
			hour_unchanged: hour = old hour
			minute_unchanged: minute = old minute
			second_unchaged: second = old second
			millisecond_zero: millisecond = 0
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Does this time come before 'other'?
		require else
			other_time_not_void: other /= Void
		do
			Result :=  hour < other.hour or else
				(hour = other.hour) and (minute < other.minute) or else
				(hour = other.hour) and (minute = other.minute) and (second < other.second) or else
				(hour = other.hour) and (minute = other.minute) and (second = other.second) and (millisecond < other.millisecond)
		ensure then
--			definition:  Result = (hour < other.hour) or else
--				(hour = other.hour) and (minute < other.minute) or else
--				(hour = other.hour) and (minute = other.minute) and (second < other.second) or else
--				(hour = other.hour) and (minute = other.minute) and (second = other.second) and (millisecond < other.millisecond)
		end


feature -- Basic operations

	add_duration (a_duration: like Duration_anchor)
			-- Add a length of time (in hours, minutes, and seconds) to the time.
		do
--			hour := hour + a_duration.hours
--			minute := minute + a_duration.minutes
--			second := second + a_duration.seconds
--			millisecond := millisecond + a_duration.milliseconds
			add_milliseconds (a_duration.milliseconds)
			add_seconds (a_duration.seconds)
			add_minutes (a_duration.minutes)
			add_hours (a_duration.hours)
		end

	add_hours (a_number: INTEGER)
			-- Add `a_number' of hours to the current time
		local
			h: INTEGER
		do
			h := a_number \\ 24
			hour := hour + h
			check
				number_now_even: (a_number - h) \\ 24 = 0
			end
			overflow := (a_number - h) // 24
			if hour < 0 then
				check
					positive_overflow: overflow >= 1
				end
				hour := hour + 24
				overflow := overflow - 1
			end
			if hour >= 24 then
				hour := hour - 24
				overflow := overflow + 1
			end
		end

	add_minutes (a_number: INTEGER)
			-- Add `a_number' of minutes to the current time.
		local
			m: INTEGER
		do
			minute := minute + a_number
			m := minute
			minute := minute \\ 60
			if minute < 0 then
				minute := minute + 60
				add_hours (-1)
			end
			add_hours (m // 60)
		end

	add_seconds (a_number: INTEGER)
			-- Add `a_number' of seconds to the current time.
		local
			s: INTEGER
		do
			second := second + a_number
			s := second
			second := second \\ 60
			if second < 0 then
				second := second + 60
				add_minutes (-1)
			end
			add_minutes (s // 60)
		end

	add_milliseconds (a_number: INTEGER)
			-- Add `a_number' of milliseconds to the current time.
		local
			ms: INTEGER
		do
			millisecond := millisecond + a_number
			ms := millisecond
			millisecond := millisecond \\ 1000
			if millisecond < 0 then
				millisecond := millisecond + 1000
				add_seconds (-1)
			end
			add_seconds (ms // 1000)
		end

feature -- Status report

	is_representable_as_integer: BOOLEAN
			-- Can Current be represented as an integer?
			-- Caveat:  the `milliseconds' will be lost due to rounding in `as_seconds'.
		do
			Result := True
		end

feature -- Querry

	time_between (other: like Current): like Duration_anchor
			-- A length of time in hours, minutes, and seconds
			-- between this time and other.
		local
			larger, smaller: like Current
			h, m, s, ms: INTEGER
		do
			larger := max (other)
			smaller := min (other)
			ms := larger.millisecond - smaller.millisecond
			h := larger.hour - smaller.hour
			m := larger.minute - smaller.minute
			s := larger.second - smaller.second
			if ms < 0 then
				ms := ms + 999
				s := s - 1
			end
			if s < 0 then
				s := s + 60
				m := m - 1
			end
			if m < 0 then
				m := m + 60
				h := h - 1
			end
			create Result.set_fine (h, m, s, ms)
			if Current < other then
				Result.negate
			end
		end

	seconds_between (a_other: like Current): INTEGER
			-- The number of seconds between Current and `other'
		require
			other_exists: a_other /= Void
		local
			larger, smaller: like Current
			h, m, s, ms: INTEGER
		do
			larger := max (a_other)
			smaller := min (a_other)
			ms := larger.millisecond - smaller.millisecond
			h := larger.hour - smaller.hour
			m := larger.minute - smaller.minute
			s := larger.second - smaller.second
			if ms < 0 then
				ms := ms + 999
				s := s - 1
			end
			if s < 0 then
				s := s + 60
				m := m - 1
			end
			if m < 0 then
				m := m + 60
				h := h - 1
			end
			Result := h * 60 * 60 + m * 60 + s
		end

	is_valid_string_representation (a_string: STRING): BOOLEAN
			-- Is `a_string' in a format that can be used to initialize Current?
		local
			hs, ms, ss, mils: STRING
			h, m, s, mil: INTEGER
		do
			if a_string /= Void and then a_string.count = 10 and then equal (a_string.substring (7, 7), ".") then
				hs := a_string.substring (1, 2)
				ms := a_string.substring (3, 4)
				ss := a_string.substring (5, 6)
				mils := a_string.substring (8, 10)
				if hs.is_integer and then ms.is_integer and then ss.is_integer and then mils.is_integer then
					h := hs.to_integer
					m := ms.to_integer
					s := ms.to_integer
					mil := mils.to_integer
					if (h >= 0 and h <= 23) and then
						(m >= 0 and m <= 59) and then
						(s >= 0 and s <= 59) and then
						(mil >= 0 and mil <= 999) then
							Result := True
					end
				end
			end
		end

	is_valid_integer_representation (a_integer: INTEGER): BOOLEAN
			-- Is `a_integer' in range to be converted to a time?
		do
			Result := a_integer >= 0
		end

feature {NONE} -- Implementation

--	normalize is
--			-- convert to a normal time (1 minute, 60 seconds becomes 2 minutes 0 seconds)
--		do
--			second := second + millisecond // 999
--			millisecond := millisecond \\ 999
--			if millisecond < 0 then
--				millisecond := millisecond + 999
--				second := second - 1
--			end
--			minute := minute + second // 60
--			second := second \\ 60
--			if second < 0 then
--				second := second + 60
--				minute := minute - 1
--			end
--			hour := hour + minute // 60
--			minute := minute \\ 60
--			if minute < 0 then
--				minute := minute + 60
--				hour := hour - 1
--			end
--			overflow := hour // 24
--			hour := hour \\ 24
--			if hour < 0 then
--				hour := hour + 24
--				overflow := overflow - 1
--			end
--		end

	is_valid: BOOLEAN
			-- Is time in correct format?
		do
			Result := (0 <= millisecond and millisecond <= 999) and
				(0 <= second and second <= 59) and
				(0 <= minute and minute <= 59) and
				(0 <= hour and hour <= 23)
		ensure then
			valid_result: Result implies
					(0 <= millisecond and millisecond <= 999) and
					(0 <= second and second <= 59) and
					(0 <= minute and minute <= 59) and
					(0 <= hour and hour <= 23)
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	duration_anchor: HMS_DURATION
			-- Anchor for features using durations.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		once
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	interval_anchor: HMS_INTERVAL
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
