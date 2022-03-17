setup() {
  . "$DEVBL_TEST_BASHLIB64"
  . "${DEVBL_BATS_HELPER}/bats-support/load.bash"
  . "${DEVBL_BATS_HELPER}/bats-assert/load.bash"
  . "${DEVBL_BATS_HELPER}/bats-file/load.bash"
  set +u # to avoid IFS missing error in run function
}

@test "bl64_log_setup: type format" {

  run bl64_log_setup '/dev/null' '1' 'INVALID_TYPE'
  assert_equal "$status" $BL64_LOG_ERROR_INVALID_TYPE

}

@test "bl64_log_setup: set type" {

  bl64_log_setup '/dev/null' '1' "$BL64_LOG_TYPE_FILE"

  assert_equal $? 0 && \
  assert_equal "$BL64_LOG_TYPE" "$BL64_LOG_TYPE_FILE"

}