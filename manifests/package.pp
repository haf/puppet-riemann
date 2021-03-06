class riemann::package(
  $ensure       = 'present'
) {
  $version     = $riemann::version
  $riemann_dir = $riemann::dir

  if $riemann::use_pkg {
    package { 'riemann':
      ensure => $ensure,
    }
  }
  elsif $riemann::use_download {
    $package_provider = $::osfamily ? {
      /(?i:linux|redhat)/ => 'rpm',
      default             => 'dpkg',
    }
    $package_name = $::osfamily ? {
      /(?i:linux|redhat)/ => "riemann-${version}-1.noarch.rpm",
      default             => "riemann_${version}_all.deb",
    }
    $package = "http://aphyr.com/riemann/$package_name"

    wget::fetch { 'download_riemann':
      source      => $package,
      destination => "/tmp/$package_name",
      require     => Class['wget'],
    }

    package { 'riemann':
      ensure   => 'installed',
      source   => "/tmp/$package_name",
      provider => $package_provider,
      require  => Wget::Fetch['download_riemann'],
    }
  }
  else {
    wget::fetch { 'download_riemann':
      source      => "http://aphyr.com/riemann/riemann-$version.tar.bz2",
      destination => "/usr/local/src/riemann-$version.tar.bz2",
      before      => Exec['untar_riemann'],
    }

    exec { 'untar_riemann':
      command => "tar xvfj /usr/local/src/riemann-$version.tar.bz2",
      cwd     => '/opt',
      creates => "${riemann_dir}-$version",
      path    => ['/bin', '/usr/bin'],
      before  => File[$riemann_dir],
    }

    file { $riemann_dir:
      ensure => link,
      target => "${riemann_dir}-$version",
    }
  }
}