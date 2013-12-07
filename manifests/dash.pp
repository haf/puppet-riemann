# Includes Package['riemann-dash'].
#
# Parameters:
#   config_file: the path to the configuration file
#     to use for parameters for the dashboard. It is a
#     Sinatra web configuration file. Defaults to a sane
#     default if left empty.
class riemann::dash(
  $config_file_source   = '',
  $config_file_template = 'riemann/riemann-dash.rb.erb',
  $host                 = '0.0.0.0',
  $port                 = 4567,
  $log_dir              = '/var/log/riemann-dash',
  $config_file          = '/etc/riemann/riemann-dash.rb',
  $user                 = 'riemann-dash',
  $manage_firewall      = hiera('manage_firewalls', false)
) {
  include riemann::common

  $home                 = "/home/$user"
  $group                = $riemann::common::group

  anchor { 'riemann::dash::start': }

  file { $home:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => Anchor['riemann::dash::start'],
    before  => Anchor['riemann::dash::end'],
  }

  user { $user:
    gid     => $group,
    home    => $home,
    shell   => '/bin/bash',
    system  => true,
    require => [
      Anchor['riemann::dash::start'],
      Group[$group],
      File[$home]
    ],
    before  => Anchor['riemann::dash::end'],
  } ->

  class { 'riemann::dash::package':
    require => Anchor['riemann::dash::start'],
    before  => Anchor['riemann::dash::end'],
  } ->
  class { 'riemann::dash::config':
    require => Anchor['riemann::dash::start'],
    before  => Anchor['riemann::dash::end'],
  } ~>
  class { 'riemann::dash::service':
    require => Anchor['riemann::dash::start'],
    before  => Anchor['riemann::dash::end'],
  }

  anchor { 'riemann::dash::end': }
}