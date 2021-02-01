#!/bin/bash

#-------------
# Example
# To use the default configuration which may work well in most cases.
#-------------

. ../../src/simpleLog4sh.source


# different log level
# check result at /tmp/simpleLog4sh/${date}/simpleLog4sh_root.log
logTrace "logTrace"
logInfo "logInfo"
logDebug "logDebug"
logError "logError"
logWarn "logWarn"

# Thiese will appear on console as well as in log file
logEcho "logEcho"
logEchoError "logEchoError"

# throw an exception. any code afterwards is not reached
throw "Exception"

echo "This is unreachable."