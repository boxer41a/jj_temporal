note
	description: "Summary description for {YMDHMS_TIMER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	YMDHMS_TIMER

inherit

	YMDHMS_INTERVAL
		undefine
			duration
		redefine
			default_create,
			time_anchor,
			duration_anchor
		end

	HMS_TIMER
		undefine
			duration
		redefine
			default_create,
			time_anchor,
			duration_anchor
		end

	YMD_TIMER
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
			Precursor {YMDHMS_INTERVAL}
			Precursor {YMD_TIMER}
			create cumulative
		end


feature {NONE} -- Anchors (for covariant redefinitions)

	time_anchor: YMDHMS_TIME
			-- Anchor for features using times.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		once
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	duration_anchor: YMDHMS_DURATION
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
