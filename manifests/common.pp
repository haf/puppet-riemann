class riemann::common(
  $group = $riemann::params::group
) inherits riemann::params {
  anchor { 'riemann::common::start': }

  group { $group:
    ensure  => present,
    system  => true,
    require => Anchor['riemann::common::start'],
    before  => Anchor['riemann::common::end'],
  }

  ensure_packages($riemann::params::tools_packages)

  package { 'riemann-tools':
    ensure   => 'installed',
    provider => gem,
    require  => [
      Package[$riemann::params::tools_packages],
      Anchor['riemann::common::start']
    ],
    before   => Anchor['riemann::common::end'],
  }
  
  anchor { 'riemann::common::end': }
}