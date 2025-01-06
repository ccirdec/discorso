import 'package:flutter/material.dart';

class MyProfileStats extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTapFollowers;
  final void Function()? onTapFollowing;

  const MyProfileStats({
    super.key,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    this.onTapFollowers,
    this.onTapFollowing,
  });

  @override
  Widget build(BuildContext context) {
    var textStyleForCount = TextStyle(
        fontSize: 20, color: Theme.of(context).colorScheme.inversePrimary);

    var textStyleForText =
        TextStyle(color: Theme.of(context).colorScheme.primary);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100,
          child: Column(
            children: [
              Text(
                postCount.toString(),
                style: textStyleForCount,
              ),
              Text("Posts", style: textStyleForText)
            ],
          ),
        ),
        GestureDetector(
          onTap: onTapFollowers,
          child: SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followerCount.toString(), style: textStyleForCount),
                Text("Followers", style: textStyleForText)
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: onTapFollowing,
          child: SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followingCount.toString(), style: textStyleForCount),
                Text("Following", style: textStyleForText)
              ],
            ),
          ),
        )
      ],
    );
  }
}
