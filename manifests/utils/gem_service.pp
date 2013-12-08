# Creates a rbenv for the given user, and installs a gem in that environment.
define riemann::utils::gem_service(
  $ensure = 'installed',
  $gem    = $name,
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

  $_compile_name = "${user}-${$riemann::common::ruby_version}"

  rbenv::compile { $_compile_name:
    user    => $user,
    group   => $group,
    home    => $home,
    global  => true,
    ruby    => $riemann::common::ruby_version,
    require => Rbenv::Install[$user],
  }

  rbenv::gem { $gem:
    ensure       => present,
    ruby         => $ruby_version,
    user         => $user,
    home         => $home,
    require      => Rbenv::Compile[$_compile_name],
  }
}