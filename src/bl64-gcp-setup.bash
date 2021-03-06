#######################################
# BashLib64 / Module / Setup / Interact with GCP
#
# Version: 1.2.1
#######################################

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
function bl64_gcp_setup() {
  bl64_dbg_lib_show_function "$@"
  local gcloud_bin="${1:-${BL64_LIB_DEFAULT}}"

  if [[ "$gcloud_bin" != "$BL64_LIB_DEFAULT" ]]; then
    bl64_check_directory "$gcloud_bin" ||
      return $?
  fi

  bl64_gcp_set_command "$gcloud_bin" &&
    bl64_gcp_set_options &&
    bl64_check_command "$BL64_GCP_CMD_GCLOUD" &&
    BL64_GCP_MODULE="$BL64_LIB_VAR_ON"

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
function bl64_gcp_set_command() {
  bl64_dbg_lib_show_function "$@"
  local gcloud_bin="${1:-${BL64_LIB_DEFAULT}}"

  if [[ "$gcloud_bin" == "$BL64_LIB_DEFAULT" ]]; then
    if [[ -x '/home/linuxbrew/.linuxbrew/bin/gcloud' ]]; then
      gcloud_bin='/home/linuxbrew/.linuxbrew/bin'
    elif [[ -x '/opt/homebrew/bin/gcloud' ]]; then
      gcloud_bin='/opt/homebrew/bin'
    elif [[ -x '/usr/local/bin/gcloud' ]]; then
      gcloud_bin='/usr/local/bin'
    elif [[ -x '/usr/bin/gcloud' ]]; then
      gcloud_bin='/usr/bin'
    fi
  else
    [[ ! -x "${gcloud_bin}/gcloud" ]] && gcloud_bin="$BL64_LIB_DEFAULT"
  fi

  if [[ "$gcloud_bin" != "$BL64_LIB_DEFAULT" ]]; then
    [[ -x "${gcloud_bin}/gcloud" ]] && BL64_GCP_CMD_GCLOUD="${gcloud_bin}/gcloud"
  fi

  bl64_dbg_lib_show_vars 'BL64_GCP_CMD_GCLOUD'
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
function bl64_gcp_set_options() {
  bl64_dbg_lib_show_function

  BL64_GCP_SET_FORMAT_YAML='--format yaml'
  BL64_GCP_SET_FORMAT_TEXT='--format text'
  BL64_GCP_SET_FORMAT_JSON='--format json'
}
