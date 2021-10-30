class autorestic::install () inherits autorestic {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  $file_ensure = $autorestic::autorestic_ensure ? {
    'present' => file,
    default   => $autorestic::autorestic_ensure,
  }

  $link_ensure = $autorestic::autorestic_ensure ? {
    'present' => link,
    default   => $autorestic::autorestic_ensure,
  }

  if $autorestic::account_manage {
    create_resources(autorestic::resource::binary_install,
      {
        'home-restic' => {
          ensure                   => $autorestic::account_ensure,
          download_url             => $autorestic::restic_download_url,
          filename                 => $autorestic::restic_download_filename,
          checksum                 => $autorestic::restic_checksum,
          checksum_type            => $autorestic::restic_checksum_type,
          install_directory        => "${autorestic::account_home}/bin",
          create_install_directory => false,
          mode                     => '0750',
          owner                    => $autorestic::account_name,
          group                    => $autorestic::account_name,
          soft_link                => "${autorestic::account_home}/bin/restic",
        },
      }
    )

    include file_capability
    file_capability { "${autorestic::account_home}/bin/${autorestic::restic_download_filename}":
      ensure     => present,
      capability => 'cap_dac_read_search+ep',
      require    => Autorestic::Resource::Binary_install['home-restic'],
      subscribe  => Autorestic::Resource::Binary_install['home-restic'],
    }
  }

  create_resources(autorestic::resource::binary_install,
    {
      'system-restic'     => {
        ensure                   => $autorestic::restic_global_install_ensure,
        download_url             => $autorestic::restic_download_url,
        filename                 => $autorestic::restic_download_filename,
        checksum                 => $autorestic::restic_checksum,
        checksum_type            => $autorestic::restic_checksum_type,
        install_directory        => $autorestic::restic_global_install_directory,
        create_install_directory => true,
        mode                     => '0755',
        owner                    => 'root',
        group                    => 'root',
        soft_link                => '/usr/local/bin/restic',
      },
      'system-autorestic' => {
        ensure                   => $autorestic::autorestic_ensure,
        download_url             => $autorestic::autorestic_download_url,
        filename                 => $autorestic::autorestic_download_filename,
        checksum                 => $autorestic::autorestic_checksum,
        checksum_type            => $autorestic::autorestic_checksum_type,
        install_directory        => $autorestic::autorestic_install_directory,
        create_install_directory => true,
        mode                     => '0755',
        owner                    => 'root',
        group                    => 'root',
        soft_link                => '/usr/local/bin/autorestic',
      },
    }
  )

  file { "${autorestic::autorestic_install_directory}/arctl":
    ensure  => $file_ensure,
    path    => "${autorestic::autorestic_install_directory}/arctl",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => epp("${module_name}/arctl.epp",
      {
        'account_name'      => $autorestic::account_name,
        'account_home'      => $autorestic::account_home,
        'install_directory' => '/usr/local/bin',
      }
    ),
  } -> file { '/usr/local/bin/arctl':
    ensure => $link_ensure,
    target => "${autorestic::autorestic_install_directory}/arctl",
  }
}
