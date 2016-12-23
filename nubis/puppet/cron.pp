cron { '/opt/admin-scripts/planet.sh':
  command => '/opt/admin-scripts/planet.sh',
  user    => 'root',
  minute  => '*/5'
}
