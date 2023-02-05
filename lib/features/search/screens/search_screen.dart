import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/common/error_page.dart';
import 'package:rope/core/common/loading_page.dart';
import 'package:rope/features/search/controller/search_controller.dart';
import 'package:rope/features/search/screens/search_tile.dart';
import 'package:rope/theme/pallete.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  final appbarTextFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: const BorderSide(
      color: Pallete.searchBarColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: SizedBox(
        height: 50,
        child: TextField(
          controller: searchController,
          onSubmitted: (value) {
            setState(() {
              isShowUser = true;
            });
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10).copyWith(
              left: 20,
            ),
            fillColor: Pallete.searchBarColor,
            filled: true,
            enabledBorder: appbarTextFieldBorder,
            focusedBorder: appbarTextFieldBorder,
            hintText: "Search",
          ),
          autofocus: true,
        ),
      )),
      body: isShowUser
          ? ref.watch(searchUserProvider(searchController.text)).when(
                data: (users) {
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: ((BuildContext context, int index) {
                      final user = users[index];
                      return SearchTile(
                        user: user,
                      );
                    }),
                  );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: (() => const Loader()),
              )
          : const SizedBox(),
    );
  }
}
