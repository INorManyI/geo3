// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:shared_preferences/shared_preferences.dart';

/// A subsystem for interacting with stored data
/// on identifiers of user's favorite geographic places.
class FavoritePlacesIdentifiersRepository
{
  static SharedPreferences? _identifiers;
  static const String key = 'favoritePlaces';

  /// Initializes the [FavoritePlacesIdentifiersRepository]
  Future<void> init() async
  {
    _identifiers = _identifiers ?? (await SharedPreferences.getInstance());
  }

  void _setIdentifiers(List<String> favoriteFoodsIds)
  {
    _identifiers!.setStringList(key, favoriteFoodsIds);
  }

  List<String> _getIdentifiers()
  {
    return _identifiers!.getStringList(key) ?? [];
  }

  /// Adds a place to the user's list of favorite geographic places.
  ///
  /// If place is already in the list, nothing will happen.
  void add(String placeId)
  {
    if (_identifiers == null)
      throw Exception('FavoritePlacesIdentifiersRepository not initialized. Please call init procedure before any interaction attempt.');

    List<String> favoritePlacesIds = _getIdentifiers();
    if (favoritePlacesIds.contains(placeId))
      return;

    favoritePlacesIds.insert(0, placeId);
    _setIdentifiers(favoritePlacesIds);
  }

  /// Removes a place from the user's list of favorite geographic places.
  ///
  /// If place not in the list, nothing will happen
  void remove(String placeId)
  {
    if (_identifiers == null)
      throw Exception('FavoritePlacesIdentifiersRepository not initialized. Please call init procedure before any interaction attempt.');

    List<String> favoritePlacesIds = _getIdentifiers();
    bool wasRemoved = favoritePlacesIds.remove(placeId);

    if (wasRemoved)
      _setIdentifiers(favoritePlacesIds);
  }

  /// Checks if a place is in the user's list of favorite geographic places
  bool has(String placeId)
  {
    if (_identifiers == null)
      throw Exception('FavoritePlacesIdentifiersRepository not initialized. Please call init procedure before any interaction attempt.');

    return _getIdentifiers().contains(placeId);
  }

  /// Retrieves identifiers of user's favorite geographic places
  List<String> getAll()
  {
    if (_identifiers == null)
      throw Exception('FavoritePlacesIdentifiersRepository not initialized. Please call init procedure before any interaction attempt.');

    return _getIdentifiers();
  }
}
