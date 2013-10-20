" Vim syntax file
" Language: PHP 5.3 & up
" Maintainer: Paul Garvin <paul@paulgarvin.net>
" Contributor: Stan Angeloff <stanimir@angeloff.name>
" URL: https://github.com/StanAngeloff/php.vim
"
" Former Maintainer:  Peter Hodge <toomuchphp-vim@yahoo.com>
" Former URL: http://www.vim.org/scripts/script.php?script_id=1571
"
" Note: All of the switches for VIM 5.X and 6.X compatability were removed.
"       DO NOT USE THIS FILE WITH A VERSION OF VIM < 7.0.
"
" Note: If you are using a colour terminal with dark background, you will probably find
"       the 'elflord' colorscheme is much better for PHP's syntax than the default
"       colourscheme, because elflord's colours will better highlight the break-points
"       (Statements) in your code.
"
" Options:  php_sql_query = 1  for SQL syntax highlighting inside strings
"           php_html_in_strings = 1  for HTML syntax highlighting inside strings.
"                                    When disabled also disables JavaScript
"                                    inside strings and HereDoc.
"           php_parent_error_close = 1  for highlighting parent error ] or )
"           php_parent_error_open = 1  for skipping an php end tag,
"                                      if there exists an open ( or [ without a closing one
"           php_no_shorttags = 1  don't sync <? ?> as php
"           php_folding = 1  for folding classes and functions
"           php_sync_method = x
"                             x=-1 to sync by search ( default )
"                             x>0 to sync at least x lines backwards
"                             x=0 to sync from start
"           php_use_sql = 0|1 If 0 don't load SQL syntax. Also disable uses of
"                             'php_sql_query'.
"
" Note:
" Setting php_folding=1 will match a closing } by comparing the indent
" before the class or function keyword with the indent of a matching }.
" Setting php_folding=2 will match all of pairs of {,} ( see known
" bugs ii )
"
" Known Bugs:
"  - setting  php_parent_error_close  on  and  php_parent_error_open  off
"    has these two leaks:
"     i) A closing ) or ] inside a string match to the last open ( or [
"        before the string, when the the closing ) or ] is on the same line
"        where the string started. In this case a following ) or ] after
"        the string would be highlighted as an error, what is incorrect.
"    ii) Same problem if you are setting php_folding = 2 with a closing
"        } inside an string on the first line of this string.
"
"  - A double-quoted string like this:
"      "$foo->someVar->someOtherVar->bar"
"    will highight '->someOtherVar->bar' as though they will be parsed
"    as object member variables, but PHP only recognizes the first
"    object member variable ($foo->someVar).


if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'php'
endif

runtime! syntax/html.vim
unlet! b:current_syntax
" HTML syntax file turns on spelling for all top level words, we attempt to turn off
syntax spell default

" Set sync method if none declared
if !exists("php_sync_method")
  if exists("php_minlines")
    let php_sync_method=php_minlines
  else
    let php_sync_method=-1
  endif
endif

syn cluster htmlPreproc add=phpRegion

if exists('php_use_sql') && php_use_sql == 1
  " Use MySQL as the default SQL syntax file.
  " See https://github.com/StanAngeloff/php.vim/pull/1
  if !exists('b:sql_type_override') && !exists('g:sql_type_default')
    let b:sql_type_override='mysql'
  endif
  syn include @sqlTop syntax/sql.vim

  syn sync clear
  unlet! b:current_syntax
  syn cluster sqlTop remove=sqlString,sqlComment
  if exists("php_sql_query")
    syn cluster phpAddStrings contains=@sqlTop
  endif
else
  let php_sql_query = 0
endif

if exists("php_html_in_strings") && php_html_in_strings == 1
  syn cluster phpAddStrings add=@htmlTop
endif

syn case match

" Superglobals
syn keyword phpSuperglobals GLOBALS _GET _POST _REQUEST _FILES _COOKIE _SERVER _SESSION _ENV HTTP_RAW_POST_DATA php_errormsg http_response_header argc argv contained

" Magic Constants
syn keyword phpMagicConstants __LINE__ __FILE__ __DIR__ __FUNCTION__ __CLASS__ __METHOD__ __NAMESPACE__ contained

" $_SERVER Variables
syn keyword phpServerVars GATEWAY_INTERFACE SERVER_NAME SERVER_SOFTWARE SERVER_PROTOCOL REQUEST_METHOD QUERY_STRING DOCUMENT_ROOT HTTP_ACCEPT HTTP_ACCEPT_CHARSET HTTP_ENCODING HTTP_ACCEPT_LANGUAGE HTTP_CONNECTION HTTP_HOST HTTP_REFERER HTTP_USER_AGENT REMOTE_ADDR REMOTE_PORT SCRIPT_FILENAME SERVER_ADMIN SERVER_PORT SERVER_SIGNATURE PATH_TRANSLATED SCRIPT_NAME REQUEST_URI PHP_SELF contained

" === BEGIN BUILTIN FUNCTIONS, CLASSES, AND CONSTANTS ===================================

syn case match

" Core
syn keyword phpConstants E_ERROR E_RECOVERABLE_ERROR E_WARNING E_PARSE E_NOTICE E_STRICT E_DEPRECATED E_CORE_ERROR E_CORE_WARNING E_COMPILE_ERROR E_COMPILE_WARNING E_USER_ERROR E_USER_WARNING E_USER_NOTICE E_USER_DEPRECATED E_ALL DEBUG_BACKTRACE_PROVIDE_OBJECT DEBUG_BACKTRACE_IGNORE_ARGS TRUE FALSE NULL ZEND_THREAD_SAFE ZEND_DEBUG_BUILD PHP_VERSION PHP_MAJOR_VERSION PHP_MINOR_VERSION PHP_RELEASE_VERSION PHP_EXTRA_VERSION PHP_VERSION_ID PHP_ZTS PHP_DEBUG PHP_OS PHP_SAPI DEFAULT_INCLUDE_PATH PEAR_INSTALL_DIR PEAR_EXTENSION_DIR PHP_EXTENSION_DIR PHP_PREFIX PHP_BINDIR PHP_LIBDIR PHP_DATADIR PHP_SYSCONFDIR PHP_LOCALSTATEDIR PHP_CONFIG_FILE_PATH PHP_CONFIG_FILE_SCAN_DIR PHP_SHLIB_SUFFIX PHP_EOL PHP_MAXPATHLEN PHP_INT_MAX PHP_INT_SIZE PHP_WINDOWS_VERSION_MAJOR PHP_WINDOWS_VERSION_MINOR PHP_WINDOWS_VERSION_BUILD PHP_WINDOWS_VERSION_PLATFORM PHP_WINDOWS_VERSION_SP_MAJOR PHP_WINDOWS_VERSION_SP_MINOR PHP_WINDOWS_VERSION_SUITEMASK PHP_WINDOWS_VERSION_PRODUCTTYPE PHP_WINDOWS_NT_DOMAIN_CONTROLLER PHP_WINDOWS_NT_SERVER PHP_WINDOWS_NT_WORKSTATION PHP_BINARY PHP_OUTPUT_HANDLER_START PHP_OUTPUT_HANDLER_WRITE PHP_OUTPUT_HANDLER_FLUSH PHP_OUTPUT_HANDLER_CLEAN PHP_OUTPUT_HANDLER_FINAL PHP_OUTPUT_HANDLER_CONT PHP_OUTPUT_HANDLER_END PHP_OUTPUT_HANDLER_CLEANABLE PHP_OUTPUT_HANDLER_FLUSHABLE PHP_OUTPUT_HANDLER_REMOVABLE PHP_OUTPUT_HANDLER_STDFLAGS PHP_OUTPUT_HANDLER_STARTED PHP_OUTPUT_HANDLER_DISABLED UPLOAD_ERR_OK UPLOAD_ERR_INI_SIZE UPLOAD_ERR_FORM_SIZE UPLOAD_ERR_PARTIAL UPLOAD_ERR_NO_FILE UPLOAD_ERR_NO_TMP_DIR UPLOAD_ERR_CANT_WRITE UPLOAD_ERR_EXTENSION STDIN STDOUT STDERR contained

