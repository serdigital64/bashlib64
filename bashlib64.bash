#!/usr/bin/env bash
#######################################
# BashLib64
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 2.1.0
#######################################

# Do not inherit aliases and commands
unset -f unalias
\unalias -a
unset -f command

# Normalize shtop defaults
shopt -qu \
  'dotglob' \
  'extdebug' \
  'failglob' \
  'globstar' \
  'gnu_errfmt' \
  'huponexit' \
  'lastpipe' \
  'login_shell' \
  'nocaseglob' \
  'nocasematch' \
  'nullglob' \
  'xpg_echo'
shopt -qs \
  'extquote'

#######################################
# BashLib64 / Setup script run-time environment
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.6.0
#######################################

# Declare imported variables
export LANG
export LC_ALL
export LANGUAGE
export TERM

# Set Command flag (On/Off)
export BL64_LIB_CMD="${BL64_LIB_CMD:-0}"

# Set Verbosity flag (On/Off)
export BL64_LIB_VERBOSE="${BL64_LIB_VERBOSE:-1}"

# Set Debug flag (On/Off)
export BL64_LIB_DEBUG="${BL64_LIB_DEBUG:-0}"

# Set Strict flag (On/Off)
export BL64_LIB_STRICT="${BL64_LIB_STRICT:-1}"

# Set Traps flag (On/Off)
export BL64_LIB_TRAPS="${BL64_LIB_TRAPS:-1}"

# Set Normalize locale flag
export BL64_LIB_LANG="${BL64_LIB_LANG:-1}"

# Set Signal traps
declare BL64_LIB_SIGNAL_HUP="${BL64_LIB_SIGNAL_HUP:--}"
declare BL64_LIB_SIGNAL_STOP="${BL64_LIB_SIGNAL_STOP:--}"
declare BL64_LIB_SIGNAL_QUIT="${BL64_LIB_SIGNAL_QUIT:--}"
declare BL64_LIB_SIGNAL_DEBUG="${BL64_LIB_SIGNAL_DEBUG:--}"
declare BL64_LIB_SIGNAL_ERR="${BL64_LIB_SIGNAL_ERR:--}"
declare BL64_LIB_SIGNAL_EXIT="${BL64_LIB_SIGNAL_EXIT:-bl64_dbg_runtime_show}"

# Capture script name
declare BL64_SCRIPT_NAME="${BL64_SCRIPT_NAME:-${0##*/}}"

# Capture script path
declare BL64_SCRIPT_PATH=''

# Define session ID for the current script
declare BL64_SCRIPT_SID="${BASHPID}"

#
# Common values
#

# Default value for parameters
readonly BL64_LIB_DEFAULT='_'

# Pseudo null value
readonly BL64_LIB_VAR_NULL='__'

# Pseudo logical values
readonly BL64_LIB_VAR_TRUE='0'
readonly BL64_LIB_VAR_FALSE='1'
readonly BL64_LIB_VAR_ON='1'
readonly BL64_LIB_VAR_OFF='0'
readonly BL64_LIB_VAR_OK='0'

#
# Common error codes
#

# Parameters
declare -rig BL64_LIB_ERROR_PARAMETER_INVALID=3
declare -rig BL64_LIB_ERROR_PARAMETER_MISSING=4
declare -rig BL64_LIB_ERROR_PARAMETER_RANGE=5
declare -rig BL64_LIB_ERROR_PARAMETER_EMPTY=6

# Function operation
declare -rig BL64_LIB_ERROR_TASK_FAILED=10
declare -rig BL64_LIB_ERROR_TASK_BACKUP=11
declare -rig BL64_LIB_ERROR_TASK_RESTORE=12
declare -rig BL64_LIB_ERROR_TASK_TEMP=13
declare -rig BL64_LIB_ERROR_TASK_UNDEFINED=14

# Module operation
declare -rig BL64_LIB_ERROR_MODULE_SETUP_INVALID=20
declare -rig BL64_LIB_ERROR_MODULE_SETUP_MISSING=21

# OS
declare -rig BL64_LIB_ERROR_OS_NOT_MATCH=30
declare -rig BL64_LIB_ERROR_OS_TAG_INVALID=31
declare -rig BL64_LIB_ERROR_OS_UNKNOWN=32
declare -rig BL64_LIB_ERROR_OS_INCOMPATIBLE=33

# External commands
declare -rig BL64_LIB_ERROR_APP_INCOMPATIBLE=40
declare -rig BL64_LIB_ERROR_APP_MISSING=41

# Filesystem
declare -rig BL64_LIB_ERROR_FILE_NOT_FOUND=50
declare -rig BL64_LIB_ERROR_FILE_NOT_READ=51
declare -rig BL64_LIB_ERROR_FILE_NOT_EXECUTE=52
declare -rig BL64_LIB_ERROR_DIRECTORY_NOT_FOUND=53
declare -rig BL64_LIB_ERROR_DIRECTORY_NOT_READ=54
declare -rig BL64_LIB_ERROR_PATH_NOT_RELATIVE=55
declare -rig BL64_LIB_ERROR_PATH_NOT_ABSOLUTE=56

# General
declare -rig BL64_LIB_ERROR_EXPORT_EMPTY=60
declare -rig BL64_LIB_ERROR_EXPORT_SET=61
declare -rig BL64_LIB_ERROR_PRIVILEGE_IS_ROOT=62
declare -rig BL64_LIB_ERROR_PRIVILEGE_IS_NOT_ROOT=63
declare -rig BL64_LIB_ERROR_OVERWRITE_NOT_PERMITED=64
#######################################
# BashLib64 / Manage archive files
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.1.0
#######################################

export BL64_ARC_CMD_TAR=''

#######################################
# BashLib64 / Check for conditions and report status
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.6.0
#######################################

readonly _BL64_CHECK_TXT_MISSING_PARAMETER='required parameter is missing'

readonly _BL64_CHECK_TXT_COMMAND_NOT_FOUND='required command is not present'
readonly _BL64_CHECK_TXT_COMMAND_NOT_EXECUTABLE='required command is present but has no execution permission'

readonly _BL64_CHECK_TXT_FILE_NOT_FOUND='required file is not present'
readonly _BL64_CHECK_TXT_FILE_NOT_READABLE='required file is present but has no read permission'

readonly _BL64_CHECK_TXT_DIRECTORY_NOT_FOUND='required directory is not present'
readonly _BL64_CHECK_TXT_DIRECTORY_NOT_READABLE='required directory is present but has no read permission'

readonly _BL64_CHECK_TXT_EXPORT_EMPTY='required shell exported variable is empty'
readonly _BL64_CHECK_TXT_EXPORT_SET='required shell exported variable is not set'

readonly _BL64_CHECK_TXT_PATH_NOT_RELATIVE='path is not relative'
readonly _BL64_CHECK_TXT_PATH_NOT_ABSOLUTE='path is not absolute'

readonly _BL64_CHECK_TXT_PRIVILEGE_IS_NOT_ROOT='the task requires root privilege. Please run the script as root or with SUDO'
readonly _BL64_CHECK_TXT_PRIVILEGE_IS_ROOT='the task should not be run with root privilege. Please run the script as a regular user and not using SUDO'

readonly _BL64_CHECK_TXT_OVERWRITE_NOT_PERMITED='the object is already present and overwrite is not permitted'

readonly _BL64_CHECK_TXT_INCOMPATIBLE='the requested operation is not supported in the current platform'
readonly _BL64_CHECK_TXT_UNDEFINED='requested command is not defined or implemented'

#######################################
# BashLib64 / Interact with container engines
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.0.0
#######################################

export BL64_CNT_CMD_PODMAN=''
export BL64_CNT_CMD_DOCKER=''

readonly _BL64_CNT_TXT_NO_CLI='unable to detect supported container engine'

#######################################
# BashLib64 / Show shell debugging information
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.3.0
#######################################

#
# Debug targets. Use to select what to debug and how
#
# * ALL_TRACE: Shell tracing for the application and bashlib64
# * APP_TRACE: Shell tracing for selected application functions
# * APP_TASK: Debugging messages from selected application functions
# * APP_CMD: External commands: enable command specific debugging options used in the app
# * APP_ALL: Enable full app debugging (task,trace,cmd)
# * LIB_TRACE: Shell tracing for selected bashlib64 functions
# * LIB_TASK: Debugging messages from selected bashlib64 functions
# * LIB_CMD: External commands: enable command specific debugging options used in bashlib64
# * LIB_ALL: Enable full bashlib64 debugging (task,trace,cmd)
#

export BL64_DBG_TARGET_NONE='0'
export BL64_DBG_TARGET_APP_TRACE='1'
export BL64_DBG_TARGET_APP_TASK='2'
export BL64_DBG_TARGET_APP_CMD='3'
export BL64_DBG_TARGET_APP_ALL='4'
export BL64_DBG_TARGET_LIB_TRACE='5'
export BL64_DBG_TARGET_LIB_TASK='6'
export BL64_DBG_TARGET_LIB_CMD='7'
export BL64_DBG_TARGET_LIB_ALL='8'

readonly _BL64_DBG_TXT_FUNCTION_START='function tracing started'
readonly _BL64_DBG_TXT_FUNCTION_STOP='function tracing stopped'
readonly _BL64_DBG_TXT_SHELL_VAR='shell variable'

readonly _BL64_DBG_TXT_BASH="Bash / Interpreter path"
readonly _BL64_DBG_TXT_BASHOPTS="Bash / ShOpt Options"
readonly _BL64_DBG_TXT_SHELLOPTS="Bash / Set -o Options"
readonly _BL64_DBG_TXT_TMPDIR="Bash / Temporary path"
readonly _BL64_DBG_TXT_BASH_VERSION="Bash / Version"
readonly _BL64_DBG_TXT_OSTYPE="Bash / Detected OS"
readonly _BL64_DBG_TXT_LC_ALL="Shell / Locale setting"
readonly _BL64_DBG_TXT_HOME="Shell / Home directory"
readonly _BL64_DBG_TXT_PWD="Shell / Current working directory (pwd command)"
readonly _BL64_DBG_TXT_CD_PWD="Shell / Current cd working directory (PWD)"
readonly _BL64_DBG_TXT_CD_OLDPWD="Shell / Previous cd working directory (OLDPWD)"
readonly _BL64_DBG_TXT_PATH="Shell / Search path"
readonly _BL64_DBG_TXT_HOSTNAME="Shell / Hostname"
readonly _BL64_DBG_TXT_EUID="Script / User ID"
readonly _BL64_DBG_TXT_UID="Script / Effective User ID"
readonly _BL64_DBG_TXT_BASH_ARGV="Script / Arguments"
readonly _BL64_DBG_TXT_COMMAND="Script / Last executed command"
readonly _BL64_DBG_TXT_STATUS="Script / Last exit status"
readonly _BL64_DBG_TXT_BASH_LINENO="Script / Last executed function"
readonly _BL64_DBG_TXT_SCRIPT_FATAL="the script is unable to contine due to a critical error"

readonly _BL64_DBG_TXT_FUNCTION_RUN="run function with parameters"

#######################################
# BashLib64 / Manage local filesystem
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.1.0
#######################################

readonly _BL64_FS_TXT_MISSING_PARAMETER='required parameters are missing'

export BL64_FS_CMD_CHMOD=''
export BL64_FS_CMD_CHOWN=''
export BL64_FS_CMD_CP=''
export BL64_FS_CMD_FIND=''
export BL64_FS_CMD_LN=''
export BL64_FS_CMD_LS=''
export BL64_FS_CMD_MKDIR=''
export BL64_FS_CMD_MKTEMP=''
export BL64_FS_CMD_MV=''
export BL64_FS_CMD_RM=''

export BL64_FS_ALIAS_CHOWN_DIR=''
export BL64_FS_ALIAS_CP_FILE=''
export BL64_FS_ALIAS_LN_SYMBOLIC=''
export BL64_FS_ALIAS_LS_FILES=''
export BL64_FS_ALIAS_MKDIR_FULL=''
export BL64_FS_ALIAS_MV=''
export BL64_FS_ALIAS_RM_FILE=''

export BL64_FS_SET_CHMOD_RECURSIVE=''
export BL64_FS_SET_CHMOD_VERBOSE=''
export BL64_FS_SET_CHOWN_RECURSIVE=''
export BL64_FS_SET_CHOWN_VERBOSE=''
export BL64_FS_SET_CP_FORCE=''
export BL64_FS_SET_CP_RECURSIVE=''
export BL64_FS_SET_CP_VERBOSE=''
export BL64_FS_SET_MKDIR_PARENTS=''
export BL64_FS_SET_MKDIR_VERBOSE=''
export BL64_FS_SET_MV_FORCE=''
export BL64_FS_SET_MV_VERBOSE=''
export BL64_FS_SET_RM_FORCE=''
export BL64_FS_SET_RM_RECURSIVE=''
export BL64_FS_SET_RM_VERBOSE=''

#######################################
# BashLib64 / Manage OS identity and access service
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.3.0
#######################################

export BL64_IAM_CMD_USERADD=''

export BL64_IAM_ALIAS_USERADD=''

#######################################
# BashLib64 / Write messages to logs
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.2.0
#######################################

readonly BL64_LOG_TYPE_FILE='F'
readonly BL64_LOG_CATEGORY_INFO='info'
readonly BL64_LOG_CATEGORY_TASK='task'
readonly BL64_LOG_CATEGORY_DEBUG='debug'
readonly BL64_LOG_CATEGORY_WARNING='warning'
readonly BL64_LOG_CATEGORY_ERROR='error'
readonly BL64_LOG_CATEGORY_RECORD='record'

readonly _BL64_LOG_TXT_NOT_SETUP='missing setup information. Please use the bl64_log_setup function before calling bl64_log_* functions'
readonly _BL64_LOG_TXT_INVALID_TYPE='invalid log type. Please use any of BL64_LOG_TYPE_*'
readonly _BL64_LOG_TXT_INVALID_VERBOSE='invalid option for verbose. Please use 1 (enable) or 0 (disable)'

export BL64_LOG_PATH=''
export BL64_LOG_VERBOSE=''
export BL64_LOG_FS=''
export BL64_LOG_TYPE=''

#######################################
# BashLib64 / Msg / Display messages
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.6.0
#######################################

readonly BL64_MSG_FORMAT_PLAIN='R'
readonly BL64_MSG_FORMAT_HOST='H'
readonly BL64_MSG_FORMAT_TIME='T'
readonly BL64_MSG_FORMAT_CALLER='C'
readonly BL64_MSG_FORMAT_FULL='F'

export BL64_MSG_FORMAT="${BL64_MSG_FORMAT:-$BL64_MSG_FORMAT_FULL}"

readonly _BL64_MSG_TXT_USAGE='Usage'
readonly _BL64_MSG_TXT_COMMANDS='Commands'
readonly _BL64_MSG_TXT_FLAGS='Flags'
readonly _BL64_MSG_TXT_PARAMETERS='Parameters'
readonly _BL64_MSG_TXT_ERROR='Error'
readonly _BL64_MSG_TXT_INFO='Info'
readonly _BL64_MSG_TXT_TASK='Task'
readonly _BL64_MSG_TXT_DEBUG='Debug'
readonly _BL64_MSG_TXT_WARNING='Warning'
readonly _BL64_MSG_TXT_BATCH='Process'
readonly _BL64_MSG_TXT_INVALID_FORMAT='invalid format. Please use one of BL64_MSG_FORMAT_*'
readonly _BL64_MSG_TXT_BATCH_START='started'
readonly _BL64_MSG_TXT_BATCH_FINISH_OK='finished successfully'
readonly _BL64_MSG_TXT_BATCH_FINISH_ERROR='finished with errors'


#######################################
# BashLib64 / OS / Identify OS attributes and provide command aliases
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.9.0
#######################################

export BL64_OS_DISTRO=''

export BL64_OS_CMD_AWK=''
export BL64_OS_CMD_CAT=''
export BL64_OS_CMD_DATE=''
export BL64_OS_CMD_FALSE=''
export BL64_OS_CMD_GAWK=''
export BL64_OS_CMD_GREP=''
export BL64_OS_CMD_HOSTNAME=''
export BL64_OS_CMD_ID=''
export BL64_OS_CMD_TRUE=''
export BL64_OS_CMD_UNAME=''

export BL64_FS_ALIAS_RM_FULL=''
export BL64_OS_ALIAS_AWK=''
export BL64_OS_ALIAS_ID_USER=''

# * OS tags:
#   * ALM   -> AlmaLinux
#   * ALP   -> Alpine Linux
#   * AMZ   -> Amazon Linux
#   * CNT   -> CentOS
#   * DEB   -> Debian
#   * FD    -> Fedora
#   * MCOS  -> MacOS (Darwin)
#   * OL    -> OracleLinux
#   * RHEL  -> RedHat Enterprise Linux
#   * UB    -> Ubuntu
readonly BL64_OS_TAGS='ALM ALP AMZ CNT DEB FD MCOS OL RHEL UB'; export BL64_OS_TAGS

# OS tags. Uppercase version of os-release id
readonly BL64_OS_ALM='ALMALINUX'; export BL64_OS_ALM
readonly BL64_OS_ALP='ALPINE'; export BL64_OS_ALP
readonly BL64_OS_AMZ='AMZN'; export BL64_OS_AMZ
readonly BL64_OS_CNT='CENTOS'; export BL64_OS_CNT
readonly BL64_OS_DEB='DEBIAN'; export BL64_OS_DEB
readonly BL64_OS_FD='FEDORA'; export BL64_OS_FD
readonly BL64_OS_MCOS='DARWIN'; export BL64_OS_MCOS
readonly BL64_OS_OL='OL'; export BL64_OS_OL
readonly BL64_OS_RHEL='RHEL'; export BL64_OS_RHEL
readonly BL64_OS_UB='UBUNTU'; export BL64_OS_UB
readonly BL64_OS_UNK='UNKNOWN'; export BL64_OS_UNK

#######################################
# BashLib64 / Manage native OS packages
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.6.0
#######################################

export BL64_PKG_CMD_APK=''
export BL64_PKG_CMD_APT=''
export BL64_PKG_CMD_BRW=''
export BL64_PKG_CMD_DNF=''
export BL64_PKG_CMD_YUM=''

export BL64_PKG_ALIAS_APK_CLEAN=''
export BL64_PKG_ALIAS_APK_INSTALL=''
export BL64_PKG_ALIAS_APK_CACHE=''
export BL64_PKG_ALIAS_APT_CLEAN=''
export BL64_PKG_ALIAS_APT_INSTALL=''
export BL64_PKG_ALIAS_APT_CACHE=''
export BL64_PKG_ALIAS_BRW_CLEAN=''
export BL64_PKG_ALIAS_BRW_INSTALL=''
export BL64_PKG_ALIAS_BRW_CACHE=''
export BL64_PKG_ALIAS_DNF_CACHE=''
export BL64_PKG_ALIAS_DNF_CLEAN=''
export BL64_PKG_ALIAS_DNF_INSTALL=''
export BL64_PKG_ALIAS_YUM_CACHE=''
export BL64_PKG_ALIAS_YUM_CLEAN=''
export BL64_PKG_ALIAS_YUM_INSTALL=''

export BL64_PKG_SET_ASSUME_YES=''
export BL64_PKG_SET_QUIET=''
export BL64_PKG_SET_SLIM=''
export BL64_PKG_SET_VERBOSE=''

readonly _BL64_PKG_TXT_CLEAN='clean up package manager run-time environment'
readonly _BL64_PKG_TXT_INSTALL='install packages'
readonly _BL64_PKG_TXT_PREPARE='initialize package manager'


#######################################
# BashLib64 / Interact with system-wide Python
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.0.0
#######################################

# Define placeholders for optional distro native python versions
export BL64_PY_CMD_PYTHON3="$BL64_LIB_VAR_NULL"
export BL64_PY_CMD_PYTHON35="$BL64_LIB_VAR_NULL"
export BL64_PY_CMD_PYTHON36="$BL64_LIB_VAR_NULL"
export BL64_PY_CMD_PYTHON37="$BL64_LIB_VAR_NULL"
export BL64_PY_CMD_PYTHON38="$BL64_LIB_VAR_NULL"
export BL64_PY_CMD_PYTHON39="$BL64_LIB_VAR_NULL"
export BL64_PY_CMD_PYTHON310="$BL64_LIB_VAR_NULL"

export BL64_PY_SET_PIP_VERBOSE=''
export BL64_PY_SET_PIP_VERSION=''
export BL64_PY_SET_PIP_UPGRADE=''
export BL64_PY_SET_PIP_USER=''

readonly _BL64_PY_TXT_PIP_PREPARE_PIP='upgrade pip module'
readonly _BL64_PY_TXT_PIP_PREPARE_SETUP='install and upgrade setuptools modules'
readonly _BL64_PY_TXT_PIP_INSTALL='install modules'

#######################################
# BashLib64 / Manage role based access service
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.3.0
#######################################

export BL64_RBAC_CMD_SUDO=''
export BL64_RBAC_CMD_VISUDO=''
export BL64_RBAC_FILE_SUDOERS=''

export BL64_RBAC_ALIAS_SUDO_ENV=''

readonly _BL64_RBAC_TXT_INVALID_SUDOERS='the sudoers file is corrupt or invalid'

#######################################
# BashLib64 / Generate random data
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.1.0
#######################################

