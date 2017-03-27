# Ensure that required packages are available

case $::osfamily {
  'RedHat': {
    package {
      'git':
        ensure => '2.7.3-1.46.amzn1',
        name   => 'git'
    }
  }
  'Debian', 'Ubuntu': {
    package {
      'git':
        ensure => '1:1.9.1-1ubuntu0.4',
        name   => 'git'
    }
  }
  default: {
    fail("Unknown package version for OS ${::osfamily}")
  }
}
