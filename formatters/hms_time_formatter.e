note
	description: "[
		Utility class for converting {HMS_TIME}'s to and from
		strings based on a selected `format'.  While the string given
		by feature `to_string' is set based on the format, the parsing
		of a string to a duration in feature `to_hms_time' is more
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
	HMS_TIME_FORMATTER

inherit

	ANY
		redefine
			default_create
		end

create
	default_create

feature -- Initialization

	default_create
		do
			set_separator (":")
			hide_seconds
			set_12_hour
		end

feature -- Element change

	set_separator (a_string: STRING)
		require
			separator_exists: a_string /= Void
		do
			separator := a_string
		end

	set_12_hour
		do
			is_12_hour := True
		end

	set_24_hour
		do
			is_12_hour := False
		end

	show_seconds
		do
			is_seconds_shown := True
		end

	hide_seconds
		do
			is_seconds_shown := False
		end

feature -- Access

	separator: STRING

	hour_string (a_time: like time_anchor): STRING
		require
			time_exists: a_time /= Void
		local
			h: INTEGER
		do
			h := a_time.hour
			if is_12_hour and then h >= 12 then
				h := h - 12
			end
			if is_12_hour and then h = 0 then
				h := 12
			end
			create Result.make(2)
			if h < 10 then
				Result.append ("0")
			end
			Result.append_integer (h)
		end

	minute_string (a_time: like time_anchor): STRING
		require
			time_exists: a_time /= Void
		do
			create Result.make(2)
			if a_time.minute < 10 then
				Result.append ("0")
			end
			Result.append_integer (a_time.minute)
		end

	second_string (a_time: like time_anchor): STRING
		require
			time_exists: a_time /= Void
		do
			create Result.make(2)
			if a_time.second < 10 then
				Result.append ("0")
			end
			Result.append_integer (a_time.second)
		end

	am_pm_string (a_time: like time_anchor): STRING
		require
			time_exists: a_time /= Void
		do
			create Result.make (3)
			if a_time.hour >= 12 then
				Result.append (" PM")
			else
				Result.append (" AM")
			end
		end

	to_string (a_time: like time_anchor): STRING
			-- the whole {HMS_TIME} as a string
		require
			time_exists: a_time /= Void
   		do
			create Result.make (20)
			Result.append (hour_string (a_time))
			Result.append (separator)
			Result.append (minute_string (a_time))
			if is_seconds_shown then
				Result.append (separator)
				Result.append (second_string (a_time))
			end
			if is_12_hour then
				Result.append (am_pm_string (a_time))
			end
		end

feature -- Status report

	is_12_hour: BOOLEAN

	is_seconds_shown: BOOLEAN

feature -- Query

	is_valid_time_string (a_time: STRING): BOOLEAN
		require
			string_exists: a_time /= Void
		do
			-- parse the string
		end

	is_index_in_hour_string (a_time: like time_anchor; a_index: INTEGER): BOOLEAN
		require
			time_exists: a_time /= Void
--			index_large_enough: a_index >= 1
		local
			s, hs: STRING
			i: INTEGER
		do
			s := to_string (a_time)
			hs := hour_string (a_time)
			i := s.substring_index (hs, 1)
			if i > 0 then
				Result := a_index >= i and a_index <= i + hs.count-1
			end
		end

	is_index_in_minute_string (a_time: like time_anchor; a_index: INTEGER): BOOLEAN
		require
			time_exists: a_time /= Void
--			index_large_enough: a_index >= 1
		local
			s, ms: STRING
			i: INTEGER
		do
			s := to_string (a_time)
			ms := minute_string (a_time)
			i := s.substring_index (ms, 1)
			if i > 0 then
				Result := a_index >= i and a_index <= i + ms.count-1
			end
		end

	is_index_in_second_string (a_time: like time_anchor; a_index: INTEGER): BOOLEAN
		require
			time_exists: a_time /= Void
--			index_large_enough: a_index >= 1
		local
			s, ss: STRING
			i: INTEGER
		do
			s := to_string (a_time)
			ss := hour_string (a_time)
			i := s.substring_index (ss, 1)
			if i > 0 then
				Result := a_index >= i and a_index <= i + ss.count-1
			end
		end

	is_index_in_am_pm_string (a_time: like time_anchor; a_index: INTEGER): BOOLEAN
		require
			time_exists: a_time /= Void
--			index_large_enough: a_index >= 1
		local
			s, ss: STRING
			i: INTEGER
		do
			s := to_string (a_time)
			ss := am_pm_string (a_time)
			i := s.substring_index (ss, 1)
			if i > 0 then
				Result := a_index >= i and a_index <= i + ss.count-1
			end
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	time_anchor: HMS_TIME
			-- Not to be called; just used to anchor types.
		require
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because gives no info; simply used as anchor.
			end
		end

feature {NONE} -- Implementation

	hms_parse (a_string: STRING)
		do
		end


end