" date
syn keyword phpConstants DATE_ATOM DATE_COOKIE DATE_ISO8601 DATE_RFC822 DATE_RFC850 DATE_RFC1036 DATE_RFC1123 DATE_RFC2822 DATE_RFC3339 DATE_RSS DATE_W3C SUNFUNCS_RET_TIMESTAMP SUNFUNCS_RET_STRING SUNFUNCS_RET_DOUBLE ATOM COOKIE ISO8601 RFC822 RFC850 RFC1036 RFC1123 RFC2822 RFC3339 RSS W3C AFRICA AMERICA ANTARCTICA ARCTIC ASIA ATLANTIC AUSTRALIA EUROPE INDIAN PACIFIC UTC ALL ALL_WITH_BC PER_COUNTRY EXCLUDE_START_DATE contained

" hash
syn keyword phpConstants HASH_HMAC MHASH_CRC32 MHASH_MD5 MHASH_SHA1 MHASH_HAVAL256 MHASH_RIPEMD160 MHASH_TIGER MHASH_GOST MHASH_CRC32B MHASH_HAVAL224 MHASH_HAVAL192 MHASH_HAVAL160 MHASH_HAVAL128 MHASH_TIGER128 MHASH_TIGER160 MHASH_MD4 MHASH_SHA256 MHASH_ADLER32 MHASH_SHA224 MHASH_SHA512 MHASH_SHA384 MHASH_WHIRLPOOL MHASH_RIPEMD128 MHASH_RIPEMD256 MHASH_RIPEMD320 MHASH_SNEFRU256 MHASH_MD2 MHASH_FNV132 MHASH_FNV1A32 MHASH_FNV164 MHASH_FNV1A64 MHASH_JOAAT contained

" iconv
syn keyword phpConstants ICONV_IMPL ICONV_VERSION ICONV_MIME_DECODE_STRICT ICONV_MIME_DECODE_CONTINUE_ON_ERROR contained

" json
syn keyword phpConstants JSON_HEX_TAG JSON_HEX_AMP JSON_HEX_APOS JSON_HEX_QUOT JSON_FORCE_OBJECT JSON_NUMERIC_CHECK JSON_UNESCAPED_SLASHES JSON_PRETTY_PRINT JSON_UNESCAPED_UNICODE JSON_ERROR_NONE JSON_ERROR_DEPTH JSON_ERROR_STATE_MISMATCH JSON_ERROR_CTRL_CHAR JSON_ERROR_SYNTAX JSON_ERROR_UTF8 JSON_OBJECT_AS_ARRAY JSON_BIGINT_AS_STRING contained

" mbstring
syn keyword phpConstants MB_OVERLOAD_MAIL MB_OVERLOAD_STRING MB_OVERLOAD_REGEX MB_CASE_UPPER MB_CASE_LOWER MB_CASE_TITLE contained

" mysql
syn keyword phpConstants MYSQL_ASSOC MYSQL_NUM MYSQL_BOTH MYSQL_CLIENT_COMPRESS MYSQL_CLIENT_SSL MYSQL_CLIENT_INTERACTIVE MYSQL_CLIENT_IGNORE_SPACE contained

" mysqli
syn keyword phpConstants MYSQLI_READ_DEFAULT_GROUP MYSQLI_READ_DEFAULT_FILE MYSQLI_OPT_CONNECT_TIMEOUT MYSQLI_OPT_LOCAL_INFILE MYSQLI_INIT_COMMAND MYSQLI_OPT_NET_CMD_BUFFER_SIZE MYSQLI_OPT_NET_READ_BUFFER_SIZE MYSQLI_OPT_INT_AND_FLOAT_NATIVE MYSQLI_OPT_SSL_VERIFY_SERVER_CERT MYSQLI_CLIENT_SSL MYSQLI_CLIENT_COMPRESS MYSQLI_CLIENT_INTERACTIVE MYSQLI_CLIENT_IGNORE_SPACE MYSQLI_CLIENT_NO_SCHEMA MYSQLI_CLIENT_FOUND_ROWS MYSQLI_STORE_RESULT MYSQLI_USE_RESULT MYSQLI_ASYNC MYSQLI_ASSOC MYSQLI_NUM MYSQLI_BOTH MYSQLI_STMT_ATTR_UPDATE_MAX_LENGTH MYSQLI_STMT_ATTR_CURSOR_TYPE MYSQLI_CURSOR_TYPE_NO_CURSOR MYSQLI_CURSOR_TYPE_READ_ONLY MYSQLI_CURSOR_TYPE_FOR_UPDATE MYSQLI_CURSOR_TYPE_SCROLLABLE MYSQLI_STMT_ATTR_PREFETCH_ROWS MYSQLI_NOT_NULL_FLAG MYSQLI_PRI_KEY_FLAG MYSQLI_UNIQUE_KEY_FLAG MYSQLI_MULTIPLE_KEY_FLAG MYSQLI_BLOB_FLAG MYSQLI_UNSIGNED_FLAG MYSQLI_ZEROFILL_FLAG MYSQLI_AUTO_INCREMENT_FLAG MYSQLI_TIMESTAMP_FLAG MYSQLI_SET_FLAG MYSQLI_NUM_FLAG MYSQLI_PART_KEY_FLAG MYSQLI_GROUP_FLAG MYSQLI_ENUM_FLAG MYSQLI_BINARY_FLAG MYSQLI_NO_DEFAULT_VALUE_FLAG MYSQLI_ON_UPDATE_NOW_FLAG MYSQLI_TYPE_DECIMAL MYSQLI_TYPE_TINY MYSQLI_TYPE_SHORT MYSQLI_TYPE_LONG MYSQLI_TYPE_FLOAT MYSQLI_TYPE_DOUBLE MYSQLI_TYPE_NULL MYSQLI_TYPE_TIMESTAMP MYSQLI_TYPE_LONGLONG MYSQLI_TYPE_INT24 MYSQLI_TYPE_DATE MYSQLI_TYPE_TIME MYSQLI_TYPE_DATETIME MYSQLI_TYPE_YEAR MYSQLI_TYPE_NEWDATE MYSQLI_TYPE_ENUM MYSQLI_TYPE_SET MYSQLI_TYPE_TINY_BLOB MYSQLI_TYPE_MEDIUM_BLOB MYSQLI_TYPE_LONG_BLOB MYSQLI_TYPE_BLOB MYSQLI_TYPE_VAR_STRING MYSQLI_TYPE_STRING MYSQLI_TYPE_CHAR MYSQLI_TYPE_INTERVAL MYSQLI_TYPE_GEOMETRY MYSQLI_TYPE_NEWDECIMAL MYSQLI_TYPE_BIT MYSQLI_SET_CHARSET_NAME MYSQLI_SET_CHARSET_DIR MYSQLI_NO_DATA MYSQLI_DATA_TRUNCATED MYSQLI_REPORT_INDEX MYSQLI_REPORT_ERROR MYSQLI_REPORT_STRICT MYSQLI_REPORT_ALL MYSQLI_REPORT_OFF MYSQLI_DEBUG_TRACE_ENABLED MYSQLI_SERVER_QUERY_NO_GOOD_INDEX_USED MYSQLI_SERVER_QUERY_NO_INDEX_USED MYSQLI_SERVER_QUERY_WAS_SLOW MYSQLI_SERVER_PS_OUT_PARAMS MYSQLI_REFRESH_GRANT MYSQLI_REFRESH_LOG MYSQLI_REFRESH_TABLES MYSQLI_REFRESH_HOSTS MYSQLI_REFRESH_STATUS MYSQLI_REFRESH_THREADS MYSQLI_REFRESH_SLAVE MYSQLI_REFRESH_MASTER MYSQLI_REFRESH_BACKUP_LOG MYSQLI_OPT_CAN_HANDLE_EXPIRED_PASSWORDS contained

