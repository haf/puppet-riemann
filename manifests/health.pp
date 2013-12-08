# Options:
#            --host, -h <s>:   Riemann host (default: 127.0.0.1)
#            --port, -p <i>:   Riemann port (default: 5555)
#      --event-host, -e <s>:   Event hostname
#        --interval, -i <i>:   Seconds between updates (default: 5)
#             --tag, -t <s>:   Tag to add to events
#             --ttl, -l <i>:   TTL for events
#       --attribute, -a <s>:   Attribute to add to the event
#         --timeout, -m <i>:   Timeout (in seconds) when waiting for acknowledgements (default: 30)
#     --cpu-warning, -c <f>:   CPU warning threshold (fraction of total jiffies) (default: 0.9)
#    --cpu-critical, -u <f>:   CPU critical threshold (fraction of total jiffies) (default: 0.95)
#    --disk-warning, -d <f>:   Disk warning threshold (fraction of space used) (default: 0.9)
#   --disk-critical, -s <f>:   Disk critical threshold (fraction of space used) (default: 0.95)
#    --load-warning, -o <i>:   Load warning threshold (load average / core) (default: 3)
#   --load-critical, -r <i>:   Load critical threshold (load average / core) (default: 8)
#  --memory-warning, -y <f>:   Memory warning threshold (fraction of RAM) (default: 0.85)
#     --memory-critical <f>:   Memory critical threshold (fraction of RAM) (default: 0.95)
#         --checks, -k <s+>:   A list of checks to run. (Default: cpu, load, memory, disk)
class riemann::health(
  $enable               = true,
  $user                 = 'riemann-health',
  $host                 = '127.0.0.1',
  $port                 = 5555,
  $event_host           = undef,
  $interval             = 5,
  $ttl                  = undef,
  $attribute            = undef,
  $timeout              = 30,
  $tags                 = undef,
  $cpu_warning          = '0.9',
  $cpu_critical         = '0.95',
  $disk_warning         = '0.9',
  $disk_critical        = '0.95',
  $load_warning         = 3,
  $load_critical        = 8,
  $memory_warning       = '0.85',
  $memory_critical      = '0.95',
  # $checks               = 'cpu,load,memory,disk',
) {
  include riemann::common

  $home                 = "/home/$user"

  $is_on_server = defined(Class['riemann'])

  $group = $is_on_server ? {
    true     => $riemann::group,
    default  => $riemann::common::group,
  }

  $_tags = $tags ? {
    undef   => [ $::hostname ],
    default => $tags
  }

  anchor { 'riemann::health::start': }

  user { $user:
    gid     => $group,
    system  => true,
    home    => $home,
    require => [
      Anchor['riemann::health::start'],
      Group[$group]
    ],
    before  => Anchor['riemann::health::end'],
  }

  file { $home:
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
    require => [
      Anchor['riemann::health::start'],
      User[$user]
    ],
    before  => Anchor['riemann::health::end'],
  }

  riemann::utils::gem_service { 'riemann-tools.haf':
    ensure       => 'installed',
    user         => $user,
    group        => $group,
    home         => $home,
    ruby_version => $riemann::common::ruby_version,
    require      => [
      Anchor['riemann::health::start'],
      File[$home]
    ],
    before       => Anchor['riemann::health::end'],
  }

  class { 'riemann::health::config':
    require => [
      Anchor['riemann::health::start'],
      Riemann::Utils::Gem_service['riemann-tools']
    ],
    before  => Anchor['riemann::health::end'],
    notify  => Class['riemann::health::service'],
  }

  class { 'riemann::health::service':
    require => [
      Anchor['riemann::health::start'],
      Class['riemann::health::config']
    ],
    before  => Anchor['riemann::health::end'],
  }

  anchor { 'riemann::health::end': }
}