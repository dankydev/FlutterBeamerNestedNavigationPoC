import 'package:beamer/beamer.dart';
import 'package:bottom_rail_navigation_multiple_beamers/data.dart';
import 'package:flutter/material.dart';

class BooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onDoubleTap: () {
              context.beamToNamed('/books/specialBooks');
            },
            child: Text('Books')),
      ),
      body: ListView(
        children: books
            .map(
              (book) => ListTile(
                title: Text(book['title']!),
                subtitle: Text(book['author']!),
                onTap: () => context.beamToNamed('/books/${book['id']}'),
              ),
            )
            .toList(),
      ),
    );
  }
}
