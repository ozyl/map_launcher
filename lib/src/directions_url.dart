import 'dart:io';

import 'package:flutter/material.dart';
import 'package:map_launcher/src/models.dart';
import 'package:map_launcher/src/utils.dart';

String getMapDirectionsUrl({
  @required MapType mapType,
  @required Coords destination,
  @required String destinationTitle,
  @required Coords origin,
  @required String originTitle,
  @required DirectionsMode directionsMode,
  @required List<Coords> waypoints,
}) {
  switch (mapType) {
    case MapType.google:
      return Utils.buildUrl(
        url: 'https://www.google.com/maps/dir/',
        queryParams: {
          'api': '1',
          'destination': '${destination.latitude},${destination.longitude}',
          'origin': Utils.nullOrValue(
            origin,
            '${origin?.latitude},${origin?.longitude}',
          ),
          'waypoints': waypoints
              ?.map((coords) => '${coords.latitude},${coords.longitude}')
              ?.join('|'),
          'travelmode': Utils.enumToString(directionsMode),
        },
      );

    case MapType.apple:
      return Utils.buildUrl(
        url: 'http://maps.apple.com/maps',
        queryParams: {
          'daddr': '${destination.latitude},${destination.longitude}',
        },
      );

    case MapType.amap:
      return Utils.buildUrl(
        url: Platform.isIOS ? 'iosamap://path' : 'amapuri://route/plan/',
        queryParams: {
          'sourceApplication': 'applicationName',
          'dlat': '${destination.latitude}',
          'dlon': '${destination.longitude}',
          'dname': destinationTitle,
          'slat': Utils.nullOrValue(origin, '${origin?.latitude}'),
          'slon': Utils.nullOrValue(origin, '${origin?.longitude}'),
          'sname': originTitle,
          't': Utils.getAmapDirectionsMode(directionsMode),
          'dev': '0',
        },
      );

    case MapType.baidu:
      return Utils.buildUrl(
        url: 'baidumap://map/direction',
        queryParams: {
          'destination':
              'name: ${destinationTitle ?? 'Destination'}|latlng:${destination.latitude},${destination.longitude}',
          'origin': Utils.nullOrValue(
            origin,
            'name: ${originTitle ?? 'Origin'}|latlng:${origin?.latitude},${origin?.longitude}',
          ),
          'coord_type': 'gcj02',
          'mode': Utils.getBaiduDirectionsMode(directionsMode),
          'src': 'com.map_launcher',
        },
      );

    case MapType.waze:
      return Utils.buildUrl(
        url: 'waze://',
        queryParams: {
          'll': '${destination.latitude},${destination.longitude}',
          'z': '10',
          'navigate': 'yes',
        },
      );

    case MapType.tencent:
      return Utils.buildUrl(
        url: 'qqmap://map/routeplan',
        queryParams: {
          'from':originTitle,
          'fromCoord':"${origin?.latitude},${origin?.longitude}",
          'to':destinationTitle,
          "tocoord":"${destination.latitude},${destination.longitude}",
          'referer': 'map_launcher',
          'type':Utils.getTencentDirectionsMode(directionsMode)
        },
      );

    case MapType.citymapper:
      return Utils.buildUrl(url: 'citymapper://directions', queryParams: {
        'endcoord': '${destination.latitude},${destination.longitude}',
        'endname': destinationTitle,
        'startcoord': Utils.nullOrValue(
          origin,
          '${origin?.latitude},${origin?.longitude}',
        ),
        'startname': originTitle,
      });

    case MapType.osmand:
      if (Platform.isIOS) {
        return Utils.buildUrl(
          url: 'osmandmaps://navigate',
          queryParams: {
            'lat': '${destination.latitude}',
            'lon': '${destination.longitude}',
            'title': destinationTitle,
          },
        );
      }
      return 'osmand.navigation:q=${destination.latitude},${destination.longitude}';

    case MapType.mapswithme:
      // Couldn't get //route to work properly as of 2020/07
      // so just using the marker method for now
      // return Utils.buildUrl(
      //   url: 'mapsme://route',
      //   queryParams: {
      //     'dll': '${destination.latitude},${destination.longitude}',
      //     'daddr': destinationTitle,
      //     'sll': Utils.nullOrValue(
      //       origin,
      //       '${origin?.latitude},${origin?.longitude}',
      //     ),
      //     'saddr': originTitle,
      //     'type': Utils.getMapsMeDirectionsMode(directionsMode),
      //   },
      // );
      return Utils.buildUrl(
        url: 'mapsme://map',
        queryParams: {
          'v': '1',
          'll': '${destination.latitude},${destination.longitude}',
          'n': destinationTitle
        },
      );

    case MapType.yandexMaps:
      return Utils.buildUrl(
        url: 'yandexmaps://maps.yandex.com/',
        queryParams: {
          'rtext':
              '${origin?.latitude},${origin?.longitude}~${destination.latitude},${destination.longitude}',
          'rtt': Utils.getYandexMapsDirectionsMode(directionsMode),
        },
      );

    case MapType.yandexNavi:
      return Utils.buildUrl(
        url: 'yandexnavi://build_route_on_map',
        queryParams: {
          'lat_to': '${destination.latitude}',
          'lon_to': '${destination.longitude}',
          'lat_from': Utils.nullOrValue(origin, '${origin?.latitude}'),
          'lon_from': Utils.nullOrValue(origin, '${origin?.longitude}'),
        },
      );

    case MapType.doubleGis:
      return Utils.buildUrl(
        url:
            'dgis://2gis.ru/routeSearch/rsType/${Utils.getDoubleGisDirectionsMode(directionsMode)}/${origin == null ? '' : 'from/${origin.longitude},${origin.latitude}/'}to/${destination.longitude},${destination.latitude}',
        queryParams: {},
      );

    default:
      return null;
  }
}
