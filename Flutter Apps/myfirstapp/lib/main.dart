import 'package:flutter/material.dart';
import 'SearchMoviePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
//import 'test1.dart';

// void main() => runApp(new MyApp());
//

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        title: 'Moive search',
        theme: new ThemeData(
          primaryColor: new Color(0xFF0F2533),
        ),
        routes: {
          '/': (BuildContext context) => new MovieSearch(),
          //'/search_material': (BuildContext context) => new MovieSearch(),
          // '/search_formal': (BuildContext context) => new SearchBookPageNew(),
          // '/collection': (BuildContext context) => new CollectionPage(),
          // '/stamp_collection_material': (BuildContext context) => new StampCollectionPage(),
          // '/stamp_collection_formal': (BuildContext context) => new StampCollectionFormalPage(),
        },
      );
  }
}






