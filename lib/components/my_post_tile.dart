import 'package:discorso/components/my_input_alert_box.dart';
import 'package:discorso/helper/time_formatter.dart';
import 'package:discorso/models/post.dart';
import 'package:discorso/services/auth/auth_service.dart';
import 'package:discorso/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPostTile extends StatefulWidget {
  final Post post;
  final void Function()? onUserTap;
  final void Function()? onPostTap;
  const MyPostTile(
      {super.key,
      required this.post,
      required this.onUserTap,
      required this.onPostTap});

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();

    _loadComments();
  }

  void _toggleLikePost() async {
    try {
      await databaseProvider.toogleLike(widget.post.id);
    } catch (e) {
      print(e);
    }
  }

  final _commentController = TextEditingController();

  void _openNewCommentBox() {
    showDialog(
        context: context,
        builder: (context) => MyInputAlertBox(
            textController: _commentController,
            hintText: "Type a comments..",
            onPressed: () async {
              await _addComment();
            },
            onPressedText: "Post"));
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    try {
      await databaseProvider.addComment(
          widget.post.id, _commentController.text.trim());
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadComments() async {
    await databaseProvider.loadComments(widget.post.id);
  }

  void _showOptions() {
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnPost = widget.post.uid == currentUid;

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                if (isOwnPost)
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text("Delete"),
                    onTap: () async {
                      Navigator.pop(context);
                      await databaseProvider.deletePost(widget.post.id);
                    },
                  )
                else ...[
                  ListTile(
                      leading: const Icon(Icons.flag),
                      title: const Text("Report"),
                      onTap: () {
                        Navigator.pop(context);

                        _reportPostConfirmationBox();
                      }),
                  ListTile(
                    leading: const Icon(Icons.block),
                    title: const Text("Block User"),
                    onTap: () {
                      Navigator.pop(context);

                      _blockUserConfirmationBox();
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

  void _reportPostConfirmationBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Report Message"),
              content:
                  const Text("Are you sure you want to report this message?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                    onPressed: () async {
                      await databaseProvider.reportUser(
                          widget.post.id, widget.post.uid);

                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Message reported")));
                      Navigator.pop(context);
                    },
                    child: const Text("Report"))
              ],
            ));
  }

  void _blockUserConfirmationBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Block User"),
              content: const Text("Are you sure you want to Block this User?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                    onPressed: () async {
                      await databaseProvider.blockUser(widget.post.uid);

                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User blocked!")));
                      Navigator.pop(context);
                    },
                    child: const Text("Block"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    bool likedByCurrentUser =
        listeningProvider.isPostLikedByCurrentUser(widget.post.id);
    int likeCount = listeningProvider.getLikeCount(widget.post.id);

    int commentCount = listeningProvider.getComments(widget.post.id).length;

    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: widget.onUserTap,
              child: Row(
                children: [
                  Icon(Icons.person,
                      color: Theme.of(context).colorScheme.primary),
                  SizedBox(width: 10),
                  Text(widget.post.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 5),
                  Text('@${widget.post.username}'),
                  Spacer(),
                  GestureDetector(
                      onTap: _showOptions,
                      child: Icon(
                        Icons.more_horiz,
                        color: Theme.of(context).colorScheme.primary,
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.post.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _toggleLikePost,
                        child: likedByCurrentUser
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite_border,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        likeCount != 0 ? likeCount.toString() : '',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _openNewCommentBox,
                      child: Icon(
                        Icons.chat_bubble,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      commentCount != 0 ? commentCount.toString() : '',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    )
                  ],
                ),
                const Spacer(),
                Text(
                  formatTimeStamp(widget.post.timestamp),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
