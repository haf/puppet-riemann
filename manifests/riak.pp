class riemann::riak(
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

  user { $user:
    ensure  => present,
    gid     => $group,
    home    => $home,
    system  => true,
    require => [
      Anchor['riemann::riak::start'],
      Group[$group]
    ],
    before  => Anchor['riemann::riak::end'],
  }

  file { $home:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => [
      Anchor['riemann::riak::start'],
      User[$user]
    ],
    before  => Anchor['riemann::riak::stop'],
  }

  riemann::utils::gem_service { 'riemann-riak':
    ensure       => 'installed',
    user         => $user,
    group        => $group,
    home         => $home,
    ruby_version => $riemann::common::ruby_version,
    require      => [
      Anchor['riemann::riak::start'],
      File[$home]
    ],
    before       => Anchor['riemann::riak::end'],
  }

  class { 'riemann::riak::config':
    require => [
      Anchor['riemann::riak::start'],
      Riemann::Utils::Gem_service['riemann-riak']
    ],
    before  => Anchor['riemann::riak::end'],
    notify  => Class['riemann::riak::service'],
  }

  class { 'riemann::riak::service':
    require => [
      Anchor['riemann::riak::start'],
      Class['riemann::riak::config']
    ],
    before  => Anchor['riemann::riak::end'],
  }

  anchor { 'riemann::riak::end': }
}