declare -rig BL64_RND_LENGTH_1=1
declare -rig BL64_RND_LENGTH_20=20
declare -rig BL64_RND_LENGTH_100=100
declare -rig BL64_RND_RANDOM_MIN=0
declare -rig BL64_RND_RANDOM_MAX=32767

readonly BL64_RND_POOL_UPPERCASE="$(printf '%b' $(printf '\\%o' {65..90}))"
readonly BL64_RND_POOL_UPPERCASE_MAX_IDX="$(( ${#BL64_RND_POOL_UPPERCASE} - 1 ))"
readonly BL64_RND_POOL_LOWERCASE="$(printf '%b' $(printf '\\%o' {97..122}))"
readonly BL64_RND_POOL_LOWERCASE_MAX_IDX="$(( ${#BL64_RND_POOL_LOWERCASE} - 1 ))"
readonly BL64_RND_POOL_DIGITS="$(printf '%b' $(printf '\\%o' {48..57}))"
readonly BL64_RND_POOL_DIGITS_MAX_IDX="$(( ${#BL64_RND_POOL_DIGITS} - 1 ))"
readonly BL64_RND_POOL_ALPHANUMERIC="${BL64_RND_POOL_UPPERCASE}${BL64_RND_POOL_LOWERCASE}${BL64_RND_POOL_DIGITS}"
readonly BL64_RND_POOL_ALPHANUMERIC_MAX_IDX="$(( ${#BL64_RND_POOL_ALPHANUMERIC} - 1 ))"

readonly _BL64_RND_TXT_LENGHT_MIN='length can not be less than'
readonly _BL64_RND_TXT_LENGHT_MAX='length can not be greater than'

#######################################
# BashLib64 / Transfer and Receive data over the network
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.4.0
#######################################

export BL64_RXTX_CMD_CURL=''
export BL64_RXTX_CMD_WGET=''

export BL64_RXTX_ALIAS_CURL=''
export BL64_RXTX_ALIAS_WGET=''

export BL64_RXTX_SET_CURL_VERBOSE=''
export BL64_RXTX_SET_CURL_OUTPUT=''
export BL64_RXTX_SET_CURL_SILENT=''
export BL64_RXTX_SET_CURL_REDIRECT=''
export BL64_RXTX_SET_CURL_SECURE=''
export BL64_RXTX_SET_WGET_VERBOSE=''
export BL64_RXTX_SET_WGET_OUTPUT=''
export BL64_RXTX_SET_WGET_SECURE=''

readonly _BL64_RXTX_TXT_MISSING_COMMAND='no web transfer command was found on the system'
readonly _BL64_RXTX_TXT_EXISTING_DESTINATION='destination path is not empty. No action taken.'
readonly _BL64_RXTX_TXT_CREATION_PROBLEM='unable to create temporary git repo'

readonly _BL64_RXTX_BACKUP_POSTFIX='._bl64_rxtx_backup'

#######################################
# BashLib64 / Manage Version Control System
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.3.0
#######################################

export BL64_VCS_CMD_GIT=''

export BL64_VCS_ALIAS_GIT=''

export BL64_VCS_SET_GIT_NO_PAGER=''
export BL64_VCS_SET_GIT_QUIET=''

#######################################
# BashLib64 / Manipulate CSV like text files
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.2.0
#######################################

declare -rig BL64_XSV_ERROR_SEARCH_VALUES=199

# Field separators
readonly BL64_XSV_FS='_@64@_'       # Custom
readonly BL64_XSV_FS_SPACE=' '
readonly BL64_XSV_FS_TAB='	'
readonly BL64_XSV_FS_COLON=':'
readonly BL64_XSV_FS_SEMICOLON=';'
readonly BL64_XSV_FS_COMMA=','
readonly BL64_XSV_FS_PIPE='|'
readonly BL64_XSV_FS_AT='@'
readonly BL64_XSV_FS_DOLLAR='$'
readonly BL64_XSV_FS_SLASH='/'

# Exports required to use inside AWK programs
export BL64_XSV_FS
export BL64_XSV_FS_SPACE
export BL64_XSV_FS_TAB
export BL64_XSV_FS_COLON
export BL64_XSV_FS_SEMICOLON
export BL64_XSV_FS_COMMA
export BL64_XSV_FS_PIPE
export BL64_XSV_FS_AT
export BL64_XSV_FS_DOLLAR
export BL64_XSV_FS_SLASH

readonly _BL64_XSV_TXT_SOURCE_NOT_FOUND='source file not found'

#######################################
# BashLib64 / Manage archive files
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.0.0
#######################################

#######################################
# Identify and normalize common *nix OS commands
# Commands are exported as variables with full path
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok, even when the OS is not supported
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_arc_set_command() {
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_ARC_CMD_TAR='/bin/tar'
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-*)
    BL64_ARC_CMD_TAR='/bin/tar'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_ARC_CMD_TAR='/bin/tar'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_ARC_CMD_TAR='/usr/bin/tar'
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# BashLib64 / Manage archive files
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.5.0
#######################################

#######################################
# Open tar files and remove the source after extraction
#
# * Preserves permissions but not ownership
# * Overwrites destination
# * Ignore ACLs and extended attributes
#
# Arguments:
#   $1: Full path to the source file
#   $2: Full path to the destination
# Outputs:
#   STDOUT: None
#   STDERR: tar or lib error messages
# Returns:
#   BL64_ARC_ERROR_INVALID_DESTINATION
#   tar error status
#######################################
function bl64_arc_open_tar() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local destination="$2"
  local -i status=0

  bl64_check_parameter 'source' &&
    bl64_check_parameter 'destination' &&
    bl64_check_directory "$destination" ||
    return $?

  cd "$destination" || return 1

  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-*)
    "$BL64_ARC_CMD_TAR" \
      --overwrite \
      --extract \
      --no-same-owner \
      --preserve-permissions \
      --no-acls \
      --force-local \
      --verbose \
      --auto-compress \
      --file="$source"
    status=$?
    ;;
  ${BL64_OS_ALP}-*)
    "$BL64_ARC_CMD_TAR" \
      x \
      --overwrite \
      -f "$source" \
      -o \
      -v
    status=$?
    ;;
  ${BL64_OS_MCOS}-*)
    "$BL64_ARC_CMD_TAR" \
      --extract \
      --no-same-owner \
      --preserve-permissions \
      --no-acls \
      --verbose \
      --auto-compress \
      --file="$source"
    status=$?
    ;;
  *)
    bl64_check_show_unsupported
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_INCOMPATIBLE
    ;;
  esac

  ((status == 0)) && bl64_fs_rm_file "$source"

  return $status
}

#######################################
# BashLib64 / Check for conditions and report status
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.9.0
#######################################

#######################################
# Check and report if the command is present and has execute permissions for the current user.
#
# Arguments:
#   $1: Full path to the command to check
#   $2: Not found error message. Default: _BL64_CHECK_TXT_COMMAND_NOT_FOUND
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: Command found
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_FILE_NOT_FOUND
#   $BL64_LIB_ERROR_FILE_NOT_EXECUTE
#######################################
function bl64_check_command() {
  bl64_dbg_lib_show_function "$@"
  local path="$1"
  local message="${2:-$_BL64_CHECK_TXT_COMMAND_NOT_FOUND}"

  bl64_check_parameter 'path' || return $?

  if [[ "$path" == "$BL64_LIB_VAR_NULL" ]]; then
    bl64_check_show_unsupported "$path"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_FILE_NOT_FOUND
  fi
  if [[ ! -f "$path" ]]; then
    bl64_msg_show_error "[${FUNCNAME[1]}] ${message} (${path})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_FILE_NOT_FOUND
  fi
  if [[ ! -x "$path" ]]; then
    bl64_msg_show_error "[${FUNCNAME[1]}] $_BL64_CHECK_TXT_COMMAND_NOT_EXECUTABLE (${path})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_FILE_NOT_EXECUTE
  fi
  return 0
}

#######################################
# Check and report if the file is present and has read permissions for the current user.
#
# Arguments:
#   $1: Full path to the file
#   $2: Not found error message. Default: _BL64_CHECK_TXT_FILE_NOT_FOUND
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: File found
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_FILE_NOT_FOUND
#   $BL64_LIB_ERROR_FILE_NOT_READ
#######################################
function bl64_check_file() {
  bl64_dbg_lib_show_function "$@"
  local path="$1"
  local message="${2:-$_BL64_CHECK_TXT_FILE_NOT_FOUND}"

  bl64_check_parameter 'path' || return $?
  if [[ ! -f "$path" ]]; then
    bl64_msg_show_error "[${FUNCNAME[1]}] ${message} (${path})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_FILE_NOT_FOUND
  fi
  if [[ ! -r "$path" ]]; then
    bl64_msg_show_error "[${FUNCNAME[1]}] $_BL64_CHECK_TXT_FILE_NOT_READABLE (${path})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_FILE_NOT_READ
  fi
  return 0
}

#######################################
# Check and report if the directory is present and has read and execute permissions for the current user.
#
# Arguments:
#   $1: Full path to the directory
#   $2: Not found error message. Default: _BL64_CHECK_TXT_DIRECTORY_NOT_FOUND
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: File found
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_DIRECTORY_NOT_FOUND
#   $BL64_LIB_ERROR_DIRECTORY_NOT_READ
#######################################
function bl64_check_directory() {
  bl64_dbg_lib_show_function "$@"
  local path="$1"
  local message="${2:-$_BL64_CHECK_TXT_DIRECTORY_NOT_FOUND}"

  bl64_check_parameter 'path' || return $?
  if [[ ! -d "$path" ]]; then
    bl64_msg_show_error "[${FUNCNAME[1]}] ${message} (${path})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_DIRECTORY_NOT_FOUND
  fi
  if [[ ! -r "$path" || ! -x "$path" ]]; then
    bl64_msg_show_error "[${FUNCNAME[1]}] $_BL64_CHECK_TXT_DIRECTORY_NOT_READABLE (${path})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_DIRECTORY_NOT_READ
  fi
  return 0
}

#######################################
# Check shell parameters:
#   - parameter is not empty
#
# Arguments:
#   $1: parameter name
#   $2: parameter description. Shown on error messages
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: Check ok
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_PARAMETER_EMPTY
#######################################
function bl64_check_parameter() {
  bl64_dbg_lib_show_function "$@"
  local parameter="$1"
  local description="${2:-parameter $parameter}"

  if [[ -z "$parameter" ]]; then
    bl64_msg_show_error "[${FUNCNAME[1]}] $_BL64_CHECK_TXT_MISSING_PARAMETER (parameter name)"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_PARAMETER_MISSING
  fi

  if eval "[[ -z \"\$${parameter}\" || \"\$${parameter}\" == '${BL64_LIB_DEFAULT}' ]]"; then
    bl64_msg_show_error "[${FUNCNAME[1]}] $_BL64_CHECK_TXT_MISSING_PARAMETER (${description})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_PARAMETER_EMPTY
  fi
  return 0
}

#######################################
# Check shell exported environment variable:
#   - exported variable is not empty
#   - exported variable is set
#
# Arguments:
#   $1: parameter name
#   $2: parameter description. Shown on error messages
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: Check ok
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_EXPORT_EMPTY
#   $BL64_LIB_ERROR_EXPORT_SET
#######################################
function bl64_check_export() {
  bl64_dbg_lib_show_function "$@"
  local export_name="$1"
  local description="${2:-export_name $export_name}"

  bl64_check_parameter 'export_name' || return $?

  if [[ ! -v "$export_name" ]]; then
    bl64_msg_show_error "[${FUNCNAME[1]}] $_BL64_CHECK_TXT_EXPORT_SET (${description})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_EXPORT_SET
  fi

  if eval "[[ -z \$${export_name} ]]"; then
    bl64_msg_show_error "[${FUNCNAME[1]}] $_BL64_CHECK_TXT_EXPORT_EMPTY (${description})"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_EXPORT_EMPTY
  fi
  return 0
}

