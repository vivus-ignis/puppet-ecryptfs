class ecryptfs (
  $package_name = $ecryptfs::params::package_name
) inherits ecryptfs::params {

  package { $package_name:
    ensure => present
  }

}
