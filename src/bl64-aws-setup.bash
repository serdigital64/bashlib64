#######################################
# BashLib64 / Module / Setup / Interact with AWS
#
# Version: 1.1.0
#######################################


#
# Module attributes getters
#

function bl64_aws_get_cli_config() {
  bl64_dbg_lib_show_function
  bl64_check_module_setup "$BL64_AWS_MODULE" || return $?
  echo "$BL64_AWS_CLI_CONFIG"
}

function bl64_aws_get_cli_credentials() {
  bl64_dbg_lib_show_function
  bl64_check_module_setup "$BL64_AWS_MODULE" || return $?
  echo "$BL64_AWS_CLI_CREDENTIALS"
}


#######################################
# Setup the bashlib64 module
#
# Arguments:
#   $1: (optional) Full path where commands are
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: setup ok
#   >0: setup failed
#######################################
# shellcheck disable=SC2120
function bl64_aws_setup() {
  bl64_dbg_lib_show_function "$@"
  local aws_bin="${1:-${BL64_LIB_DEFAULT}}"

  if [[ "$aws_bin" != "$BL64_LIB_DEFAULT" ]]; then
    bl64_check_directory "$aws_bin" ||
      return $?
  fi

  bl64_aws_set_command "$aws_bin" &&
    bl64_aws_set_options &&
    bl64_check_command "$BL64_AWS_CMD_AWS" &&
    bl64_aws_set_paths &&
    BL64_AWS_MODULE="$BL64_LIB_VAR_ON"

}

#######################################
# Identify and normalize commands
#
# * If no values are provided, try to detect commands looking for common paths
# * Commands are exported as variables with full path
#
# Arguments:
#   None
# Outputs:
#   STDOUT: None
#   STDERR: None
# Returns:
#   0: always ok
#######################################
function bl64_aws_set_command() {
  bl64_dbg_lib_show_function "$@"
  local aws_bin="${1:-${BL64_LIB_DEFAULT}}"

  if [[ "$aws_bin" == "$BL64_LIB_DEFAULT" ]]; then
    if [[ -x '/home/linuxbrew/.linuxbrew/bin/aws' ]]; then
      aws_bin='/home/linuxbrew/.linuxbrew/bin'
    elif [[ -x '/opt/homebrew/bin/aws' ]]; then
      aws_bin='/opt/homebrew/bin'
    elif [[ -x '/usr/local/bin/aws' ]]; then
      aws_bin='/usr/local/bin'
    elif [[ -x '/opt/aws/bin/aws' ]]; then
      aws_bin='/opt/aws/bin'
    elif [[ -x '/usr/bin/aws' ]]; then
      aws_bin='/usr/bin'
    fi
  else
    [[ ! -x "${aws_bin}/aws" ]] && aws_bin="$BL64_LIB_DEFAULT"
  fi

  if [[ "$aws_bin" != "$BL64_LIB_DEFAULT" ]]; then
    [[ -x "${aws_bin}/aws" ]] && BL64_AWS_CMD_AWS="${aws_bin}/aws"
  fi

  bl64_dbg_lib_show_vars 'BL64_AWS_CMD_AWS'
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
function bl64_aws_set_options() {
  bl64_dbg_lib_show_function

  BL64_AWS_SET_FORMAT_JSON='--output json'
  BL64_AWS_SET_FORMAT_TEXT='--output text'
  BL64_AWS_SET_FORMAT_TABLE='--output table'
  BL64_AWS_SET_FORMAT_YAML='--output yaml'
  BL64_AWS_SET_FORMAT_STREAM='--output yaml-stream'
  BL64_AWS_SET_DEBUG='--debug'
  BL64_AWS_SET_OUPUT_NO_PAGER='--no-cli-pager'
  BL64_AWS_SET_OUPUT_NO_COLOR='--color off'
  BL64_AWS_SET_INPUT_NO_PROMPT='--no-cli-auto-prompt'

  return 0
}

#######################################
# Set and prepare module paths
#
# * Global paths only
# * If preparation fails the whole module fails
#
# Arguments:
#   $1: configuration file name
#   $2: credential file name
# Outputs:
#   STDOUT: None
#   STDERR: check errors
# Returns:
#   0: paths prepared ok
#   >0: failed to prepare paths
#######################################
# shellcheck disable=SC2120
function bl64_aws_set_paths() {
  bl64_dbg_lib_show_function "$@"
  local configuration="${1:-${BL64_SCRIPT_ID}}"
  local credentials="${2:-${BL64_SCRIPT_ID}}"
  local aws_home=''

  bl64_dbg_lib_show_info 'prepare AWS_HOME'
  bl64_check_home || return $?
  aws_home="${HOME}/${BL64_AWS_SUFFIX_HOME}"
  bl64_fs_create_dir "$BL64_AWS_CLI_MODE" "$BL64_LIB_DEFAULT" "$BL64_LIB_DEFAULT" "$aws_home" || return $?

  bl64_dbg_lib_show_info 'set configuration paths'
  BL64_AWS_CLI_HOME="$aws_home"
  BL64_AWS_CLI_CACHE="${BL64_AWS_CLI_HOME}/${BL64_AWS_SUFFIX_CACHE}"
  BL64_AWS_CLI_CONFIG="${BL64_AWS_CLI_HOME}/${configuration}.${BL64_AWS_SUFFIX_CONFIG}"
  BL64_AWS_CLI_CREDENTIALS="${BL64_AWS_CLI_HOME}/${credentials}.${BL64_AWS_SUFFIX_CREDENTIALS}"

  bl64_dbg_lib_show_vars 'BL64_AWS_CLI_HOME' 'BL64_AWS_CLI_CACHE' 'BL64_AWS_CLI_CONFIG' 'BL64_AWS_CLI_CREDENTIALS'
  return 0
}
