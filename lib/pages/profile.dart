import 'package:app_settings/app_settings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/locator.dart';
import 'package:moveness/providers/me.dart';
import 'package:moveness/services/auth.dart';
import 'package:moveness/misc/error_dialogs.dart';
import 'package:moveness/shared/action_dialog.dart';
import 'package:moveness/shared/styled_circular_progress_indicator.dart';
import 'package:moveness/views/login.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    final _auth = locator<AuthService>();
    final _meProvider = Provider.of<MeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _isButtonDisabled
                ? null
                : _onClickRemoveMe(_meProvider, _auth, context),
            color: Colors.red,
          ),
        ],
      ),
      body: Column(
        children: [
          _meProvider.me == null
              ? Padding(
                  padding: EdgeInsets.only(top: ThemeSettings.getMainPadding()),
                  child: Center(child: StyledCircularProgressIndicator()),
                )
              : Padding(
                  padding: EdgeInsets.fromLTRB(
                    ThemeSettings.getMainPadding(),
                    0,
                    ThemeSettings.getMainPadding(),
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _meProvider.me?.emailConfirmed == true
                          ? Container()
                          : Text(
                              'Bekräfta din e-postadress genom att trycka'
                              ' på länken i e-postmeddelandet från Motionskampen.',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: _meProvider.me?.profileImageURL ?? "",
                            fit: BoxFit.cover,
                            height: 40,
                          ),
                          SizedBox(width: ThemeSettings.getMainPadding()),
                          Text(_meProvider.me!.username),
                        ],
                      ),
                    ],
                  ),
                ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  onPressed: () => AppSettings.openAppSettings(),
                  child: Text('Inställningar'),
                ),
                SizedBox(height: ThemeSettings.getMainPadding()),
                RaisedButton(
                  onPressed: () {
                    _auth.logout();

                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => LoginView(),
                    ));
                  },
                  child: Text('Logga ut'),
                ),
                SizedBox(height: ThemeSettings.getMainPadding())
              ],
            ),
          ),
        ],
      ),
    );
  }

  _onClickRemoveMe(
      MeProvider meProvider, AuthService auth, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ActionDialog(
        title: 'Ta bort konto?',
        content: 'Är du säker på att du vill ta bort ditt konto?',
        positiveText: 'Ja',
        positive: () async {
          setState(() {
            _isButtonDisabled = true;
          });
          var response = await meProvider.deleteMe();

          if (response.isSuccess()) {
            auth.logout();

            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => LoginView(),
            ));
          } else {
            setState(() {
              _isButtonDisabled = false;
            });

            ErrorDialogs(response, context).show();
          }
        },
      ),
    );
  }
}
