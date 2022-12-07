class autorestic::config () inherits autorestic {
  assert_private("Use of private class ${name} by ${caller_module_name}")

  $file_ensure = $autorestic::autorestic_ensure ? {
    'present' => file,
    default   => $autorestic::account_ensure,
  }

  if $autorestic::autorestic_config_source != undef {
    file { "${autorestic::account_home}/autorestic.yml":
      ensure  => $file_ensure,
      mode    => '0644',
      owner   => $autorestic::account_uid,
      group   => $autorestic::account_gid,
      source  => $autorestic::autorestic_config_source,
      require => User[$autorestic::account_name],
    }
  }
  file { "${autorestic::account_home}/.autorestic.env":
    ensure  => $file_ensure,
    mode    => '0600',
    owner   => $autorestic::account_uid,
    group   => $autorestic::account_gid,
    require => User[$autorestic::account_name],
  }
}