" pcre
syn keyword phpConstants PREG_PATTERN_ORDER PREG_SET_ORDER PREG_OFFSET_CAPTURE PREG_SPLIT_NO_EMPTY PREG_SPLIT_DELIM_CAPTURE PREG_SPLIT_OFFSET_CAPTURE PREG_GREP_INVERT PREG_NO_ERROR PREG_INTERNAL_ERROR PREG_BACKTRACK_LIMIT_ERROR PREG_RECURSION_LIMIT_ERROR PREG_BAD_UTF8_ERROR PREG_BAD_UTF8_OFFSET_ERROR PCRE_VERSION contained

" session
syn keyword phpConstants PHP_SESSION_DISABLED PHP_SESSION_NONE PHP_SESSION_ACTIVE contained

" standard
syn keyword phpConstants CONNECTION_ABORTED CONNECTION_NORMAL CONNECTION_TIMEOUT INI_USER INI_PERDIR INI_SYSTEM INI_ALL INI_SCANNER_NORMAL INI_SCANNER_RAW PHP_URL_SCHEME PHP_URL_HOST PHP_URL_PORT PHP_URL_USER PHP_URL_PASS PHP_URL_PATH PHP_URL_QUERY PHP_URL_FRAGMENT PHP_QUERY_RFC1738 PHP_QUERY_RFC3986 M_E M_LOG2E M_LOG10E M_LN2 M_LN10 M_PI M_PI_2 M_PI_4 M_1_PI M_2_PI M_SQRTPI M_2_SQRTPI M_LNPI M_EULER M_SQRT2 M_SQRT1_2 M_SQRT3 INF NAN PHP_ROUND_HALF_UP PHP_ROUND_HALF_DOWN PHP_ROUND_HALF_EVEN PHP_ROUND_HALF_ODD INFO_GENERAL INFO_CREDITS INFO_CONFIGURATION INFO_MODULES INFO_ENVIRONMENT INFO_VARIABLES INFO_LICENSE INFO_ALL CREDITS_GROUP CREDITS_GENERAL CREDITS_SAPI CREDITS_MODULES CREDITS_DOCS CREDITS_FULLPAGE CREDITS_QA CREDITS_ALL HTML_SPECIALCHARS HTML_ENTITIES ENT_COMPAT ENT_QUOTES ENT_NOQUOTES ENT_IGNORE ENT_SUBSTITUTE ENT_DISALLOWED ENT_HTML401 ENT_XML1 ENT_XHTML ENT_HTML5 STR_PAD_LEFT STR_PAD_RIGHT STR_PAD_BOTH PATHINFO_DIRNAME PATHINFO_BASENAME PATHINFO_EXTENSION PATHINFO_FILENAME CHAR_MAX LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_ALL SEEK_SET SEEK_CUR SEEK_END LOCK_SH LOCK_EX LOCK_UN LOCK_NB STREAM_NOTIFY_CONNECT STREAM_NOTIFY_AUTH_REQUIRED STREAM_NOTIFY_AUTH_RESULT STREAM_NOTIFY_MIME_TYPE_IS STREAM_NOTIFY_FILE_SIZE_IS STREAM_NOTIFY_REDIRECTED STREAM_NOTIFY_PROGRESS STREAM_NOTIFY_FAILURE STREAM_NOTIFY_COMPLETED STREAM_NOTIFY_RESOLVE STREAM_NOTIFY_SEVERITY_INFO STREAM_NOTIFY_SEVERITY_WARN STREAM_NOTIFY_SEVERITY_ERR STREAM_FILTER_READ STREAM_FILTER_WRITE STREAM_FILTER_ALL STREAM_CLIENT_PERSISTENT STREAM_CLIENT_ASYNC_CONNECT STREAM_CLIENT_CONNECT STREAM_CRYPTO_METHOD_SSLv2_CLIENT STREAM_CRYPTO_METHOD_SSLv3_CLIENT STREAM_CRYPTO_METHOD_SSLv23_CLIENT STREAM_CRYPTO_METHOD_TLS_CLIENT STREAM_CRYPTO_METHOD_SSLv2_SERVER STREAM_CRYPTO_METHOD_SSLv3_SERVER STREAM_CRYPTO_METHOD_SSLv23_SERVER STREAM_CRYPTO_METHOD_TLS_SERVER STREAM_SHUT_RD STREAM_SHUT_WR STREAM_SHUT_RDWR STREAM_PF_INET STREAM_PF_INET6 STREAM_PF_UNIX STREAM_IPPROTO_IP STREAM_SOCK_STREAM STREAM_SOCK_DGRAM STREAM_SOCK_RAW STREAM_SOCK_SEQPACKET STREAM_SOCK_RDM STREAM_PEEK STREAM_OOB STREAM_SERVER_BIND STREAM_SERVER_LISTEN FILE_USE_INCLUDE_PATH FILE_IGNORE_NEW_LINES FILE_SKIP_EMPTY_LINES FILE_APPEND FILE_NO_DEFAULT_CONTEXT FILE_TEXT FILE_BINARY FNM_NOESCAPE FNM_PATHNAME FNM_PERIOD FNM_CASEFOLD PSFS_PASS_ON PSFS_FEED_ME PSFS_ERR_FATAL PSFS_FLAG_NORMAL PSFS_FLAG_FLUSH_INC PSFS_FLAG_FLUSH_CLOSE CRYPT_SALT_LENGTH CRYPT_STD_DES CRYPT_EXT_DES CRYPT_MD5 CRYPT_BLOWFISH CRYPT_SHA256 CRYPT_SHA512 DIRECTORY_SEPARATOR PATH_SEPARATOR SCANDIR_SORT_ASCENDING SCANDIR_SORT_DESCENDING SCANDIR_SORT_NONE GLOB_BRACE GLOB_MARK GLOB_NOSORT GLOB_NOCHECK GLOB_NOESCAPE GLOB_ERR GLOB_ONLYDIR GLOB_AVAILABLE_FLAGS LOG_EMERG LOG_ALERT LOG_CRIT LOG_ERR LOG_WARNING LOG_NOTICE LOG_INFO LOG_DEBUG LOG_KERN LOG_USER LOG_MAIL LOG_DAEMON LOG_AUTH LOG_SYSLOG LOG_LPR LOG_NEWS LOG_UUCP LOG_CRON LOG_AUTHPRIV LOG_PID LOG_CONS LOG_ODELAY LOG_NDELAY LOG_NOWAIT LOG_PERROR EXTR_OVERWRITE EXTR_SKIP EXTR_PREFIX_SAME EXTR_PREFIX_ALL EXTR_PREFIX_INVALID EXTR_PREFIX_IF_EXISTS EXTR_IF_EXISTS EXTR_REFS SORT_ASC SORT_DESC SORT_REGULAR SORT_NUMERIC SORT_STRING SORT_LOCALE_STRING SORT_NATURAL SORT_FLAG_CASE CASE_LOWER CASE_UPPER COUNT_NORMAL COUNT_RECURSIVE ASSERT_ACTIVE ASSERT_CALLBACK ASSERT_BAIL ASSERT_WARNING ASSERT_QUIET_EVAL STREAM_USE_PATH STREAM_IGNORE_URL STREAM_REPORT_ERRORS STREAM_MUST_SEEK STREAM_URL_STAT_LINK STREAM_URL_STAT_QUIET STREAM_MKDIR_RECURSIVE STREAM_IS_URL STREAM_OPTION_BLOCKING STREAM_OPTION_READ_TIMEOUT STREAM_OPTION_READ_BUFFER STREAM_OPTION_WRITE_BUFFER STREAM_BUFFER_NONE STREAM_BUFFER_LINE STREAM_BUFFER_FULL STREAM_CAST_AS_STREAM STREAM_CAST_FOR_SELECT STREAM_META_TOUCH STREAM_META_OWNER STREAM_META_OWNER_NAME STREAM_META_GROUP STREAM_META_GROUP_NAME STREAM_META_ACCESS IMAGETYPE_GIF IMAGETYPE_JPEG IMAGETYPE_PNG IMAGETYPE_SWF IMAGETYPE_PSD IMAGETYPE_BMP IMAGETYPE_TIFF_II IMAGETYPE_TIFF_MM IMAGETYPE_JPC IMAGETYPE_JP2 IMAGETYPE_JPX IMAGETYPE_JB2 IMAGETYPE_SWC IMAGETYPE_IFF IMAGETYPE_WBMP IMAGETYPE_JPEG2000 IMAGETYPE_XBM IMAGETYPE_ICO IMAGETYPE_UNKNOWN IMAGETYPE_COUNT DNS_A DNS_NS DNS_CNAME DNS_SOA DNS_PTR DNS_HINFO DNS_MX DNS_TXT DNS_SRV DNS_NAPTR DNS_AAAA DNS_A6 DNS_ANY DNS_ALL contained

