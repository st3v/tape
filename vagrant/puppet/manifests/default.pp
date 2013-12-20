exec { "apt-get-update":
    command => "/usr/bin/apt-get update",
    onlyif => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'"
}

package {'curl':
    provider => apt,
    ensure => present,
    require => Exec['apt-get-update']
}

package {'git-core':
    provider => apt,
    ensure => latest,
    require => Exec['apt-get-update']
}

$package_cache = "/tape/vagrant/.package-cache"
file {"${package_cache}":
    ensure => "directory"
}

package {'openjdk-7-jdk':
    provider => apt,
    ensure => latest,
    require => Exec['apt-get-update']
}

class {'elasticsearch':
    version => '0.90.8',
    package_dir => "${package_cache}",
    require => [Package['openjdk-7-jdk'],File["${package_cache}"]]
}

class {'typesafe':
    version => '1.0.9',
    package_dir => "${package_cache}",
    require => [Package['openjdk-7-jdk'],File["${package_cache}"]]
}
