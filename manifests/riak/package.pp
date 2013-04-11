class riemann::riak::package(
  $ensure = 'installed'
) inherits riemann::params {
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