note

	description: "Parser token codes"
	generator: "geyacc version 3.4"

class YMD_TIME_TOKENS


feature -- Last values

	last_any_value: detachable ANY

feature -- Access

	token_name (a_token: INTEGER): STRING
			-- Name of token `a_token'
		do
			inspect a_token
			when 0 then
				Result := "EOF token"
			when -1 then
				Result := "Error token"
			when SCAN_ERROR_TOKEN then
				Result := "SCAN_ERROR_TOKEN"
			when WEEKDAY_TOKEN then
				Result := "WEEKDAY_TOKEN"
			when YEAR_TOKEN then
				Result := "YEAR_TOKEN"
			when MONTH_TOKEN then
				Result := "MONTH_TOKEN"
			when YEAR_OR_DAY_TOKEN then
				Result := "YEAR_OR_DAY_TOKEN"
			when NUMBER_TOKEN then
				Result := "NUMBER_TOKEN"
			else
				Result := "Unknown token"
			end
		end

feature -- Token codes

	SCAN_ERROR_TOKEN: INTEGER = 258
	WEEKDAY_TOKEN: INTEGER = 259
	YEAR_TOKEN: INTEGER = 260
	MONTH_TOKEN: INTEGER = 261
	YEAR_OR_DAY_TOKEN: INTEGER = 262
	NUMBER_TOKEN: INTEGER = 263

end
