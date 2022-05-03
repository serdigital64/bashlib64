setup() {
  . "$DEVBL_TEST_SETUP"
}

@test "bl64_os_awk: hello" {
  expected='hello world'

  run bl64_os_awk -v test="$expected" 'END{ print test }' < /dev/null
  assert_success
  assert_output "$expected"

}