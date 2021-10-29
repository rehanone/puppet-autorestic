class autorestic::install () inherits autorestic {

  assert_private("Use of private class ${name} by ${caller_module_name}")

  $file_ensure = $autorestic::autorestic_ensure ? {
    'present' => file,
    default   => $autorestic::autorestic_ensure,
  }

  $restic_binary = "${autorestic::account_home}/bin/restic"

  if $autorestic::account_manage {
    create_resources(autorestic::resource::binary_install,
      {
        $autorestic::account_name => {
          ensure            => $autorestic::account_ensure,
          download_url      => $autorestic::restic_binary_url,
          checksum          => $autorestic::restic_checksum,
          checksum_type     => $autorestic::restic_checksum_type,
          install_directory => "${autorestic::account_home}/bin",
          file_name         => 'restic',
          mode              => '0750',
          owner             => $autorestic::account_name,
          group             => $autorestic::account_name,
        },
      }
    )

    include file_capability
    file_capability { $restic_binary:
      ensure     => present,
      capability => 'cap_dac_read_search+ep',
      require    => Autorestic::Resource::Binary_install[$autorestic::account_name],
    }
  }

  create_resources(autorestic::resource::binary_install,
    {
      'system-restic'     => {
        ensure            => $autorestic::restic_global_install_ensure,
        download_url      => $autorestic::restic_binary_url,
        checksum          => $autorestic::restic_checksum,
        checksum_type     => $autorestic::restic_checksum_type,
        install_directory => $autorestic::restic_global_install_directory,
        file_name         => 'restic',
        mode              => '0755',
        owner             => 'root',
        group             => 'root',
      },
      'system-autorestic' => {
        ensure            => $autorestic::autorestic_ensure,
        download_url      => $autorestic::autorestic_binary_url,
        checksum          => $autorestic::autorestic_checksum,
        checksum_type     => $autorestic::autorestic_checksum_type,
        install_directory => $autorestic::autorestic_install_directory,
        file_name         => 'autorestic',
        mode              => '0755',
        owner             => 'root',
        group             => 'root',
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
        'install_directory' => $autorestic::autorestic_install_directory,
        'restic_binaray'    => $restic_binary,
      }
    ),
  }
}
