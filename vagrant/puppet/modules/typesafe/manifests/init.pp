
class typesafe ($version, $package_dir = "/opt") {

    exec{'typesafe::get-activator':
        command => "/usr/bin/wget -q http://downloads.typesafe.com/typesafe-activator/${version}/typesafe-activator-${version}.zip -O ${package_dir}/typesafe-activator-${version}.zip",
        creates  => "${package_dir}/typesafe-activator-${version}.zip",
        timeout  => 1800
    }

    package {'unzip':
        provider => apt,
        ensure => present
    }

    exec{'typesafe::unzip-activator':
        command => "/usr/bin/sudo /usr/bin/unzip ${package_dir}/typesafe-activator-${version}.zip -d /usr/share/typesafe",
        require => [Package['unzip'], Exec['typesafe::get-activator']],
        unless  => "/usr/bin/test -d /usr/share/typesafe/activator-${version}"
    }

    exec{'typesafe::unlink-activator':
        command => "/usr/bin/sudo /bin/rm -f /usr/local/bin/activator",
        require => Exec['typesafe::unzip-activator'],
        onlyif => "/usr/bin/test -h /usr/local/bin/activator"
    }

    exec{'typesafe::link-activator':
        command => "/usr/bin/sudo /bin/ln -s /usr/share/typesafe/activator-${version}/activator /usr/local/bin/",
        require => Exec['typesafe::unlink-activator']
    }

    exec{'typesafe::chmod-activator':
        command => "/usr/bin/sudo /bin/chmod 755 /usr/local/bin/activator",
        require => Exec['typesafe::link-activator'],
        onlyif => "/usr/bin/test -f /usr/local/bin/activator"
    }

    file {'/home/vagrant/.activator':
        ensure => "directory",
        owner  => "vagrant",
        group  => "vagrant",
        mode   => 750,
    }

    file {"/home/vagrant/.activator/activatorconfig.txt":
        mode => "0644",
        owner => 'vagrant',
        group => 'vagrant',
        source => 'puppet:///modules/typesafe/activatorconfig.txt',
        require => File['/home/vagrant/.activator']
    }

    #exec{'typesafe::run-activator':
    #   command => "/usr/local/bin/activator ui >> /var/log/activator.log 2>&1 &",
    #   require => Exec['typesafe::link-activator']
    #}

}