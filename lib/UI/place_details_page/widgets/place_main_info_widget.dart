import 'package:flutter/material.dart';

import '../../../repositories/place_repository/DTO/place.dart';
import '../../localization/place_type_localization.dart';

/// A subsystem for displaying widget with general information about food
/// on the "Place details" page for the user.
class PlaceMainInfoWidget extends StatelessWidget
{
  final Place _place;

  const PlaceMainInfoWidget(this._place, {super.key});

  @override
  Widget build(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Адрес: ${_place.getAddress()}.'),
            const SizedBox(height: 10),
            Text('Категория: ${PlaceTypeLocalization.localize(_place.getType())}.'),
            const SizedBox(height: 10),
            if (_place.getPurpose() != null)
              Text('Назначение: ${_place.getPurpose()}.'),
          ],
        )
      ],
    );
  }
}
