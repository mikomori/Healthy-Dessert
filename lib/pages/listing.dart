import 'package:flutter/material.dart';
import '../scope_model/main_model.dart';
import '../model/product.dart';

class Listing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = MainModel.of(context, true);
    final double deviceWidth = MediaQuery.of(context).size.width;

    _showWarningDialog(BuildContext context, product) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content: Text('This action cannot be undone.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('CANCEL', style:TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('DELETE', style:TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                  onPressed: () {
                    model.removeProduct(product, true);
                    Navigator.pop(context); 
                  },
                )
              ],
            );
          });
    }

    Widget _listItem(product, index) {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(right: 20, left: 5, bottom: 7),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: product.image is String ? AssetImage(product.image) :FileImage(product.image),
                )),
            Container(
                width: deviceWidth * 0.4,
                child: Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                )),
          ],
        ),
        Row(children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.grey[700],),
            onPressed: () {
              model.select(index, product.type);
              Navigator.pushNamed(context, '/edit');
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.grey[700]),
            onPressed: () {
              _showWarningDialog(context, product);
            },
          )
        ]),
      ]);
    }

    Widget _listing(type) {
      List products = model.products[type];
      return products.length > 0
          ? ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                Product product = products[index];
                return _listItem(product, index);
              },
              itemCount: products.length,
            )
          : Container(
              margin: EdgeInsets.only(left: 7),
              child: Text('None'),
            );
    }

    Widget _title(String title, double size) {
    return Text(
        title,
        style: TextStyle(
            color: Colors.grey[600],
            fontSize: size,
            fontWeight: FontWeight.bold,
            letterSpacing: 2),
      );
  }

    Widget _subtitle(String title, double size) {
      return Container(
          decoration: BoxDecoration(
              border: Border(
                  )),
          margin: EdgeInsets.only(bottom: 15, top: 30),
          padding: EdgeInsets.only(bottom: 7, left: 2),
          child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
                fontSize: size,
                letterSpacing: 2),
          ));
    }

    return Container(
        margin: EdgeInsets.only(top: 40, left: 15, right: 10),
        child: ListView(
          children: [
            _title('Dessert List'.toUpperCase(), 24),
            _subtitle('Daily Special', 16),
            _listing('special'),
            _subtitle('Cookies', 16),
            _listing('cookies'),
            _subtitle('Breads', 16),
            _listing('breads'),
            _subtitle('Cakes', 16),
            _listing('cakes'),
            SizedBox(height: 30,),
            Container(
              margin:EdgeInsets.all(2),
              child: OutlineButton(
              borderSide: BorderSide(color: Colors.grey[600]),
              child: Text('Log Out', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.grey[600])), onPressed: (){
              Navigator.pushReplacementNamed(context, '/auth');
            },)),
            SizedBox(height: 20,),

          ],
        ));
  }
}
