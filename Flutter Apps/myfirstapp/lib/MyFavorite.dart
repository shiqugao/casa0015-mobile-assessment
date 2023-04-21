import 'package:flutter/material.dart';

class MyFavorite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Moive1 search',
      theme: new ThemeData(
        primaryColor: new Color(0xFF0F2533),
      ),
      routes: {
        //'/': (BuildContext context) => new MovieSearch(),
        //'/search_material': (BuildContext context) => new MovieSearch(),
        // '/search_formal': (BuildContext context) => new SearchBookPageNew(),
        // '/collection': (BuildContext context) => new CollectionPage(),
        // '/stamp_collection_material': (BuildContext context) => new StampCollectionPage(),
        // '/stamp_collection_formal': (BuildContext context) => new StampCollectionFormalPage(),
      },
    );
  }
}