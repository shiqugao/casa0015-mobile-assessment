import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieSearch extends StatefulWidget {
  @override
  _MovieSearchState createState() => _MovieSearchState();
}

class _MovieSearchState extends State<MovieSearch> {
  List<dynamic> _movies = [];
  String _query = '';

  Future<void> _searchMovies(String query) async {
    String url = 'https://api.themoviedb.org/3/search/movie?query=$query&api_key=51bfdd6d2df13c15209d2cb1e0ecf9a5';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        _movies = jsonDecode(response.body)['results'];
      });
    } else {
      throw Exception('Failed to search movies');
    }
  }

  Widget _buildSearchResults() {
    if (_movies.isEmpty) {
      return Center(child: Text('No results found'));
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: _movies.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // TODO: navigate to movie details page
            },
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: Image.network('https://image.tmdb.org/t/p/w500/${_movies[index]['poster_path']}'),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _movies[index]['title'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(hintText: 'Search for movies...'),
          onChanged: (query) {
            setState(() {
              _query = query;
            });
          },
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              _searchMovies(query);
            }
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: _buildSearchResults(),
      ),
    );
  }
}

