// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'DTO/place.dart';
import '../enums/place_type.dart';
import 'DTO/place_list_item.dart';
import 'errors/get_place_errors.dart';
import 'errors/find_place_errors.dart';
import 'package:lab_geo_3/config.dart';
import 'package:http/http.dart' as http;
import 'view_models/find_place_view_model.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// A subsystem for interacting with stored data on geographic places.
class PlaceRepository
{
  /// Checks if device is connected to the internet
  Future<bool> _isConnectedToInternet() async
  {
      return await InternetConnection().hasInternetAccess;
  }

  /// Converts the [string] from 2gis Http-response to [PlaceType]
  ///
  /// Returns `null` if appropriate [PlaceType] not exists
  PlaceType? _getPlaceTypeFromApiString(String s)
  {
    switch (s)
    {
      case 'branch':
        return PlaceType.branch;
      case 'building':
        return PlaceType.building;
      case 'street':
        return PlaceType.street;
      case 'attraction':
        return PlaceType.attraction;
      default:
        return null;
    }
  }

  Place? _convertApiDataToPlace(http.Response response)
  {
    Map<String, dynamic>? data = jsonDecode(response.body)['result']?['items'][0];

    if (data == null)
      return null;

    return Place(
      id: data['id'],
      name: data['name'],
      address: data['address_name'],
      purpose: data['purpose_name'],
      type: _getPlaceTypeFromApiString(data['type']) ?? PlaceType.branch,
    );
  }

  Future<Place?> _getFromApi(String id, GetPlaceErrors errors) async
  {
    // Get place's data from API
    String key = Config.API_KEY_2GIS;
    Uri uri = Uri.parse('https://catalog.api.2gis.com/3.0/items/byid?id=$id&key=$key');
    http.Response response = await http.get(uri);

    if (response.statusCode != 200)
    {
      errors.add(errors.INTERNAL);
      return null;
    }

    return _convertApiDataToPlace(response);
  }

  /// Retrieves information about geographic place.
  ///
  /// Returns `null` if error occurred or geographic place not exists.
  Future<Place?> get(String id, GetPlaceErrors errors) async
  {
    if (! (await _isConnectedToInternet()))
    {
      errors.add(errors.INTERNET_CONNECTION_MISSING);
      return null;
    }

    return _getFromApi(id, errors);
  }


  String _convertPlaceTypesToString(List<PlaceType> placeTypes)
  {
    List<String> result = [];

    // Here bugs can happen (don't care)
    for (PlaceType placeType in placeTypes)
      result.add(placeType.name);

    return result.join(',');
  }

  PlaceListItem _convertApiDataToPlaceListItem(Map<String, dynamic> placeData)
  {
    return PlaceListItem(
      id: placeData['id'],
      name: placeData['name'],
      address: placeData['address_name'] ?? '',
    );
  }

  List<PlaceListItem> _convertApiDataToPlacesList(http.Response response)
  {
    List<PlaceListItem> result = [];
    List? placesData = jsonDecode(response.body)['result']?['items'];

    if (placesData == null)
      return [];

    for (Map<String, dynamic> placeData in placesData)
    {
      // Skip if PlaceType not exists
      PlaceType? type = _getPlaceTypeFromApiString(placeData['type']);
      if (type == null)
        continue;

      result.add(_convertApiDataToPlaceListItem(placeData));
    }

    return result;
  }


  Future<List<PlaceListItem>> _findFromApi(FindPlaceViewModel search, FindPlaceErrors errors) async
  {
    // Generating URL
    String placeTypes = _convertPlaceTypesToString(search.placeTypes);
    String url = 'https://catalog.api.2gis.com/3.0/items?q=${'${search.query} ${search.city}'}';
    if (placeTypes.isNotEmpty)
      url += '&type=$placeTypes';
    url += '&locale=ru_RU&key=${Config.API_KEY_2GIS}';

    // Fetching places array from API
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode != 200)
    {
      errors.add(errors.INTERNAL);
      return [];
    }

    return _convertApiDataToPlacesList(response);
  }

  /// Retrieves a list of relevant geographic places
  ///
  /// Returns an empty list if error occurred.
  Future<List<PlaceListItem>> find(FindPlaceViewModel search, FindPlaceErrors errors) async
  {
    if (! (await _isConnectedToInternet()))
    {
      errors.add(errors.INTERNET_CONNECTION_MISSING);
      return [];
    }
    return _findFromApi(search, errors);
  }
}
