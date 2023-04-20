import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieDetailsPage extends StatelessWidget {
  final Map<String, dynamic> movie;

  const MovieDetailsPage({Key? key, required this.movie}) : super(key: key);

  // void _launchTrailer(BuildContext context) async {
  //   final videoKey = movie['video_key'];
  //   if (videoKey == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Trailer not available'),
  //     ));
  //     return;
  //   }
  //   final url = 'https://www.youtube.com/watch?v=$videoKey';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text('Could not launch trailer'),
  //     ));
  //   }
  // }


  void _launchTrailer(BuildContext context) async {
    final movieId = movie['id'];
    final response = await http.get(Uri.https('api.themoviedb.org', '/3/movie/$movieId/videos', {
      'api_key': '51bfdd6d2df13c15209d2cb1e0ecf9a5',
      'language': 'en-US',
    }));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final videos = data['results'] as List<dynamic>;

      if (videos.isNotEmpty) {
        final videoKey = videos.first['key'];
        final url = 'https://www.youtube.com/watch?v=$videoKey';

        if (await canLaunch(url)) {
          await launch(url);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Could not launch trailer'),
          ));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Trailer not available'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not fetch video data'),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie['title'],
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: movie['id'],
              child: Image.network(
                'https://image.tmdb.org/t/p/w500/${movie['poster_path']}',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                movie['title'],
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Release date: ${movie['release_date']}',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Rating: ${movie['vote_average']}/10',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Overview:',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                movie['overview'],
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () => _launchTrailer(context),
                child: Text('Watch trailer'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}