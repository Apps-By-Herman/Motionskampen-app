import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/dtos/requests/register.dart';
import 'package:moveness/locator.dart';
import 'package:moveness/services/auth.dart';
import 'package:moveness/misc/error_dialogs.dart';
import 'package:moveness/shared/styled_circular_progress_indicator.dart';
import 'package:moveness/shared/styled_text_form_field.dart';
import 'package:moveness/views/main.dart';

class RegisterView extends StatelessWidget {
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
                  'Registrera',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                SizedBox(height: 24),
                RegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    Key? key,
  }) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = locator<AuthService>();

  bool _showLoading = false;
  bool _isButtonDisabled = false;

  @override
  void dispose() {
    emailController.dispose();
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
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            labelText: 'E-postadress',
            validator: (value) {
              if (!EmailValidator.validate(value ?? "", false, false))
                return "E-postadressen är inte giltig.";
              return null;
            },
          ),
          SizedBox(height: 24),
          StyledTextFormField(
            controller: usernameController,
            keyboardType: TextInputType.emailAddress,
            labelText: 'Användarnamn',
            validator: (value) {
              if (value?.isEmpty == true)
                return "Användarnamnet får inte vara tomt.";
              return null;
            },
          ),
          SizedBox(height: 24),
          StyledTextFormField(
            controller: passwordController,
            keyboardType: TextInputType.emailAddress,
            labelText: 'Lösenord',
            validator: (value) {
              if (value?.isEmpty == true)
                return "Lösenordet får inte vara tomt.";
              if ((value ?? "").length < 6) return "Måste vara minst 6 tecken långt.";
              if (value?.contains(new RegExp(r'[0-9]')) == false)
                return "Måste innehålla minst en siffra.";
              if (value?.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]')) ==
                  false) return "Måste innehålla minst ett specialtecken.";
              if (value?.contains(new RegExp(r'[a-z]')) == false)
                return "Måste innehålla minst en liten bokstav.";
              if (value?.contains(new RegExp(r'[A-Z]')) == false)
                return "Måste innehålla minst en stor bokstav";
              return null;
            },
            obscureText: true,
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                minWidth: 130,
                color: Theme.of(context).accentColor,
                textColor: Theme.of(context).primaryColor,
                padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
                onPressed: () => Navigator.of(context).pop(),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(context).accentColor,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50)),
                child: Text('Tillbaka'),
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

                          var email = emailController.text.trim();
                          var username = usernameController.text.trim();
                          var password = passwordController.text.trim();

                          var request = RegisterRequest(
                            email: email,
                            username: username,
                            password: password,
                          );

                          var response = await _auth.register(request);

                          if (response.isSuccess()) {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (context) {
                                return MainView();
                              },
                            ));
                          } else {
                            setState(() {
                              _showLoading = false;
                              _isButtonDisabled = false;
                            });

                            ErrorDialogs(response, context).show();
                          }
                        }
                      },
                child: Text('Registrera'),
              ),
            ],
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
