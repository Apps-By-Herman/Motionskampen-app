import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/models/team.dart';
import 'package:moveness/providers/search.dart';
import 'package:provider/provider.dart';

class SearchTeamItem extends StatefulWidget {
  const SearchTeamItem(this.team, {Key? key}) : super(key: key);
  final Team team;

  @override
  _SearchTeamItemState createState() => _SearchTeamItemState();
}

class _SearchTeamItemState extends State<SearchTeamItem> {
  @override
  Widget build(BuildContext context) {
    final searchUserProvider = Provider.of<SearchProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        color: ThemeSettings.grayColor,
        child: InkWell(
          onTap: () => searchUserProvider.selectTeam(widget.team),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.team.imageURL == null
                    ? Container()
                    : CachedNetworkImage(
                        imageUrl: widget.team.imageURL ?? "",
                        fit: BoxFit.cover,
                        height: 30,
                      ),
                Flexible(
                  child: Text(
                    widget.team.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text("${widget.team.members.length.toString()} medlemmar"),
                Spacer(),
                searchUserProvider.selectedTeam == widget.team
                    ? Icon(Icons.check, color: Colors.green)
                    : Icon(Icons.add_circle_outline_sharp)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
