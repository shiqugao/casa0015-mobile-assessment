import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrailerPage extends StatelessWidget {
  final String trailerUrl;

  TrailerPage({required this.trailerUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trailer'),
      ),
      body: WebView(
        initialUrl: trailerUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