#######################################
# Check that the given path is relative
#
# * String check only
# * Path is not tested for existance
#
# Arguments:
#   $1: Path string
#   $2: Failed check error message. Default: _BL64_CHECK_TXT_PATH_NOT_RELATIVE
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: File found
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_PATH_NOT_RELATIVE
#######################################
function bl64_check_path_relative() {
  bl64_dbg_lib_show_function "$@"
  local path="$1"
  local message="${2:-$_BL64_CHECK_TXT_PATH_NOT_RELATIVE}"

  bl64_check_parameter 'path' || return $?
  if [[ "$path" == '/' || "$path" == /* ]]; then
    bl64_msg_show_error "[${FUNCNAME[1]}] $_BL64_CHECK_TXT_PATH_NOT_RELATIVE ($path)"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_PATH_NOT_RELATIVE
  fi
  return 0
}

#######################################
# Check that the given path is absolute
#
# * String check only
# * Path is not tested for existance
#
# Arguments:
#   $1: Path string
#   $2: Failed check error message. Default: _BL64_CHECK_TXT_PATH_NOT_ABSOLUTE
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: File found
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_PATH_NOT_ABSOLUTE
#######################################
function bl64_check_path_absolute() {
  bl64_dbg_lib_show_function "$@"
  local path="$1"
  local message="${2:-$_BL64_CHECK_TXT_PATH_NOT_ABSOLUTE}"

  bl64_check_parameter 'path' || return $?
  if [[ "$path" != '/' && "$path" != /* ]]; then
    bl64_msg_show_error "[${FUNCNAME[1]}] $_BL64_CHECK_TXT_PATH_NOT_RELATIVE ($path)"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_PATH_NOT_ABSOLUTE
  fi
  return 0
}

#######################################
# Check that the effective user running the current process is root
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: check ok
#   $BL64_LIB_ERROR_PRIVILEGE_IS_ROOT
#######################################
function bl64_check_privilege_root() {
  bl64_dbg_lib_show_function
  bl64_dbg_lib_show_vars 'EUID'
  if [[ "$EUID" != '0' ]]; then
    bl64_msg_show_error "[${FUNCNAME[1]}] $_BL64_CHECK_TXT_PRIVILEGE_IS_NOT_ROOT (EUID: $EUID)"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_PRIVILEGE_IS_NOT_ROOT
  fi
  return 0
}

#######################################
# Check that the effective user running the current process is not root
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: check ok
#   $BL64_LIB_ERROR_PRIVILEGE_IS_NOT_ROOT
#######################################
function bl64_check_privilege_not_root() {
  bl64_dbg_lib_show_function "$@"
  bl64_dbg_lib_show_vars 'EUID'
  if [[ "$EUID" == '0' ]]; then
    bl64_msg_show_error "[${FUNCNAME[1]}] $_BL64_CHECK_TXT_PRIVILEGE_IS_ROOT"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_PRIVILEGE_IS_ROOT
  fi
  return 0
}

#######################################
# Check file/dir overwrite condition
#
# Arguments:
#   $1: Full path to the object
#   $2: Error message
#   $3: Overwrite flag. Must be ON(1) or OFF(0). Default: OFF
# Outputs:
#   STDOUT: None
#   STDERR: Error message
# Returns:
#   0: check ok
#   $BL64_LIB_ERROR_PARAMETER_MISSING
#   $BL64_LIB_ERROR_OVERWRITE_NOT_PERMITED
#######################################
function bl64_check_overwrite() {
  bl64_dbg_lib_show_function "$@"
  local path="$1"
  local message="${2:-$_BL64_CHECK_TXT_OVERWRITE_NOT_PERMITED}"
  local overwrite="${3:-"$BL64_LIB_VAR_OFF"}"

  bl64_check_parameter 'path' || return $?

  if [[ "$overwrite" == "$BL64_LIB_VAR_OFF" ]]; then
    if [[ -e "$path" ]]; then
      bl64_msg_show_error "[${FUNCNAME[1]}] ${message} (${path})"
      # shellcheck disable=SC2086
      return $BL64_LIB_ERROR_OVERWRITE_NOT_PERMITED
    fi
  fi

  return 0
}

#######################################
# Raise unsupported platform error
#
# Arguments:
#   $1: target (function name, command path, etc)
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   BL64_LIB_ERROR_OS_INCOMPATIBLE
#######################################
function bl64_check_show_unsupported() {
  local target="${1:-${FUNCNAME[1]}}"

  bl64_msg_show_error "${_BL64_CHECK_TXT_INCOMPATIBLE} (os: ${BL64_OS_DISTRO} / target: ${target})"
  return $BL64_LIB_ERROR_OS_INCOMPATIBLE
}

#######################################
# Raise undefined command error
#
# * Commonly used in the default branch of case statements to catch undefined options
#
# Arguments:
#   $1: command
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   BL64_LIB_ERROR_TASK_UNDEFINED
#######################################
function bl64_check_show_undefined() {
  local target="${1:-}"

  bl64_msg_show_error "${_BL64_CHECK_TXT_UNDEFINED} ${target:+(${target})}"
  return $BL64_LIB_ERROR_TASK_UNDEFINED
}

#######################################
# BashLib64 / Interact with container engines
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.0.0
#######################################

#######################################
# Identify and normalize commands
#
# * Commands are exported as variables with full path
# * The caller function is responsible for checking that the target command is present (installed)
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_cnt_set_command() {
  bl64_dbg_lib_show_function

  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_ALP}-* | ${BL64_OS_MCOS}-*)
    BL64_CNT_CMD_PODMAN='/usr/bin/podman'
    BL64_CNT_CMD_DOCKER='/usr/bin/docker'
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# BashLib64 / Interact with container engines
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.1.0
#######################################

#######################################
# Logins the container engine to a container registry. The password is stored in a regular file
#
# Arguments:
#   $1: user
#   $2: file
#   $3: registry
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_cnt_login_file() {
  bl64_dbg_lib_show_function "$@"
  local user="$1"
  local file="$2"
  local registry="$3"

  bl64_check_parameter 'user' &&
    bl64_check_parameter 'file' &&
    bl64_check_parameter 'registry' &&
    bl64_check_file 'file' ||
    return $?

  if [[ -x "$BL64_CNT_CMD_DOCKER" ]]; then
    bl64_cnt_docker_login "$user" "$BL64_LIB_DEFAULT" "$file" "$registry"
  elif [[ -x "$BL64_CNT_CMD_PODMAN" ]]; then
    bl64_cnt_podman_login "$user" "$BL64_LIB_DEFAULT" "$file" "$registry"
  else
    bl64_msg_show_error "$_BL64_CNT_TXT_NO_CLI ($BL64_CNT_CMD_DOCKER. $BL64_CNT_CMD_PODMAN)"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_MISSING
  fi
}

#######################################
# Logins the container engine to a container. The password is passed as parameter
#
# Arguments:
#   $1: user
#   $2: password
#   $3: registry
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_cnt_login() {
  bl64_dbg_lib_show_function "$@"
  local user="$1"
  local password="$2"
  local registry="$3"

  bl64_check_parameter 'user' &&
    bl64_check_parameter 'password' &&
    bl64_check_parameter 'registry' ||
    return $?

  if [[ -x "$BL64_CNT_CMD_DOCKER" ]]; then
    bl64_cnt_docker_login "$user" "$password" "$BL64_LIB_DEFAULT" "$registry"
  elif [[ -x "$BL64_CNT_CMD_PODMAN" ]]; then
    bl64_cnt_podman_login "$user" "$password" "$BL64_LIB_DEFAULT" "$registry"
  else
    bl64_msg_show_error "$_BL64_CNT_TXT_NO_CLI ($BL64_CNT_CMD_DOCKER. $BL64_CNT_CMD_PODMAN)"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_MISSING
  fi
}

#######################################
# Command wrapper: docker login
#
# Arguments:
#   $1: user
#   $2: password
#   $3: file
#   $4: registry
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################

function bl64_cnt_docker_login() {
  bl64_dbg_lib_show_function "$@"
  local user="$1"
  local password="$2"
  local file="$3"
  local registry="$4"

  _bl64_cnt_login_put_password "$password" "$file" |
    bl64_cnt_run_docker \
      login \
      --username "$user" \
      --password-stdin \
      "$registry"
}

#######################################
# Command wrapper: podman login
#
# Arguments:
#   $1: user
#   $2: password
#   $3: file
#   $4: registry
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################

function bl64_cnt_podman_login() {
  bl64_dbg_lib_show_function "$@"
  local user="$1"
  local password="$2"
  local file="$3"
  local registry="$4"

  _bl64_cnt_login_put_password "$password" "$file" |
    bl64_cnt_run_podman \
      login \
      --username "$user" \
      --password-stdin \
      "$registry"
}

#######################################

# Runs a container source using interactive settings
#
# * Allows signals
# * Attaches tty
#
# Arguments:
#   $@: arguments are passes as-is
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_cnt_run_interactive() {
  bl64_dbg_lib_show_function "$@"

  if [[ -x "$BL64_CNT_CMD_DOCKER" ]]; then
    bl64_cnt_docker_run_interactive "$@"
  elif [[ -x "$BL64_CNT_CMD_PODMAN" ]]; then
    bl64_cnt_podman_run_interactive "$@"
  else
    bl64_msg_show_error "$_BL64_CNT_TXT_NO_CLI ($BL64_CNT_CMD_DOCKER. $BL64_CNT_CMD_PODMAN)"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_MISSING
  fi
}

#######################################
# Command wrapper: podman run
#
# * Provides verbose and debug support
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################

function bl64_cnt_podman_run_interactive() {
  bl64_dbg_lib_show_function "$@"

  bl64_cnt_run_podman \
    run \
    --rm \
    --interactive \
    --tty \
    "$@"
}

#######################################
# Command wrapper: docker run
#
# * Provides verbose and debug support
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################

function bl64_cnt_docker_run_interactive() {
  bl64_dbg_lib_show_function "$@"

  bl64_cnt_run_docker \
    run \
    --rm \
    --interactive \
    --tty \
    "$@"

}

#######################################
# Command wrapper: podman
#
# * Provides debug support
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################

function bl64_cnt_run_podman() {
  bl64_dbg_lib_show_function "$@"
  local verbose='error'

  bl64_check_command "$BL64_CNT_CMD_PODMAN" || return $?
  bl64_dbg_lib_command_enabled && verbose="debug"
  bl64_dbg_runtime_show_paths

  "$BL64_CNT_CMD_PODMAN" \
    --log-level "$verbose" \
    "$@"
}

#######################################
# Command wrapper: docker
#
# * Provides debug support
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################

function bl64_cnt_run_docker() {
  bl64_dbg_lib_show_function "$@"
  local verbose='error'

  bl64_check_command "$BL64_CNT_CMD_DOCKER" || return $?
  bl64_dbg_lib_command_enabled && verbose="debug"
  bl64_dbg_runtime_show_paths

  "$BL64_CNT_CMD_DOCKER" \
    --log-level "$verbose" \
    "$@"
}

#######################################
# Builds a container source
#
# Arguments:
#   $1: build context. Format: full path
#   $2: dockerfile path. Format: relative to the build context
#   $3: tag to be applied to the resulting source. Format: docker tag
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_cnt_build() {
  bl64_dbg_lib_show_function "$@"
  local context="$1"
  local file="${2:-Dockerfile}"
  local tag="${3:-latest}"

  bl64_check_parameter 'context' &&
    bl64_check_directory "$context" &&
    bl64_check_file "${context}/${file}" ||
    return $?

  cd "${context}"

  if [[ -x "$BL64_CNT_CMD_DOCKER" ]]; then
    bl64_cnt_docker_build "$file" "$tag"
  elif [[ -x "$BL64_CNT_CMD_PODMAN" ]]; then
    bl64_cnt_podman_build "$file" "$tag"
  else
    bl64_msg_show_error "$_BL64_CNT_TXT_NO_CLI ($BL64_CNT_CMD_DOCKER. $BL64_CNT_CMD_PODMAN)"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_MISSING
  fi
}

#######################################
# Command wrapper: docker build
#
# Arguments:
#   $1: context
#   $2: file
#   $3: tag
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################

function bl64_cnt_docker_build() {
  bl64_dbg_lib_show_function "$@"
  local file="$1"
  local tag="$2"

  bl64_cnt_run_docker \
    build \
    --no-cache \
    --rm \
    --tag "$tag" \
    --file "$file" \
    .
}

#######################################
# Command wrapper: podman build
#
# Arguments:
#   $1: context
#   $2: file
#   $3: tag
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################

function bl64_cnt_podman_build() {
  bl64_dbg_lib_show_function "$@"
  local file="$1"
  local tag="$2"

  bl64_cnt_run_podman \
    build \
    --no-cache \
    --rm \
    --tag "$tag" \
    --file "$file" \
    .
}

#######################################
# Push a local source to the target container registry
#
# * Image is already present in the local destination
#
# Arguments:
#   $1: source. Format: IMAGE:TAG
#   $2: destination. Format: REPOSITORY/IMAGE:TAG
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_cnt_push() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local destination="$2"

  bl64_check_parameter 'source' &&
    bl64_check_parameter 'destination' ||
    return $?

  if [[ -x "$BL64_CNT_CMD_DOCKER" ]]; then
    bl64_cnt_docker_push "$source" "$destination"
  elif [[ -x "$BL64_CNT_CMD_PODMAN" ]]; then
    bl64_cnt_podman_push "$source" "$destination"
  else
    bl64_msg_show_error "$_BL64_CNT_TXT_NO_CLI ($BL64_CNT_CMD_DOCKER. $BL64_CNT_CMD_PODMAN)"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_MISSING
  fi
}

#######################################
# Command wrapper: docker push
#
# Arguments:
#   $1: source
#   $2: destination
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################

function bl64_cnt_docker_push() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local destination="$2"

  bl64_cnt_run_docker \
    push \
    "${destination}"
}

#######################################
# Command wrapper: podman push
#
# Arguments:
#   $1: source
#   $2: destination
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################

function bl64_cnt_podman_push() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local destination="$2"

  bl64_cnt_run_podman \
    push \
    "localhost/${source}" \
    "${destination}"
}

#######################################
# Pull a remote container image to the local registry
#
# Arguments:
#   $1: source. Format: [REPOSITORY/]IMAGE:TAG
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_cnt_pull() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"

  bl64_check_parameter 'source' ||
    return $?

  if [[ -x "$BL64_CNT_CMD_DOCKER" ]]; then
    bl64_cnt_docker_pull "$source"
  elif [[ -x "$BL64_CNT_CMD_PODMAN" ]]; then
    bl64_cnt_podman_pull "$source"
  else
    bl64_msg_show_error "$_BL64_CNT_TXT_NO_CLI ($BL64_CNT_CMD_DOCKER. $BL64_CNT_CMD_PODMAN)"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_MISSING
  fi
}

#######################################
# Command wrapper: docker pull
#
# Arguments:
#   $1: source
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################

function bl64_cnt_docker_pull() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"

  bl64_cnt_run_docker \
    pull \
    "${source}"
}

#######################################
# Command wrapper: podman pull
#
# Arguments:
#   $1: source
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################

function bl64_cnt_podman_pull() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"

  bl64_cnt_run_podman \
    pull \
    "${source}"
}

function _bl64_cnt_login_put_password() {
  local password="$1"
  local file="$2"

  if [[ "$password" != "$BL64_LIB_DEFAULT" ]]; then
    printf '%s\n' "$password"
  elif [[ "$file" != "$BL64_LIB_DEFAULT" ]]; then
    "$BL64_OS_CMD_CAT" "$file"
  fi

}

#######################################
# BashLib64 / Show shell debugging information
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.5.0
#######################################

function bl64_dbg_app_task_enabled { [[ "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_APP_TASK" || "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_APP_ALL" ]]; }
function bl64_dbg_lib_task_enabled { [[ "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_LIB_TASK" || "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_LIB_ALL" ]]; }
function bl64_dbg_app_command_enabled { [[ "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_APP_CMD" || "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_APP_ALL" ]]; }
function bl64_dbg_lib_command_enabled { [[ "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_LIB_CMD" || "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_LIB_ALL" ]]; }

#######################################
# Show runtime info
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: runtime info
# Returns:
#   latest exit status (before function call)
#######################################
function bl64_dbg_runtime_get_script_path() {
  BL64_SCRIPT_PATH="$(
    cd "${BASH_SOURCE[0]%/*}" >/dev/null 2>&1 &&
      pwd
  )"
}

#######################################
# Show runtime info
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: runtime info
# Returns:
#   latest exit status (before function call)
#######################################
function bl64_dbg_runtime_show() {
  local -i last_status=$?

  if bl64_dbg_app_task_enabled; then
    bl64_msg_show_debug "${_BL64_DBG_TXT_BASH}: [${BASH}]"
    bl64_msg_show_debug "${_BL64_DBG_TXT_BASHOPTS}: [${BASHOPTS:-NONE}]"
    bl64_msg_show_debug "${_BL64_DBG_TXT_SHELLOPTS}: [${SHELLOPTS:-NONE}]"
    bl64_msg_show_debug "${_BL64_DBG_TXT_TMPDIR}: [${TMPDIR:-NONE}]"
    bl64_msg_show_debug "${_BL64_DBG_TXT_BASH_VERSION}: [${BASH_VERSION}]"
    bl64_msg_show_debug "${_BL64_DBG_TXT_OSTYPE}: [${OSTYPE:-NONE}]"
    bl64_msg_show_debug "${_BL64_DBG_TXT_LC_ALL}: [${LC_ALL:-NONE}]"
    bl64_msg_show_debug "${_BL64_DBG_TXT_HOSTNAME}: [${HOSTNAME:-EMPTY}]"
    bl64_msg_show_debug "${_BL64_DBG_TXT_EUID}: [${EUID}]"
    bl64_msg_show_debug "${_BL64_DBG_TXT_UID}: [${UID}]"
    bl64_msg_show_debug "${_BL64_DBG_TXT_BASH_ARGV}: [${BASH_ARGV[*]:-NONE}]"
    bl64_msg_show_debug "${_BL64_DBG_TXT_COMMAND}: [${BASH_COMMAND:-NONE}]"
    bl64_msg_show_debug "${_BL64_DBG_TXT_STATUS}: [${last_status}]"

    bl64_dbg_runtime_show_paths

    bl64_msg_show_debug "${_BL64_DBG_TXT_BASH_LINENO}(1): [${BASH_SOURCE[1]:-NONE}:${FUNCNAME[1]:-NONE}:${BASH_LINENO[1]:-0}]"
    bl64_msg_show_debug "${_BL64_DBG_TXT_BASH_LINENO}(2): [${BASH_SOURCE[2]:-NONE}:${FUNCNAME[2]:-NONE}:${BASH_LINENO[2]:-0}]"
    bl64_msg_show_debug "${_BL64_DBG_TXT_BASH_LINENO}(3): [${BASH_SOURCE[3]:-NONE}:${FUNCNAME[3]:-NONE}:${BASH_LINENO[3]:-0}]"
  fi

  # shellcheck disable=SC2248
  return $last_status
}

#######################################
# Show runtime call stack
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: callstack
# Returns:
#   latest exit status (before function call)
#######################################
function bl64_dbg_runtime_show_callstack() {

  bl64_dbg_app_task_enabled || bl64_dbg_lib_task_enabled || return 0
  bl64_msg_show_debug "${_BL64_DBG_TXT_BASH_LINENO}(1): [${BASH_SOURCE[1]:-NONE}:${FUNCNAME[1]:-NONE}:${BASH_LINENO[1]:-0}]"
  bl64_msg_show_debug "${_BL64_DBG_TXT_BASH_LINENO}(2): [${BASH_SOURCE[2]:-NONE}:${FUNCNAME[2]:-NONE}:${BASH_LINENO[2]:-0}]"
  bl64_msg_show_debug "${_BL64_DBG_TXT_BASH_LINENO}(3): [${BASH_SOURCE[3]:-NONE}:${FUNCNAME[3]:-NONE}:${BASH_LINENO[3]:-0}]"

}

#######################################
# Show runtime paths
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: callstack
# Returns:
#   latest exit status (before function call)
#######################################
function bl64_dbg_runtime_show_paths() {

  bl64_dbg_app_task_enabled || bl64_dbg_lib_task_enabled || return 0
  bl64_msg_show_debug "${_BL64_DBG_TXT_HOME}: [${HOME:-EMPTY}]"
  bl64_msg_show_debug "${_BL64_DBG_TXT_PATH}: [${PATH:-EMPTY}]"
  bl64_msg_show_debug "${_BL64_DBG_TXT_CD_PWD}: [${PWD:-EMPTY}]"
  bl64_msg_show_debug "${_BL64_DBG_TXT_CD_OLDPWD}: [${OLDPWD:-EMPTY}]"
  bl64_msg_show_debug "${_BL64_DBG_TXT_PWD}: [$(pwd)]"

}

#######################################
# Stop app  shell tracing
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_dbg_app_trace_stop() {
  [[ "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_APP_TRACE" || "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_APP_ALL" ]] &&
    set +x &&
    bl64_msg_show_debug "[${FUNCNAME[1]}:${BASH_LINENO[1]}] ${_BL64_DBG_TXT_FUNCTION_STOP}"
  return 0
}

#######################################
# Start app  shell tracing if target is in scope
#
# Arguments:
#   None
# Outputs:
#   STDOUT: Tracing
#   STDERR: Debug messages
# Returns:
#   0: always ok
#######################################
function bl64_dbg_app_trace_start() {
  [[ "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_APP_TRACE" || "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_APP_ALL" ]] &&
    bl64_msg_show_debug "[${FUNCNAME[1]}:${BASH_LINENO[1]}] ${_BL64_DBG_TXT_FUNCTION_START}" &&
    set -x
  return 0
}

#######################################
# Stop bashlib64 shell tracing
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_dbg_lib_trace_stop() {
  [[ "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_LIB_TRACE" || "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_LIB_ALL" ]] &&
    set +x &&
    bl64_msg_show_debug "[${FUNCNAME[1]}:${BASH_LINENO[1]}] ${_BL64_DBG_TXT_FUNCTION_STOP}"
  return 0
}

#######################################
# Start bashlib64 shell tracing if target is in scope
#
# Arguments:
#   None
# Outputs:
#   STDOUT: Tracing
#   STDERR: Debug messages
# Returns:
#   0: always ok
#######################################
function bl64_dbg_lib_trace_start() {
  [[ "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_LIB_TRACE" || "$BL64_LIB_DEBUG" == "$BL64_DBG_TARGET_LIB_ALL" ]] &&
    bl64_msg_show_debug "[${FUNCNAME[1]}:${BASH_LINENO[1]}] ${_BL64_DBG_TXT_FUNCTION_START}" &&
    set -x
  return 0
}

#######################################
# Show bashlib64 task level debugging information
#
# Arguments:
#   $1: message
# Outputs:
#   STDOUT: None
#   STDERR: Debug message
# Returns:
#   0: always ok
#######################################
function bl64_dbg_lib_show_info() {
  [[ "$BL64_LIB_DEBUG" != "$BL64_DBG_TARGET_LIB_TASK" && "$BL64_LIB_DEBUG" != "$BL64_DBG_TARGET_LIB_ALL" || "$#" == '0' ]] &&
    return 0
  bl64_msg_show_debug "[${FUNCNAME[1]}:${BASH_LINENO[1]}] ${*}"

  return 0
}

#######################################
# Show app task level debugging information
#
# Arguments:
#   $@: messages
# Outputs:
#   STDOUT: None
#   STDERR: Debug message
# Returns:
#   0: always ok
#######################################
function bl64_dbg_app_show_info() {

  [[ "$BL64_LIB_DEBUG" != "$BL64_DBG_TARGET_APP_TASK" && "$BL64_LIB_DEBUG" != "$BL64_DBG_TARGET_APP_ALL" || "$#" == '0' ]] &&
    return 0
  bl64_msg_show_debug "[${FUNCNAME[1]}:${BASH_LINENO[1]}] ${*}"

  return 0
}

#######################################
# Show bashlib64 task level variable values
#
# Arguments:
#   $@: variable names
# Outputs:
#   STDOUT: None
#   STDERR: Debug message
# Returns:
#   0: always ok
#######################################
function bl64_dbg_lib_show_vars() {
  local variable=''

  [[ "$BL64_LIB_DEBUG" != "$BL64_DBG_TARGET_LIB_TASK" && "$BL64_LIB_DEBUG" != "$BL64_DBG_TARGET_LIB_ALL" || "$#" == '0' ]] &&
    return 0

  for variable in "$@"; do
    eval "bl64_msg_show_debug \"[${FUNCNAME[1]}:${BASH_LINENO[1]}] ${_BL64_DBG_TXT_SHELL_VAR}: [${variable}=\$${variable}]\""
  done

  return 0
}

#######################################
# Show app task level variable values
#
# Arguments:
#   $@: variable names
# Outputs:
#   STDOUT: None
#   STDERR: Debug message
# Returns:
#   0: always ok
#######################################
function bl64_dbg_app_show_vars() {
  local variable=''

  [[ "$BL64_LIB_DEBUG" != "$BL64_DBG_TARGET_APP_TASK" && "$BL64_LIB_DEBUG" != "$BL64_DBG_TARGET_APP_ALL" || "$#" == '0' ]] &&
    return 0

  for variable in "$@"; do
    eval "bl64_msg_show_debug \"[${FUNCNAME[1]}:${BASH_LINENO[1]}] ${_BL64_DBG_TXT_SHELL_VAR}: [${variable}=\$${variable}]\""
  done

  return 0
}

#######################################
# Show bashlib64 function name and parameters
#
# Arguments:
#   $@: parameters
# Outputs:
#   STDOUT: None
#   STDERR: Debug message
# Returns:
#   0: always ok
#######################################
function bl64_dbg_lib_show_function() {

  bl64_dbg_lib_task_enabled || return 0

  bl64_msg_show_debug "[${FUNCNAME[1]}:${BASH_LINENO[1]}] ${_BL64_DBG_TXT_FUNCTION_RUN}: [${*}]"
  return 0
}

#######################################
# Show app function name and parameters
#
# Arguments:
#   $@: parameters
# Outputs:
#   STDOUT: None
#   STDERR: Debug message
# Returns:
#   0: always ok
#######################################
function bl64_dbg_app_show_function() {

  bl64_dbg_app_task_enabled || return 0

  bl64_msg_show_debug "[${FUNCNAME[1]}:${BASH_LINENO[1]}] ${_BL64_DBG_TXT_FUNCTION_RUN}: [${*}]"
  return 0
}

#######################################
# BashLib64 / Manage local filesystem
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.0.0
#######################################

#######################################
# Identify and normalize common *nix OS commands
# Commands are exported as variables with full path
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok, even when the OS is not supported
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_fs_set_command() {
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_FS_CMD_CHMOD='/bin/chmod'
    BL64_FS_CMD_CHOWN='/bin/chown'
    BL64_FS_CMD_CP='/bin/cp'
    BL64_FS_CMD_FIND='/usr/bin/find'
    BL64_FS_CMD_LN='/bin/ln'
    BL64_FS_CMD_LS='/bin/ls'
    BL64_FS_CMD_MKDIR='/bin/mkdir'
    BL64_FS_CMD_MKTEMP='/bin/mktemp'
    BL64_FS_CMD_MV='/bin/mv'
    BL64_FS_CMD_RM='/bin/rm'
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-*)
    BL64_FS_CMD_CHMOD='/usr/bin/chmod'
    BL64_FS_CMD_CHOWN='/usr/bin/chown'
    BL64_FS_CMD_CP='/usr/bin/cp'
    BL64_FS_CMD_FIND='/usr/bin/find'
    BL64_FS_CMD_LN='/bin/ln'
    BL64_FS_CMD_LS='/usr/bin/ls'
    BL64_FS_CMD_MKDIR='/usr/bin/mkdir'
    BL64_FS_CMD_MKTEMP='/usr/bin/mktemp'
    BL64_FS_CMD_MV='/usr/bin/mv'
    BL64_FS_CMD_RM='/usr/bin/rm'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_FS_CMD_CHMOD='/bin/chmod'
    BL64_FS_CMD_CHOWN='/bin/chown'
    BL64_FS_CMD_CP='/bin/cp'
    BL64_FS_CMD_FIND='/usr/bin/find'
    BL64_FS_CMD_LN='/bin/ln'
    BL64_FS_CMD_LS='/bin/ls'
    BL64_FS_CMD_MKDIR='/bin/mkdir'
    BL64_FS_CMD_MKTEMP='/bin/mktemp'
    BL64_FS_CMD_MV='/bin/mv'
    BL64_FS_CMD_RM='/bin/rm'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_FS_CMD_CHMOD='/bin/chmod'
    BL64_FS_CMD_CHOWN='/usr/sbin/chown'
    BL64_FS_CMD_CP='/bin/cp'
    BL64_FS_CMD_FIND='/usr/bin/find'
    BL64_FS_CMD_LN='/bin/ln'
    BL64_FS_CMD_LS='/bin/ls'
    BL64_FS_CMD_MKDIR='/bin/mkdir'
    BL64_FS_CMD_MKTEMP='/usr/bin/mktemp'
    BL64_FS_CMD_MV='/bin/mv'
    BL64_FS_CMD_RM='/bin/rm'
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_fs_set_options() {
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-*)
    BL64_FS_SET_MKDIR_VERBOSE='--verbose'
    BL64_FS_SET_MKDIR_PARENTS='--parents'
    BL64_FS_SET_CHOWN_VERBOSE='--verbose'
    BL64_FS_SET_CHOWN_RECURSIVE='--recursive'
    BL64_FS_SET_CP_VERBOSE='--verbose'
    BL64_FS_SET_CP_RECURSIVE='--recursive'
    BL64_FS_SET_CP_FORCE='--force'
    BL64_FS_SET_CHMOD_VERBOSE='--verbose'
    BL64_FS_SET_CHMOD_RECURSIVE='--recursive'
    BL64_FS_SET_MV_VERBOSE='--verbose'
    BL64_FS_SET_MV_FORCE='--force'
    BL64_FS_SET_RM_VERBOSE='--verbose'
    BL64_FS_SET_RM_FORCE='--force'
    BL64_FS_SET_RM_RECURSIVE='--recursive'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_FS_SET_MKDIR_VERBOSE=' '
    BL64_FS_SET_MKDIR_PARENTS='-p'
    BL64_FS_SET_CHOWN_VERBOSE='-v'
    BL64_FS_SET_CHOWN_RECURSIVE='-R'
    BL64_FS_SET_CP_VERBOSE='-v'
    BL64_FS_SET_CP_RECURSIVE='-R'
    BL64_FS_SET_CP_FORCE='-f'
    BL64_FS_SET_CHMOD_VERBOSE='-v'
    BL64_FS_SET_CHMOD_RECURSIVE='-R'
    BL64_FS_SET_MV_VERBOSE=' '
    BL64_FS_SET_MV_FORCE='-f'
    BL64_FS_SET_RM_VERBOSE=' '
    BL64_FS_SET_RM_FORCE='-f'
    BL64_FS_SET_RM_RECURSIVE='-R'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_FS_SET_MKDIR_VERBOSE='-v'
    BL64_FS_SET_MKDIR_PARENTS='-p'
    BL64_FS_SET_CHOWN_VERBOSE='-v'
    BL64_FS_SET_CHOWN_RECURSIVE='-R'
    BL64_FS_SET_CP_VERBOSE='-v'
    BL64_FS_SET_CP_RECURSIVE='-R'
    BL64_FS_SET_CP_FORCE='-f'
    BL64_FS_SET_CHMOD_VERBOSE='-v'
    BL64_FS_SET_CHMOD_RECURSIVE='-R'
    BL64_FS_SET_MV_VERBOSE='-v'
    BL64_FS_SET_MV_FORCE='-f'
    BL64_FS_SET_RM_VERBOSE='-v'
    BL64_FS_SET_RM_FORCE='-f'
    BL64_FS_SET_RM_RECURSIVE='-R'
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# Create command aliases for common use cases
#
# * Aliases are presented as regular shell variables for easy inclusion in complex commands
# * Use the alias without quotes, otherwise the shell will interprete spaces as part of the command
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
# shellcheck disable=SC2034
function bl64_fs_set_alias() {
  local cmd_mawk='/usr/bin/mawk'

  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-*)
    BL64_FS_ALIAS_LN_SYMBOLIC="${BL64_FS_CMD_LN} --verbose --symbolic"
    BL64_FS_ALIAS_LS_FILES="${BL64_FS_CMD_LS} --color=never"
    ;;
  ${BL64_OS_ALP}-*)
    BL64_FS_ALIAS_LN_SYMBOLIC="${BL64_FS_CMD_LN} -v -s"
    BL64_FS_ALIAS_LS_FILES="${BL64_FS_CMD_LS} --color=never"
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_FS_ALIAS_LN_SYMBOLIC="${BL64_FS_CMD_LN} -v -s"
    BL64_FS_ALIAS_LS_FILES="${BL64_FS_CMD_LS} --color=never"
    ;;
  *) bl64_check_show_unsupported ;;
  esac

  BL64_FS_ALIAS_MKTEMP_DIR="${BL64_FS_CMD_MKTEMP} -d"
  BL64_FS_ALIAS_MKTEMP_FILE="${BL64_FS_CMD_MKTEMP}"
  BL64_FS_ALIAS_CHOWN_DIR="${BL64_FS_CMD_CHOWN} ${BL64_FS_SET_CHOWN_VERBOSE} ${BL64_FS_SET_CHOWN_RECURSIVE}"
  BL64_FS_ALIAS_CP_DIR="${BL64_FS_CMD_CP} ${BL64_FS_SET_CP_VERBOSE} ${BL64_FS_SET_CP_FORCE} ${BL64_FS_SET_CP_RECURSIVE}"
  BL64_FS_ALIAS_CP_DFIND="/usr/bin/find"
  BL64_FS_ALIAS_CP_FILE="${BL64_FS_CMD_CP} ${BL64_FS_SET_CP_VERBOSE} ${BL64_FS_SET_CP_FORCE}"
  BL64_FS_ALIAS_CP_FIFIND="/usr/bin/find"
  BL64_FS_ALIAS_MKDIR_FULL="${BL64_FS_CMD_MKDIR} ${BL64_FS_SET_MKDIR_VERBOSE} ${BL64_FS_SET_MKDIR_PARENTS}"
  BL64_FS_ALIAS_MV="${BL64_FS_CMD_MV} ${BL64_FS_SET_MV_VERBOSE} ${BL64_FS_SET_MV_FORCE}"
  BL64_FS_ALIAS_RM_FILE="${BL64_FS_CMD_RM} ${BL64_FS_SET_RM_VERBOSE} ${BL64_FS_SET_RM_FORCE}"
  BL64_FS_ALIAS_RM_FULL="${BL64_FS_CMD_RM} ${BL64_FS_SET_RM_VERBOSE} ${BL64_FS_SET_RM_FORCE} ${BL64_FS_SET_RM_RECURSIVE}"
}

#######################################
# BashLib64 / Manage local filesystem
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.2.0
#######################################

#######################################
# Create one ore more directories, then set owner and permissions
#
#  Features:
#   * If the new path is already present nothing is done. No error or warning is presented
# Limitations:
#   * Parent directories are not created
#   * No rollback in case of errors. The process will not remove already created paths
# Arguments:
#   $1: permissions. Regular chown format accepted. Default: umask defined
#   $2: user name. Default: root
#   $3: group name. Default: root (or equivalent)
#   $@: full directory paths
# Outputs:
#   STDOUT: command dependant
#   STDERR: command dependant
# Returns:
#   command dependant
#######################################
function bl64_fs_create_dir() {
  bl64_dbg_lib_show_function "$@"
  local mode="${1:-${BL64_LIB_DEFAULT}}"
  local user="${2:-${BL64_LIB_DEFAULT}}"
  local group="${3:-${BL64_LIB_DEFAULT}}"
  local path=''

  # Remove consumed parameters
  bl64_dbg_lib_show_info "parameters:[${*}]"
  shift
  shift
  shift

  # shellcheck disable=SC2086
  (($# == 0)) && bl64_msg_show_error "$_BL64_FS_TXT_MISSING_PARAMETER" && return $BL64_LIB_ERROR_PARAMETER_MISSING
  bl64_dbg_lib_show_info "paths:[${*}]"

  for path in "$@"; do

    bl64_check_path_absolute "$path" || return $?
    [[ -d "$path" ]] && continue
    bl64_fs_mkdir "$path" || return $?

    # Determine if mode needs to be set
    if [[ "$mode" != "$BL64_LIB_DEFAULT" ]]; then
      bl64_fs_chmod "$mode" "$path" || return $?
    fi

    # Determine if owner needs to be set
    if [[ "$user" != "$BL64_LIB_DEFAULT" && "$group" != "$BL64_LIB_DEFAULT" ]]; then
      bl64_fs_chown "${user}:${group}" "$path" || return $?
    fi

  done

  return 0
}

#######################################
# Copy one ore more files to a single destination, then set owner and permissions
#
# Requirements:
#   * Destination path should be present
#   * root privilege (sudo) if paths are restricted or change owner is requested
# Limitations:
#   * No rollback in case of errors. The process will not remove already copied files
# Arguments:
#   $1: permissions. Regular chown format accepted. Default: umask defined
#   $2: user name. Default: root
#   $3: group name. Default: root (or equivalent)
#   $4: destination path
#   $@: full file paths
# Outputs:
#   STDOUT: command dependant
#   STDERR: command dependant
# Returns:
#   command dependant
#######################################
function bl64_fs_copy_files() {
  bl64_dbg_lib_show_function "$@"
  local mode="${1:-${BL64_LIB_DEFAULT}}"
  local user="${2:-${BL64_LIB_DEFAULT}}"
  local group="${3:-${BL64_LIB_DEFAULT}}"
  local destination="${4:-${BL64_LIB_DEFAULT}}"
  local path=''
  local target=''

  bl64_check_directory "$destination" || return $?

  # Remove consumed parameters
  bl64_dbg_lib_show_info "parameters:[${*}]"
  shift
  shift
  shift
  shift

  # shellcheck disable=SC2086
  (($# == 0)) && bl64_msg_show_error "$_BL64_FS_TXT_MISSING_PARAMETER" && return $BL64_LIB_ERROR_PARAMETER_MISSING
  bl64_dbg_lib_show_info "paths:[${*}]"

  for path in "$@"; do

    target=''
    bl64_check_path_absolute "$path" &&
      target="${destination}/$(bl64_fmt_basename "$path")" &&
      bl64_fs_cp_file "$path" "$target" || return $?

    # Determine if mode needs to be set
    if [[ "$mode" != "$BL64_LIB_DEFAULT" ]]; then
      bl64_fs_chmod "$mode" "$target" || return $?
    fi

    # Determine if owner needs to be set
    if [[ "$user" != "$BL64_LIB_DEFAULT" && "$group" != "$BL64_LIB_DEFAULT" ]]; then
      bl64_fs_chown "${user}:${group}" "$target" || return $?
    fi

  done

  return 0
}

#######################################
# Merge 2 or more files into a new one, then set owner and permissions
#
# * Will not overwrite if already existing
#
# Requirements:
#   * root privilege (sudo) if paths are restricted or change owner is requested
# Arguments:
#   $1: permissions. Regular chown format accepted. Default: umask defined
#   $2: user name. Default: root
#   $3: group name. Default: root (or equivalent)
#   $4: destination file. Full path
#   $@: source files. Full path
# Outputs:
#   STDOUT: command dependant
#   STDERR: command dependant
# Returns:
#   command dependant
#   $BL64_FS_ERROR_EXISTING_FILE
#   $BL64_LIB_ERROR_TASK_FAILED
#######################################
function bl64_fs_merge_files() {
  bl64_dbg_lib_show_function "$@"
  local mode="${1:-${BL64_LIB_DEFAULT}}"
  local user="${2:-${BL64_LIB_DEFAULT}}"
  local group="${3:-${BL64_LIB_DEFAULT}}"
  local destination="${4:-${BL64_LIB_DEFAULT}}"
  local path=''
  local -i status_cat=0
  local -i status_file=0

  bl64_check_parameter 'destination' || return $?
  bl64_check_overwrite "$destination" || return $?

  # Remove consumed parameters
  bl64_dbg_lib_show_info "parameters:[${*}]"
  shift
  shift
  shift
  shift

  # shellcheck disable=SC2086
  (($# == 0)) && bl64_msg_show_error "$_BL64_FS_TXT_MISSING_PARAMETER" && return $BL64_LIB_ERROR_PARAMETER_MISSING
  bl64_dbg_lib_show_info "paths:[${*}]"

  for path in "$@"; do
    bl64_check_path_absolute "$path" &&
      "$BL64_OS_CMD_CAT" "$path"
    status_cat=$?
    ((status_cat != 0)) && break
    :
  done >>"$destination"
  status_file=$?

  # Determine if mode needs to be set
  if [[ "$status_file" == '0' && "$status_cat" == '0' && "$mode" != "$BL64_LIB_DEFAULT" ]]; then
    bl64_fs_chmod "$mode" "$destination" || return $?
  fi

  # Determine if owner needs to be set
  if [[ "$status_file" == '0' && "$status_cat" == '0' && "$user" != "$BL64_LIB_DEFAULT" && "$group" != "$BL64_LIB_DEFAULT" ]]; then
    bl64_fs_chown "${user}:${group}" "$destination" || return $?
  fi

  # Rollback if error
  # shellcheck disable=SC2030 # BL64_LIB_VERBOSE is temporary modified in a subshell to avoid changing the global setting
  if ((status_cat != 0 || status_file != 0)); then
    BL64_LIB_VERBOSE="$BL64_LIB_VAR_OFF"
    bl64_fs_rm_file "$destination"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_TASK_FAILED
  fi
  return 0
}

#######################################
# Merge contents from source directory to target
#
# Requirements:
#   * root privilege (sudo) if the files are restricted
# Arguments:
#   $1: source path
#   $2: target path
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   bl64_check_parameter
#   bl64_check_directory
#   command exit status
#######################################
function bl64_fs_merge_dir() {
  bl64_dbg_lib_show_function "$@"
  local source="${1:-${BL64_LIB_DEFAULT}}"
  local target="${2:-${BL64_LIB_DEFAULT}}"
  local -i status=0

  bl64_check_parameter 'source' &&
    bl64_check_parameter 'target' &&
    bl64_check_directory "$source" &&
    bl64_check_directory "$target" ||
    return $?

  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-*)
    bl64_fs_cp_dir --no-target-directory "$source" "$target"
    status=$?
    ;;
  ${BL64_OS_MCOS}-*)
    # shellcheck disable=SC2086
    bl64_fs_cp_dir ${source}/ "$target"
    status=$?
    ;;
  ${BL64_OS_ALP}-*)
    shopt -sq dotglob
    # shellcheck disable=SC2086
    bl64_fs_cp_dir ${source}/* -t "$target"
    status=$?
    shopt -uq dotglob
    ;;
  *)
    bl64_check_show_unsupported
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_INCOMPATIBLE
    ;;

  esac

  return $status
}

#######################################
# Change object ownership with verbose flag
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_fs_chown() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_CHOWN_VERBOSE"

  # shellcheck disable=SC2086
  "$BL64_FS_CMD_CHOWN" $verbose "$@"
}

#######################################
# Change object permission with verbose flag
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_fs_chmod() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_CHMOD_VERBOSE"

  # shellcheck disable=SC2086
  "$BL64_FS_CMD_CHMOD" $verbose "$@"
}

#######################################
# Change directory ownership with verbose and recursive flags
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_fs_chown_dir() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_CHMOD_VERBOSE"

  # shellcheck disable=SC2086
  "$BL64_FS_CMD_CHMOD" $verbose "$BL64_FS_SET_CHOWN_RECURSIVE" "$@"
}

#######################################
# Copy files with verbose and force flags
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_fs_cp_file() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_CP_VERBOSE"

  # shellcheck disable=SC2086
  "$BL64_FS_CMD_CP" $verbose "$BL64_FS_SET_CP_FORCE" "$@"
}

#######################################
# Copy directory recursively with verbose and force flags
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_fs_cp_dir() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_CP_VERBOSE"

  # shellcheck disable=SC2086
  "$BL64_FS_CMD_CP" $verbose "$BL64_FS_SET_CP_FORCE" "$BL64_FS_SET_CP_RECURSIVE" "$@"
}

#######################################
# Create a symbolic link with verbose flag
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_fs_ln_symbolic() {
  bl64_dbg_lib_show_function "$@"
  $BL64_FS_ALIAS_LN_SYMBOLIC "$@"
}

#######################################
# List files with nocolor flag
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_fs_ls_files() {
  bl64_dbg_lib_show_function "$@"
  $BL64_FS_ALIAS_LS_FILES "$@"
}

#######################################
# Create full path including parents. Uses verbose flag
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_fs_mkdir() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_MKDIR_VERBOSE"

  # shellcheck disable=SC2086
  "$BL64_FS_CMD_MKDIR" $verbose "$@"
}

#######################################
# Create full path including parents. Uses verbose flag
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_fs_mkdir_full() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_MKDIR_VERBOSE"

  # shellcheck disable=SC2086
  "$BL64_FS_CMD_MKDIR" $verbose "$BL64_FS_SET_MKDIR_PARENTS" "$@"
}

#######################################
# Move files using the verbose and force flags
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_fs_mv() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_MV_VERBOSE"

  # shellcheck disable=SC2086
  "$BL64_FS_CMD_MV" $verbose "$BL64_FS_SET_MV_FORCE" "$@"
}

#######################################
# Remove files using the verbose and force flags. Limited to current filesystem
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_fs_rm_file() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_RM_VERBOSE"

  # shellcheck disable=SC2086
  "$BL64_FS_CMD_RM" $verbose "$BL64_FS_SET_RM_FORCE" "$@"
}

#######################################
# Remove directories using the verbose and force flags. Limited to current filesystem
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_fs_rm_full() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_dbg_lib_command_enabled && verbose="$BL64_FS_SET_RM_VERBOSE"

  # shellcheck disable=SC2086
  "$BL64_FS_CMD_RM" $verbose "$BL64_FS_SET_RM_FORCE" "$BL64_FS_SET_RM_RECURSIVE" "$@"
}

#######################################
# Remove content from OS temporary repositories
#
# Arguments:
#   None
# Outputs:
#   STDOUT: rm output
#   STDERR: rm stderr
# Returns:
#   0: always ok
#######################################
function bl64_fs_cleanup_tmps() {
  bl64_dbg_lib_show_function
  bl64_fs_rm_full -- /tmp/[[:alnum:]]*
  bl64_fs_rm_full -- /var/tmp/[[:alnum:]]*
  return 0
}

#######################################
# Remove or reset logs from standard locations
#
# Arguments:
#   None
# Outputs:
#   STDOUT: rm output
#   STDERR: rm stderr
# Returns:
#   0: always ok
#######################################
function bl64_fs_cleanup_logs() {
  bl64_dbg_lib_show_function
  local target='/var/log'

  if [[ -d "$target" ]]; then
    bl64_fs_rm_full ${target}/[[:alnum:]]*
  fi
  return 0
}

#######################################
# Remove or reset OS caches from standard locations
#
# Arguments:
#   None
# Outputs:
#   STDOUT: rm output
#   STDERR: rm stderr
# Returns:
#   0: always ok
#######################################
function bl64_fs_cleanup_caches() {
  bl64_dbg_lib_show_function
  local target='/var/cache/man'

  if [[ -d "$target" ]]; then
    bl64_fs_rm_full ${target}/[[:alnum:]]*
  fi
  return 0
}

#######################################
# Performs a complete cleanup of the OS temporary content
#
# * Removes temporary files
# * Cleans caches
# * Removes logs
#
# Arguments:
#   None
# Outputs:
#   STDOUT: output from clean functions
#   STDERR: output from clean functions
# Returns:
#   0: always ok
#######################################
function bl64_fs_cleanup_full() {
  bl64_dbg_lib_show_function "$@"
  bl64_pkg_cleanup
  bl64_fs_cleanup_tmps
  bl64_fs_cleanup_logs
  bl64_fs_cleanup_caches

  return 0
}

#######################################
# OS command wrapper: find
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_fs_find() {
  bl64_dbg_lib_show_function "$@"

  bl64_check_command "$BL64_FS_CMD_FIND" || return $?

  "$BL64_FS_CMD_FIND" "$@"
}

#######################################
# Find files and report as list
#
# * Not using bl64_fs_find to avoid file expansion for -name
#
# Arguments:
#   $1: search path
#   $2: search pattern. Format: find -name options
# Outputs:
#   STDOUT: file list. One path per line
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_fs_find_files() {
  bl64_dbg_lib_show_function "$@"
  local path="${1:-.}"
  local pattern="${2:-}"

  bl64_check_command "$BL64_FS_CMD_FIND" &&
    bl64_check_directory "$path" || return $?

  # shellcheck disable=SC2086
  "$BL64_FS_CMD_FIND" \
    "$path" \
    -type f \
    ${pattern:+-name "${pattern}"} \
    -print
}

#######################################
# BashLib64 / Format text data
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.4.0
#######################################

#######################################
# Removes comments from text input using the external tool Grep
#
# * Comment delimiter: #
# * All text to the right of the delimiter is removed
#
# Arguments:
#   $1: Full path to the text file. Default: STDIN
# Outputs:
#   STDOUT: Original text with comments removed
#   STDERR: grep Error message
# Returns:
#   0: successfull execution
#   >0: grep command exit status
#######################################
function bl64_fmt_strip_comments() {
  bl64_dbg_lib_show_function "$@"
  local source="${1:--}"

  "$BL64_OS_CMD_GREP" -v -E '^#.*$|^ *#.*$' "$source"
}

#######################################
# Removes starting slash from path
#
# * If path is a single slash or relative path no change is done
#
# Arguments:
#   $1: Target path
# Outputs:
#   STDOUT: Updated path
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_fmt_strip_starting_slash() {
  bl64_dbg_lib_show_function "$@"
  local path="$1"

  # shellcheck disable=SC2086
  if [[ -z "$path" ]]; then
    return $BL64_LIB_VAR_OK
  elif [[ "$path" == '/' ]]; then
    printf '%s' "${path}"
  elif [[ "$path" == /* ]]; then
    printf '%s' "${path:1}"
  else
    printf '%s' "${path}"
  fi
}

#######################################
# Removes ending slash from path
#
# * If path is a single slash or no ending slash is present no change is done
#
# Arguments:
#   $1: Target path
# Outputs:
#   STDOUT: Updated path
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_fmt_strip_ending_slash() {
  bl64_dbg_lib_show_function "$@"
  local path="$1"

  # shellcheck disable=SC2086
  if [[ -z "$path" ]]; then
    return $BL64_LIB_VAR_OK
  elif [[ "$path" == '/' ]]; then
    printf '%s' "${path}"
  elif [[ "$path" == */ ]]; then
    printf '%s' "${path:0:-1}"
  else
    printf '%s' "${path}"
  fi
}

