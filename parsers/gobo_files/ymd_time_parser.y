%{
indexing
	description:  "[
		Parser for reading in a string and converting it to a date.
		This file was produced by 'geyacc' (from the gobo tools cluster)
		using file 'ymd_time_parser.y'.
		]"
	date: "17 Aug 04"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: 2009-06-25 21:37:23 -0400 (Thu, 25 Jun 2009) $"
	revision:	"$Revision: 7 $"

class YMD_TIME_PARSER

inherit

	YY_PARSER_SKELETON
		rename
			make as make_parser_skeleton
		redefine
			default_create
		end

	YMD_TIME_PARSER_ROUTINES
		rename
			last_value as last_scanner_value
		redefine
			default_create
		end

	YMD_TIME_SCANNER
		rename
			last_value as last_scanner_value
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create is
			-- Create a new Eiffel parser.
		do
			Precursor {YMD_TIME_SCANNER}
			make_parser_skeleton
		end

feature -- Access

	last_value: YMD_TIME
			-- The result of parsing

feature -- Basic operations

	parse_string (a_string: STRING) is
			-- Parse `a_string'.
		local
			b: KL_CHARACTER_BUFFER
			yy_buf: YY_BUFFER
			f: FILE
			s: STRING
		do
			reset
				-- The `b' must end in "%U%U".  I don't know why.
				-- so append it onto the end of a copy of `a_string'.
			s := deep_clone (a_string)
			s.append ("%U%U")
			create b.make_from_string (s)
			create yy_buf.make_from_buffer (b)
			set_input_buffer (yy_buf)	
			parse
		end

-------------------------------------------------------------------------------------
--------------------  Following created by GeYacc  ----------------------------------


%}

%token SCAN_ERROR_TOKEN

%token WEEKDAY_TOKEN
%token YEAR_TOKEN
%token MONTH_TOKEN
%token YEAR_OR_DAY_TOKEN
%token NUMBER_TOKEN

%type <YMD_TIME> Date
%type <YMD_TIME> Ambiguous_day
%type <YMD_TIME> Ambiguous_day_month
%type <YMD_TIME> Unspecified
%type <YMD_TIME> Weekday_included
%type <YMD_TIME> Three_numbers
%type <YMD_TIME> Two_numbers

%type <INTEGER> Month
%type <INTEGER> Year
%type <INTEGER> Year_or_day
%type <INTEGER> Number

--------------------------------------------------------------------------------
%%

Date: -- Empty			{ parsed_result := "No date entered" }
	| Ambiguous_day		{ $$ := $1  last_value := $$ }
	| Ambiguous_day_month	{ $$ := $1  last_value := $$ }
	| Unspecified		{ $$ := $1  last_value := $$ }
	| Three_numbers		{ $$ := $1  last_value := $$ }
	| Two_numbers		{ $$ := $1  last_value := $$ }
	| Weekday_included	{ $$ := $1  last_value := $$ }
--	| SCAN_ERROR_TOKEN	{ $$ := last_scanner_value	last_value := $$ }
	;

-- The Month and Year are known.
Ambiguous_day: Number Month Year	{ $$ := process_ambiguous_day ($1, $2, $3) }
	| Year_or_day Month Year	{ $$ := process_ambiguous_day ($1, $2, $3) }
	| Month Year_or_day Year	{ $$ := process_ambiguous_day ($2, $1, $3) }
	| Month Number Year		{ $$ := process_ambiguous_day ($2, $1, $3) }
	;

-- Only the Year is certain.
Ambiguous_day_month: Year_or_day Number Year	{ $$ := process_ambiguous_day ($1, $2, $3) }
	| Number Year_or_day Year			{ $$ := process_ambiguous_day ($2, $1, $3) }
	| Year Year_or_day Number			{ $$ := process_ambiguous_day ($2, $3, $1) }
	| Year Number Year_or_day			{ $$ := process_ambiguous_day ($3, $2, $1) }
	| Number Number Year				{ $$ := process_ambiguous_day_month ($1, $2, $3) }
	| Year Number Number				{ $$ := process_ambiguous_day_month ($2, $3, $1) }
	;

-- Two values input and at least one can be identified; assumptions are made about the unknowns.
Unspecified: Month Year		{ $$ := process_unspecified (0, $1, $2) }
	| Year Month		{ $$ := process_unspecified (0, $2, $1) }
	| Year_or_day Month	{ $$ := process_unspecified ($1, $2, 0) }
	| Month Year_or_day	{ $$ := process_unspecified ($2, $1, 0) }
	| Number Year		{ $$ := process_unspecified (0, $1, $2) }
	| Year Number		{ $$ := process_unspecified (0, $2, $1) }
	| Number Month		{ $$ := process_unspecified ($1, $2, 0) }
	| Month Number		{ $$ := process_unspecified ($2, $1, 0) }
	;

-- A date with the weekday included; the weekday is ignored.
Weekday_included: Weekday Ambiguous_day	{ $$ := $2 }
	| Weekday Ambiguous_day_month		{ $$ := $2 }
	| Weekday Unspecified			{ $$ := $2 }
	| Weekday Three_numbers			{ $$ := $2 }
	| Weekday Two_numbers			{ $$ := $2 }
	;

-- The date is entered as three numbers and scanner is unable to deduce from
-- the values which one is day, year, and so on.
Three_numbers: Number Number Number	{ $$ := process_three_numbers ($1, $2, $3) }
	| Year_or_day Number Number	{ $$ := process_three_numbers ($1, $2, $3) }
	| Number Year_or_day Number	{ $$ := process_three_numbers ($1, $2, $3) }
	| Number Number Year_or_day	{ $$ := process_three_numbers ($1, $2, $3) }
	;

-- The date was enterred as only two numbers and the scanner was unable
-- to deduce thier meanings.
Two_numbers: Number Number	{ $$ := process_two_numbers ($1, $2) }
	| Year_or_day Number	{ $$ := process_two_numbers ($1, $2) }	
	| Number Year_or_day	{ $$ := process_two_numbers ($1, $2) }
	;


--------------------------------------------------------------------------------

Weekday: WEEKDAY_TOKEN	{ -- do nothing as result is not needed 
				}
	;

Month: MONTH_TOKEN	{ $$ := last_integer }
	;

Year: YEAR_TOKEN		{ $$ := last_integer }
	;

Year_or_day: YEAR_OR_DAY_TOKEN	{ $$ := last_integer }
	;

Number: NUMBER_TOKEN	{ $$ := last_integer }
	;


%%

end -- class YMD_TIME_PARSER
