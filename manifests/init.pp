# Setup autorestic scripts
class autorestic (
  Boolean               $account_manage,
  Enum[absent, present] $account_ensure,
  String[1]             $account_name,
  String[1]             $account_gid,
  String[1]             $account_uid,
  Stdlib::Absolutepath  $account_home,
  Array[String[1]]      $account_groups,

  Boolean               $dependencies_manage,
  Array[String[1]]      $dependencies_packages,
  String[1]             $restic_version,
  String[1]             $restic_download_filename,
  Stdlib::HTTPSUrl      $restic_download_url,
  String[1]             $restic_checksum,
  Enum[none, md5, sha1, sha2, sha256, sha384, sha512]
  $restic_checksum_type,
  Stdlib::Absolutepath  $restic_global_install_directory,
  Enum[absent, present] $restic_global_install_ensure,

  Enum[absent, present] $autorestic_ensure,
  String[1]             $autorestic_version,
  String[1]             $autorestic_download_filename,
  Stdlib::HTTPSUrl      $autorestic_download_url,
  String[1]             $autorestic_checksum,
  Enum[none, md5, sha1, sha2, sha256, sha384, sha512]
  $autorestic_checksum_type,
  Stdlib::Absolutepath  $autorestic_install_directory,
  String[1]             $wrapper_user,
  Optional[String[1]]   $autorestic_config_source = undef,
) {
  anchor { "${module_name}::begin": }
  -> class { "${module_name}::account": }
  -> class { "${module_name}::dependencies": }
  -> class { "${module_name}::config": }
  -> class { "${module_name}::install": }
  -> class { "${module_name}::wrapper": }
  -> anchor { "${module_name}::end": }
}