#######################################
# Show the last part (basename) of a path
#
# * The function operates on text data, it doesn't verify path existance
# * The last part can be either a directory or a file
# * Parts are separated by the / character
# * The basename is defined by taking the text to the right of the last separator
# * Function mimics the linux basename command
#
# Examples:
#
#   bl64_fmt_basename '/full/path/to/file' -> 'file'
#   bl64_fmt_basename '/full/path/to/file/' -> ''
#   bl64_fmt_basename 'path/to/file' -> 'file'
#   bl64_fmt_basename 'path/to/file/' -> ''
#   bl64_fmt_basename '/file' -> 'file'
#   bl64_fmt_basename '/' -> ''
#   bl64_fmt_basename 'file' -> 'file'
#
# Arguments:
#   $1: Path
# Outputs:
#   STDOUT: Basename
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_fmt_basename() {
  bl64_dbg_lib_show_function "$@"
  local path="$1"
  local base=''

  if [[ -n "$path" && "$path" != '/' ]]; then
    base="${path##*/}"
  fi

  if [[ -z "$base" || "$base" == */* ]]; then
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_PARAMETER_INVALID
  else
    printf '%s' "$base"
  fi
  return 0
}

#######################################
# Show the directory part of a path
#
# * The function operates on text data, it doesn't verify path existance
# * Parts are separated by the slash (/) character
# * The directory is defined by taking the input string up to the last separator
#
# Examples:
#
#   bl64_fmt_dirname '/full/path/to/file' -> '/full/path/to'
#   bl64_fmt_dirname '/full/path/to/file/' -> '/full/path/to/file'
#   bl64_fmt_dirname '/file' -> '/'
#   bl64_fmt_dirname '/' -> '/'
#   bl64_fmt_dirname 'dir' -> 'dir'
#
# Arguments:
#   $1: Path
# Outputs:
#   STDOUT: Dirname
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_fmt_dirname() {
  bl64_dbg_lib_show_function "$@"
  local path="$1"

  # shellcheck disable=SC2086
  if [[ -z "$path" ]]; then
    return $BL64_LIB_VAR_OK
  elif [[ "$path" == '/' ]]; then
    printf '%s' "${path}"
  elif [[ "$path" != */* ]]; then
    printf '%s' "${path}"
  elif [[ "$path" == /*/* ]]; then
    printf '%s' "${path%/*}"
  elif [[ "$path" == */*/* ]]; then
    printf '%s' "${path%/*}"
  elif [[ "$path" == /* && "${path:1}" != */* ]]; then
    printf '%s' '/'
  fi
}

