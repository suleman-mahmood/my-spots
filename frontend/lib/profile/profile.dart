import 'package:flutter/material.dart';
import 'package:myspots/shared/avatars/ReelAvator.dart';
import 'package:myspots/shared/buttons/HashTagButton.dart';
import 'package:myspots/shared/buttons/RoundedIconTextButton.dart';
import 'package:myspots/shared/layouts/HomeLayout.dart';
import 'package:myspots/shared/reels/ReelGridView.dart';
import 'package:myspots/shared/typography/BodyText.dart';
import 'package:myspots/shared/typography/MainHeading.dart';

enum PostsAboutType { posts, about }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  PostsAboutType postsAboutTypeView = PostsAboutType.posts;

  @override
  Widget build(BuildContext context) {
    return HomeLayout(
      children: [
        Row(
          children: [
            ReelAvatar(
              imageUrl:
                  'https://images.unsplash.com/photo-1635107510862-53886e926b74?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MainHeading(text: 'Mia Cooper'),
                SizedBox(height: 10),
                BodyText(text: 'Industrial Engineer & Foodie'),
                SizedBox(height: 20),
                RoundedIconButton(
                  icon: Icons.person_add,
                  text: 'Follow',
                  onPressed: () {},
                ),
              ],
            )
          ],
        ),
        SegmentedButton<PostsAboutType>(
          segments: const <ButtonSegment<PostsAboutType>>[
            ButtonSegment<PostsAboutType>(
              value: PostsAboutType.posts,
              label: Text('Posts'),
            ),
            ButtonSegment<PostsAboutType>(
              value: PostsAboutType.about,
              label: Text('About'),
            ),
          ],
          selected: <PostsAboutType>{postsAboutTypeView},
          onSelectionChanged: (Set<PostsAboutType> newSelection) {
            setState(() {
              postsAboutTypeView = newSelection.first;
            });
          },
        ),
        Visibility(
          visible: postsAboutTypeView == PostsAboutType.posts,
          child: Expanded(
            child: ReelGridView(
              reelUrls: [
                'https://images.unsplash.com/photo-1635107510862-53886e926b74?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
                'https://images.unsplash.com/photo-1635107510862-53886e926b74?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
                'https://images.unsplash.com/photo-1635107510862-53886e926b74?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
                'https://images.unsplash.com/photo-1635107510862-53886e926b74?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
                'https://images.unsplash.com/photo-1635107510862-53886e926b74?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
                'https://images.unsplash.com/photo-1635107510862-53886e926b74?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
                'https://images.unsplash.com/photo-1635107510862-53886e926b74?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
                'https://images.unsplash.com/photo-1635107510862-53886e926b74?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=735&q=80',
              ],
            ),
          ),
        ),
        Visibility(
          visible: postsAboutTypeView == PostsAboutType.about,
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        MainHeading(text: '520'),
                        BodyText(text: 'Followers'),
                      ],
                    ),
                    Column(
                      children: [
                        MainHeading(text: '250'),
                        BodyText(text: 'Following'),
                      ],
                    )
                  ],
                ),
                MainHeading(text: 'Following trends:'),
                Wrap(
                  spacing: 8.0, // Horizontal space between the buttons
                  runSpacing: 8.0, // Vertical space between the rows of buttons
                  children: [
                    TranslucentGreyButton(text: 'italy', onPressed: () => {}),
                    TranslucentGreyButton(text: 'food', onPressed: () => {}),
                    TranslucentGreyButton(text: 'cafe', onPressed: () => {}),
                    TranslucentGreyButton(text: 'coffee', onPressed: () => {}),
                    TranslucentGreyButton(text: 'boating', onPressed: () => {}),
                    TranslucentGreyButton(text: 'art', onPressed: () => {}),
                    TranslucentGreyButton(
                      text: 'photography',
                      onPressed: () => {},
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
