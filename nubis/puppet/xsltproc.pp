# Ensure that required packages are available

case $::osfamily {
  'RedHat': {
    package {
      'xsltproc':
        ensure => '1.1.28-5.el7',
        name   => 'libxslt-devel'
    }
  }
  'Debian', 'Ubuntu': {
    package {
      'xsltproc':
        ensure => '1.1.28-2.1',
        name   => 'xsltproc'
    }
  }
  default: {
    fail("Unknown package version for OS ${::osfamily}")
  }
}
