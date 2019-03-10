import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'scope_model/main_model.dart';
import './pages/auth.dart';
import './pages/home.dart';
import './pages/product_detail.dart';
import './pages/edit.dart';
import './pages/listing.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: MainModel(),
      child: MaterialApp(
      theme: ThemeData(
        fontFamily: 'JosefinSans',
        primarySwatch: Colors.pink,
        // primaryColor: Colors.white,
        accentColor: Colors.pink,
        // primaryTextTheme: TextTheme(title: TextStyle(color: Colors.grey[600])),
        // iconTheme: IconThemeData(color: Colors.grey[600]),
      ),
      home: Auth(),
      routes: {
        '/home': (BuildContext context) => Home(),
        '/listing': (BuildContext context) => Listing(),
        '/edit': (BuildContext context) => Edit(),
        '/auth': (BuildContext context) => Auth(),
      },
      onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            List types = ['special', 'cookies', 'breads', 'cakes'];
            if (types.contains(pathElements[1])) {
              final int index = int.parse(pathElements[2]);
              return MaterialPageRoute(
                  builder: (BuildContext context) => ProductDetail(pathElements[1], index));
            }
          },
      debugShowCheckedModeBanner: false,
    ));
  }
}
