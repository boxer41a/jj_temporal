note
	description:  "[
		Duration of time described in years, months, and days.
		]"
	names: "ymd_duration"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	YMD_DURATION

inherit

	ABSTRACT_DURATION
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Create an instance with zero length.
		do
			days_per_month := default_days_per_month
			set (0, 0, 0)
		end

feature -- Access

	as_string: STRING_8
			-- The time represented as a string.
		do
			Result := years.out + ":" + months.out + ":" + days.out
		end

	years: INTEGER
		-- Number of years part.
		-- Does not consider the months or days.

	months: INTEGER
		-- Number of months part.
		-- Does not consider the years or days.

	days: INTEGER
		-- Number of days part.
		-- Does not consider the months or years.

	default_days_per_month: DOUBLE = 30.4375
		-- Default value for 'days_per_month'.
		-- 365.25 days per year divided by 12 months per year.

	days_per_month: DOUBLE
			-- Number of days in a month.  (28?, 29?, 30?, 31?)
			-- Value assumed by class to do calculations involving conversion
			-- from days to months to years.
			-- Default = 30.4375 days / month.

	days_per_year: DOUBLE
			-- Number of days in the year.  Calculated based on 'days_per_month'.
			-- Value assumed by class to do calculations involving conversion
			-- from days to months to years.
			-- Default = 365.25 days / year.
		do
			Result := days_per_month * 12
		end

	as_years: DOUBLE
			-- Length of duration in years.
		do
			Result := years + months / 12 + days / days_per_year
		end

	as_months: DOUBLE
			-- Length of duration in months.
		do
			Result := years * 12 + months + days / days_per_month
		end

	as_days: DOUBLE
			-- Length of duration in days.
		do
			Result := years * days_per_year + months * days_per_month + days
		end

	one: like Current
			-- Neutral element for "*" and "/"
		do
			create Result
			Result.set (1,1,1)
		ensure then
			result_years_is_one: Result.years = 1
			result_months_is_one: Result.months = 1
			result_days_is_one: Result.days = 1
		end

	zero: like Current
			-- Neutral element for "+" and "-"
		do
			create Result
		ensure then
			result_years_is_zero: Result.years = 0
			result_months_is_zero: Result.months = 0
			result_days_is_zero: Result.days = 0
		end

	percent_of (other: like Current): DOUBLE
			-- What percent of other in length is this one?
			-- For example: is current duration at least twice as long as other?
		do
--				Result := as_months / other.as_months	-- Used months because it seemed reasonable accuracy.
				Result := as_days / other.as_days		-- Must use days because of accuracy problems with month length.
		end

	normalized: like Current
			-- A copy of Current in a normalized form.
		do
			Result := twin
			Result.normalize
		end

feature -- Element change

	set_zero
			-- Make Current have zero length.
		do
			set (0, 0, 0)
		end

	set (ys, ms, ds: INTEGER)
			-- Change the length of years, months, and days.
		do
			years := ys
			months := ms
			days := ds
		ensure
			years_set: years = ys
			months_set: months = ms
			days_set: days = ds
		end

	set_years (ys: INTEGER)
			-- Change years
		do
			years := ys
		ensure
			years_set: years = ys
		end

	set_months (ms: INTEGER)
			-- Change months
		do
			months := ms;
		ensure
			months_set: months = ms
		end

	set_days (ds: INTEGER)
			-- Change days
		do
			days := ds
		ensure
			days_set: days = ds
		end

	set_days_per_month (i: DOUBLE)
		-- Change 'days_per_month' (value used in calculations
		-- involving month lenghts).
		require
			in_range: i >= 28 and i <= 31
		do
			days_per_month := i
		ensure
			days_per_month_set: days_per_month = i
		end

feature -- Basic operations

	negate
			-- Reverse the sign on years, months, and days.
		do
			years := -years;
			months := -months;
			days := -days
		ensure then
			years_negated: -years = old years
			months_negated: -months = old months
			days_negated: -days = old days
		end

	normalize
			-- Convert to standard format:  "13 months" becomes "1 year, 1 month".
			-- Month and year length is based on 'days_per_month'.
			-- This feature is hard to define.  For example, is 28 days equal to
			-- one month?  What about 30 days?
			-- This needs to be fixed.
		require
			days_per_month > 0
		local
			m, d: DOUBLE
			dpm: DOUBLE
		do
				-- The check on `days_per_month' was necessary because `<' which calls
				-- this feature must be getting called before the object is fully
				-- initialized, so at that point `days_per_month' is zero; this check
				-- prevents that "floating point exception".
			if days_per_month = 0 then
				dpm := Default_days_per_month
			else
				dpm := days_per_month
			end
			d := days
			m := d / dpm
			months := months + m.truncated_to_integer
			m := m - m.truncated_to_integer
			d := m * dpm
			days := d.truncated_to_integer
--			if (d - days) > 0.5 then
--				days := days + 1	
--				if days > dpm then
--					months := months + 1
--				end
--			end			
			years := years + months // 12
			months := months \\ 12
		end

	add (other: like Current)
			-- Add other to current.
		do
			years := years + other.years;
			months := months + other.months;
			days := days + other.days
		ensure then
			years_added: years = old years + other.years
			months_added: months = old months + other.months
			days_add: days = old days + other.days
		end

	sub (other: like Current)
			-- Subtract other from current.
		do
			years := years - other.years;
			months := months - other.months;
			days := days - other.days
		ensure then
			years_subbed: years = old years - other.years
			months_subbed: months = old months - other.months
			days_subbed: days = old days - other.days
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
			days := v.rounded
			normalize
		end

	divide (r: DOUBLE)
			-- Divide by 'r'.
			-- Result is normalized.
		do
			set (0, 0, (as_days / r).rounded)
			normalize
		end


	div (i: INTEGER)
			-- Integer division.
			-- Result is normalized.
		do
			set (0, 0, (as_days / i).truncated_to_integer)
			normalize
		end

	mod (i: INTEGER)
			-- Modulo of duration with 'i'.
			-- Result is normalized.
		do
			set (0, 0, as_days.truncated_to_integer \\ i)
			normalize
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current shorter than other?
		local
			temp, temp_other: like Current
		do
			temp := twin
			temp_other := other.twin
			temp.normalize
			temp_other.normalize
			Result := (temp.years < temp_other.years) or else
				(temp.years = temp_other.years and temp.months < temp_other.months) or else
				(temp.years = temp_other.years and temp.months = temp_other.months and temp.days < temp_other.days)
		end

invariant

	days_per_month_in_range: days_per_month >= 28 and days_per_month <= 31


end -- class YMD_DURATION

