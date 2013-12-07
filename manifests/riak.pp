class riemann::riak(
  $enable               = true,
  $config_file          = '',
  $config_file_template = '',
  $user                 = 'riemann-riak'
) {
  include riemann::common

  $home                 = "/home/$user"

  $is_on_server = defined(Class['riemann'])

  $group = $is_on_server ? {
    true     => $riemann::group,
    default  => $riemann::common::group,
  }

  anchor { 'riemann::riak::start': }

  file { $home:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => Anchor['riemann::riak::start'],
    before  => Anchor['riemann::riak::stop'],
  }

  user { $user:
    ensure  => present,
    gid     => $group,
    home    => $home,
    system  => true,
    require => Anchor['riemann::riak::start'],
    before  => Anchor['riemann::riak::end'],
  }

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