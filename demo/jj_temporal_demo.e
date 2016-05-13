note
	description: "[
			Test objects for temporal cluster.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	JJ_TEMPORAL_DEMO

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			create date
			create time
			create date_time
			io.put_string (date.out)
			io.new_line
			io.new_line
			io.put_string (time.out)
			io.new_line
			io.new_line
			io.put_string (date_time.out)

			create ymd_formatter

			io.put_string ("The formatted date = ")
			io.put_string (ymd_formatter.to_string (date) + "%N")
		end

feature -- Access

	date: YMD_TIME
			-- To test a date

	time: HMS_TIME
			-- To test a time

	date_time: YMDHMS_TIME
			-- To test a date and time

	ymd_formatter: YMD_TIME_FORMATTER
			-- To test the gobo parsers


feature {PERSON} -- Implementation


end
