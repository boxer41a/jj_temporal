note
	description:  "[
		Notion of a duration of time such as 2 hours, or 3 years, etc.
		]"
	names: "abstract_duration, duration"
	date: "1 Jan 99"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

deferred class
	ABSTRACT_DURATION

inherit
	COMPARABLE

feature -- Access

	negative: like Current
			-- The negative value of this duration
		do
			Result := twin
			Result.negate
		ensure
			negative_result: Current > zero implies Result < zero
			positive_result: Current < zero implies Result > zero
		end

	one: like Current
			-- Neutral element for "*" and "/"
		deferred
		ensure
			result_exists: Result /= Void
			valid_result: Result.is_one
		end

	zero: like Current
			-- Neutral element for "+" and "-"
		deferred
		ensure
			result_exists: Result /= Void
			good_result: Result.is_zero
		end

feature -- Status Report

	is_zero: BOOLEAN
			-- Is this duration of 0 length?
		do
			Result := equal (Current, zero)
		ensure
			valid_result: Result implies equal (Current, zero)
		end

	is_one: BOOLEAN
			-- Is this duration neutral for '*' and '/'?
		do
			Result := equal (Current, one)
		ensure
			valid_result: Result implies equal (Current, one)
		end

	is_negative: BOOLEAN
			-- Is current less than the 'zero' duration?
		do
			Result := Current < zero
		ensure
			valid_result: Result implies Current < zero
		end

feature -- Element Change

	set_zero
			-- Make the duration have zero length.
		deferred
		ensure
			is_zero: is_zero
		end


	negate
			-- Reverses the sign.
		deferred
		ensure
			positive_implication: not is_negative implies old is_negative
			negative_implication: is_negative implies not old is_negative
		end

	add (other: like Current)
			-- Add other other to Current.
		require
			other_exists: other /= Void
		deferred
		end

	sub (other: like Current)
			-- Subtract other from Current
		require
			other_exists: other /= Void
		deferred
		end

	multiply (r: DOUBLE)
			-- Multiply by a factor of 'r'.
		deferred
		end

	divide (r: DOUBLE)
			-- Divide by 'r'.
		require
			not_zero_devisor: r /= 0
		deferred
		end

	div (i: INTEGER)
			-- Integer division.
		require
			not_zero_devisor: i /= 0
		deferred
		end

	mod (i: INTEGER)
			-- Modulo.
		require
			not_zero_devisor: i /= 0
		deferred
		end

	percent_of (other: like Current): DOUBLE
			-- What percent of other in length is this one?
			-- For example: is current duration at least twice as long as other?
		require
			other_exists: other /= Void
			other_not_zero: not other.is_zero
		deferred
		end

feature -- Basic operations

	identity alias "+": like Current
			-- Just a clone of Current.  Included for symetry.
		do
			Result := twin
		ensure
			no_side_effect: equal (Current, old Current)
		end

	oposite alias "-": like Current
			-- Invert the sign of other.
		do
			Result := twin
			Result.negate
		ensure
			no_side_effect: equal (Current, old Current)
		end

	plus alias "+" (other: like Current): like Current
			-- Sum of current and other.
		do
			Result := twin
			Result.add (other)
		ensure
			no_side_effect: equal (Current, old Current)
		end

	minus alias "-" (other: like Current): like Current
			-- Difference of Current and other.
		do
			Result := twin
			Result.sub (other)
		ensure
			no_side_effect: equal (Current, old Current)
		end

	product alias "*" (r: DOUBLE): like Current
			-- Product of Current and 'r'.
			-- Multiply by a factor of 'r'.
		do
			Result := twin
			Result.multiply (r)
		ensure
			no_side_effect: equal (Current, old Current)
		end

	quotient alias "/" (r: DOUBLE): like Current
			-- Quotent of Current by 'r'.
		require
			not_zero_devisor: r /= 0
		do
			Result := twin
			Result.divide (r)
		ensure
			no_side_effect: equal (Current, old Current)
		end

	integer_quotient alias "//" (i: INTEGER): like Current
			-- Integer division of Current by 'i'.
		require
			not_zero_devisor: i /= 0
		do
			Result := twin
			Result.div (i)
		ensure
			no_side_effect: equal (Current, old Current)
		end

	integer_remainder alias "\\" (i: INTEGER): like Current
			-- Modulo of Current by 'i'.
		require
			not_zero_devisor: i /= 0
		do
			Result := twin
			Result.mod (i)
		ensure
			no_side_effect: equal (Current, old Current)
		end

end

