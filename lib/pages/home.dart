import 'package:flutter/material.dart';
import '../scope_model/main_model.dart';
import './products.dart';
import './orders.dart';
import './edit.dart';
import './listing.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  void onTabTapped(int index, model) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1 && model.selectedIndex != null) {
      model.select(null, null);
    }
  }

  List<BottomNavigationBarItem> barItems(user, cart, total) {
    if (user.isAdmin) {
      return [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_on),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.loupe),
            title: Text('Create')),
        BottomNavigationBarItem(
            icon: Icon(Icons.details), title: Text('Manage')),
      ];
    } else {
      return [
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_on),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
            icon: Stack(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 12, top: 7),
                  child: Icon(Icons.loupe)),
              cart.length > 0 ? Positioned(
                top: 0.0,
                right: 0.0,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    total.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ) : SizedBox()
            ]),
            title: Text('Orders')),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = MainModel.of(context, true);
    final List<Widget> _children = model.user.isAdmin
        ? [Products(), Edit(), Listing()]
        : [Products(), Orders()];

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) => onTabTapped(index, model),
        items: barItems(model.user, model.user.cart, model.cartAmount()),
      ),
      body: _children[_currentIndex],
    );
  }
}
