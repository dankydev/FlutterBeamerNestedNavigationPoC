import 'package:beamer/beamer.dart';
import 'package:bottom_rail_navigation_multiple_beamers/books/book_details.dart';
import 'package:bottom_rail_navigation_multiple_beamers/books/books_screen.dart';
import 'package:bottom_rail_navigation_multiple_beamers/data.dart';
import 'package:flutter/material.dart';

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
          BeamPage(key: ValueKey("specialBooks"), child: SpecialBooksPage()),
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

class SpecialBooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Special books")),
      body: GestureDetector(
        onTap: () {
          context.beamToNamed("/books/specialBooks/99999");
        },
        child: Center(
          child: Text("Special books!"),
        ),
      ),
    );
  }
}
