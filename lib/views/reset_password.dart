import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/dtos/requests/reset_password.dart';
import 'package:moveness/locator.dart';
import 'package:moveness/services/api.dart';
import 'package:moveness/shared/styled_text_form_field.dart';
import 'package:moveness/views/confirm_reset_password.dart';

class ResetPasswordView extends StatelessWidget {
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
                  'Glömt lösenord',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).accentColor,
                  ),
                ),
                SizedBox(height: ThemeSettings.getMainPadding()),
                ResetPasswordForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResetPasswordForm extends StatefulWidget {
  const ResetPasswordForm({
    Key? key,
  }) : super(key: key);

  @override
  _ResetPasswordForm createState() => _ResetPasswordForm();
}

class _ResetPasswordForm extends State<ResetPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(text: '');
  final _api = locator<ApiService>();

  @override
  void dispose() {
    emailController.dispose();
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
              if (value?.isEmpty == true)
                return "Får inte vara tom";
              else if (!EmailValidator.validate(value ?? "", false, false))
                return "E-postadressen är inte giltig";
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
                onPressed: () async {
                  if (_formKey.currentState?.validate() == true) {
                    var email = emailController.text;
                    var request = ResetPasswordRequest(email: email);
                    await _api.resetPassword(request);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ConfirmResetPasswordView(email),
                      ),
                    );
                  }
                },
                child: Text('Återställ'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
