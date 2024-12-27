import 'package:discorso/components/my_user_tile.dart';
import 'package:discorso/services/database/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final databaseProvider =
        Provider.of<DatabaseProvider>(context, listen: false);
    final listeningProvider = Provider.of<DatabaseProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                hintText: "Seacrh Users...",
                hintStyle:
                    TextStyle(color: Theme.of(context).colorScheme.primary),
                border: InputBorder.none),
            onChanged: (value) {
              if (value.isNotEmpty) {
                databaseProvider.searchUsers(value);
              } else {
                databaseProvider.searchUsers("");
              }
            },
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: listeningProvider.searchResult.isEmpty
            ? Center(
                child: Text("No users found.."),
              )
            : ListView.builder(
                itemCount: listeningProvider.searchResult.length,
                itemBuilder: (context, index) {
                  final user = listeningProvider.searchResult[index];

                  return MyUserTile(user: user);
                }));
  }
}
