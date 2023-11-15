note
	description: "[
		Utility class for converting {YMD_DURATION}'s to and from
		strings based on a selected `format'.  While the string given
		by feature `as_string' is set based on the format, the parsing
		of a string to a duration in feature `to_ymd_duration' is more
		relaxed.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	YMD_DURATION_FORMATTER

inherit

	ANY
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			set_separator (", ")
			set_year_month_day
		end

feature -- Access

	separator: STRING

feature -- Element change

	set_separator (a_string: STRING)
		require
			string_exists: a_string /= Void
		do
			separator := a_string
		end

	set_day_month_year
		-- Set format to day-month-year.
		do
			format := dmy
		end

	set_year_month_day
		do
			format := ymd
		end

	set_day_month
		do
			format := dm
		end

	set_month_year
		do
			format := my
		end

feature -- Access

	year_string (a_duration: YMD_DURATION): STRING
		do
			create Result.make(8)
			Result.append_integer (a_duration.years)
			Result.append (" year")
			if a_duration.years /= 1 and a_duration.years /= -1 then
				Result.append ("s")
			end
		end

	month_string (a_duration: YMD_DURATION): STRING
		do
			create Result.make (8)
			Result.append_integer (a_duration.months)
			Result.append (" month")
			if a_duration.months /= 1 and a_duration.months /= -1 then
				Result.append ("s")
			end
		end

	day_string (a_duration: YMD_DURATION): STRING
		do
			create Result.make (8)
			Result.append_integer (a_duration.days)
			Result.append (" day")
			if a_duration.days /= 1 and a_duration.days /= -1 then
				Result.append ("s")
			end
		end

	to_string (a_duration: YMD_DURATION): STRING
			-- the whole duration as a string
   		do
			create Result.make (20)
			Result.append (day_string(a_duration))
			Result.append (separator)
			Result.append (month_string(a_duration))
			Result.append (separator)
			Result.append (year_string(a_duration))
		end

	string_to_duration (a_string: STRING): YMD_DURATION
		-- Parse the string based on the current formatting.
		require
			valid_date_string: is_valid_date_string (a_string)
		do
			check
				fix_me:  False then
			end
		end

feature -- Query

	is_valid_date_string (a_string: STRING): BOOLEAN
		require
			string_exists: a_string /= Void
		do
			-- parse the string
			Result := True
-- !!! temporary
		end

	is_index_in_day_string (a_date: YMD_DURATION; a_index: INTEGER): BOOLEAN
		require
			date_exists: a_date /= Void
--			index_large_enough: a_index >= 1
		local
			s, ds: STRING
			i: INTEGER
		do
			s := to_string (a_date)
			ds := day_string (a_date)
			i := s.substring_index (ds, 1)
			if i > 0 then
				Result := a_index >= i and a_index <= i + ds.count-1
			end
		end

	is_index_in_month_string (a_date: YMD_DURATION; a_index: INTEGER): BOOLEAN
		local
			s, ms: STRING
			i: INTEGER
		do
			s := to_string (a_date)
			ms := month_string (a_date)
			i := s.substring_index (ms, 1)
			if i > 0 then
				Result := a_index >= i and a_index <= i + ms.count-1
			end
		end

	is_index_in_year_string (a_date: YMD_DURATION; a_index: INTEGER): BOOLEAN
		local
			s, ys: STRING
			i: INTEGER
		do
			s := to_string (a_date)
			ys := year_string (a_date)
			i := s.substring_index (ys, 1)
			if i > 0 then
				Result := a_index >= i and a_index <= i + ys.count-1
			end
		end


feature {NONE} -- Implementation

	format: INTEGER

	dmy, ymd, 			-- day-month-year, etc
	dm, my	: INTEGER = unique	-- day-month or month-year only

	dmy_parse (a_string: STRING)
		do
		end


end	-- class YMD_DURATION_FORMATTER


