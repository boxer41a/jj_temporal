note
	description:  "[
		A span of time consisting of a start-time, finish-time
		and duration described in terms of hours, minutes, and
		seconds.  Positive durations only.
		]"
	names: "hms_interval, interval, time_span, time_interval, span"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	HMS_INTERVAL

inherit

	ABSTRACT_INTERVAL
		redefine
			time_anchor,
			duration_anchor
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Create an instance starting and ending at the default creation
			-- value for the type of `start' time, having zero length duration.
		do
				-- Can't define `default_create' in ABSTRACT_INTERVAL because there
				-- `start_imp' is deffered and cannot call create on a deferred type.
			create start_imp
			finish_imp := start_imp.twin
		ensure then
			same_start_and_finish: equal (start, finish)
			zero_duration: duration.is_zero
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
