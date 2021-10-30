define autorestic::resource::binary_install (
  Enum[present, absent] $ensure,
  Stdlib::HTTPSUrl      $download_url,
  String[1]             $filename,
  String[1]             $checksum,
  Enum[none, md5, sha1, sha2, sha256, sha384, sha512]
  $checksum_type,
  Stdlib::Absolutepath  $install_directory,
  Boolean               $create_install_directory,
  Stdlib::Filemode      $mode,
  String[1]             $owner,
  String[1]             $group,
  Stdlib::Absolutepath  $soft_link,
) {

  $file_ensure = $ensure ? {
    'present' => file,
    default   => $ensure,
  }

  $link_ensure = $ensure ? {
    'present' => link,
    default   => $ensure,
  }

  $directory_ensure = $ensure ? {
    'present' => directory,
    default   => $ensure,
  }

  if $create_install_directory {
    file { $install_directory:
      ensure => $directory_ensure,
    }
  }

  archive { "/tmp/${title}-${filename}":
    ensure          => $ensure,
    extract         => true,
    extract_path    => $install_directory,
    extract_command => "bunzip2 -c %s > ${install_directory}/${filename}",
    source          => $download_url,
    checksum        => $checksum,
    checksum_type   => $checksum_type,
    cleanup         => true,
    creates         => "${install_directory}/${filename}",
    require         => Package['bzip2'],
  }
  -> file { "${install_directory}/${filename}":
    ensure => $file_ensure,
    mode   => $mode,
    owner  => $owner,
    group  => $group,
  }
  -> file { $soft_link:
    ensure => $link_ensure,
    target => "${install_directory}/${filename}",
  }
}
