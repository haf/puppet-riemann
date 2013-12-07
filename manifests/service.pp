class riemann::service(
  $ensure = 'present',
) {
  $bin_dir = $riemann::bin_dir
  $user    = $riemann::user
  $group   = $riemann::group
  $use_pkg = $riemann::use_pkg

  if $use_pkg {
    service { 'riemann':
      ensure => 'running',
    }
  } else {
    supervisor::service { 'riemann':
      ensure      => $ensure,
      user        => $user,
      group       => $group,
      command     => "${bin_dir}/riemann $riemann::config_file",
    } 
  }
}