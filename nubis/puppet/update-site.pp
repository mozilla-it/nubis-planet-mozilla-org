file { '/opt/admin-scripts':
  ensure => 'directory',
  owner  => root,
  group  => root,
  mode   => '0755',
}

file {'/opt/admin-scripts/symlink_add.sh':
  ensure  => file,
  owner   => root,
  group   => root,
  mode    => '0755',
  source  => 'puppet:///nubis/files/symlink_add.sh',
  require => File['/opt/admin-scripts'],
}

file {'/opt/admin-scripts/symlink_remove.sh':
  ensure  => file,
  owner   => root,
  group   => root,
  mode    => '0755',
  source  => 'puppet:///nubis/files/symlink_remove.sh',
  require => File['/opt/admin-scripts'],
}

file { '/data':
  ensure => 'directory',
  owner  => root,
  group  => root,
  mode   => '0755',
}

file { '/data/static':
  ensure  => 'directory',
  owner   => root,
  group   => root,
  mode    => '0755',
  require => File['/data'],
}

file { '/data/static/src':
  ensure  => 'directory',
  owner   => root,
  group   => root,
  mode    => '0755',
  require => File['/data/static'],
}

file { '/data/static/build':
  ensure  => 'directory',
  owner   => root,
  group   => root,
  mode    => '0755',
  require => File['/data/static'],
}

file { '/data/static/build/planet-content':
  ensure  => 'directory',
  owner   => root,
  group   => root,
  mode    => '0755',
  require => File['/data/static/build'],
}

file { '/data/static/build/planet-source':
  ensure  => 'directory',
  owner   => root,
  group   => root,
  mode    => '0755',
  require => File['/data/static/build'],
}
