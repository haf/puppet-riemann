# Options:
#                --host, -h <s>:   Riemann host (default: 127.0.0.1)
#                --port, -p <i>:   Riemann port (default: 5555)
#          --event-host, -e <s>:   Event hostname
#            --interval, -i <i>:   Seconds between updates (default: 5)
#                 --tag, -t <s>:   Tag to add to events
#                 --ttl, -l <i>:   TTL for events
#           --attribute, -a <s>:   Attribute to add to the event
#             --timeout, -m <i>:   Timeout (in seconds) when waiting for acknowledgements (default: 30)
#           --tcp, --no-tcp, -c:   Use TCP transport instead of UDP (improves reliability, slight overhead. (Default: true)
#         --interfaces, -n <s+>:   Interfaces to monitor
#  --ignore-interfaces, -g <s+>:   Interfaces to ignore (default: lo)
#                        --help:   Show this message
class riemann::net(
  $ensure               = 'present',
  $config_file          = '',
  $config_file_template = '',
  $user                 = 'riemann-net',
  $host                 = '127.0.0.1',
  $port                 = 5555,
  $event_host           = $::fqdn,
  $interval             = 5,
  $tags                 = [ $::hostname ],
  $attributes           = [],
  $timeout              = 30,
  $use_tcp              = true,
  $interfaces           = undef,
  $ignore_interfaces    = 'lo'
) {
  include riemann::common

  $home                 = "/home/$user"

  $is_on_server = defined(Class['riemann'])

  $group = $is_on_server ? {
    true     => $riemann::group,
    default  => $riemann::common::group,
  }

  anchor { 'riemann::net::start': }

  user { $user:
    ensure  => $ensure,
    gid     => $group,
    home    => $home,
    system  => true,
    require => [
      Anchor['riemann::net::start'],
      Group[$group]
    ],
    before  => Anchor['riemann::net::end'],
  }

  file { $home:
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => '0755',
    require => [
      Anchor['riemann::net::start'],
      User[$user]
    ],
    before  => Anchor['riemann::net::end'],
  }

  riemann::utils::gem_service { 'riemann-tools':
    gem          => 'riemann-tools.haf',
    ensure       => $ensure,
    user         => $user,
    group        => $group,
    home         => $home,
    ruby_version => $riemann::common::ruby_version,
    require      => [
      Anchor['riemann::net::start'],
      File[$home]
    ],
    before       => Anchor['riemann::net::end'],
  }

  class { 'riemann::net::config':
    require => [
      Anchor['riemann::net::start'],
      Riemann::Utils::Gem_service['riemann-tools']
    ],
    before  => Anchor['riemann::net::end'],
    notify  => Class['riemann::net::service'],
  }

  class { 'riemann::net::service':
    require => [
      Anchor['riemann::net::start'],
      Class['riemann::net::config']
    ],
    before  => Anchor['riemann::net::end'],
  }

  anchor { 'riemann::net::end': }
}