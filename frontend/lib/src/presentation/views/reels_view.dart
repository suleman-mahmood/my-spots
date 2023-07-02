import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:myspots/src/config/router/app_router.dart';
import 'package:myspots/src/presentation/widgets/loaders/CircularLoader.dart';
import 'package:myspots/src/services/backend.dart';
import 'package:myspots/src/presentation/widgets/avatars/ProfileAvator.dart';
import 'package:myspots/src/presentation/widgets/buttons/HashTagButton.dart';
import 'package:myspots/src/presentation/widgets/buttons/RoundedIconTextButton.dart';
import 'package:myspots/src/presentation/widgets/inputs/CommentInput.dart';
import 'package:myspots/src/presentation/widgets/typography/BodyText.dart';
import 'package:myspots/src/presentation/widgets/typography/MainHeading.dart';
import 'package:myspots/src/services/models.dart' as model;
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

@RoutePage()
class ReelsView extends StatefulWidget {
  const ReelsView({super.key});

  @override
  State<ReelsView> createState() => _ViewReelsScreenState();
}

class _ViewReelsScreenState extends State<ReelsView> {
  PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final reels = context.read<model.AppState>().currentlySelectedReels;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<model.AppState>(builder: (context, appState, child) {
          if (appState.isLoading) {
            return const CircularProgressIndicator();
          }
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: reels.length,
                  itemBuilder: (context, index) {
                    return ReelView(reel: reels[index]);
                  },
                  controller: controller,
                ),
              ),
              appState.erroMessage.isNotEmpty
                  ? BodyText(
                      text: appState.erroMessage,
                      textColor: Colors.red,
                    )
                  : const SizedBox.shrink(),
            ],
          );
        }),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final model.Comment comment;

  const CommentWidget({
    required this.comment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: BackendService().getAnyUser(comment.userId),
      builder: (context, snapshot) {
        // If an error occurred while fetching data
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // When the future completes successfully
        if (snapshot.connectionState == ConnectionState.done) {
          final user = snapshot.data!;

          return Row(
            children: [
              ProfileAvatar(imageUrl: user.avatarUrl),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainHeading(text: user.fullName),
                  Container(
                    width: 150,
                    child: Flexible(
                      child: BodyText(
                        text: comment.commentText,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ],
              ),
              // TODO: later implementation of adding hearts to comments
              // Column(
              //   children: [
              //     Icon(Icons.heart_broken),
              //     BodyText(text: '40'),
              //   ],
              // ),
            ],
          );
        }

        // While waiting for the future to complete
        return const CircularLoader();
      },
    );
  }
}

class ReelView extends StatefulWidget {
  final model.Reel reel;

  ReelView({super.key, required this.reel});

  @override
  State<ReelView> createState() => _ReelViewState();
}

