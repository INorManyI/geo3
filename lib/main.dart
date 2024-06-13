// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lab_geo_3/UI/favorite_places_page/favorite_places_page.dart';

import 'UI/places_page/places_page.dart';

class GeoApp extends StatefulWidget
{
  const GeoApp({super.key});

  @override
  GeoAppState createState() => GeoAppState();
}

class GeoAppState extends State<GeoApp>
{
  int currentIndex = 0;

  @override
  Widget build(BuildContext context)
  {
    void onNavigationBarLinkTapped(int index) async
    {
      setState(() {
        currentIndex = index;
      });
    }

    return MaterialApp(
        title: 'Справочник',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.light(
                onSurface: Colors.white,
                onBackground: Color.fromARGB(255, 127, 0, 212),
            ),
            textTheme: GoogleFonts.manropeTextTheme(
              const TextTheme(
                bodyMedium: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                bodySmall: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                bodyLarge: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                )
              )
            ),
            appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 145, 0, 212),
                titleTextStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                ),
                centerTitle: true,
            ),
        ),
        home: Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: const [
              PlacesPage(),
              FavoritePlacesPage()
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onNavigationBarLinkTapped,
            selectedItemColor: const Color.fromARGB(255, 109, 0, 212),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Главная',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Избранное',
              ),
            ],
          ),
        )
    );
  }
}

void main() async
{
  GeoApp app = const GeoApp();
  runApp(app);
}