#######################################
# Convert list to string. Optionally add prefix, postfix to each field
#
# * list: lines separated by \n
# * string: same as original list but with \n replaced with space
#
# Arguments:
#   $1: output field separator. Default: space
#   $2: prefix. Format: string
#   $3: postfix. Format: string
# Inputs:
#   STDIN: list
# Outputs:
#   STDOUT: string
#   STDERR: None
# Returns:
#   always ok
#######################################
function bl64_fmt_list_to_string() {
  bl64_dbg_lib_show_function
  local field_separator="${1:-${BL64_LIB_DEFAULT}}"
  local prefix="${2:-${BL64_LIB_DEFAULT}}"
  local postfix="${3:-${BL64_LIB_DEFAULT}}"

  [[ "$field_separator" == "$BL64_LIB_DEFAULT" ]] && field_separator=' '
  [[ "$prefix" == "$BL64_LIB_DEFAULT" ]] && prefix=''
  [[ "$postfix" == "$BL64_LIB_DEFAULT" ]] && postfix=''

  bl64_os_awk \
    -v field_separator="$field_separator" \
    -v prefix="$prefix" \
    -v postfix="$postfix" \
    '
    BEGIN {
      joined_string = ""
      RS="\n"
    }
    {
      joined_string = ( joined_string == "" ? "" : joined_string field_separator ) prefix $0 postfix
    }
    END { print joined_string }
  '
}

#######################################
# Build a separator line with optional payload
#
# * Separator format: payload + \n
#
# Arguments:
#   $1: Separator payload. Format: string
# Outputs:
#   STDOUT: separator line
#   STDERR: grep Error message
# Returns:
#   printf exit status
#######################################
function bl64_fmt_separator_line() {
  bl64_dbg_lib_show_function "$@"
  local payload="${1:-}"

  printf '%s\n' "$payload"
}

#######################################
# BashLib64 / Manage OS identity and access service
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.0.0
#######################################

#######################################
# Identify and normalize commands
#
# * Commands are exported as variables with full path
# * The caller function is responsible for checking that the target command is present (installed)
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_iam_set_command() {
  bl64_dbg_lib_show_function
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-*)
    BL64_IAM_CMD_USERADD='/usr/sbin/useradd'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_IAM_CMD_USERADD='/usr/sbin/adduser'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_IAM_CMD_USERADD='/usr/bin/dscl'
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# Create command aliases for common use cases
#
# * Aliases are presented as regular shell variables for easy inclusion in complex commands
# * Use the alias without quotes, otherwise the shell will interprete spaces as part of the command
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_iam_set_alias() {
  bl64_dbg_lib_show_function
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-*)
    BL64_IAM_ALIAS_USERADD="$BL64_IAM_CMD_USERADD"
    ;;
  ${BL64_OS_ALP}-*)
    BL64_IAM_ALIAS_USERADD="$BL64_IAM_CMD_USERADD"
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_IAM_ALIAS_USERADD="$BL64_IAM_CMD_USERADD -q . -create"
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# BashLib64 / Manage OS identity and access service
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.5.0
#######################################

#######################################
# Create OS user
#
# Arguments:
#   $1: login name
# Outputs:
#   STDOUT: native user add command output
#   STDERR: native user add command error messages
# Returns:
#   native user add command error status
#######################################
function bl64_iam_user_add() {
  bl64_dbg_lib_show_function "$@"
  local login="$1"

  bl64_check_privilege_root &&
    bl64_check_parameter 'login' ||
    return $?

  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-*)
    $BL64_IAM_ALIAS_USERADD "$login"
    ;;
  ${BL64_OS_ALP}-*)
    $BL64_IAM_ALIAS_USERADD -D "$login"
    ;;
  ${BL64_OS_MCOS}-*)
    $BL64_IAM_ALIAS_USERADD "/Users/${login}"
    ;;
  esac
}

#######################################
# BashLib64 / Write messages to logs
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.3.0
#######################################

#######################################
# Save a log record to the logs repository
#
# Arguments:
#   $1: name of the function, command or script name that is generating the message
#   $2: log message category. Use any of $BL64_LOG_CATEGORY_*
#   $4: message to be saved to the logs repository
# Outputs:
#   STDOUT: None
#   STDERR: execution errors
# Returns:
#   0: log record successfully saved
#   >0: failed to save the log record
#   BL64_LIB_ERROR_MODULE_SETUP_MISSING
#   BL64_LIB_ERROR_MODULE_SETUP_INVALID
#######################################
function _bl64_log_register() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local category="$2"
  local payload="$3"

  if [[ -z "$BL64_LOG_PATH" || -z "$BL64_LOG_VERBOSE" || -z "$BL64_LOG_TYPE" || -z "$BL64_LOG_FS" ]]; then
    bl64_msg_show_error "$_BL64_LOG_TXT_NOT_SETUP"
    return $BL64_LIB_ERROR_MODULE_SETUP_MISSING
  fi

  case "$BL64_LOG_TYPE" in
  "$BL64_LOG_TYPE_FILE")
    printf '%(%d%m%Y%H%M%S)T%s%s%s%s%s%s%s%s%s%s%s%s\n' \
      '-1' \
      "$BL64_LOG_FS" \
      "$HOSTNAME" \
      "$BL64_LOG_FS" \
      "$BL64_SCRIPT_NAME" \
      "$BL64_LOG_FS" \
      "$BL64_SCRIPT_SID" \
      "$BL64_LOG_FS" \
      "${source}" \
      "$BL64_LOG_FS" \
      "$category" \
      "$BL64_LOG_FS" \
      "$payload" >>"$BL64_LOG_PATH"
    ;;
  *)
    bl64_msg_show_error "$_BL64_LOG_TXT_INVALID_TYPE"
    return $BL64_LIB_ERROR_MODULE_SETUP_INVALID
    ;;
  esac
}

#######################################
# Initialize the log repository
#
# Arguments:
#   $1: full path to the log repository
#   $2: show log messages to STDOUT/STDERR?. 1: yes, 0: no
#   $3: log type. Use any of the constants $BL64_LOG_TYPE_*
#   $4: field separator character to be used on each log record
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   BL64_LIB_ERROR_MODULE_SETUP_INVALID
#   BL64_LIB_ERROR_MODULE_SETUP_INVALID
#######################################
function bl64_log_setup() {
  bl64_dbg_lib_show_function "$@"
  local path="$1"
  local verbose="${2:-1}"
  local type="${3:-$BL64_LOG_TYPE_FILE}"
  local fs="${4:-:}"

  bl64_check_parameter "$path" || return $?

  # shellcheck disable=SC2086
  if [[ "$type" != "$BL64_LOG_TYPE_FILE" ]]; then
    bl64_msg_show_error "$_BL64_LOG_TXT_INVALID_TYPE"
    return $BL64_LIB_ERROR_MODULE_SETUP_INVALID
  fi

  # shellcheck disable=SC2086
  if [[ "$verbose" != '0' && "$verbose" != '1' ]]; then
    bl64_msg_show_error "$_BL64_LOG_TXT_INVALID_VERBOSE"
    return $BL64_LIB_ERROR_MODULE_SETUP_INVALID
  fi

  BL64_LOG_PATH="${path}"
  BL64_LOG_VERBOSE="${verbose}"
  BL64_LOG_TYPE="${type}"
  BL64_LOG_FS="${fs}"
  return 0
}

#######################################
# Save a single log record of type 'info' to the logs repository.
# Optionally display the message on STDOUT (BL64_LOG_VERBOSE='1')
#
# Arguments:
#   $1: message to be recorded
#   $2: name of the function, command or script name that is generating the message
# Outputs:
#   STDOUT: message (when BL64_LOG_VERBOSE='1')
#   STDERR: execution errors
# Returns:
#   0: log record successfully saved
#   >0: failed to save the log record
#######################################
function bl64_log_info() {
  bl64_dbg_lib_show_function "$@"
  local payload="$1"
  local source="${2:-${FUNCNAME[1]}}"

  if [[ -n "$BL64_LOG_VERBOSE" && "$BL64_LOG_VERBOSE" == '1' ]]; then
    bl64_msg_show_info "$payload"
  fi

  _bl64_log_register \
    "${source:-main}" \
    "$BL64_LOG_CATEGORY_INFO" \
    "$payload"
}

#######################################
# Save a single log record of type 'task' to the logs repository.
# Optionally display the message on STDOUT (BL64_LOG_VERBOSE='1')
#
# Arguments:
#   $1: message to be recorded
#   $2: name of the function, command or script name that is generating the message
# Outputs:
#   STDOUT: message (when BL64_LOG_VERBOSE='1')
#   STDERR: execution errors
# Returns:
#   0: log record successfully saved
#   >0: failed to save the log record
#######################################
function bl64_log_task() {
  bl64_dbg_lib_show_function "$@"
  local payload="$1"
  local source="${2:-${FUNCNAME[1]}}"

  if [[ -n "$BL64_LOG_VERBOSE" && "$BL64_LOG_VERBOSE" == '1' ]]; then
    bl64_msg_show_task "$payload"
  fi

  _bl64_log_register \
    "${source:-main}" \
    "$BL64_LOG_CATEGORY_TASK" \
    "$payload"
}

#######################################
# Save a single log record of type 'error' to the logs repository.
# Optionally display the message on STDERR (BL64_LOG_VERBOSE='1')
#
# Arguments:
#   $1: message to be recorded
#   $2: name of the function, command or script name that is generating the message
# Outputs:
#   STDOUT: None
#   STDERR: execution errors, message (when BL64_LOG_VERBOSE='1')
# Returns:
#   0: log record successfully saved
#   >0: failed to save the log record
#######################################
function bl64_log_error() {
  bl64_dbg_lib_show_function "$@"
  local payload="$1"
  local source="${2:-${FUNCNAME[1]}}"

  if [[ -n "$BL64_LOG_VERBOSE" && "$BL64_LOG_VERBOSE" == '1' ]]; then
    bl64_msg_show_error "$payload"
  fi

  _bl64_log_register \
    "${source:-main}" \
    "$BL64_LOG_CATEGORY_ERROR" \
    "$payload"
}

#######################################
# Save a single log record of type 'warning' to the logs repository.
# Optionally display the message on STDERR (BL64_LOG_VERBOSE='1')
#
# Arguments:
#   $1: message to be recorded
#   $2: name of the function, command or script name that is generating the message
# Outputs:
#   STDOUT: None
#   STDERR: execution errors, message (when BL64_LOG_VERBOSE='1')
# Returns:
#   0: log record successfully saved
#   >0: failed to save the log record
#######################################
function bl64_log_warning() {
  bl64_dbg_lib_show_function "$@"
  local payload="$1"
  local source="${2:-${FUNCNAME[1]}}"

  if [[ -n "$BL64_LOG_VERBOSE" && "$BL64_LOG_VERBOSE" == '1' ]]; then
    bl64_msg_show_warning "$payload"
  fi

  _bl64_log_register \
    "${source:-main}" \
    "$BL64_LOG_CATEGORY_WARNING" \
    "$payload"
}

#######################################
# Record a log stream and save it to the logs repository.
# Each line is saved as a different log record.
#
# Arguments:
#   $1: short alphanumeric string to identify the log stream
#   $2: name of the function, command or script name that is generating the stream
# Outputs:
#   STDOUT: None
#   STDERR: execution errors
# Returns:
#   0: stream successfully saved
#   >0: failed to save the stream
#######################################
function bl64_log_record() {
  bl64_dbg_lib_show_function "$@"
  local tag="${1:-tag}"
  local source="${2:-${FUNCNAME[1]}}"
  local input_log_line=''

  case "$BL64_LOG_TYPE" in
  "$BL64_LOG_TYPE_FILE")
    while read -r input_log_line; do
      _bl64_log_register \
        "${source:-main}" \
        "$BL64_LOG_CATEGORY_RECORD" \
        "${tag}${BL64_LOG_FS}${input_log_line}"
    done
    ;;
  esac
}

#######################################
# BashLib64 / Msg / Display messages
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.7.0
#######################################

#######################################
# Display message helper
#
# Arguments:
#   $1: type of message
#   $2: message to show
# Outputs:
#   STDOUT: message
#   STDERR: message when type is error or warning
# Returns:
#   printf exit status
#   BL64_LIB_ERROR_MODULE_SETUP_INVALID
#######################################
function _bl64_msg_show() {
  local type="$1"
  local message="$2"

  case "$BL64_MSG_FORMAT" in
  "$BL64_MSG_FORMAT_PLAIN")
    printf "%s: %s\n" \
      "$type" \
      "$message"
    ;;
  "$BL64_MSG_FORMAT_HOST")
    printf "@%s %s: %s\n" \
      "$HOSTNAME" \
      "$type" \
      "$message"
    ;;
  "$BL64_MSG_FORMAT_TIME")
    printf "[%(%d/%b/%Y-%H:%M:%S)T] %s: %s\n" \
      '-1' \
      "$type" \
      "$message"
    ;;
  "$BL64_MSG_FORMAT_CALLER")
    printf "%s %s: %s\n" \
      "$BL64_SCRIPT_NAME" \
      "$type" \
      "$message"
    ;;
  "$BL64_MSG_FORMAT_FULL")
    printf "%s@%s[%(%d/%b/%Y-%H:%M:%S)T] %s: %s\n" \
      "$BL64_SCRIPT_NAME" \
      "$HOSTNAME" \
      '-1' \
      "$type" \
      "$message"
    ;;
  *)
    bl64_msg_show_error "$_BL64_MSG_TXT_INVALID_FORMAT"
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_MODULE_SETUP_INVALID
  esac
}

#######################################
# Setup the message library
#
# Arguments:
#   $1: define message format. One of BL64_MSG_FORMAT_*
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: successfull execution
#   BL64_LIB_ERROR_MODULE_SETUP_INVALID
#######################################
function bl64_msg_setup() {
  local format="$1"

  # shellcheck disable=SC2086
  if [[
    "$format" != "$BL64_MSG_FORMAT_PLAIN" && \
    "$format" != "$BL64_MSG_FORMAT_HOST" && \
    "$format" != "$BL64_MSG_FORMAT_TIME" && \
    "$format" != "$BL64_MSG_FORMAT_CALLER" && \
    "$format" != "$BL64_MSG_FORMAT_FULL"
  ]]; then
    bl64_msg_show_error "$_BL64_MSG_TXT_INVALID_FORMAT"
    return $BL64_LIB_ERROR_MODULE_SETUP_INVALID
  fi

  BL64_MSG_FORMAT="$format"
}

#######################################
# Show script usage information
#
# Arguments:
#   $1: script command line. Include all required and optional components
#   $2: full script usage description
#   $3: list of script commands
#   $4: list of script flags
#   $5: list of script parameters
# Outputs:
#   STDOUT: usage info
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_usage() {
  local usage="${1:-${BL64_LIB_DEFAULT}}"
  local description="${2:-${BL64_LIB_DEFAULT}}"
  local commands="${3:-${BL64_LIB_DEFAULT}}"
  local flags="${4:-${BL64_LIB_DEFAULT}}"
  local parameters="${5:-${BL64_LIB_DEFAULT}}"

  printf '\n%s: %s %s\n\n' "$_BL64_MSG_TXT_USAGE" "$BL64_SCRIPT_NAME" "$usage"

  if [[ "$description" != "$BL64_LIB_DEFAULT" ]]; then
    printf '%s\n\n' "$description"
  fi

  if [[ "$commands" != "$BL64_LIB_DEFAULT" ]]; then
    printf '%s\n%s\n' "$_BL64_MSG_TXT_COMMANDS" "$commands"
  fi

  if [[ "$flags" != "$BL64_LIB_DEFAULT" ]]; then
    printf '%s\n%s\n' "$_BL64_MSG_TXT_FLAGS" "$flags"
  fi

  if [[ "$parameters" != "$BL64_LIB_DEFAULT" ]]; then
    printf '%s\n%s\n' "$_BL64_MSG_TXT_PARAMETERS" "$parameters"
  fi

  return 0
}

#######################################
# Display error message
#
# Arguments:
#   $1: error message
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_error() {
  local message="${1-${BL64_LIB_DEFAULT}}"

  _bl64_msg_show "$_BL64_MSG_TXT_ERROR" "$message" >&2
}

#######################################
# Display warning message
#
# Arguments:
#   $1: warning message
# Outputs:
#   STDOUT: none
#   STDERR: message
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_warning() {
  local message="${1-${BL64_LIB_DEFAULT}}"

  _bl64_msg_show "$_BL64_MSG_TXT_WARNING" "$message" >&2
}

#######################################
# Display info message
#
# Arguments:
#   $1: message
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_info() {
  local message="${1-${BL64_LIB_DEFAULT}}"

  [[ "$BL64_LIB_VERBOSE" == "$BL64_LIB_VAR_OFF" ]] && return 0

  _bl64_msg_show "$_BL64_MSG_TXT_INFO" "$message"
}

#######################################
# Display task message
#
# Arguments:
#   $1: message
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_task() {
  local message="${1-${BL64_LIB_DEFAULT}}"

  [[ "$BL64_LIB_VERBOSE" == "$BL64_LIB_VAR_OFF" ]] && return 0

  _bl64_msg_show "$_BL64_MSG_TXT_TASK" "$message"
}

#######################################
# Display debug message
#
# Arguments:formatting
#   $1: message
# Outputs:
#   STDOUT: None
#   STDERR: messageformatting
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_debug() {
  local message="${1-${BL64_LIB_DEFAULT}}"

  _bl64_msg_show "$_BL64_MSG_TXT_DEBUG" "$message" >&2
}

#######################################
# Display message. Plain output, no extra info.
#
# Arguments:
#   $1: message
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_text() {
  local message="${1-${BL64_LIB_DEFAULT}}"

  [[ "$BL64_LIB_VERBOSE" == "$BL64_LIB_VAR_OFF" ]] && return 0

  printf '%s\n' "$message"
}

#######################################
# Display batch process start message
#
# Arguments:
#   $1: message
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_batch_start() {
  local message="${1-${BL64_LIB_DEFAULT}}"

  [[ "$BL64_LIB_VERBOSE" == "$BL64_LIB_VAR_OFF" ]] && return 0

  _bl64_msg_show "$_BL64_MSG_TXT_BATCH" "[${message}] ${_BL64_MSG_TXT_BATCH_START}"
}

#######################################
# Display batch process complete message
#
# Arguments:
#   $1: process exit status
#   $2: message
# Outputs:
#   STDOUT: message
#   STDERR: None
# Returns:
#   0: successfull execution
#   >0: printf error
#######################################
function bl64_msg_show_batch_finish() {
  local status="$1"
  local message="${2-${BL64_LIB_DEFAULT}}"

  [[ "$BL64_LIB_VERBOSE" == "$BL64_LIB_VAR_OFF" ]] && return 0

  if ((status == 0)); then
    _bl64_msg_show "$_BL64_MSG_TXT_BATCH" "[${message}] ${_BL64_MSG_TXT_BATCH_FINISH_OK}"
  else
    _bl64_msg_show "$_BL64_MSG_TXT_BATCH" "[${message}] ${_BL64_MSG_TXT_BATCH_FINISH_ERROR}: exit-status-${status}"
  fi
}

#######################################
# BashLib64 / OS / Identify OS attributes and provide command aliases
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.0.0
#######################################

