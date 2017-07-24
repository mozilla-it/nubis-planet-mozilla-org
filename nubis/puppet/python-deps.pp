# Package requirements to help resolve issue-4 in GitHub

# Apt dependencies
$packages = [
  'libssl-dev',
  'build-essential',
  'libffi-dev',
]

package {
  $packages:
    ensure  => 'installed',
}

# Pip dependencies

python::pip { 'idna':
  ensure => '2.5',
}

python::pip { 'pyopenssl':
  ensure => '17.2.0',
}

python::pip { 'feedparser':
  ensure => '5.2.1',
}

python::pip { 'lockfile':
  ensure => '0.12.2',
}

python::pip { 'CacheControl':
  ensure => '0.12.3',
}
