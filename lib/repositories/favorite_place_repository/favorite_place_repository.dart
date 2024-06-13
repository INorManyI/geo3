// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import '../../config.dart';
import 'package:http/http.dart' as http;
import 'favorite_places_identifiers_repository.dart';
import 'DTO/favorite_place_list_item.dart';
import 'errors/get_all_favorite_places_errors.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// A subsystem for interacting with stored data
/// on user's favorite geographic places.
class FavoritePlaceRepository
{
  final _favoritePlaceIdentifiers = FavoritePlacesIdentifiersRepository();
  final List<FavoritePlaceListItem> _favoritePlacesCache = [];

  /// Initializes the [FavoritePlaceRepository]
  Future<void> init() async
  {
    await _favoritePlaceIdentifiers.init();
  }

  /// Adds a place to the user's list of favorite geographic places.
  ///
  /// If place is already in the list, nothing will happen.
  void add(String placeId)
  {
    _favoritePlaceIdentifiers.add(placeId);
  }

  /// Removes a place from the user's list of favorite geographic places.
  ///
  /// If place not in the list, nothing will happen
  void remove(String placeId)
  {
    _favoritePlaceIdentifiers.remove(placeId);
  }

  /// Checks if a place is in the user's list of favorite geographic places
  bool has(String placeId)
  {
    return _favoritePlaceIdentifiers.has(placeId);
  }



  FavoritePlaceListItem? _getFromCache(String favoritePlaceId)
  {
    for (final favoritePlace in _favoritePlacesCache)
    {
      if (favoritePlace.getId() == favoritePlaceId)
        return favoritePlace;
    }

    return null;
  }

  void _addToCache(FavoritePlaceListItem place)
  {
    _favoritePlacesCache.add(place);
  }

  /// Checks if device is connected to the internet
  Future<bool> _isConnectedToInternet() async
  {
      return await InternetConnection().hasInternetAccess;
  }

  Future<FavoritePlaceListItem?>
  _getFromApi(String favoritePlaceId, GetAllFavoritePlacesErrors errors) async
  {
    // Get place's data from API
    String key = Config.API_KEY_2GIS;
    Uri uri = Uri.parse('https://catalog.api.2gis.com/3.0/items/byid?id=$favoritePlaceId&key=$key');
    http.Response response = await http.get(uri);

    if (response.statusCode != 200)
    {
      errors.add(errors.INTERNAL);
      return null;
    }

    Map<String, dynamic>? data = jsonDecode(response.body)['result']?['items'][0];
    if (data == null)
      return null;

    return FavoritePlaceListItem(
      id: data['id'],
      name: data['name'],
      address: data['address_name'],
    );
  }

  /// Retrieves a list of user's favorite foods.
  ///
  /// Returns an empty list if error was encountered.
  Future<List<FavoritePlaceListItem>> getAll(GetAllFavoritePlacesErrors errors) async
  {
    List<FavoritePlaceListItem> result = [];
    for (String favoritePlaceId in _favoritePlaceIdentifiers.getAll())
    {
      FavoritePlaceListItem? favoritePlace = _getFromCache(favoritePlaceId);
      if (favoritePlace != null)
      {
        result.add(favoritePlace);
        continue;
      }

      if (! (await _isConnectedToInternet()))
      {
        errors.add(errors.INTERNET_CONNECTION_MISSING);
        continue;
      }

      favoritePlace = await _getFromApi(favoritePlaceId, errors);
      if (favoritePlace != null)
      {
        _addToCache(favoritePlace);
        result.add(favoritePlace);
      }
    }

    return result;
  }
}
