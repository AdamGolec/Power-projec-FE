import 'dart:convert';
import 'package:http/http.dart' as http;

fetchInitialRoute(startPoint, endPoint) async {
  const apiKey = '5b3ce3597851110001cf62489513c460675e42199a86c0f6d7133d72';

  return await http.get(Uri.parse(
      'https://api.openrouteservice.org/v2/directions/foot-hiking?api_key=$apiKey&start=${startPoint[0]},${startPoint[1]}&end=${endPoint[0]},${endPoint[1]}'));
}

fetchRoutePOIData(List coordinates, int buffer, int markerLimit,
    List categoryGroupIds, List categoryIds) async {
  const apiKey = '5b3ce3597851110001cf62489513c460675e42199a86c0f6d7133d72';
  return await http.post(
    Uri.parse('https://api.openrouteservice.org/pois'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': apiKey,
    },
    body: jsonEncode({
      "request": "pois",
      "geometry": {
        "geojson": {"type": "LineString", "coordinates": coordinates},
        "buffer": buffer
      },
      "limit": markerLimit,
      "filters": {
        "category_group_ids": categoryGroupIds,
        "category_ids": categoryIds
      },
    }),
  );
}

fetchRoute(List coordinates) async {
  //coordinates structure: [[lng,lat],[lng,lat]...]

  const apiKey = '5b3ce3597851110001cf62489513c460675e42199a86c0f6d7133d72';
  return await http.post(
      Uri.parse('https://api.openrouteservice.org/v2/directions/foot-hiking'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': apiKey,
      },
      body: jsonEncode({
        "coordinates": coordinates,
        "preference": "fastest",
      }));
}

fetchIsochroneBoundary(positionCoordinate) async {
  const apiKey = '5b3ce3597851110001cf62489513c460675e42199a86c0f6d7133d72';

  return await http.post(
      Uri.parse('https://api.openrouteservice.org/v2/isochrones/foot-hiking'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': apiKey,
      },
      body: jsonEncode({
        "locations": [
          [positionCoordinate[1], positionCoordinate[0]]
        ],
        "range_type": "time",
        "range": [600],
      }));
}

fetchIsochronePOIData(isochroneGeoJson, markerLimit, categoryIds) async {
  const apiKey = '5b3ce3597851110001cf62489513c460675e42199a86c0f6d7133d72';

  return await http.post(
    Uri.parse('https://api.openrouteservice.org/pois'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': apiKey,
    },
    body: jsonEncode({
      "request": "pois",
      "geometry": {
        "geojson": {
          "type": "Polygon",
          "coordinates": json.decode(isochroneGeoJson.body)["features"][0]
              ["geometry"]["coordinates"]
        },
        "buffer": 200
      },
      "limit": markerLimit,
      "filters": {
        "category_group_ids": categoryIds,
      }
    }),
  );
}
