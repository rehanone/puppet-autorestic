class autorestic::wrapper () inherits autorestic {
  assert_private("Use of private class ${name} by ${caller_module_name}")

  $file_ensure = $autorestic::autorestic_ensure ? {
    'present' => file,
    default   => $autorestic::autorestic_ensure,
  }

  $link_ensure = $autorestic::autorestic_ensure ? {
    'present' => link,
    default   => $autorestic::autorestic_ensure,
  }

  file { "${autorestic::autorestic_install_directory}/arctl":
    ensure  => $file_ensure,
    path    => "${autorestic::autorestic_install_directory}/arctl",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => epp("${module_name}/arctl.epp",
      {
        'account_name'      => $autorestic::wrapper_user,
        'account_home'      => $autorestic::account_home,
        'install_directory' => '/usr/local/bin',
      }
    ),
  } -> file { '/usr/local/bin/arctl':
    ensure => $link_ensure,
    target => "${autorestic::autorestic_install_directory}/arctl",
  }
}
