note
	description: "[
			Objects which record their creation time.
		]"
	date: "1 Sep 04"
	date: "1 Jan 99"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	TIME_STAMPABLE

inherit

	ANY
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Initialize `Current'.
		do
			create timestamp.set_now_utc_fine
		end

feature -- Access

	id: STRING
			-- Unique (hopefully) object id based on the creation time of the object.
			-- Concatination of Current's `generating_type' and `time_stamp'.
		do
			Result := generating_type + " " + timestamp.as_string
		end

	timestamp: YMDHMS_TIME
			-- Time this object was created

--feature -- Comparison

--	infix "<" (a_other: like Current): BOOLEAN is
--			-- Is Current less than `a_other'?
--		do
--			Result := id < a_other.id
----			Result := timestamp < a_other.timestamp
--		end

invariant

	time_stamp_exists: timestamp /= Void

end
