note
	description: "[
			Constants for use with {YMDHMS_TIME}, {YMDHMS_DURATION}, 
			and {YMDHMS_INTERVAL}.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	YMDHMS_DURATION_CONSTANTS

feature -- Access

	One_second: YMDHMS_DURATION
		once
			create  Result
			Result.set (0, 0, 0, 0, 0, 1)
		end

	One_minute: YMDHMS_DURATION
		once
			create  Result
			Result.set (0, 0, 0, 0, 1, 0)
		end

	One_hour: YMDHMS_DURATION
		once
			create  Result
			Result.set (0, 0, 0, 1, 0, 0)
		end

	One_day: YMDHMS_DURATION
		once
			create  Result
			Result.set (0, 0, 1, 0, 0, 0)
		end

	One_week: YMDHMS_DURATION
		once
			create  Result
			Result.set (0, 0, 7, 0, 0, 0)
		end

	One_month: YMDHMS_DURATION
		once
			create  Result
			Result.set (0, 1, 0, 0, 0, 0)
		end

	One_quarter: YMDHMS_DURATION
		once
			create  Result
			Result.set (0, 3, 0, 0, 0, 0)
		end

	One_year: YMDHMS_DURATION
		once
			create  Result
			Result.set (1, 0, 0, 0, 0, 0)
		end

end -- class YMDHMS_DURATION_CONSTANTS
