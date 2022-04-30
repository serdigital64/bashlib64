setup() {
  . "$DEVBL_TEST_SETUP"

}

@test "bl64_fs_set_command: commands are set" {

  assert_not_equal "${BL64_FS_CMD_CHMOD}" ''
  assert_not_equal "${BL64_FS_CMD_CHOWN}" ''
  assert_not_equal "${BL64_FS_CMD_CP}" ''
  assert_not_equal "${BL64_FS_CMD_LN}" ''
  assert_not_equal "${BL64_FS_CMD_LS}" ''
  assert_not_equal "${BL64_FS_CMD_MKDIR}" ''
  assert_not_equal "${BL64_FS_CMD_MKTEMP}" ''
  assert_not_equal "${BL64_FS_CMD_MV}" ''
  assert_not_equal "${BL64_FS_CMD_RM}" ''

}

@test "bl64_fs_set_command: commands are present" {

  assert_file_executable "${BL64_FS_CMD_CHMOD}"
  assert_file_executable "${BL64_FS_CMD_CHOWN}"
  assert_file_executable "${BL64_FS_CMD_CP}"
  assert_file_executable "${BL64_FS_CMD_LN}"
  assert_file_executable "${BL64_FS_CMD_LS}"
  assert_file_executable "${BL64_FS_CMD_MKDIR}"
  assert_file_executable "${BL64_FS_CMD_MKTEMP}"
  assert_file_executable "${BL64_FS_CMD_MV}"
  assert_file_executable "${BL64_FS_CMD_RM}"

}
