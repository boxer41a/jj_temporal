note
	description: "[
		Utility class for converting {HMS_DURATION}'s to and from
		strings based on a selected `format'.  While the string given
		by feature `as_string' is set based on the format, the parsing
		of a string to a duration in feature `to_hms_duration' is more
		relaxed.
		]"
	date: "18 Feb 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	HMS_DURATION_FORMATTER

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
			set_hour_minute_second
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

	set_hour_minute_second
		-- Set format to day-month-year.
		do
			format := hms
		end

	set_second_minute_hour
		do
			format := smh
		end

	set_hour_minute
		do
			format := hm
		end

	set_minute_hour
		do
			format := mh
		end

feature -- Access

	hour_string (a_duration: HMS_DURATION): STRING
		do
			create Result.make(8)
			Result.append_integer (a_duration.hours)
			Result.append (" hour")
			if a_duration.hours /= 1 and a_duration.hours /= -1 then
				Result.append ("s")
			end
		end

	minute_string (a_duration: HMS_DURATION): STRING
		do
			create Result.make (8)
			Result.append_integer (a_duration.minutes)
			Result.append (" minute")
			if a_duration.minutes /= 1 and a_duration.minutes /= -1 then
				Result.append ("s")
			end
		end

	second_string (a_duration: HMS_DURATION): STRING
		do
			create Result.make (8)
			Result.append_integer (a_duration.seconds)
			Result.append (" second")
			if a_duration.seconds /= 1 and a_duration.seconds /= -1 then
				Result.append ("s")
			end
		end

	to_string (a_duration: HMS_DURATION): STRING
			-- the whole duration as a string
   		do
			create Result.make (20)
			Result.append (hour_string(a_duration))
			Result.append (separator)
			Result.append (minute_string(a_duration))
			Result.append (separator)
			Result.append (second_string(a_duration))
		end

	string_to_duration (a_string: STRING): HMS_DURATION
		-- Parse the string based on the current formatting.
		require
			valid_date_string: is_valid_duration_string (a_string)
		do
			check
				fix_me:  False then
			end
		end

feature -- Query

	is_valid_duration_string (a_string: STRING): BOOLEAN
		require
			string_exists: a_string /= Void
		do
			-- parse the string
			Result := True
-- !!! temporary
		end

	is_index_in_hour_string (a_date: HMS_DURATION; a_index: INTEGER): BOOLEAN
		require
			date_exists: a_date /= Void
--			index_large_enough: a_index >= 1
		local
			s, ds: STRING
			i: INTEGER
		do
			s := to_string (a_date)
			ds := hour_string (a_date)
			i := s.substring_index (ds, 1)
			if i > 0 then
				Result := a_index >= i and a_index <= i + ds.count-1
			end
		end

	is_index_in_minute_string (a_date: HMS_DURATION; a_index: INTEGER): BOOLEAN
		local
			s, ms: STRING
			i: INTEGER
		do
			s := to_string (a_date)
			ms := minute_string (a_date)
			i := s.substring_index (ms, 1)
			if i > 0 then
				Result := a_index >= i and a_index <= i + ms.count-1
			end
		end

	is_index_in_second_string (a_date: HMS_DURATION; a_index: INTEGER): BOOLEAN
		local
			s, ys: STRING
			i: INTEGER
		do
			s := to_string (a_date)
			ys := second_string (a_date)
			i := s.substring_index (ys, 1)
			if i > 0 then
				Result := a_index >= i and a_index <= i + ys.count-1
			end
		end

feature {NONE} -- Implementation

	format: INTEGER

	hms, smh, 			-- hours-minutes-seconds, etc
	hm, mh	: INTEGER = unique	-- hours-minutes only

	hms_parse (a_string: STRING)
		do
		end


end -- class HMS_DURATION_FORMATTER


