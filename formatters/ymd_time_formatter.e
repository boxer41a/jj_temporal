note
	description: "[
		Utility class for converting {YMD_TIME}'s (i.e. dates) to and from
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
	YMD_TIME_FORMATTER

inherit

	YMD_TIME_FORMAT_CONSTANTS
		redefine
			default_create
		end

create
	default_create

feature -- Initialization

	default_create
			-- Create an instance to parse dates in "dd mmm yy" format.
		do
			set_separator (" ")
		end

feature -- Access

	separator: STRING
			-- The character (or string) placed between the day, month, year, etc.

	to_ymd_time (a_string: STRING): like time_anchor
			-- Parse `a_string'
		require
			string_exists: a_string /= Void
			is_string_valid: is_valid (a_string)
		do
			Result := parsed (a_string)
		ensure
			result_exists: Result /= Void
		end

	to_string (a_ymd_time: like time_anchor): STRING
			-- The complete string representation of `a_ymd_time'.
		require
			ymd_time_exists: a_ymd_time /= Void
   		do
			create Result.make (20)
			inspect format
				when Day_month_year then
					if is_weekday_included then
						Result.append (weekday_string (a_ymd_time))
						Result.append (", ")
					end
					Result.append (day_string (a_ymd_time))
					Result.append (separator)
					Result.append (month_string (a_ymd_time))
					Result.append (separator)
					Result.append (year_string (a_ymd_time))
				when Year_month_day then
				when Month_day_year then
				when Month_year then
				when Day_month then
			else
				check
					should_not_happen: False
						-- because format must be one of these
				end
			end
		end

	year_string (a_ymd_time: like time_anchor): STRING
			-- The string representation of `year' feature of `a_ymd_time'.
			-- Will be shortened to two characters if `is_short_format'.
		do
			create Result.make(4)
			Result.append_integer (a_ymd_time.year)
			if is_short_format then
				if a_ymd_time.year < 10 then
					Result.keep_tail (1)
					if is_zero_padded then
						Result.prepend ("0")
					end
				else
					Result.keep_tail (2)
				end
			else
				if is_zero_padded then
					if a_ymd_time.year < 10 then
						Result.prepend ("000")
					elseif a_ymd_time.year < 100 then
						Result.prepend ("00")
					elseif a_ymd_time.year < 1000 then
						Result.prepend ("0")
					end
				end
			end
		ensure
			valid_length_if_short: is_short_format implies Result.count <= 2
		end

	month_string (a_ymd_time: like time_anchor): STRING
			-- The string representation of `month' feature of `a_ymd_time'.
		require
			ymd_time_exists: a_ymd_time /= Void
		do
			create Result.make (10)
			if is_month_numeric then
				if is_zero_padded and a_ymd_time.month < 10 then
					Result.append ("0")
				end
				Result.append_integer (a_ymd_time.month)
			else
				if is_short_format then
					Result.append (months_text.i_th (a_ymd_time.month))
				else
					Result.append (long_months_text.i_th (a_ymd_time.month))
				end
			end
		end

	day_string (a_ymd_time: like time_anchor): STRING
			-- The string representation of `day' feature of `a_ymd_time'.
		require
			ymd_time_exists: a_ymd_time /= Void
		do
			create Result.make (2)
			if is_zero_padded and a_ymd_time.day < 10 then
				Result.append ("0")
			end
			Result.append_integer (a_ymd_time.day)
		end

	weekday_string (a_ymd_time: like time_anchor): STRING
			-- The string repesentation of the `weekday' of `a_ymd_time'.
			-- (i.e. "Sunday", "Monday, etc. or "Sun", "Mon", etc.
		require
			ymd_time_exists: a_ymd_time /= Void
		do
			create Result.make (15)
			inspect a_ymd_time.weekday
				when 1 then Result.append ("Sunday")
				when 2 then Result.append ("Monday")
				when 3 then Result.append ("Tuesday")
				when 4 then Result.append ("Wednesday")
				when 5 then Result.append ("Thursday")
				when 6 then Result.append ("Friday")
				when 7 then Result.append ("Saturday")
			else
				check
					should_not_happen: False
						-- because `weekday' ranges from 1 to 7.
				end
			end
			if is_short_format then
				Result.keep_head (3)
			end
		end

feature -- Element change

	set_separator (a_string: STRING)
			-- Set `separator' to `a_string'.
		require
			separator_exists: a_string /= Void
		do
			separator := a_string
		ensure
			seperator_set: separator = a_string
		end

	set_format (a_format: INTEGER)
			-- Change `format'.
			-- The values are in YMD_TIME_FORMAT_CONSTANTS
		require
			valid_format: is_valid_format (a_format)
		do
			format := a_format
		end

	set_show_weekday
			-- Include the day of the week in the output string.
		do
			is_weekday_included := True
		end

	set_hide_weekday
			-- Do not include the day of the week in the output string.
		do
			is_weekday_included := False
		end

	set_format_short
			-- Abriviate the `month_string' (if shown as text) to three
			-- characters and shorten the year to two digits.
		do
			is_short_format := True
		end

	set_format_long
			-- Show the `month_string' (if shown as text) to the complete
			-- (unabriviated) word and show the year as four digits.
		do
			is_short_format := False
		end

	set_month_numeric
			-- Make the month appear as digits, not text.
		do
			is_month_numeric := True
		ensure
			showing_month_as_digits: is_month_numeric
		end

	set_month_text
			-- Make the month appear as text.
			-- It may be full text or abbriviated depending on `is_format_short'.
		do
			is_month_numeric := False
		ensure
			showing_month_as_text: not is_month_numeric
		end

	set_pad_zeros
			-- Make sure the `day_string', `year_string', and `month_string' (when
			-- `is_month_numeric') are padded with leading zeros when necessary.
			-- For example, in numeric form "9 Jan 2004" may be shown as "09/01/04".
		do
			is_zero_padded := True
		ensure
			zero_padding_set: is_zero_padded
		end

	set_hide_zeros
			-- Do not pad numeric values with leading zeros.
		do
			is_zero_padded := False
		ensure
			not_padded: not is_zero_padded
		end

feature -- Basic operations

	save_format
			-- Save the `format' for restoration later.
		do
			saved := format
		ensure
			format_saved: saved = format
		end

	restore_format
			-- Reset `format' to the value `saved' by a call to `save_format'.
		do
			format := saved
		ensure
			format_restored: format = saved
		end

feature -- Query

	is_valid (a_string: STRING): BOOLEAN
			-- Is `a_string' convertable to a date?
		require
			string_exists: a_string /= Void
		do
			Result := parsed (a_string) /= Void
		ensure
			definition: Result implies parsed (a_string) /= Void
		end

	is_weekday_included: BOOLEAN
			-- Is the day of week (ie "Monday") in ymd_time string.

	is_short_format: BOOLEAN
			-- Is the year two digits instead of four and
			-- is the month abriviated?

	is_month_numeric: BOOLEAN
			-- Is the `month_string' shown as digits?  (As opposed to a
			-- textual representation such as "January".)

	is_zero_padded: BOOLEAN
			-- Are digital values to be padded with leading zero's if
			-- shorter than normal?

	is_index_in_day_string (a_ymd_time: like time_anchor; a_index: INTEGER): BOOLEAN
		require
			ymd_time_exists: a_ymd_time /= Void
--			index_large_enough: a_index >= 1
		local
			s, ds: STRING
			i: INTEGER
		do
			s := to_string (a_ymd_time)
			ds := day_string (a_ymd_time)
			i := s.substring_index (ds, 1)
			if i > 0 then
				Result := a_index >= i and a_index <= i + ds.count-1
			end
		end

	is_index_in_month_string (a_ymd_time: like time_anchor; a_index: INTEGER): BOOLEAN
		require
			ymd_time_exists: a_ymd_time /= Void
		local
			s, ms: STRING
			i: INTEGER
		do
			s := to_string (a_ymd_time)
			ms := month_string (a_ymd_time)
			i := s.substring_index (ms, 1)
			if i > 0 then
				Result := a_index >= i and a_index <= i + ms.count-1
			end
		end

	is_index_in_year_string (a_ymd_time: like time_anchor; a_index: INTEGER): BOOLEAN
		local
			s, ys: STRING
			i: INTEGER
		do
			s := to_string (a_ymd_time)
			ys := year_string (a_ymd_time)
			i := s.substring_index (ys, 1)
			if i > 0 then
				Result := a_index >= i and a_index <= i + ys.count-1
			end
		end

	is_index_in_weekday_string (a_ymd_time: like time_anchor; a_index: INTEGER): BOOLEAN
		local
			s, wds: STRING
			i: INTEGER
		do
			s := to_string (a_ymd_time)
			wds := weekday_string (a_ymd_time)
			i := s.substring_index (wds, 1)
			if i > 0 then
				Result := a_index >= i and a_index <= i + wds.count-1
			end
		end

feature {NONE} -- Implementation

	parsed (a_string: STRING): like time_anchor
			-- Attemp to convert `a_string' to a {YMD_TIME}, returning
			-- Void if unable.
		require
			string_exists: a_string /= Void
			string_has_length: a_string.count >= 1
		local
			p: YMD_TIME_PARSER
		do
			create p
--			p.set_format (format)
--			p.parse_string (a_string)
--			Result := p.last_value
			check
				fix_me:  False then
			end
		end

	format: INTEGER

	saved: INTEGER
			-- used to save the format.

feature {NONE} -- Anchors (for covariant redefinitions)

	time_anchor: YMD_TIME
			-- Not to be called; just used to anchor types.
		require
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because gives no info; simply used as anchor.
			end
		end

invariant

	valid_ymd_time_format: is_valid_format (format)

end


