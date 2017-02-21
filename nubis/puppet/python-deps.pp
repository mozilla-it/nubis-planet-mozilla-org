# Package requirements to help resolve issue-4 in GitHub

# Ensure everything is updated
exec { 'apt-get-update':
  command     => '/usr/bin/apt-get update',
  refreshonly => true,
}

# Apt dependencies
$packages = [
  'python-pip',
  'build-essential',
  'libffi-dev',
  'python-dev'
]

package {
  $packages:
    ensure  => 'installed',
    require => Exec['apt-get-update'],
}

# Pip dependencies
exec { 'pip-idna':
  command => '/usr/bin/pip install idna',
  require => Exec['apt-get-update'],
}

exec { 'pip-pyopenssl':
  command => '/usr/bin/pip install pyopenssl',
  require => Exec['apt-get-update'],
}
