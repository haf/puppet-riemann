class riemann::riak::service(
  $ensure = 'running'
) {
  supervisor::service { 'riemann-riak':
    ensure      => $ensure,
    command     => "riemann-riak",
    group       => $riemann::riak::group,
    user        => $riemann::riak::user,
  }
}