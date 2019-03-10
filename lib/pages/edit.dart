import 'package:flutter/material.dart';
import '../widget/primary_button.dart';
import '../model/product.dart';
import '../scope_model/main_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Edit extends StatefulWidget {

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _titleWarning;
  double _imagesize = 250.0;
  String _selectDropDown;
  Color _grey700 = Colors.grey[700];

  Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'type': null,
    'image': null,
  };

  static const _menuItems = <String>['special', 'cookies', 'breads', 'cakes'];

  void _onSubmit(product, model) {
    if (!_formKey.currentState.validate() && _formData['image'] != null) {
      return;
    }
    _formKey.currentState.save();

    Product newProduct = Product(
        title: _formData['title'],
        description: _formData['description'],
        price: _formData['price'],
        image: model.selectedIndex == null
            ? _formData['image']
            : _formData['image'] == null ? product.image : _formData['image'],
        type: _formData['type']);

    if (model.selectedIndex != null) {
      Navigator.pop(context);

      if (product.type != _formData['type']) {
        model.removeProduct(product, false);
        model.addProduct(newProduct, true);
      } else {
        model.updateProduct(newProduct);
      }
    } else {
      dynamic addProduct = model.addProduct(newProduct, false);
      if (addProduct == 'error') {
        setState(() {
          _titleWarning = 'Title existed, please choose another title';
        });
      } else {
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  Widget _title(String title, double size) {
    return Text(
      title,
      textAlign: TextAlign.left,
      style: TextStyle(
          color: Colors.grey[600],
          fontSize: size,
          fontWeight: FontWeight.bold,
          letterSpacing: 2),
    );
  }

  final List<DropdownMenuItem> _dropDownItems = _menuItems
      .map((String value) => DropdownMenuItem(value: value, child: Text(value)))
      .toList();

  void _getImage() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 150,
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: <Widget>[
                  FlatButton.icon(
                    label: Text('Camera'),
                    icon: Icon(Icons.camera),
                    onPressed: () async {
                      Navigator.pop(context);
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.camera);
                      setState(() {
                        _formData['image'] = image;
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton.icon(
                    label: Text('Gallery'),
                    icon: Icon(Icons.picture_in_picture),
                    onPressed: () async {
                      Navigator.pop(context);
                      var image = await ImagePicker.pickImage(
                          source: ImageSource.gallery, maxWidth: 400);
                      setState(() {
                        _formData['image'] = image;
                      });
                    },
                  )
                ],
              ));
        });
  }

  Widget _imageUploader(model, Product product) {
    return Column(
      children: <Widget>[
        model.selectedIndex == null
            ? _formData['image'] == null
                ? Container(
                    height: _imagesize,
                    width: _imagesize,
                    decoration: BoxDecoration(
                      border: Border.all(color: _grey700, width: 2),
                    ),
                    child: Center(
                      child: Icon(Icons.add, size: 40, color: _grey700),
                    ),
                  )
                : Image.file(
                    _formData['image'],
                    width: _imagesize,
                    height: _imagesize,
                    fit: BoxFit.cover,
                  )
            : _formData['image'] != null
                ? Image.file(
                    _formData['image'],
                    width: _imagesize,
                    height: _imagesize,
                    fit: BoxFit.cover,
                  )
                : product.image is String
                    ? Image.asset(
                        product.image,
                        width: _imagesize,
                        height: _imagesize,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        product.image,
                        width: _imagesize,
                        height: _imagesize,
                        fit: BoxFit.cover,
                      ),
        SizedBox(
          height: 7,
        ),
        GestureDetector(
          onTap: _getImage,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: _imagesize,
              decoration: BoxDecoration(border: Border.all(color: _grey700)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.camera_alt, color: _grey700),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Upload Image',
                    style: TextStyle(color: _grey700),
                  )
                ],
              )),
        )
      ],
    );
  }

  Widget _pageContent(model) {
    final int index = model.selectedIndex;
    final products = model.products[model.selectedType];
    final product = index == null ? null : products[index];
    bool isEdit = index != null;

    return Container(
        margin: EdgeInsets.only(left: 30, right: 30, top: 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              isEdit
                  ? _title('Edit'.toUpperCase(), 24)
                  : Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: _title('New Dessert'.toUpperCase(), 24)),
              SizedBox(
                height: 10,
              ),
              
              TextFormField(
                initialValue: isEdit ? product.title : null,
                validator: (String value) {
                  if (value.isEmpty || value.length < 3) {
                    return 'Title with min of 3 character is required';
                  }
                },
                decoration: InputDecoration(
                  labelText: 'title',
                ),
                onSaved: (String val) {
                  _formData['title'] = val;
                },
              ),
              _titleWarning == null
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        _titleWarning,
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      )),
              TextFormField(
                initialValue: isEdit ? product.description : null,
                validator: (String value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Description with min of 5 characters is required';
                  }
                },
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'description',
                ),
                onSaved: (String val) {
                  _formData['description'] = val;
                },
              ),
              TextFormField(
                initialValue: isEdit ? product.price.toStringAsFixed(2) : null,
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Price is required';
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'price',
                ),
                onSaved: (String val) {
                  _formData['price'] = double.parse(val);
                },
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 20)),
                hint: Text('type'),
                items: _dropDownItems,
                onChanged: (value) {
                    setState(() => _selectDropDown = value);
                },
                value: _selectDropDown,
                validator: (value) {
                  if (value == null) {
                    return 'Dessert type is required';
                  }
                },
                onSaved: (value) {
                  _formData['type'] = value;
                },
              ),
              SizedBox(
                height: 30,
              ),
              _imageUploader(model, product),

              SizedBox(
                height: 40,
              ),
              PrimaryButton(
                  'submit', () => _onSubmit(isEdit ? product : null, model)),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final model = MainModel.of(context, true);
    if(model.selectedIndex != null) {
      if(_selectDropDown == null){
        _selectDropDown = model.selectedType;
      }
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: _grey700),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: _pageContent(model),
      );
    } else {
      return _pageContent(model);
    }
  }
}