" tokenizer
syn keyword phpConstants T_REQUIRE_ONCE T_REQUIRE T_EVAL T_INCLUDE_ONCE T_INCLUDE T_LOGICAL_OR T_LOGICAL_XOR T_LOGICAL_AND T_PRINT T_SR_EQUAL T_SL_EQUAL T_XOR_EQUAL T_OR_EQUAL T_AND_EQUAL T_MOD_EQUAL T_CONCAT_EQUAL T_DIV_EQUAL T_MUL_EQUAL T_MINUS_EQUAL T_PLUS_EQUAL T_BOOLEAN_OR T_BOOLEAN_AND T_IS_NOT_IDENTICAL T_IS_IDENTICAL T_IS_NOT_EQUAL T_IS_EQUAL T_IS_GREATER_OR_EQUAL T_IS_SMALLER_OR_EQUAL T_SR T_SL T_INSTANCEOF T_UNSET_CAST T_BOOL_CAST T_OBJECT_CAST T_ARRAY_CAST T_STRING_CAST T_DOUBLE_CAST T_INT_CAST T_DEC T_INC T_CLONE T_NEW T_EXIT T_IF T_ELSEIF T_ELSE T_ENDIF T_LNUMBER T_DNUMBER T_STRING T_STRING_VARNAME T_VARIABLE T_NUM_STRING T_INLINE_HTML T_CHARACTER T_BAD_CHARACTER T_ENCAPSED_AND_WHITESPACE T_CONSTANT_ENCAPSED_STRING T_ECHO T_DO T_WHILE T_ENDWHILE T_FOR T_ENDFOR T_FOREACH T_ENDFOREACH T_DECLARE T_ENDDECLARE T_AS T_SWITCH T_ENDSWITCH T_CASE T_DEFAULT T_BREAK T_CONTINUE T_GOTO T_FUNCTION T_CONST T_RETURN T_TRY T_CATCH T_THROW T_USE T_INSTEADOF T_GLOBAL T_PUBLIC T_PROTECTED T_PRIVATE T_FINAL T_ABSTRACT T_STATIC T_VAR T_UNSET T_ISSET T_EMPTY T_HALT_COMPILER T_CLASS T_TRAIT T_INTERFACE T_EXTENDS T_IMPLEMENTS T_OBJECT_OPERATOR T_DOUBLE_ARROW T_LIST T_ARRAY T_CALLABLE T_CLASS_C T_TRAIT_C T_METHOD_C T_FUNC_C T_LINE T_FILE T_COMMENT T_DOC_COMMENT T_OPEN_TAG T_OPEN_TAG_WITH_ECHO T_CLOSE_TAG T_WHITESPACE T_START_HEREDOC T_END_HEREDOC T_DOLLAR_OPEN_CURLY_BRACES T_CURLY_OPEN T_PAAMAYIM_NEKUDOTAYIM T_NAMESPACE T_NS_C T_DIR T_NS_SEPARATOR T_DOUBLE_COLON contained

" zlib
syn keyword phpConstants FORCE_GZIP FORCE_DEFLATE ZLIB_ENCODING_RAW ZLIB_ENCODING_GZIP ZLIB_ENCODING_DEFLATE contained

syn case ignore

" Core
syn keyword phpFunctions zend_version func_num_args func_get_arg func_get_args strlen strcmp strncmp strcasecmp strncasecmp each error_reporting define defined get_class get_called_class get_parent_class method_exists property_exists class_exists interface_exists trait_exists function_exists class_alias get_included_files get_required_files is_subclass_of is_a get_class_vars get_object_vars get_class_methods trigger_error user_error set_error_handler restore_error_handler set_exception_handler restore_exception_handler get_declared_classes get_declared_traits get_declared_interfaces get_defined_functions get_defined_vars create_function get_resource_type get_loaded_extensions extension_loaded get_extension_funcs get_defined_constants debug_backtrace debug_print_backtrace gc_collect_cycles gc_enabled gc_enable gc_disable contained
syn keyword phpClasses stdClass Traversable IteratorAggregate Iterator ArrayAccess Serializable Exception ErrorException Closure contained

