import 'package:discorso/pages/account_settings_page.dart';
import 'package:discorso/pages/blocked_users_page.dart';
import 'package:discorso/pages/home_page.dart';
import 'package:discorso/pages/post_page.dart';
import 'package:discorso/pages/profile_page.dart';
import 'package:flutter/material.dart';

import '../models/post.dart';

void goUserPage(BuildContext context, String uid) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(uid: uid),
    ),
  );
}

void goPostPage(BuildContext context, Post post){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostPage(post: post,),),
  );
}

void goToBlockedUsersPage(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlockedUsersPage(), ),
  );
}

void goAccountSettingsPage(BuildContext context){
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AccountSettingsPage(), ),
  );
}

void goHomePage(BuildContext context) {
  Navigator.pushAndRemoveUntil(
    context, 
    MaterialPageRoute(
      builder: (context) => HomePage(), 
    ), 
    (route) => route.isFirst);
}