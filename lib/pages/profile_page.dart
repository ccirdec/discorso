import 'package:discorso/models/user.dart';
import 'package:discorso/services/auth/auth_service.dart';
import 'package:discorso/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({
    super.key,
    required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  late final databaseProvider = 
    Provider.of<DatabaseProvider>(context, listen: false);

  UserProfile? user;
  String currentUserId = AuthService().getCurrentUid();

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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(centerTitle: true,
        title: Text(_isloading ? '' : user!.name),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          Center(
            child: Text( _isloading ? '' : '@${user!.username}',
             style: TextStyle(color:Theme.of(context).colorScheme.primary),
             ),
          ),
          
          const SizedBox(height: 25,),

          Center(
            child: Container(
              decoration: BoxDecoration(
                color:Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(25)
              ),
              padding: const EdgeInsets.all(25),
              child: Icon(
                Icons.person,
                size: 72,
                color:Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(height: 25,),
        ],
      ),
    );
  }
}