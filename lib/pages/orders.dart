import 'package:flutter/material.dart';
import '../scope_model/main_model.dart';
import '../model/product.dart';
import '../widget/primary_button.dart';

class DialogCount extends StatefulWidget {
  final Product product;
  final int count;
  DialogCount(this.product, this.count);

  @override
  _DialogCountState createState() => _DialogCountState();
}

class _DialogCountState extends State<DialogCount> {
  int _count = 1;
  @override
  void initState() {
    _count = widget.count;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = MainModel.of(context, true);

    _showWarningDialog(product) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            void pop() {
              Navigator.pop(context);
            }

            return AlertDialog(
              title: Text('Are you sure you want to remove this dessert?'),
              content: Text('This action cannot be undone.'),
              actions: <Widget>[
                FlatButton(
                  child: Text('CANCEL',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          letterSpacing: 1)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('DELETE',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, letterSpacing: 1)),
                  onPressed: () {
                    model.cartRemove(product);
                    Navigator.pop(context);
                    pop();
                  },
                )
              ],
            );
          });
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.remove_circle_outline,
              color: Colors.grey[600], size: 35),
          onPressed: () {
            if (_count == 1) {
              _showWarningDialog(widget.product);
            } else {
              setState(() {
                _count = _count - 1;
              });
              model.decrement(widget.product);
            }
          },
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Text('${_count.toString()}',
                style: TextStyle(
                  fontSize: 20,
                ))),
        IconButton(
          icon:
              Icon(Icons.add_circle_outline, color: Colors.grey[600], size: 35),
          onPressed: () {
            setState(() {
              _count = _count + 1;
            });
            model.increment(widget.product);
          },
        ),
      ],
    );
  }
}

class Orders extends StatelessWidget {
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

  _showSheet(BuildContext context, product, count, model) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(children: [
            Container(
                padding: EdgeInsets.symmetric(vertical:30, horizontal:10),
                child: Center(
                    child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          product.image,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                                width: 150,
                                child: Text(
                                  product.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Text('RM ${product.price.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 18)),
                            SizedBox(
                              height: 10,
                            ),
                            DialogCount(product, count)
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: 50,
                      child: Row(children: [
                        Expanded(
                            child: PrimaryButton('done', () {
                          Navigator.pop(context);
                        }))
                      ]),
                    ),
                  ],
                )))
          ]);
        });
  }

  orderItem(context, product, count, model) {
    return GestureDetector(
        onTap: () => _showSheet(context, product, count, model),
        child: Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Image.asset(
                      product.image,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 15),
                        width: 140,
                        child: Text(
                          product.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                Text(
                  '${count.toString()}x RM ${product.price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18),
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    final model = MainModel.of(context, true);
    final products = model.user.cart;

    return Container(
        margin: EdgeInsets.only(left: 15, right: 10, top: 40),
        child: ListView(children: [
          _title('Orders'.toUpperCase(), 24),
          SizedBox(
            height: 30,
          ),
          ListView.builder(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              Product product = products[index][0];
              int count = products[index][1];
              return orderItem(context, product, count, model);
            },
            itemCount: products.length,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.grey[400],
            height: products.length > 0 ? 2 : 0,
            margin: EdgeInsets.only(bottom: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: products.length > 0
                ? [
                    Text('TOTAL',
                        style: TextStyle(
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.grey[600])),
                    Text(
                      'RM ${model.total.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18),
                    )
                  ]
                : [
                    Text('Browse menu to add orders here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.grey[500]))
                  ],
          ),
          SizedBox(
            height: 40,
          ),
          products.length > 0
              ? PrimaryButton('Check Out', () {
                  model.checkOut();
                })
              : SizedBox(),
          SizedBox(
            height: 20,
          ),
          OutlineButton(
            borderSide: BorderSide(color: Colors.grey[600]),
            child: Text('Log Out',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey[600])),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/auth');
            },
          )
        ]));
  }
}
