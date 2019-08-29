import 'package:carstat/components/main_scafford.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carstat/services/auth_service.dart';
import 'package:carstat/services/auth_provider.dart';

class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Введите Email' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Введите пароль' : null;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({this.onSignedIn, this.onSignedOut});
  final VoidCallback onSignedIn;
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

enum FormType {
  login,
  register,
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        final BaseAuth auth = AuthProvider.of(context).auth;
        if (_formType == FormType.login) {
          final String userId = await auth.signInWithEmailAndPassword(_email, _password);
          print('Signed in: $userId');
        } else {
          final String userId = await auth.createUserWithEmailAndPassword(_email, _password);
          print('Registered user: $userId');
        }
        widget.onSignedIn();
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> googleSignIn() async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      final String userEmail = await auth.signInWithGoogle();
      print(userEmail);
      widget.onSignedIn();

    } catch (e) {
      print('Error: $e');
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: ListView(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildInputs() + buildSubmitButtons(),
                ),
              ),
            ),
          )
        ],
      )
    );
  }

  List<Widget> buildInputs() {
    return <Widget>[
      Text('ВХОД В ПРИЛОЖЕНИЕ:', style: TextStyle(fontWeight: FontWeight.bold),),
      Divider(),
      TextFormField(
        key: Key('email'),
        decoration: InputDecoration(labelText: 'Email'),
        validator: EmailFieldValidator.validate,
        onSaved: (String value) => _email = value,
      ),
      TextFormField(
        key: Key('password'),
        decoration: InputDecoration(labelText: 'Пароль'),
        obscureText: true,
        validator: PasswordFieldValidator.validate,
        onSaved: (String value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return <Widget>[
        Container(height: 30.0,),
        RaisedButton(
          key: Key('signIn'),
          child: Text('ВХОД', style: TextStyle()),
          onPressed: validateAndSubmit,
          color: Colors.yellow,
          highlightColor: Colors.orange[400],
        ),
        Container(height: 20.0,),
        RaisedButton(
          key: Key('googleSignIn'),
          child: Wrap(
            children: <Widget>[
              Image.asset('images/google_logo.png', height: 15.0,),
              Container(width: 10.0,),
              Text('ВХОД ЧЕРЕЗ GOOGLE')
            ],
          ),
          onPressed: () {
            googleSignIn();
          },
          color: Colors.yellow,
        ),
        Container(height: 20.0,),
        RaisedButton(
          child: Text('РЕГИСТРАЦИЯ', ),
          color: Colors.yellow,
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: RaisedButton(
            child: Text('ЗАРЕГИСТРИРОВАТЬ', style: TextStyle()),
            onPressed: validateAndSubmit,
            color: Colors.yellow,
            highlightColor: Colors.orange[400],
          ),
        ),
        FlatButton(
          child: Text('Есть аккаунт? Войти', style: TextStyle(fontSize: 14.0, color: Colors.green)),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}

// TODO возвращать ошибку авторизации если пользователь не найден