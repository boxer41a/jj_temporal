note
	description: "[
		Timer for hours, minutes, seconds, and miliseconds.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	HMS_TIMER

inherit

	HMS_INTERVAL
		undefine
			duration,
			out
		redefine
			default_create,
			time_anchor,
			duration_anchor
		end

	TIMER
		undefine
			time_anchor,
			duration_anchor
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Set up the timer
		do
			Precursor {HMS_INTERVAL}
			Precursor {TIMER}
			create cumulative
		end


feature {NONE} -- Anchors (for covariant redefinitions)

	time_anchor: HMS_TIME
			-- Anchor for features using times.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		once
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	duration_anchor: HMS_DURATION
			-- Anchor for features using durations.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		once
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end


end
