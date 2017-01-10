# http://git.savannah.gnu.org/cgit/parallel.git/tree/README

exec { 'install-gnu-parallel':
  command => '( wget -O - pi.dk/3 || curl pi.dk/3/ || fetch -o - http://pi.dk/3 ) | bash',
  creates => '/usr/local/bin/parallel',
  path    => ['/sbin','/bin','/usr/sbin','/usr/bin','/usr/local/sbin','/usr/local/bin'],
}->
exec {'accept-gnu-parallel-license':
  path    => ['/sbin','/bin','/usr/sbin','/usr/bin','/usr/local/sbin','/usr/local/bin'],
  command => 'echo "will cite" | /usr/local/bin/parallel --citation',
}
