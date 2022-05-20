setup() {
  [[ -f '/run/.containerenv' ]] && skip 'not applicable to container mode'

  . "$TESTMANSH_TEST_BATSCORE_SETUP"
  bl64_cnt_setup
}

@test "bl64_cnt_run_podman: CLI runs ok" {
  [[ ! -x "$BL64_CNT_CMD_PODMAN" ]] && skip

  run bl64_cnt_run_podman --version
  assert_success
}
