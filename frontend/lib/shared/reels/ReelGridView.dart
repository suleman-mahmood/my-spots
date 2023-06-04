import 'package:flutter/material.dart';
import 'package:myspots/services/models.dart' as model;
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
        crossAxisCount: 3,
        childAspectRatio: 9 / 16, // Width to height ratio of the reel view
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
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
          onTap: () {
            context.read<model.AppState>().setCurrentlySelectedReels(reels);
            Navigator.pushNamed(context, '/view-reels');
          },
        );
      },
    );
  }
}
