import 'package:scoped_model/scoped_model.dart';
import '../model/product.dart';
import '../model/user.dart';

class MainModel extends Model with ProductModel, UserModel {
  static MainModel of(context, bool status) =>
      ScopedModel.of<MainModel>(context, rebuildOnChange: status);
}

mixin UserModel on Model {
  static User admin = User(email: 'admin', password: 'admin', isAdmin: true);

  User _user;

  User get user => _user;

  void login(String email, String password) {
    if (email == admin.email) {
      _user = admin;
    } else {
      _user = User(email: email, password: password);
    }
  }

  double _total = 0.0;

  double get total => _total;

  void addToCart(Product product) {
    List products = _user.cart.map((cart) => cart[0]).toList();

    if (products.contains(product)) {
    } else {
      _user.cart.add([product, 1]);
    }
    _total = _total + product.price;
    notifyListeners();
  }

  int cartAmount() {
    List products = _user.cart.map((cart) => cart[1]).toList();
    int sum = _user.cart.length > 0
        ? products.reduce((value, element) => value + element)
        : 0;
    return sum;
  }

  void cartRemove(product) {
    List products = _user.cart.map((cart) => cart[0]).toList();
    int index = products.indexWhere((p) => p.title == product.title);
    _user.cart.removeAt(index);
    notifyListeners();
  }

  void increment(Product product) {
    List products = _user.cart.map((cart) => cart[0]).toList();

    int index = products.indexWhere((p) => p.title == product.title);

    _user.cart[index][1] = _user.cart[index][1] + 1;

    _total = _total + product.price;
    notifyListeners();
  }

  void decrement(Product product) {
    List products = _user.cart.map((cart) => cart[0]).toList();

    int index = products.indexWhere((p) => p.title == product.title);
    int count = _user.cart[index][1];
    _user.cart[index][1] = count == 0 ? 0 : count - 1;

    _total = count == 0 ? _total : _total - product.price;
    notifyListeners();
  }

  void checkOut() {
    _user.cart.clear();
    _total = 0;
    notifyListeners();
  }
}

mixin ProductModel on Model {
  Map<String, List<Product>> _products = {
    'special': [
      Product(
          title: 'Snowy Raisin Bread',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas consequat mauris bibendum, malesuada quam quis, dictum tortor.',
          price: 12.00,
          image: 'assets/bread04.jpg',
          type: 'special')
    ],
    'cookies': [
      Product(
          title: 'Choco Cookies',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas consequat mauris bibendum, malesuada quam quis, dictum tortor.',
          price: 7.90,
          image: 'assets/cookie01.jpg',
          type: 'cookies'),
      Product(
          title: 'Vanilla Cookies',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas consequat mauris bibendum, malesuada quam quis, dictum tortor.',
          price: 8.0,
          image: 'assets/cookie02.jpg',
          type: 'cookies'),
      Product(
          title: 'Almond Cookies',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas consequat mauris bibendum, malesuada quam quis, dictum tortor.',
          price: 9.0,
          image: 'assets/cookie03.jpg',
          type: 'cookies'),
    ],
    'breads': [
      Product(
          title: 'Creamy Bun',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas consequat mauris bibendum, malesuada quam quis, dictum tortor.',
          price: 9.0,
          image: 'assets/bread03.jpg',
          type: 'breads'),
      Product(
          title: 'Sourdough',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas consequat mauris bibendum, malesuada quam quis, dictum tortor.',
          price: 7.0,
          image: 'assets/bread01.jpg',
          type: 'breads'),
      Product(
          title: 'Bunny Bun',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas consequat mauris bibendum, malesuada quam quis, dictum tortor.',
          price: 10.0,
          image: 'assets/bread02.jpg',
          type: 'breads'),
    ],
    'cakes': [
      Product(
          title: 'Walnut Cake',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas consequat mauris bibendum, malesuada quam quis, dictum tortor.',
          price: 10.0,
          image: 'assets/cake01.jpg',
          type: 'cakes'),
      Product(
          title: 'Choco Cupcake',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas consequat mauris bibendum, malesuada quam quis, dictum tortor.',
          price: 9.0,
          image: 'assets/cake03.jpg',
          type: 'cakes'),
      Product(
          title: 'Easter Cupcake',
          description:
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas consequat mauris bibendum, malesuada quam quis, dictum tortor.',
          price: 9.0,
          image: 'assets/cake02.jpg',
          type: 'cakes'),
    ]
  };

  int _selectedIndex;
  String _selectedType;

  Map get products => _products;
  int get selectedIndex => _selectedIndex;
  String get selectedType => _selectedType;

  select(int index, String type) {
    _selectedIndex = index;
    _selectedType = type;
  }

  addProduct(Product product, bool isEdit) {
     if (product.type == 'special') {
          updateProduct(product);
        }
    else if (isEdit) {
      _products[product.type].add(product);
    } else {
      List allProducts = _products.values.expand((x) => x).toList();
      List titles = allProducts.map((p) => p.title.toLowerCase()).toList();

      if (titles.contains(product.title.toLowerCase())) {
        return 'error';
      } else {
        _products[product.type].add(product);
      }
    }
  }

  removeProduct(Product product, bool isNotified) {
    _products[product.type].remove(product);
    if(isNotified){
      notifyListeners();
    }
  }

  updateProduct(Product product) {
    if (product.type == 'special') {
      if(_products['special'].length > 0){
      _products['special'][0] = product;
      }else{
        _products['special'].add(product);
      }
    } else {
      _products[product.type][_selectedIndex] = product;
    }
  }
}
