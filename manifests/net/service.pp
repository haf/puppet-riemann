# Gathers munin statistics and submits them to Riemann.
class riemann::net::service(
  $ensure = 'present'
) {
  supervisor::service { 'riemann-net':
    ensure      => $ensure,
    command     => "riemann-net",
    group       => $riemann::net::group,
    user        => $riemann::net::user,
  }
}