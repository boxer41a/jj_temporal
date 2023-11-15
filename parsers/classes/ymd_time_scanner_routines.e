note
	description: "[
		Routines used by the {YMD_TIME_SCANNER}.  These were put here to
		ease the editting.  The text of class {YMD_TIME_SCANNER} is produced
		by "gelex" from a discription file, so every time a change is
		made "geyacc" must be run (from a dos prompt), the files moved, etc.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class
	YMD_TIME_SCANNER_ROUTINES

inherit

	YMD_TIME_FORMAT_CONSTANTS
		undefine
			default_create
		end

feature {NONE} -- Inititalization

	default_create

		 	-- Create an instance
		do
		end

feature -- Access

	last_string: detachable STRING
			-- Last string value read to pass to parser

	last_integer: INTEGER
			-- Last integer value read to pass to parser.

	last_value: detachable ANY
			-- Last value read by the scanner

feature {NONE} -- Implementation

	comas_removed (a_number_string: STRING): STRING
			-- Return the string without comas.
			-- Used to remove comas from reals or strings.
		local
			s: STRING
			i, n: INTEGER
			c: CHARACTER
		do
			create Result.make (200)
			s := a_number_string
			n := a_number_string.count
			from i := 1 until i > n
			loop
				c := s.item (i)
				if c /= ',' then
					Result.append_character (c)
				end
				i := i + 1
			end
		end

invariant

end -- class YMD_TIME_SCANNER_ROUTINES
