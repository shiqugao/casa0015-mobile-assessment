import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'movie_details_page.dart';
import 'MyFavorite.dart';

class MovieSearch extends StatefulWidget {
  @override
  _MovieSearchState createState() => _MovieSearchState();
}

class _MovieSearchState extends State<MovieSearch> {
  List<Map<String, dynamic>> _movies = [];
  String _sortBy = 'popularity.desc'; // default sort order
  Future<void> _fetchMovies(String query) async {
    final apiKey = 'api';
    final url = query.isEmpty
        ? Uri.https('api.themoviedb.org', '/3/discover/movie', {
      'api_key': apiKey,
      'sort_by': _sortBy,
    })
        : Uri.https('api.themoviedb.org', '/3/search/movie', {
      'api_key': apiKey,
      'query': query,
    });
    final response = await http.get(url);
    final data = json.decode(response.body);
    setState(() {
      _movies = List<Map<String, dynamic>>.from(data['results']);
    });
  }

  void _showMovieDetails(BuildContext context, Map<String, dynamic> movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailsPage(movie: movie),
      ),
    );
  }

  void _sortMovies(String sortBy) {
    setState(() {
      _sortBy = sortBy;
    });
    _fetchMovies('');
  }

  Widget _buildSearchResults(BuildContext context) {
    return ListView.builder(
      itemCount: _movies.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            children: [
              Hero(
                tag: _movies[index]['id'],
                child: GestureDetector(
                  onTap: () {
                    _showMovieDetails(context, _movies[index]);
                  },
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500/${_movies[index]['poster_path']}',
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                _movies[index]['title'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchMovies('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onSubmitted: (value) => _fetchMovies(value),
          decoration: InputDecoration(
            hintText: 'Search for a movie...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _sortMovies,
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: 'popularity.desc',
                  child: Text('Popularity'),
                ),
                PopupMenuItem<String>(
                  value: 'release_date.desc',
                  child: Text('Release Date'),
                ),
                PopupMenuItem<String>(
                  value: 'vote_average.desc',
                  child: Text('Rating'),
                ),
              ];
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        focusColor: Colors.green,
        tooltip: 'My Favorite',
        autofocus: true,
        onPressed:      () async {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => MyFavorite()));
    },
        child: Icon(Icons.star_rate),
      ),
      body: _movies.isEmpty
          ? Center(
        child: Text('Start searching for movies!'),
      )
          : _buildSearchResults(context),

    );
  }
}
