import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moveness/app_theme.dart';
import 'package:moveness/models/user.dart';
import 'package:moveness/providers/search.dart';
import 'package:provider/provider.dart';

class SearchUserItem extends StatefulWidget {
  const SearchUserItem(this.user, this.challengeUser, {Key? key})
      : super(key: key);
  final User user;
  final bool challengeUser;

  @override
  _SearchUserItemState createState() => _SearchUserItemState();
}

class _SearchUserItemState extends State<SearchUserItem> {
  @override
  Widget build(BuildContext context) {
    final searchUserProvider = Provider.of<SearchProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        color: ThemeSettings.grayColor,
        child: InkWell(
          onTap: () {
            if (searchUserProvider.selectedUsers?.contains(widget.user) ==
                true) {
              searchUserProvider.removeUser(widget.user);
            } else {
              if (widget.challengeUser)
                searchUserProvider.selectedUsers?.clear();

              searchUserProvider.addUser(widget.user);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.user.profileImageURL,
                  fit: BoxFit.cover,
                  height: 30,
                ),
                Flexible(
                  child: Text(
                    widget.user.username,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Spacer(),
                searchUserProvider.selectedUsers?.contains(widget.user) == true
                    ? Icon(Icons.check, color: Colors.green)
                    : Icon(Icons.add_circle_outline_sharp),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
