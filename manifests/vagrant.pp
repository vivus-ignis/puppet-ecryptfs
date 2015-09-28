node default {
  file { '/tmp/passphrase':
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => 'passphrase_passwd=foobarbazquux'
  } ->

  file { [ '/tmp/source', '/tmp/dest' ]:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  } ->

  ecryptfs::mount { 'test ecryptfs mount':
    source_dir      => '/tmp/source',
    dest_dir        => '/tmp/dest',
    passphrase_file => '/tmp/passphrase'
  } ->

  file { '/tmp/dest/test1':
    content => 'foobarbaz'
  } ->

  ecryptfs::mount { 'test ecryptfs unmount':
    ensure          => unmounted,
    source_dir      => '/tmp/source',
    dest_dir        => '/tmp/dest',
    passphrase_file => '/tmp/passphrase'
  }
}
