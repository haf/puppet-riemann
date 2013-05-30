class riemann::riak::service(
  $ensure = 'running',
  $enable = true
) {
  $log_dir = $riemann::riak::log_dir
  $group   = $riemann::riak::group

  svcutils::mixsvc { 'riemann-riak':
    log_dir     => $log_dir,
    ensure      => $ensure,
    enable      => $ensure,
    exec        => '/usr/bin/riemann-riak',
    description => 'Riemann Riak - Riak monitoring',
    group       => $group,
  }
}