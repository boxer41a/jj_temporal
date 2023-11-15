note
	description:  "[
		A span of time consisting of a start-time, finish-time
		and duration described in terms of years, months,
		days, hours, minutes, and seconds.  Positive durations only.
		]"
	names: "ymdhms_interval, interval, time_span, time_interval, span"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	YMDHMS_INTERVAL

inherit

	HMS_INTERVAL
		undefine
			default_create,
			time_anchor,
			duration_anchor
		end

	YMD_INTERVAL
		redefine
			time_anchor,
			duration_anchor
		end

create
	default_create

feature {NONE} -- Anchors (for covariant redefinitions)

	time_anchor: YMDHMS_TIME
			-- Anchor for features using times.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	duration_anchor: YMDHMS_DURATION
			-- Anchor for features using durations.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

end
