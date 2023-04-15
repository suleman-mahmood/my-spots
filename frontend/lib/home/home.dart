import 'package:flutter/material.dart';
import 'package:myspots/shared/avatars/ProfileAvator.dart';
import 'package:myspots/shared/buttons/HashTagButton.dart';
import 'package:myspots/shared/buttons/PrimaryButton.dart';
import 'package:myspots/shared/buttons/RoundedIconTextButton.dart';
import 'package:myspots/shared/layouts/HomeLayout.dart';
import 'package:myspots/shared/typography/BodyText.dart';
import 'package:myspots/shared/typography/MainHeading.dart';

enum ReelsType { explore, following }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ReelsType reelsTypeView = ReelsType.explore;
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return HomeLayout(
      children: [
        // Explore and following toggle buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SegmentedButton<ReelsType>(
              segments: const <ButtonSegment<ReelsType>>[
                ButtonSegment<ReelsType>(
                  value: ReelsType.explore,
                  label: BodyText(text: 'Explore'),
                ),
                ButtonSegment<ReelsType>(
                  value: ReelsType.following,
                  label: BodyText(text: 'Following'),
                ),
              ],
              selected: <ReelsType>{reelsTypeView},
              onSelectionChanged: (Set<ReelsType> newSelection) {
                setState(() {
                  reelsTypeView = newSelection.first;
                });
              },
            ),
          ],
        ),
        Expanded(
          child: PageView(
            scrollDirection: Axis.vertical,
            children: [
              ReelView(),
              ReelView(),
              ReelView(),
            ],
            controller: controller,
          ),
        ),
      ],
    );
  }
}

class Comment extends StatelessWidget {
  const Comment({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileAvatar(
          imageUrl:
              'https://images.unsplash.com/photo-1635107510862-53886e926b74?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MainHeading(text: 'Ben Johns'),
            Container(
              width: 150,
              child: Flexible(
                child: BodyText(
                  text:
                      'Yes I agree this place has the best pasta I have ever had.',
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            Icon(Icons.heart_broken),
            BodyText(text: '40'),
          ],
        ),
      ],
    );
  }
}

class ReelView extends StatelessWidget {
  const ReelView({super.key});

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const MainHeading(text: '23 comments'),
                SizedBox(height: 10),
                Comment(),
                Comment(),
                Comment(),
                Comment(),
                Comment(),
                Comment(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const MainHeading(text: 'Report'),
                SizedBox(height: 10),
                BodyText(text: 'Please select a reason'),
                Card(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: BodyText(text: 'Animal cruelty'),
                  ),
                ),
                Card(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: BodyText(text: 'Dangerous place or individual'),
                  ),
                ),
                Card(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: BodyText(text: 'Self harm / suicide'),
                  ),
                ),
                PrimaryButton(buttonText: 'Report', onPressed: () => {}),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          // Profile information and stuff
          Row(
            children: [
              GestureDetector(
                child: ProfileAvatar(
                  imageUrl:
                      'https://images.unsplash.com/photo-1635107510862-53886e926b74?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
                ),
                onTap: () => {Navigator.pushNamed(context, '/profile')},
              ),
              Column(
                children: [
                  GestureDetector(
                    child: BodyText(text: 'Mia Cooper'),
                    onTap: () => {Navigator.pushNamed(context, '/profile')},
                  ),
                  BodyText(text: '6 hours ago'),
                ],
              ),
              Expanded(child: Container()),
              RoundedIconButton(
                icon: Icons.person_add,
                text: 'Follow',
                onPressed: () {},
              ),
            ],
          ),
          // All the available space for video
          Expanded(child: Container()),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // tags
                  Row(
                    children: [
                      TranslucentGreyButton(
                        text: 'food',
                        onPressed: () {},
                      ),
                      TranslucentGreyButton(
                        text: 'cafe',
                        onPressed: () {},
                      ),
                    ],
                  ),
                  // description fix error here
                  Container(
                    width: 300,
                    child: Flexible(
                      child: BodyText(
                        text:
                            'Take only memories, leave only footprints. To travel, to experience and learn: that is to live...',
                      ),
                    ),
                  ),
                  // location
                  Row(
                    children: [
                      Icon(Icons.location_pin),
                      BodyText(text: 'Capriccio Cafe, Rome, Italy'),
                    ],
                  ),
                ],
              ),
              Expanded(child: Container()),
              Column(
                children: [
                  // Bookmark icon
                  Icon(Icons.bookmark),
                  // Heart icon
                  Icon(Icons.heart_broken),
                  BodyText(text: '40'),
                  // Comments icon
                  GestureDetector(
                    child: Icon(Icons.comment),
                    onTap: () => {_showCommentsSheet(context)},
                  ),
                  BodyText(text: '23'),
                  // More icon
                  GestureDetector(
                    child: Icon(Icons.report),
                    onTap: () => {_showReportSheet(context)},
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