#######################################
# Identify and normalize common *nix OS commands
# Commands are exported as variables with full path
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok, even when the OS is not supported
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_os_set_command() {
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_OS_CMD_AWK='/usr/bin/awk'
    BL64_OS_CMD_CAT='/bin/cat'
    BL64_OS_CMD_DATE="/bin/date"
    BL64_OS_CMD_FALSE="/bin/false"
    BL64_OS_CMD_GAWK='/usr/bin/gawk'
    BL64_OS_CMD_GREP='/bin/grep'
    BL64_OS_CMD_HOSTNAME='/bin/hostname'
    BL64_OS_CMD_ID='/usr/bin/id'
    BL64_ARC_CMD_TAR='/bin/tar'
    BL64_OS_CMD_TRUE="/bin/true"
    BL64_OS_CMD_UNAME='/bin/uname'
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-*)
    BL64_OS_CMD_AWK='/usr/bin/awk'
    BL64_OS_CMD_CAT='/usr/bin/cat'
    BL64_OS_CMD_DATE="/usr/bin/date"
    BL64_OS_CMD_FALSE="/usr/bin/false"
    BL64_OS_CMD_GAWK='/usr/bin/gawk'
    BL64_OS_CMD_GREP='/usr/bin/grep'
    BL64_OS_CMD_HOSTNAME='/usr/bin/hostname'
    BL64_OS_CMD_ID='/usr/bin/id'
    BL64_ARC_CMD_TAR='/bin/tar'
    BL64_OS_CMD_TRUE="/usr/bin/true"
    BL64_OS_CMD_UNAME='/bin/uname'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_OS_CMD_AWK='/usr/bin/awk'
    BL64_OS_CMD_CAT='/bin/cat'
    BL64_OS_CMD_DATE="/bin/date"
    BL64_OS_CMD_FALSE="/bin/false"
    BL64_OS_CMD_GAWK='/usr/bin/gawk'
    BL64_OS_CMD_GREP='/bin/grep'
    BL64_OS_CMD_HOSTNAME='/bin/hostname'
    BL64_OS_CMD_ID='/usr/bin/id'
    BL64_ARC_CMD_TAR='/bin/tar'
    BL64_OS_CMD_TRUE="/bin/true"
    BL64_OS_CMD_UNAME='/bin/uname'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_OS_CMD_AWK='/usr/bin/awk'
    BL64_OS_CMD_CAT='/bin/cat'
    BL64_OS_CMD_DATE="/bin/date"
    BL64_OS_CMD_FALSE="/usr/bin/false"
    BL64_OS_CMD_GAWK='/usr/bin/gawk'
    BL64_OS_CMD_GREP='/usr/bin/grep'
    BL64_OS_CMD_HOSTNAME='/bin/hostname'
    BL64_OS_CMD_ID='/usr/bin/id'
    BL64_ARC_CMD_TAR='/usr/bin/tar'
    BL64_OS_CMD_TRUE="/usr/bin/true"
    BL64_OS_CMD_UNAME='/usr/bin/uname'
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_os_set_options() {
  :
}

#######################################
# Create command aliases for common use cases
#
# * Aliases are presented as regular shell variables for easy inclusion in complex commands
# * Use the alias without quotes, otherwise the shell will interprete spaces as part of the command
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_os_set_alias() {
  local cmd_mawk='/usr/bin/mawk'

  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-*)
    if [[ -x "$cmd_mawk" ]]; then
      BL64_OS_ALIAS_AWK="$cmd_mawk"
    else
      BL64_OS_ALIAS_AWK="$BL64_OS_CMD_GAWK --traditional"
    fi
    BL64_OS_ALIAS_ID_USER="${BL64_OS_CMD_ID} -u -n"
    ;;
  ${BL64_OS_ALP}-*)
    BL64_OS_ALIAS_AWK="$BL64_OS_CMD_GAWK --traditional"
    BL64_OS_ALIAS_ID_USER="${BL64_OS_CMD_ID} -u -n"
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_OS_ALIAS_AWK="$BL64_OS_CMD_AWK"
    BL64_OS_ALIAS_ID_USER="${BL64_OS_CMD_ID} -u -n"
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# BashLib64 / OS / Identify OS attributes and provide command aliases
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.12.0
#######################################

function _bl64_os_match() {
  bl64_dbg_lib_show_function "$@"
  local os="$1"
  local item="$2"
  local version="${item##*-}"

  # Pattern: OOO-V.V
  if [[ "$item" == +([[:alpha:]])-+([[:digit:]]).+([[:digit:]]) ]]; then
    [[ "$BL64_OS_DISTRO" == "${os}-${version}" ]]
  # Pattern: OOO-V
  elif [[ "$item" == +([[:alpha:]])-+([[:digit:]]) ]]; then
    [[ "$BL64_OS_DISTRO" == ${os}-${version}.+([[:digit:]]) ]]
  # Pattern: OOO
  else
    [[ "$BL64_OS_DISTRO" == ${os}-+([[:digit:]]).+([[:digit:]]) ]]
  fi
}

# Warning: bootstrap function
function _bl64_os_get_distro_from_uname() {
  bl64_dbg_lib_show_function
  local os_type=''
  local os_version=''
  local cmd_sw_vers='/usr/bin/sw_vers'

  os_type="$(uname)"
  case "$os_type" in
  'Darwin')
    os_version="$("$cmd_sw_vers" -productVersion)"
    BL64_OS_DISTRO="DARWIN-${os_version}"
    ;;
  *) BL64_OS_DISTRO="$BL64_OS_UNK" ;;
  esac

  return 0
}

# Warning: bootstrap function
function _bl64_os_get_distro_from_os_release() {

  # shellcheck disable=SC1091
  source '/etc/os-release'
  if [[ -n "$ID" && -n "$VERSION_ID" ]]; then
    BL64_OS_DISTRO="${ID^^}-${VERSION_ID}"
  fi

  case "$BL64_OS_DISTRO" in
  ${BL64_OS_ALM}-8*) : ;;
  ${BL64_OS_ALP}-3*) : ;;
  ${BL64_OS_CNT}-7*)
    [[ "$BL64_OS_DISTRO" == "${BL64_OS_CNT}-7" ]] && BL64_OS_DISTRO="${BL64_OS_CNT}-7.0"
    ;;
  ${BL64_OS_CNT}-8*)
    [[ "$BL64_OS_DISTRO" == "${BL64_OS_CNT}-8" ]] && BL64_OS_DISTRO="${BL64_OS_CNT}-8.0"
    ;;
  ${BL64_OS_CNT}-9*)
    [[ "$BL64_OS_DISTRO" == "${BL64_OS_CNT}-9" ]] && BL64_OS_DISTRO="${BL64_OS_CNT}-9.0"
    ;;
  ${BL64_OS_DEB}-9*)
    [[ "$BL64_OS_DISTRO" == "${BL64_OS_DEB}-9" ]] && BL64_OS_DISTRO="${BL64_OS_DEB}-9.0"
    ;;
  ${BL64_OS_DEB}-10*)
    [[ "$BL64_OS_DISTRO" == "${BL64_OS_DEB}-10" ]] && BL64_OS_DISTRO="${BL64_OS_DEB}-10.0"
    ;;
  ${BL64_OS_DEB}-11*)
    [[ "$BL64_OS_DISTRO" == "${BL64_OS_DEB}-11" ]] && BL64_OS_DISTRO="${BL64_OS_DEB}-11.0"
    ;;
  ${BL64_OS_FD}-33*)
    [[ "$BL64_OS_DISTRO" == "${BL64_OS_FD}-33" ]] && BL64_OS_DISTRO="${BL64_OS_FD}-33.0"
    ;;
  ${BL64_OS_FD}-34*)
    [[ "$BL64_OS_DISTRO" == "${BL64_OS_FD}-34" ]] && BL64_OS_DISTRO="${BL64_OS_FD}-34.0"
    ;;
  ${BL64_OS_FD}-35*)
    [[ "$BL64_OS_DISTRO" == "${BL64_OS_FD}-35" ]] && BL64_OS_DISTRO="${BL64_OS_FD}-35.0"
    ;;
  ${BL64_OS_OL}-7* | ${BL64_OS_OL}-8*) : ;;
  ${BL64_OS_RHEL}-8*) : ;;
  ${BL64_OS_UB}-20* | ${BL64_OS_UB}-21*) : ;;
  *) BL64_OS_DISTRO="$BL64_OS_UNK" ;;
  esac

  return 0
}

#######################################
# Check if the current OS matches the target list
#
# Arguments:
#   $@: list of normalized OS names. Formats: as defined by bl64_os_get_distro
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: os match
#   BL64_LIB_ERROR_OS_NOT_MATCH
#   BL64_LIB_ERROR_OS_TAG_INVALID
#######################################

function bl64_os_match() {
  bl64_dbg_lib_show_function "$@"
  local item=''

  bl64_dbg_lib_show_info "[OSList=${*}}] / [BL64_OS_DISTRO=${BL64_OS_DISTRO}]"
  # shellcheck disable=SC2086
  for item in "$@"; do
    case "$item" in
    'ALM' | ALM-*) _bl64_os_match "$BL64_OS_ALM" "$item" && return 0 ;;
    'ALP' | ALP-*) _bl64_os_match "$BL64_OS_ALP" "$item" && return 0 ;;
    'CNT' | CNT-*) _bl64_os_match "$BL64_OS_CNT" "$item" && return 0 ;;
    'DEB' | DEB-*) _bl64_os_match "$BL64_OS_DEB" "$item" && return 0 ;;
    'FD' | FD-*) _bl64_os_match "$BL64_OS_FD" "$item" && return 0 ;;
    'MCOS' | MCOS-*) _bl64_os_match "$BL64_OS_MCOS" "$item" && return 0 ;;
    'OL' | OL-*) _bl64_os_match "$BL64_OS_OL" "$item" && return 0 ;;
    'RHEL' | RHEL-*) _bl64_os_match "$BL64_OS_RHEL" "$item" && return 0 ;;
    'UB' | UB-*) _bl64_os_match "$BL64_OS_UB" "$item" && return 0 ;;
    *) return $BL64_LIB_ERROR_OS_TAG_INVALID ;;
    esac
  done

  # shellcheck disable=SC2086
  return $BL64_LIB_ERROR_OS_NOT_MATCH
}

#######################################
# Identify and normalize Linux OS distribution name and version
#
# * Target format: OOO-V.V
#   * OOO: OS short name (tag)
#   * V.V: Version (Major, Minor)
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok, even when the OS is not supported
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_os_get_distro() {
  if [[ -r '/etc/os-release' ]]; then
    _bl64_os_get_distro_from_os_release
  else
    _bl64_os_get_distro_from_uname
  fi

  # Do not use return as this function gets sourced
}

#######################################
# Show current user name
#
# * Based on the BLD_OS_ALIAS_* variables and provided for cases where variables as command can not be used
#
# Arguments:
#   $@: arguments are passed as is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_os_id_user() {
  bl64_dbg_lib_show_function "$@"
  $BL64_OS_ALIAS_ID_USER "$@"
}

#######################################
# OS command wrapper: awk
#
# * Detects OS provided awk and selects the best match
# * The selected awk app is configured for POSIX compatibility and traditional regexp
# * If gawk is required use the BL64_OS_CMD_GAWK variable instead of this function
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_os_awk() {
  bl64_dbg_lib_show_function "$@"
  local awk_cmd='/usr/bin/awk'
  local awk_flags=' '

  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    if [[ -x '/usr/bin/gawk' ]]; then
      awk_cmd='/usr/bin/gawk'
      awk_flags='--posix'
    elif [[ -x '/usr/bin/mawk' ]]; then
      awk_cmd='/usr/bin/mawk'
    fi
    ;;
  ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-*)
    awk_cmd='/usr/bin/gawk'
    awk_flags='--posix'
    ;;
  ${BL64_OS_ALP}-*)
    if [[ -x '/usr/bin/gawk' ]]; then
      awk_cmd='/usr/bin/gawk'
      awk_flags='--posix'
    fi
    ;;
  ${BL64_OS_MCOS}-*)
    awk_cmd='/usr/bin/awk'
    ;;
  *)
    bl64_check_show_unsupported
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_INCOMPATIBLE
    ;;
  esac
  bl64_check_command "$awk_cmd" || return $?

  # shellcheck disable=SC2086
  "$awk_cmd" $awk_flags "$@"
}

#######################################
# BashLib64 / Manage native OS packages
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.0.0
#######################################

#######################################
# Identify and normalize commands
#
# * Commands are exported as variables with full path
# * The caller function is responsible for checking that the target command is present (installed)
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_pkb_set_command() {
  bl64_dbg_lib_show_function
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_FD}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-*)
    BL64_PKG_CMD_DNF='/usr/bin/dnf'
    ;;
  ${BL64_OS_CNT}-8.* | ${BL64_OS_CNT}-9.* | ${BL64_OS_OL}-8.*)
    BL64_PKG_CMD_DNF='/usr/bin/dnf'
    ;;
  ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*)
    BL64_PKG_CMD_YUM='/usr/bin/yum'
    ;;
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_PKG_CMD_APT='/usr/bin/apt-get'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_PKG_CMD_APK='/sbin/apk'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_PKG_CMD_BRW='/opt/homebrew/bin/brew'
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_pkg_set_options() {
  bl64_dbg_lib_show_function
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_FD}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_CNT}-8.* | ${BL64_OS_CNT}-9.* | ${BL64_OS_OL}-8.*)
    BL64_PKG_SET_ASSUME_YES='--assumeyes'
    BL64_PKG_SET_SLIM='--nodocs'
    BL64_PKG_SET_QUIET='--quiet'
    BL64_PKG_SET_VERBOSE='--color=never --verbose'
    ;;
  ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*)
    BL64_PKG_SET_ASSUME_YES='--assumeyes'
    BL64_PKG_SET_SLIM=' '
    BL64_PKG_SET_QUIET='--quiet'
    BL64_PKG_SET_VERBOSE='--color=never --verbose'
    ;;
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_PKG_SET_ASSUME_YES='--assume-yes'
    BL64_PKG_SET_SLIM=' '
    BL64_PKG_SET_QUIET='--quiet'
    BL64_PKG_SET_VERBOSE='--show-progress'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_PKG_SET_ASSUME_YES=' '
    BL64_PKG_SET_SLIM=' '
    BL64_PKG_SET_QUIET='--quiet'
    BL64_PKG_SET_VERBOSE='--verbose'
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_PKG_SET_ASSUME_YES=' '
    BL64_PKG_SET_SLIM=' '
    BL64_PKG_SET_QUIET='--quiet'
    BL64_PKG_SET_VERBOSE='--verbose'
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# Create command aliases for common use cases
#
# * Aliases are presented as regular shell variables for easy inclusion in complex commands
# * Use the alias without quotes, otherwise the shell will interprete spaces as part of the command
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_pkb_set_alias() {
  bl64_dbg_lib_show_function
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_FD}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_CNT}-8.* | ${BL64_OS_CNT}-9.* | ${BL64_OS_OL}-8.*)
    BL64_PKG_ALIAS_DNF_CACHE="$BL64_PKG_CMD_DNF ${BL64_PKG_SET_VERBOSE} makecache"
    BL64_PKG_ALIAS_DNF_INSTALL="$BL64_PKG_CMD_DNF ${BL64_PKG_SET_VERBOSE} ${BL64_PKG_SET_SLIM} ${BL64_PKG_SET_ASSUME_YES} install"
    BL64_PKG_ALIAS_DNF_CLEAN="$BL64_PKG_CMD_DNF clean all"
    ;;
  ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*)
    BL64_PKG_ALIAS_YUM_CACHE="$BL64_PKG_CMD_YUM ${BL64_PKG_SET_VERBOSE} makecache"
    BL64_PKG_ALIAS_YUM_INSTALL="$BL64_PKG_CMD_YUM ${BL64_PKG_SET_VERBOSE} ${BL64_PKG_SET_ASSUME_YES} install"
    BL64_PKG_ALIAS_YUM_CLEAN="$BL64_PKG_CMD_YUM clean all"
    ;;
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    BL64_PKG_ALIAS_APT_CACHE="$BL64_PKG_CMD_APT update ${BL64_PKG_SET_VERBOSE}"
    BL64_PKG_ALIAS_APT_INSTALL="$BL64_PKG_CMD_APT install ${BL64_PKG_SET_ASSUME_YES} ${BL64_PKG_SET_VERBOSE}"
    BL64_PKG_ALIAS_APT_CLEAN="$BL64_PKG_CMD_APT clean"
    ;;
  ${BL64_OS_ALP}-*)
    BL64_PKG_ALIAS_APK_CACHE="$BL64_PKG_CMD_APK update ${BL64_PKG_SET_VERBOSE}"
    BL64_PKG_ALIAS_APK_INSTALL="$BL64_PKG_CMD_APK add ${BL64_PKG_SET_VERBOSE}"
    BL64_PKG_ALIAS_APK_CLEAN="$BL64_PKG_CMD_APK cache clean ${BL64_PKG_SET_VERBOSE}"
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_PKG_ALIAS_BRW_CACHE="$BL64_PKG_CMD_BRW update ${BL64_PKG_SET_VERBOSE}"
    BL64_PKG_ALIAS_BRW_INSTALL="$BL64_PKG_CMD_BRW install ${BL64_PKG_SET_VERBOSE}"
    BL64_PKG_ALIAS_BRW_CLEAN="$BL64_PKG_CMD_BRW cleanup ${BL64_PKG_SET_VERBOSE} --prune=all -s"
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}
#######################################
# BashLib64 / Manage native OS packages
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.9.0
#######################################

#######################################
# Deploy packages
#
# * Before installation: prepares the package manager environment and cache
# * After installation: removes cache and temporary files
#
# Arguments:
#   package list, separated by spaces (expanded with $@)
# Outputs:
#   STDOUT: process output
#   STDERR: process stderr
# Returns:
#   n: process exist status
#######################################
function bl64_pkg_deploy() {
  bl64_dbg_lib_show_function "$@"
  bl64_pkg_prepare &&
    bl64_pkg_install "$@" &&
    bl64_pkg_cleanup
}

#######################################
# Initialize the package manager for installations
#
# Requirements:
#   * root privilege (sudo)
# Arguments:
#   None
# Outputs:
#   STDOUT: package manager stderr
#   STDERR: package manager stderr
# Returns:
#   n: package manager exist status
#######################################
function bl64_pkg_prepare() {
  bl64_dbg_lib_show_function
  local verbose=''

  bl64_check_privilege_root || return $?

  if bl64_dbg_lib_command_enabled; then
    verbose="$BL64_PKG_SET_VERBOSE"
  else
    verbose="$BL64_PKG_SET_QUIET"
  fi

  bl64_msg_show_task "$_BL64_PKG_TXT_PREPARE"
  # shellcheck disable=SC2086
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_FD}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_CNT}-8.* | ${BL64_OS_CNT}-9.* | ${BL64_OS_OL}-8.*)
    "$BL64_PKG_CMD_DNF" $verbose makecache
    ;;
  ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*)
    "$BL64_PKG_CMD_YUM" $verbose makecache
    ;;
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    export DEBIAN_FRONTEND="noninteractive"
    "$BL64_PKG_CMD_APT" update $verbose
    ;;
  ${BL64_OS_ALP}-*)
    "$BL64_PKG_CMD_APK" update $verbose
    ;;
  ${BL64_OS_MCOS}-*)
    "$BL64_PKG_CMD_BRW" update $verbose
    ;;
  *)
    bl64_check_show_unsupported
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_INCOMPATIBLE
    ;;
  esac
}

#######################################
# Install packages
#
# * Assume yes
# * Avoid installing docs (man) when possible
#
# Requirements:
#   * root privilege (sudo)
# Arguments:
#   package list, separated by spaces (expanded with $@)
# Outputs:
#   STDOUT: package manager stderr
#   STDERR: package manager stderr
# Returns:
#   n: package manager exist status
#######################################
function bl64_pkg_install() {
  bl64_dbg_lib_show_function "$@"
  local verbose=''

  bl64_check_privilege_root || return $?

  if bl64_dbg_lib_command_enabled; then
    verbose="$BL64_PKG_SET_VERBOSE"
  else
    verbose="$BL64_PKG_SET_QUIET"
  fi

  bl64_msg_show_task "$_BL64_PKG_TXT_INSTALL"
  # shellcheck disable=SC2086
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_FD}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_CNT}-8.* | ${BL64_OS_CNT}-9.* | ${BL64_OS_OL}-8.*)
    "$BL64_PKG_CMD_DNF" $verbose ${BL64_PKG_SET_SLIM} ${BL64_PKG_SET_ASSUME_YES} install -- "$@"
    ;;
  ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*)
    "$BL64_PKG_CMD_YUM" $verbose ${BL64_PKG_SET_ASSUME_YES} install -- "$@"
    ;;
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    export DEBIAN_FRONTEND="noninteractive"
    "$BL64_PKG_CMD_APT" install $verbose ${BL64_PKG_SET_ASSUME_YES} -- "$@"
    ;;
  ${BL64_OS_ALP}-*)
    "$BL64_PKG_CMD_APK" add $verbose -- "$@"
    ;;
  ${BL64_OS_MCOS}-*)
    "$BL64_PKG_CMD_BRW" install $verbose "$@"
    ;;
  *)
    bl64_check_show_unsupported
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_INCOMPATIBLE
    ;;

  esac
}

