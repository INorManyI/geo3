import '../../enums/place_type.dart';

/// A subsystem for passing data into method "find" of PlaceRepository.
class FindPlaceViewModel
{
  final String query;
  final String city;
  final List<PlaceType> placeTypes;

  FindPlaceViewModel({required this.query, required this.city, required this.placeTypes});
}
