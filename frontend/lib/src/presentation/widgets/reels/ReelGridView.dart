import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:myspots/src/config/router/app_router.dart';
import 'package:myspots/src/presentation/widgets/typography/BodyText.dart';
import 'package:myspots/src/services/models.dart' as model;
import 'package:timeago/timeago.dart' as timeago;
import 'package:provider/provider.dart';

class ReelGridView extends StatelessWidget {
  final List<model.Reel> reels;

  ReelGridView({required this.reels});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      itemCount: reels.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 9 / 14, // Width to height ratio of the reel view
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: NetworkImage(
                        reels[index].thumbnailUrl,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Colors.white.withOpacity(0.5)),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          // toString(reels[index].createdAt),
                          // print(reels[index].createdAt),
                          timeago.format(reels[index].createdAt),
                          textScaleFactor: 1.15,
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onTap: () {
            context.read<model.AppState>().setCurrentlySelectedReels(reels);
            context.router.push(ReelsRoute());
          },
        );
      },
    );
  }
}
