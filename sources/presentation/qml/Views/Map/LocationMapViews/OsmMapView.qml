import QtQuick 2.6
import QtLocation 5.6
import QtPositioning 5.6

BaseMapView {
    id: map

    plugin: Plugin {
        name: "osm"

        PluginParameter { name: "osm.useragent"; value: "JAGCS" }
        PluginParameter { name: "osm.mapping.custom.host"; value: "http://a.tile.openstreetmap.org/" }
        PluginParameter { name: "osm.mapping.cache.disk.size"; value: settings.value("Map/cacheSize", 0) }
        PluginParameter { name: "osm.mapping.highdpi_tiles"; value: settings.boolValue("Map/highdpiTiles", true) }
    }

    activeMapType: supportedMapTypes[settings.value("Map/osmActiveMapType")]
}
