# Installs the riemann-dash service.
class riemann::dash::service(
  $ensure = 'present',
) {
  supervisor::service { 'riemann-dash':
    ensure      => $ensure,
    command     => "/home/${riemann::dash::user}/.rbenv/shims/riemann-dash $riemann::dash::config_file",
    directory   => $riemann::dash::home,
    user        => $riemann::dash::user,
    group       => $riemann::dash::group,
  }
}