# Install the riemann server on the server.
class riemann(
  $version            = $riemann::params::version,
  $config_file        = $riemann::params::config_file,
  $config_file_source = $riemann::params::config_file_source,
  $config_file_template = $riemann::params::config_file_template,
  $host               = $riemann::params::host,
  $port               = $riemann::params::port,
  $wsport             = $riemann::params::wsport,
  $dir                = $riemann::params::dir,
  $bin_dir            = $riemann::params::bin_dir,
  $log_dir            = $riemann::params::log_dir,
  $group              = $riemann::params::group,
  $user               = $riemann::params::user,
  $use_pkg            = $riemann::params::use_pkg
) inherits riemann::params {
  include svcutils

  validate_string($version, $host, $port)

  if ! defined(Class['java']) {
    class { 'java':
      distribution => 'jre',
    }
  }

  anchor { 'riemann::start': }
  svcutils::svcuser { $user:
    group   => $group,
    require => [
      Anchor['riemann::start'],
      Class['riemann::common']
    ],
    before  => Anchor['riemann::end'],
  } ->
  class { 'riemann::package':
    require => [
      Anchor['riemann::start'],
      Class['java'],
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