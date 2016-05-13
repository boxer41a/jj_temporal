note
	description: "[
		Utility class for converting {YMDHMS_DURATION}'s to and from
		strings based on a selected `format'.  While the string given
		by feature `as_string' is set based on the format, the parsing
		of a string to a date in feature `to_ymdhms_duration' is more
		relaxed.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	YMDHMS_DURATION_FORMATTER

inherit

	HMS_DURATION_FORMATTER
		rename
			to_string as time_string,
			set_separator as set_time_separator,
			separator as time_separator,
			string_to_duration as hms_string_to_duration,
			format as hms_format
		redefine
			default_create
		end

	YMD_DURATION_FORMATTER
		rename
			to_string as date_string,
			set_separator as set_date_separator,
			separator as date_separator,
			string_to_duration as ymd_string_to_duration,
			format as ymd_format
		redefine
			default_create
		end

create
	default_create

feature -- Initialization

	default_create
			--
		do
			Precursor {HMS_DURATION_FORMATTER}
			Precursor {YMD_DURATION_FORMATTER}
		end

feature -- Access

	to_string (a_duration: YMDHMS_DURATION): STRING
			-- the whole duration as a string
		require
			duration_exists: a_duration /= Void
		do
			create Result.make (30)
			Result.append (date_string (a_duration))
			Result.append (" ")
			Result.append (time_string (a_duration))
		end

end -- class YMDHMS_DURATION_FORMATTER
