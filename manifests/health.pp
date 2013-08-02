class riemann::health(
  $enable               = true,
  $config_file          = '',
  $config_file_template = '',
  $log_dir              = $riemann::params::log_dir,
  $ruby_version         = $riemann::params::ruby_version
) inherits riemann::params {
  include svcutils

  $user = $riemann::params::health_user

  $is_on_server = defined(Class['riemann'])

  $group = $is_on_server ? {
    true     => $riemann::group,
    default  => $riemann::params::group,
  }

  anchor { 'riemann::health::start': }
  svcutils::svcuser { $user:
    group   => $group,
    require => [
      Anchor['riemann::health::start'],
      Class['riemann::common']
    ],
    before  => Anchor['riemann::health::end'],
  } ->
  class { 'riemann::health::package':
    require => Anchor['riemann::health::start'],
    before  => Anchor['riemann::health::end'],
  } ->
  class { 'riemann::health::config':
    require => Anchor['riemann::health::start'],
    before  => Anchor['riemann::health::end'],
  } ~>
  class { 'riemann::health::service':
    require => Anchor['riemann::health::start'],
    before  => Anchor['riemann::health::end'],
  }

  anchor { 'riemann::health::end': }
}