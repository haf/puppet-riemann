class riemann::service(
  $ensure = 'running',
  $enable = true
) {
  $log_dir = $riemann::log_dir
  $bin_dir = $riemann::bin_dir
  $user    = $riemann::user
  $group   = $riemann::group
  $use_pkg = $riemann::use_pkg
  $config  = $riemann::config_file

  rvm::system_user { 'riemann': }

  if $use_pkg {
    service { 'riemann':
      ensure => 'running',
    }
  } else {
    svcutils::mixsvc { 'riemann':
      ensure      => $ensure,
      enable      => $enable,
      user        => $user,
      group       => $group,
      log_dir     => $log_dir,
      exec        => "${bin_dir}/riemann $config",
      description => 'Riemann Server',
      before      => Rvm::System_user['riemann'],
    } 
  }
}