class riemann::health::service(
  $ensure = 'running'
) {
  $tags         = repeated_param('tag', $riemann::health::_tags)

  supervisor::service { 'riemann-health':
    ensure      => $ensure,
    command     => "riemann-health \
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
    group       => $riemann::health::group,
    user        => $riemann::health::user,
  }
}