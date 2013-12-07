# Install the riemann server on the server.
class riemann(
  $version              = '0.2.0',
  $config_file          = '/etc/riemann/riemann.config',
  $config_file_source   = '',
  $config_file_template = 'riemann/riemann.config.erb',
  $host                 = '0.0.0.0',
  $port                 = 5555,
  $wsport               = 5556,
  $dir                  = '/opt/riemann',
  $log_dir              = '/var/log/riemann',
  $user                 = 'riemann',
  $use_pkg              = true,
  $use_download         = false,
  $manage_firewall      = hiera('manage_firewalls', false)
) {
  include riemann::common

  $home               = "/home/$user"
  $group              = $riemann::common::group
  $bin_dir            = "$dir/bin"

  validate_string($version, $host, $port)

  anchor { 'riemann::start': }

  file { $home:
    ensure => directory,
    mode   => '0755',
    owner  => $user,
    group  => $group,
    require => Anchor['riemann::start'],
    before  => Anchor['riemann::end'],
  }

  user { $user:
    gid     => $group,
    system  => true,
    home    => $home,
    require => [
      Anchor['riemann::start'],
      Group[$group],
      File[$home]
    ],
    before  => Anchor['riemann::end'],
  }

  class { 'riemann::package':
    require => [
      Anchor['riemann::start'],
      Class['java']
    ],
    before  => Anchor['riemann::end'],
  } ->
  class { 'riemann::config':
    require => Anchor['riemann::start'],
    before  => Anchor['riemann::end'],
  } ~>
  class { 'riemann::service':
    require => Anchor['riemann::start'],
    before  => Anchor['riemann::end']
  }

  anchor { 'riemann::end': }
}