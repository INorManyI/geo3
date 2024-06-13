// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import '../../repositories/favorite_place_repository/favorite_place_repository.dart';
import '../../repositories/place_repository/DTO/place.dart';
import '../../repositories/place_repository/errors/get_place_errors.dart';
import '../../repositories/place_repository/place_repository.dart';
import 'widgets/place_main_info_widget.dart';

class PlaceDetailsPage extends StatefulWidget
{
  final String placeId;

  const PlaceDetailsPage({super.key, required this.placeId});

  @override
  PlaceDetailsPageState createState() => PlaceDetailsPageState();
}

class PlaceDetailsPageState extends State<PlaceDetailsPage>
{
  Place? _place;
  late FavoritePlaceRepository _favoritePlaces;
  bool _isPlaceFavorite = false;

  void showErrorMessage(String message)
  {
      final snackBar = SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _initPlaceDetails() async
  {
    final places = PlaceRepository();
    final errors = GetPlaceErrors();

    final place = await places.get(widget.placeId, errors);

    if (errors.hasAny())
    {
      if (errors.isInternetConnectionMissing())
        showErrorMessage('Отсутствует интернет-соединение');
      if (errors.isInternalErrorOccurred())
        showErrorMessage('В приложении произошла критическая ошибка. Разработчики уже были оповещены.');

      return;
    }

    setState(() {
      _place = place;
    });
  }

  /// Reverses place's "favorite" status.
  ///
  /// If place is in the "favorite" list then it will be removed from it.
  /// Otherwise it will be added to it.
  void _togglePlaceFavoriteStatus()
  {
    if (_isPlaceFavorite)
      _favoritePlaces.remove(widget.placeId);
    else
      _favoritePlaces.add(widget.placeId);

    setState(() {
      _isPlaceFavorite = ! _isPlaceFavorite;
    });
  }

  @override
  void initState()
  {
    super.initState();
    _initPlaceDetails();

    () async {
      final favoritePlaces = FavoritePlaceRepository();
      await favoritePlaces.init();
      setState(() {
        _favoritePlaces = favoritePlaces;
        _isPlaceFavorite = _favoritePlaces.has(widget.placeId);
      });
    }();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(_place?.getName() ?? ''),
        actions: [
          IconButton(
            icon: Icon(
              _isPlaceFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isPlaceFavorite ? Colors.amber : Colors.white,
            ),
            onPressed: _togglePlaceFavoriteStatus,
          )
        ],
      ),

      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10)
              ),
              padding: const EdgeInsets.all(16.0),

              child: _place == null
               ? const Center(child: CircularProgressIndicator())
               : SingleChildScrollView(child: PlaceMainInfoWidget(_place!))
            ),
          )
        ],
      ),
    );
  }
}
