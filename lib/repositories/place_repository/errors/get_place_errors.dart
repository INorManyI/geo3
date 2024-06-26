// ignore_for_file: non_constant_identifier_names

import '../../../errors.dart';

/// A subsystem for reading errors
/// that may occur during an attempt
/// to retrieve information about geographic place
/// from PlaceRepository
class GetPlaceErrors extends Errors
{
  final int INTERNET_CONNECTION_MISSING = 1;
  final int INTERNAL = 1 << 1;

  /// Checks if ocurred an error because the internet connection is missing
  bool isInternetConnectionMissing()
  {
    return has(INTERNET_CONNECTION_MISSING);
  }

  /// Checks if ocurred an internal error
  bool isInternalErrorOccurred()
  {
    return has(INTERNAL);
  }
}
