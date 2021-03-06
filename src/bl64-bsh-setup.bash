#######################################
# BashLib64 / Module / Functions / Interact with Bash shell
#
# Version: 1.0.0
#######################################

#######################################
# Setup the bashlib64 module
#
# * Warning: bootstrap function
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
function bl64_bsh_setup() {
  bl64_dbg_lib_show_function

  bl64_bsh_set_command ||
    return $?
  BL64_BSH_MODULE="$BL64_LIB_VAR_ON"

}

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
function bl64_bsh_set_command() {
  bl64_dbg_lib_show_function

  case "${BASH_VERSINFO[0]}" in
  4*) BL64_BSH_VERSION='4.0' ;;
  5*) BL64_BSH_VERSION='5.0' ;;
  *)
    bl64_msg_show_error "${_BL64_BSH_TXT_UNSUPPORTED} (${BASH_VERSINFO[0]})" &&
      return $BL64_LIB_ERROR_OS_BASH_VERSION
    ;;
  esac
  bl64_dbg_lib_show_vars 'BL64_BSH_VERSION'
}
