import 'package:beamer/beamer.dart';
import 'package:bottom_rail_navigation_multiple_beamers/data.dart';
import 'package:flutter/material.dart';

class ArticlesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Articles"),
      ),
      body: ListView(
        children: articles
            .map(
              (article) => ListTile(
                title: Text(article['title']!),
                subtitle: Text(article['author']!),
                onTap: () => context.beamToNamed('/articles/${article['id']}'),
              ),
            )
            .toList(),
      ),
    );
  }
}
