import 'package:flutter/material.dart';
import '../scope_model/main_model.dart';
import '../widget/primary_button.dart';
import '../model/product.dart';

class ProductDetail extends StatelessWidget {
  final String type;
  final int index;

  ProductDetail(this.type, this.index);
  

  @override
  Widget build(BuildContext context) {

    final model = MainModel.of(context, true);
    Product _product = model.products[type][index];

    Widget _title(String title, double size) {
      return Container(
          margin: EdgeInsets.only(
            top: 310,
            left: 30,
          ),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
                color: Colors.white,
                fontSize: size,
                // fontWeight: FontWeight.bold,
                letterSpacing: 2),
          ));
    }

    Widget _content(String content, double size) {
      return Container(
          child: Text(
        content,
        style: TextStyle(fontSize: size),
      ));
    }

    final double deviceWidth = MediaQuery.of(context).size.width;

    Widget _imageWithTitle() {
      return Stack(
        children: <Widget>[
          _product.image is String ?
          Image.asset(
            _product.image,
            height: 380,
            width: deviceWidth,
            fit: BoxFit.cover,
          ) : Image.file(
            _product.image,
            height: 380,
            width: deviceWidth,
            fit: BoxFit.cover,
          ),
          Container(
              height: 380,
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                end: Alignment.topCenter,
                begin: Alignment.bottomCenter,
                colors: [Colors.black.withOpacity(0.4), Colors.transparent],
              ))),
          _title(_product.title, 28),
        ],
      );
    }

    Widget appBar() {
      return Positioned(
          left: 0.0,
          right: 0.0,
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.black.withOpacity(0),
          ));
    }

    return Scaffold(
        body: Stack(
      children: <Widget>[
        ListView(
          children: <Widget>[
            _imageWithTitle(),
            Container(
              margin: EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _content(_product.description, 16),
                  SizedBox(height: 20,),
                  _content('RM ${_product.price.toStringAsFixed(2)}', 26),
                ],
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: model.user.isAdmin ? SizedBox() : PrimaryButton('add to cart', () {
                  model.addToCart(_product);
                  Navigator.pop(context);
                }))
          ],
        ),
        appBar()
      ],
    ));
  }
}
