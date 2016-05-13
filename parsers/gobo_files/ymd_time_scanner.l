%{
indexing
	description:  "[
		Scanner for reading in a string and converting it to a date.
		This file was produced by 'gelex' (from the gobo tools cluster)
		using file "ymd_time_scanner.l".
		]"
	date: "17 Aug 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class YMD_TIME_SCANNER

inherit

	YY_COMPRESSED_SCANNER_SKELETON
		export
			{NONE} all
			{ANY} scanning_error
		redefine
			default_create
		end

	UT_CHARACTER_CODES
		export
			{NONE} all
		redefine
			default_create
		end

	YMD_TIME_TOKENS
		export
			{NONE} all
		redefine
			default_create
		end

	YMD_TIME_SCANNER_ROUTINES
		export
			{NONE} all
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create is
			-- Create a scanner object
		do
			make
			Precursor {YMD_TIME_SCANNER_ROUTINES}
		end

feature -- Basic operations

	scan_string (a_string: STRING) is
			-- Scan `a_string'
		local
			b: KL_CHARACTER_BUFFER
			yy_buf: YY_BUFFER
			f: FILE
			s: STRING
		do
				-- The `b' must end in "%U%U".  I don't know why.
				-- so append it onto the end of a copy of `a_string'.
			s := deep_clone (a_string)
			s.append ("%U%U")
			create b.make_from_string (s)
			create yy_buf.make_from_buffer (b)
			set_input_buffer (yy_buf)
			scan
		end

	print_values is
		do
			io.put_string ("token = ")
			io.put_string (token_name (last_token))
			io.put_string ("     value = ")
			if last_value /= Void then
				io.put_string (last_value.out)				
			else
				io.put_string ("Void")	
			end
			io.new_line
		end

---------------------------------------------------------------------------------
-----------------------   Following code produce by Gelex  ----------------------
		
%}

--%x IN_STR		-- line 50
%option outfile="ymd_time_scanner.e"


IDENTIFIER	[a-zA-Z][a-zA-Z]*

DIGIT		[0-9]
INTEGER	{DIGIT}+|{DIGIT}{1,3}(,{DIGIT}{3})+

SEPARATORS	[:./\\,\- \t\n\r]+

%%

{INTEGER}	{
			last_integer := comas_removed (text).to_integer
			last_value := last_integer
			if last_integer > 31 then
				last_token := YEAR_TOKEN
			elseif last_integer > 12 then
				last_token := YEAR_OR_DAY_TOKEN
			else
				last_token := NUMBER_TOKEN
			end
			print_values
		}

{IDENTIFIER} {	if is_month (text) then
				last_token := MONTH_TOKEN
				last_integer := get_month (text)
				last_value := last_integer
			elseif is_weekday (text) then
				last_token := WEEKDAY_TOKEN
				last_string := text
				last_value := text
			else
				last_token := SCAN_ERROR_TOKEN
				last_value := last_string
				print_values
			end
			print_values
		}

{SEPARATORS} {	last_value := text
			print_values
		}


%%

	
end -- class YMD_TIME_SCANNER