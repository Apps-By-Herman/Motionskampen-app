import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/dtos/requests/confirm_reset_password.dart';
import 'package:moveness/locator.dart';
import 'package:moveness/services/api.dart';
import 'package:moveness/misc/error_dialogs.dart';
import 'package:moveness/shared/action_dialog.dart';
import 'package:moveness/shared/styled_circular_progress_indicator.dart';
import 'package:moveness/shared/styled_text_form_field.dart';

class ConfirmResetPasswordView extends StatelessWidget {
  ConfirmResetPasswordView(
    this.email, {
    Key? key,
  }) : super(key: key);

  final email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ThemeSettings.getMainPadding()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('assets/images/logo_color.png'),
                  fit: BoxFit.cover,
                  height: 170,
                ),
                Text(
                  'Återställ lösenord',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                SizedBox(height: ThemeSettings.getMainPadding()),
                ConfirmResetPasswordForm(email),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmResetPasswordForm extends StatefulWidget {
  const ConfirmResetPasswordForm(
    this.email, {
    Key? key,
  }) : super(key: key);

  final email;

  @override
  _ConfirmResetPasswordForm createState() => _ConfirmResetPasswordForm();
}

class _ConfirmResetPasswordForm extends State<ConfirmResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final tokenController = TextEditingController(text: '');
  final passwordController = TextEditingController(text: '');
  final confirmPasswordController = TextEditingController(text: '');
  final _api = locator<ApiService>();

  bool showLoading = false;
  bool _isButtonDisabled = false;

  @override
  void dispose() {
    tokenController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          StyledTextFormField(
            controller: tokenController,
            keyboardType: TextInputType.text,
            labelText: 'Återställningskod',
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
            obscureText: true,
            validator: (value) {
              if (value?.isEmpty == true) return "Lösenordet får inte vara tomt.";
              if ((value ?? "").length < 6) return "Måste vara minst 6 tecken långt.";
              if (value?.contains(new RegExp(r'[0-9]')) == false)
                return "Måste innehålla minst en siffra.";
              if (value?.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]')) == false)
                return "Måste innehålla minst ett specialtecken.";
              if (value?.contains(new RegExp(r'[a-z]')) == false)
                return "Måste innehålla minst en liten bokstav.";
              if (value?.contains(new RegExp(r'[A-Z]')) == false)
                return "Måste innehålla minst en stor bokstav";
              return null;
            },
          ),
          SizedBox(height: ThemeSettings.getMainPadding()),
          StyledTextFormField(
            controller: confirmPasswordController,
            keyboardType: TextInputType.text,
            labelText: 'Lösenord igen',
            obscureText: true,
            validator: (value) {
              if (value?.isEmpty == true) return "Får inte vara tom";
              if (value != passwordController.text)
                return "Lösenorden matchar inte.";

              return null;
            },
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
                onPressed: () => Navigator.of(context).pop(),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Theme.of(context).accentColor,
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  'Tillbaka',
                  overflow: TextOverflow.ellipsis,
                ),
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
                            showLoading = true;
                            _isButtonDisabled = true;
                          });
                          var token = tokenController.text;
                          var password = passwordController.text;

                          var request = ConfirmResetPasswordRequest(
                              email: widget.email,
                              token: token,
                              password: password);
                          var response =
                              await _api.confirmResetPassword(request);

                          if (response.isSuccess()) {
                            showDialog(
                              context: context,
                              builder: (ctx) => ActionDialog(
                                positiveText: "OK",
                                content: "Ditt lösenord har återställts, "
                                    "logga in med ditt nya lösenord.",
                                title: "Lyckades",
                                positive: () {
                                  var count = 0;
                                  Navigator.popUntil(context, (route) {
                                    return count++ == 2;
                                  });
                                },
                              ),
                            );
                          } else {
                            setState(() {
                              showLoading = false;
                              _isButtonDisabled = false;
                            });

                            ErrorDialogs(response, context).show();
                          }
                        }
                      },
                child: Text(
                  'Byt lösenord',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Visibility(
            child: Padding(
              padding: EdgeInsets.only(top: ThemeSettings.getMainPadding()),
              child: StyledCircularProgressIndicator(),
            ),
            visible: showLoading,
          ),
        ],
      ),
    );
  }
}