" date
syn keyword phpFunctions strtotime date idate gmdate mktime gmmktime checkdate strftime gmstrftime time localtime getdate date_create date_create_from_format date_parse date_parse_from_format date_get_last_errors date_format date_modify date_add date_sub date_timezone_get date_timezone_set date_offset_get date_diff date_time_set date_date_set date_isodate_set date_timestamp_set date_timestamp_get timezone_open timezone_name_get timezone_name_from_abbr timezone_offset_get timezone_transitions_get timezone_location_get timezone_identifiers_list timezone_abbreviations_list timezone_version_get date_interval_create_from_date_string date_interval_format date_default_timezone_set date_default_timezone_get date_sunrise date_sunset date_sun_info contained
syn keyword phpClasses DateTime DateTimeZone DateInterval DatePeriod contained

" ereg
syn keyword phpFunctions ereg ereg_replace eregi eregi_replace split spliti sql_regcase contained
" hash
syn keyword phpFunctions hash hash_file hash_hmac hash_hmac_file hash_init hash_update hash_update_stream hash_update_file hash_final hash_copy hash_algos mhash_keygen_s2k mhash_get_block_size mhash_get_hash_name mhash_count mhash contained
" iconv
syn keyword phpFunctions iconv iconv_get_encoding iconv_set_encoding iconv_strlen iconv_substr iconv_strpos iconv_strrpos iconv_mime_encode iconv_mime_decode iconv_mime_decode_headers contained
" json
syn keyword phpFunctions json_encode json_decode json_last_error contained
syn keyword phpClasses JsonSerializable contained

" mbstring
syn keyword phpFunctions mb_convert_case mb_strtoupper mb_strtolower mb_language mb_internal_encoding mb_http_input mb_http_output mb_detect_order mb_substitute_character mb_parse_str mb_output_handler mb_preferred_mime_name mb_strlen mb_strpos mb_strrpos mb_stripos mb_strripos mb_strstr mb_strrchr mb_stristr mb_strrichr mb_substr_count mb_substr mb_strcut mb_strwidth mb_strimwidth mb_convert_encoding mb_detect_encoding mb_list_encodings mb_encoding_aliases mb_convert_kana mb_encode_mimeheader mb_decode_mimeheader mb_convert_variables mb_encode_numericentity mb_decode_numericentity mb_send_mail mb_get_info mb_check_encoding mb_regex_encoding mb_regex_set_options mb_ereg mb_eregi mb_ereg_replace mb_eregi_replace mb_ereg_replace_callback mb_split mb_ereg_match mb_ereg_search mb_ereg_search_pos mb_ereg_search_regs mb_ereg_search_init mb_ereg_search_getregs mb_ereg_search_getpos mb_ereg_search_setpos mbregex_encoding mbereg mberegi mbereg_replace mberegi_replace mbsplit mbereg_match mbereg_search mbereg_search_pos mbereg_search_regs mbereg_search_init mbereg_search_getregs mbereg_search_getpos mbereg_search_setpos contained
" mysql
syn keyword phpFunctions mysql_connect mysql_pconnect mysql_close mysql_select_db mysql_query mysql_unbuffered_query mysql_db_query mysql_list_dbs mysql_list_tables mysql_list_fields mysql_list_processes mysql_error mysql_errno mysql_affected_rows mysql_insert_id mysql_result mysql_num_rows mysql_num_fields mysql_fetch_row mysql_fetch_array mysql_fetch_assoc mysql_fetch_object mysql_data_seek mysql_fetch_lengths mysql_fetch_field mysql_field_seek mysql_free_result mysql_field_name mysql_field_table mysql_field_len mysql_field_type mysql_field_flags mysql_escape_string mysql_real_escape_string mysql_stat mysql_thread_id mysql_client_encoding mysql_ping mysql_get_client_info mysql_get_host_info mysql_get_proto_info mysql_get_server_info mysql_info mysql_set_charset mysql mysql_fieldname mysql_fieldtable mysql_fieldlen mysql_fieldtype mysql_fieldflags mysql_selectdb mysql_freeresult mysql_numfields mysql_numrows mysql_listdbs mysql_listtables mysql_listfields mysql_db_name mysql_dbname mysql_tablename mysql_table_name contained
" mysqli
syn keyword phpFunctions mysqli_affected_rows mysqli_autocommit mysqli_change_user mysqli_character_set_name mysqli_close mysqli_commit mysqli_connect mysqli_connect_errno mysqli_connect_error mysqli_data_seek mysqli_dump_debug_info mysqli_debug mysqli_errno mysqli_error mysqli_error_list mysqli_stmt_execute mysqli_execute mysqli_fetch_field mysqli_fetch_fields mysqli_fetch_field_direct mysqli_fetch_lengths mysqli_fetch_all mysqli_fetch_array mysqli_fetch_assoc mysqli_fetch_object mysqli_fetch_row mysqli_field_count mysqli_field_seek mysqli_field_tell mysqli_free_result mysqli_get_connection_stats mysqli_get_client_stats mysqli_get_charset mysqli_get_client_info mysqli_get_client_version mysqli_get_host_info mysqli_get_proto_info mysqli_get_server_info mysqli_get_server_version mysqli_get_warnings mysqli_init mysqli_info mysqli_insert_id mysqli_kill mysqli_more_results mysqli_multi_query mysqli_next_result mysqli_num_fields mysqli_num_rows mysqli_options mysqli_ping mysqli_poll mysqli_prepare mysqli_report mysqli_query mysqli_real_connect mysqli_real_escape_string mysqli_real_query mysqli_reap_async_query mysqli_rollback mysqli_select_db mysqli_set_charset mysqli_stmt_affected_rows mysqli_stmt_attr_get mysqli_stmt_attr_set mysqli_stmt_bind_param mysqli_stmt_bind_result mysqli_stmt_close mysqli_stmt_data_seek mysqli_stmt_errno mysqli_stmt_error mysqli_stmt_error_list mysqli_stmt_fetch mysqli_stmt_field_count mysqli_stmt_free_result mysqli_stmt_get_result mysqli_stmt_get_warnings mysqli_stmt_init mysqli_stmt_insert_id mysqli_stmt_more_results mysqli_stmt_next_result mysqli_stmt_num_rows mysqli_stmt_param_count mysqli_stmt_prepare mysqli_stmt_reset mysqli_stmt_result_metadata mysqli_stmt_send_long_data mysqli_stmt_store_result mysqli_stmt_sqlstate mysqli_sqlstate mysqli_ssl_set mysqli_stat mysqli_store_result mysqli_thread_id mysqli_thread_safe mysqli_use_result mysqli_warning_count mysqli_refresh mysqli_escape_string mysqli_set_opt contained
syn keyword phpClasses mysqli_sql_exception mysqli_driver mysqli mysqli_warning mysqli_result mysqli_stmt contained

" pcre
syn keyword phpFunctions preg_match preg_match_all preg_replace preg_replace_callback preg_filter preg_split preg_quote preg_grep preg_last_error contained
" session
syn keyword phpFunctions session_name session_module_name session_save_path session_id session_regenerate_id session_decode session_encode session_start session_destroy session_unset session_set_save_handler session_cache_limiter session_cache_expire session_set_cookie_params session_get_cookie_params session_write_close session_status session_register_shutdown session_commit contained
syn keyword phpClasses SessionHandlerInterface SessionHandler contained

