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
    final apiKey = 'API';
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
                  child: Row(
                    children: [
                      Icon(Icons.trending_up_rounded),
                      SizedBox(width: 8),
                      Text('Popularity'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'release_date.desc',
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded),
                      SizedBox(width: 8),
                      Text('Release Date'),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'vote_average.desc',
                  child: Row(
                    children: [
                      Icon(Icons.star_rounded),
                      SizedBox(width: 8),
                      Text('Rating'),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        tooltip: 'Millstone',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyFavorite()),
          );
        },
        child: Icon(Icons.star_rate),
      ),

      body: _movies.isEmpty
          ? Center(
        child: Text(
          'Start searching for movies!',
          style: TextStyle(fontSize: 24),
        ),
      )
          : GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        itemCount: _movies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _showMovieDetails(context, _movies[index]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Hero(
                    tag: _movies[index]['id'],
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500/${_movies[index]['poster_path']}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _movies[index]['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'Release date: ${_movies[index]['release_date']}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


