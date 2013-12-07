class riemann::riak::package(
  $ensure = 'installed'
) {
  riemann::utils::gem { 'riemann-riak':
    ensure       => $ensure,
    user         => $riemann::riak::user,
    group        => $riemann::riak::group,
    home         => $riemann::riak::home,
    ruby_version => $riemann::common::ruby_version,
  }
}