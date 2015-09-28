# ecryptfs

#### Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Limitations - OS compatibility, etc.](#limitations)

## Overview

This module allows to manage [ecryptfs](http://ecryptfs.org/) mounts as puppet types.
Passphrase for encryption should be stored in a file and secured separately.

Mounts are NOT persisted across reboots.

## Usage

Use `ecryptfs::mount` type to define encrypted mounts:

```puppet
ecryptfs::mount { 'encrypted JENKINS_HOME':
  source_dir      => '/mnt/ebs/jenkins',
  dest_dir        => '/var/lib/jenkins',
  passphrase_file => '/dev/shm/.jenkins_home_ecryptfs'
}
```

This will install ecryptfs-utils and try to mount `/mnt/ebs/jenkins` to `/var/lib/jenkins` using a
passphrase stored in plaintext in a file `/dev/shm/.jenkins_home_ecryptfs`. Please note that
a passphrase file should be created by you -- either by puppet or by any other means. Same goes
for a source and destination directory. Please see an example in [manifests/vagrant.pp](https://github.com/vivus-ignis/puppet-ecryptfs/blob/master/manifests/vagrant.pp).

If you need to define a resource which makes sure that an encrypted mount is UNMOUNTED upon
puppet run, set `ensure => unmounted` leaving all the other parameters in place.

## Limitations

This module was tested on CentOS 6.x so far.
