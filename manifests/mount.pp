define ecryptfs::mount (
  $source_dir,
  $dest_dir,
  $passphrase_file,
  $cipher           = 'aes',
  $cipher_keysize   = 32,
  $ensure           = 'mounted'
) {
  require ecryptfs

  validate_absolute_path($dest_dir)
  validate_absolute_path($source_dir)
  validate_absolute_path($passphrase_file)
  validate_re($ensure, [ '^mounted$', '^unmounted$' ])

  $name_norm       = inline_template("<%= @name.gsub(/\s/, '_') %>")
  $source_dir_norm = inline_template("<%= @source_dir.gsub(/\s/, '_') %>")
  $dest_dir_norm   = inline_template("<%= @dest_dir.gsub(/\s/, '_') %>")
  $fnek_file       = "/dev/shm/.puppet_ecryptfs__${name_norm}.fnek"

  Exec {
    path => '/bin:/usr/bin:/sbin:/usr/sbin'
  }

  $ecryptfs_options = {
    'ecryptfs_cipher'                 => $cipher,
    'ecryptfs_key_bytes'              => $cipher_keysize,
    'key'                             => "passphrase:passphrase_passwd_file=${passphrase_file}",
    'ecryptfs_passthrough'            => 'n',
    'ecryptfs_enable_filename_crypto' => 'y',
    'no_sig_cache'                    => 'y',
    'ecryptfs_fnek_sig'               => "`cat ${fnek_file}`"
  }

  $cli_opts = join(join_keys_to_values($ecryptfs_options, '='), ',')

  # notify { "ecryptfs // options: ${cli_opts}": } ->

  case $ensure {

    'mounted': {
      exec { $fnek_file:
        command     => "cat ${passphrase_file} | ecryptfs-add-passphrase --fnek - | head -1 | cut -d'[' -f2 | cut -d']' -f1 | perl -pe 'chomp' > ${fnek_file}",
        environment => 'LC_ALL=C',
        umask       => '0077',
        unless      => "mount | grep '^${source_dir} on ${dest_dir} type ecryptfs'"
      } ->

      exec { "ecryptfs_mount_${source_dir_norm}_${dest_dir_norm}":
        command => "mount -t ecryptfs '${source_dir}' '${dest_dir}' -o ${cli_opts}",
        unless  => "mount | grep '^${source_dir} on ${dest_dir} type ecryptfs'"
      } ->

      file { $fnek_file:
        ensure => absent
      }
    }

    'unmounted': {
      exec { "ecryptfs_umount_${source_dir_norm}_${dest_dir_norm}":
        command => "umount '${dest_dir}'",
        onlyif  => "mount | grep '^${source_dir} on ${dest_dir} type ecryptfs'"
      }
    }

    default: {
      # if we are here, that means parameters validation has failed
      fail("ecryptfs: ensure should be set either to 'mounted' or 'unmounted'")
    }

  }
}
