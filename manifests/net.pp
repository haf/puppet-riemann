class riemann::net(
  $ensure               = 'present',
  $config_file          = '',
  $config_file_template = '',
  $user                 = 'riemann-net'
) {
  include riemann::common

  $home                 = "/home/$user"

  $is_on_server = defined(Class['riemann'])

  $group = $is_on_server ? {
    true     => $riemann::group,
    default  => $riemann::common::group,
  }

  anchor { 'riemann::net::start': }

  file { $home:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => Anchor['riemann::net::start'],
    before  => Anchor['riemann::net::stop'],
  }

  user { $user:
    ensure  => $ensure,
    gid     => $group,
    home    => $home,
    system  => true,
    require => [
      Anchor['riemann::net::start'],
      File[$home],
      Group[$group]
    ],
    before  => Anchor['riemann::net::end'],
  } ->
  class { 'riemann::net::package':
    require => Anchor['riemann::net::start'],
    before  => Anchor['riemann::net::end'],
  } ->
  class { 'riemann::net::config':
    require => Anchor['riemann::net::start'],
    before  => Anchor['riemann::net::end'],
  } ~>
  class { 'riemann::net::service':
    require => Anchor['riemann::net::start'],
    before  => Anchor['riemann::net::end'],
  }

  anchor { 'riemann::net::end': }
}