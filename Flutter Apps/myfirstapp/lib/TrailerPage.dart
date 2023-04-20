import 'package:flutter/material.dart';

class TrailerPage extends StatelessWidget {
  final String trailerUrl;

  const TrailerPage({Key? key, required this.trailerUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: WebView(
          initialUrl: trailerUrl,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}