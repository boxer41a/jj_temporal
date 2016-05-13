note
	description:  "[
		Notion of a span of time consisting of a start-time, a
		finish-time and a duration.  Positive durations only.
		]"
	names: "abstract_interval, time_span, time_interval, span"
	date: "1 Jan 99"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

deferred class
	ABSTRACT_INTERVAL

inherit

	COMPARABLE
		undefine
			default_create
		end

feature -- Access

	start: like time_anchor
			-- Beginning moment of the time span and anchor for class.
		do
			Result := start_imp.twin
		ensure
			result_exists: Result /= Void
		end

	finish: like time_anchor
			-- Ending moment of the time span.
		do
			Result := finish_imp.twin
		ensure
			result_exists: Result /= Void
		end

	duration: like duration_anchor
			-- Length of time span.
		do
			Result := finish.time_between (start)
		ensure
			result_exists: Result /= Void
		end

feature -- Element Change

	set_start_finish (a_start_time, a_finish_time: like time_anchor)
			-- Set the `start' and `finish' times.
		require
			times_exists: a_start_time /= Void and a_finish_time /= Void
			valid_times: a_start_time <= a_finish_time
		do
			start_imp := a_start_time.twin
			finish_imp := a_finish_time.twin
		ensure
			start_was_set: equal (start, a_start_time)
			finish_was_set: equal (finish, a_finish_time)
		end

	set_start_duration (a_start_time: like time_anchor; a_duration: like duration_anchor)
			-- Set the `start' time and the `duration'.
		require
			start_time_exists: a_start_time /= Void
			duration_exists: a_duration /= Void
			positive_duration: not a_duration.is_negative
		do
			start_imp := a_start_time.twin
			finish_imp := a_start_time + a_duration
		ensure
			start_was_set: equal (start, a_start_time)
			duration_was_set: equal (duration, a_duration)
		end

	set_duration_finish (a_duration: like duration_anchor; a_finish_time: like time_anchor)
		-- Set the `duration' and `finish' time.
		require
			duration_exists: a_duration /= Void
			positive_duration: not a_duration.is_negative
			finish_time_exists: a_finish_time /= Void
		do
			start_imp := a_finish_time - a_duration
			finish_imp := a_finish_time.twin
		ensure
			finish_was_set: equal (finish, a_finish_time)
			duration_was_set: equal (duration, a_duration)
		end

	move (a_duration: like duration_anchor)
			-- Change the `start' and `finish' times by moving the
			-- interval by the amount represented by `a_duration'.
		require
			duration_exists: a_duration /= Void
		do
			start_imp.add_duration (a_duration)
			finish_imp.add_duration (a_duration)
		ensure
			duration_unchanged: equal (duration, old duration)
		end

feature -- Status Report


feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Does current interval start before other or if they start at the
			-- same time, does Current end before the other?
		do
			if (start < other.start) or else
			   (start.is_equal (other.start) and then finish < other.finish) then
				Result := true
			end
		ensure then
			less_than_definition: Result implies (start < other.start or else
								   (start.is_equal (other.start) and then finish < other.finish))
		end

	meets (other: like Current): BOOLEAN
			--  x.meets(y)      |-----x----->|
			-- y.is_met_by(x)                |-----y----->|
		require
			other_exists: other /= Void
		do
			Result := equal (finish, other.start)
		ensure
			Result implies equal (finish, other.start)
			Result implies Current < other
		end

	is_met_by (other: like Current): BOOLEAN
			--  x.meets(y)      |-----x----->|
			-- y.is_met_by(x)                |-----y----->|
		require
			other_exists: other /= Void
		do
			Result := equal (start, other.finish)
		ensure
			Result implies equal (start, other.finish)
			Result implies other < Current
		end

	is_before (other: like Current): BOOLEAN
			--  x.is_before(y)	|-----x----->|
			--  y.is_after(x)					|-----y----->|
		require
			other_exists: other /= Void
		do
			Result := finish < other.start
		ensure
			Result implies finish.is_before (other)
			Result implies Current < other
		end

	is_after (other: like Current): BOOLEAN
			--  x.is_before(y)	|-----x----->|
			--  y.is_after(x)					|-----y----->|
		require
			other_exists: other /= Void
		do
			Result := start > other.finish
		ensure
			Result implies start.is_after (other)
			Result implies other < Current
		end

	includes (other: like Current): BOOLEAN
			--    x.includes(y)           |-----x----->|
			--  y.is_included_by(x)          |--y-->|
		require
			other_exists: other /= Void
		do
			Result := other.start.belongs (Current) and
				  other.finish.belongs (Current)
		ensure
			Result implies other.start.belongs (Current);
			Result implies other.finish.belongs (Current)
		end

	is_included_by (other: like Current): BOOLEAN
			--    x.includes(y)           |-----x----->|
			--  y.is_included_by(x)          |--y-->|
		require
			other_exists: other /= Void
		do
			Result := start.belongs (other) and finish.belongs (other)
		ensure
			Result implies start.belongs (other);
			Result implies finish.belongs (other);
		end

	overlaps (other: like Current): BOOLEAN
			--    x.overlaps(y)           |-----x----->|
			--  y.is_overlapped_by(x)               |--y-->|
		require
			other_exists: other /= Void
		do
			Result := finish.belongs (other)
		ensure
			Result implies finish.belongs (other)
		end

	is_overlapped_by (other: like Current): BOOLEAN
			--    x.overlaps(y)           |-----x----->|
			--  y.is_overlapped_by(x)               |--y-->|
		require
			other_exists: other /= Void
		do
			Result := other.finish.belongs (Current)
		ensure
			Result implies other.finish.belongs (Current)
		end

	intersects (other: like Current): BOOLEAN
			-- Do the two intervals have a least one time point in common?
		require
			other_exists: other /= Void
		do
			Result := meets (other) or is_met_by (other) or else
						includes (other) or is_included_by (other) or else
						overlaps (other) or is_overlapped_by (other)
		ensure
			Result implies meets (other) or is_met_by (other) or else
							includes (other) or is_included_by (other) or else
							overlaps (other) or is_overlapped_by (other)
		end

feature -- Transformation

	unite (other: like Current)
			-- Transform into the union between this interval and the other.
			--    |-------------x------------->|
			--          |-------------y------------->|
			--    |------------x.union(y)----------->|
			--  Only valid if at least one time point common to both.
		require
			other_exists: other /= Void
			intersecting_intervals: intersects (other)
		local
			temp_start: like time_anchor
			temp_finish: like finish
		do
			temp_start := start.min (other.start)
			temp_finish := finish.max (other.finish)
			set_start_finish (temp_start, temp_finish);
		ensure
			valid_result: equal (start, old start.min(other.start)) and
							equal (finish, old finish.max(other.finish))
		end

	intersect (other: like Current)
			-- Transform into the intersection of this interval and the other.
			--    |-------------x------------->|
			--          |-------------y------------->|
			--          |--x.intersection(y)-->|
			--  Only valid if at least one time point common to both.
		require
			other_exists: other /= Void
			intersecting_intervals: intersects (other)
		local
			temp_start: like time_anchor
			temp_finish: like finish
		do
			temp_start := start.max (other.start)
			temp_finish := finish.min (other.finish)
			set_start_finish (temp_start, temp_finish);
		ensure
			valid_result: equal (start, old start.max(other.start)) and
							equal (finish, old finish.min(other.finish))
		end

	split (a_time: like time_anchor): like Current
			-- Transform by splitting the interval at 'a_time'.
			-- Result is the interval after 'a_time'.
			--                   |
			--                  time
			--                   |
			--                   V
			--    |-----Current----------------->|
			--    |---Current--->|----Result---->|
			--  Only valid if time is within the interval.
		require
			time_exists: a_time /= Void
			time_in_interval: a_time.belongs (Current)
		do
			Result := twin
			set_start_finish (start, a_time)
			Result.set_start_finish (a_time, Result.finish)
		ensure
			closure: equal (old Current, Result.union (Current))
			meets_result: Current.meets (Result)
		end

feature -- Basic operations

	union (other: like Current): like Current
			-- The union between this interval and the other.
			--    |-------------x------------->|
			--          |-------------y------------->|
			--    |------------x.union(y)----------->|
			--  Only valid if at least one time point common to both.
		require
			other_exists: other /= Void
			intersecting_intervals: intersects (other)
		do
			Result := twin
			Result.unite (other)
		ensure
			no_side_effect: equal (Current, old Current)
			valid_result: equal (Result.start, start.min(other.start)) and
							equal (Result.finish, finish.max(other.finish))
		end

	intersection (other: like Current): like Current
			-- The intersection of this interval and the other.
			--    |-------------x------------->|
			--          |-------------y------------->|
			--          |--x.intersection(y)-->|
			--  Only valid if at least one time point common to both.
		require
			other_exists: other /= Void
			intersecting_intervals: intersects (other)
		do
			Result := twin
			Result.intersect (other)
		ensure
			no_side_effect: equal (Current, old Current)
			valid_result: equal (Result.start, start.max (other.start)) and
							equal (Result.finish, finish.min(other.finish))
		end

	time_at_percent (a_ratio: DOUBLE): like time_anchor
			-- Time based on some percentage of this interval.
			-- Example 1: if 'a_ratio' is 0.0 then result = 'start'; if
			-- 'a_ratio' is 0.5 then resulting time is 1/2 the distance
			-- from start to finish; if 'a_ratio' is 2.0 then resulting time
			-- is at twice the duration from start to finish.
		do
			Result := start + (duration * a_ratio)
		end

feature {NONE} -- Implementation

	start_imp: like time_anchor
			-- Used internally to prevent changes to `start' which could otherwise
			-- be induced by calls to a _TIME.

	finish_imp: like time_anchor
			-- Used internally to prevent changes to `finish' which could otherwise
			-- be induced by calls to a _TIME.

feature {NONE} -- Anchors (for covariant redefinitions)

	time_anchor: ABSTRACT_TIME
			-- Anchor for features using times.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		once
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	duration_anchor: ABSTRACT_DURATION
			-- Anchor for features using durations.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		once
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

invariant

	is_initialized: start_imp /= Void and finish_imp /= Void
	start_before_finish: start <= finish
	positive_duration: not duration.is_negative

end
