
import 'package:beamer/beamer.dart';
import 'package:bottom_rail_navigation_multiple_beamers/routing/articles_location.dart';
import 'package:bottom_rail_navigation_multiple_beamers/routing/books_location.dart';
import 'package:flutter/material.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  AppScreenState createState() => AppScreenState();
}

class AppScreenState extends State<AppScreen> {
  late int currentIndex;

  final routerDelegates = [
    BeamerDelegate(
      initialPath: '/books',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('books')) {
          return BooksLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
    BeamerDelegate(
      initialPath: '/articles',
      locationBuilder: (routeInformation, _) {
        if (routeInformation.location!.contains('articles')) {
          return ArticlesLocation(routeInformation);
        }
        return NotFound(path: routeInformation.location!);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
            child: IndexedStack(
              index: currentIndex,
              children: [
                Beamer(
                  routerDelegate: routerDelegates[0],
                ),
                Beamer(
                  routerDelegate: routerDelegates[1],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(label: 'Books', icon: Icon(Icons.book)),
          BottomNavigationBarItem(label: 'Articles', icon: Icon(Icons.article)),
        ],
        onTap: _navigateTo,
      ),
    );
  }

  void _navigateTo(index) {
    if (index != currentIndex) {
      setState(() => currentIndex = index);
      routerDelegates[currentIndex].update(rebuild: false);
    }
  }

  // TODO: what does this do?
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uriString = Beamer.of(context).configuration.location!;
    currentIndex = uriString.contains('books') ? 0 : 1;
  }
}
