import 'package:flutter/material.dart';
import '../model/product.dart';
import '../scope_model/main_model.dart';

class Products extends StatefulWidget {
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  String _search = '';
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final model = MainModel.of(context, true);

    Widget _productInfo(Product product, double height, width, int index) {
      return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/${product.type}/$index');
          },
          child: Container(
              width: width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: <Widget>[
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image(
                              image: product.image is String
                                  ? AssetImage(product.image)
                                  : FileImage(product.image),
                              height: height,
                              width: width,
                              fit: BoxFit.cover,
                            )),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 250,
                              alignment: Alignment.bottomRight,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3)
                                ],
                              )),
                            )),
                      ],
                    ),
                    Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 190,
                                      padding: EdgeInsets.only(left: 2, top: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            product.title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                letterSpacing: 1),
                                          ),
                                          Text(
                                            'RM ${product.price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                                fontSize: 20, height: 1.5),
                                          ),
                                        ],
                                      )),
                                  model.user.isAdmin
                                      ? SizedBox()
                                      : IconButton(
                                          color: Colors.grey[700],
                                          icon: Icon(Icons.add_shopping_cart),
                                          onPressed: () {
                                            model.addToCart(product);
                                          },
                                        ),
                                ]),
                          ],
                        ))
                  ])));
    }

    Widget _horizontalListItem(List products) {
      return products.length > 0
          ? Container(
              height: 330,
              padding: EdgeInsets.only(left: deviceWidth / 15, top: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      margin: EdgeInsets.only(right: deviceWidth / 30),
                      width: 250,
                      child:
                          _productInfo(products[index], 250.0, 250.0, index));
                },
                itemCount: products.length,
              ))
          : Container(
              margin: EdgeInsets.only(left: 30),
              child: Text('NONE',
                  style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500])));
    }

    Widget _specialItem(product) {
      return product == null
          ? Container(
              margin: EdgeInsets.only(left: 30, top: 10),
              child: Text('NONE',
                  style: TextStyle(
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[500])))
          : Container(
              margin: EdgeInsets.only(
                  left: deviceWidth / 15, right: deviceWidth / 15, top: 10),
              child: _productInfo(
                  product, 250.0, deviceWidth - (deviceWidth / 7.5), 0));
    }

    Widget _title(String title, double size) {
      return Container(
          margin: EdgeInsets.only(top: 20, left: 30, bottom: 0),
          child: Text(
            title,
            style: TextStyle(
                fontSize: size, fontWeight: FontWeight.bold, letterSpacing: 1),
          ));
    }

    Widget _subtitle(String title) {
      return Container(
          margin: EdgeInsets.only(
            left: 32,
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ));
    }

    List products = model.products.values.expand((x) => x).toList();

    List result = products
        .where((product) => product.title.toLowerCase().contains(_search))
        .toList();

    int indexOf(Product product) =>
        products.where((p) => p.type == product.type).toList().indexOf(product);

    List<Widget> resultItems = result
        .map((result) => Container(
            margin: EdgeInsets.only(top: 20),
            child: _productInfo(result, 250.0, 250.0, indexOf(result))))
        .toList();

    Widget searchBar() {
      return Container(
        color: Colors.grey[50],
          padding: EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 10),
          child: TextField(
            controller: _searchController,
            onChanged: (String value) {
              setState(() {
                _search = value;
              });
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 15, left: 7),
              hintText: 'Search menu',
              hintStyle: TextStyle(fontSize: 20),
              suffixIcon: Icon(Icons.search),
            ),
          ));
    }

    return Stack(
      children: <Widget>[
        ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            children: <Widget>[
              SizedBox(height: 60,),
              _search == ''
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _title('Daily Special'.toUpperCase(), 20),
                        _subtitle('Limited edition specially made'),
                        _specialItem(model.products['special'].length > 0
                            ? model.products['special'][0]
                            : null),
                        _title('Cookies', 28),
                        _horizontalListItem(model.products['cookies']),
                        _title('Breads', 28),
                        _horizontalListItem(model.products['breads']),
                        _title('Cakes', 28),
                        _horizontalListItem(model.products['cakes']),
                      ],
                    )
                  //search result
                  : Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Container(
                              padding: EdgeInsets.only(right: 40),
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _search = '';
                                      _searchController.text = '';
                                    });
                                  },
                                  icon: Icon(Icons.clear,
                                      size: 30, color: Colors.grey[700])))
                        ]..addAll(resultItems),
                      )),
              SizedBox(
                height: 30,
              )
            ]),
        searchBar()
      ],
    );
  }
}
