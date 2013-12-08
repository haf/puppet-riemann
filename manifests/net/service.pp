# Gathers munin statistics and submits them to Riemann.
class riemann::net::service(
  $ensure = 'present'
) {
  $tags         = repeated_param('tag', $riemann::net::tags)
  $attributes   = repeated_param('attribute', $riemann::net::attributes)
  $tcp_flag = $riemann::net::use_tcp ? {
    true    => '--tcp',
    default => '--no-tcp'
  }
  $interfaces = $riemann::net::interfaces ? {
    undef   => '',
    default => "--interfaces $riemann::net::interfaces"
  }

  supervisor::service { 'riemann-net':
    ensure      => $ensure,
    command     => "/home/${riemann::net::user}/.rbenv/shims/riemann-net \
--host $riemann::net::host \
--port $riemann::net::port \
--event-host $riemann::net::event_host \
--interval $riemann::net::interval \
$tags \
$attributes \
--timeout $riemann::net::timeout \
$tcp_flag \
$interfaces \
--ignore-interfaces $riemann::net::ignore_interfaces",
    group       => $riemann::net::group,
    user        => $riemann::net::user,
  }
}