import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/locator.dart';
import 'package:moveness/services/auth.dart';
import 'package:moveness/shared/ok_dialog.dart';
import 'package:moveness/shared/styled_circular_progress_indicator.dart';
import 'package:moveness/shared/styled_text_form_field.dart';
import 'package:moveness/views/main.dart';
import 'package:moveness/views/register.dart';
import 'package:moveness/views/reset_password.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ThemeSettings.getMainPadding()),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Image(
                    image: AssetImage('assets/images/logo_color.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  'Logga in',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                SizedBox(height: ThemeSettings.getMainPadding()),
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');

  final _auth = locator<AuthService>();

  bool _showLoading = false;
  bool _isButtonDisabled = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          StyledTextFormField(
            controller: usernameController,
            keyboardType: TextInputType.emailAddress,
            labelText: 'Användarnamn',
            validator: (value) {
              if (value?.isEmpty == true) return "Får inte vara tom";
              return null;
            },
          ),
          SizedBox(height: ThemeSettings.getMainPadding()),
          StyledTextFormField(
            controller: passwordController,
            keyboardType: TextInputType.text,
            labelText: 'Lösenord',
            validator: (value) {
              if (value?.isEmpty == true) return "Får inte vara tom";
              return null;
            },
            obscureText: true,
          ),
          SizedBox(height: ThemeSettings.getMainPadding()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                minWidth: 130,
                color: Theme.of(context).accentColor,
                textColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => RegisterView())),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(context).accentColor,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50)),
                child: Text('Registrera'),
              ),
              FlatButton(
                minWidth: 130,
                color: Theme.of(context).accentColor,
                textColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(context).accentColor,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50)),
                onPressed: _isButtonDisabled
                    ? null
                    : () async {
                        if (_formKey.currentState?.validate() == true) {
                          setState(() {
                            _showLoading = true;
                            _isButtonDisabled = true;
                          });

                          if (await _auth.login(
                            usernameController.text.trim(),
                            passwordController.text.trim(),
                          )) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => MainView(),
                              ),
                            );
                          } else {
                            setState(() {
                              _showLoading = false;
                              _isButtonDisabled = false;
                            });

                            showDialog(
                              context: context,
                              builder: (context) => OkDialog(
                                buttonText: "OK",
                                content: "Felaktiga användaruppgifter",
                                title: "Fel",
                              ),
                            );
                          }
                        }
                      },
                child: Text('Logga in'),
              ),
            ],
          ),
          SizedBox(height: ThemeSettings.getMainPadding()),
          InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ResetPasswordView(),
            )),
            child: Text(
              'Glömt lösenord?',
              style: TextStyle(
                color: ThemeSettings.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Visibility(
            child: Padding(
              padding: EdgeInsets.only(top: ThemeSettings.getMainPadding()),
              child: StyledCircularProgressIndicator(),
            ),
            visible: _showLoading,
          ),
        ],
      ),
    );
  }
}
