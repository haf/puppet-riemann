class riemann::common(
  $group = $riemann::params::group
) inherits riemann::params {
  group { $group:
    ensure  => present,
    system  => true,
  }

  ensure_packages($riemann::params::tools_packages)

  package { 'riemann-tools':
    ensure   => 'installed',
    provider => gem,
    require  => [
      Package[$riemann::params::tools_packages]
    ],
  }
}