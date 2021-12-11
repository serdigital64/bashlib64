#!/bin/bash
#######################################
# Create the BashLib64 stand-alone distributable file
#
# Author: serdigital64 (https://github.com/serdigital64)
# License: GPL-3.0-or-later (https://www.gnu.org/licenses/gpl-3.0.txt)
# Repository: https://github.com/serdigital64/bashlib64
# Version: 1.0.0
#######################################

source './.env' || exit 1
source "${DEVBL64_BIN}/bashlib64.bash" || exit 1

function devbl64_run_tests_bats() {

  local case="$1"
  local target=''
  local test_list=''

  if [[ -n "$case" ]]; then
    test_list="$DEVBL64_TEST/batscore/${case}.bats"
  else
    test_list="$(echo $DEVBL64_TEST/batscore/*)"
  fi

  for target in $test_list; do
    bl64_msg_show_task "testing: $case"
    "$DEVBL64_CMD_BATS" --verbose-run "$target"
  done

  :

}

function devbl64_run_tests_check() {

  bl64_check_command "$DEVBL64_CMD_BATS" || return 1
  bl64_check_file "${DEVBL64_BUILD}/bashlib64.bash" || return 1
  :

}

function devbl64_run_tests_help() {
  bl64_msg_show_usage \
    '-b [-t Case] [-h]' \
    'Run Tests' \
    '
    -b      : Run bats-core based tests
    ' '' '
    -t case : Test case name. If not specified all cases are run.
    '
}

#
# Main
#

declare devbl64_run_tests_status=1
declare devbl64_run_tests_command=''
declare devbl64_run_tests_option=''
declare devbl64_run_tests_case=''

(($# == 0)) && devbl64_run_tests_help && exit 1
while getopts ':bc:h' devbl64_run_tests_option; do
  case "$devbl64_run_tests_option" in
  b)
    devbl64_run_tests_command='devbl64_run_tests_bats'
    devbl64_run_tests_command_tag='run bats-core tests'
    ;;
  c)
    devbl64_run_tests_case="$OPTARG"
    ;;
  h)
    devbl64_run_tests_help && exit
    ;;
  \?)
    devbl64_run_tests_help && exit 1
    ;;
  esac
done
[[ -z "$devbl64_run_tests_command" ]] && devbl64_run_tests_help && exit 1
devbl64_run_tests_check || exit 1

bl64_msg_show_info "starting ${devbl64_run_tests_command_tag} process"
case "$devbl64_run_tests_command" in
'devbl64_run_tests_bats') "$devbl64_run_tests_command" "$devbl64_run_tests_case";;
esac
devbl64_run_tests_status=$?

if ((devbl64_run_tests_status == 0)); then
  bl64_msg_show_info "${devbl64_run_tests_command_tag} process complete"
else
  bl64_msg_show_info "${devbl64_run_tests_command_tag} process complete with errors (error: $devbl64_run_tests_status)"
fi

exit $devbl64_run_tests_status
