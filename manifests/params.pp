class ecryptfs::params {
  $package_name = $::osfamily ? {
    default => 'ecryptfs-utils'
  }
}
