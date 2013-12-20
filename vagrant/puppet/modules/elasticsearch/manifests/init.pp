class elasticsearch ($version, $package_dir = "/opt") {

    exec{'elasticsearch::get-package':
        command => "/usr/bin/wget -q https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${version}.deb -O ${package_dir}/elasticsearch-${version}.deb",
        creates => "${package_dir}/elasticsearch-${version}.deb",
        unless => "/usr/bin/test -f /usr/share/elasticsearch/bin/elasticsearch && /usr/share/elasticsearch/bin/elasticsearch -v | /bin/grep -ce 'Version: ${version},.*'",
        timeout  => 1800
    }

    package {'elasticsearch':
        provider => dpkg,
        ensure => latest,
        source => "${package_dir}/elasticsearch-${version}.deb",
        require => Exec['elasticsearch::get-package']
    }

}