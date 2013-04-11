class riemann::health::package(
  $ensure = 'installed'
) inherits riemann::params {
  ensure_packages($riemann::params::tools_packages)

  if ! defined(Package['riemann-tools']) {
    package { 'riemann-tools':
      ensure   => 'installed',
      provider => gem,
      require  => [
        Package[$riemann::params::tools_packages]
      ],
    }
  }
}