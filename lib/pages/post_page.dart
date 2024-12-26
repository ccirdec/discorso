import 'package:discorso/components/my_comment_tile.dart';
import 'package:discorso/components/my_post_tile.dart';
import 'package:discorso/helper/navigate_pages.dart';
import 'package:discorso/models/post.dart';
import 'package:discorso/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostPage extends StatefulWidget {
  final Post post;
  const PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    final allComments = listeningProvider.getComments(widget.post.id);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          MyPostTile(
              post: widget.post,
              onUserTap: () => goUserPage(context, widget.post.uid),
              onPostTap: () {}),
          allComments.isEmpty
              ? Center(
                  child: Text("No Comments yet.."),
                )
              : ListView.builder(
                  itemCount: allComments.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final comment = allComments[index];

                    return MyCommentTile(
                        comment: comment,
                        onUserTap: () => goUserPage(context, comment.uid));
                  },
                )
        ],
      ),
    );
  }
}
