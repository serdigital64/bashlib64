setup() {
  . "$TESTMANSH_TEST_BATSCORE_SETUP"
}

@test "bl64_os_match: os = ALM + list" {

  export BL64_OS_DISTRO="${BL64_OS_ALM}-8.5"
  run bl64_os_match 'ALM' 'RHEL'
  assert_success

}

@test "bl64_os_match: os = ALM-8 + list" {

  export BL64_OS_DISTRO="${BL64_OS_ALM}-8.5"
  run bl64_os_match 'ALM-8' 'RHEL-8'
  assert_success

}

@test "bl64_os_match: os = DEB-10 + list" {

  export BL64_OS_DISTRO="${BL64_OS_DEB}-10.0"
  run bl64_os_match 'DEB-10' 'UB-20'
  assert_success

}

@test "bl64_os_match: os = ALM-8.5 + list" {

  export BL64_OS_DISTRO="${BL64_OS_ALM}-8.5"
  run bl64_os_match 'ALM-8.5' 'RHEL-8.5'
  assert_success

}

@test "bl64_os_match: fail os = ALM-9 + list" {

  export BL64_OS_DISTRO="${BL64_OS_ALM}-8.5"
  run bl64_os_match 'ALM-9' 'RHEL-10'
  assert_failure
  assert_equal $status $BL64_LIB_ERROR_OS_NOT_MATCH

}

@test "bl64_os_match: fail os = ALM-9.5 + list" {

  export BL64_OS_DISTRO="${BL64_OS_ALM}-8.5"
  run bl64_os_match 'ALM-9.5' 'RHEL-10.1'
  assert_failure
  assert_equal $status $BL64_LIB_ERROR_OS_NOT_MATCH

}

@test "bl64_os_match: invalid os = XXX + list" {

  export BL64_OS_DISTRO="${BL64_OS_ALM}-8.5"
  run bl64_os_match 'CNT-8.5' 'RHEL-10.1' 'XXX'
  assert_failure
  assert_equal $status $BL64_LIB_ERROR_OS_TAG_INVALID

}
