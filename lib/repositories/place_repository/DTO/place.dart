import '../../enums/place_type.dart';

/// A subsystem for reading data about geographic place
/// passed from the PlaceRepository.
class Place
{
  final String _id;
  final String _name;
  final String _address;
  final PlaceType _type;
  final String? _purpose;

  Place({required String id, required String name, required String address, required PlaceType type, required String? purpose}) : _id = id, _name = name, _address = address, _type = type, _purpose = purpose;

  /// Returns geographic place's identifier
  String getId() => _id;

  /// Returns geographic place's name
  String getName() => _name;

  /// Returns geographic place's address
  String getAddress() => _address;

  /// Returns geographic place's type
  PlaceType getType() => _type;

  /// Returns geographic place's purpose
  String? getPurpose() => _purpose;
}
