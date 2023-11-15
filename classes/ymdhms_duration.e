note
	description:  "[
		Duration of time described in years, months, days,
		hours, minutes, and seconds.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	YMDHMS_DURATION

inherit

	YMD_DURATION
		rename
			set as ymd_set,
			as_string as as_ymd_string
		redefine
			default_create,
			zero, one,
			set_zero,
			as_years, as_months, as_days,
			add, sub, multiply, divide, div, mod, negate, percent_of,
			is_less,
			normalize
		end

	HMS_DURATION
		rename
			set as hms_set,
			as_string as as_hms_string
		redefine
			default_create,
			zero, one,
			set_zero,
			as_hours, as_minutes, as_seconds,
			add, sub, multiply, divide, div, mod, negate, percent_of,
			is_less,
			normalize
		select
			as_hms_string
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			Precursor {YMD_DURATION}
			Precursor {HMS_DURATION}
		end

feature -- Access

	as_string: STRING_8
			-- The time represented as a string.
		do
			Result := as_ymd_string + ":" + as_hms_string
		end

	zero: like Current
			-- Neutral element for "+" and "-"
		do
			create Result
		end

	one: like Current
			-- Neutral element for "*" and "/"
		do
			create Result
			Result.set (1,1,1,1,1,1)
		end

	as_years: DOUBLE
			-- Length of duration in years.
		do
			Result := years + months / 12 + days / days_per_year +
					hours / (24 * days_per_year) + minutes / (60 * 24 * days_per_year) +
					seconds / (60 * 60 * 24 * days_per_year)
		end

	as_months: DOUBLE
			-- Length of duration in months.
		do
			Result := years * 12 + months + days / days_per_month +
					hours / hours_per_month + minutes / (60 * hours_per_month) +
					seconds / (60 * 60 * hours_per_month)
		end

	as_days: DOUBLE
			-- Length of duration in days.
		do
			Result := years * days_per_year + months * days_per_month + days +
					hours / 24 + minutes / (24 * 60) + seconds / (24 * 60 * 60)
		end

	as_hours: DOUBLE
			-- Length of this duration in hours.
		do
			Result := (years * days_per_year + months * days_per_month + days) 	-- number of days
						* 24 + hours + minutes / 60 + seconds / 3600
		end

	as_minutes: DOUBLE
			-- Length of this duration in minutes.
		do
			Result := ((years * days_per_year + months * days_per_month + days) 	-- number of days
						* 24 + hours)												-- number of hours
						* 60 + minutes + seconds / 60
		end

	as_seconds: DOUBLE
			-- Length of this duration in seconds.
		do
			Result := (((years * days_per_year + months * days_per_month + days) 	-- number of days
						* 24 + hours)												-- number of hours
						* 60 + minutes)												-- number of minutes
						* 60 + seconds
		end

feature -- Element change

	set (a_year, a_month, a_day, a_hour, a_minute, a_second: INTEGER)
			-- Change years, months, days, hours, minutes, seconds.
		do
			ymd_set (a_year, a_month, a_day)
			hms_set (a_hour, a_minute, a_second)
		ensure
			years_set: years = a_year
			months_set: months = a_month
			days_set: days = a_day
			hours_set: hours = a_hour
			minutes_set: minutes = a_minute
			seconds_set: seconds = a_second
		end

	set_zero
			-- Make the duration be zero length.
		do
			ymd_set (0, 0, 0)
			set_fine (0, 0, 0, 0)
		end


	negate
			-- Reverse the sign for years, ..., seconds.
		do
			Precursor {YMD_DURATION}
			Precursor {HMS_DURATION}
		end

	normalize
			-- Convert to standard format:  "13 months" becomes "1 year, 1 month".
			-- Month and year length is based on 'days_per_month'.
		do
			Precursor {HMS_DURATION}
			set_days (days + hours // 24)
			set_hours (hours \\ 24)
			Precursor {YMD_DURATION}
		end

	add (other: like Current)
			-- Add other to current.
		do
			Precursor {YMD_DURATION} (other)
			Precursor {HMS_DURATION} (other)
		end

	sub (other: like Current)
			-- Subtract other from current.
		do
			Precursor {YMD_DURATION} (other)
			Precursor {HMS_DURATION} (other)
		end

	multiply (r: DOUBLE)
			-- Multiply by a factor of 'r'.
			-- Result is normalized.
		local
			v: DOUBLE
			fract: DOUBLE
		do
			v := years * r
			years := v.floor
			fract := v - years

			v := months * r + 12 * fract
			months := v.floor
			fract := v - months

			v := days * r + days_per_month * fract
			days := v.floor
			fract := v - days

			v := hours * r + 24 * fract
			hours := v.floor
			fract := v - hours

			v := minutes * r + 60 * fract
			minutes := v.floor
			fract := v - minutes

			v := seconds * r + 60 * fract
			seconds := v.rounded
			normalize
		end

	divide (r: DOUBLE)
			-- Divide by 'r'.
			-- Result is normalized.
		do
			Precursor {HMS_DURATION} (r)	-- calculates based on seconds.
		end

	div (i: INTEGER)
			-- Integer division.
			-- Result is normalized.
		do
			Precursor {HMS_DURATION} (i)	-- calculates based on seconds.
		end

	mod (i: INTEGER)
			-- Modulo.
			-- Result is normalized.
		do
			Precursor {HMS_DURATION} (i)	-- calculates based on seconds.
		end

	percent_of (other: like Current): DOUBLE
			-- What percent of other in length is this one?
		do
			Result := as_days / other.as_days	-- Days seemed reasonable accuracy.
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is this duration shorter than other?
		do
			Result := Precursor {YMD_DURATION} (other) or else
						(years = other.years and then months = other.months and then days = other.days and then
						Precursor {HMS_DURATION} (other))
		end

feature {NONE} -- Implementation

	hours_per_year: DOUBLE
			-- Number of hours in a year.
		do
			Result := days_per_year * 24
		end

	hours_per_month: DOUBLE
			-- Number of hours in a month.
		do
			Result := days_per_month * 24
		end



end -- class YMDHMS_DURATION

