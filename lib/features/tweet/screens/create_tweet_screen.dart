import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rope/core/common/loading_page.dart';
import 'package:rope/core/common/rouned_small_button.dart';
import 'package:rope/core/utils.dart';
import 'package:rope/features/auth/controller/auth_controller.dart';
import 'package:rope/features/tweet/controller/tweet_controller.dart';
import 'package:rope/theme/pallete.dart';

class CreateTweetScreen extends ConsumerStatefulWidget {
  const CreateTweetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateTweetScreenState();
}

class _CreateTweetScreenState extends ConsumerState<CreateTweetScreen> {
  final textEditingController = TextEditingController();
  List<File> images = [];

  void shareTweet() {
    ref.read(tweetControllerProvider.notifier).shareTweet(
          images: images,
          text: textEditingController.text,
          context: context,
        );
    textEditingController.text = "";
    images = [];
  }

  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isLoading = ref.watch(tweetControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
          iconSize: 30,
        ),
        actions: [
          RoundedSmallButton(
            onTap: shareTweet,
            label: "Rope",
            backgroundColor: Pallete.blueColor,
            textColor: Pallete.whiteColor,
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : SafeArea(
              child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.profileUrl),
                      radius: 30,
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        controller: textEditingController,
                        style: const TextStyle(fontSize: 22),
                        decoration: const InputDecoration(
                          hintText: "Whats happening?",
                          hintStyle: TextStyle(
                            color: Pallete.greyColor,
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                        ),
                        maxLines: null,
                      ),
                    ),
                  ],
                ),
                if (images.isNotEmpty)
                  CarouselSlider(
                    items: images.map(
                      (e) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: Image.file(e));
                      },
                    ).toList(),
                    options: CarouselOptions(
                      height: 400,
                      enableInfiniteScroll: false,
                    ),
                  )
              ],
            )),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Pallete.greyColor,
              width: 0.3,
            ),
          ),
        ),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.all(10).copyWith(left: 15, right: 15),
            child: GestureDetector(
              onTap: onPickImages,
              child: const Icon(
                Icons.photo_outlined,
                color: Pallete.blueColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
            child: const Icon(
              Icons.gif_box_outlined,
              color: Pallete.blueColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8).copyWith(left: 15, right: 15),
            child: const Icon(
              Icons.emoji_emotions_outlined,
              color: Pallete.blueColor,
            ),
          ),
        ]),
      ),
    );
  }
}
