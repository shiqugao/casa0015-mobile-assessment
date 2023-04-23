import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MovieDetailsPage extends StatelessWidget {
  final Map<String, dynamic> movie;

  const MovieDetailsPage({Key? key, required this.movie}) : super(key: key);

  void _launchTrailer(BuildContext context) async {
    final movieId = movie['id'];
    final response = await http.get(Uri.https('api.themoviedb.org', '/3/movie/$movieId/videos', {
      'api_key': 'api',
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



  void _addToFavorites(BuildContext context) async {
    try {
      print('Adding movie to favorites: $movie');
      await FirebaseFirestore.instance.collection('favorites').add(movie);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Added to favorites'),
      ));
      print('Movie added to favorites: $movie');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Could not add to favorites $e'),
      ));
      print('Error adding movie to favorites: $e');
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
            SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: () => _addToFavorites(context),
                child: Text('Add to favorites'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}