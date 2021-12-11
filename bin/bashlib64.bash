#!/bin/bash
#######################################
# BashLib64
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.3.0
#######################################

[[ -n "$BL64_LIB_DEBUG" && "$BL64_LIB_DEBUG" == '1' ]] && set -x
export BL64_OS_DISTRO
export BL64_OS_CMD_AWK
export BL64_OS_CMD_CAT
export BL64_OS_CMD_CHMOD
export BL64_OS_CMD_CHOWN
export BL64_OS_CMD_CP
export BL64_OS_CMD_CAT
export BL64_OS_CMD_DATE
export BL64_OS_CMD_HOSTNAME
export BL64_OS_CMD_GREP
export BL64_OS_CMD_ID
export BL64_OS_CMD_LS
export BL64_OS_CMD_MKDIR
export BL64_OS_CMD_MKTEMP
export BL64_OS_CMD_RM
export BL64_OS_CMD_SUDO
export BL64_OS_CMD_USERADD
export BL64_OS_ALIAS_CHOWN_DIR
export BL64_OS_ALIAS_CP_FILE
export BL64_OS_ALIAS_ID_USER
export BL64_OS_ALIAS_LS_FILES
export BL64_OS_ALIAS_RM_FILE
export BL64_OS_ALIAS_RM_FULL
export BL64_OS_ALIAS_SUDO_ENV
readonly _BL64_MSG_TXT_USAGE='Usage'
readonly _BL64_MSG_TXT_COMMANDS='Commands'
readonly _BL64_MSG_TXT_FLAGS='Flags'
readonly _BL64_MSG_TXT_PARAMETERS='Parameters'
readonly _BL64_MSG_TXT_ERROR='Error'
readonly _BL64_MSG_TXT_INFO='Info'
readonly _BL64_MSG_TXT_TASK='Task'
readonly _BL64_MSG_TXT_DEBUG='Debug'
readonly _BL64_MSG_TXT_WARNING='Warning'
readonly _BL64_MSG_HEADER='%s@%s[%(%d/%b/%Y-%H:%M:%S)T]'
readonly BL64_LOG_TYPE_FILE='F'
readonly BL64_LOG_CATEGORY_INFO='info'
readonly BL64_LOG_CATEGORY_TASK='task'
readonly BL64_LOG_CATEGORY_DEBUG='debug'
readonly BL64_LOG_CATEGORY_WARNING='warning'
readonly BL64_LOG_CATEGORY_ERROR='error'
readonly BL64_LOG_CATEGORY_RECORD='record'
export BL64_LOG_VERBOSE="${BL64_LOG_VERBOSE:-1}"
export BL64_LOG_FS="${BL64_LOG_FS:-:}"
export BL64_LOG_PATH="${BL64_LOG_PATH:-/dev/null}"
export BL64_LOG_TYPE="${BL64_LOG_TYPE:-$BL64_LOG_TYPE_FILE}"
readonly BL64_CHECK_ERROR_MISSING_PARAMETER=1
readonly BL64_CHECK_ERROR_FILE_NOT_FOUND=2
readonly BL64_CHECK_ERROR_FILE_NOT_READ=3
readonly BL64_CHECK_ERROR_FILE_NOT_EXECUTE=4
readonly _BL64_CHECK_TXT_MISSING_PARAMETER='required parameter is missing'
readonly _BL64_CHECK_TXT_COMMAND_NOT_FOUND='the command is not present'
readonly _BL64_CHECK_TXT_COMMAND_NOT_EXECUTABLE='the command is present but has no execution permission'
readonly _BL64_CHECK_TXT_FILE_NOT_FOUND='the file is not present'
readonly _BL64_CHECK_TXT_FILE_NOT_READABLE='the file is present but has no read permission'
readonly BL64_PKG_CMD_APT='/usr/bin/apt-get'
readonly BL64_PKG_CMD_DNF='/usr/bin/dnf'
readonly BL64_PKG_CMD_YUM='/usr/bin/yum'
readonly BL64_PKG_ALIAS_APT_UPDATE="$BL64_PKG_CMD_APT update"
readonly BL64_PKG_ALIAS_APT_INSTALL="$BL64_PKG_CMD_APT --assume-yes install"
readonly BL64_PKG_ALIAS_APT_CLEAN="$BL64_PKG_CMD_APT clean"
readonly BL64_PKG_ALIAS_DNF_CACHE="$BL64_PKG_CMD_DNF --color=never makecache"
readonly BL64_PKG_ALIAS_DNF_INSTALL="$BL64_PKG_CMD_DNF --color=never --nodocs --assumeyes install"
readonly BL64_PKG_ALIAS_DNF_CLEAN="$BL64_PKG_CMD_DNF clean all"
function bl64_os_get_distro() {
  BL64_OS_DISTRO='UNKNOWN'
  if [[ -r '/etc/os-release' ]]; then
    # shellcheck disable=SC1091
    source '/etc/os-release'
    if [[ -n "$ID" && -n "$VERSION_ID" ]]; then
      BL64_OS_DISTRO="${ID^^}-${VERSION_ID}"
    fi
  fi
  return 0
}
function bl64_os_set_command() {
  if [[ "$BL64_OS_DISTRO" =~ (UBUNTU-.*|FEDORA-.*|CENTOS-.*|OL-.*|DEBIAN-.*) ]]; then
    BL64_OS_CMD_AWK='/usr/bin/awk'
    BL64_OS_CMD_SUDO='/usr/bin/sudo'
    BL64_OS_CMD_USERADD='/usr/sbin/useradd'
  fi
  if [[ "$BL64_OS_DISTRO" =~ (UBUNTU-.*|DEBIAN-.*) ]]; then
    BL64_OS_CMD_CAT='/bin/cat'
    BL64_OS_CMD_CHMOD='/bin/chmod'
    BL64_OS_CMD_CHOWN='/bin/chown'
    BL64_OS_CMD_CP='/bin/cp'
    BL64_OS_CMD_DATE="/bin/date"
    BL64_OS_CMD_GREP='/bin/grep'
    BL64_OS_CMD_HOSTNAME='/bin/hostname'
    BL64_OS_CMD_ID='/bin/id'
    BL64_OS_CMD_LS='/bin/ls'
    BL64_OS_CMD_MKDIR='/bin/mkdir'
    BL64_OS_CMD_MKTEMP='/bin/mktemp'
    BL64_OS_CMD_RM='/bin/rm'
  fi
  if [[ "$BL64_OS_DISTRO" =~ (FEDORA-.*|CENTOS-.*|OL-.*) ]]; then
    BL64_OS_CMD_CAT='/usr/bin/cat'
    BL64_OS_CMD_CHMOD='/usr/bin/chmod'
    BL64_OS_CMD_CHOWN='/usr/bin/chown'
    BL64_OS_CMD_CP='/usr/bin/cp'
    BL64_OS_CMD_DATE="/usr/bin/date"
    BL64_OS_CMD_GREP='/usr/bin/grep'
    BL64_OS_CMD_HOSTNAME='/usr/bin/hostname'
    BL64_OS_CMD_ID='/usr/bin/id'
    BL64_OS_CMD_LS='/usr/bin/ls'
    BL64_OS_CMD_MKDIR='/usr/bin/mkdir'
    BL64_OS_CMD_MKTEMP='/usr/bin/mktemp'
    BL64_OS_CMD_RM='/usr/bin/rm'
  fi
  return 0
}
function bl64_os_set_alias() {
  BL64_OS_ALIAS_CHOWN_DIR="$BL64_OS_CMD_CHOWN --verbose --recursive"
  BL64_OS_ALIAS_CP_FILE="$BL64_OS_CMD_CP --verbose --force"
  BL64_OS_ALIAS_ID_USER="$BL64_OS_CMD_ID -u -n"
  BL64_OS_ALIAS_LS_FILES="$BL64_OS_CMD_LS --color=never"
  BL64_OS_ALIAS_RM_FILE="$BL64_OS_CMD_CP --verbose --force --one-file-system"
  BL64_OS_ALIAS_RM_FULL="$BL64_OS_CMD_CP --verbose --force --one-file-system --recursive"
  BL64_OS_ALIAS_SUDO_ENV="$BL64_OS_CMD_SUDO --preserve-env --set-home"
}
function bl64_os_cleanup_tmps() {
  $BL64_OS_ALIAS_RM_FILE -- /tmp/*
  $BL64_OS_ALIAS_RM_FILE -- /var/tmp/*
  :
}
function bl64_os_cleanup_logs() {
  :
}
function bl64_os_cleanup_caches() {
  :
}
function bl64_os_cleanup_full() {
  bl64_os_cleanup_tmps
  bl64_os_cleanup_logs
  bl64_os_cleanup_caches
  :
}
function bl64_fmt_strip_comments() {
  local source="${1:--}"
  "$BL64_OS_CMD_GREP" -v -E '^#.*$|^ *#.*$' "$source"
}
function bl64_msg_show_usage() {
  local usage="${1:-$BL64_LIB_VAR_TBD}"
  local description="${2:-$BL64_LIB_VAR_NULL}"
  local commands="${3:-$BL64_LIB_VAR_NULL}"
  local flags="${4:-$BL64_LIB_VAR_NULL}"
  local parameters="${5:-$BL64_LIB_VAR_NULL}"
  printf '\n%s: %s %s\n\n' "$_BL64_MSG_TXT_USAGE" "$BL64_SCRIPT_NAME" "$usage"
  if [[ "$description" != "$BL64_LIB_VAR_NULL" ]]; then
    printf '%s\n\n' "$description"
  fi
  if [[ "$commands" != "$BL64_LIB_VAR_NULL" ]]; then
    printf '%s\n%s\n' "$_BL64_MSG_TXT_COMMANDS" "$commands"
  fi
  if [[ "$flags" != "$BL64_LIB_VAR_NULL" ]]; then
    printf '%s\n%s\n' "$_BL64_MSG_TXT_FLAGS" "$flags"
  fi
  if [[ "$parameters" != "$BL64_LIB_VAR_NULL" ]]; then
    printf '%s\n%s\n' "$_BL64_MSG_TXT_PARAMETERS" "$parameters"
  fi
  return 0
}
function bl64_msg_show_error() {
  local message="${1-$BL64_LIB_VAR_TBD}"
  printf "$_BL64_MSG_HEADER %s: %s\n" \
    "$BL64_SCRIPT_NAME" \
    "$HOSTNAME" \
    '-1' \
    "$_BL64_MSG_TXT_ERROR" \
    "$message" >&2
  return 0
}
function bl64_msg_show_warning() {
  local message="${1-$BL64_LIB_VAR_TBD}"
  printf "$_BL64_MSG_HEADER %s: %s\n" \
    "$BL64_SCRIPT_NAME" \
    "$HOSTNAME" \
    '-1' \
    "$_BL64_MSG_TXT_WARNING" \
    "$message" >&2
  return 0
}
function bl64_msg_show_info() {
  local message="${1-$BL64_LIB_VAR_TBD}"
  printf "$_BL64_MSG_HEADER %s: %s\n" \
    "$BL64_SCRIPT_NAME" \
    "$HOSTNAME" \
    '-1' \
    "$_BL64_MSG_TXT_INFO" \
    "$message"
  return 0
}
function bl64_msg_show_task() {
  local message="${1-$BL64_LIB_VAR_TBD}"
  printf "$_BL64_MSG_HEADER %s: %s\n" \
    "$BL64_SCRIPT_NAME" \
    "$HOSTNAME" \
    '-1' \
    "$_BL64_MSG_TXT_TASK" \
    "$message"
  return 0
}
function bl64_msg_show_debug() {
  local message="${1-$BL64_LIB_VAR_TBD}"
  printf "$_BL64_MSG_HEADER %s: %s\n" \
    "$BL64_SCRIPT_NAME" \
    "$HOSTNAME" \
    '-1' \
    "$_BL64_MSG_TXT_DEBUG" \
    "$message" >&2
  return 0
}
function bl64_msg_show_text() {
  local message="${1-$BL64_LIB_VAR_TBD}"
  printf '%s\n' "$message"
  return 0
}
function _bl64_log_register() {
  local source="$1"
  local category="$2"
  local payload="$3"
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
  esac
}
function bl64_log_setup() {
  BL64_LOG_PATH="${1:-$BL64_LOG_PATH}"
  BL64_LOG_VERBOSE="${2:-$BL64_LOG_VERBOSE}"
  BL64_LOG_TYPE="${3:-$BL64_LOG_TYPE}"
  BL64_LOG_FS="${4:-$BL64_LOG_FS}"
  return 0
}
function bl64_log_info() {
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
function bl64_log_task() {
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
function bl64_log_error() {
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
function bl64_log_warning() {
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
function bl64_log_record() {
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
function bl64_check_command() {
  local path="$1"
  if [[ -z "$path" ]]; then
    bl64_msg_show_error "$_BL64_CHECK_TXT_MISSING_PARAMETER (command path)"
    # shellcheck disable=SC2086
    return $BL64_CHECK_ERROR_MISSING_PARAMETER
  fi
  if [[ ! -f "$path" ]]; then
    bl64_msg_show_error "$_BL64_CHECK_TXT_COMMAND_NOT_FOUND ($path)"
    # shellcheck disable=SC2086
    return $BL64_CHECK_ERROR_FILE_NOT_FOUND
  fi
  if [[ ! -x "$path" ]]; then
    bl64_msg_show_error "$_BL64_CHECK_TXT_COMMAND_NOT_EXECUTABLE ($path)"
    # shellcheck disable=SC2086
    return $BL64_CHECK_ERROR_FILE_NOT_EXECUTE
  fi
  :
}
function bl64_check_file() {
  local path="$1"
  if [[ -z "$path" ]]; then
    bl64_msg_show_error "$_BL64_CHECK_TXT_MISSING_PARAMETER (file path)"
    # shellcheck disable=SC2086
    return $BL64_CHECK_ERROR_MISSING_PARAMETER
  fi
  if [[ ! -f "$path" ]]; then
    bl64_msg_show_error "$_BL64_CHECK_TXT_FILE_NOT_FOUND ($path)"
    # shellcheck disable=SC2086
    return $BL64_CHECK_ERROR_FILE_NOT_FOUND
  fi
  if [[ ! -r "$path" ]]; then
    bl64_msg_show_error "$_BL64_CHECK_TXT_FILE_NOT_READABLE ($path)"
    # shellcheck disable=SC2086
    return $BL64_CHECK_ERROR_FILE_NOT_READ
  fi
  :
}
function bl64_pkg_prepare() {
  export LC_ALL="C"
  case "$BL64_OS_DISTRO" in
  UBUNTU-* | DEBIAN-*)
    export DEBIAN_FRONTEND="noninteractive"
    $BL64_PKG_ALIAS_APT_UPDATE
    ;;
  FEDORA-* | CENTOS-* | OL-*)
    $BL64_PKG_ALIAS_DNF_CACHE
    ;;
  esac
}
function bl64_pkg_install() {
  export LC_ALL="C"
  case "$BL64_OS_DISTRO" in
  UBUNTU-* | DEBIAN-*)
    export DEBIAN_FRONTEND="noninteractive"
    $BL64_PKG_ALIAS_APT_INSTALL
    ;;
  FEDORA-* | CENTOS-* | OL-*)
    $BL64_PKG_ALIAS_DNF_INSTALL
    ;;
  esac
}
function bl64_pkg_cleanup() {
  export LC_ALL="C"
  case "$BL64_OS_DISTRO" in
  UBUNTU-* | DEBIAN-*)
    export DEBIAN_FRONTEND="noninteractive"
    $BL64_PKG_ALIAS_APT_CLEAN
    ;;
  FEDORA-* | CENTOS-* | OL-*)
    $BL64_PKG_ALIAS_DNF_CLEAN
    ;;
  esac
}
#######################################
# BashLib64 / Core / Setup run-time environment
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.0.2
#######################################

export LANG
export LC_ALL
export LANGUAGE

export BL64_LIB_DEBUG="${BL64_LIB_DEBUG:-0}"
export BL64_LIB_STRICT="${BL64_LIB_STRICT:-1}"
export BL64_LIB_LANG="${BL64_LIB_LANG:-1}"
export BL64_LIB_SIGNAL_HUP="${BL64_LIB_SIGNAL_HUP:--}"
export BL64_LIB_SIGNAL_STOP="${BL64_LIB_SIGNAL_STOP:--}"
export BL64_LIB_SIGNAL_QUIT="${BL64_LIB_SIGNAL_QUIT:--}"
export BL64_SCRIPT_NAME="${BL64_SCRIPT_NAME:-${0##*/}}"
export BL64_SCRIPT_SID="${BASHPID}"

