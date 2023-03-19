import 'package:flutter/material.dart';

class ArticleDetailsScreen extends StatelessWidget {
  const ArticleDetailsScreen({required this.article});

  final Map<String, String> article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${article["title"]}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('Author: ${article['author']}'),
      ),
    );
  }
}
