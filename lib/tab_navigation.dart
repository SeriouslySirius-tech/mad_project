import 'package:flutter/material.dart';
import 'package:mad_project/providers/files.dart';
import 'package:mad_project/favourites_page.dart';
import 'package:mad_project/floating_action_picker.dart';
import 'package:mad_project/my_home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mad_project/providers/favourite_docs_provider.dart';

class TabNavigation extends ConsumerStatefulWidget {
  const TabNavigation({super.key});

  @override
  ConsumerState<TabNavigation> createState() {
    return _TabNavigationState();
  }
}

class _TabNavigationState extends ConsumerState<TabNavigation> {
  int currentIndex = 0;

  void selectPage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final files = ref.watch(filesProvider);
    final favouriteFiles = ref.watch(favouriteDocsProvider);
    Widget activePage = MyHomePage(files: files);
    var activePageTitle = "Recent Notes";

    if (currentIndex == 1) {
      activePage = FavouritesPage(favFiles: favouriteFiles);
      activePageTitle = "Favourites";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      floatingActionButton: const FloatingActionPicker(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.timelapse),
              label: 'Recent',
              activeIcon: Icon(
                Icons.timelapse,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              )),
          BottomNavigationBarItem(
              icon: const Icon(Icons.favorite_rounded),
              label: "Favourites",
              activeIcon: Icon(
                Icons.favorite_rounded,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              )),
        ],
      ),
    );
  }
}
