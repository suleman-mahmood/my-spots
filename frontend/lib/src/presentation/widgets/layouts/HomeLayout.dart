import 'package:flutter/material.dart';
import 'package:myspots/src/presentation/views/create_reels_view.dart';
import 'package:myspots/src/presentation/views/home_view.dart';
import 'package:myspots/src/presentation/views/my_profile_view.dart';
import 'package:myspots/src/presentation/views/profile_view.dart';
import 'package:myspots/src/presentation/views/saved_view.dart';
import 'package:myspots/src/presentation/views/search_reels_view.dart';
import 'package:myspots/src/presentation/widgets/typography/BodyText.dart';
import 'package:provider/provider.dart';
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
        backgroundColor: widget.backgroundColor,
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
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.save),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
