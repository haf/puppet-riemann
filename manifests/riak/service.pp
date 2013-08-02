class riemann::riak::service(
  $ensure = 'running',
  $enable = true
) {
  $log_dir      = $riemann::riak::log_dir
  $group        = $riemann::riak::group
  $ruby_version = $riemann::riak::ruby_version
  $user         = $riemann::riak::user

  svcutils::mixsvc { 'riemann-riak':
    log_dir     => $log_dir,
    ensure      => $ensure,
    enable      => $ensure,
    exec        => "/usr/local/rvm/bin/rvm $ruby_version do riemann-riak",
    description => 'Riemann Riak - Riak monitoring',
    group       => $group,
    user        => $user,
  } ->

  rvm::system_user { 'riemann-riak': }

}