import 'package:flutter/material.dart';
import 'package:myspots/src/services/backend.dart';
import 'package:myspots/src/presentation/widgets/avatars/ReelAvator.dart';
import 'package:myspots/src/presentation/widgets/buttons/HashTagButton.dart';
import 'package:myspots/src/presentation/widgets/buttons/RoundedIconTextButton.dart';
import 'package:myspots/src/presentation/widgets/loaders/CircularLoader.dart';
import 'package:myspots/src/presentation/widgets/reels/ReelGridView.dart';
import 'package:myspots/src/presentation/widgets/typography/BodyText.dart';
import 'package:myspots/src/presentation/widgets/typography/MainHeading.dart';
import 'package:provider/provider.dart';
import 'package:myspots/src/services/models.dart' as model;

enum PostsAboutType { posts, about }

class MyProfileView extends StatefulWidget {
  const MyProfileView({Key? key});

  @override
  State<MyProfileView> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<MyProfileView> {
  PostsAboutType postsAboutTypeView = PostsAboutType.posts;

  @override
  Widget build(BuildContext context) {
    final user = context.read<model.User>();
    final currentlySelectedUserId = user.id;

    return FutureBuilder(
      future: BackendService().getAnyUser(currentlySelectedUserId),
      builder: (context, snapshot) {
        // If an error occurred while fetching data
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // When the future completes successfully
        if (snapshot.connectionState == ConnectionState.done) {
          final user = snapshot.data!;

          return Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  SizedBox(height: 12),
                  buildProfileRow(user),
                  SizedBox(height: 24),
                  buildSegmentedButton(),
                  SizedBox(height: 10),
                  buildPostsOrAboutSection(currentlySelectedUserId, user),
                ],
              ),
            ),
          );
        }

        // While waiting for the future to complete
        return const CircularLoader();
      },
    );
  }

  Widget buildProfileRow(model.User user) {
    return Row(
      children: [
        ReelAvatar(imageUrl: user.avatarUrl),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              MainHeading(text: user.fullName),
              const SizedBox(height: 24),
              // MainHeading(text: user.profileText),
              Text(user.profileText, maxLines: 3),
              // HeadingElement.h4(text: user.profileText),
              // const SizedBox(height: 8),
              // BodyText(text: user.profileText),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSegmentedButton() {
    return SegmentedButton<PostsAboutType>(
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
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              Color(0xFF88B930).withOpacity(0.7)),
          padding: const MaterialStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 20, vertical: 4)),
          foregroundColor: MaterialStatePropertyAll(Color(0xFF132B32)),
          iconColor: MaterialStatePropertyAll(Colors.white)),
      onSelectionChanged: (Set<PostsAboutType> newSelection) {
        setState(() {
          postsAboutTypeView = newSelection.first;
        });
      },
    );
  }

  Widget buildPostsOrAboutSection(
      String currentlySelectedUserId, model.User user) {
    if (postsAboutTypeView == PostsAboutType.posts) {
      return FutureBuilder(
        future: BackendService().getUserReels(currentlySelectedUserId),
        builder: (context, snapshot) {
          // If an error occurred while fetching data
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // When the future completes successfully
          if (snapshot.connectionState == ConnectionState.done) {
            final reels = snapshot.data!;
            return Expanded(
              child: ReelGridView(
                reels: reels,
              ),
            );
          }

          // While waiting for the future to complete
          return const CircularLoader();
        },
      );
    } else {
      return Expanded(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildFollowersFollowingRow(user),
              // SizedBox(height: 16),
              // MainHeading(text: 'Following tags:'),
              // SizedBox(height: 8),
              // buildTrendsWrap(),
            ],
          ),
        ),
      );
    }
  }

  Widget buildFollowersFollowingRow(model.User user) {
    double width_screen = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildFollowersColumn(user),
        SizedBox(width: width_screen / 5),
        buildFollowingColumn(user),
      ],
    );
  }

  Widget buildFollowersColumn(model.User user) {
    return Column(
      children: [
        Text(user.followers.toString(), textScaleFactor: 3),
        SizedBox(height: 2),
        Text(
          'Followers',
          style: TextStyle(color: Colors.grey[500]),
          textScaleFactor: 1.25,
        ),
      ],
    );
  }

  Widget buildFollowingColumn(model.User user) {
    return Column(
      children: [
        Text(user.following.toString(), textScaleFactor: 3),
        SizedBox(height: 2),
        Text(
          'Following',
          style: TextStyle(color: Colors.grey[500]),
          textScaleFactor: 1.25,
        ),
      ],
    );
  }

  Widget buildTrendsWrap() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
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
    );
  }
}
