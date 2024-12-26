import 'package:discorso/models/comments.dart';
import 'package:discorso/services/auth/auth_service.dart';
import 'package:discorso/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCommentTile extends StatelessWidget {
  final Comment comment;
  final void Function()? onUserTap;

  const MyCommentTile(
      {super.key, required this.comment, required this.onUserTap});

  void _showOptions(BuildContext context) {
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnComment = comment.uid == currentUid;

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                if (isOwnComment)
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text("Delete"),
                    onTap: () async {
                      Navigator.pop(context);
                      await Provider.of<DatabaseProvider>(context,
                              listen: false)
                          .deleteComments(comment.id, comment.postId);
                    },
                  )
                else ...[
                  ListTile(
                      leading: const Icon(Icons.flag),
                      title: const Text("Report"),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                  ListTile(
                    leading: const Icon(Icons.block),
                    title: const Text("Block User"),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )
                ],
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text("Cancel"),
                  onTap: () => Navigator.pop(context),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onUserTap,
            child: Row(
              children: [
                Icon(Icons.person,
                    color: Theme.of(context).colorScheme.inversePrimary),
                SizedBox(width: 10),
                Text(comment.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 5),
                Text('@${comment.username}'),
                Spacer(),
                GestureDetector(
                    onTap: () => _showOptions(context),
                    child: Icon(
                      Icons.more_horiz,
                      color: Theme.of(context).colorScheme.primary,
                    )),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            comment.message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
