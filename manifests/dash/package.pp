# Installs the dashboard ruby gem.
class riemann::dash::package(
  $ensure = 'installed'
) {
  riemann::utils::gem { 'riemann-dash':
    ensure       => $ensure,
    user         => $riemann::dash::user,
    group        => $riemann::dash::group,
    home         => $riemann::dash::home,
    ruby_version => $riemann::common::ruby_version,
  }
}