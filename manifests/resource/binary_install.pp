define autorestic::resource::binary_install (
  Enum[present, absent] $ensure,
  Stdlib::HTTPSUrl      $download_url,
  String[1]             $checksum,
  Enum[none, md5, sha1, sha2, sha256, sha384, sha512]
  $checksum_type,
  Stdlib::Absolutepath  $install_directory,
  String[1]             $file_name,
  Stdlib::Filemode      $mode,
  String[1]             $owner,
  String[1]             $group,
) {
  $file_ensure = $ensure ? {
    'present' => file,
    default   => $ensure,
  }

  archive { "/tmp/${title}-${file_name}.bz2":
    ensure          => $ensure,
    extract         => true,
    extract_path    => $install_directory,
    extract_command => "bunzip2 -c %s > ${install_directory}/${file_name}",
    source          => $download_url,
    checksum        => $checksum,
    checksum_type   => $checksum_type,
    cleanup         => true,
    creates         => "${install_directory}/${file_name}",
    require         => Package['bzip2'],
  }
  -> file { "${install_directory}/${file_name}":
    ensure => $file_ensure,
    mode   => $mode,
    owner  => $owner,
    group  => $group,
  }
}
