class elasticsearch ($version) {

    exec{'get-es-package':
        command => "/usr/bin/wget -q https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${version}.deb -O /opt/elasticsearch-${version}.deb",
        creates => "/opt/elasticsearch-${version}.deb",
        unless => "/usr/bin/test -f /usr/share/elasticsearch/bin/elasticsearch && /usr/share/elasticsearch/bin/elasticsearch -v | grep -ce 'Version: ${version},.*'",
        timeout  => 1800
    }

    package {'elasticsearch':
        provider => dpkg,
        ensure => latest,
        source => "/opt/elasticsearch-${version}.deb",
        require => Exec['get-es-package']
    }

}