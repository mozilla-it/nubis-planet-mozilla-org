# Ensure that Python 2.7 is installed

case $::osfamily {
  'RedHat': {
    $python_package            = 'python2.7.5-39.el7_2'
  }
  'Debian', 'Ubuntu': {
    $python_package            = 'python2.7'
  }
  default: {
    fail("Unknown Python package for OS ${::osfamily}")
  }
}

package {
  'python':
    ensure => installed,
    name   => $python_package,
}
