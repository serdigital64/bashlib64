setup() {
  . "$TESTMANSH_TEST_BATSCORE_SETUP"
}

@test "bl64_rbac_set_command: run function" {
  run bl64_rbac_set_command
  assert_success
}