#######################################
# Clean up the package manager run-time environment
#
# * Warning: removes cache contents
#
# Requirements:
#   * root privilege (sudo)
# Arguments:
#   None
# Outputs:
#   STDOUT: package manager stderr
#   STDERR: package manager stderr
# Returns:
#   n: package manager exist status
#######################################
function bl64_pkg_cleanup() {
  bl64_dbg_lib_show_function
  local target=''
  local verbose=''

  bl64_check_privilege_root || return $?

  if bl64_dbg_lib_command_enabled; then
    verbose="$BL64_PKG_SET_VERBOSE"
  else
    verbose="$BL64_PKG_SET_QUIET"
  fi

  bl64_msg_show_task "$_BL64_PKG_TXT_CLEAN"
  # shellcheck disable=SC2086
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_FD}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_CNT}-8.* | ${BL64_OS_CNT}-9.* | ${BL64_OS_OL}-8.*)
    "$BL64_PKG_CMD_DNF" clean all $verbose
    ;;
  ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*)
    "$BL64_PKG_CMD_YUM" clean all $verbose
    ;;
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-*)
    export DEBIAN_FRONTEND="noninteractive"
    "$BL64_PKG_CMD_APT" clean
    ;;
  ${BL64_OS_ALP}-*)
    "$BL64_PKG_CMD_APK" cache clean $verbose
    target='/var/cache/apk'
    if [[ -d "$target" ]]; then
      bl64_fs_rm_full ${target}/[[:alpha:]]*
    fi
    ;;
  ${BL64_OS_MCOS}-*)
    "$BL64_PKG_CMD_BRW" cleanup $verbose --prune=all -s
    ;;
  *)
    bl64_check_show_unsupported
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_INCOMPATIBLE
    ;;

  esac
}

#######################################
# BashLib64 / Interact with system-wide Python
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.0.0
#######################################

#######################################
# Identify and normalize commands
#
# * Commands are exported as variables with full path
# * The caller function is responsible for checking that the target command is present (installed)
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_py_set_command() {
  bl64_dbg_lib_show_function

  # Define distro native Python versions
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_CNT}-7.* | ${BL64_OS_OL}-7.*)
    BL64_PY_CMD_PYTHON36='/usr/bin/python3'
    ;;
  ${BL64_OS_CNT}-8.* | ${BL64_OS_RHEL}-8.* | ${BL64_OS_ALM}-8.* | ${BL64_OS_OL}-8.*)
    BL64_PY_CMD_PYTHON36='/usr/bin/python3'
    BL64_PY_CMD_PYTHON39='/usr/bin/python3.9'
    ;;
  ${BL64_OS_RHEL}-9.*)
    BL64_PY_CMD_PYTHON39='/usr/bin/python3.9'
    ;;
  ${BL64_OS_FD}-33.* | ${BL64_OS_FD}-34.*)
    BL64_PY_CMD_PYTHON39='/usr/bin/python3.9'
    ;;
  ${BL64_OS_FD}-35.*)
    BL64_PY_CMD_PYTHON310='/usr/bin/python3.10'
    ;;
  ${BL64_OS_DEB}-9.*)
    BL64_PY_CMD_PYTHON35='/usr/bin/python3.5'
    ;;
  ${BL64_OS_DEB}-10.*)
    BL64_PY_CMD_PYTHON37='/usr/bin/python3.7'
    ;;
  ${BL64_OS_DEB}-11.*)
    BL64_PY_CMD_PYTHON39='/usr/bin/python3.9'
    ;;
  ${BL64_OS_UB}-20.*)
    BL64_PY_CMD_PYTHON39='/usr/bin/python3.9'
    ;;
  ${BL64_OS_UB}-21.*)
    BL64_PY_CMD_PYTHON310='/usr/bin/python3.10'
    ;;
  ${BL64_OS_ALP}-3.*)
    BL64_PY_CMD_PYTHON39='/usr/bin/python3.9'
    ;;
  ${BL64_OS_MCOS}-12.*)
    BL64_PY_CMD_PYTHON39='/usr/bin/python3.9'
    ;;
  *) bl64_check_show_unsupported ;;
  esac

  # Select best match for default python or leave default if no better option found
  if [[ -x "$BL64_PY_CMD_PYTHON310" ]]; then
    BL64_PY_CMD_PYTHON3="$BL64_PY_CMD_PYTHON310"
  elif [[ -x "$BL64_PY_CMD_PYTHON39" ]]; then
    BL64_PY_CMD_PYTHON3="$BL64_PY_CMD_PYTHON39"
  elif [[ -x "$BL64_PY_CMD_PYTHON37" ]]; then
    BL64_PY_CMD_PYTHON3="$BL64_PY_CMD_PYTHON37"
  elif [[ -x "$BL64_PY_CMD_PYTHON36" ]]; then
    BL64_PY_CMD_PYTHON3="$BL64_PY_CMD_PYTHON36"
  elif [[ -x "$BL64_PY_CMD_PYTHON35" ]]; then
    BL64_PY_CMD_PYTHON3="$BL64_PY_CMD_PYTHON35"
  else
    BL64_PY_CMD_PYTHON3="/usr/bin/python3"
  fi
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_py_set_options() {
  bl64_dbg_lib_show_function
  # Common sets - unversioned
  BL64_PY_SET_PIP_VERBOSE='--verbose'
  BL64_PY_SET_PIP_VERSION='--version'
  BL64_PY_SET_PIP_UPGRADE='--upgrade'
  BL64_PY_SET_PIP_USER='--user'
}

#######################################
# BashLib64 / Interact with system-wide Python
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.1.0
#######################################

#######################################
# Python PIP caller
#
# Arguments:
#   $@: arguments are passes as-is
# Outputs:
#   STDOUT: PIP output
#   STDERR: PIP error
# Returns:
#   PIP exit status
#######################################
function bl64_py_pip_run() {
  bl64_dbg_lib_show_function "$@"
  local debug=''

  bl64_check_command "$BL64_PY_CMD_PYTHON3" || return $?

  bl64_dbg_lib_command_enabled && debug="$BL64_PY_SET_PIP_VERBOSE"

  bl64_dbg_lib_show_info "arguments:[$*]"
  "$BL64_PY_CMD_PYTHON3" -m 'pip' $debug "$@"
}

#######################################
# Get Python PIP version
#
# Arguments:
#   None
# Outputs:
#   STDOUT: PIP version
#   STDERR: PIP error
# Returns:
#   0: ok
#   $BL64_LIB_ERROR_APP_INCOMPATIBLE
#######################################
function bl64_py_pip_get_version() {
  bl64_dbg_lib_show_function
  local -a version

  read -r -a version < <("$BL64_PY_CMD_PYTHON3" -m 'pip' "$BL64_PY_SET_PIP_VERSION")
  if [[ "${version[1]}" == [0-9.]* ]]; then
    printf '%s' "${version[1]}"
  else
    # shellcheck disable=SC2086
    return $BL64_LIB_ERROR_APP_INCOMPATIBLE
  fi

  return 0
}

#######################################
# Initialize package manager for local-user
#
# * Upgrade pip
# * Install/upgrade setuptools
#
# Arguments:
#   None
# Outputs:
#   STDOUT: package manager stderr
#   STDERR: package manager stderr
# Returns:
#   n: package manager exist status
#######################################
function bl64_py_pip_usr_prepare() {
  bl64_dbg_lib_show_function
  local modules_pip='pip'
  local modules_setup='setuptools wheel stevedore'

  bl64_msg_show_task "$_BL64_PY_TXT_PIP_PREPARE_PIP"
  bl64_py_pip_run \
    'install' \
    $BL64_PY_SET_PIP_UPGRADE \
    $BL64_PY_SET_PIP_USER \
    $modules_pip

  bl64_msg_show_task "$_BL64_PY_TXT_PIP_PREPARE_SETUP"
  # shellcheck disable=SC2086
  bl64_py_pip_run \
    'install' \
    $BL64_PY_SET_PIP_UPGRADE \
    $BL64_PY_SET_PIP_USER \
    $modules_setup

}

#######################################
# Install packages for local-user
#
# * Assume yes
#
# Arguments:
#   package list, separated by spaces (expanded with $@)
# Outputs:
#   STDOUT: package manager stderr
#   STDERR: package manager stderr
# Returns:
#   n: package manager exist status
#######################################
function bl64_py_pip_usr_install() {
  bl64_dbg_lib_show_function "$@"
  bl64_msg_show_task "$_BL64_PY_TXT_PIP_INSTALL"
  bl64_py_pip_run \
    'install' \
    $BL64_PY_SET_PIP_USER \
    "$@"
}

#######################################
# BashLib64 / Manage role based access service
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.0.0
#######################################

#######################################
# Identify and normalize commands
#
# * Commands are exported as variables with full path
# * The caller function is responsible for checking that the target command is present (installed)
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_rbac_set_command() {
  bl64_dbg_lib_show_function
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_ALP}-* | ${BL64_OS_MCOS}-*)
    BL64_RBAC_CMD_SUDO='/usr/bin/sudo'
    BL64_RBAC_CMD_VISUDO='/usr/sbin/visudo'
    BL64_RBAC_FILE_SUDOERS='/etc/sudoers'
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# Create command aliases for common use cases
#
# * Aliases are presented as regular shell variables for easy inclusion in complex commands
# * Use the alias without quotes, otherwise the shell will interprete spaces as part of the command
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_rbac_set_alias() {
  bl64_dbg_lib_show_function
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_ALP}-* | ${BL64_OS_MCOS}-*)
    BL64_RBAC_ALIAS_SUDO_ENV="$BL64_RBAC_CMD_SUDO --preserve-env --set-home"
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# Run privileged OS command using Sudo if needed
#
# Arguments:
#   $@: command and arguments to run
# Outputs:
#   STDOUT: command or sudo output
#   STDERR: command or sudo error
# Returns:
#   command or sudo exit status
#######################################
function bl64_rbac_run_command() {
  bl64_dbg_lib_show_function "$@"
  local -i status=0

  # shellcheck disable=SC2086
  (($# == 0)) && return $BL64_RBAC_ERROR_MISSING_PARAMETER
  # shellcheck disable=SC2086
  bl64_check_command "$BL64_RBAC_CMD_SUDO" || return $BL64_RBAC_ERROR_MISSING_SUDO

  # Check the effective user id
  if [[ "$EUID" == '0' ]]; then
    # Already root, execute command directly
    "$@"
  else
    # Current user is regular, use SUDO
    $BL64_RBAC_ALIAS_SUDO_ENV "$@"
  fi
  status=$?

  return $status
}

#######################################
# BashLib64 / Manage role based access service
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.6.0
#######################################

#######################################
# Add password-less root privilege
#
# Arguments:
#   $1: user name. User must already be present.
# Outputs:
#   STDOUT: None
#   STDERR: execution errors
# Returns:
#   0: rule added
#   >0: failed command exit status
#######################################
function bl64_rbac_add_root() {
  bl64_dbg_lib_show_function "$@"
  local user="$1"
  local new_sudoers="${BL64_RBAC_FILE_SUDOERS}.bl64_new"
  local old_sudoers="${BL64_RBAC_FILE_SUDOERS}.bl64_old"
  local -i status=0

  bl64_check_privilege_root &&
    bl64_check_parameter 'user' &&
    bl64_check_file "$BL64_RBAC_FILE_SUDOERS" &&
    bl64_rbac_check_sudoers "$BL64_RBAC_FILE_SUDOERS" ||
    return $?

  umask 0266
  # shellcheck disable=SC2016
  bl64_os_awk \
    -v ControlUsr="$user" \
    '
      BEGIN { Found = 0 }
      ControlUsr " ALL=(ALL) NOPASSWD: ALL" == $0 { Found = 1 }
      { print $0 }
      END {
        if( Found == 0) {
          print( ControlUsr " ALL=(ALL) NOPASSWD: ALL" )
        }
      }
    ' \
    "$BL64_RBAC_FILE_SUDOERS" >"$new_sudoers"

  if [[ -s "$new_sudoers" ]]; then
    bl64_fs_cp_file "${BL64_RBAC_FILE_SUDOERS}" "$old_sudoers"
  fi
  if [[ -s "$new_sudoers" && -s "$old_sudoers" ]]; then
    "$BL64_OS_CMD_CAT" "${BL64_RBAC_FILE_SUDOERS}.bl64_new" >"${BL64_RBAC_FILE_SUDOERS}" &&
      bl64_rbac_check_sudoers "$BL64_RBAC_FILE_SUDOERS"
    status=$?
  else
    status=$BL64_LIB_ERROR_TASK_FAILED
  fi

  return $status
}

#######################################
# Use visudo --check to validate sudoers file
#
# Arguments:
#   $1: full path to the sudoers file
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: sudoers sintax ok
#   visudo exit status
#######################################
function bl64_rbac_check_sudoers() {
  bl64_dbg_lib_show_function "$@"
  local sudoers="$1"
  local -i status=0

  bl64_check_privilege_root &&
    bl64_check_command "$BL64_RBAC_CMD_VISUDO" ||
    return $?

  "$BL64_RBAC_CMD_VISUDO" \
    --check \
    --file "$sudoers"
  status=$?

  if ((status != 0)); then
    bl64_msg_show_error "$_BL64_RBAC_TXT_INVALID_SUDOERS ($sudoers)"
  fi

  return $status
}

#######################################
# BashLib64 / Generate random data
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.1.0
#######################################

#######################################
# Generate random integer number between min and max
#
# Arguments:
#   $1: Minimum. Default: BL64_RND_RANDOM_MIN
#   $2: Maximum. Default: BL64_RND_RANDOM_MAX
# Outputs:
#   STDOUT: random number
#   STDERR: execution error
# Returns:
#   0: no error
#   >0: printf error
#   BL64_LIB_ERROR_PARAMETER_RANGE
#   BL64_LIB_ERROR_PARAMETER_RANGE
#######################################
function bl64_rnd_get_range() {
  bl64_dbg_lib_show_function "$@"
  local min="${1:-${BL64_RND_RANDOM_MIN}}"
  local max="${2:-${BL64_RND_RANDOM_MAX}}"
  local modulo=0

  # shellcheck disable=SC2086
  ((min < BL64_RND_RANDOM_MIN)) &&
    bl64_msg_show_error "$_BL64_RND_TXT_LENGHT_MIN $BL64_RND_RANDOM_MIN" && return $BL64_LIB_ERROR_PARAMETER_RANGE
  # shellcheck disable=SC2086
  ((max > BL64_RND_RANDOM_MAX)) &&
    bl64_msg_show_error "$_BL64_RND_TXT_LENGHT_MAX $BL64_RND_RANDOM_MAX" && return $BL64_LIB_ERROR_PARAMETER_RANGE

  modulo=$((max - min + 1))

  printf '%s' "$((min + (RANDOM % modulo)))"
}

#######################################
# Generate numeric string
#
# Arguments:
#   $1: Length. Default: BL64_RND_LENGTH_1
# Outputs:
#   STDOUT: random string
#   STDERR: execution error
# Returns:
#   0: no error
#   >0: printf error
#   BL64_LIB_ERROR_PARAMETER_RANGE
#   BL64_LIB_ERROR_PARAMETER_RANGE
#######################################
function bl64_rnd_get_numeric() {
  bl64_dbg_lib_show_function "$@"
  local length="${1:-${BL64_RND_LENGTH_1}}"
  local seed=''

  # shellcheck disable=SC2086
  ((length < BL64_RND_LENGTH_1)) &&
    bl64_msg_show_error "$_BL64_RND_TXT_LENGHT_MIN $BL64_RND_LENGTH_1" && return $BL64_LIB_ERROR_PARAMETER_RANGE
  # shellcheck disable=SC2086
  ((length > BL64_RND_LENGTH_20)) &&
    bl64_msg_show_error "$_BL64_RND_TXT_LENGHT_MAX $BL64_RND_LENGTH_20" && return $BL64_LIB_ERROR_PARAMETER_RANGE

  seed="${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}"
  printf '%s' "${seed:0:$length}"
}

#######################################
# Generate alphanumeric string
#
# Arguments:
#   $1: Minimum. Default: BL64_RND_RANDOM_MIN
#   $2: Maximum. Default: BL64_RND_RANDOM_MAX
# Outputs:
#   STDOUT: random string
#   STDERR: execution error
# Returns:
#   0: no error
#   >0: printf error
#   BL64_LIB_ERROR_PARAMETER_RANGE
#   BL64_LIB_ERROR_PARAMETER_RANGE
#######################################
function bl64_rnd_get_alphanumeric() {
  bl64_dbg_lib_show_function "$@"
  local length="${1:-${BL64_RND_LENGTH_1}}"
  local output=''
  local item=''
  local index=0
  local count=0

  ((length < BL64_RND_LENGTH_1)) &&
    bl64_msg_show_error "$_BL64_RND_TXT_LENGHT_MIN $BL64_RND_LENGTH_1" && return $BL64_LIB_ERROR_PARAMETER_RANGE
  ((length > BL64_RND_LENGTH_100)) &&
    bl64_msg_show_error "$_BL64_RND_TXT_LENGHT_MAX $BL64_RND_LENGTH_100" && return $BL64_LIB_ERROR_PARAMETER_RANGE

  while ((count < length)); do
    index=$(bl64_rnd_get_range '0' "$BL64_RND_POOL_ALPHANUMERIC_MAX_IDX")
    item="$(printf '%s' "${BL64_RND_POOL_ALPHANUMERIC:$index:1}")"
    output="${output}${item}"
    ((count++))
  done

  printf '%s' "$output"
}

#######################################
# BashLib64 / Transfer and Receive data over the network
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.0.0
#######################################

#######################################
# Identify and normalize commands
#
# * Commands are exported as variables with full path
# * The caller function is responsible for checking that the target command is present (installed)
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_rxtx_set_command() {
  bl64_dbg_lib_show_function
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_ALP}-* | ${BL64_OS_MCOS}-*)
    BL64_RXTX_CMD_CURL='/usr/bin/curl'
    BL64_RXTX_CMD_WGET='/usr/bin/wget'
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_rxtx_set_options() {
  bl64_dbg_lib_show_function
  # shellcheck disable=SC2034
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-11.* | ${BL64_OS_FD}-*)
    BL64_RXTX_SET_CURL_VERBOSE='--verbose'
    BL64_RXTX_SET_CURL_SILENT='--silent --no-progress-meter'
    BL64_RXTX_SET_CURL_OUTPUT='--output'
    BL64_RXTX_SET_CURL_SECURE='--config /dev/null'
    BL64_RXTX_SET_CURL_REDIRECT='--location'
    BL64_RXTX_SET_WGET_VERBOSE='--verbose'
    BL64_RXTX_SET_WGET_OUTPUT='--output-document'
    BL64_RXTX_SET_WGET_SECURE='--no-config'
    ;;
  ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_DEB}-9.* | ${BL64_OS_DEB}-10.*)
    BL64_RXTX_SET_CURL_VERBOSE='--verbose'
    BL64_RXTX_SET_CURL_SILENT='--silent'
    BL64_RXTX_SET_CURL_OUTPUT='--output'
    BL64_RXTX_SET_CURL_SECURE='--config /dev/null'
    BL64_RXTX_SET_CURL_REDIRECT='--location'
    BL64_RXTX_SET_WGET_VERBOSE='--verbose'
    BL64_RXTX_SET_WGET_OUTPUT='--output-document'
    BL64_RXTX_SET_WGET_SECURE='--no-config'
    ;;
  ${BL64_OS_ALP}-*)
    BL64_RXTX_SET_CURL_VERBOSE='--verbose'
    BL64_RXTX_SET_CURL_SILENT='--silent'
    BL64_RXTX_SET_CURL_OUTPUT='--output'
    BL64_RXTX_SET_CURL_SECURE='--config /dev/null'
    BL64_RXTX_SET_CURL_REDIRECT='--location'
    BL64_RXTX_SET_WGET_VERBOSE='--verbose'
    BL64_RXTX_SET_WGET_OUTPUT='-O'
    BL64_RXTX_SET_WGET_SECURE=' '
    ;;
  ${BL64_OS_MCOS}-*)
    BL64_RXTX_SET_CURL_VERBOSE='--verbose'
    BL64_RXTX_SET_CURL_SILENT='--silent --no-progress-meter'
    BL64_RXTX_SET_CURL_OUTPUT='--output'
    BL64_RXTX_SET_CURL_SECURE='--config /dev/null'
    BL64_RXTX_SET_CURL_REDIRECT='--location'
    BL64_RXTX_SET_WGET_VERBOSE='--verbose'
    BL64_RXTX_SET_WGET_OUTPUT='--output-document'
    BL64_RXTX_SET_WGET_SECURE='--no-config'
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# Create command aliases for common use cases
#
# * Aliases are presented as regular shell variables for easy inclusion in complex commands
# * Use the alias without quotes, otherwise the shell will interprete spaces as part of the command
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_rxtx_set_alias() {
  bl64_dbg_lib_show_function
  BL64_RXTX_ALIAS_CURL="$BL64_RXTX_CMD_CURL ${BL64_RXTX_SET_CURL_SECURE}"
  BL64_RXTX_ALIAS_WGET="$BL64_RXTX_CMD_WGET ${BL64_RXTX_SET_WGET_SECURE}"
}

#######################################
# BashLib64 / Transfer and Receive data over the network
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.10.0
#######################################

