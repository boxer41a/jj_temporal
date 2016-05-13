note
	description: "[
		Utility class for converting {YMDHMS_TIME}'s (i.e. date/times) to and from
		strings based on a selected `format'.  While the string given
		by feature `as_string' is set based on the format, the parsing
		of a string to a date in feature `to_ymd_time' is more relaxed.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	YMDHMS_TIME_FORMATTER

inherit

	HMS_TIME_FORMATTER
		rename
			set_separator as set_time_separator,
			separator as time_separator
		redefine
			default_create,
			to_string,
			time_anchor
		end

	YMD_TIME_FORMATTER
		rename
			set_separator as set_date_separator,
			separator as date_separator
		redefine
			default_create,
			to_string,
			time_anchor
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			Precursor {HMS_TIME_FORMATTER}
 			Precursor {YMD_TIME_FORMATTER}
		end

feature -- Access

	to_string (a_time: like time_anchor): STRING
			-- the whole date as a string
		do
			create Result.make (30)
			if not is_date_hidden then
				Result.append (Precursor {YMD_TIME_FORMATTER} (a_time))
				Result.append (" ")
			end
			if not is_time_hidden then
				Result.append (Precursor {HMS_TIME_FORMATTER} (a_time))
			end
		end

feature -- Status report

	is_time_hidden: BOOLEAN
			-- Will `to_string' not include the time?

	is_date_hidden: BOOLEAN
			-- Will `to_string' not include the date?

feature -- Status setting

	hide_time
			-- Make `to_string' produce a string showing the date only;
			-- the time portion will not show.
		do
			is_time_hidden := True
			is_date_hidden := False
		ensure
			time_is_hidden: is_time_hidden
			date_is_shown: not is_date_hidden
		end

	hide_date
			-- Make `a_string' produce a string showing the time only;
			-- the date portionn will not show.
		do
			is_date_hidden := True
			is_time_hidden := False
		ensure
			date_is_hidden: is_date_hidden
			time_is_shown: not is_time_hidden
	end

	show_date_and_time
			-- Make `to_string' produce a string showing both the date
			-- portion and the time portion.  This is the default.
		do
			is_date_hidden := False
			is_time_hidden := False
		ensure
			date_is_shown: not is_date_hidden
			time_is_shown: not is_time_hidden
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	time_anchor: YMDHMS_TIME
			-- Not to be called; just used to anchor types.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because gives no info; simply used as anchor.
			end
		end

invariant

	not_both_date_and_time_hidden: not (is_date_hidden and is_time_hidden)

end
