# Creates a rbenv for the given user, and installs a gem in that environment.
define riemann::utils::gem(
  $ensure = 'installed',
  $home,
  $user,
  $group,
  $ruby_version,
) {
  rbenv::install { $user:
    group   => $group,
    home    => $home,
    require => File[$home],
  }

  rbenv::compile { $riemann::common::ruby_version:
    user   => $user,
    group  => $group,
    home   => $home,
    global => true,
    require => Rbenv::Install[$user],
  }

  rbenv::gem { $name:
    ensure       => present,
    ruby         => $ruby_version,
    user         => $user,
    home         => $home,
    require      => Rbenv::Compile[$ruby_version],
  }
}