class riemann::common(
  $group = 'riemanns',
  $ruby_version
) {
  require epel

  anchor { 'riemann::common::start': }

  group { $group:
    ensure  => present,
    system  => true,
    require => Anchor['riemann::common::start'],
    before  => Anchor['riemann::common::end'],
  }

  $required_packages = [
    'make',
    'automake',
    'gcc',
    'gcc-c++',
    'libxml2',
    'libxml2-devel',
    'libxslt',
    'libxslt-devel'
  ]

  ensure_packages($required_packages)

  Anchor['riemann::common::start'] -> Package[$required_packages] -> Anchor['riemann::common::end']

  anchor { 'riemann::common::end': }
}