#######################################
# Pull data from web server
#
# * If the destination is already present no update is done unless $3=$BL64_LIB_VAR_ON
#
# Arguments:
#   $1: Source URL
#   $2: Full path to the destination file
#   $3: replace existing content Values: $BL64_LIB_VAR_ON | $BL64_LIB_VAR_OFF (default)
#   $4: permissions. Regular chown format accepted. Default: umask defined
# Outputs:
#   STDOUT: None unless BL64_DBG_TARGET_LIB_CMD
#   STDERR: command error
# Returns:
#   BL64_LIB_ERROR_APP_MISSING
#   command error status
#######################################
function bl64_rxtx_web_get_file() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"
  local destination="$2"
  local replace="${3:-${BL64_LIB_VAR_OFF}}"
  local mode="${4:-${BL64_LIB_DEFAULT}}"
  local verbose="$BL64_RXTX_SET_CURL_SILENT"
  local -i status=0

  bl64_check_parameter 'source' &&
    bl64_check_parameter 'destination' || return $?

  [[ "$replace" == "$BL64_LIB_VAR_OFF" && -e "$destination" ]] && return 0
  _bl64_rxtx_backup "$destination" >/dev/null || return $?

  if [[ -x "$BL64_RXTX_CMD_CURL" ]]; then
    bl64_dbg_lib_command_enabled && verbose="$BL64_RXTX_SET_CURL_VERBOSE"
    $BL64_RXTX_ALIAS_CURL $verbose \
      $BL64_RXTX_SET_CURL_REDIRECT \
      $BL64_RXTX_SET_CURL_OUTPUT "$destination" \
      "$source"
    status=$?
  elif [[ -x "$BL64_RXTX_CMD_WGET" ]]; then
    bl64_dbg_lib_command_enabled && verbose="$BL64_RXTX_SET_WGET_VERBOSE"
    $BL64_RXTX_ALIAS_WGET $verbose \
      $BL64_RXTX_SET_WGET_OUTPUT "$destination" \
      "$source"
    status=$?
  else
    # shellcheck disable=SC2086
    bl64_msg_show_error "$_BL64_RXTX_TXT_MISSING_COMMAND (wget or curl)" &&
      return $BL64_LIB_ERROR_APP_MISSING
  fi

  # Determine if mode needs to be set
  if [[ "$status" == '0' && "$mode" != "$BL64_LIB_DEFAULT" ]]; then
    bl64_fs_chmod "$mode" "$destination"
    status=$?
  fi

  _bl64_rxtx_restore "$destination" "$status" >/dev/null || return $?

  return $status
}

#######################################
# Pull directory contents from git repo
#
# * Content of source path is downloaded into destination (source_path/* --> destionation/). Source path itself is not created
# * If the destination is already present no update is done unless $3=$BL64_LIB_VAR_ON
# * If asked to replace destination, temporary backup is done in case git fails by moving the destination to a temp name
# * Warning: git repo info is removed after pull (.git)
#
# Arguments:
#   $1: URL to the GIT repository
#   $2: source path. Format: relative to the repo URL. Use '.' to download the full repo
#   $3: destination path. Format: full path
#   $3: branch name. Default: main
#   $5: replace existing content. Values: $BL64_LIB_VAR_ON | $BL64_LIB_VAR_OFF (default)
# Outputs:
#   STDOUT: command stdout
#   STDERR: command error
# Returns:
#   BL64_LIB_ERROR_TASK_TEMP
#   command error status
#######################################
function bl64_rxtx_git_get_dir() {
  bl64_dbg_lib_show_function "$@"
  local source_url="${1}"
  local source_path="${2}"
  local destination="${3}"
  local replace="${4:-${BL64_LIB_VAR_OFF}}"
  local branch="${5:-main}"
  local -i status=0

  # shellcheck disable=SC2086
  bl64_check_parameter 'source_url' &&
    bl64_check_parameter 'source_path' &&
    bl64_check_parameter 'destination' &&
    bl64_check_path_relative "$source_path" ||
    return $?

  # Check if destination is already present
  if [[ "$replace" == "$BL64_LIB_VAR_OFF" && -e "$destination" ]]; then
    bl64_msg_show_warning "$_BL64_RXTX_TXT_EXISTING_DESTINATION"
    # shellcheck disable=SC2086
    return $BL64_LIB_VAR_OK
  else
    # Asked to replace, backup first
    _bl64_rxtx_backup "$destination" >/dev/null || return $?
  fi

  # Detect what type of path is requested
  if [[ "$source_path" == '.' || "$source_path" == './' ]]; then
    _bl64_rxtx_git_get_dir_root "$source_url" "$destination" "$branch"
  else
    _bl64_rxtx_git_get_dir_sub "$source_url" "$source_path" "$destination" "$branch"
  fi
  status=$?

  # Remove GIT repo metadata
  if [[ -d "${destination}/.git" ]]; then
    bl64_dbg_lib_show_info 'remove git metadata'
    # shellcheck disable=SC2164
    cd "$destination"
    bl64_fs_rm_full '.git' >/dev/null
  fi

  # Check if restore is needed
  _bl64_rxtx_restore "$destination" "$status" >/dev/null || return $?
  return $status
}

function _bl64_rxtx_git_get_dir_root() {
  bl64_dbg_lib_show_function "$@"
  local source_url="${1}"
  local destination="${2}"
  local branch="${3:-main}"
  local -i status=0
  local repo=''
  local git_name=''
  local transition=''

  repo="$($BL64_FS_ALIAS_MKTEMP_DIR)"
  # shellcheck disable=SC2086
  bl64_check_directory "$repo" "$_BL64_RXTX_TXT_CREATION_PROBLEM" || return $BL64_LIB_ERROR_TASK_TEMP

  git_name="$(bl64_fmt_basename "$source_url")"
  git_name="${git_name/.git/}"
  transition="${repo}/${git_name}"
  bl64_dbg_lib_show_vars 'git_name' 'transition'

  # Clone the repo
  bl64_vcs_git_clone "$source_url" "$repo" "$branch" &&
    # Promote to destination
    [[ -d "$transition" ]] &&
    bl64_dbg_lib_show_info 'promote to destination' &&
    bl64_fs_mv "$transition" "$destination"
  status=$?

  [[ -d "$repo" ]] && bl64_fs_rm_full "$repo" >/dev/null
  return $status
}

function _bl64_rxtx_git_get_dir_sub() {
  bl64_dbg_lib_show_function "$@"
  local source_url="${1}"
  local source_path="${2}"
  local destination="${3}"
  local branch="${4:-main}"
  local -i status=0
  local repo=''
  local target=''
  local source=''
  local transition=''

  repo="$($BL64_FS_ALIAS_MKTEMP_DIR)"
  # shellcheck disable=SC2086
  bl64_check_directory "$repo" "$_BL64_RXTX_TXT_CREATION_PROBLEM" || return $BL64_LIB_ERROR_TASK_TEMP

  # Use transition path to get to the final target path
  source="${repo}/${source_path}"
  target="$(bl64_fmt_basename "$destination")"
  transition="${repo}/transition/${target}"
  bl64_dbg_lib_show_vars 'source' 'target' 'transition'

  bl64_vcs_git_sparse "$source_url" "$repo" "$branch" "$source_path" &&
    [[ -d "$source" ]] &&
    bl64_fs_mkdir_full "${repo}/transition" &&
    bl64_fs_mv "$source" "$transition" >/dev/null &&
    bl64_fs_mv "${transition}" "$destination" >/dev/null
  status=$?

  [[ -d "$repo" ]] && bl64_fs_rm_full "$repo" >/dev/null
  return $status
}

function _bl64_rxtx_backup() {
  bl64_dbg_lib_show_function "$@"
  local destination="$1"
  local backup="${destination}${_BL64_RXTX_BACKUP_POSTFIX}"
  local -i status=0

  if [[ -e "$destination" ]]; then
    bl64_fs_mv "$destination" "$backup"
    status=$?
  fi

  ((status != 0)) && status=$BL64_LIB_ERROR_TASK_BACKUP
  # shellcheck disable=SC2086
  return $status
}

function _bl64_rxtx_restore() {
  bl64_dbg_lib_show_function "$@"
  local destination="$1"
  local result="$2"
  local backup="${destination}${_BL64_RXTX_BACKUP_POSTFIX}"
  local -i status=0

  # Check if restore is needed based on the operation result
  if [[ "$result" == "$BL64_LIB_VAR_OK" ]]; then
    # Operation was ok, backup no longer needed
    [[ -e "$backup" ]] && bl64_fs_rm_full "$backup"
    # shellcheck disable=SC2086
    return $BL64_LIB_VAR_OK
  fi

  # Remove invalid content
  [[ -e "$destination" ]] && bl64_fs_rm_full "$destination"

  # Restore content from backup
  bl64_fs_mv "$backup" "$destination"
  status=$?

  ((status != 0)) && status=$BL64_LIB_ERROR_TASK_RESTORE
  # shellcheck disable=SC2086
  return $status
}

#######################################
# BashLib64 / Manipulate text files content
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.1.0
#######################################

#######################################
# Search for a whole line in a given text file
#
# Arguments:
#   $1: source file path
#   $2: text to look for
# Outputs:
#   STDOUT: none
#   STDERR: Error messages
# Returns:
#   0: line was found
#   >0: grep command exit status
#######################################
function bl64_txt_search_line() {
  bl64_dbg_lib_show_function "$@"
  local source="${1:--}"
  local line="$2"

  "$BL64_OS_CMD_GREP" -E "^${line}$" "$source" > /dev/null
}

#######################################
# BashLib64 / Manage Version Control System
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.0.0
#######################################

#######################################
# Identify and normalize commands
#
# * Commands are exported as variables with full path
# * The caller function is responsible for checking that the target command is present (installed)
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_vcs_set_command() {
  bl64_dbg_lib_show_function
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_ALP}-* | ${BL64_OS_MCOS}-*)
    BL64_VCS_CMD_GIT='/usr/bin/git'
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# Create command aliases for common use cases
#
# * Aliases are presented as regular shell variables for easy inclusion in complex commands
# * Use the alias without quotes, otherwise the shell will interprete spaces as part of the command
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_vcs_set_alias() {
  bl64_dbg_lib_show_function
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_ALP}-* | ${BL64_OS_MCOS}-*)
    # shellcheck disable=SC2034
    BL64_VCS_ALIAS_GIT="$BL64_VCS_CMD_GIT"
    ;;
  *) bl64_check_show_unsupported ;;
  esac
}

#######################################
# Create command sets for common options
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
# Warning: bootstrap function: use pure bash, no return, no exit
function bl64_vcs_set_options() {
  bl64_dbg_lib_show_function
  # Common sets - unversioned
  BL64_VCS_SET_GIT_NO_PAGER='--no-pager'
  BL64_VCS_SET_GIT_QUIET=' '
}

#######################################
# BashLib64 / Manage Version Control System
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.9.0
#######################################

#######################################
# GIT CLI wrapper with verbose, debug and common options
#
# Arguments:
#   $@: arguments are passed as-is to the command
# Outputs:
#   STDOUT: command output
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_vcs_run_git() {
  bl64_dbg_lib_show_function "$@"
  local debug="$BL64_VCS_SET_GIT_QUIET"

  bl64_dbg_lib_command_enabled && debug=''

  # shellcheck disable=SC2086
  bl64_dbg_lib_show_info "$BL64_VCS_CMD_GIT" $debug $BL64_VCS_SET_GIT_NO_PAGER "$@"
  # shellcheck disable=SC2086
  "$BL64_VCS_CMD_GIT" $debug $BL64_VCS_SET_GIT_NO_PAGER "$@"
}

#######################################
# Clone GIT branch
#
# * File ownership is set to the current user
# * Destination is created if not existing
#
# Arguments:
#   $1: URL to the GIT repository
#   $2: destination path where the repository will be created
#   $3: branch name. Default: main
# Outputs:
#   STDOUT: git output
#   STDERR: git stderr
# Returns:
#   n: git exit status
#######################################
function bl64_vcs_git_clone() {
  bl64_dbg_lib_show_function "$@"
  local source="${1}"
  local destination="${2}"
  local branch="${3:-main}"

  bl64_check_parameter 'source' &&
    bl64_check_parameter 'destination' &&
    bl64_check_command "$BL64_VCS_CMD_GIT" ||
    return $?

  bl64_fs_create_dir "${BL64_LIB_DEFAULT}" "${BL64_LIB_DEFAULT}" "${BL64_LIB_DEFAULT}" "$destination" || returnn $?

  # shellcheck disable=SC2164
  cd "$destination"

  bl64_vcs_run_git \
    clone \
    --depth 1 \
    --single-branch \
    --branch "$branch" \
    "$source"
}

#######################################
# Clone partial GIT repository (sparse checkout)
#
# * File ownership is set to the current user
# * Destination is created if not existing
#
# Arguments:
#   $1: URL to the GIT repository
#   $2: destination path where the repository will be created
#   $3: branch name. Default: main
#   $4: include pattern list. Field separator: space
# Outputs:
#   STDOUT: git output
#   STDERR: git stderr
# Returns:
#   n: git exit status
#######################################
function bl64_vcs_git_sparse() {
  bl64_dbg_lib_show_function "$@"
  local source="${1}"
  local destination="${2}"
  local branch="${3:-main}"
  local pattern="${4}"
  local item=''
  local -i status=0

  bl64_check_command "$BL64_VCS_CMD_GIT" &&
    bl64_check_parameter 'source' &&
    bl64_check_parameter 'destination' &&
    bl64_check_parameter 'pattern' || return $?

  bl64_fs_create_dir "${BL64_LIB_DEFAULT}" "${BL64_LIB_DEFAULT}" "${BL64_LIB_DEFAULT}" "$destination" || returnn $?

  # shellcheck disable=SC2164
  cd "$destination"

  if bl64_os_match 'DEB-9' 'DEB-10' 'UB-20' 'OL-7' 'CNT-7'; then
    # shellcheck disable=SC2086
    bl64_vcs_run_git init &&
      bl64_vcs_run_git remote add origin "$source" &&
      bl64_vcs_run_git config core.sparseCheckout true &&
      {
        IFS=' '
        for item in $pattern; do echo "$item" >>'.git/info/sparse-checkout'; done
        unset IFS
      } &&
      bl64_vcs_run_git pull --depth 1 origin "$branch"
  else
    # shellcheck disable=SC2086
    bl64_vcs_run_git init &&
      bl64_vcs_run_git sparse-checkout set &&
      {
        IFS=' '
        for item in $pattern; do echo "$item"; done | bl64_vcs_run_git sparse-checkout add --stdin
      } &&
      bl64_vcs_run_git remote add origin "$source" &&
      bl64_vcs_run_git pull --depth 1 origin "$branch"
  fi
  status=$?

  return $status
}

#######################################
# BashLib64 / Manipulate CSV like text files
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.2.0
#######################################

#######################################
# Dump file to STDOUT without comments and spaces
#
# Arguments:
#   $1: Full path to the file
# Outputs:
#   STDOUT: file content
#   STDERR: Error messages
# Returns:
#   0: successfull execution
#   BL64_LIB_ERROR_FILE_*
#######################################
function bl64_xsv_dump() {
  bl64_dbg_lib_show_function "$@"
  local source="$1"

  bl64_check_parameter 'source' &&
    bl64_check_file "$source" "$_BL64_XSV_TXT_SOURCE_NOT_FOUND" || return $?

  "$BL64_OS_CMD_GREP" -v -E '^#.*$|^$' "$source"

}

#######################################
# Search for records based on key filters and return matching rows
#
# Arguments:
#   $1: Single string with one ore more search values separated by $BL64_XSV_FS
#   $2: source file path. Default: STDIN
#   $3: one ore more column numbers (keys) where values will be searched. Format: single string using $BL64_XSV_COLON as field separator
#   $4: one or more fields to show on record match. Format: single string using $BL64_XSV_COLON as field separator
#   $5: field separator for the source file. Default: $BL64_XSV_COLON
#   $6: field separator for the output record. Default: $BL64_XSV_COLON
# Outputs:
#   STDOUT: matching records
#   STDERR: Error messages
# Returns:
#   0: successfull execution
#   BL64_XSV_ERROR_MISSING_COMMAND
#   BL64_XSV_ERROR_SEARCH_VALUES
#   >0: awk command exit status
#######################################
function bl64_xsv_search_records() {
  bl64_dbg_lib_show_function "$@"
  local values="$1"
  local source="${2:--}"
  local keys="${3:-1}"
  local fields="${4:-0}"
  local fs_src="${5:-$BL64_XSV_FS_COLON}"
  local fs_out="${6:-$BL64_XSV_FS_COLON}"

  # shellcheck disable=SC2086
  bl64_check_parameter 'values' 'search value' || return $?

  # shellcheck disable=SC2016
  bl64_os_awk \
    -F "$fs_src" \
    -v VALUES="${values}" \
    -v KEYS="$keys" \
    -v FIELDS="$fields" \
    -v FS_OUT="$fs_out" \
    '
      BEGIN {
        show_total = split( FIELDS, show_fields, ENVIRON["BL64_XSV_FS_COLON"] )
        keys_total = split( KEYS, keys_fields, ENVIRON["BL64_XSV_FS_COLON"] )
        values_total = split( VALUES, values_fields, ENVIRON["BL64_XSV_FS"] )
        if( keys_total != values_total ) {
          exit ENVIRON["BL64_XSV_ERROR_SEARCH_VALUES"]
        }
        row_match = ""
        count = 0
        found = 0
      }
      /^#/ || /^$/ { next }
      {
        found = 0
        for( count = 1; count <= keys_total; count++ ) {
          if ( $keys_fields[count] == values_fields[count] ) {
            found = 1
          } else {
            found = 0
            break
          }
        }

        if( found == 1 ) {
          row_match = $show_fields[1]
          for( count = 2; count <= show_total; count++ ) {
            row_match = row_match FS_OUT $show_fields[count]
          }
          print row_match
        }
      }
      END {}
    ' \
    "$source"

}

#######################################
# BashLib64 / Setup script run-time environment
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.8.0
#######################################

#
# Main
#

# Do not inherit sensitive environment variables
unset MAIL
unset ENV
unset IFS

# Normalize terminal settings
TERM="${TERM:-vt100}"

# Normalize locales to C
if [[ "$BL64_LIB_LANG" == '1' ]]; then
  LANG='C'
  LC_ALL='C'
  LANGUAGE='C'
fi

# Set strict mode for enhanced security
if [[ "$BL64_LIB_STRICT" == '1' ]]; then
  set -o 'nounset'
  set -o 'privileged'
fi

# Ensure pipeline exit status is failed when any cmd fails
set -o 'pipefail'

# Enable error processing
set -o 'errtrace'
set -o 'functrace'

# Disable fast-fail. Developer must implement error handling (check for exit status)
set +o 'errexit'

# Reset bash set options to defaults
set -o 'braceexpand'
set -o 'hashall'
set +o 'allexport'
set +o 'histexpand'
set +o 'history'
set +o 'ignoreeof'
set +o 'monitor'
set +o 'noclobber'
set +o 'noglob'
set +o 'nolog'
set +o 'notify'
set +o 'onecmd'
set +o 'posix'

# Do not set/unset - Breaks bats-core
# set -o 'keyword'
# set -o 'noexec'

# Detect current OS
bl64_os_get_distro

# Verify lib compatibility
if [[ "$BL64_OS_DISTRO" == "$BL64_OS_UNK" || ("${BASH_VERSINFO[0]}" != '4' && "${BASH_VERSINFO[0]}" != '5') ]]; then
  printf '%s\n' "Fatal: BashLib64 is not supported in the current OS (distro:[${BL64_OS_DISTRO}] / bash:[${BASH_VERSION}] / uname:[$(uname -a))])" >&2
  # Warning: return and exit are not used to avoid terminating the shell when using source to load the lib
  false
else
  bl64_os_set_command
  bl64_os_set_options
  bl64_os_set_alias
  bl64_fs_set_command
  bl64_fs_set_options
  bl64_fs_set_alias
  bl64_arc_set_command
  bl64_iam_set_command
  bl64_iam_set_alias
  bl64_pkb_set_command
  bl64_pkg_set_options
  bl64_pkb_set_alias
  bl64_rbac_set_command
  bl64_rbac_set_alias
  bl64_vcs_set_command
  bl64_vcs_set_options
  bl64_vcs_set_alias
  bl64_rxtx_set_command
  bl64_rxtx_set_options
  bl64_rxtx_set_alias
  bl64_py_set_command
  bl64_py_set_options
  bl64_cnt_set_command

  # Set signal handlers
  # shellcheck disable=SC2064
  if [[ "$BL64_LIB_TRAPS" == "$BL64_LIB_VAR_ON" ]]; then
    trap "$BL64_LIB_SIGNAL_HUP" 'SIGHUP'
    trap "$BL64_LIB_SIGNAL_STOP" 'SIGINT'
    trap "$BL64_LIB_SIGNAL_QUIT" 'SIGQUIT'
    trap "$BL64_LIB_SIGNAL_QUIT" 'SIGTERM'
    trap "$BL64_LIB_SIGNAL_DEBUG" 'DEBUG'
    trap "$BL64_LIB_SIGNAL_EXIT" 'EXIT'
    trap "$BL64_LIB_SIGNAL_ERR" 'ERR'
  fi

  # Capture script path
  bl64_dbg_runtime_get_script_path

  # Enable command mode: the library can be used as a stand-alone script to run embeded functions
  if [[ "$BL64_LIB_CMD" == "$BL64_LIB_VAR_ON" ]]; then
    "$@"
  else
    :
  fi
fi