" SimpleXML
syn keyword phpFunctions simplexml_load_file simplexml_load_string simplexml_import_dom contained
syn keyword phpClasses SimpleXMLElement SimpleXMLIterator contained

" standard
syn keyword phpFunctions constant bin2hex hex2bin sleep usleep time_nanosleep time_sleep_until flush wordwrap htmlspecialchars htmlentities html_entity_decode htmlspecialchars_decode get_html_translation_table sha1 sha1_file md5 md5_file crc32 iptcparse iptcembed getimagesize getimagesizefromstring image_type_to_mime_type image_type_to_extension phpinfo phpversion phpcredits php_logo_guid php_real_logo_guid php_egg_logo_guid zend_logo_guid php_sapi_name php_uname php_ini_scanned_files php_ini_loaded_file strnatcmp strnatcasecmp substr_count strspn strcspn strtok strtoupper strtolower strpos stripos strrpos strripos strrev hebrev hebrevc nl2br basename dirname pathinfo stripslashes stripcslashes strstr stristr strrchr str_shuffle str_word_count str_split strpbrk substr_compare strcoll substr substr_replace quotemeta ucfirst lcfirst ucwords strtr addslashes addcslashes rtrim str_replace str_ireplace str_repeat count_chars chunk_split trim ltrim strip_tags similar_text explode implode join setlocale localeconv soundex levenshtein chr ord parse_str str_getcsv str_pad chop strchr sprintf printf vprintf vsprintf fprintf vfprintf sscanf fscanf parse_url urlencode urldecode rawurlencode rawurldecode http_build_query linkinfo link unlink exec system escapeshellcmd escapeshellarg passthru shell_exec proc_open proc_close proc_terminate proc_get_status rand srand getrandmax mt_rand mt_srand mt_getrandmax getservbyname getservbyport getprotobyname getprotobynumber getmyuid getmygid getmypid getmyinode getlastmod base64_decode base64_encode convert_uuencode convert_uudecode abs ceil floor round sin cos tan asin acos atan atanh atan2 sinh cosh tanh asinh acosh expm1 log1p pi is_finite is_nan is_infinite pow exp log log10 sqrt hypot deg2rad rad2deg bindec hexdec octdec decbin decoct dechex base_convert number_format fmod inet_ntop inet_pton ip2long long2ip getenv putenv getopt microtime gettimeofday uniqid quoted_printable_decode quoted_printable_encode convert_cyr_string get_current_user set_time_limit header_register_callback get_cfg_var magic_quotes_runtime set_magic_quotes_runtime get_magic_quotes_gpc get_magic_quotes_runtime error_log error_get_last call_user_func call_user_func_array call_user_method call_user_method_array forward_static_call forward_static_call_array serialize unserialize var_dump var_export debug_zval_dump print_r memory_get_usage memory_get_peak_usage register_shutdown_function register_tick_function unregister_tick_function highlight_file show_source highlight_string php_strip_whitespace ini_get ini_get_all ini_set ini_alter ini_restore get_include_path set_include_path restore_include_path setcookie setrawcookie header header_remove headers_sent headers_list http_response_code connection_aborted connection_status ignore_user_abort parse_ini_file parse_ini_string is_uploaded_file move_uploaded_file gethostbyaddr gethostbyname gethostbynamel gethostname dns_check_record checkdnsrr dns_get_mx getmxrr dns_get_record intval floatval doubleval strval gettype settype is_null is_resource is_bool is_long is_float is_int is_integer is_double is_real is_numeric is_string is_array is_object is_scalar is_callable pclose popen readfile rewind rmdir umask fclose feof fgetc fgets fgetss fread fopen fpassthru ftruncate fstat fseek ftell fflush fwrite fputs mkdir rename copy tempnam tmpfile file file_get_contents file_put_contents stream_select stream_context_create stream_context_set_params stream_context_get_params stream_context_set_option stream_context_get_options stream_context_get_default stream_context_set_default stream_filter_prepend stream_filter_append stream_filter_remove stream_socket_client stream_socket_server stream_socket_accept stream_socket_get_name stream_socket_recvfrom stream_socket_sendto stream_socket_enable_crypto stream_socket_shutdown stream_socket_pair stream_copy_to_stream stream_get_contents stream_supports_lock fgetcsv fputcsv flock get_meta_tags stream_set_read_buffer stream_set_write_buffer set_file_buffer stream_set_chunk_size set_socket_blocking stream_set_blocking socket_set_blocking stream_get_meta_data stream_get_line stream_wrapper_register stream_register_wrapper stream_wrapper_unregister stream_wrapper_restore stream_get_wrappers stream_get_transports stream_resolve_include_path stream_is_local get_headers stream_set_timeout socket_set_timeout socket_get_status realpath fnmatch fsockopen pfsockopen pack unpack get_browser crypt opendir closedir chdir getcwd rewinddir readdir dir scandir glob fileatime filectime filegroup fileinode filemtime fileowner fileperms filesize filetype file_exists is_writable is_writeable is_readable is_executable is_file is_dir is_link stat lstat chown chgrp chmod touch clearstatcache disk_total_space disk_free_space diskfreespace realpath_cache_size realpath_cache_get mail ezmlm_hash openlog syslog closelog lcg_value metaphone ob_start ob_flush ob_clean ob_end_flush ob_end_clean ob_get_flush ob_get_clean ob_get_length ob_get_level ob_get_status ob_get_contents ob_implicit_flush ob_list_handlers ksort krsort natsort natcasesort asort arsort sort rsort usort uasort uksort shuffle array_walk array_walk_recursive count end prev next reset current key min max in_array array_search extract compact array_fill array_fill_keys range array_multisort array_push array_pop array_shift array_unshift array_splice array_slice array_merge array_merge_recursive array_replace array_replace_recursive array_keys array_values array_count_values array_reverse array_reduce array_pad array_flip array_change_key_case array_rand array_unique array_intersect array_intersect_key array_intersect_ukey array_uintersect array_intersect_assoc array_uintersect_assoc array_intersect_uassoc array_uintersect_uassoc array_diff array_diff_key array_diff_ukey array_udiff array_diff_assoc array_udiff_assoc array_diff_uassoc array_udiff_uassoc array_sum array_product array_filter array_map array_chunk array_combine array_key_exists pos sizeof key_exists assert assert_options version_compare str_rot13 stream_get_filters stream_filter_register stream_bucket_make_writeable stream_bucket_prepend stream_bucket_append stream_bucket_new output_add_rewrite_var output_reset_rewrite_vars sys_get_temp_dir contained
syn keyword phpClasses __PHP_Incomplete_Class php_user_filter Directory contained

" tokenizer
syn keyword phpFunctions token_get_all token_name contained
" zlib
syn keyword phpFunctions readgzfile gzrewind gzclose gzeof gzgetc gzgets gzgetss gzread gzopen gzpassthru gzseek gztell gzwrite gzputs gzfile gzcompress gzuncompress gzdeflate gzinflate gzencode gzdecode zlib_encode zlib_decode zlib_get_coding_type ob_gzhandler contained


" === END BUILTIN FUNCTIONS, CLASSES, AND CONSTANTS =====================================

