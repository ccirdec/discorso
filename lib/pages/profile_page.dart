import 'package:discorso/components/my_bio_box.dart';
import 'package:discorso/components/my_input_alert_box.dart';
import 'package:discorso/components/my_post_tile.dart';
import 'package:discorso/helper/navigate_pages.dart';
import 'package:discorso/models/user.dart';
import 'package:discorso/services/auth/auth_service.dart';
import 'package:discorso/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final listeningProvider = Provider.of<DatabaseProvider>(context);

  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();

  final bioTextController = TextEditingController();

  bool _isloading = true;

  @override
  void initState() {
    super.initState();

    loadUser();
  }

  Future<void> loadUser() async {
    user = await databaseProvider.userProfile(widget.uid);

    setState(() {
      _isloading = false;
    });
  }

  void _showEditBioBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textController: bioTextController,
        hintText: "Edit bio..",
        onPressed: saveBio,
        onPressedText: "Save",
      ),
    );
  }

  Future<void> saveBio() async {
    setState(() {
      _isloading = true;
    });

    await databaseProvider.updateBio(bioTextController.text);

    await loadUser();

    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allUserPosts = listeningProvider.filterUserPosts(widget.uid);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        title: Text(_isloading ? '' : user!.name),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          Center(
            child: Text(
              _isloading ? '' : '@${user!.username}',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(25)),
              padding: const EdgeInsets.all(25),
              child: Icon(Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Bio",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: _showEditBioBox,
                  child: Icon(
                    Icons.create_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
          ),
          MyBioBox(text: _isloading ? '...' : user!.bio),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 25),
            child: Text(
              "Post",
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          allUserPosts.isEmpty
              ? const Center(
                  child: Text("No posts yet.."),
                )
              : ListView.builder(
                  itemCount: allUserPosts.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final post = allUserPosts[index];

                    return MyPostTile(
                      post: post,
                      onUserTap: () {},
                      onPostTap: () => goPostPage(context, post),
                    );
                  },
                )
        ],
      ),
    );
  }
}
