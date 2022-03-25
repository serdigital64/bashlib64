setup() {
  . "$DEVBL_TEST_BASHLIB64"
  . "${DEVBL_BATS_HELPER}/bats-support/load.bash"
  . "${DEVBL_BATS_HELPER}/bats-assert/load.bash"
  . "${DEVBL_BATS_HELPER}/bats-file/load.bash"
}

function _test_bl64_dbg_function_start() {
  bl64_dbg_function_start '_test_bl64_dbg_function_start'
}

@test "bl64_dbg_function_start: start dbg" {

  set +u # to avoid IFS missing error in run function
  run _test_bl64_dbg_function_start

  assert_success

}
