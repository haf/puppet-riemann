class riemann::riak(
  $enable  = true,
  $config_file = '',
  $config_file_template = '',
  $log_dir = $riemann::params::log_dir
) inherits riemann::params {
  include svcutils

  $user = $riemann::params::riak_user
  $group = defined(Class['riemann']) ? {
    true     => $riemann::group,
    default  => $riemann::params::group,
  }

  anchor { 'riemann::riak::start': }

  svcutils::svcuser { $user:
    group => $group,
    require => Anchor['riemann::riak::start'],
    before  => Anchor['riemann::riak::end'],
  } ->
  class { 'riemann::riak::package':
    require => Anchor['riemann::riak::start'],
    before  => Anchor['riemann::riak::end'],
  } ->
  class { 'riemann::riak::config':
    require => Anchor['riemann::riak::start'],
    before  => Anchor['riemann::riak::end'],
  } ~>
  class { 'riemann::riak::service':
    require => Anchor['riemann::riak::start'],
    before  => Anchor['riemann::riak::end'],
  }

  anchor { 'riemann::riak::end': }
}