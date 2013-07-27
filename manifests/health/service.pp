class riemann::health::service(
  $ensure = 'running',
  $enable = true
) {
  $log_dir = $riemann::health::log_dir
  $group   = $riemann::health::group
  $ruby_version = $riemann::health::ruby_version

  rvm::system_user { 'riemann-health': }

  svcutils::mixsvc { 'riemann-health':
    log_dir     => $log_dir,
    ensure      => $ensure,
    enable      => $enable,
    exec        => "/usr/local/rvm/bin/rvm $ruby_version do riemann-health",
    description => 'Riemann Health Process',
    group       => $group,
    before      => Rvm::System_user['riemann-health'],
  }
}