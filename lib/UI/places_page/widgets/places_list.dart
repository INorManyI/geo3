import 'package:flutter/material.dart';
import 'package:lab_geo_3/UI/place_details_page/place_details_page.dart';

import '../../../repositories/place_repository/DTO/place_list_item.dart';

/// A subsystem for displaying "List of foods" widget of "Foods" page to the user.
class PlacesListWidget extends StatelessWidget
{
  final List<PlaceListItem> placesList;

  const PlacesListWidget({super.key, required this.placesList});

  @override
  Widget build(BuildContext context)
  {
    return Container(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0)
            ),
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
                itemCount: placesList.length,
                itemBuilder: (BuildContext context, int index)
                {
                  PlaceListItem place = placesList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(
                        place.getName(),
                        style: const TextStyle(color: Colors.black),
                      ),
                      subtitle: Text(
                        place.getAddress(),
                        style: const TextStyle(color: Colors.black),
                      ),
                      onTap: ()
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaceDetailsPage(placeId: place.getId())
                          ),
                        );
                      },
                    ),
                  );
                },
                  ),
          ),
    );
  }
}
