note
	description: "[
			Routines used by the {YMD_TIME_PARSER}.  These were put here to
			ease the editting.  The text of class {YMD_TIME_PARSER} is produced
			by "geyacc" from a discription file, so every time a change is
			made "geyacc" must be run (from a dos prompt), the files moved, etc.
				]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class YMD_TIME_PARSER_ROUTINES

inherit

	YMD_TIME_FORMAT_CONSTANTS
		undefine
			default_create
		end

	YMD_TIME_SCANNER_ROUTINES

feature -- Access

	format: INTEGER
		-- How the date should appear (i.e. "dd mmm yyyy", "mm/dd/yy", etc

feature -- Element change

	set_format (a_format: INTEGER)
			-- Change `format'
		require
			valid_format: is_valid_format (a_format)
		do
			format := a_format
		ensure
			format_was_set: format = a_format
		end

feature {NONE} -- Implementation

	process_ambiguous_day (a_possible_day, a_month, a_year: INTEGER): detachable YMD_TIME
			-- Return a date if `a_possible_day' is valid for the know values of
			-- `a_month' and `a_year'; void otherwise.
		require
			valid_month: a_month >= 1 and a_month <= 12
			valid_year: a_year /= 0
		local
			d: YMD_TIME
		do
			create d.set (a_year, a_month, 1)
			if a_possible_day >= 1 and a_possible_day <= d.last_day_of_month then
				create Result.set (a_year, a_month, a_possible_day)
			end
		end

	process_ambiguous_day_month (a_possible_day, a_possible_month, a_year: INTEGER): YMD_TIME
			-- Only the year is known; determine which of the other two values is
			-- the month and which is the day.
		require
			valid_year: a_year /= 0
			unknown_day_from_scanner: a_possible_day <= 12
			unknown_month_from_scanner: a_possible_month <= 12
		do
			create Result.set (a_year, a_possible_month, a_possible_day)
		end

	process_ambiguous_day_year (a_possible_day, a_month, a_possible_year: INTEGER): YMD_TIME
			-- Only the month is know for sure.
		require
			valid_month: a_month >= 1 and a_month <= 12
			unknown_day_from_scanner: a_possible_day <= 12
			unknown_year_from_scanner: a_possible_year <= 12
		do
			create Result.set (a_possible_day, a_month, a_possible_year)
		end

	process_unspecified (a_day, a_month, a_year: INTEGER): YMD_TIME
			-- One of `a_day' or `a_year' was not specified in the scanned string.
			-- The unspecified one will be 0.
		require
			one_zero: a_day = 0 or a_year = 0
			valid_month: a_month >= 1 and a_month <= 12
		local
			d: YMD_TIME
		do
			if a_day = 0 then
				create Result.set (a_year, a_month, 1)
			else
				create d.set_now
				create Result.set_now
				Result.set_day (a_day)
				Result.set_month (a_month)
				if Result < d then
					Result.set_year (Result.year + 1)
				end
			end
		end

	process_three_numbers (int_1, int_2, int_3: INTEGER): YMD_TIME
			-- Scanner encountered a three-integer date and was unable to determine
			-- from the context what any of them mean.
		require
			int_1_is_number: int_1 >= 1 and int_1 <= 31
			int_2_is_number: int_2 >= 1 and int_2 <= 31
			int_3_is_number: int_3 >= 1 and int_3 <= 31
		do

			create Result.set (int_1, int_2, int_3)
		end

	process_two_numbers (int_1, int_2: INTEGER): YMD_TIME
			-- Scanner only found 2 numbers and unknow what they represent.
		require
			int_1_is_number: int_1 >= 1 and int_1 <= 31
			int_2_is_number: int_2 >= 1 and int_2 <= 31
		do
			create Result.set_now
			Result.set_day (int_1)
			Result.set_month (int_2)
		end

invariant

	valid_ymd_time_format: is_valid_format (format)

end -- Class YMD_TIME_PARSER_ROUTINES
