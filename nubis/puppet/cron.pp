cron { 'update-site.sh':
  command => '/opt/admin-scripts/planet.sh',
  user    => 'root',
  minute  => [6, 16]
}
