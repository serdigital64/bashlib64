setup() {
  . "$DEVBL_TEST_SETUP"
  bl64_gcp_setup
}

@test "bl64_gcp_set_command: commands are set" {

  assert_not_equal "$BL64_GCP_CMD_GCLOUD" ''

}
