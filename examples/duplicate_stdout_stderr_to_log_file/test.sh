#!/bin/bash

#-------------
# Example
# In this example, any stdout or stderr will duplicate to a log file
# It is helpful when you want to collect output of other commands
#-------------

. ../../src/simpleLog4sh.source ./simpleLog4sh.cfg

# stdout of this command will be also collected in log file: /tmp/simpleLog4sh/${date}/simpleLog4sh_root.out
uptime

# stderr of this command will be also collected in log file: /tmp/simpleLog4sh/${date}/simpleLog4sh_root.err
not_fund_command

# logEcho logEchoError is also duplicated
logEcho "logEcho something"

# logEcho logEchoError is also duplicated
logEchoError "logEchoError something"