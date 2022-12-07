node default {
  notify { 'enduser-before': }
  notify { 'enduser-after': }

  group { 'docker':
    ensure => present,
    system => true,
  }

  class { 'autorestic':
    account_ensure               => present,
    account_groups               => ['docker'],
    autorestic_ensure            => present,
    restic_global_install_ensure => present,
    require                      => [Notify['enduser-before'], Group['docker']],
    before                       => Notify['enduser-after'],
  }
}
