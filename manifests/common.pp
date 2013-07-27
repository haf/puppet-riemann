class riemann::common(
  $group = $riemann::params::group,
  $ruby_version
) inherits riemann::params {
  anchor { 'riemann::common::start': }

  group { $group:
    ensure  => present,
    system  => true,
    require => Anchor['riemann::common::start'],
    before  => Anchor['riemann::common::end'],
  }

  ensure_packages($riemann::params::tools_packages)

  rvm_gem { 'riemann-tools':
    ensure       => 'installed',
    name         => 'riemann-tools',
    ruby_version => $ruby_version,
    require  => [
      Rvm_system_ruby["ruby-$ruby_version"],
      Package[$riemann::params::tools_packages],
      Anchor['riemann::common::start']
    ],
    before   => Anchor['riemann::common::end'],
  }

  anchor { 'riemann::common::end': }
}