class _ReelViewState extends State<ReelView> {
  late VideoPlayerController _controller;
  String newComment = '';
  List<String> reportReasons = [
    'Animal cruelty',
    'Dangerous place or individual',
    'Self harm / suicide',
    'Inappropriate content',
    'Spam',
    'Hate speech',
    'Violence',
    'Other',
  ];

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(widget.reel.videoUrl)
      ..initialize().then((_) async {
        await _controller.play();
        await _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showCommentsSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FutureBuilder(
            future: BackendService().getReelComments(widget.reel.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              // When the future completes successfully
              if (snapshot.connectionState == ConnectionState.done) {
                final comments = snapshot.data!;

                if (comments.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 50,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          MainHeading(text: 'No comments'),
                          const SizedBox(height: 10),
                          CommentInput(
                            labelText: 'Add comment...',
                            prefixIcon: const Icon(Icons.comment_bank_outlined),
                            onChanged: (v) => newComment = v,
                            validator: (commentValue) {
                              if (commentValue == null) {
                                return "Please enter a comment";
                              }
                              return null;
                            },
                            onSubmit: () {
                              BackendService().commentReel(
                                widget.reel.id,
                                newComment,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        MainHeading(text: '${widget.reel.comments} comments'),
                        const SizedBox(height: 10),
                        ...comments
                            .map((comm) => CommentWidget(comment: comm))
                            .toList(),
                        CommentInput(
                          labelText: 'Add comment...',
                          prefixIcon: const Icon(Icons.comment_bank_outlined),
                          onChanged: (v) => newComment = v,
                          validator: (commentValue) {
                            if (commentValue == null) {
                              return "Please enter a comment";
                            }
                            return null;
                          },
                          onSubmit: () {
                            BackendService().commentReel(
                              widget.reel.id,
                              newComment,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              // While waiting for the future to complete
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 50,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MainHeading(text: 'No comments'),
                      const SizedBox(height: 10),
                      CommentInput(
                        labelText: 'Add comment...',
                        prefixIcon: const Icon(Icons.comment_bank_outlined),
                        onChanged: (v) => newComment = v,
                        validator: (commentValue) {
                          if (commentValue == null) {
                            return "Please enter a comment";
                          }
                          return null;
                        },
                        onSubmit: () {
                          BackendService().commentReel(
                            widget.reel.id,
                            newComment,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            });
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
                MainHeading(text: 'Report'),
                SizedBox(height: 10),
                BodyText(text: 'Please select a reason'),
                ...reportReasons
                    .map((reason) => GestureDetector(
                          child: Card(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: BodyText(text: reason),
                            ),
                          ),
                          onTap: () {
                            BackendService().reportReel(
                              widget.reel.id,
                              reason,
                            );
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleProfileTap(String userId) async {
    context.read<model.AppState>().setCurrentlySelectedUser(userId);
    // await _controller.pause();
    context.router.replace(ProfileRoute());
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Stack(
        children: [
          VideoPlayer(_controller),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20,
            ),
            child: Column(
              children: [
                // Profile information and stuff
                FutureBuilder(
                  future: BackendService().getAnyUser(widget.reel.userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    // When the future completes successfully
                    if (snapshot.connectionState == ConnectionState.done) {
                      final user = snapshot.data!;
                      return Row(
                        children: [
                          GestureDetector(
                            child: ProfileAvatar(
                              imageUrl: user.avatarUrl,
                            ),
                            onTap: () => _handleProfileTap(user.id),
                          ),
                          SizedBox(width: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                child: BodyText(
                                  text: user.fullName,
                                  textColor: Colors.white,
                                ),
                                onTap: () => _handleProfileTap(user.id),
                              ),
                              BodyText(
                                text: timeago.format(widget.reel.createdAt),
                                textColor: Colors.white,
                              ),
                            ],
                          ),
                          Expanded(child: Container()),
                          RoundedIconButton(
                            icon: Icons.person_add,
                            text: 'Follow',
                            onPressed: () {
                              BackendService().followUser(widget.reel.userId);
                            },
                          ),
                        ],
                      );
                    }

                    return const CircularLoader();
                  },
                ),
                // All the available space for video
                Expanded(child: Container()),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // tags
                        Row(
                          children: widget.reel.tags
                              .map<TranslucentGreyButton>(
                                (tag) => TranslucentGreyButton(
                                  text: tag.tagName,
                                  onPressed:
                                      () {}, // TODO: redirect to tag page
                                ),
                              )
                              .toList(),
                        ),
                        // description fix error here
                        Container(
                          width: 300,
                          child: Flexible(
                            child: BodyText(
                              text: widget.reel.description,
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                        // location
                        Row(
                          children: [
                            Icon(Icons.location_pin, color: Colors.white),
                            BodyText(
                              text: widget.reel.spotName,
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      children: [
                        // Bookmark icon
                        GestureDetector(
                          child: Icon(
                            Icons.bookmark,
                            color: Colors.lightBlue,
                          ),
                          onTap: () =>
                              {BackendService().favouriteReel(widget.reel.id)},
                        ),
                        SizedBox(height: 10),

                        // Heart icon
                        GestureDetector(
                          child: Icon(
                            Icons.heart_broken,
                            color: Colors.pink,
                          ),
                          onTap: () => {
                            BackendService().likeReel(widget.reel.id),
                          },
                        ),
                        BodyText(
                          text: widget.reel.likes.toString(),
                          textColor: Colors.white,
                        ),

                        SizedBox(height: 10),
                        // Comments icon
                        GestureDetector(
                          child: Icon(
                            Icons.comment,
                            color: Colors.green,
                          ),
                          onTap: () => {_showCommentsSheet(context)},
                        ),
                        BodyText(
                          text: widget.reel.comments.toString(),
                          textColor: Colors.white,
                        ),

                        SizedBox(height: 10),
                        // More icon
                        GestureDetector(
                          child: Icon(
                            Icons.report,
                            color: Colors.white,
                          ),
                          onTap: () => {_showReportSheet(context)},
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
