# Ensure that required packages are available

case $::osfamily {
  'RedHat': {
    package {
      'python':
        ensure => '2.7.5-48.el7',
        name   => 'python'
    }
  }
  'Debian', 'Ubuntu': {
    package {
      'python':
        ensure => '2.7.11-1',
        name   => 'python'
    }
  }
  default: {
    fail("Unknown package version for OS ${::osfamily}")
  }
}
