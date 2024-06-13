// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:lab_geo_3/repositories/favorite_place_repository/DTO/favorite_place_list_item.dart';
import 'package:lab_geo_3/repositories/favorite_place_repository/errors/get_all_favorite_places_errors.dart';
import 'package:lab_geo_3/repositories/favorite_place_repository/favorite_place_repository.dart';

import 'widgets/places_list_widget.dart';

class FavoritePlacesPage extends StatefulWidget
{
  const FavoritePlacesPage({super.key});

  @override
  FavoritePlacesPageState createState() => FavoritePlacesPageState();
}

class FavoritePlacesPageState extends State<FavoritePlacesPage>
{
  List<FavoritePlaceListItem> _placesList = [];
  final _favoritePlaces = FavoritePlaceRepository();

  void showErrorMessage(String message)
  {
      final snackBar = SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _updateFoodList() async
  {
      await _favoritePlaces.init();

      final errors = GetAllFavoritePlacesErrors();
      final placeList = await _favoritePlaces.getAll(errors);
      if (errors.hasAny())
      {
        if (errors.isInternetConnectionMissing())
          showErrorMessage('Отсутствует интернет-соединение');
        if (errors.isInternalErrorOccurred())
          showErrorMessage('В приложении произошла критическая ошибка. Разработчики уже были оповещены.');
        return;
      }
      setState(() {
        _placesList = placeList;
      });
  }

  @override
  Widget build(BuildContext context)
  {
    _updateFoodList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),

      body: PlacesListWidget(placesList: _placesList)
    );
  }
}
