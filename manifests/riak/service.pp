class riemann::riak::service(
  $ensure = 'present'
) {
  supervisor::service { 'riemann-riak':
    ensure      => $ensure,
    command     => "riemann-riak",
    group       => $riemann::riak::group,
    user        => $riemann::riak::user,
  }
}