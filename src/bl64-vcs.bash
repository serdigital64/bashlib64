#######################################
# BashLib64 / Manage Version Control System
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.2.0
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
function bl64_vcs_set_command() {
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_ALP}-*)
    BL64_VCS_CMD_GIT='/usr/bin/git'
    ;;
  esac
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
#   BL64_VCS_ERROR_MISSING_PARAMETER
#   BL64_VCS_ERROR_DESTINATION_ERROR
#   BL64_VCS_ERROR_MISSING_COMMAND
#######################################
function bl64_vcs_git_clone() {
  local source="${1}"
  local destination="${2}"
  local branch="${3:-main}"

  # shellcheck disable=SC2086
  bl64_check_command "$BL64_VCS_CMD_GIT" || return $BL64_VCS_ERROR_MISSING_COMMAND

  # shellcheck disable=SC2086
  bl64_check_parameter 'source' 'repository source' &&
    bl64_check_parameter 'destination' 'repository destination' ||
    return $BL64_VCS_ERROR_MISSING_PARAMETER

  [[ ! -d "$destination" ]] && bl64_os_mkdir_full "$destination"
  # shellcheck disable=SC2086
  bl64_check_directory "$destination" || return $BL64_VCS_ERROR_DESTINATION_ERROR

  # shellcheck disable=SC2086
  cd "$destination" || return $BL64_VCS_ERROR_DESTINATION_ERROR

  "$BL64_VCS_CMD_GIT" \
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
#   BL64_VCS_ERROR_MISSING_PARAMETER
#   BL64_VCS_ERROR_DESTINATION_ERROR
#   BL64_VCS_ERROR_MISSING_COMMAND
#######################################
function bl64_vcs_git_sparse() {
  local source="${1}"
  local destination="${2}"
  local branch="${3:-main}"
  local pattern="${4}"
  local include_list=''

  # shellcheck disable=SC2086
  bl64_check_command "$BL64_VCS_CMD_GIT" || return $BL64_VCS_ERROR_MISSING_COMMAND

  # shellcheck disable=SC2086
  bl64_check_parameter 'source' 'repository source' &&
    bl64_check_parameter 'destination' 'repository destination' &&
    bl64_check_parameter 'pattern' 'pattern list' || return $BL64_VCS_ERROR_MISSING_PARAMETER

  [[ ! -d "$destination" ]] && bl64_os_mkdir_full "$destination"
  # shellcheck disable=SC2086
  bl64_check_directory "$destination" || return $BL64_VCS_ERROR_DESTINATION_ERROR

  # shellcheck disable=SC2086
  cd "$destination" || return $BL64_VCS_ERROR_DESTINATION_ERROR

  include_list="$(
    IFS=' '
    for item in $pattern; do echo "$item"; done
  )"

  # shellcheck disable=SC2086
  "$BL64_VCS_CMD_GIT" init &&
    "$BL64_VCS_CMD_GIT" sparse-checkout set &&
    { echo $include_list | "$BL64_VCS_CMD_GIT" sparse-checkout add --stdin; } &&
    "$BL64_VCS_CMD_GIT" remote add origin "$source" &&
    "$BL64_VCS_CMD_GIT" pull --depth 1 origin "$branch"
}