readonly BL64_LIB_VAR_NULL='__s64__'
readonly BL64_LIB_VAR_TBD='TBD'
#######################################
# BashLib64 / Core / Setup run-time environment
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.0.3
#######################################

#
# Main
#

set -o pipefail

if [[ "$BL64_LIB_STRICT" == '1' ]]; then
  unset -f unalias
  \unalias -a
  unset -f command
  unset MAIL
  unset ENV
  unset IFS
  set -u
  set -p
  set -e
fi

# shellcheck disable=SC2064
trap "$BL64_LIB_SIGNAL_HUP" 'SIGHUP'
# shellcheck disable=SC2064
trap "$BL64_LIB_SIGNAL_STOP" 'SIGINT'
# shellcheck disable=SC2064
trap "$BL64_LIB_SIGNAL_QUIT" 'SIGQUIT'
# shellcheck disable=SC2064
trap "$BL64_LIB_SIGNAL_QUIT" 'SIGTERM'

export TERM="${TERM:-vt100}"

bl64_os_get_distro

case "$BL64_OS_DISTRO" in
UBUNTU-* | FEDORA-* | CENTOS-* | OL-* | DEBIAN-*)
  if [[ "$BL64_LIB_LANG" == '1' ]]; then
    LANG='C'
    LC_ALL='C'
    LANGUAGE='C'
  fi
  ;;
*)
  printf '%s\n' "Fatal: BashLib64 is not supported in the current OS" >&2
  exit 1
  ;;
esac

bl64_os_set_command
bl64_os_set_alias
: