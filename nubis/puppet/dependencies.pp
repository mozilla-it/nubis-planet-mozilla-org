# Ensure that required packages are available

case $::osfamily {
  'RedHat': {
    $git_package_version = '2.7.3-1.46.amzn1',
    $git_package_name = 'git',
    $xsltproc_package_version = '1.1.28-5.el7',
    $xsltproc_package_name = 'libxslt-devel',
    $python_package_version = '2.7.5-48.el7',
    $python_package_name = 'python'
  }
  'Debian', 'Ubuntu': {
    $git_package_version = '1:1.9.1-1ubuntu0.3',
    $git_package_name = 'git',
    $xsltproc_package_version = '1.1.28-2.1',
    $xsltproc_package_name = 'xsltproc',
    $python_package_version = '2.7.11-1',
    $python_package_name = 'python'
  }
  default: {
    fail("Unknown package version for OS ${::osfamily}")
  }
}

package {
  'git':
    ensure => $git_package_version,
    name   => $git_package_name
}

package {
  'xsltproc':
    ensure => $xsltproc_package_version,
    name   => $xsltproc_package_name
}

package {
  'python':
    ensure => $python_package_version,
    name   => $python_package_name
}
