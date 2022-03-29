import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/dtos/requests/create_activity.dart';
import 'package:moveness/providers/activity.dart';
import 'package:moveness/providers/challenge.dart';
import 'package:moveness/misc/error_dialogs.dart';
import 'package:moveness/shared/ok_dialog.dart';
import 'package:provider/provider.dart';

class CreateActivityPage extends StatefulWidget {
  @override
  _CreateActivityPageState createState() => _CreateActivityPageState();
}

class _CreateActivityPageState extends State<CreateActivityPage> {
  final _formKey = GlobalKey<FormState>();
  final minutesController = TextEditingController();
  late ActivityType? chosenActivityType;

  bool _isButtonDisabled = false;
  final _light = 1.14589531645;
  final _moderate = 2.28645861973;
  final _high = 4.47546831649;

  late List<ActivityType> activities;

  @override
  void initState() {
    super.initState();

    activities = [
      ActivityType(
        name: "Promenad",
        image: "assets/images/walking.png",
        value: _light,
      ),
      ActivityType(
        name: "Löpning",
        image: "assets/images/running.png",
        value: _moderate,
      ),
      ActivityType(
        name: "Power walk",
        image: "assets/images/walking.png",
        value: _moderate,
      ),
      ActivityType(
        name: "Styreträning",
        image: "assets/images/weight_lifting.png",
        value: _moderate,
      ),
      ActivityType(
        name: "Lagsport",
        image: "assets/images/team_sport.png",
        value: _moderate,
      ),
      ActivityType(
        name: "Intervallträning",
        image: "assets/images/running.png",
        value: _high,
      ),
      ActivityType(
        name: "Cykeltur i lågt tempo",
        image: "assets/images/cycling.png",
        value: _light,
      ),
      ActivityType(
        name: "Cykeltur i högt tempo",
        image: "assets/images/cycling.png",
        value: _moderate,
      ),
      ActivityType(
        name: "Dansa",
        image: "assets/images/dancing.png",
        value: _moderate,
      ),
      ActivityType(
        name: "Yoga",
        image: "assets/images/yoga.png",
        value: _light,
      ),
      ActivityType(
        name: "Lågintensiv träning\n(Enkel andning, svettas inte)",
        image: "assets/images/light.png",
        value: _light,
      ),
      ActivityType(
        name: "Medelintensiv träning\n(Djup andning, svettas efter 10 minuter)",
        image: "assets/images/moderate.png",
        value: _moderate,
      ),
      ActivityType(
        name: "Högintensiv träning\n(Tung andning, svettas efter 3-5 minuter)",
        image: "assets/images/running.png",
        value: _high,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);
    final challengeProvider = Provider.of<ChallengeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Skapa aktivitet')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    controller: minutesController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    autofocus: true,
                    validator: (value) {
                      if (value?.isEmpty == true)
                        return "Får inte vara tom.";
                      else if (value != null && int.tryParse(value) == null)
                        return "Måste vara ett heltal.";

                      return null;
                    },
                  ),
                ),
                Text('min')
              ],
            ),
            SizedBox(height: ThemeSettings.getMainPadding()),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: activities.length,
                itemBuilder: (context, i) {
                  final activityType = activities[i];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        activities.forEach((e) {
                          e.picked = false;
                        });
                        activityType.picked = true;
                      });
                      chosenActivityType = activityType;
                    },
                    child: Container(
                      color:
                          activityType.picked ? ThemeSettings.grayColor : null,
                      padding: EdgeInsets.fromLTRB(
                        0,
                        ThemeSettings.getMainPadding(),
                        0,
                        ThemeSettings.getMainPadding(),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            activityType.image,
                            fit: BoxFit.cover,
                            height: 50,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              ThemeSettings.getMainPadding(),
                              4,
                              ThemeSettings.getMainPadding(),
                              0,
                            ),
                            child: Text(
                              activityType.name,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ThemeSettings.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                padding: EdgeInsets.fromLTRB(
                  ThemeSettings.getMainPadding(),
                  0,
                  ThemeSettings.getMainPadding(),
                  0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                0,
                ThemeSettings.getMainPadding(),
                0,
                ThemeSettings.getMainPadding(),
              ),
              child: RaisedButton(
                  onPressed: _isButtonDisabled
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() == true) {
                            if (chosenActivityType == null) {
                              showDialog(
                                  builder: (context) => OkDialog(
                                        title: "Ingen aktivitet vald",
                                        content: "Du måste välja en aktivitet",
                                        buttonText: "OK",
                                      ),
                                  context: context);
                              return;
                            }

                            setState(() {
                              _isButtonDisabled = true;
                            });

                            final name =
                                chosenActivityType?.name.split("\n").first;
                            final activityLevel =
                                chosenActivityType?.value ?? 0;
                            final points = activityLevel *
                                int.parse(minutesController.text);

                            var request = CreateActivityRequest(
                              activeMinutes: points.round(),
                              name: name,
                            );

                            var response =
                                await activityProvider.createActivity(request);

                            if (response.isSuccess()) {
                              challengeProvider.getChallenges(true);
                              Navigator.of(context).pop();
                            } else {
                              setState(() {
                                _isButtonDisabled = false;
                              });

                              ErrorDialogs(response, context).show();
                            }
                          }
                        },
                  child: Text(
                    'Skapa',
                  )),
            )
          ],
        ),
      ),
    );
  }
}

class ActivityType {
  String name;
  String image;
  double value;
  bool picked = false;

  ActivityType({
    required this.name,
    required this.image,
    required this.value,
  });
}
