# Installs the riemann-dash service.
class riemann::dash::service(
  $ensure = 'running',
  $enable = true
) {
  $log_dir      = $riemann::dash::log_dir
  $config_file  = $riemann::dash::config_file
  $home         = $riemann::dash::home
  $group        = $riemann::dash::group
  $ruby_version = $riemann::dash::ruby_version
  $user         = $riemann::dash::user

  svcutils::mixsvc { 'riemann-dash':
    log_dir     => $log_dir,
    ensure      => $ensure,
    enable      => $enable,
    exec        => "/usr/local/rvm/bin/rvm $ruby_version do riemann-dash $config_file",
    description => 'A service that launches the riemann dashboard',
    group       => $group,
    home        => $home,
    user        => $user,
  } ->

  rvm::system_user { $user: }
}