/// A subsystem for reading data passed from the FavoritePlaceRepository
/// needed to generate a list of user's favorite geographic places.
class FavoritePlaceListItem
{
  final String _id;
  final String _name;
  final String _address;

  FavoritePlaceListItem({required String id, required String name, required String address}) : _id = id, _name = name, _address = address;

  /// Returns geographic place's identifier
  String getId() => _id;

  /// Returns geographic place's name
  String getName() => _name;

  /// Returns geographic place's address
  String getAddress() => _address;
}
