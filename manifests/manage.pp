# Manages an user, his home and files
define users::manage
  (
  Struct[{
    password   => Optional[String[0, default]],
    ssh        => Optional[
      Struct[{
        key       => String[1, default],
        key_label => String[1, default],
        key_type  => String[7, 7],
      }]
    ],
  }] $userdata
){
  File {
    group => $name,
    mode  => '0700',
    owner => $name,
  }

  user { $name:
    ensure   => present,
    password => empty($userdata['password']) ? {
      false => $userdata['password'],
      true  => '',
    },
    shell    => '/bin/bash',
    groups   => 'bbadmins',
    home     => "/home/${name}",
    require  => Package[[keys($::users::mandatory_dependencies)]],
  }

  file { "/home/${name}":
    ensure  => directory,
    mode    => '0755',
    owner   => $name,
    require => User[$name],
  }

  file { "/home/${name}/.ssh":
    ensure  => directory,
    owner   => $name,
    require => File["/home/${name}"],
  }

  # Manage SSH keys
  $ssh_public_key = try_get_value($userdata, "ssh/key")

  if !empty($ssh_public_key) {
    File{ "${name}_ssh_public_key":
    content => $ssh_public_key,
    group   => $name,
    mode    => '0655',
    owner   => $name,
    path    => "/home/${name}/.ssh/${name}.pub",
    }
  }

  # Manage authorized_keys
  file { "/home/${name}/.ssh/authorized_keys":
    ensure  => present,
    content => epp('users/authorized_keys', { 'name' => $name }),
    owner   => $name,
    require => File["/home/${name}/.ssh"],
  }
}