" The following is needed afterall it seems.
syntax keyword phpClasses containedin=ALLBUT,phpComment,phpStringDouble,phpStringSingle,phpIdentifier,phpMethodsVar

" Control Structures
syn keyword  phpKeyword  contained if else elseif while do for foreach break
syn keyword  phpKeyword  contained switch case default continue return goto as
syn keyword  phpKeyword  contained endif endwhile endfor endforeach endswitch
syn keyword  phpKeyword  contained declare endeclare function 

" Class Keywords
syn keyword phpType contained class abstract extends interface implements
syn keyword phpType contained static final var public private protected const trait

" Magic Methods
syn keyword phpStatement contained __construct __destruct __call __callStatic
syn keyword phpStatement contained __get __set __isset __unset __sleep
syn keyword phpStatement contained __wakeup __toString __invoke __set_state __clone

" Exception Keywords
syn keyword phpKeyword try catch throw contained

" Language Constructs
syn keyword phpStatement exit eval unset list instanceof insteadof contained

" These special keywords have traditionally received special colors
syn keyword phpSpecial empty die isset echo print new clone contained
syn keyword phpSpecial self parent this contained

" Include & friends
syn keyword phpInclude include include_once require require_once namespace use contained

" Types
syn keyword phpType bool[ean] int[eger] real double float string array object callable contained
syn keyword phpClasses global stdClass contained

" Boolean
syn keyword phpBoolean  true false  contained
syn keyword phpConstant null contained

" Operator
syn match phpOperator       "[-=+%^&|*!.~?:]" contained display
syn match phpOperator       "[-+*/%^&|.]="  contained display
syn match phpOperator       "/[^*/]"me=e-1  contained display
syn match phpOperator       "\$"  contained display
syn match phpOperator       "&&\|\<and\>" contained display
syn match phpOperator       "||\|\<x\=or\>" contained display
syn match phpOperator       "[!=<>]=" contained display
syn match phpOperator       "[<>]"  contained display
syn match phpMemberSelector "->"  contained display
syn match phpVarSelector    "\$"  contained display
" highlight object variables inside strings
syn match phpMethodsVar     "->\h\w*" contained contains=phpMethods,phpMemberSelector display containedin=phpStringDouble

" Identifier
syn match  phpIdentifier         "$\h\w*"  contained contains=phpEnvVar,phpIntVar,phpVarSelector display
syn match  phpIdentifierSimply   "${\h\w*}"  contains=phpOperator,phpParent  contained display
syn region phpIdentifierComplex  matchgroup=phpParent start="{\$"rs=e-1 end="}"  contains=phpIdentifier,phpMemberSelector,phpVarSelector,phpIdentifierArray contained extend
syn region phpIdentifierArray    matchgroup=phpParent start="\[" end="]" contains=@phpClInside contained

" Number
syn match phpNumber "-\=\<\d\+\>" contained display
syn match phpNumber "\<0x\x\{1,8}\>"  contained display
syn match phpNumber "\<0b[01]\+\>"    contained display

" Float
syn match phpNumber "\(-\=\<\d+\|-\=\)\.\d\+\>" contained display

" SpecialChar
syn match phpSpecialChar "\\[fnrtv\\]" contained display
syn match phpSpecialChar "\\\d\{3}"  contained contains=phpOctalError display
syn match phpSpecialChar "\\x\x\{2}" contained display
" corrected highlighting for an escaped '\$' inside a double-quoted string
syn match phpSpecialChar "\\\$"  contained display
syn match phpSpecialChar +\\"+   contained display
syn match phpStrEsc      "\\\\"  contained display
syn match phpStrEsc      "\\'"   contained display

