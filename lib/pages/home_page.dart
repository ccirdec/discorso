import 'package:discorso/components/my_drawer.dart';
import 'package:discorso/components/my_input_alert_box.dart';
import 'package:discorso/components/my_post_tile.dart';
import 'package:discorso/helper/navigate_pages.dart';
import 'package:discorso/models/post.dart';
import 'package:discorso/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final listeningProvider = Provider.of<DatabaseProvider>(context);

  late final databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);


  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    loadAllPosts();
  }

  Future<void> loadAllPosts() async {
    await databaseProvider.loadAllPosts();
  }

  void _openPostMessageBox(){
    showDialog(
      context: context, 
      builder: (context)=> MyInputAlertBox(
        textController: _messageController, 
        hintText: "What's on your mind", 
        onPressed: () async {
          await postMessage(_messageController.text);
        }, 
        onPressedText: "Post"
        ),
    );
  }

  Future<void> postMessage(String message) async{
    await databaseProvider.postMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: MyDrawer(),
      appBar: AppBar(centerTitle: true,
          title: Image.asset(
            'assets/logo.png', 
            height: 40,
          ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openPostMessageBox,
        child: Icon(Icons.message),
        ),
      
      body: _buildPostList(listeningProvider.allPost),
    );
  }
  Widget _buildPostList(List<Post> posts){
    return posts.isEmpty
      ? 
      Center(
        child: Text("Nothing Here..", style: TextStyle(color: Theme.of(context).colorScheme.primary,))
      )
      :
      ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
        final post = posts[index];

        return MyPostTile(
          post: post,
          onUserTap:() => goUserPage(context, post.uid),
          onPostTap: () => goPostPage(context, post),
          );

      });
  } 
}
