# Ensure that Python 2.7 is installed

class { 'python' :
  version    => '2.6',
  pip        => 'present',
  dev        => 'absent',
  virtualenv => 'present',
  gunicorn   => 'absent',
}

package {
  'libxslt':
    ensure => installed
}
