class autorestic::account () inherits autorestic {
  assert_private("Use of private class ${name} by ${caller_module_name}")

  $directory_ensure = $autorestic::account_ensure ? {
    'present' => directory,
    default   => $autorestic::account_ensure,
  }

  if $autorestic::account_manage {
    if $autorestic::account_ensure == present {
      group { $autorestic::account_name:
        ensure => $autorestic::account_ensure,
        gid    => $autorestic::account_gid,
        system => true,
      }
      -> user { $autorestic::account_name:
        ensure     => $autorestic::account_ensure,
        uid        => $autorestic::account_uid,
        gid        => $autorestic::account_gid,
        home       => $autorestic::account_home,
        groups     => $autorestic::account_groups,
        membership => 'inclusive',
        managehome => true,
        shell      => '/bin/false',
        system     => true,
      }
    } else {
      user { $autorestic::account_name:
        ensure     => $autorestic::account_ensure,
        uid        => $autorestic::account_uid,
        gid        => $autorestic::account_gid,
        home       => $autorestic::account_home,
        groups     => $autorestic::account_groups,
        membership => 'inclusive',
        managehome => true,
        shell      => '/bin/false',
        system     => true,
      }
      -> group { $autorestic::account_name:
        ensure => $autorestic::account_ensure,
        gid    => $autorestic::account_gid,
        system => true,
      }
    }

    file { "${autorestic::account_home}/bin":
      ensure  => $directory_ensure,
      mode    => '0750',
      owner   => $autorestic::account_uid,
      group   => $autorestic::account_gid,
      require => User[$autorestic::account_name],
    }
  }
}
