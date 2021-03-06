setup() {
  . "$TESTMANSH_TEST_BATSCORE_SETUP"
}

@test "bl64_fs_find_files: find one file - found" {

  run bl64_fs_find_files "$TESTMANSH_TEST_SAMPLES" 'text_with_comments_01.txt'
  assert_success
  assert_output "${TESTMANSH_TEST_SAMPLES}/text_with_comments_01.txt"

}

# @test "bl64_fs_find_files: find one file - not found" {

#   run bl64_fs_find_files "$TESTMANSH_TEST_SAMPLES" 'fake_file'
#   assert_success
#   assert_output ''

# }
