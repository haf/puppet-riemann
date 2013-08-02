# Gathers munin statistics and submits them to Riemann.
class riemann::net::service(
  $ensure = 'running',
  $enable = true
) {
  $log_dir = $riemann::net::log_dir
  $group   = $riemann::net::group
  $ruby_version = $riemann::net::ruby_version
  $user         = $riemann::net::user

  svcutils::mixsvc { 'riemann-net':
    log_dir     => $log_dir,
    ensure      => $ensure,
    enable      => $enable,
    exec        => "/usr/local/rvm/bin/rvm $ruby_version do riemann-net",
    description => 'Riemann Net Process',
    group       => $group,
    user        => $user,
  } ->

  rvm::system_user { $user: }
}