# Ensure that Python 2.7 is installed

package {
  'python':
    ensure => installed
}

package {
  'libxslt':
    ensure => installed
}
