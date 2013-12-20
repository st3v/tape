class elasticsearch ($version) {

    exec{'get-es-package':
        command => "/usr/bin/wget -q https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${version}.deb -O /tmp/elasticsearch-${version}.deb",
        creates => "/tmp/elasticsearch-${version}.deb",
        unless => "/usr/bin/test -f /usr/share/elasticsearch/bin/elasticsearch && /usr/share/elasticsearch/bin/elasticsearch -v | grep -ce 'Version: ${version},.*'",
        timeout  => 1800
    }

    package {'elasticsearch':
        provider => dpkg,
        ensure => latest,
        source => "/tmp/elasticsearch-${version}.deb",
        require => Exec['get-es-package']
    }

}