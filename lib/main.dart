import 'package:beamer/beamer.dart';
import 'package:bottom_rail_navigation_multiple_beamers/books/book_details.dart';
import 'package:bottom_rail_navigation_multiple_beamers/books/books_screen.dart';
import 'package:bottom_rail_navigation_multiple_beamers/articles/article_details.dart';
import 'package:bottom_rail_navigation_multiple_beamers/articles/articles_screen.dart';
import 'package:bottom_rail_navigation_multiple_beamers/data.dart';
import 'package:flutter/material.dart';

// LOCATIONS
class BooksLocation extends BeamLocation<BeamState> {
  BooksLocation(RouteInformation routeInformation) : super(routeInformation);

  // BE CAREFUL: detail patterns must go AFTER all the others
  @override
  List<String> get pathPatterns => [
        '/books/specialBooks',
        '/books/specialBooks/:specialBookId',
        '/books/:bookId'
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        BeamPage(
          key: ValueKey('books'),
          title: 'Books',
          type: BeamPageType.noTransition,
          child: BooksScreen(),
        ),
        if (state.pathPatternSegments.last.toString() == "specialBooks")
          BeamPage(
              key: ValueKey("specialBooks"),
              child: Scaffold(
                appBar: AppBar(title: Text("Special books")),
                body: GestureDetector(
                  onTap: () {
                    context.beamToNamed("/books/specialBooks/99999");
                  },
                  child: Center(
                    child: Text("Special books!"),
                  ),
                ),
              )),
        if (state.pathParameters.containsKey('bookId'))
          BeamPage(
            key: ValueKey('book-${state.pathParameters['bookId']}'),
            title: books.firstWhere((book) =>
                book['id'] == state.pathParameters['bookId'])['title'],
            child: BookDetailsScreen(
              book: books.firstWhere(
                  (book) => book['id'] == state.pathParameters['bookId']),
            ),
          ),
        if (state.pathParameters.containsKey('specialBookId'))
          BeamPage(
            key: ValueKey(
                'specialBook-${state.pathParameters['specialBookId']}'),
            child: Scaffold(
              appBar: AppBar(),
              body: Center(
                  child:
                      Text(state.pathParameters['specialBookId'].toString())),
            ),
          ),
      ];
}

class ArticlesLocation extends BeamLocation<BeamState> {
  ArticlesLocation(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<String> get pathPatterns => ['/articles/:articleId'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        BeamPage(
          key: ValueKey('articles'),
          title: 'Articles',
          type: BeamPageType.noTransition,
          child: ArticlesScreen(),
        ),
        if (state.pathParameters.containsKey('articleId'))
          BeamPage(
            key: ValueKey('articles-${state.pathParameters['articleId']}'),
            title: articles.firstWhere((article) =>
                article['id'] == state.pathParameters['articleId'])['title'],
            child: ArticleDetailsScreen(
              article: articles.firstWhere((article) =>
                  article['id'] == state.pathParameters['articleId']),
            ),
          ),
      ];
}

// APP
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final uriString = Beamer.of(context).configuration.location!;
    currentIndex = uriString.contains('books') ? 0 : 1;
  }
}

class MyApp extends StatelessWidget {
  final routerDelegate = BeamerDelegate(
    initialPath: '/books',
    locationBuilder: RoutesLocationBuilder(
      routes: {
        '*': (context, state, data) => AppScreen(),
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerDelegate: routerDelegate,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(
        delegate: routerDelegate,
      ),
    );
  }
}

void main() => runApp(MyApp());
