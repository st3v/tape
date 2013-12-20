exec { "apt-get-update":
    command => "/usr/bin/apt-get update",
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

package {'openjdk-7-jre-headless':
    provider => apt,
    ensure => latest,
    require => Exec['apt-get-update']
}

class {'elasticsearch':
    version => '0.90.8',
    require => [Exec['apt-get-update'],Package['openjdk-7-jre-headless']],
}

class {'typesafe':
    version => '1.0.9',
    require => Package['openjdk-7-jre-headless']
}
