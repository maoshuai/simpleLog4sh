#---------------
# Simple log for shell
# author: maoshuai
#---------------

# source only once
if [ "${_simpleLog4sh_sourced}" ]; then
        return
fi
_simpleLog4sh_sourced=1


####################### methods for client code

# refresh log name, client can call this method to switch log name
refreshLogger(){
	export LOGGER_NAME="$1"
	setStd
}

# print error message and exit
throw()
{
	if [ $# -ne 0 ];then
		logEchoError "$@"
		logError "$@"
	fi  
  	exit 1
}

# keep an copy of echo message
logEcho()
{
	echo "$@"
	_doLog "ECHO " $simpleLog4sh_LOG_LEVEL_NUM_OFF "$@"

}

# keep an copy of error message
logEchoError()
{
	echo "(ERROR)" "$@" >&2
	_doLog "ECHO_ERROR" $simpleLog4sh_LOG_LEVEL_NUM_OFF "$@"
}

logTrace()
{	
	_doLog "TRACE" $simpleLog4sh_LOG_LEVEL_NUM_TRACE "$@"
}

logDebug()
{	
	_doLog "DEBUG" $simpleLog4sh_LOG_LEVEL_NUM_DEBUG "$@"
}

logInfo()
{
	_doLog "INFO " $simpleLog4sh_LOG_LEVEL_NUM_INFO "$@"
}

logWarn()
{
	_doLog "WARN" $simpleLog4sh_LOG_LEVEL_NUM_WARN "$@"
}

logError()
{
	_doLog "ERROR" $simpleLog4sh_LOG_LEVEL_NUM_ERROR "$@"
}

#
##############################
	
simpleLog4sh_main(){


	# setting default configurations:
	# root directory for log files:
	simpleLog4sh_LOG_DIR="/tmp/simpleLog4sh"
	# log level
	simpleLog4sh_LOG_LEVEL="ALL"
	# prfeix name of log files
	simpleLog4sh_LOG_FILE_NAME_PREFIX="simpleLog4sh"
	# control the maximum number (in days) of archive files to keep (default: -1, keep all)
	simpleLog4sh_MAX_HISTORY=-1
	# suffix name of log files
	simpleLog4sh_LOG_FILE_NAME_SUFFIX=".log"
	# suffix name of stdout log
	# keep it empty if you don't want to redirect stdout
	simpleLog4sh_LOG_STDOUT_SUFFIX=""
	# keep stdout on console when redirect stdout (defult: true)
	# e.g. stdout will appear both on console and log file.
	# set false if don't keep on console
	simpleLog4sh_LOG_STDOUT_KEEP_CONSOLE="true"
	# suffix name of stderr log
	# keep it empty if you don't want to redirect stderr
	simpleLog4sh_LOG_STDERR_SUFFIX=""
	# keep stderr on console when redirect stderr (defult: true)
	# e.g. stderr will appear both on console and log file.
	# set false if don't keep on console
	simpleLog4sh_LOG_STDERR_KEEP_CONSOLE="true"
	# show full call path of functions
	simpleLog4sh_LOG_FULL_CALLPATH="false"

	# load configuration file if it is provided.
	cfgFile=$1
	if [ x"$cfgFile" != "x" ];then
		if [ -f $cfgFile ];then
			. $cfgFile
		fi
	fi
	# loading configuration is complete now

	# ensure the output directory is writable
	if [ -d $simpleLog4sh_LOG_DIR ];then
		if [ ! -w $simpleLog4sh_LOG_DIR ];then
			echo "simpleLog4sh_LOG_DIR is not writeable directory: $simpleLog4sh_LOG_DIR" >&2
			exit 1
		fi
	fi

	# log level number
	simpleLog4sh_LOG_LEVEL_NUM_ALL=-9000
	simpleLog4sh_LOG_LEVEL_NUM_TRACE=50
	simpleLog4sh_LOG_LEVEL_NUM_DEBUG=100
	simpleLog4sh_LOG_LEVEL_NUM_INFO=200
	simpleLog4sh_LOG_LEVEL_NUM_WARN=300
	simpleLog4sh_LOG_LEVEL_NUM_ERROR=400
	simpleLog4sh_LOG_LEVEL_NUM_OFF=9000

	# interpret the human readable log level name to correspondent log level number
	if [ x$simpleLog4sh_LOG_LEVEL = x"ALL" ];then
		simpleLog4sh_LOG_LEVEL_NUM=$simpleLog4sh_LOG_LEVEL_NUM_ALL
	elif [ x$simpleLog4sh_LOG_LEVEL = x"TRACE" ];then
		simpleLog4sh_LOG_LEVEL_NUM=$simpleLog4sh_LOG_LEVEL_NUM_TRACE
	elif [ x$simpleLog4sh_LOG_LEVEL = x"DEBUG" ];then
		simpleLog4sh_LOG_LEVEL_NUM=$simpleLog4sh_LOG_LEVEL_NUM_DEBUG
	elif [ x$simpleLog4sh_LOG_LEVEL = x"INFO" ];then
		simpleLog4sh_LOG_LEVEL_NUM=$simpleLog4sh_LOG_LEVEL_NUM_INFO
	elif [ x$simpleLog4sh_LOG_LEVEL = x"WARN" ];then
		simpleLog4sh_LOG_LEVEL_NUM=$simpleLog4sh_LOG_LEVEL_NUM_WARN
	elif [ x$simpleLog4sh_LOG_LEVEL = x"ERROR" ];then
		simpleLog4sh_LOG_LEVEL_NUM=$simpleLog4sh_LOG_LEVEL_NUM_ERROR
	elif [ x$simpleLog4sh_LOG_LEVEL = x"OFF" ];then
		simpleLog4sh_LOG_LEVEL_NUM=$simpleLog4sh_LOG_LEVEL_NUM_OFF
	else 
		# by default, log level is ALL
		simpleLog4sh_LOG_LEVEL_NUM=$simpleLog4sh_LOG_LEVEL_NUM_ALL
	fi



	# setting default log name, which may be override lately
	defaultLoggerName="root"

	# redirect stdout and stderr
	setStd

	# remove old logs
	_log_removeStaleLogs

}

# redirect stdout and stderr
setStd(){
	if [ x"$simpleLog4sh_LOG_STDOUT_SUFFIX" != "x" ];then
		if [ x"$simpleLog4sh_LOG_STDOUT_KEEP_CONSOLE" != x"false" ];then
			exec > >(tee -a $(_getCurrentStdOutFile))
		else
			exec >>$(_getCurrentStdOutFile)
		fi
	fi
	if [ x"$simpleLog4sh_LOG_STDERR_SUFFIX" != "x" ];then
		if [ x"$simpleLog4sh_LOG_STDERR_KEEP_CONSOLE" != x"false" ];then
			exec 2> >(tee -a $(_getCurrentStdErrFile))
		else
			exec 2>>$(_getCurrentStdErrFile)
		fi
	fi
}





# get log file name by date
_getCurrentLogFile()
{
	local logDate=$(date +"%Y%m%d")
	if [ ! -e $simpleLog4sh_LOG_DIR/$logDate ];then
		mkdir -p $simpleLog4sh_LOG_DIR/$logDate
	fi 
	
	local todayLogFile=$simpleLog4sh_LOG_DIR/$logDate/${simpleLog4sh_LOG_FILE_NAME_PREFIX}_$(_getLoggerName)${simpleLog4sh_LOG_FILE_NAME_SUFFIX}
	if [ ! -e $todayLogFile ];then
		touch $todayLogFile
	fi 
	echo $todayLogFile
}

_getLoggerName(){
	loggerName=$
	if [ "x$LOGGER_NAME" = "x" ];then
		echo "$defaultLoggerName"
	else
		echo "$LOGGER_NAME"
	fi
}



# get stdout log file name by date
_getCurrentStdOutFile()
{
	local logDate=$(date +"%Y%m%d")
	if [ ! -e $simpleLog4sh_LOG_DIR/$logDate ];then
		mkdir -p $simpleLog4sh_LOG_DIR/$logDate
	fi 
	
	local todayLogFile=$simpleLog4sh_LOG_DIR/$logDate/${simpleLog4sh_LOG_FILE_NAME_PREFIX}_$(_getLoggerName)${simpleLog4sh_LOG_STDOUT_SUFFIX}
	if [ ! -e $todayLogFile ];then
		touch $todayLogFile
	fi 
	echo $todayLogFile
}

# get stederr log file name by date
_getCurrentStdErrFile()
{
	local logDate=$(date +"%Y%m%d")
	if [ ! -e $simpleLog4sh_LOG_DIR/$logDate ];then
		mkdir -p $simpleLog4sh_LOG_DIR/$logDate
	fi 
	
	local todayLogFile=$simpleLog4sh_LOG_DIR/$logDate/${simpleLog4sh_LOG_FILE_NAME_PREFIX}_$(_getLoggerName)${simpleLog4sh_LOG_STDERR_SUFFIX}
	if [ ! -e $todayLogFile ];then
		touch $todayLogFile
	fi 
	echo $todayLogFile
}

# get call function path
_getCallPath(){
	if [ "x$simpleLog4sh_LOG_FULL_CALLPATH" == "xtrue" ];then
		local len=${#FUNCNAME[@]}
		let "len=len-2"
		local callPath=""
		while [ $len -ge 3 ];do
			if [ "x$callPath" == "x" ];then
				callPath="${FUNCNAME[$len]}"
			else
				callPath="$callPath.${FUNCNAME[$len]}"
			fi
			let "len=len-1"
		done
		echo "$callPath"
	else
		echo "${FUNCNAME[3]}"
	fi

}

# inner methdo called by all logXXX function
_doLog(){
	local levelName="$1"
	local levelNum="$2"
	shift 2
	if [ $simpleLog4sh_LOG_LEVEL_NUM -le $levelNum ];then
		timestamp="$(date +%Y-%m-%d\ %H:%M:%S)"
		echo "$timestamp [$(_getCallPath)] ($levelName)  $@" >> `_getCurrentLogFile`
	fi
}

# remove stale logs xx days before
_log_removeStaleLogs(){
	# empty or non-positive inidcate keep all logs
	if [ x"$simpleLog4sh_MAX_HISTORY" == x"" ];then
		return
	fi
	if [ $simpleLog4sh_MAX_HISTORY -lt 0 ];then
		return
	fi

	# we don't clean too old log files
	# e.g. each time we clean log files generated simpleLog4sh_MAX_HISTORY to simpleLog4sh_MAX_HISTORY+graceDay  days before
	local graceDay=7

	local numberOfBackDate=$simpleLog4sh_MAX_HISTORY	

	while [ $graceDay -ge 0 ];do
		numberOfBackDate=$((numberOfBackDate+1))
		graceDay=$((graceDay-1))
		local dateDir=$(date -d "-$numberOfBackDate day"  "+%Y%m%d")
		if [ -d "$simpleLog4sh_LOG_DIR/$dateDir" ];then
			logTrace "delete stale log: $simpleLog4sh_LOG_DIR/$dateDir"
			rm -rf  "$simpleLog4sh_LOG_DIR/$dateDir"
		fi	
	done
}



simpleLog4sh_main "$@"