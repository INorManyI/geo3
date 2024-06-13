// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import '../../repositories/enums/place_type.dart';
import '../../repositories/place_repository/DTO/place_list_item.dart';
import '../../repositories/place_repository/errors/find_place_errors.dart';
import '../../repositories/place_repository/place_repository.dart';
import '../../repositories/place_repository/view_models/find_place_view_model.dart';
import '../localization/place_type_localization.dart';
import 'widgets/places_list.dart';

enum LoadingStatus
{
  loading,
  notLoading,
  failed
}

class PlacesPage extends StatefulWidget
{
  const PlacesPage({super.key});

  @override
  PlacesPageState createState() => PlacesPageState();
}

class PlacesPageState extends State<PlacesPage>
{
  String _searchQuery = '';
  String _searchCity = '';
  final List<PlaceType> _selectedPlaceTypes = [];
  List<PlaceListItem>? _placesList = [];
  LoadingStatus _loadingStatus = LoadingStatus.notLoading;

  void showErrorMessage(String message)
  {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _performSearch() async
  {
    final places = PlaceRepository();
    final errors = FindPlaceErrors();

    setState(() {
      _loadingStatus = LoadingStatus.loading;
    });
    FindPlaceViewModel search = FindPlaceViewModel(
      query: _searchQuery,
      city: _searchCity,
      placeTypes: _selectedPlaceTypes
    );
    final placesList = await places.find(search, errors);

    if (errors.hasAny())
    {
      setState(() {
        _loadingStatus = LoadingStatus.failed;
      });

      if (errors.isInternetConnectionMissing())
        showErrorMessage('Отсутствует интернет-соединение');
      if (errors.isInternalErrorOccurred())
        showErrorMessage('В приложении произошла критическая ошибка. Разработчики уже были оповещены.');

      return;
    }

    setState(() {
      _loadingStatus = LoadingStatus.notLoading;
      _placesList = placesList;
    });
  }

  Widget _getBody()
  {
    switch (_loadingStatus)
    {
      case LoadingStatus.loading:
        return const Center(child: CircularProgressIndicator());

      case LoadingStatus.failed:
        return const Center(child: Text('Произошла ошибка'));

      case LoadingStatus.notLoading:
        if (_placesList!.isNotEmpty)
          return PlacesListWidget(placesList: _placesList!);

        if (_searchQuery.isEmpty)
          return const Center(child: Text('Начните искать места'));
        else
          return const Center(child: Text('Ничего не было найдено'));
    }
  }

  void _showSearchDialog() async
  {
    var query = await showDialog<String>(
      context: context,
      builder: (BuildContext context)
      {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState)
          {
            return AlertDialog(
              surfaceTintColor: Colors.cyan,
              shadowColor: Colors.cyan,
              iconColor: Colors.cyan,
              title: const Text(
                'Поиск',
                style: TextStyle(
                  color: Colors.black
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value)
                    {
                      _searchQuery = value;
                    },
                    decoration: const InputDecoration(hintText: 'Поиск:'),
                  ),
                  TextField(
                    onChanged: (value)
                    {
                      _searchCity = value;
                    },
                    decoration: const InputDecoration(hintText: 'Город:'),
                  ),
                  SizedBox(
                    height: 170.0, // give it a specific height
                    child: SingleChildScrollView(
                      child: Wrap(
                        children: PlaceType.values.map((PlaceType type)
                        {
                          final titleStr = PlaceTypeLocalization.localize(type);
                          return CheckboxListTile(
                            title: Text(
                              titleStr,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14
                              ),
                            ),
                            value: _selectedPlaceTypes.contains(type),
                            onChanged: (value)
                            {
                              setState(()
                              {
                                if (value!)
                                  _selectedPlaceTypes.add(type);
                                else
                                  _selectedPlaceTypes.remove(type);
                              });
                            }
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: ()
                  {
                    Navigator.pop(context);
                  },
                  child: const Text('Отмена'),
                ),
                TextButton(
                  onPressed: ()
                  {
                    _performSearch();
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          }
        );
      },
    );
    if (query != null) {
      setState(() {
        _searchQuery = query;
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Места'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          )
        ],
      ),
      body: _getBody()
    );
  }
}
