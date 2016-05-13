note
	description: "[
		Constants describing how {YMD_TIME}'s (dates) should appear.
	]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	YMD_TIME_FORMAT_CONSTANTS

feature -- Assess

	Day_month_year: INTEGER = 0
			-- (e.g. "31 January 2004" or "31/01/04")

	Year_month_day: INTEGER = 1
			-- (e.g. "2004 January 31" or "04/01/31")

	Month_day_year: INTEGER = 2
			-- (e.g. "January 31, 2004" or "01/31/04")

	Day_month: INTEGER = 3
			-- (e.g. "31 January" or "31/01")

	Month_year: INTEGER = 4
			-- (e.g. "January 2004" or "01/04")

	days_text: LINKED_LIST [STRING]
		once
			create Result.make
			Result.extend ("SUN")
			Result.extend ("MON")
			Result.extend ("TUE")
			Result.extend ("WED")
			Result.extend ("THU")
			Result.extend ("FRI")
			Result.extend ("SAT")
			Result.compare_objects
		end

	months_text: LINKED_LIST [STRING]
		once
			create Result.make
			Result.extend ("JAN")
			Result.extend ("FEB")
			Result.extend ("MAR")
			Result.extend ("APR")
			Result.extend ("MAY")
			Result.extend ("JUN")
			Result.extend ("JUL")
			Result.extend ("AUG")
			Result.extend ("SEP")
			Result.extend ("OCT")
			Result.extend ("NOV")
			Result.extend ("DEC")
			Result.compare_objects
		end

	long_days_text: LINKED_LIST [STRING]
		once
			create Result.make
			Result.extend ("SUNDAY")
			Result.extend ("MONDAY")
			Result.extend ("TUESDAY")
			Result.extend ("WEDNESDAY")
			Result.extend ("THURSDAY")
			Result.extend ("FRIDAY")
			Result.extend ("SATURDAY")
			Result.compare_objects
		end

	long_months_text: LINKED_LIST [STRING]
			--
		once
			create Result.make
			Result.extend ("JANUARY")
			Result.extend ("FEBRUARY")
			Result.extend ("MARCH")
			Result.extend ("APRIL")
			Result.extend ("MAY")
			Result.extend ("JUNE")
			Result.extend ("JULY")
			Result.extend ("AUGUST")
			Result.extend ("SEPTEMBER")
			Result.extend ("OCTOBER")
			Result.extend ("NOVEMBER")
			Result.extend ("DECEMBER")
			Result.compare_objects
		end

feature -- Querry

	is_valid_format (a_integer: INTEGER): BOOLEAN
			-- Does `a_integer' represent a valid date format?
		do
			Result := a_integer = Day_month_year or else
					a_integer = Year_month_day or else
					a_integer = Month_day_year or else
					a_integer = Day_month or else
					a_integer = Month_year
		end

	is_month (a_string: STRING): BOOLEAN
			-- Does a_string represent a month?
		do
			Result := months_text.has (a_string.as_upper) or else
						long_months_text.has (a_string.as_upper)
		end

	is_weekday (a_string: STRING): BOOLEAN
			-- Does `a_string' represent a weekday?
		do
			Result := days_text.has (a_string.as_upper) or else
						long_days_text.has (a_string.as_upper)
		end

	get_month (a_month: STRING): INTEGER
			-- Number of the `a_month'
		require
			is_month: is_month (a_month)
		do
			if months_text.has (a_month.as_upper) then
				Result := months_text.index_of (a_month.as_upper, 1)
			else
				Result := long_months_text.index_of (a_month.as_upper, 1)
			end
		end

end
