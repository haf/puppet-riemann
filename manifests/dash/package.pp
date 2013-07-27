# Installs the dashboard ruby gem.
class riemann::dash::package(
  $ensure = 'installed'
) inherits riemann::params {
  rvm_gem { 'riemann-dash':
    name         => 'riemann-dash',
    ensure       => $ensure,
    ruby_version => 'ruby-1.9.3-p448',
    require      => Rvm_system_ruby['ruby-1.9.3-p448'],
  }
}