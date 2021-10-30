class autorestic::dependencies () inherits autorestic {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  if $autorestic::dependencies_manage {
    ensure_packages([$autorestic::dependencies_packages], { 'ensure' => present })
  }
}
