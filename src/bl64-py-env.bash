#######################################
# BashLib64 / Module / Globals / Interact with system-wide Python
#
# Version: 1.2.0
#######################################

# Define placeholders for optional distro native python versions
export BL64_PY_CMD_PYTHON3="$BL64_LIB_UNAVAILABLE"
export BL64_PY_CMD_PYTHON35="$BL64_LIB_UNAVAILABLE"
export BL64_PY_CMD_PYTHON36="$BL64_LIB_UNAVAILABLE"
export BL64_PY_CMD_PYTHON37="$BL64_LIB_UNAVAILABLE"
export BL64_PY_CMD_PYTHON38="$BL64_LIB_UNAVAILABLE"
export BL64_PY_CMD_PYTHON39="$BL64_LIB_UNAVAILABLE"
export BL64_PY_CMD_PYTHON310="$BL64_LIB_UNAVAILABLE"

export BL64_PY_SET_PIP_VERBOSE=''
export BL64_PY_SET_PIP_VERSION=''
export BL64_PY_SET_PIP_UPGRADE=''
export BL64_PY_SET_PIP_USER=''

readonly _BL64_PY_TXT_PIP_PREPARE_PIP='upgrade pip module'
readonly _BL64_PY_TXT_PIP_PREPARE_SETUP='install and upgrade setuptools modules'
readonly _BL64_PY_TXT_PIP_INSTALL='install modules'