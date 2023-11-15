cd d:
cd e_source
cd parser_tests
cd date_parser
cd discription_files
geyacc -t ymd_time_tokens -o ymd_time_parser.e ymd_time_parser.y
gelex -o ymd_time_scanner.e ymd_time_scanner.l
