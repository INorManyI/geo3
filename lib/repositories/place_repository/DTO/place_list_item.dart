/// A subsystem for reading data from the PlaceRepository
/// needed to generate a list of geographic places
class PlaceListItem
{
  final String _id;
  final String _name;
  final String _address;

  PlaceListItem({required String id, required String name, required String address}) : _id = id, _name = name, _address = address;

  /// Returns geographic place's identifier
  String getId() => _id;

  /// Returns geographic place's name
  String getName() => _name;

  /// Returns geographic place's address
  String getAddress() => _address;
}
