import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Movie {
  final int id;
  final String title;
  final String overview;

  Movie({required this.id, required this.title, required this.overview});

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'],
    );
  }
}

class MovieSearch extends StatefulWidget {
  @override
  _MovieSearchState createState() => _MovieSearchState();
}

class _MovieSearchState extends State<MovieSearch> {
  final _searchController = TextEditingController();
  List<Movie> _movies = [];
  bool _isLoading = false;

  Future<List<Movie>> _searchMovies(String query) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/search/movie?query=$query&api_key=51bfdd6d2df13c15209d2cb1e0ecf9a5'));

    if (response.statusCode == 200) {
      final movies = jsonDecode(response.body)['results'] as List;
      setState(() {
        _movies = movies.map((json) => Movie.fromJson(json)).toList();
        _isLoading = false;
      });
      return _movies;
    } else {
      throw Exception('Failed to search movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for a movie',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    await _searchMovies(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (_movies.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _movies.length,
                itemBuilder: (context, index) {
                  final movie = _movies[index];
                  return ListTile(
                    title: Text(movie.title),
                    subtitle: Text(movie.overview),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}