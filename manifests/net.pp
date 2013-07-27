class riemann::net(
  $enable               = true,
  $config_file          = '',
  $config_file_template = '',
  $log_dir              = $riemann::params::log_dir,
  $ruby_version
) inherits riemann::params {
  include svcutils

  $user = $riemann::params::net_user

  $is_on_server = defined(Class['riemann'])

  $group = $is_on_server ? {
    true     => $riemann::group,
    default  => $riemann::params::group,
  }

  anchor { 'riemann::net::start': }
  svcutils::svcuser { $user:
    group => $group,
    require => [
      Anchor['riemann::net::start'],
      Class['riemann::common']
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