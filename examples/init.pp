node default {

  notify { 'enduser-before': }
  notify { 'enduser-after': }

  class { 'autorestic':
    account_ensure    => present,
    autorestic_ensure => present,
    require           => Notify['enduser-before'],
    before            => Notify['enduser-after'],
  }
}
