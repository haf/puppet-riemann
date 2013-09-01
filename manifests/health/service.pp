class riemann::health::service(
  $ensure = 'running',
  $enable = true
) {
  $log_dir      = $riemann::health::log_dir
  $group        = $riemann::health::group
  $ruby_version = $riemann::health::ruby_version
  $user         = $riemann::health::user
  $tags         = repeated_param('tag', $riemann::health::_tags)

  svcutils::mixsvc { 'riemann-health':
    log_dir     => $log_dir,
    ensure      => $ensure,
    enable      => $enable,
    exec        => "/usr/local/rvm/bin/rvm $ruby_version do riemann-health \
--host $riemann::health::host \
--port $riemann::health::port \
--interval $riemann::health::interval \
--timeout $riemann::health::timeout \
$tags \
--cpu-warning ${riemann::health::cpu_warning} \
--cpu-critical ${riemann::health::cpu_critical} \
--disk-warning ${riemann::health::disk_warning} \
--disk-critical ${riemann::health::disk_critical} \
--load-warning ${riemann::health::load_warning} \
--load-critical ${riemann::health::load_critical} \
--memory-warning ${riemann::health::memory_warning} \
--memory-critical ${riemann::health::memory_critical}",
    description => 'Riemann Health Process',
    group       => $group,
    user        => $user,
  } ->

  rvm::system_user { 'riemann-health': }
}