import 'package:flutter/material.dart';
import 'package:myspots/src/presentation/views/create_reels_view.dart';
import 'package:myspots/src/presentation/views/home_view.dart';
import 'package:myspots/src/presentation/views/my_profile_view.dart';
import 'package:myspots/src/presentation/views/profile_view.dart';
import 'package:myspots/src/presentation/views/saved_view.dart';
import 'package:myspots/src/presentation/views/search_reels_view.dart';
import 'package:myspots/src/presentation/widgets/typography/BodyText.dart';
import 'package:provider/provider.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:myspots/src/services/models.dart' as model;

class HomeLayout extends StatefulWidget {
  final Color backgroundColor;

  const HomeLayout({
    Key? key,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int _selectedIndex = 0;

  List<Widget> pageList = [
    HomeView(),
    SearchReelsView(),
    CreateReelsView(),
    SavedView(),
    MyProfileView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            _selectedIndex == 2 ? Colors.black : widget.backgroundColor,
        body: Consumer<model.AppState>(builder: (context, appState, child) {
          if (appState.isLoading) {
            return const CircularProgressIndicator();
          }
          return Column(
            children: [
              pageList.elementAt(_selectedIndex),
              // Column(
              //   children: [Text('Wow')],
              // ),
              appState.erroMessage.isNotEmpty
                  ? BodyText(
                      text: appState.erroMessage,
                      textColor: Colors.red,
                    )
                  : const SizedBox.shrink(),
            ],
          );
        }),
        bottomNavigationBar: DotNavigationBar(
          marginR: const EdgeInsets.only(bottom: 0),
          splashColor: Colors.orange[200],
          enablePaddingAnimation: false,
          borderRadius: 0,
          backgroundColor:
              _selectedIndex == 2 ? Colors.grey[700] : Colors.white,
          items: [
            DotNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              selectedColor: Colors.orange[200],
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.search),
              selectedColor: Colors.orange[200],
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined),
              selectedColor: Colors.orange[200],
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.save_as_outlined),
              selectedColor: Colors.orange[200],
            ),
            DotNavigationBarItem(
              icon: Icon(Icons.person_outlined),
              selectedColor: Colors.orange[200],
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[200],
          unselectedItemColor:
              _selectedIndex == 2 ? Colors.white : Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
