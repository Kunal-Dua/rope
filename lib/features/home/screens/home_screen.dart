import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/constants/constants.dart';
import 'package:rope/features/home/widgets/side_drawer.dart';
import 'package:rope/features/notification/screens/notification_screen.dart';
import 'package:rope/features/search/screens/search_screen.dart';
import 'package:rope/features/tweet/screens/create_tweet_screen.dart';
import 'package:rope/features/tweet/widgets/list_tweet.dart';
import 'package:rope/theme/pallete.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;
  void onPageChange(int index) {
    _page = index;
  }

  @override
  Widget build(BuildContext context) {
    // final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: _page == 0
          ? AppBar(
              title: Image.asset(
                Constants.appLogo,
                height: 40,
              ),
              centerTitle: true,
            )
          : null,
      drawer: const SideDrawer(),
      body: IndexedStack(
        index: _page,
        children: const [
          ListTweet(),
          SearchScreen(),
          NotificationScreen(),
        ],
      ),
      floatingActionButton: _page == 0
          ? FloatingActionButton(
              onPressed: (() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateTweetScreen()),
                );
              }),
              child: const Icon(
                Icons.add,
                color: Pallete.whiteColor,
                size: 28,
              ),
            )
          : null,
      bottomNavigationBar: CupertinoTabBar(
          backgroundColor: Pallete.backgroundColor,
          currentIndex: _page,
          onTap: onPageChange,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
              _page == 0 ? Icons.home : Icons.home_outlined,
              color: Pallete.whiteColor,
            )),
            BottomNavigationBarItem(
                icon: Icon(
              _page == 1 ? Icons.search : Icons.search_outlined,
              color: Pallete.whiteColor,
            )),
            BottomNavigationBarItem(
                icon: Icon(
              _page == 2 ? Icons.notifications : Icons.notifications_outlined,
              color: Pallete.whiteColor,
            )),
          ]),
    );
  }
}
