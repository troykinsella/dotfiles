
check_sum() {
  local package_path=$1
  local package_sum=$2

  echo "$package_sum $package_path" | sha256sum -c || return 1

  return 0
}

needs_fetch() {
  local package_path=$1
  local package_sum=$2

  test -f $package_path || return 0
  check_sum $package_path $package_sum || return 0

  return 1
}
