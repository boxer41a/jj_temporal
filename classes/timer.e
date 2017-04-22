note
	description: "[
		Stop-watch type object.
		Create the object and call `reset' to use.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

deferred class
	TIMER

inherit

	ABSTRACT_INTERVAL
		redefine
			duration
		end

feature {NONE} -- Initialization

	default_create
			-- Initialize Current
		do
			create lap_times.make (10)
		end

feature -- Access

	duration: like duration_anchor
			-- The time between the `start' and the `finish';
			-- or the time between the `start' and the current time if
			-- the timer is running.
		local
			t: like time_anchor
		do
			if is_running then
				t := finish
				t.set_now_utc_fine
				Result := t.time_between (start)
			else
				Result := Precursor
 			end
		end

	cumulative: like duration_anchor
			-- Cumulative total of all the times elapsed on the timer.
			-- Recalculated at every `stop'.

	i_th_lap (a_index: INTEGER): like duration_anchor
			-- The `a_index'th duration.
		require
			is_valid_lap_index: is_valid_lap_index (a_index)
		do
			Result := lap_times.i_th (a_index)
		end

feature -- Status report

	is_running: BOOLEAN
			-- Is the timer running?
			-- (Use `start' to begin timing and `stop' to end.)

feature -- Basic operations

	reset
			-- Reset `elapsed' to zero.
		do
			start_imp.set_now_utc_fine
			finish_imp.copy (start)
			cumulative.set_zero
			lap_times.wipe_out
		end

	run
			-- Start the timer
		require
			not_running: not is_running
		do
			is_running := True
			start_imp.set_now_utc_fine
		ensure
			is_running: is_running
		end

	stop
			-- Stop the timer
		require
			is_running: is_running
		do
			is_running := False
			finish_imp.set_now_utc_fine
			cumulative := cumulative + duration
--			start_imp.copy (finish)
-- 			mark_lap
		ensure
			is_stopped: not is_running
		end

	mark_lap
			-- Record the current `lap' time in `lap_times' but keep the timer running.
		do
			lap_times.extend (duration)
		end

feature -- Querry

	is_valid_lap_index (a_index: INTEGER): BOOLEAN
			-- Is `a_index' a valid value into the list of `lap_times'?
		do
			Result := lap_times.valid_index (a_index)
		end

feature {NONE} -- Implementation

	lap_times: ARRAYED_LIST [like duration_anchor]
			-- List of durations for each time `mark_lap' was called.

end
