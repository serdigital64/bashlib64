#######################################
# BashLib64 / Module / Functions / Manage OS identity and access service
#
# Version: 1.8.0
#######################################

#######################################
# Create OS user
#
# * If the user is already created nothing is done, no error
#
# Arguments:
#   $1: login name
#   $2: home. Default: os native
# Outputs:
#   STDOUT: native user add command output
#   STDERR: native user add command error messages
# Returns:
#   native user add command error status
#######################################
function bl64_iam_user_add() {
  bl64_dbg_lib_show_function "$@"
  local login="${1:-}"
  local home="${2:-}"

  bl64_check_privilege_root &&
    bl64_check_parameter 'login' ||
    return $?

  if bl64_iam_user_is_created "$login"; then
    bl64_dbg_lib_show_info "user already created, nothing to do ($login)"
    return 0
  fi

  bl64_msg_show_lib_task "$_BL64_IAM_TXT_ADD_USER ($login)"
  # shellcheck disable=SC2086
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    "$BL64_IAM_CMD_USERADD" \
      $BL64_IAM_SET_USERADD_CREATE_HOME \
      ${home:+${BL64_IAM_SET_USERADD_HOME_PATH} "${home}"} \
      "$login"
    ;;
  ${BL64_OS_ALP}-*)
    "$BL64_IAM_CMD_USERADD" \
      $BL64_IAM_SET_USERADD_CREATE_HOME \
      ${home:+${BL64_IAM_SET_USERADD_HOME_PATH} "${home}"} \
      -D \
      "$login"
    ;;
  ${BL64_OS_MCOS}-*)
    "$BL64_IAM_CMD_USERADD" \
      $BL64_IAM_SET_USERADD_CREATE_HOME \
      -q . \
      -create "/Users/${login}"
    ;;
  *) bl64_check_alert_unsupported ;;
  esac
}

#######################################
# Determine if the user is created
#
# Arguments:
#   $1: login name
# Outputs:
#   STDOUT: native user add command output
#   STDERR: native user add command error messages
# Returns:
#   native user add command error status
#######################################
function bl64_iam_user_is_created() {
  bl64_dbg_lib_show_function "$@"
  local user="$1"

  bl64_check_parameter 'user' ||
    return $?

  # Use the ID command to detect if the user is created
  bl64_iam_user_get_id "$user" > /dev/null 2>&1

}

#######################################
# Get user's UID
#
# Arguments:
#   $1: user login name. Default: current user
# Outputs:
#   STDOUT: user ID
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_iam_user_get_id() {
  bl64_dbg_lib_show_function "$@"
  local user="$1"

  # shellcheck disable=SC2086
  case "$BL64_OS_DISTRO" in
  ${BL64_OS_UB}-* | ${BL64_OS_DEB}-* | ${BL64_OS_FD}-* | ${BL64_OS_CNT}-* | ${BL64_OS_RHEL}-* | ${BL64_OS_ALM}-* | ${BL64_OS_OL}-* | ${BL64_OS_RCK}-*)
    "${BL64_IAM_CMD_ID}" -u $user
    ;;
  ${BL64_OS_ALP}-*)
    "${BL64_IAM_CMD_ID}" -u $user
    ;;
  ${BL64_OS_MCOS}-*)
    "${BL64_IAM_CMD_ID}" -u $user
    ;;
  *) bl64_check_alert_unsupported ;;
  esac

}

#######################################
# Get current user name
#
# Arguments:
#   None
# Outputs:
#   STDOUT: user name
#   STDERR: command stderr
# Returns:
#   command exit status
#######################################
function bl64_iam_user_get_current() {
  bl64_dbg_lib_show_function
  "${BL64_IAM_CMD_ID}" -u -n
}
