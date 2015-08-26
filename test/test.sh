##################################
# 简单shell日志工具 测试
# author maoshuai  http://imshuai.com
# 
##################################

# 导入simplelog4sh.sh
. ../src/simplelog4sh.sh

# 调用方法
logInfo hello, world
logDebug "hello, logDebug"
logInfo "hello, logInfo"
logWarn "hello, logWarn"
logError "hello, logError"

myEcho "hello, myEcho"
myEchoError "hello, myEchoError"

throw "Arguments Number Error"
