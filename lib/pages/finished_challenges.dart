import 'package:flutter/material.dart';
import 'package:moveness/models/challenge.dart';
import 'package:moveness/providers/challenge.dart';
import 'package:moveness/shared/challenge_item.dart';
import 'package:moveness/shared/empty_list_text.dart';
import 'package:moveness/shared/styled_circular_progress_indicator.dart';
import 'package:provider/provider.dart';

class FinishedChallengesPage extends StatefulWidget {
  const FinishedChallengesPage({this.teamChallenges, Key? key})
      : super(key: key);
  final List<Challenge>? teamChallenges;

  @override
  _FinishedChallengesPageState createState() => _FinishedChallengesPageState();
}

class _FinishedChallengesPageState extends State<FinishedChallengesPage> {
  @override
  void initState() {
    super.initState();

    if (widget.teamChallenges == null) {
      var challengeProvider =
          Provider.of<ChallengeProvider>(context, listen: false);
      challengeProvider.getFinishedChallenges();
    }
  }

  @override
  Widget build(BuildContext context) {
    final challengeProvider = Provider.of<ChallengeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Avslutade utmaningar")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: widget.teamChallenges == null
                  ? challengeProvider.finishedChallenges == null
                      ? Center(child: StyledCircularProgressIndicator())
                      : challengeProvider.finishedChallenges!.isEmpty
                          ? EmptyListText('Du har inga avslutade utmaningar.')
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  challengeProvider.finishedChallenges!.length,
                              itemBuilder: (context, i) => ChallengeWidget(
                                challengeProvider.finishedChallenges![i],
                                true,
                              ),
                            )
                  : widget.teamChallenges?.isEmpty == true
                      ? EmptyListText('Teamet har inga avslutade utmaningar.')
                      : ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: widget.teamChallenges?.length,
                          itemBuilder: (context, i) => ChallengeWidget(
                            widget.teamChallenges![i],
                            true,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
