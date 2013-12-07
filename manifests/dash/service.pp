# Installs the riemann-dash service.
class riemann::dash::service(
  $ensure = 'running',
) {
  supervisor::service { 'riemann-dash':
    ensure      => $ensure,
    command     => "riemann-dash $riemann::dash::config_file",
    directory   => $riemann::dash::home,
    user        => $riemann::dash::user,
    group       => $riemann::dash::group,
  }
}