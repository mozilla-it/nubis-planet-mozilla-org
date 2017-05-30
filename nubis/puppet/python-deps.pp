# Package requirements to help resolve issue-4 in GitHub

# Apt dependencies
$packages = [
  'libssl-dev',
  'python-pip',
  'build-essential',
  'libffi-dev',
  'python-dev'
]

package {
  $packages:
    ensure  => 'installed',
}

# Pip dependencies
exec { 'pip-idna':
  command => '/usr/bin/pip install idna',
}

exec { 'pip-pyopenssl':
  command => '/usr/bin/pip install pyopenssl',
}

exec { 'pip-feedparser':
  command => '/usr/bin/pip install feedparser',
}
