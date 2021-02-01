#!/bin/bash

#-------------
# Example
# In this example, any stdout or stderr will redirect to log file only
# In the console, you will see no output as if nothing happened.
#-------------
. ../../src/simpleLog4sh.source ./simpleLog4sh.cfg

# stdout of this command will not shown in console but in log file: /tmp/simpleLog4sh/${date}/simpleLog4sh_root.out
uptime

# stderr of this command wwil not shown in console but in log file: /tmp/simpleLog4sh/${date}/simpleLog4sh_root.err
not_fund_command

# logEcho logEchoError also disappeared in console
logEcho "logEcho something"

# logEcho logEchoError also disappeared in console
logEchoError "logEchoError something"