note
	description: "[
			Constants for use with YMD_TIME, YMD_DURATION, and YMD_INTERVAL.
		]"
	date: "1 Jan 99"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	YMD_CONSTANTS

feature -- Access

	One_day: YMD_DURATION
		once
			create Result
			Result.set (0, 0, 1)
		end

	One_week: YMD_DURATION
		once
			create Result
			Result.set (0, 0, 7)
		end

	One_month: YMD_DURATION
		once
			create Result
			Result.set (0, 1, 0)
		end

	One_quarter: YMD_DURATION
		once
			create Result
			Result.set (0, 3, 0)
		end

	One_year: YMD_DURATION
		once
			create Result
			Result.set (1, 0, 0)
		end

end -- class YMD_CONSTANTS
