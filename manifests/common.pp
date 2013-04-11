class riemann::common(
  $group = $riemann::params::group
) inherits riemann::params {
  group { $group:
    ensure  => present,
    system  => true,
  }
}