" Adding format specifiers to the 'SpecialChar' category:
syn match phpSpecialChar display contained /%\(\d\+\$\)\=[-+' #0*]*\(\d*\|\*\|\*\d\+\$\)\(\.\(\d*\|\*\|\*\d\+\$\)\)\=\([aAbBdiouxXDOUfFeEgGcCsSpnmMyYhH]\|\[\^\=.[^]]*\]\)/ containedin=phpStringDouble,phpHereDoc
syn match phpSpecialChar display contained /%%/ containedin=phpStringDouble,phpHereDoc

" Error
syn match phpOctalError "[89]"  contained display
if exists("php_parent_error_close")
  syn match phpParentError "[)\]}]"  contained display
endif

" Todo
syn keyword phpTodo todo fixme xxx note contained

" Comment
if exists("php_parent_error_open")
  syn region phpComment start="/\*" end="\*/" contained contains=phpTodo,@Spell
else
  syn region phpComment start="/\*" end="\*/" contained contains=phpTodo,@Spell extend
endif
" if version >= 600
  syn match phpComment  "#.\{-}\(?>\|$\)\@="  contained contains=phpTodo,@Spell
  syn match phpComment  "//.\{-}\(?>\|$\)\@=" contained contains=phpTodo,@Spell
" else
"   syn match phpComment  "#.\{-}$" contained contains=phpTodo,@Spell
"   syn match phpComment  "#.\{-}?>"me=e-2  contained contains=phpTodo,@Spell
"   syn match phpComment  "//.\{-}$"  contained contains=phpTodo,@Spell
"   syn match phpComment  "//.\{-}?>"me=e-2 contained contains=phpTodo,@Spell
" endif

" String
if exists("php_parent_error_open")
  syn region phpStringDouble start=+"+ skip=+\\\\\|\\"+ end=+"+  contains=@Spell,@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex,phpStrEsc contained keepend
  syn region phpBacktick start=+`+ skip=+\\\\\|\\"+ end=+`+  contains=@Spell,@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex,phpStrEsc contained keepend
  syn region phpStringSingle start=+'+ skip=+\\\\\|\\'+ end=+'+  contains=@Spell,@phpAddStrings,phpStrEsc contained keepend
else
  syn region phpStringDouble start=+"+ skip=+\\\\\|\\"+ end=+"+  contains=@Spell,@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex,phpStrEsc contained extend keepend
  syn region phpBacktick start=+`+ skip=+\\\\\|\\"+ end=+`+  contains=@Spell,@phpAddStrings,phpIdentifier,phpSpecialChar,phpIdentifierSimply,phpIdentifierComplex,phpStrEsc contained extend keepend
  syn region phpStringSingle start=+'+ skip=+\\\\\|\\'+ end=+'+  contains=@Spell,@phpAddStrings,phpStrEsc contained keepend extend
endif

" HereDoc
syn case match
syn region phpHereDoc matchgroup=Delimiter start="\(<<<\)\@<=\z(\I\i*\)$" end="^\z1\(;\=$\)\@=" contained contains=@Spell,phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar,phpStrEsc keepend extend
syn region phpHereDoc matchgroup=Delimiter start=+\(<<<\)\@<="\z(\I\i*\)"$+ end="^\z1\(;\=$\)\@=" contained contains=@Spell,phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar,phpStrEsc keepend extend
" including HTML,JavaScript,SQL even if not enabled via options
if exists('php_html_in_strings') && php_html_in_strings == 1
  syn region phpHereDoc matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(html\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@="  contained contains=@htmlTop,phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar,phpStrEsc keepend extend
  syn region phpHereDoc matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(javascript\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@="  contained contains=@htmlJavascript,phpIdentifierSimply,phpIdentifier,phpIdentifierComplex,phpSpecialChar,phpMethodsVar,phpStrEsc keepend extend
endif

if exists('php_sql_query') && php_sql_query == 1
  syn region phpHereDoc matchgroup=Delimiter start="\(<<<\)\@<=\z(\(\I\i*\)\=\(sql\)\c\(\i*\)\)$" end="^\z1\(;\=$\)\@=" contained contains=@sqlTop,phpIdentifier,phpIdentifierSimply,phpIdentifierComplex,phpSpecialChar,phpMethodsVar,phpStrEsc keepend extend
endif
syn case ignore

" NowDoc
syn region phpNowDoc matchgroup=Delimiter start=+\(<<<\)\@<='\z(\I\i*\)'$+ end="^\z1\(;\=$\)\@=" contained keepend extend

" Parent
if exists("php_parent_error_close") || exists("php_parent_error_open")
  syn match  phpParent "[{}]"  contained
  syn region phpParent matchgroup=Delimiter start="(" end=")"  contained contains=@phpClInside transparent
  syn region phpParent matchgroup=Delimiter start="\[" end="\]"  contained contains=@phpClInside transparent
  if !exists("php_parent_error_close")
    syn match phpParent "[\])]" contained
  endif
else
  syn match phpParent "[({[\]})]" contained
endif

" Clusters
syn cluster phpClConst contains=phpFunctions,phpClasses,phpIdentifier,phpStatement,phpOperator,phpStringSingle,phpStringDouble,phpBacktick,phpNumber,phpType,phpBoolean,phpStructure,phpMethodsVar,phpConstants,phpException,phpSuperglobals,phpMagicConstants,phpServerVars
syn cluster phpClInside contains=@phpClConst,phpComment,phpParent,phpParentError,phpInclude,phpHereDoc,phpNowDoc
syn cluster phpClFunction contains=@phpClInside,phpDefine,phpParentError,phpStorageClass,phpSpecial
syn cluster phpClTop contains=@phpClFunction,phpFoldFunction,phpFoldClass,phpFoldInterface,phpFoldTry,phpFoldCatch

" Php Region
if exists("php_parent_error_open")
  syn region phpRegion matchgroup=Delimiter start="<?\(php\)\=" end="?>" contains=@phpClTop
else
  syn region phpRegion matchgroup=Delimiter start="<?\(php\)\=" end="?>" contains=@phpClTop keepend
endif

" Fold
if exists("php_folding") && php_folding==1
" match one line constructs here and skip them at folding
  syn keyword phpSCKeyword  abstract final private protected public static  contained
  syn keyword phpFCKeyword  function  contained
  syn match phpDefine "\(\s\|^\)\(abstract\s\+\|final\s\+\|private\s\+\|protected\s\+\|public\s\+\|static\s\+\)*function\(\s\+.*[;}]\)\@="  contained contains=phpSCKeyword
  syn match phpStructure "\(\s\|^\)\(abstract\s\+\|final\s\+\)*class\(\s\+.*}\)\@="  contained
  syn match phpStructure "\(\s\|^\)interface\(\s\+.*}\)\@="  contained
  syn match phpException "\(\s\|^\)try\(\s\+.*}\)\@="  contained
  syn match phpException "\(\s\|^\)catch\(\s\+.*}\)\@="  contained

  set foldmethod=syntax
  syn region phpFoldHtmlInside matchgroup=Delimiter start="?>" end="<?\(php\)\=" contained transparent contains=@htmlTop
  syn region phpFoldFunction matchgroup=Storageclass start="^\z(\s*\)\(abstract\s\+\|final\s\+\|private\s\+\|protected\s\+\|public\s\+\|static\s\+\)*function\s\([^};]*$\)\@="rs=e-9 matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldHtmlInside,phpFCKeyword contained transparent fold extend
  syn region phpFoldFunction matchgroup=Define start="^function\s\([^};]*$\)\@=" matchgroup=Delimiter end="^}" contains=@phpClFunction,phpFoldHtmlInside contained transparent fold extend
  syn region phpFoldClass matchgroup=Structure start="^\z(\s*\)\(abstract\s\+\|final\s\+\)*class\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction,phpSCKeyword contained transparent fold extend
  syn region phpFoldInterface matchgroup=Structure start="^\z(\s*\)interface\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction contained transparent fold extend
  syn region phpFoldCatch matchgroup=Exception start="^\z(\s*\)catch\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction contained transparent fold extend
  syn region phpFoldTry matchgroup=Exception start="^\z(\s*\)try\s\+\([^}]*$\)\@=" matchgroup=Delimiter end="^\z1}" contains=@phpClFunction,phpFoldFunction contained transparent fold extend
elseif exists("php_folding") && php_folding==2
  set foldmethod=syntax
  syn region phpFoldHtmlInside matchgroup=Delimiter start="?>" end="<?\(php\)\=" contained transparent contains=@htmlTop
  syn region phpParent matchgroup=Delimiter start="{" end="}"  contained contains=@phpClFunction,phpFoldHtmlInside transparent fold
endif

" Sync
if php_sync_method==-1
  syn sync match phpRegionSync grouphere phpRegion "^\s*<?\(php\)\=\s*$"
  syn sync match phpRegionSync grouphere NONE "^\s*?>\s*$"
  syn sync match phpRegionSync grouphere NONE "^\s*%>\s*$"
  syn sync match phpRegionSync grouphere phpRegion "function\s.*(.*\$"
elseif php_sync_method>0
  exec "syn sync minlines=" . php_sync_method
else
  syn sync fromstart
endif

" Define the default highlighting.
" For version 5.8 and later: only when an item doesn't have highlighting yet
if !exists("did_php_syn_inits")

  hi def link phpComment          Comment
  hi def link phpSuperglobals     Constant
  hi def link phpMagicConstants   Constant
  hi def link phpServerVars       Constant
  hi def link phpConstants        Constant
  hi def link phpBoolean          Constant
  hi def link phpNumber           Number
  hi def link phpStringSingle     String
  hi def link phpStringDouble     String
  hi def link phpBacktick         String
  hi def link phpHereDoc          String
  hi def link phpNowDoc           String
  hi def link phpFunctions        Function
  hi def link phpClasses          StorageClass
  hi def link phpMethods          Function
  hi def link phpIdentifier       Identifier
  hi def link phpIdentifierSimply Identifier
  hi def link phpStatement        Statement
  hi def link phpStructure        Statement
  hi def link phpException        StorageClass
  hi def link phpOperator         Operator
  hi def link phpVarSelector      Operator
  hi def link phpInclude          PreProc
  hi def link phpDefine           PreProc
  hi def link phpSpecial          Special
  hi def link phpKeyword          Keyword
  hi def link phpFCKeyword        Keyword
  hi def link phpType             Type
  hi def link phpSCKeyword        Keyword
  hi def link phpMemberSelector   Operator
  hi def link phpSpecialChar      SpecialChar
  hi def link phpStrEsc           SpecialChar
  hi def link phpParent           Special
  hi def link phpParentError      Error
  hi def link phpOctalError       Error
  hi def link phpTodo             Todo

endif

let b:current_syntax = "php"

if main_syntax == 'php'
  unlet main_syntax
endif

" vim: ts=8 sts=2 sw=2 expandtab
