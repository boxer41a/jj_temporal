note
	description: "[
			Constants for use with HMS_TIME, HMS_DURATION, and HMS_INTERVAL.
		]"
	date: "24 Aug 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"


class
	HMS_CONSTANTS

feature -- Access

	One_second: HMS_DURATION
		once
			create  Result.set (0, 0, 1)
		end

	One_minute: HMS_DURATION
		once
			create  Result.set (0, 1, 0)
		end

	One_hour: HMS_DURATION
		once
			create  Result.set (1, 0, 0)
		end

end -- class HMS_CONSTANTS
