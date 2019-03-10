import 'package:flutter/material.dart';
import '../scope_model/main_model.dart';
import '../widget/primary_button.dart';

class Auth extends StatefulWidget {
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };

  void _onSubmit(login) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    login(_formData['email'], _formData['password']);
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    final model = MainModel.of(context, true);
    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.center,
          child: SingleChildScrollView(
              child: Column(
                children: [
            Image.asset('assets/logo.png', width: 100, color: Colors.grey[700]),
            SizedBox(
              height: 10,
            ),
            Text(
              'Mori\'s Bakery',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.grey[700],
                  letterSpacing: 2),
            ),
            SizedBox(
              height: 5
            ),
            Text(
              'Healthy food made with joy',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  letterSpacing: 2),
            ),
            SizedBox(
              height: 10,
            ),
            Form(
                key: _formKey,
                child: ListView(shrinkWrap: true, children: <Widget>[
                  TextFormField(
                    initialValue: null,
                    // validator: (String value) {
                    //   if (value.isEmpty ||
                    //       value.length < 6 ||
                    //       !value.contains('@') ||
                    //       !value.contains('.')) {
                    //     return 'Invalid email';
                    //   }
                    // },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email',
                    ),
                    onSaved: (String val) {
                      _formData['email'] = val;
                    },
                  ),
                  TextFormField(
                    initialValue: null,
                    // validator: (String value) {
                    //   if (value.isEmpty || value.length < 8) {
                    //     return 'Password with min of 8 character is required';
                    //   }
                    // },
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: 'Password',
                    ),
                    onSaved: (String val) {
                      _formData['password'] = val;
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  PrimaryButton('login', () => _onSubmit(model.login))
                ])),
          ]))),
    );
  }
}
