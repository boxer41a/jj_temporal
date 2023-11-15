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
		local
			i: INTEGER
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
			create timer_1
			create timer_2
			timer_1.reset
			timer_2.reset

			from i := 1
			until i > 10
			loop
				io.put_string ("i = " + i.out + "%N")
				timer_1.run
				ee.sleep (100)
				timer_1.stop
				timer_2.run
				ee.sleep (1_000_000_000)
				timer_2.stop
				io.put_string ("timer_1.cumulative = " + timer_1.cumulative.as_seconds.out)
				io.new_line
				io.put_string ("timer_2.cumulative = " + timer_2.cumulative.as_seconds.out)
				io.new_line
				i := i + 1
			end
			io.put_string ("timer_1.cumulative = " + timer_1.cumulative.as_seconds.out)
			io.put_string (" %T")
			io.put_string ("timer_2.cumulative = " + timer_2.cumulative.as_seconds.out)
			io.new_line

--			io.put_string ("The formatted date = ")
--			io.put_string (ymd_formatter.to_string (date) + "%N")
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

	timer_1, timer_2: HMS_TIMER

	ee: EXECUTION_ENVIRONMENT
		once
			create Result
		end

end
