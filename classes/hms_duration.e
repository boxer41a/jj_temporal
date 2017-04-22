note
	description:  "[
		A duration of time represented by hours, minutes, and seconds.
		]"
	names: "duration, time_duration"
	date: "1999/01/01";  updated: "14 Aug 04"
	date: "1 Jan 99"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	HMS_DURATION

inherit

	ABSTRACT_DURATION

create
	default_create,
	set,
	set_fine

feature -- Access

	as_string: STRING_8
			-- The time represented as a string.
		do
			Result := hours.out + ":" + minutes.out + ":" + seconds.out + "." + milliseconds.out
		end

	hours: INTEGER
			-- The number of hours in this DURATION

	minutes: INTEGER
			-- The number of minutes in this DURATION

	seconds: INTEGER
			-- The number of seconds in this DURATION

	milliseconds: INTEGER
			-- The number of milli-seconds in this DURATION

	as_hours: DOUBLE
			-- Length of this duration in hours.
		do
			Result := hours + minutes / 60 + seconds / 3600 + milliseconds / 3600000
		end

	as_minutes: DOUBLE
			-- Length of this duration in minutes.
		do
			Result := hours * 60 + minutes + seconds / 60 + milliseconds / 60000
		end

	as_seconds: DOUBLE
			-- Length of this duration in seconds.
		do
			Result := hours * 3600 + minutes * 60 + seconds + milliseconds / 1000
		end

	as_milliseconds: DOUBLE
			-- Length of this duration in milliseconds
		do
			Result := hours * 3600000 + minutes * 60000 + seconds * 1000 + milliseconds
		end

	one: like Current
			-- Neutral element for '*' and '/'.
		do
			create Result.set_fine (1, 1, 1, 1)
		ensure then
			result_hours_is_one: Result.hours = 1
			result_minutes_is_one: Result.minutes = 1
			result_seconds_is_one: Result.seconds = 1
			result_millisecons_is_one: Result.milliseconds = 1
		end

	zero: like Current
			-- Neutral element for '+' and '-'.
		do
			create Result
		ensure then
			result_hours_is_zero: Result.hours = 0
			result_minutes_is_zero: Result.minutes = 0
			result_seconds_is_zero: Result.seconds = 0
			result_milliseconds_is_zero: Result.milliseconds = 0
		end

	percent_of (other: like Current): DOUBLE
			-- What percent of other in length is this one?
		do
				-- Used minutes because it seemed reasonable accuracy.
			Result := as_minutes / other.as_minutes
		end

feature -- Element change

	set_zero
			-- Make current have zero length.
		do
			set_fine (0, 0, 0, 0)
		end

	set (a_hours, a_minutes, a_seconds: INTEGER)
			-- Change the hours, minutes, and seconds to these values
			-- and set milliseconds to zero.
		do
			set_fine (a_hours, a_minutes, a_seconds, 0)
		ensure
			hours_set: hours = a_hours
			minutes_set: minutes = a_minutes
			seconds_set: seconds = a_seconds
			milliseconds_zero: milliseconds = 0
		end

	set_fine (a_hours, a_minutes, a_seconds, a_milliseconds: INTEGER)
			-- Change `hours', `minutes', `seconds', and `milliseconds'
		do
			hours := a_hours
			minutes := a_minutes
			seconds := a_seconds
			milliseconds := a_milliseconds
		ensure
			hours_set: hours = a_hours
			minutes_set: minutes = a_minutes
			seconds_set: seconds = a_seconds
			milliseconds_set: milliseconds = a_milliseconds
		end

	set_hours (a_hours: INTEGER)
			-- Change hours
		do
			hours := a_hours
		ensure
			hours_set: hours = a_hours
		end

	set_minutes (a_minutes: INTEGER)
			-- change minutes
		do
			minutes := a_minutes
		ensure
			minutes_set: minutes = a_minutes
		end

	set_seconds (a_seconds: INTEGER)
			-- Change seconds
		do
			seconds := a_seconds
		ensure
			seconds_set: seconds = a_seconds
		end

	negate
			-- Reverses the sign for hours, minutes, and seconds.
		do
			hours := -hours
			minutes := -minutes
			seconds := -seconds
			milliseconds := -milliseconds
		ensure then
			hours_negated: -hours = old hours
			minutes_negated: -minutes = old minutes
			seconds_negated: -seconds = old seconds
			milliseconds_negated: milliseconds = -milliseconds
		end

	normalize
			-- Convert to standard format:  "61 minutes" becomes "1 hour, 1 minute".
		do
-- Fix me !!!  for negatives...
			seconds := seconds + milliseconds // 999
			milliseconds := milliseconds \\ 999
			minutes := minutes + seconds // 60
			seconds := seconds \\ 60
			hours := hours + minutes // 60
			minutes := minutes \\ 60
		end

	add (other: like Current)
			-- Add 'other'.  Does not 'normalize'.
		do
			hours := hours + other.hours
			minutes := minutes + other.minutes
			seconds := seconds + other.seconds
			milliseconds := milliseconds + other.milliseconds
		ensure then
			hours_added: hours = old hours + other.hours
			minutes_added: minutes = old minutes + other.minutes
			seconds_added: seconds = old seconds + other.seconds
			milliseconds_added: milliseconds = old milliseconds + other.milliseconds
		end

	sub (other: like Current)
			-- Subtract 'other'.  Does not 'normalize'.
		do
			hours := hours - other.hours
			minutes := minutes - other.minutes
			seconds := seconds - other.seconds
			milliseconds := milliseconds - other.milliseconds
		ensure then
			hours_subbed: hours = old hours - other.hours
			minutes_subbed: minutes = old minutes - other.minutes
			seconds_subbed: seconds = old seconds - other.seconds
			milliseconds_subbed: milliseconds = old milliseconds - other.milliseconds
		end

	multiply (r: DOUBLE)
			-- Multiply by a factor of 'r'.
			-- Result is normalized.
		local
			v: DOUBLE
			fract: DOUBLE
		do
				-- Multiply `hours'
			v := hours * r
			hours := v.floor
			fract := v - hours
				-- Multiply `minutes' and add fractional of hour
			v := minutes * r + 60 * fract
			minutes := v.floor
			fract := v - minutes
				-- Mulitply `seconds' and add fractional minute
			v := seconds * r + 60 * fract
			seconds := v.floor
			fract := v - seconds
				-- Multiply `milliseconds' and add fractional second
			v := milliseconds * r + 1000 * fract
			milliseconds := v.rounded
				-- Normalize
			normalize
		end

	divide (r: DOUBLE)
			-- Divide by 'r'.
			-- Result is normalized.
		do
			set_fine (0, 0, 0, (as_milliseconds / r).rounded)
			normalize
		end

	div (i: INTEGER)
			-- Integer division.
			-- Result is normalized.
		do
			set (0, 0, as_seconds.truncated_to_integer // i)
			normalize
		end

	mod (i: INTEGER)
			-- Modulo.
			-- Result is normalized.
		do
			set (0, 0, as_seconds.truncated_to_integer \\ i)
			normalize
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is 'Current' less than 'other'?
		local
			temp, temp_other: like Current
		do
			temp := twin
			temp_other := other.twin
			temp.normalize
			temp_other.normalize
			Result := (temp.hours < temp_other.hours) or
			   (temp.hours = temp_other.hours and temp.minutes < temp_other.minutes) or
			   (temp.hours = temp_other.hours and temp.minutes = temp_other.minutes and temp.seconds < temp_other.seconds)
		end

end



