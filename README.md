# SimpleLog4sh

![Log file screenshot](doc/img/header.png)

# Introduction

**simpleLog4sh** is an extremely simple shell logging framework — so simple that it shouldn't even be called a logging framework. It's lightweight yet practical: **just a few hundred lines of pure shell script with zero dependencies**.

**simpleLog4sh** doesn't aim to be as complex as Apache logging frameworks, but it can significantly enhance your shell script logging experience and free you from tedious echo statements.

Through simple encapsulation, this small shell script can accomplish the following features:

1. Multi-level logging output (`logInfo`, `logDebug`, `logWarn`, `logError`) with configurable log level filtering
2. Automatic log file rotation by date with automatic cleanup
3. Log entries include timestamps, log levels, and function call chains
4. Capture stdout/stderr — third-party command output can be duplicated or redirected to log files
5. `throw` statement for exception-like error handling

Easy to get started and follows familiar patterns:

```bash
logInfo "hello, world"
logDebug "hello, world"  # Recommended to wrap all content in double quotes
```

Example output:

```
2015-08-26 20:12:21 [test.sh] (INFO) hello, world
2015-08-26 20:12:21 [test.sh] (DEBUG) hello, world
```

[中文版本](README_zh.md)

# Usage Examples

## Importing simpleLog4sh

Import at the beginning of your shell script. Refer to the usage in `/examples/quickstart`:

```bash
. ../src/simpleLog4sh.source
```

If you need to override default configuration, provide a config file (refer to the cfg file provided in source code):

```bash
. ../src/simpleLog4sh.source ../src/simpleLog4sh.cfg
```

## `logXXX` Statements

simpleLog4sh provides four log level methods:

1. `logDebug`
2. `logInfo` 
3. `logWarn`
4. `logError`

Usage is straightforward — all parameters are treated as log content:

```bash
logInfo "hello, world"
logDebug "hello, world"  # Recommended to wrap all content in double quotes
```

Example output (default output to `/tmp/simpleLog4sh` directory):

```
2015-08-26 20:03:18 [test.sh] (INFO) hello, this logInfo
2015-08-26 20:12:21 [test.sh] (DEBUG) hello, logDebug
2015-08-26 20:12:21 [test.sh] (INFO) hello, logInfo
2015-08-26 20:12:21 [test.sh] (WARN) hello, logWarn
2015-08-26 20:12:21 [test.sh] (ERROR) hello, logError
2015-08-26 20:12:21 [test.sh] (ECHO) hello, myEcho
2015-08-26 20:12:21 [test.sh] (ECHO_ERROR) hello, myEchoError
2015-08-26 20:13:26 [test.sh] (DEBUG) hello, logDebug
```

## Setting Log Levels

simpleLog4sh supports 6 log levels, similar to Apache logging framework:

1. `ALL`
2. `DEBUG`
3. `INFO`
4. `WARN`
5. `ERROR`
6. `OFF`

To set a specific log level, load a configuration file after importing simpleLog4sh, and set the `simpleLog4sh_LOG_LEVEL` variable in the config file with one of the following values:

```
ALL
DEBUG
INFO
WARN
ERROR
OFF
```

## `throw` Statement

The `throw` statement works similarly to Java's exception throwing. Using `throw` achieves exception-like behavior:

```bash
throw "ParamsNumberException: need 2 params"
```

When using `throw`, the program outputs the statement to stderr, logs it as `LOG_LEVEL_ERROR` in the log file, and exits with exit code 1.

## `logEcho` and `logEchoError` Statements

`logEcho` and `logEchoError` are similar to shell's `echo` statement but with two enhancements:

1. Both output to console AND log file
2. `logEchoError` outputs to stderr

## Log Path and Log File Rotation

By default, log output path is `/tmp/simpleLog4sh`, and log files are created with current date naming, similar to:

```
-rw-r--r--  1 maoshuai  wheel  1839  8 25 23:48 log_20150825.log
-rw-r--r--  1 maoshuai  wheel  1839  8 26 20:32 log_20150826.log
```

You can customize the log directory by loading a configuration file and modifying the `simpleLog4sh_LOG_DIR` variable.