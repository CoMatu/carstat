import 'package:flutter/material.dart';
import 'dart:async';
import 'package:carstat/components/main_appbar.dart';
import 'package:carstat/generated/i18n.dart';
import 'package:carstat/services/auth_service.dart';
import 'package:carstat/services/auth_provider.dart';

class EmailFieldValidator {
  BuildContext context;
  EmailFieldValidator(this.context);
  String validate(String value) {
    return value.isEmpty ? S.of(context).enter_email : null;
  }
}

class PasswordFieldValidator {
  BuildContext context;
  PasswordFieldValidator(this.context);
  String validate(String value) {
    return value.isEmpty ? S.of(context).enter_password : null;
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
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

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
          final String userId =
              await auth.signInWithEmailAndPassword(_email, _password);
          print('Signed in: $userId');
        } else {
          final String userId =
              await auth.createUserWithEmailAndPassword(_email, _password);
          print('Registered user: $userId');
        }
        widget.onSignedIn();
      } catch (e) {
        print('Error with email: $e');
        _showSnackBar(e);
      }
    }
  }

  void _showSnackBar(e) {
    key.currentState.showSnackBar(SnackBar(
      content: Text(e.toString()),
      backgroundColor: Colors.red,
    ));
  }

  Future<void> googleSignIn() async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      final String userId = await auth.signInWithGoogle();
      print('Signed with Google as $userId');
      widget.onSignedIn();
    } catch (e) {
      print('Error with Google: $e');
      _showSnackBar(e);
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
    return Scaffold(
      key: key,
        appBar: MainAppBar(),
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
        ));
  }

  List<Widget> buildInputs() {
    return <Widget>[
      Text(
        S.of(context).login,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Divider(),
      TextFormField(
        key: Key('email'),
        decoration: InputDecoration(labelText: 'Email'),
        validator: EmailFieldValidator(context).validate,
        onSaved: (String value) => _email = value,
      ),
      TextFormField(
        key: Key('password'),
        decoration: InputDecoration(labelText: S.of(context).password),
        obscureText: true,
        validator: PasswordFieldValidator(context).validate,
        onSaved: (String value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return <Widget>[
        Container(
          height: 30.0,
        ),
        RaisedButton(
          key: Key('signIn'),
          child: Text(S.of(context).signin, style: TextStyle()),
          onPressed: validateAndSubmit,
          color: Colors.yellow,
          highlightColor: Colors.orange[400],
        ),
        Container(
          height: 20.0,
        ),
        RaisedButton(
          key: Key('googleSignIn'),
          child: Wrap(
            children: <Widget>[
              Image.asset(
                'images/google_logo.png',
                height: 15.0,
              ),
              Container(
                width: 10.0,
              ),
              Text(S.of(context).signin_with_google)
            ],
          ),
          onPressed: googleSignIn,
          color: Colors.yellow,
        ),
        Container(
          height: 20.0,
        ),
        RaisedButton(
          child: Text(
            S.of(context).registration,
          ),
          color: Colors.yellow,
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: RaisedButton(
            child: Text(S.of(context).registration, style: TextStyle()),
            onPressed: validateAndSubmit,
            color: Colors.yellow,
            highlightColor: Colors.orange[400],
          ),
        ),
        FlatButton(
          child: Text(S.of(context).already_have_account,
              style: TextStyle(fontSize: 14.0, color: Colors.green)),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}

// TODO возвращать ошибку авторизации если пользователь не найден
