setup() {
  . "$TESTMANSH_TEST_BATSCORE_SETUP"
}

@test "bl64_txt_search_line: line is present" {

  line='second line'
  run bl64_txt_search_line "$TESTMANSH_TEST_SAMPLES/text_lines_01.txt" "$line"
  assert_success

}

@test "bl64_txt_search_line: line is not present" {

  line='not present'
  run bl64_txt_search_line "$TESTMANSH_TEST_SAMPLES/text_lines_01.txt" "$line"
  assert_failure

}
