note
	description:  "[
		Notion of a time, such as <1 Jan 98> or <10:30 P.M.> or <the moment of creation>, etc.
		]"
	names: "abstract_time, time, date"
	date: "1 Jan 99"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

deferred class
	ABSTRACT_TIME

inherit
	COMPARABLE

feature -- Access

	as_string: STRING
			-- The time represented as a string, ideally with not extra characters.
		deferred
		end

	as_integer: INTEGER
			-- The time as represented by an INTEGER.
		require
			is_representable: is_representable_as_integer
		deferred
		end

feature -- Initialization

	set_now
			-- Set current time according to timezone.
		deferred
		end

	set_now_utc
			-- Set the current object to today's date in utc format.
		deferred
		end

	set_now_utc_fine
			-- Set the current object to today's date in utc format.
		deferred
		end

feature -- Element change

	from_string (a_string: STRING)
			-- Change Current to the time represented by `a_string'.
			-- It must be in the format as provided by `as_string'.
		require
			valid_string_representation: is_valid_string_representation (a_string)
		deferred
		end

	from_integer (a_integer: INTEGER)
			-- Change Current to the time represented by `a_integer'.
		require
			valid_integer_representation: is_valid_integer_representation (a_integer)
		deferred
		end

	add_duration (a_duration: like duration_anchor)
			-- adds a duration to Current time
		require
			duration_exists: a_duration /= Void
		deferred
		end

feature -- Basic operations

	plus alias "+" (a_duration: like duration_anchor): like Current
			-- same as add_duration except returns a new time
		require
			duration_exists: a_duration /= Void
		do
			Result := twin
			Result.add_duration (a_duration)
		ensure
			no_side_effect: equal (Current, old Current)
		end

	minus alias "-" (a_duration: like duration_anchor): like Current
			-- same as adding a negative duration except returns a new time
		require
			duration_exists: a_duration /= Void
		do
			Result := twin
			Result.add_duration (a_duration.negative)
		ensure
			no_side_effect: equal (Current, old Current)
		end

feature -- Status report

	is_representable_as_integer: BOOLEAN
			-- Can Current be represented as an integer?
		deferred
		end

feature -- Querry

	is_before (a_interval: like interval_anchor): BOOLEAN
			-- Is this time before the interval?
		require
			interval_exists: a_interval /= Void
		do
			Result := Current < a_interval.start
		ensure
			valid_result: Result implies Current < a_interval.start
		end

	is_after (a_interval: like interval_anchor): BOOLEAN
			-- Is this time after the interval?
		require
			interval_exists: a_interval /= Void
		do
			Result := Current > a_interval.finish
		ensure
			valid_result: Result implies Current > a_interval.finish
		end

	belongs (a_interval: like interval_anchor): BOOLEAN
			-- Does this time fall somewhere during the interval?
		require
			interval_exists: a_interval /= Void
		do
			Result := Current >= a_interval.start and Current <= a_interval.finish
		ensure
			valid_result: Result implies Current >= a_interval.start and Current <= a_interval.finish
		end

	is_between (time_1, time_2: like Current): BOOLEAN
			-- Is current between the two times?
		require
			others_exist: time_1 /= Void and time_2 /= Void
		do
			if time_1 < Current and Current < time_2 then
				Result := True
			elseif time_2 < Current and Current < time_1 then
				Result := True
			end
		ensure
			valid_result: Result implies ((time_1 < Current and Current < time_2) or else
							(time_2 < Current and Current < time_1))
		end

	is_between_inclusive (time_1, time_2: like Current): BOOLEAN
			-- Is current between the two times or equal to one of the two times?
		require
			others_exist: time_1 /= Void and time_2 /= Void
		do
			if time_1 <= Current and Current <= time_2 then
				Result := True
			elseif time_2 <= Current and Current <= time_1 then
				Result := True
			end
		ensure
			valid_result: Result implies ((time_1 <= Current and Current <= time_2) or else
							(time_2 <= Current and Current <= time_1))
		end

	percent_of (a_interval: like interval_anchor): DOUBLE
			-- Where does this time fall in relation to the interval?
			-- If current time is before the interval then result should be negative.
			-- If current time is after the interval then result should be > 1 (i.e. > 100%).
			-- If current time belongs to the interval then result should be between 0 and 1.
		require
			interval_exists: a_interval /= Void
		local
			int: like Interval_anchor
		do
--			int := twin (a_interval)
			int := a_interval.deep_twin
			if is_before (a_interval) then
				int.set_start_finish (Current, a_interval.start)
				if not a_interval.duration.is_zero then
					Result := -(int.duration.percent_of (a_interval.duration))
				end
			else
				int.set_start_finish (a_interval.start, Current)
				if not a_interval.duration.is_zero then
					Result := int.duration.percent_of (a_interval.duration)
				end
			end
		ensure
			negative_if_before: Result < 0 implies Current.is_before (a_interval)
			zero_to_one_if_belongs: (Result >= 0 and Result <= 1) implies Current.belongs (a_interval)
			over_one_if_after: Result > 1 implies Current.is_after (a_interval)
		end

	time_between (other: like Current): like duration_anchor
			-- The duration of time between Current and other
		require
			other_exists: other /= Void
		deferred
		end

	is_valid_string_representation (a_string: STRING): BOOLEAN
			-- Is `a_string' in a format that can be used to initialize Current?
		deferred
		end

	is_valid_integer_representation (a_integer: INTEGER): BOOLEAN
			-- Is `a_integer' in the range reconizable by Current?
		deferred
		end

feature {NONE} -- Implementation

	C_date: C_DATE
			-- Used to set the date and time based on system clock.
		once
			create Result
		end

	is_valid: BOOLEAN
			-- Test used by invariant.
		do
			Result := True
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	duration_anchor: ABSTRACT_DURATION
			-- Anchor for features using durations.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	interval_anchor: ABSTRACT_INTERVAL
			-- Anchor for features using intervals.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

invariant

	always_valid: is_valid

note
	copyright: "Copyright (c) 1984-2015, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end



